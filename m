Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908512B4036
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728661AbgKPJsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:48:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728654AbgKPJsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:48:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605520120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BUhQYSb0ZbV3y60TPg9UZIDjbXDpgmb/7O/rvb0aZPQ=;
        b=aVPf52fqY8uvBOLytsJHUqCeXYjT0TWmFnJBCrLEEXu8AKOBhxBeZ3D7aDgD/3lazgHFFH
        C2gwXRHJpXOdFsEphI+F1e8uJRyjJ138kbmJDFBHM1WEJQmsuyv/cLt6Z4ZOtl0EIpQ2HW
        2gBWVAPpa8ppwtBFzZMTTtJy4n1GoRo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-4k_wqhjsM7KZNCxRJ9MNTQ-1; Mon, 16 Nov 2020 04:48:36 -0500
X-MC-Unique: 4k_wqhjsM7KZNCxRJ9MNTQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 210EC108E1A8;
        Mon, 16 Nov 2020 09:48:35 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-64.ams2.redhat.com [10.36.114.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6E581002C22;
        Mon, 16 Nov 2020 09:48:33 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 04/13] mptcp: introduce mptcp_schedule_work
Date:   Mon, 16 Nov 2020 10:48:05 +0100
Message-Id: <bf6e086f3cb983b13823b55422e5a973ec062394.1605458224.git.pabeni@redhat.com>
In-Reply-To: <cover.1605458224.git.pabeni@redhat.com>
References: <cover.1605458224.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove some of code duplications an allow preventing
rescheduling on close.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/pm.c       |  3 +--
 net/mptcp/protocol.c | 36 ++++++++++++++++++++++--------------
 net/mptcp/protocol.h |  1 +
 3 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index e19e1525ecbb..f9c88e2abb8e 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -89,8 +89,7 @@ static bool mptcp_pm_schedule_work(struct mptcp_sock *msk,
 		return false;
 
 	msk->pm.status |= BIT(new_status);
-	if (schedule_work(&msk->work))
-		sock_hold((struct sock *)msk);
+	mptcp_schedule_work((struct sock *)msk);
 	return true;
 }
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 3c68cf912fb8..0e725f18af24 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -620,9 +620,8 @@ static bool move_skbs_to_msk(struct mptcp_sock *msk, struct sock *ssk)
 		 * this is not a good place to change state. Let the workqueue
 		 * do it.
 		 */
-		if (mptcp_pending_data_fin(sk, NULL) &&
-		    schedule_work(&msk->work))
-			sock_hold(sk);
+		if (mptcp_pending_data_fin(sk, NULL))
+			mptcp_schedule_work(sk);
 	}
 
 	spin_unlock_bh(&sk->sk_lock.slock);
@@ -699,23 +698,32 @@ static void mptcp_reset_timer(struct sock *sk)
 	sk_reset_timer(sk, &icsk->icsk_retransmit_timer, jiffies + tout);
 }
 
+bool mptcp_schedule_work(struct sock *sk)
+{
+	if (inet_sk_state_load(sk) != TCP_CLOSE &&
+	    schedule_work(&mptcp_sk(sk)->work)) {
+		/* each subflow already holds a reference to the sk, and the
+		 * workqueue is invoked by a subflow, so sk can't go away here.
+		 */
+		sock_hold(sk);
+		return true;
+	}
+	return false;
+}
+
 void mptcp_data_acked(struct sock *sk)
 {
 	mptcp_reset_timer(sk);
 
 	if ((!test_bit(MPTCP_SEND_SPACE, &mptcp_sk(sk)->flags) ||
-	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)) &&
-	    schedule_work(&mptcp_sk(sk)->work))
-		sock_hold(sk);
+	     (inet_sk_state_load(sk) != TCP_ESTABLISHED)))
+		mptcp_schedule_work(sk);
 }
 
 void mptcp_subflow_eof(struct sock *sk)
 {
-	struct mptcp_sock *msk = mptcp_sk(sk);
-
-	if (!test_and_set_bit(MPTCP_WORK_EOF, &msk->flags) &&
-	    schedule_work(&msk->work))
-		sock_hold(sk);
+	if (!test_and_set_bit(MPTCP_WORK_EOF, &mptcp_sk(sk)->flags))
+		mptcp_schedule_work(sk);
 }
 
 static void mptcp_check_for_eof(struct mptcp_sock *msk)
@@ -1620,8 +1628,7 @@ static void mptcp_retransmit_handler(struct sock *sk)
 		mptcp_stop_timer(sk);
 	} else {
 		set_bit(MPTCP_WORK_RTX, &msk->flags);
-		if (schedule_work(&msk->work))
-			sock_hold(sk);
+		mptcp_schedule_work(sk);
 	}
 }
 
@@ -2334,7 +2341,8 @@ static void mptcp_release_cb(struct sock *sk)
 		struct sock *ssk;
 
 		ssk = mptcp_subflow_recv_lookup(msk);
-		if (!ssk || !schedule_work(&msk->work))
+		if (!ssk || sk->sk_state == TCP_CLOSE ||
+		    !schedule_work(&msk->work))
 			__sock_put(sk);
 	}
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 278c88c405e8..5211564a533f 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -408,6 +408,7 @@ static inline bool mptcp_is_fully_established(struct sock *sk)
 void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
+bool mptcp_schedule_work(struct sock *sk);
 void mptcp_data_acked(struct sock *sk);
 void mptcp_subflow_eof(struct sock *sk);
 bool mptcp_update_rcv_data_fin(struct mptcp_sock *msk, u64 data_fin_seq, bool use_64bit);
-- 
2.26.2

