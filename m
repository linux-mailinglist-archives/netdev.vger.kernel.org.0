Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17401D57A3
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:23:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgEORXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:23:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36303 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726831AbgEORXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589563400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vv1asE1qj9O0T/AJ5dV389SeUbJUFcllI8zEpuOm52I=;
        b=H/2uB7Q1CQsk9wjLqTq9p0zliQY2kHiwMFIvfvto6UET+j80NTTJsHllKu8/xN/HaBGpN5
        48GY4epYQjB5MU6akIEPcwJBotXt8cWS+0HFGci2V4V1ov6HbkxXmioD05/2ARrgmmJtBI
        XD093x17IGINHt6OopV35EDl1dl4M8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-HYVwboACPmKIdT-E5Wnbog-1; Fri, 15 May 2020 13:23:17 -0400
X-MC-Unique: HYVwboACPmKIdT-E5Wnbog-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A95F8107ACCA;
        Fri, 15 May 2020 17:23:15 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-8.ams2.redhat.com [10.36.115.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12EAE600F5;
        Fri, 15 May 2020 17:23:13 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 3/3] mptcp: cope better with MP_JOIN failure
Date:   Fri, 15 May 2020 19:22:17 +0200
Message-Id: <4dc2d07bafebc2dde162fe1dc1c25f0c4cb602e1.1589558049.git.pabeni@redhat.com>
In-Reply-To: <cover.1589558049.git.pabeni@redhat.com>
References: <cover.1589558049.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, on MP_JOIN failure we reset the child
socket, but leave the request socket untouched.

tcp_check_req will deal with it according to the
'tcp_abort_on_overflow' sysctl value - by default the
req socket will stay alive.

The above leads to inconsistent behavior on MP JOIN
failure, and bad listener overflow accounting.

This patch addresses the issue leveraging the infrastructure
just introduced to ask the TCP stack to drop the req on
failure.

The child socket is not freed anymore by subflow_syn_recv_sock(),
instead it's moved to a dead state and will be disposed by the
next sock_put done by the TCP stack, so that listener overflow
accounting is not affected by MP JOIN failure.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Christoph Paasch <cpaasch@apple.com>
---
 net/mptcp/subflow.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 5e03ed8ae899..3cf2eeea9d80 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -478,7 +478,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		 */
 		if (!ctx || fallback) {
 			if (fallback_is_fatal)
-				goto close_child;
+				goto dispose_child;
 
 			if (ctx) {
 				subflow_ulp_fallback(child, ctx);
@@ -507,11 +507,11 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 			owner = mptcp_token_get_sock(ctx->token);
 			if (!owner)
-				goto close_child;
+				goto dispose_child;
 
 			ctx->conn = (struct sock *)owner;
 			if (!mptcp_finish_join(child))
-				goto close_child;
+				goto dispose_child;
 
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKRX);
 			tcp_rsk(req)->drop_req = true;
@@ -531,11 +531,14 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		      !mptcp_subflow_ctx(child)->conn));
 	return child;
 
-close_child:
+dispose_child:
+	tcp_rsk(req)->drop_req = true;
 	tcp_send_active_reset(child, GFP_ATOMIC);
-	inet_csk_prepare_forced_close(child);
+	inet_csk_prepare_for_destroy_sock(child);
 	tcp_done(child);
-	return NULL;
+
+	/* The last child reference will be released by the caller */
+	return child;
 }
 
 static struct inet_connection_sock_af_ops subflow_specific;
-- 
2.21.3

