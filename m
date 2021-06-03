Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09B939AE9A
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 01:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbhFCX0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 19:26:35 -0400
Received: from mga05.intel.com ([192.55.52.43]:8112 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhFCX03 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 19:26:29 -0400
IronPort-SDR: kMRTsgBoTYJ5/LWDIVuHNAsSeXGXHg1xrG02CFAPxptJvwJzzQMAH/WlY0NXxQhuSlhdbESAaQ
 qr/UwNsTum/Q==
X-IronPort-AV: E=McAfee;i="6200,9189,10004"; a="289807808"
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="289807808"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:44 -0700
IronPort-SDR: gD81MXf0qcMIMCnjWtDnn5Ku/7ImY2xv91xb3NE/HBodiNgd8QE2Z84GSviYzYsllwJtHF/HGA
 rNjdMVbXPr8Q==
X-IronPort-AV: E=Sophos;i="5.83,246,1616482800"; 
   d="scan'208";a="483669046"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.3.143])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2021 16:24:43 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 6/7] mptcp: receive path cmsg support
Date:   Thu,  3 Jun 2021 16:24:32 -0700
Message-Id: <20210603232433.260703-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
References: <20210603232433.260703-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This adds support for SO_TIMESTAMP(NS).  Timestamps are passed to
userspace in the same way as for plain tcp sockets.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2bc199549a88..3897d35fd9df 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -39,10 +39,15 @@ struct mptcp_skb_cb {
 	u64 map_seq;
 	u64 end_seq;
 	u32 offset;
+	u8  has_rxtstamp:1;
 };
 
 #define MPTCP_SKB_CB(__skb)	((struct mptcp_skb_cb *)&((__skb)->cb[0]))
 
+enum {
+	MPTCP_CMSG_TS = BIT(0),
+};
+
 static struct percpu_counter mptcp_sockets_allocated;
 
 static void __mptcp_destroy_sock(struct sock *sk);
@@ -272,6 +277,7 @@ static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
 	struct sock *sk = (struct sock *)msk;
 	struct sk_buff *tail;
+	bool has_rxtstamp;
 
 	__skb_unlink(skb, &ssk->sk_receive_queue);
 
@@ -287,6 +293,8 @@ static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 			goto drop;
 	}
 
+	has_rxtstamp = TCP_SKB_CB(skb)->has_rxtstamp;
+
 	/* the skb map_seq accounts for the skb offset:
 	 * mptcp_subflow_get_mapped_dsn() is based on the current tp->copied_seq
 	 * value
@@ -294,6 +302,7 @@ static bool __mptcp_move_skb(struct mptcp_sock *msk, struct sock *ssk,
 	MPTCP_SKB_CB(skb)->map_seq = mptcp_subflow_get_mapped_dsn(subflow);
 	MPTCP_SKB_CB(skb)->end_seq = MPTCP_SKB_CB(skb)->map_seq + copy_len;
 	MPTCP_SKB_CB(skb)->offset = offset;
+	MPTCP_SKB_CB(skb)->has_rxtstamp = has_rxtstamp;
 
 	if (MPTCP_SKB_CB(skb)->map_seq == msk->ack_seq) {
 		/* in sequence */
@@ -1757,7 +1766,9 @@ static void mptcp_wait_data(struct sock *sk, long *timeo)
 
 static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 				struct msghdr *msg,
-				size_t len, int flags)
+				size_t len, int flags,
+				struct scm_timestamping_internal *tss,
+				int *cmsg_flags)
 {
 	struct sk_buff *skb, *tmp;
 	int copied = 0;
@@ -1777,6 +1788,11 @@ static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 			}
 		}
 
+		if (MPTCP_SKB_CB(skb)->has_rxtstamp) {
+			tcp_update_recv_tstamps(skb, tss);
+			*cmsg_flags |= MPTCP_CMSG_TS;
+		}
+
 		copied += count;
 
 		if (count < data_len) {
@@ -1964,7 +1980,8 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	int copied = 0;
+	struct scm_timestamping_internal tss;
+	int copied = 0, cmsg_flags = 0;
 	int target;
 	long timeo;
 
@@ -1986,7 +2003,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	while (copied < len) {
 		int bytes_read;
 
-		bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied, flags);
+		bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied, flags, &tss, &cmsg_flags);
 		if (unlikely(bytes_read < 0)) {
 			if (!copied)
 				copied = bytes_read;
@@ -2067,6 +2084,11 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		set_bit(MPTCP_DATA_READY, &msk->flags);
 	}
 out_err:
+	if (cmsg_flags && copied >= 0) {
+		if (cmsg_flags & MPTCP_CMSG_TS)
+			tcp_recv_timestamp(msg, sk, &tss);
+	}
+
 	pr_debug("msk=%p data_ready=%d rx queue empty=%d copied=%d",
 		 msk, test_bit(MPTCP_DATA_READY, &msk->flags),
 		 skb_queue_empty_lockless(&sk->sk_receive_queue), copied);
-- 
2.31.1

