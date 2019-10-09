Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD958D1C70
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 01:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbfJIXIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 19:08:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:40462 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732412AbfJIXIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 19:08:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2019 16:08:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,277,1566889200"; 
   d="scan'208";a="205902520"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.70.56])
  by orsmga002.jf.intel.com with ESMTP; 09 Oct 2019 16:08:42 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v3 07/10] tcp: Prevent coalesce/collapse when skb has MPTCP extensions
Date:   Wed,  9 Oct 2019 16:08:06 -0700
Message-Id: <20191009230809.27387-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009230809.27387-1-mathew.j.martineau@linux.intel.com>
References: <20191009230809.27387-1-mathew.j.martineau@linux.intel.com>
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
 include/net/mptcp.h   | 16 ++++++++++++++++
 include/net/tcp.h     |  8 ++++++++
 net/ipv4/tcp_input.c  | 10 ++++++++--
 net/ipv4/tcp_output.c |  2 +-
 4 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index f9f668ac4339..43ddfdf9e4a3 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -8,6 +8,7 @@
 #ifndef __NET_MPTCP_H
 #define __NET_MPTCP_H
 
+#include <linux/skbuff.h>
 #include <linux/types.h>
 
 /* MPTCP sk_buff extension data */
@@ -24,4 +25,19 @@ struct mptcp_ext {
 			__unused:2;
 };
 
+#ifdef CONFIG_MPTCP
+
+static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
+{
+	return skb_ext_exist(skb, SKB_EXT_MPTCP);
+}
+
+#else
+
+static inline bool mptcp_skb_ext_exist(const struct sk_buff *skb)
+{
+	return false;
+}
+
+#endif /* CONFIG_MPTCP */
 #endif /* __NET_MPTCP_H */
diff --git a/include/net/tcp.h b/include/net/tcp.h
index 16c9f21243ca..414fe1749c0f 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -39,6 +39,7 @@
 #include <net/tcp_states.h>
 #include <net/inet_ecn.h>
 #include <net/dst.h>
+#include <net/mptcp.h>
 
 #include <linux/seq_file.h>
 #include <linux/memcontrol.h>
@@ -961,6 +962,13 @@ static inline bool tcp_skb_can_collapse_to(const struct sk_buff *skb)
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
index 3578357abe30..e3870479c429 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1420,7 +1420,7 @@ static struct sk_buff *tcp_shift_skb_data(struct sock *sk, struct sk_buff *skb,
 	if ((TCP_SKB_CB(prev)->sacked & TCPCB_TAGBITS) != TCPCB_SACKED_ACKED)
 		goto fallback;
 
-	if (!tcp_skb_can_collapse_to(prev))
+	if (!tcp_skb_can_collapse(prev, skb))
 		goto fallback;
 
 	in_sack = !after(start_seq, TCP_SKB_CB(skb)->seq) &&
@@ -4418,6 +4418,9 @@ static bool tcp_try_coalesce(struct sock *sk,
 	if (TCP_SKB_CB(from)->seq != TCP_SKB_CB(to)->end_seq)
 		return false;
 
+	if (mptcp_skb_ext_exist(from))
+		return false;
+
 #ifdef CONFIG_TLS_DEVICE
 	if (from->decrypted != to->decrypted)
 		return false;
@@ -4926,10 +4929,12 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 
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
@@ -4945,7 +4950,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 		/* Decided to skip this, advance start seq. */
 		start = TCP_SKB_CB(skb)->end_seq;
 	}
-	if (end_of_skbs ||
+	if (end_of_skbs || mptcp_skb_ext_exist(skb) ||
 	    (TCP_SKB_CB(skb)->tcp_flags & (TCPHDR_SYN | TCPHDR_FIN)))
 		return;
 
@@ -4988,6 +4993,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 				skb = tcp_collapse_one(sk, skb, list, root);
 				if (!skb ||
 				    skb == tail ||
+				    mptcp_skb_ext_exist(skb) ||
 				    (TCP_SKB_CB(skb)->tcp_flags & (TCPHDR_SYN | TCPHDR_FIN)))
 					goto end;
 #ifdef CONFIG_TLS_DEVICE
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index fec6d67bfd14..8469a109f0aa 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2853,7 +2853,7 @@ static void tcp_retrans_try_collapse(struct sock *sk, struct sk_buff *to,
 		if (!tcp_can_collapse(sk, skb))
 			break;
 
-		if (!tcp_skb_can_collapse_to(to))
+		if (!tcp_skb_can_collapse(to, skb))
 			break;
 
 		space -= skb->len;
-- 
2.23.0

