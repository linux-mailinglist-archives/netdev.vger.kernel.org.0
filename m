Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 378F113F9EA
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731361AbgAPTvB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:51:01 -0500
Received: from correo.us.es ([193.147.175.20]:56070 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731041AbgAPTu5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 14:50:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5534807EC
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D5A29DA71A
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 20:50:55 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CB088DA715; Thu, 16 Jan 2020 20:50:55 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4238DA70F;
        Thu, 16 Jan 2020 20:50:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 16 Jan 2020 20:50:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A4C3742EF9E1;
        Thu, 16 Jan 2020 20:50:53 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 9/9] netfilter: nat: fix ICMP header corruption on ICMP errors
Date:   Thu, 16 Jan 2020 20:50:44 +0100
Message-Id: <20200116195044.326614-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200116195044.326614-1-pablo@netfilter.org>
References: <20200116195044.326614-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

Commit 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
made nf_nat_icmp_reply_translation() use icmp_manip_pkt() as the l4
manipulation function for the outer packet on ICMP errors.

However, icmp_manip_pkt() assumes the packet has an 'id' field which
is not correct for all types of ICMP messages.

This is not correct for ICMP error packets, and leads to bogus bytes
being written the ICMP header, which can be wrongfully regarded as
'length' bytes by RFC 4884 compliant receivers.

Fix by assigning the 'id' field only for ICMP messages that have this
semantic.

Reported-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Fixes: 8303b7e8f018 ("netfilter: nat: fix spurious connection timeouts")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_nat_proto.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/netfilter/nf_nat_proto.c b/net/netfilter/nf_nat_proto.c
index 0a59c14b5177..64eedc17037a 100644
--- a/net/netfilter/nf_nat_proto.c
+++ b/net/netfilter/nf_nat_proto.c
@@ -233,6 +233,19 @@ icmp_manip_pkt(struct sk_buff *skb,
 		return false;
 
 	hdr = (struct icmphdr *)(skb->data + hdroff);
+	switch (hdr->type) {
+	case ICMP_ECHO:
+	case ICMP_ECHOREPLY:
+	case ICMP_TIMESTAMP:
+	case ICMP_TIMESTAMPREPLY:
+	case ICMP_INFO_REQUEST:
+	case ICMP_INFO_REPLY:
+	case ICMP_ADDRESS:
+	case ICMP_ADDRESSREPLY:
+		break;
+	default:
+		return true;
+	}
 	inet_proto_csum_replace2(&hdr->checksum, skb,
 				 hdr->un.echo.id, tuple->src.u.icmp.id, false);
 	hdr->un.echo.id = tuple->src.u.icmp.id;
-- 
2.11.0

