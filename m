Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198A32B0316
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgKLKt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:49:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56363 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728029AbgKLKtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:49:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178159;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0I7qGof3Rv/VzYLT/8BlSyedu+IPLSMCdaiyqffq4IA=;
        b=QrbXjm0TbrAXo8YAXg7w6h+LNoW20BqWjyxoZICes2eQfWFzPad/C6igMsUV4wzgvcVMpv
        OVsCXTnmHgX15zmsBhsal3yJKngyT178dpH5/n/yGEkNDF13HSXpEaYTAHPnXyApd8wq8B
        cVSmnZVYOzzrpVVMMaFuCaGkVf3VI2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-419-NZwL8528OcCaP9DkUtDQKQ-1; Thu, 12 Nov 2020 05:49:17 -0500
X-MC-Unique: NZwL8528OcCaP9DkUtDQKQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C439879538;
        Thu, 12 Nov 2020 10:49:16 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64C4F5C3E1;
        Thu, 12 Nov 2020 10:49:15 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 13/13] mptcp: send explicit ack on delayed ack_seq incr
Date:   Thu, 12 Nov 2020 11:48:11 +0100
Message-Id: <a84d5415f618863823bfa4ab5b238b0f3c9a0df5.1605175834.git.pabeni@redhat.com>
In-Reply-To: <cover.1605175834.git.pabeni@redhat.com>
References: <cover.1605175834.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the worker moves some bytes from the OoO queue into
the receive queue, the msk->ask_seq is updated, the MPTCP-level
ack carrying that value needs to wait the next ingress packet,
possibly slowing down or hanging the peer

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 05daed57ae4a..bb9a0bc7ee33 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -405,13 +405,27 @@ static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
 	mptcp_sk(sk)->timer_ival = tout > 0 ? tout : TCP_RTO_MIN;
 }
 
-static void mptcp_check_data_fin(struct sock *sk)
+static void mptcp_send_ack(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+
+	mptcp_for_each_subflow(msk, subflow) {
+		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+		lock_sock(ssk);
+		tcp_send_ack(ssk);
+		release_sock(ssk);
+	}
+}
+
+static bool mptcp_check_data_fin(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	u64 rcv_data_fin_seq;
+	bool ret = false;
 
 	if (__mptcp_check_fallback(msk) || !msk->first)
-		return;
+		return ret;
 
 	/* Need to ack a DATA_FIN received from a peer while this side
 	 * of the connection is in ESTABLISHED, FIN_WAIT1, or FIN_WAIT2.
@@ -427,8 +441,6 @@ static void mptcp_check_data_fin(struct sock *sk)
 	 */
 
 	if (mptcp_pending_data_fin(sk, &rcv_data_fin_seq)) {
-		struct mptcp_subflow_context *subflow;
-
 		WRITE_ONCE(msk->ack_seq, msk->ack_seq + 1);
 		WRITE_ONCE(msk->rcv_data_fin, 0);
 
@@ -452,17 +464,11 @@ static void mptcp_check_data_fin(struct sock *sk)
 			break;
 		}
 
+		ret = true;
 		mptcp_set_timeout(sk, NULL);
-		mptcp_for_each_subflow(msk, subflow) {
-			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-			lock_sock(ssk);
-			tcp_send_ack(ssk);
-			release_sock(ssk);
-		}
-
+		mptcp_send_ack(msk);
 		if (sock_flag(sk, SOCK_DEAD))
-			return;
+			return ret;
 
 		sk->sk_state_change(sk);
 		if (sk->sk_shutdown == SHUTDOWN_MASK ||
@@ -471,6 +477,7 @@ static void mptcp_check_data_fin(struct sock *sk)
 		else
 			sk_wake_async(sk, SOCK_WAKE_WAITD, POLL_IN);
 	}
+	return ret;
 }
 
 static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
@@ -1542,7 +1549,8 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 	} while (!done);
 
 	if (mptcp_ofo_queue(msk) || moved > 0) {
-		mptcp_check_data_fin((struct sock *)msk);
+		if (!mptcp_check_data_fin((struct sock *)msk))
+			mptcp_send_ack(msk);
 		return true;
 	}
 	return false;
-- 
2.26.2

