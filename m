Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8065100E5D
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 22:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727494AbfKRVuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 16:50:08 -0500
Received: from correo.us.es ([193.147.175.20]:45694 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbfKRVtc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 16:49:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CAE42EB498
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE8D0B7FFE
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 22:49:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B3F04BAACC; Mon, 18 Nov 2019 22:49:28 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DEC16DA801;
        Mon, 18 Nov 2019 22:49:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 22:49:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B0BDF42EE38F;
        Mon, 18 Nov 2019 22:49:23 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/18] netfilter: nf_tables: add nft_payload_rebuild_vlan_hdr()
Date:   Mon, 18 Nov 2019 22:49:00 +0100
Message-Id: <20191118214914.142794-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191118214914.142794-1-pablo@netfilter.org>
References: <20191118214914.142794-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wrap the code to rebuild the ethernet + vlan header into a function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_payload.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 247799801165..3db9c802ea62 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -23,6 +23,19 @@
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 
+static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
+					 struct vlan_ethhdr *veth)
+{
+	if (skb_copy_bits(skb, mac_off, veth, ETH_HLEN))
+		return false;
+
+	veth->h_vlan_proto = skb->vlan_proto;
+	veth->h_vlan_TCI = htons(skb_vlan_tag_get(skb));
+	veth->h_vlan_encapsulated_proto = skb->protocol;
+
+	return true;
+}
+
 /* add vlan header into the user buffer for if tag was removed by offloads */
 static bool
 nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
@@ -35,13 +48,9 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 	if (offset < VLAN_ETH_HLEN) {
 		u8 ethlen = len;
 
-		if (skb_copy_bits(skb, mac_off, &veth, ETH_HLEN))
+		if (!nft_payload_rebuild_vlan_hdr(skb, mac_off, &veth))
 			return false;
 
-		veth.h_vlan_proto = skb->vlan_proto;
-		veth.h_vlan_TCI = htons(skb_vlan_tag_get(skb));
-		veth.h_vlan_encapsulated_proto = skb->protocol;
-
 		if (offset + len > VLAN_ETH_HLEN)
 			ethlen -= offset + len - VLAN_ETH_HLEN;
 
-- 
2.11.0

