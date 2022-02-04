Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0304A9BCF
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359632AbiBDPTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:19:20 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50368 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359629AbiBDPTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:19:16 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CFBBE60191;
        Fri,  4 Feb 2022 16:19:09 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 3/6] netfilter: conntrack: move synack init code to helper
Date:   Fri,  4 Feb 2022 16:19:00 +0100
Message-Id: <20220204151903.320786-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204151903.320786-1-pablo@netfilter.org>
References: <20220204151903.320786-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

It seems more readable to use a common helper in the followup fix rather
than copypaste or goto.

No functional change intended.  The function is only called for syn-ack
or syn in repy direction in case of simultaneous open.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 47 ++++++++++++++++----------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index af5115e127cf..88c89e97d8a2 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -446,6 +446,32 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 	}
 }
 
+static void tcp_init_sender(struct ip_ct_tcp_state *sender,
+			    struct ip_ct_tcp_state *receiver,
+			    const struct sk_buff *skb,
+			    unsigned int dataoff,
+			    const struct tcphdr *tcph,
+			    u32 end, u32 win)
+{
+	/* SYN-ACK in reply to a SYN
+	 * or SYN from reply direction in simultaneous open.
+	 */
+	sender->td_end =
+	sender->td_maxend = end;
+	sender->td_maxwin = (win == 0 ? 1 : win);
+
+	tcp_options(skb, dataoff, tcph, sender);
+	/* RFC 1323:
+	 * Both sides must send the Window Scale option
+	 * to enable window scaling in either direction.
+	 */
+	if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE &&
+	      receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE)) {
+		sender->td_scale = 0;
+		receiver->td_scale = 0;
+	}
+}
+
 static bool tcp_in_window(struct nf_conn *ct,
 			  enum ip_conntrack_dir dir,
 			  unsigned int index,
@@ -499,24 +525,9 @@ static bool tcp_in_window(struct nf_conn *ct,
 		 * Initialize sender data.
 		 */
 		if (tcph->syn) {
-			/*
-			 * SYN-ACK in reply to a SYN
-			 * or SYN from reply direction in simultaneous open.
-			 */
-			sender->td_end =
-			sender->td_maxend = end;
-			sender->td_maxwin = (win == 0 ? 1 : win);
-
-			tcp_options(skb, dataoff, tcph, sender);
-			/*
-			 * RFC 1323:
-			 * Both sides must send the Window Scale option
-			 * to enable window scaling in either direction.
-			 */
-			if (!(sender->flags & IP_CT_TCP_FLAG_WINDOW_SCALE
-			      && receiver->flags & IP_CT_TCP_FLAG_WINDOW_SCALE))
-				sender->td_scale =
-				receiver->td_scale = 0;
+			tcp_init_sender(sender, receiver,
+					skb, dataoff, tcph,
+					end, win);
 			if (!tcph->ack)
 				/* Simultaneous open */
 				return true;
-- 
2.30.2

