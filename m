Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A04462B0315
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbgKLKtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:49:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29375 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728035AbgKLKtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:49:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CwmL1kJO7nhDyz/gXv4Zp2K9RLW/2zT27fn8v0e2wY4=;
        b=Z6RtDDmN6YYcXxxvOPqluSLir4zSAQpBUI3xh56Y45WwALUBlX9oOURfND9TDQvmluHNj5
        WBhOd8raizIPfLOQEr6c78H5CvxyvXR9HYQcCX0EMaW+5qSmEmxuH+yk8BZbDNezNc8l7d
        +IoDNm4MS96oQ8YmZBTgnZT368xkdqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-gIN_AInJO9W1BSe4f4PI4w-1; Thu, 12 Nov 2020 05:49:16 -0500
X-MC-Unique: gIN_AInJO9W1BSe4f4PI4w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F63A106B823;
        Thu, 12 Nov 2020 10:49:15 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DBD7D5C3E1;
        Thu, 12 Nov 2020 10:49:13 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 12/13] mptcp: keep track of advertised windows right edge
Date:   Thu, 12 Nov 2020 11:48:10 +0100
Message-Id: <7b279af0cc528394fc22fe45682388718309bea3.1605175834.git.pabeni@redhat.com>
In-Reply-To: <cover.1605175834.git.pabeni@redhat.com>
References: <cover.1605175834.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Before sending 'x' new bytes also check that the new snd_una would
be within the permitted receive window.

For every ACK that also contains a DSS ack, check whether its tcp-level
receive window would advance the current mptcp window right edge and
update it if so.

Signed-off-by: Florian Westphal <fw@strlen.de>
Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c  | 24 ++++++++++++++++++----
 net/mptcp/protocol.c | 49 +++++++++++++++++++++++++++++++++++++++++++-
 net/mptcp/protocol.h |  1 +
 3 files changed, 69 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 1be272d2bd95..f2d1e27a2bc1 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -809,11 +809,14 @@ static u64 expand_ack(u64 old_ack, u64 cur_ack, bool use_64bit)
 	return cur_ack;
 }
 
-static void update_una(struct mptcp_sock *msk,
-		       struct mptcp_options_received *mp_opt)
+static void ack_update_msk(struct mptcp_sock *msk,
+			   const struct sock *ssk,
+			   struct mptcp_options_received *mp_opt)
 {
 	u64 new_snd_una, snd_una, old_snd_una = atomic64_read(&msk->snd_una);
+	u64 new_wnd_end, wnd_end, old_wnd_end = atomic64_read(&msk->wnd_end);
 	u64 snd_nxt = READ_ONCE(msk->snd_nxt);
+	struct sock *sk = (struct sock *)msk;
 
 	/* avoid ack expansion on update conflict, to reduce the risk of
 	 * wrongly expanding to a future ack sequence number, which is way
@@ -825,12 +828,25 @@ static void update_una(struct mptcp_sock *msk,
 	if (after64(new_snd_una, snd_nxt))
 		new_snd_una = old_snd_una;
 
+	new_wnd_end = new_snd_una + tcp_sk(ssk)->snd_wnd;
+
+	while (after64(new_wnd_end, old_wnd_end)) {
+		wnd_end = old_wnd_end;
+		old_wnd_end = atomic64_cmpxchg(&msk->wnd_end, wnd_end,
+					       new_wnd_end);
+		if (old_wnd_end == wnd_end) {
+			if (mptcp_send_head(sk))
+				mptcp_schedule_work(sk);
+			break;
+		}
+	}
+
 	while (after64(new_snd_una, old_snd_una)) {
 		snd_una = old_snd_una;
 		old_snd_una = atomic64_cmpxchg(&msk->snd_una, snd_una,
 					       new_snd_una);
 		if (old_snd_una == snd_una) {
-			mptcp_data_acked((struct sock *)msk);
+			mptcp_data_acked(sk);
 			break;
 		}
 	}
@@ -930,7 +946,7 @@ void mptcp_incoming_options(struct sock *sk, struct sk_buff *skb)
 	 * monodirectional flows will stuck
 	 */
 	if (mp_opt.use_ack)
-		update_una(msk, &mp_opt);
+		ack_update_msk(msk, sk, &mp_opt);
 
 	/* Zero-data-length packets are dropped by the caller and not
 	 * propagated to the MPTCP layer, so the skb extension does not
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 05b8112050b9..05daed57ae4a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -57,6 +57,12 @@ static struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk)
 	return msk->subflow;
 }
 
+/* Returns end sequence number of the receiver's advertised window */
+static u64 mptcp_wnd_end(const struct mptcp_sock *msk)
+{
+	return atomic64_read(&msk->wnd_end);
+}
+
 static bool mptcp_is_tcpsk(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
@@ -174,6 +180,7 @@ static void mptcp_data_queue_ofo(struct mptcp_sock *msk, struct sk_buff *skb)
 	if (after64(seq, max_seq)) {
 		/* out of window */
 		mptcp_drop(sk, skb);
+		pr_debug("oow by %ld", (unsigned long)seq - (unsigned long)max_seq);
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_NODSSWINDOW);
 		return;
 	}
@@ -842,6 +849,7 @@ static void mptcp_clean_una(struct sock *sk)
 	 */
 	if (__mptcp_check_fallback(msk))
 		atomic64_set(&msk->snd_una, msk->snd_nxt);
+
 	snd_una = atomic64_read(&msk->snd_una);
 
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list) {
@@ -939,12 +947,30 @@ struct mptcp_sendmsg_info {
 	unsigned int flags;
 };
 
+static int mptcp_check_allowed_size(struct mptcp_sock *msk, u64 data_seq,
+				    int avail_size)
+{
+	u64 window_end = mptcp_wnd_end(msk);
+
+	if (__mptcp_check_fallback(msk))
+		return avail_size;
+
+	if (!before64(data_seq + avail_size, window_end)) {
+		u64 allowed_size = window_end - data_seq;
+
+		return min_t(unsigned int, allowed_size, avail_size);
+	}
+
+	return avail_size;
+}
+
 static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			      struct mptcp_data_frag *dfrag,
 			      struct mptcp_sendmsg_info *info)
 {
 	u64 data_seq = dfrag->data_seq + info->sent;
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	bool zero_window_probe = false;
 	struct mptcp_ext *mpext = NULL;
 	struct sk_buff *skb, *tail;
 	bool can_collapse = false;
@@ -974,6 +1000,16 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 			avail_size = info->size_goal - skb->len;
 	}
 
+	/* Zero window and all data acked? Probe. */
+	avail_size = mptcp_check_allowed_size(msk, data_seq, avail_size);
+	if (avail_size == 0) {
+		if (skb || atomic64_read(&msk->snd_una) != msk->snd_nxt)
+			return 0;
+		zero_window_probe = true;
+		data_seq = atomic64_read(&msk->snd_una) - 1;
+		avail_size = 1;
+	}
+
 	if (WARN_ON_ONCE(info->sent > info->limit ||
 			 info->limit > dfrag->data_len))
 		return 0;
@@ -991,6 +1027,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	if (skb == tail) {
 		WARN_ON_ONCE(!can_collapse);
 		mpext->data_len += ret;
+		WARN_ON_ONCE(zero_window_probe);
 		goto out;
 	}
 
@@ -1008,6 +1045,12 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 		 mpext->data_seq, mpext->subflow_seq, mpext->data_len,
 		 mpext->dsn64);
 
+	if (zero_window_probe) {
+		mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
+		mpext->frozen = 1;
+		ret = 0;
+		tcp_push_pending_frames(ssk);
+	}
 out:
 	mptcp_subflow_ctx(ssk)->rel_write_seq += ret;
 	return ret;
@@ -1861,7 +1904,7 @@ static void mptcp_worker(struct work_struct *work)
 	info.limit = dfrag->already_sent;
 	while (info.sent < dfrag->already_sent) {
 		ret = mptcp_sendmsg_frag(sk, ssk, dfrag, &info);
-		if (ret < 0)
+		if (ret <= 0)
 			break;
 
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RETRANSSEGS);
@@ -2219,6 +2262,8 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk->write_seq = subflow_req->idsn + 1;
 	msk->snd_nxt = msk->write_seq;
 	atomic64_set(&msk->snd_una, msk->write_seq);
+	atomic64_set(&msk->wnd_end, msk->snd_nxt + req->rsk_rcv_wnd);
+
 	if (mp_opt->mp_capable) {
 		msk->can_ack = true;
 		msk->remote_key = mp_opt->sndr_key;
@@ -2251,6 +2296,8 @@ void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk)
 				      TCP_INIT_CWND * tp->advmss);
 	if (msk->rcvq_space.space == 0)
 		msk->rcvq_space.space = TCP_INIT_CWND * TCP_MSS_DEFAULT;
+
+	atomic64_set(&msk->wnd_end, msk->snd_nxt + tcp_sk(ssk)->snd_wnd);
 }
 
 static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8345011fc0ba..b4c8dbe9236b 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -215,6 +215,7 @@ struct mptcp_sock {
 	struct sock	*last_snd;
 	int		snd_burst;
 	atomic64_t	snd_una;
+	atomic64_t	wnd_end;
 	unsigned long	timer_ival;
 	u32		token;
 	unsigned long	flags;
-- 
2.26.2

