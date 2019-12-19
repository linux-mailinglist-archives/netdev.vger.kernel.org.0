Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6031270C8
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 23:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbfLSWfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 17:35:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:29335 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727184AbfLSWfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 17:35:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2019 14:34:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,333,1571727600"; 
   d="scan'208";a="248484465"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.1.107])
  by fmsmga002.fm.intel.com with ESMTP; 19 Dec 2019 14:34:59 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next v5 07/11] tcp: coalesce/collapse must respect MPTCP extensions
Date:   Thu, 19 Dec 2019 14:34:30 -0800
Message-Id: <20191219223434.19722-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
References: <20191219223434.19722-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coalesce and collapse of packets carrying MPTCP extensions is allowed
when the newer packet has no extension or the extensions carried by both
packets are equal.

This allows merging of TSO packet trains and even cross-TSO packets, and
does not require any additional action when moving data into existing
SKBs.

v3 -> v4:
 - allow collapsing, under mptcp_skb_can_collapse() constraint

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h   | 54 +++++++++++++++++++++++++++++++++++++++++++
 include/net/tcp.h     |  8 +++++++
 net/ipv4/tcp_input.c  | 11 ++++++---
 net/ipv4/tcp_output.c |  2 +-
 4 files changed, 71 insertions(+), 4 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index f9f668ac4339..8e27e33861ab 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -8,6 +8,7 @@
 #ifndef __NET_MPTCP_H
 #define __NET_MPTCP_H
 
+#include <linux/skbuff.h>
 #include <linux/types.h>
 
 /* MPTCP sk_buff extension data */
@@ -24,4 +25,57 @@ struct mptcp_ext {
 			__unused:2;
 };
 
+#ifdef CONFIG_MPTCP
+
+/* move the skb extension owership, with the assumption that 'to' is
+ * newly allocated
+ */
+static inline void mptcp_skb_ext_move(struct sk_buff *to,
+				      struct sk_buff *from)
+{
+	if (!skb_ext_exist(from, SKB_EXT_MPTCP))
+		return;
+
+	if (WARN_ON_ONCE(to->active_extensions))
+		skb_ext_put(to);
+
+	to->active_extensions = from->active_extensions;
+	to->extensions = from->extensions;
+	from->active_extensions = 0;
+}
+
+static inline bool mptcp_ext_matches(const struct mptcp_ext *to_ext,
+				     const struct mptcp_ext *from_ext)
+{
+	return !from_ext ||
+	       (to_ext && from_ext &&
+	        !memcmp(from_ext, to_ext, sizeof(struct mptcp_ext)));
+}
+
+/* check if skbs can be collapsed.
+ * MPTCP collapse is allowed if neither @to or @from carry an mptcp data
+ * mapping, or if the extension of @to is the same as @from.
+ * Collapsing is not possible if @to lacks an extension, but @from carries one.
+ */
+static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
+					  const struct sk_buff *from)
+{
+	return mptcp_ext_matches(skb_ext_find(to, SKB_EXT_MPTCP),
+				 skb_ext_find(from, SKB_EXT_MPTCP));
+}
+
+#else
+
+static inline void mptcp_skb_ext_move(struct sk_buff *to,
+				      const struct sk_buff *from)
+{
+}
+
+static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
+					  const struct sk_buff *from)
+{
+	return true;
+}
+
+#endif /* CONFIG_MPTCP */
 #endif /* __NET_MPTCP_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index c82b2f75d024..f4cddd42d52a 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -39,6 +39,7 @@
 #include <net/tcp_states.h>
 #include <net/inet_ecn.h>
 #include <net/dst.h>
+#include <net/mptcp.h>
 
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
@@ -978,6 +979,13 @@ static inline bool tcp_skb_can_collapse_to(const struct sk_buff *skb)
 	return likely(!TCP_SKB_CB(skb)->eor);
 }
 
+static inline bool tcp_skb_can_collapse(const struct sk_buff *to,
+					const struct sk_buff *from)
+{
+	return likely(tcp_skb_can_collapse_to(to) &&
+		      mptcp_skb_can_collapse(to, from));
+}
+
 /* Events passed to congestion control interface */
 enum tcp_ca_event {
 	CA_EVENT_TX_START,	/* first transmit when no packets in flight */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 88b987ca9ebb..a16d9f2a0529 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1422,7 +1422,7 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
 	if ((TCP_SKB_CB(prev)->sacked & TCPCB_TAGBITS) != TCPCB_SACKED_ACKED)
 		goto fallback;
 
-	if (!tcp_skb_can_collapse_to(prev))
+	if (!tcp_skb_can_collapse(prev, skb))
 		goto fallback;
 
 	in_sack = !after(start_seq, TCP_SKB_CB(skb)->seq) &&
@@ -4420,6 +4420,9 @@ static bool tcp_try_coalesce(struct sock *sk,
 	if (TCP_SKB_CB(from)->seq != TCP_SKB_CB(to)->end_seq)
 		return false;
 
+	if (!mptcp_skb_can_collapse(to, from))
+		return false;
+
 #ifdef CONFIG_TLS_DEVICE
 	if (from->decrypted != to->decrypted)
 		return false;
@@ -4929,7 +4932,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 		/* The first skb to collapse is:
 		 * - not SYN/FIN and
 		 * - bloated or contains data before "start" or
-		 *   overlaps to the next one.
+		 *   overlaps to the next one and mptcp allow collapsing.
 		 */
 		if (!(TCP_SKB_CB(skb)->tcp_flags & (TCPHDR_SYN | TCPHDR_FIN)) &&
 		    (tcp_win_from_space(sk, skb->truesize) > skb->len ||
@@ -4938,7 +4941,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 			break;
 		}
 
-		if (n && n != tail &&
+		if (n && n != tail && mptcp_skb_can_collapse(skb, n) &&
 		    TCP_SKB_CB(skb)->end_seq != TCP_SKB_CB(n)->seq) {
 			end_of_skbs = false;
 			break;
@@ -4971,6 +4974,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 		else
 			__skb_queue_tail(&tmp, nskb); /* defer rbtree insertion */
 		skb_set_owner_r(nskb, sk);
+		mptcp_skb_ext_move(nskb, skb);
 
 		/* Copy data, releasing collapsed skbs. */
 		while (copy > 0) {
@@ -4990,6 +4994,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 				skb = tcp_collapse_one(sk, skb, list, root);
 				if (!skb ||
 				    skb == tail ||
+				    !mptcp_skb_can_collapse(nskb, skb) ||
 				    (TCP_SKB_CB(skb)->tcp_flags & (TCPHDR_SYN | TCPHDR_FIN)))
 					goto end;
 #ifdef CONFIG_TLS_DEVICE
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b184f03d7437..9e04d45bc0e4 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2854,7 +2854,7 @@ static void tcp_retrans_try_collapse(struct sock *sk, struct sk_buff *to,
 		if (!tcp_can_collapse(sk, skb))
 			break;
 
-		if (!tcp_skb_can_collapse_to(to))
+		if (!tcp_skb_can_collapse(to, skb))
 			break;
 
 		space -= skb->len;
-- 
2.24.1

