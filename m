Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337F0121FA9
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 01:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfLQAZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 19:25:11 -0500
Received: from mga07.intel.com ([134.134.136.100]:21148 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727705AbfLQAZA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 19:25:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 16:24:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="217599734"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2019 16:24:58 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 07/11] tcp: Prevent coalesce/collapse when skb has MPTCP extensions
Date:   Mon, 16 Dec 2019 16:24:51 -0800
Message-Id: <20191217002455.24849-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217002455.24849-1-mathew.j.martineau@linux.intel.com>
References: <20191217002455.24849-1-mathew.j.martineau@linux.intel.com>
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
index c82b2f75d024..c483c73b8d41 100644
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
+		      !mptcp_skb_ext_exist(from));
+}
+
 /* Events passed to congestion control interface */
 enum tcp_ca_event {
 	CA_EVENT_TX_START,	/* first transmit when no packets in flight */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 88b987ca9ebb..55b460a2ece2 100644
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
 
+	if (mptcp_skb_ext_exist(from))
+		return false;
+
 #ifdef CONFIG_TLS_DEVICE
 	if (from->decrypted != to->decrypted)
 		return false;
@@ -4928,10 +4931,12 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 
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
@@ -4947,7 +4952,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 		/* Decided to skip this, advance start seq. */
 		start = TCP_SKB_CB(skb)->end_seq;
 	}
-	if (end_of_skbs ||
+	if (end_of_skbs || mptcp_skb_ext_exist(skb) ||
 	    (TCP_SKB_CB(skb)->tcp_flags & (TCPHDR_SYN | TCPHDR_FIN)))
 		return;
 
@@ -4990,6 +4995,7 @@ tcp_collapse(struct sock *sk, struct sk_buff_head *list, struct rb_root *root,
 				skb = tcp_collapse_one(sk, skb, list, root);
 				if (!skb ||
 				    skb == tail ||
+				    mptcp_skb_ext_exist(skb) ||
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

