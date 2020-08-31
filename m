Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 251522576A1
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 11:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHaJhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 05:37:15 -0400
Received: from correo.us.es ([193.147.175.20]:40388 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726472AbgHaJhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 05:37:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9DB9F15AEA7
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:36:59 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8F989DA78D
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:36:59 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 84E32DA78A; Mon, 31 Aug 2020 11:36:59 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 53955DA704;
        Mon, 31 Aug 2020 11:36:57 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 31 Aug 2020 11:36:57 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 2AD0242EF4E0;
        Mon, 31 Aug 2020 11:36:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 8/8] netfilter: conntrack: do not auto-delete clash entries on reply
Date:   Mon, 31 Aug 2020 11:36:48 +0200
Message-Id: <20200831093648.20765-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200831093648.20765-1-pablo@netfilter.org>
References: <20200831093648.20765-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its possible that we have more than one packet with the same ct tuple
simultaneously, e.g. when an application emits n packets on same UDP
socket from multiple threads.

NAT rules might be applied to those packets. With the right set of rules,
n packets will be mapped to m destinations, where at least two packets end
up with the same destination.

When this happens, the existing clash resolution may merge the skb that
is processed after the first has been received with the identical tuple
already in hash table.

However, its possible that this identical tuple is a NAT_CLASH tuple.
In that case the second skb will be sent, but no reply can be received
since the reply that is processed first removes the NAT_CLASH tuple.

Do not auto-delete, this gives a 1 second window for replies to be passed
back to originator.

Packets that are coming later (udp stream case) will not be affected:
they match the original ct entry, not a NAT_CLASH one.

Also prevent NAT_CLASH entries from getting offloaded.

Fixes: 6a757c07e51f ("netfilter: conntrack: allow insertion of clashing entries")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_udp.c | 26 ++++++++++----------------
 net/netfilter/nft_flow_offload.c       |  2 +-
 2 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 760ca2422816..af402f458ee0 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -81,18 +81,6 @@ static bool udp_error(struct sk_buff *skb,
 	return false;
 }
 
-static void nf_conntrack_udp_refresh_unreplied(struct nf_conn *ct,
-					       struct sk_buff *skb,
-					       enum ip_conntrack_info ctinfo,
-					       u32 extra_jiffies)
-{
-	if (unlikely(ctinfo == IP_CT_ESTABLISHED_REPLY &&
-		     ct->status & IPS_NAT_CLASH))
-		nf_ct_kill(ct);
-	else
-		nf_ct_refresh_acct(ct, ctinfo, skb, extra_jiffies);
-}
-
 /* Returns verdict for packet, and may modify conntracktype */
 int nf_conntrack_udp_packet(struct nf_conn *ct,
 			    struct sk_buff *skb,
@@ -124,12 +112,15 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 
 		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
 
+		/* never set ASSURED for IPS_NAT_CLASH, they time out soon */
+		if (unlikely((ct->status & IPS_NAT_CLASH)))
+			return NF_ACCEPT;
+
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else {
-		nf_conntrack_udp_refresh_unreplied(ct, skb, ctinfo,
-						   timeouts[UDP_CT_UNREPLIED]);
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREPLIED]);
 	}
 	return NF_ACCEPT;
 }
@@ -206,12 +197,15 @@ int nf_conntrack_udplite_packet(struct nf_conn *ct,
 	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		nf_ct_refresh_acct(ct, ctinfo, skb,
 				   timeouts[UDP_CT_REPLIED]);
+
+		if (unlikely((ct->status & IPS_NAT_CLASH)))
+			return NF_ACCEPT;
+
 		/* Also, more likely to be important, and not a probe */
 		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else {
-		nf_conntrack_udp_refresh_unreplied(ct, skb, ctinfo,
-						   timeouts[UDP_CT_UNREPLIED]);
+		nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREPLIED]);
 	}
 	return NF_ACCEPT;
 }
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 3b9b97aa4b32..3a6c84fb2c90 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -102,7 +102,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	}
 
 	if (nf_ct_ext_exist(ct, NF_CT_EXT_HELPER) ||
-	    ct->status & IPS_SEQ_ADJUST)
+	    ct->status & (IPS_SEQ_ADJUST | IPS_NAT_CLASH))
 		goto out;
 
 	if (!nf_ct_is_confirmed(ct))
-- 
2.20.1

