Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2008B2C628D
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgK0KK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:10:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33845 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726985AbgK0KKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606471853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WiuiCsXrFMizWnkEeuYxhnYHCxJnvl/hVk8+fpZ4/S0=;
        b=HnspMMacSZ5rPgtgX88m/RIgWRrz4VhsBlcNCGXx45rP1EWzkT09mlJbYjWmpLJkxQiKZB
        ZjxkErQZ4klrygXSrLsBvlELELekmXefA9by79tfN8UhSn4f4f1vOw6KyyGwu3/G0hs4cT
        H9//CAhJYlTj7pV9NvUkm0GEjSELB8U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-OeEWRdzRNlu4fTkiHl-yVg-1; Fri, 27 Nov 2020 05:10:49 -0500
X-MC-Unique: OeEWRdzRNlu4fTkiHl-yVg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D4F441007476;
        Fri, 27 Nov 2020 10:10:47 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADA9F10021B3;
        Fri, 27 Nov 2020 10:10:46 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 5/6] mptcp: avoid a few atomic ops in the rx path
Date:   Fri, 27 Nov 2020 11:10:26 +0100
Message-Id: <46e049b7bf734ed50f5b3c3762ee0278a682c66e.1606413118.git.pabeni@redhat.com>
In-Reply-To: <cover.1606413118.git.pabeni@redhat.com>
References: <cover.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extending the data_lock scope in mptcp_incoming_option
we can use that to protect both snd_una and wnd_end.
In the typical case, we will have a single atomic op instead of 2

Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/mptcp_diag.c |  2 +-
 net/mptcp/options.c    | 33 +++++++++++++--------------------
 net/mptcp/protocol.c   | 34 ++++++++++++++++------------------
 net/mptcp/protocol.h   |  8 ++++----
 4 files changed, 34 insertions(+), 43 deletions(-)

diff --git a/net/mptcp/mptcp_diag.c b/net/mptcp/mptcp_diag.c
index 5f390a97f556..b70ae4ba3000 100644
--- a/net/mptcp/mptcp_diag.c
+++ b/net/mptcp/mptcp_diag.c
@@ -140,7 +140,7 @@ static void mptcp_diag_get_info(struct sock *sk, struct inet_diag_msg *r,
 	info->mptcpi_flags = flags;
 	info->mptcpi_token = READ_ONCE(msk->token);
 	info->mptcpi_write_seq = READ_ONCE(msk->write_seq);
-	info->mptcpi_snd_una = atomic64_read(&msk->snd_una);
+	info->mptcpi_snd_una = READ_ONCE(msk->snd_una);
 	info->mptcpi_rcv_nxt = READ_ONCE(msk->ack_seq);
 	unlock_sock_fast(sk, slow);
 }
diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 8a59b3e44599..3986454a0340 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -833,15 +833,17 @@ static void ack_update_msk(struct mptcp_sock *msk,
 			   const struct sock *ssk,
 			   struct mptcp_options_received *mp_opt)
 {
-	u64 new_snd_una, snd_una, old_snd_una = atomic64_read(&msk->snd_una);
-	u64 new_wnd_end, wnd_end, old_wnd_end = atomic64_read(&msk->wnd_end);
-	u64 snd_nxt = READ_ONCE(msk->snd_nxt);
+	u64 new_wnd_end, new_snd_una, snd_nxt = READ_ONCE(msk->snd_nxt);
 	struct sock *sk = (struct sock *)msk;
+	u64 old_snd_una;
+
+	mptcp_data_lock(sk);
 
 	/* avoid ack expansion on update conflict, to reduce the risk of
 	 * wrongly expanding to a future ack sequence number, which is way
 	 * more dangerous than missing an ack
 	 */
+	old_snd_una = msk->snd_una;
 	new_snd_una = expand_ack(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
 
 	/* ACK for data not even sent yet? Ignore. */
@@ -850,26 +852,17 @@ static void ack_update_msk(struct mptcp_sock *msk,
 
 	new_wnd_end = new_snd_una + tcp_sk(ssk)->snd_wnd;
 
-	while (after64(new_wnd_end, old_wnd_end)) {
-		wnd_end = old_wnd_end;
-		old_wnd_end = atomic64_cmpxchg(&msk->wnd_end, wnd_end,
-					       new_wnd_end);
-		if (old_wnd_end == wnd_end) {
-			if (mptcp_send_head(sk))
-				mptcp_schedule_work(sk);
-			break;
-		}
+	if (after64(new_wnd_end, msk->wnd_end)) {
+		msk->wnd_end = new_wnd_end;
+		if (mptcp_send_head(sk))
+			mptcp_schedule_work(sk);
 	}
 
-	while (after64(new_snd_una, old_snd_una)) {
-		snd_una = old_snd_una;
-		old_snd_una = atomic64_cmpxchg(&msk->snd_una, snd_una,
-					       new_snd_una);
-		if (old_snd_una == snd_una) {
-			mptcp_data_acked(sk);
-			break;
-		}
+	if (after64(new_snd_una, old_snd_una)) {
+		msk->snd_una = new_snd_una;
+		__mptcp_data_acked(sk);
 	}
+	mptcp_data_unlock(sk);
 }
 
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 75b4c4c50dbb..51f92f3096bf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -60,7 +60,7 @@ static struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk)
 /* Returns end sequence number of the receiver's advertised window */
 static u64 mptcp_wnd_end(const struct mptcp_sock *msk)
 {
-	return atomic64_read(&msk->wnd_end);
+	return READ_ONCE(msk->wnd_end);
 }
 
 static bool mptcp_is_tcpsk(struct sock *sk)
@@ -358,7 +358,7 @@ static void mptcp_check_data_fin_ack(struct sock *sk)
 	/* Look for an acknowledged DATA_FIN */
 	if (((1 << sk->sk_state) &
 	     (TCPF_FIN_WAIT1 | TCPF_CLOSING | TCPF_LAST_ACK)) &&
-	    msk->write_seq == atomic64_read(&msk->snd_una)) {
+	    msk->write_seq == READ_ONCE(msk->snd_una)) {
 		mptcp_stop_timer(sk);
 
 		WRITE_ONCE(msk->snd_data_fin_enable, 0);
@@ -764,7 +764,7 @@ bool mptcp_schedule_work(struct sock *sk)
 	return false;
 }
 
-void mptcp_data_acked(struct sock *sk)
+void __mptcp_data_acked(struct sock *sk)
 {
 	mptcp_reset_timer(sk);
 
@@ -997,11 +997,11 @@ static void mptcp_clean_una(struct sock *sk)
 	 * plain TCP
 	 */
 	if (__mptcp_check_fallback(msk))
-		atomic64_set(&msk->snd_una, msk->snd_nxt);
+		msk->snd_una = READ_ONCE(msk->snd_nxt);
 
-	mptcp_data_lock(sk);
-	snd_una = atomic64_read(&msk->snd_una);
 
+	mptcp_data_lock(sk);
+	snd_una = msk->snd_una;
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list) {
 		if (after64(dfrag->data_seq + dfrag->data_len, snd_una))
 			break;
@@ -1282,10 +1282,12 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	/* Zero window and all data acked? Probe. */
 	avail_size = mptcp_check_allowed_size(msk, data_seq, avail_size);
 	if (avail_size == 0) {
-		if (skb || atomic64_read(&msk->snd_una) != msk->snd_nxt)
+		u64 snd_una = READ_ONCE(msk->snd_una);
+
+		if (skb || snd_una != msk->snd_nxt)
 			return 0;
 		zero_window_probe = true;
-		data_seq = atomic64_read(&msk->snd_una) - 1;
+		data_seq = snd_una - 1;
 		avail_size = 1;
 	}
 
@@ -1994,12 +1996,8 @@ static void mptcp_retransmit_handler(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (atomic64_read(&msk->snd_una) == READ_ONCE(msk->snd_nxt)) {
-		mptcp_stop_timer(sk);
-	} else {
-		set_bit(MPTCP_WORK_RTX, &msk->flags);
-		mptcp_schedule_work(sk);
-	}
+	set_bit(MPTCP_WORK_RTX, &msk->flags);
+	mptcp_schedule_work(sk);
 }
 
 static void mptcp_retransmit_timer(struct timer_list *t)
@@ -2621,8 +2619,8 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 
 	msk->write_seq = subflow_req->idsn + 1;
 	msk->snd_nxt = msk->write_seq;
-	atomic64_set(&msk->snd_una, msk->write_seq);
-	atomic64_set(&msk->wnd_end, msk->snd_nxt + req->rsk_rcv_wnd);
+	msk->snd_una = msk->write_seq;
+	msk->wnd_end = msk->snd_nxt + req->rsk_rcv_wnd;
 
 	if (mp_opt->mp_capable) {
 		msk->can_ack = true;
@@ -2658,7 +2656,7 @@ void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk)
 	if (msk->rcvq_space.space == 0)
 		msk->rcvq_space.space = TCP_INIT_CWND * TCP_MSS_DEFAULT;
 
-	atomic64_set(&msk->wnd_end, msk->snd_nxt + tcp_sk(ssk)->snd_wnd);
+	WRITE_ONCE(msk->wnd_end, msk->snd_nxt + tcp_sk(ssk)->snd_wnd);
 }
 
 static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
@@ -2918,7 +2916,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	WRITE_ONCE(msk->ack_seq, ack_seq);
 	WRITE_ONCE(msk->rcv_wnd_sent, ack_seq);
 	WRITE_ONCE(msk->can_ack, 1);
-	atomic64_set(&msk->snd_una, msk->write_seq);
+	WRITE_ONCE(msk->snd_una, msk->write_seq);
 
 	mptcp_pm_new_connection(msk, 0);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 97c1e5dcb3e2..3c07aafde10e 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -222,8 +222,8 @@ struct mptcp_sock {
 	struct sock	*last_snd;
 	int		snd_burst;
 	int		old_wspace;
-	atomic64_t	snd_una;
-	atomic64_t	wnd_end;
+	u64		snd_una;
+	u64		wnd_end;
 	unsigned long	timer_ival;
 	u32		token;
 	int		rmem_pending;
@@ -321,7 +321,7 @@ static inline struct mptcp_data_frag *mptcp_rtx_tail(const struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (!before64(msk->snd_nxt, atomic64_read(&msk->snd_una)))
+	if (!before64(msk->snd_nxt, READ_ONCE(msk->snd_una)))
 		return NULL;
 
 	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
@@ -495,7 +495,7 @@ void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
 bool mptcp_schedule_work(struct sock *sk);
-void mptcp_data_acked(struct sock *sk);
+void __mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
 void __mptcp_flush_join_list(struct mptcp_sock *msk);
-- 
2.26.2

