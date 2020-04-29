Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D651BEA2C
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 23:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgD2VsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 17:48:24 -0400
Received: from correo.us.es ([193.147.175.20]:60666 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbgD2VsX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 17:48:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B842412BFFB
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 23:48:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA0CEBAAB8
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 23:48:21 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9FD30BAAAF; Wed, 29 Apr 2020 23:48:21 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E7F2BAAA1;
        Wed, 29 Apr 2020 23:48:19 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 23:48:19 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 7D01A42EF9E0;
        Wed, 29 Apr 2020 23:48:19 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/2] netfilter: nat: never update the UDP checksum when it's 0
Date:   Wed, 29 Apr 2020 23:48:10 +0200
Message-Id: <20200429214811.19941-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200429214811.19941-1-pablo@netfilter.org>
References: <20200429214811.19941-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

If the UDP header of a local VXLAN endpoint is NAT-ed, and the VXLAN
device has disabled UDP checksums and enabled Tx checksum offloading,
then the skb passed to udp_manip_pkt() has hdr->check == 0 (outer
checksum disabled) and skb->ip_summed == CHECKSUM_PARTIAL (inner packet
checksum offloaded).

Because of the ->ip_summed value, udp_manip_pkt() tries to update the
outer checksum with the new address and port, leading to an invalid
checksum sent on the wire, as the original null checksum obviously
didn't take the old address and port into account.

So, we can't take ->ip_summed into account in udp_manip_pkt(), as it
might not refer to the checksum we're acting on. Instead, we can base
the decision to update the UDP checksum entirely on the value of
hdr->check, because it's null if and only if checksum is disabled:

  * A fully computed checksum can't be 0, since a 0 checksum is
    represented by the CSUM_MANGLED_0 value instead.

  * A partial checksum can't be 0, since the pseudo-header always adds
    at least one non-zero value (the UDP protocol type 0x11) and adding
    more values to the sum can't make it wrap to 0 as the carry is then
    added to the wrapped number.

  * A disabled checksum uses the special value 0.

The problem seems to be there from day one, although it was probably
not visible before UDP tunnels were implemented.

Fixes: 5b1158e909ec ("[NETFILTER]: Add NAT support for nf_conntrack")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_proto.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 3d816a1e5442..59151dc07fdc 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -68,15 +68,13 @@ static bool udp_manip_pkt(struct sk_buff *skb,
 			  enum nf_nat_manip_type maniptype)
 {
 	struct udphdr *hdr;
-	bool do_csum;
 
 	if (skb_ensure_writable(skb, hdroff + sizeof(*hdr)))
 		return false;
 
 	hdr = (struct udphdr *)(skb->data + hdroff);
-	do_csum = hdr->check || skb->ip_summed == CHECKSUM_PARTIAL;
+	__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, !!hdr->check);
 
-	__udp_manip_pkt(skb, iphdroff, hdr, tuple, maniptype, do_csum);
 	return true;
 }
 
-- 
2.20.1

