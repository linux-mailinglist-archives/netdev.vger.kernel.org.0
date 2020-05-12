Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7122F1CF689
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgELOLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:11:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56136 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728085AbgELOLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589292680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6SnCi1H2hbmZgmMago2qxPa+a25bjrkbSjMX/nEVb0Y=;
        b=CTPDmEl4SakRwww0qKqkoU7Gl+jbzVqsaRaKaQ5GtM9jhPlw20C1xVvqwT5rHF/M3XoCMi
        3TZV42Zzh6DwpQ9HvdwPRqX6+Y9HQjtb3UQNDmXeLdWSEnqpxtpWxnpl6YUuVrzTNMIYrV
        DpaGXcBS7VgJklTmEl8sJDoqhGtE8tE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-ligGQ6rpMLWxEOPgGPKi-Q-1; Tue, 12 May 2020 10:11:18 -0400
X-MC-Unique: ligGQ6rpMLWxEOPgGPKi-Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15D74884D86;
        Tue, 12 May 2020 14:11:17 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-10.ams2.redhat.com [10.36.115.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E678D5D9DD;
        Tue, 12 May 2020 14:11:15 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [RFC PATCH 3/3] mptcp: cope better with MP_JOIN failure
Date:   Tue, 12 May 2020 16:08:10 +0200
Message-Id: <93ab518d98394270a402411198d50ee94177d10a.1589280857.git.pabeni@redhat.com>
In-Reply-To: <cover.1589280857.git.pabeni@redhat.com>
References: <cover.1589280857.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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

Reported-by: Christoph Paasch <cpaasch@apple.com>
Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index b39a66ffac7a..755cd9712216 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -476,7 +476,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		 */
 		if (!ctx || fallback) {
 			if (fallback_is_fatal)
-				goto close_child;
+				goto dispose_child;
 
 			if (ctx) {
 				subflow_ulp_fallback(child, ctx);
@@ -506,11 +506,11 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 			owner = mptcp_token_get_sock(ctx->token);
 			if (!owner)
-				goto close_child;
+				goto dispose_child;
 
 			ctx->conn = (struct sock *)owner;
 			if (!mptcp_finish_join(child))
-				goto close_child;
+				goto dispose_child;
 
 			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKRX);
 			tcp_sk(child)->drop_req = true;
@@ -530,11 +530,14 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		      !mptcp_subflow_ctx(child)->conn));
 	return child;
 
-close_child:
+dispose_child:
+	tcp_sk(child)->drop_req = true;
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

