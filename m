Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B85B2B403D
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 10:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgKPJsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 04:48:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49336 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728682AbgKPJsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 04:48:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605520132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bBjs+eItgvmlH/fD6oswebhIMYYLw1+545fJPhiMVHI=;
        b=ZCuOIOIp/C6ZTUkw/Ohm/mtn3uc1KeBzOQ927QqmFTP6sCu/hX/aWHVwG2ZrukF72zgwpp
        rTH8dSedoVShGv3ji1DRtQqEKx07BgMGxa1Uxdm4oN9OcKc9d5f6m8OscWfSXb05fZ6cQl
        hQHAkQt6mOM38EkOz4S3aNGCMS7qczs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-2OXAO0ghObWZJxQhC-Wi-g-1; Mon, 16 Nov 2020 04:48:50 -0500
X-MC-Unique: 2OXAO0ghObWZJxQhC-Wi-g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8A5431018729;
        Mon, 16 Nov 2020 09:48:49 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-64.ams2.redhat.com [10.36.114.64])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 63B751002C18;
        Mon, 16 Nov 2020 09:48:48 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 13/13] mptcp: send explicit ack on delayed ack_seq incr
Date:   Mon, 16 Nov 2020 10:48:14 +0100
Message-Id: <1ccf235121023b2383eeabf452ce044f648e3f76.1605458224.git.pabeni@redhat.com>
In-Reply-To: <cover.1605458224.git.pabeni@redhat.com>
References: <cover.1605458224.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the worker moves some bytes from the OoO queue into
the receive queue, the msk->ask_seq is updated, the MPTCP-level
ack carrying that value needs to wait the next ingress packet,
possibly slowing down or hanging the peer

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 5a92b9239909..8df013daea88 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -407,13 +407,27 @@ static void mptcp_set_timeout(const struct sock *sk, const struct sock *ssk)
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
@@ -429,8 +443,6 @@ static void mptcp_check_data_fin(struct sock *sk)
 	 */
 
 	if (mptcp_pending_data_fin(sk, &rcv_data_fin_seq)) {
-		struct mptcp_subflow_context *subflow;
-
 		WRITE_ONCE(msk->ack_seq, msk->ack_seq + 1);
 		WRITE_ONCE(msk->rcv_data_fin, 0);
 
@@ -454,17 +466,12 @@ static void mptcp_check_data_fin(struct sock *sk)
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
 		mptcp_close_wake_up(sk);
 	}
+	return ret;
 }
 
 static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
@@ -1547,7 +1554,8 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
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

