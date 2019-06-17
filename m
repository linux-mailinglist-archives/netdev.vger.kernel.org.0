Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663354958D
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728796AbfFQW66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:58:58 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728434AbfFQW6x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:50 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:50 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 16/33] tcp: Prevent coalesce/collapse when skb has MPTCP extensions
Date:   Mon, 17 Jun 2019 15:57:51 -0700
Message-Id: <20190617225808.665-17-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPTCP extension data needs to be preserved as it passes through the
TCP stack. Make sure that these skbs are not appended to others during
coalesce or collapse, so the data remains associated with the payload of
the given skb.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h   | 10 ++++++++++
 include/net/tcp.h     |  8 ++++++++
 net/ipv4/tcp_input.c  | 10 ++++++++--
 net/ipv4/tcp_output.c |  2 +-
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 805206359135..30cfa473e8bf 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -61,6 +61,11 @@ bool mptcp_synack_options(const struct request_sock *req, unsigned int *size,
 bool mptcp_established_options(struct sock *sk, unsigned int *size,
 			       struct mptcp_out_options *opts);
 
+static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
+{
+	return skb_ext_exist(skb, SKB_EXT_MPTCP);
+}
+
 void mptcp_write_options(__be32 *ptr, struct mptcp_out_options *opts);
 
 #else
@@ -108,5 +113,10 @@ static inline bool mptcp_established_options(struct sock *sk,
 	return false;
 }
 
+static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
+{
+	return false;
+}
+
 #endif /* CONFIG_MPTCP */
 #endif /* __NET_MPTCP_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 23995f8c11fa..af13d91f4a0f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -39,6 +39,7 @@
 #include <net/tcp_states.h>
 #include <net/inet_ecn.h>
 #include <net/dst.h>
+#include <net/mptcp.h>
 
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
@@ -949,6 +950,13 @@ static inline bool tcp_skb_can_collapse_to(const struct sk_buff *skb)
 	return likely(!TCP_SKB_CB(skb)->eor);
 }
 
+static inline bool tcp_skb_can_collapse(const struct sk_buff *to,
+					const struct sk_buff *from)
+{
+	return likely(tcp_skb_can_collapse_to(to) &&
+		      !mptcp_skb_ext_exist(from));
+}
+
 /* Events passed to congestion control interface */
 enum tcp_ca_event {
 	CA_EVENT_TX_START,	/* first transmit when no packets in flight */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 240eb75c7b84..5e634fdd8e1c 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1402,7 +1402,7 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
 	if ((TCP_SKB_CB(prev)->sacked & TCPCB_TAGBITS) != TCPCB_SACKED_ACKED)
 		goto fallback;
 
-	if (!tcp_skb_can_collapse_to(prev))
+	if (!tcp_skb_can_collapse(prev, skb))
 		goto fallback;
 
 	in_sack = !after(start_seq, TCP_SKB_CB(skb)->seq) &&
@@ -4362,6 +4362,9 @@ static bool tcp_try_coalesce(struct sock *sk,
 	if (TCP_SKB_CB(from)->seq != TCP_SKB_CB(to)->end_seq)
 		return false;
 
+	if (mptcp_skb_ext_exist(from))
+		return false;
+
 #ifdef CONFIG_TLS_DEVICE
 	if (from->decrypted != to->decrypted)
 		return false;
@@ -4869,10 +4872,12 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 
 		/* The first skb to collapse is:
 		 * - not SYN/FIN and
+		 * - does not include a MPTCP skb extension
 		 * - bloated or contains data before "start" or
 		 *   overlaps to the next one.
 		 */
 		if (!(TCP_SKB_CB(skb)->tcp_flags & (TCPHDR_SYN | TCPHDR_FIN)) &&
+		    !mptcp_skb_ext_exist(skb) &&
 		    (tcp_win_from_space(sk, skb->truesize) > skb->len ||
 		     before(TCP_SKB_CB(skb)->seq, start))) {
 			end_of_skbs = false;
@@ -4888,7 +4893,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 		/* Decided to skip this, advance start seq. */
 		start = TCP_SKB_CB(skb)->end_seq;
 	}
-	if (end_of_skbs ||
+	if (end_of_skbs || mptcp_skb_ext_exist(skb) ||
 	    (TCP_SKB_CB(skb)->tcp_flags & (TCPHDR_SYN | TCPHDR_FIN)))
 		return;
 
@@ -4931,6 +4936,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 				skb = tcp_collapse_one(sk, skb, list, root);
 				if (!skb ||
 				    skb == tail ||
+				    mptcp_skb_ext_exist(skb) ||
 				    (TCP_SKB_CB(skb)->tcp_flags & (TCPHDR_SYN | TCPHDR_FIN)))
 					goto end;
 #ifdef CONFIG_TLS_DEVICE
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a41ba69760f1..4e49b2c40820 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2882,7 +2882,7 @@ static void tcp_retrans_try_collapse(struct sock *sk, struct sk_buff *to,
 		if (!tcp_can_collapse(sk, skb))
 			break;
 
-		if (!tcp_skb_can_collapse_to(to))
+		if (!tcp_skb_can_collapse(to, skb))
 			break;
 
 		space -= skb->len;
-- 
2.22.0

