Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF1C2C628A
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgK0KKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:10:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50653 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726392AbgK0KKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:10:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606471847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=b3tSgcMH0JdKsU/0erlZvyLs30Y9sOsMMihYLiN6G5M=;
        b=TyeWq/oI18T7FqH54kDXlQW+RAUvyR7DKQdaF3s1eIHsutBKVcZMz+0Zk51/hbe2M6aFog
        p9r865PKvRMIy+eWwFoQr8bu1XpMQ+9R8rzTi37yR/j9FVB6BfK7fqjcR4UBhrkXThe4cr
        j+URgYb466TtNsdbrLDbDgxzXyMH0HE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-_ff3wXc6Mzm-_PigL7zmnA-1; Fri, 27 Nov 2020 05:10:44 -0500
X-MC-Unique: _ff3wXc6Mzm-_PigL7zmnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 500F287953B;
        Fri, 27 Nov 2020 10:10:43 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28F2E1002393;
        Fri, 27 Nov 2020 10:10:41 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 2/6] mptcp: implement wmem reservation
Date:   Fri, 27 Nov 2020 11:10:23 +0100
Message-Id: <e1726dbf86cee84d76098f42774be3abe2c367c7.1606413118.git.pabeni@redhat.com>
In-Reply-To: <cover.1606413118.git.pabeni@redhat.com>
References: <cover.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This leverages the previous commit to reserve the wmem
required for the sendmsg() operation when the msk socket
lock is first acquired.
Some heuristics are used to get a reasonable [over] estimation of
the whole memory required. If we can't forward alloc such amount
fallback to a reasonable small chunk, otherwise enter the wait
for memory path.

When sendmsg() needs more memory it looks at wmem_reserved
first and if that is exhausted, move more space from
sk_forward_alloc.

The reserved memory is not persistent and is released at the
next socket unlock via the release_cb().

Overall this will simplify the next patch.

Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 92 ++++++++++++++++++++++++++++++++++++++++----
 net/mptcp/protocol.h |  1 +
 2 files changed, 86 insertions(+), 7 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 16e9cb1c79cc..07fe484eefd1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -873,6 +873,81 @@ static bool mptcp_frag_can_collapse_to(const struct mptcp_sock *msk,
 		df->data_seq + df->data_len == msk->write_seq;
 }
 
+static int mptcp_wmem_with_overhead(int size)
+{
+	return size + ((sizeof(struct mptcp_data_frag) * size) >> PAGE_SHIFT);
+}
+
+static void __mptcp_wmem_reserve(struct sock *sk, int size)
+{
+	int amount = mptcp_wmem_with_overhead(size);
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	WARN_ON_ONCE(msk->wmem_reserved);
+	if (amount <= sk->sk_forward_alloc)
+		goto reserve;
+
+	/* under memory pressure try to reserve at most a single page
+	 * otherwise try to reserve the full estimate and fallback
+	 * to a single page before entering the error path
+	 */
+	if ((tcp_under_memory_pressure(sk) && amount > PAGE_SIZE) ||
+	    !sk_wmem_schedule(sk, amount)) {
+		if (amount <= PAGE_SIZE)
+			goto nomem;
+
+		amount = PAGE_SIZE;
+		if (!sk_wmem_schedule(sk, amount))
+			goto nomem;
+	}
+
+reserve:
+	msk->wmem_reserved = amount;
+	sk->sk_forward_alloc -= amount;
+	return;
+
+nomem:
+	/* we will wait for memory on next allocation */
+	msk->wmem_reserved = -1;
+}
+
+static void __mptcp_update_wmem(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (!msk->wmem_reserved)
+		return;
+
+	if (msk->wmem_reserved < 0)
+		msk->wmem_reserved = 0;
+	if (msk->wmem_reserved > 0) {
+		sk->sk_forward_alloc += msk->wmem_reserved;
+		msk->wmem_reserved = 0;
+	}
+}
+
+static bool mptcp_wmem_alloc(struct sock *sk, int size)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	/* check for pre-existing error condition */
+	if (msk->wmem_reserved < 0)
+		return false;
+
+	if (msk->wmem_reserved >= size)
+		goto account;
+
+	if (!sk_wmem_schedule(sk, size))
+		return false;
+
+	sk->sk_forward_alloc -= size;
+	msk->wmem_reserved += size;
+
+account:
+	msk->wmem_reserved -= size;
+	return true;
+}
+
 static void dfrag_uncharge(struct sock *sk, int len)
 {
 	sk_mem_uncharge(sk, len);
@@ -930,7 +1005,7 @@ static void mptcp_clean_una(struct sock *sk)
 	}
 
 out:
-	if (cleaned)
+	if (cleaned && tcp_under_memory_pressure(sk))
 		sk_mem_reclaim_partial(sk);
 }
 
@@ -1307,7 +1382,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
 		return -EOPNOTSUPP;
 
-	lock_sock(sk);
+	mptcp_lock_sock(sk, __mptcp_wmem_reserve(sk, len));
 
 	timeo = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
@@ -1356,11 +1431,12 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		offset = dfrag->offset + dfrag->data_len;
 		psize = pfrag->size - offset;
 		psize = min_t(size_t, psize, msg_data_left(msg));
-		if (!sk_wmem_schedule(sk, psize + frag_truesize))
+		if (!mptcp_wmem_alloc(sk, psize + frag_truesize))
 			goto wait_for_memory;
 
 		if (copy_page_from_iter(dfrag->page, offset, psize,
 					&msg->msg_iter) != psize) {
+			msk->wmem_reserved += psize + frag_truesize;
 			ret = -EFAULT;
 			goto out;
 		}
@@ -1376,7 +1452,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		 * Note: we charge such data both to sk and ssk
 		 */
 		sk_wmem_queued_add(sk, frag_truesize);
-		sk->sk_forward_alloc -= frag_truesize;
 		if (!dfrag_collapsed) {
 			get_page(dfrag->page);
 			list_add_tail(&dfrag->list, &msk->rtx_queue);
@@ -2003,6 +2078,7 @@ static int __mptcp_init_sock(struct sock *sk)
 	INIT_WORK(&msk->work, mptcp_worker);
 	msk->out_of_order_queue = RB_ROOT;
 	msk->first_pending = NULL;
+	msk->wmem_reserved = 0;
 
 	msk->ack_hint = NULL;
 	msk->first = NULL;
@@ -2197,6 +2273,7 @@ static void __mptcp_destroy_sock(struct sock *sk)
 
 	sk->sk_prot->destroy(sk);
 
+	WARN_ON_ONCE(msk->wmem_reserved);
 	sk_stream_kill_queues(sk);
 	xfrm_sk_free_policy(sk);
 	sk_refcnt_debug_release(sk);
@@ -2542,13 +2619,14 @@ static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 
 #define MPTCP_DEFERRED_ALL (TCPF_WRITE_TIMER_DEFERRED)
 
-/* this is very alike tcp_release_cb() but we must handle differently a
- * different set of events
- */
+/* processes deferred events and flush wmem */
 static void mptcp_release_cb(struct sock *sk)
 {
 	unsigned long flags, nflags;
 
+	/* clear any wmem reservation and errors */
+	__mptcp_update_wmem(sk);
+
 	do {
 		flags = sk->sk_tsq_flags;
 		if (!(flags & MPTCP_DEFERRED_ALL))
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6abac8238de3..4cf355076e35 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -218,6 +218,7 @@ struct mptcp_sock {
 	u64		ack_seq;
 	u64		rcv_wnd_sent;
 	u64		rcv_data_fin_seq;
+	int		wmem_reserved;
 	struct sock	*last_snd;
 	int		snd_burst;
 	int		old_wspace;
-- 
2.26.2

