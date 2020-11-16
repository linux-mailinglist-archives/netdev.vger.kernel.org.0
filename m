Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 774922B4038
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgKPJsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:48:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25144 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728682AbgKPJso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605520123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zEqwmIjIC7q6ndlE4WWFaemA09Usj7sSy6qneDS+qlM=;
        b=VwpL+sj6cU0u5SJnYei05fQdNQ0GkhbPIa8pnUg9erGDbt2hJLu8vIn22LL0WvILGG8A9a
        2QlCD7YEMthPlnSK2Zu4hxuvGcKNX8JGF5d71mozRnT5fdi2cZLkK3+wuOBMMmCYduLBjv
        u3VbaxUDmwa6VEJsY0d0r+Rnm1dNwmk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-IwfplFoiPeq8Uq5s2wQbjw-1; Mon, 16 Nov 2020 04:48:40 -0500
X-MC-Unique: IwfplFoiPeq8Uq5s2wQbjw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD6E6809DD3;
        Mon, 16 Nov 2020 09:48:39 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-64.ams2.redhat.com [10.36.114.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8E6731002C1B;
        Mon, 16 Nov 2020 09:48:38 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 07/13] mptcp: introduce MPTCP snd_nxt
Date:   Mon, 16 Nov 2020 10:48:08 +0100
Message-Id: <fbe968b8b9199c949fcbf50940daa047411fce3d.1605458224.git.pabeni@redhat.com>
In-Reply-To: <cover.1605458224.git.pabeni@redhat.com>
References: <cover.1605458224.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Track the next MPTCP sequence number used on xmit,
currently always equal to write_next.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c  |  4 ++--
 net/mptcp/protocol.c |  7 +++++--
 net/mptcp/protocol.h | 17 +++++++++--------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index a044dd43411d..a6b57021b6d0 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -813,7 +813,7 @@ static void update_una(struct mptcp_sock *msk,
 		       struct mptcp_options_received *mp_opt)
 {
 	u64 new_snd_una, snd_una, old_snd_una = atomic64_read(&msk->snd_una);
-	u64 write_seq = READ_ONCE(msk->write_seq);
+	u64 snd_nxt = READ_ONCE(msk->snd_nxt);
 
 	/* avoid ack expansion on update conflict, to reduce the risk of
 	 * wrongly expanding to a future ack sequence number, which is way
@@ -822,7 +822,7 @@ static void update_una(struct mptcp_sock *msk,
 	new_snd_una = expand_ack(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
 
 	/* ACK for data not even sent yet? Ignore. */
-	if (after64(new_snd_una, write_seq))
+	if (after64(new_snd_una, snd_nxt))
 		new_snd_una = old_snd_una;
 
 	while (after64(new_snd_una, old_snd_una)) {
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 40c4227ae9fe..2b0fd08b03f9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -834,7 +834,7 @@ static void mptcp_clean_una(struct sock *sk)
 	 * plain TCP
 	 */
 	if (__mptcp_check_fallback(msk))
-		atomic64_set(&msk->snd_una, msk->write_seq);
+		atomic64_set(&msk->snd_una, msk->snd_nxt);
 	snd_una = atomic64_read(&msk->snd_una);
 
 	list_for_each_entry_safe(dfrag, dtmp, &msk->rtx_queue, list) {
@@ -1338,6 +1338,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 	release_sock(ssk);
 out:
+	msk->snd_nxt = msk->write_seq;
 	ssk_check_wmem(msk);
 	release_sock(sk);
 	return copied ? : ret;
@@ -1629,7 +1630,7 @@ static void mptcp_retransmit_handler(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (atomic64_read(&msk->snd_una) == READ_ONCE(msk->write_seq)) {
+	if (atomic64_read(&msk->snd_una) == READ_ONCE(msk->snd_nxt)) {
 		mptcp_stop_timer(sk);
 	} else {
 		set_bit(MPTCP_WORK_RTX, &msk->flags);
@@ -2100,6 +2101,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	WRITE_ONCE(msk->fully_established, false);
 
 	msk->write_seq = subflow_req->idsn + 1;
+	msk->snd_nxt = msk->write_seq;
 	atomic64_set(&msk->snd_una, msk->write_seq);
 	if (mp_opt->mp_capable) {
 		msk->can_ack = true;
@@ -2409,6 +2411,7 @@ void mptcp_finish_connect(struct sock *ssk)
 	WRITE_ONCE(msk->remote_key, subflow->remote_key);
 	WRITE_ONCE(msk->local_key, subflow->local_key);
 	WRITE_ONCE(msk->write_seq, subflow->idsn + 1);
+	WRITE_ONCE(msk->snd_nxt, msk->write_seq);
 	WRITE_ONCE(msk->ack_seq, ack_seq);
 	WRITE_ONCE(msk->can_ack, 1);
 	atomic64_set(&msk->snd_una, msk->write_seq);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index ec17f9c367c5..946319cf9cca 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -92,6 +92,13 @@
 #define MPTCP_FALLBACK_DONE	4
 #define MPTCP_WORK_CLOSE_SUBFLOW 5
 
+static inline bool before64(__u64 seq1, __u64 seq2)
+{
+	return (__s64)(seq1 - seq2) < 0;
+}
+
+#define after64(seq2, seq1)	before64(seq1, seq2)
+
 struct mptcp_options_received {
 	u64	sndr_key;
 	u64	rcvr_key;
@@ -201,6 +208,7 @@ struct mptcp_sock {
 	u64		local_key;
 	u64		remote_key;
 	u64		write_seq;
+	u64		snd_nxt;
 	u64		ack_seq;
 	u64		rcv_data_fin_seq;
 	struct sock	*last_snd;
@@ -276,7 +284,7 @@ static inline struct mptcp_data_frag *mptcp_rtx_tail(const struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	if (list_empty(&msk->rtx_queue))
+	if (!before64(msk->snd_nxt, atomic64_read(&msk->snd_una)))
 		return NULL;
 
 	return list_last_entry(&msk->rtx_queue, struct mptcp_data_frag, list);
@@ -528,13 +536,6 @@ static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
 	return (struct mptcp_ext *)skb_ext_find(skb, SKB_EXT_MPTCP);
 }
 
-static inline bool before64(__u64 seq1, __u64 seq2)
-{
-	return (__s64)(seq1 - seq2) < 0;
-}
-
-#define after64(seq2, seq1)	before64(seq1, seq2)
-
 void mptcp_diag_subflow_init(struct tcp_ulp_ops *ops);
 
 static inline bool __mptcp_check_fallback(const struct mptcp_sock *msk)
-- 
2.26.2

