Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524741E827A
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgE2Ptk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:49:40 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59021 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726838AbgE2Ptj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:49:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590767378;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TUxFJqIOnv1Ms2VJP0DSzUqLY/qT+oP9E0b+tP02o94=;
        b=C7fv6l96bkb0zsUu6iPr2M5GzLMzaHvJkWAzjFgdQJbaJTEE7y4UgvZ6n5MkKv21yQHhUg
        LMRRMEM1OLh/7519+1rrCLTa2giAE9SfJgDXiDl0vZ/quBKLdGI28fMB9w1dc+Zbsr8jwz
        X8oboOo91svHfUJJW/9hqtYK2z3C5r4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-113-ACwoQ_krMEawT4MHeRqs9A-1; Fri, 29 May 2020 11:49:36 -0400
X-MC-Unique: ACwoQ_krMEawT4MHeRqs9A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97520107ACCA;
        Fri, 29 May 2020 15:49:35 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-94.ams2.redhat.com [10.36.114.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 51BA65D9F3;
        Fri, 29 May 2020 15:49:34 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next] mptcp: fix NULL ptr dereference in MP_JOIN error path
Date:   Fri, 29 May 2020 17:49:18 +0200
Message-Id: <1fc1fd4512e4709d1fbeb7f008f38b273ee1d798.1590767183.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When token lookup on MP_JOIN 3rd ack fails, the server
socket closes with a reset the incoming child. Such socket
has the 'is_mptcp' flag set, but no msk socket associated
- due to the failed lookup.

While crafting the reset packet mptcp_established_options_mp()
will try to dereference the child's master socket, causing
a NULL ptr dereference.

This change addresses the issue with explicit fallback to
TCP in such error path.

Fixes: 729cd6436f35 ("mptcp: cope better with MP_JOIN failure")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index f3c06b8af92d..493b98a0825c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -413,6 +413,20 @@ static void subflow_ulp_fallback(struct sock *sk,
 	tcp_sk(sk)->is_mptcp = 0;
 }
 
+static void subflow_drop_ctx(struct sock *ssk)
+{
+	struct mptcp_subflow_context *ctx = mptcp_subflow_ctx(ssk);
+
+	if (!ctx)
+		return;
+
+	subflow_ulp_fallback(ssk, ctx);
+	if (ctx->conn)
+		sock_put(ctx->conn);
+
+	kfree_rcu(ctx, rcu);
+}
+
 static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 					  struct sk_buff *skb,
 					  struct request_sock *req,
@@ -485,10 +499,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			if (fallback_is_fatal)
 				goto dispose_child;
 
-			if (ctx) {
-				subflow_ulp_fallback(child, ctx);
-				kfree_rcu(ctx, rcu);
-			}
+			subflow_drop_ctx(child);
 			goto out;
 		}
 
@@ -537,6 +548,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 	return child;
 
 dispose_child:
+	subflow_drop_ctx(child);
 	tcp_rsk(req)->drop_req = true;
 	tcp_send_active_reset(child, GFP_ATOMIC);
 	inet_csk_prepare_for_destroy_sock(child);
-- 
2.21.3

