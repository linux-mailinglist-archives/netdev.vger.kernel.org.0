Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9220F760
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 16:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389045AbgF3Oiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 10:38:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41096 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726672AbgF3Oip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 10:38:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593527924;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=B6CrHqng17Pxk6mV6y2tawGhe70QMZC9ySlLvQupB5M=;
        b=OO8asWKtD8FAiXMwrSrlCUPGCqRSpde0G2Yhva7mP43wAQmJOyw0EhUYLjk2ptz2SMoq4l
        EY42yJ5if20q1cLT4/yyDSUrliyfak46d15/miWaMSFa+l7KIzEY3fIV3m66lJZY83w5bI
        aTESwaFEw88NYykEcTmtpxihcqQsr3w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-ZOUlLuFmPiqE1vJ7duEfXw-1; Tue, 30 Jun 2020 10:38:38 -0400
X-MC-Unique: ZOUlLuFmPiqE1vJ7duEfXw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 728BB1902EBE;
        Tue, 30 Jun 2020 14:38:37 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-78.ams2.redhat.com [10.36.113.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19F1A77F59;
        Tue, 30 Jun 2020 14:38:35 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next] mptcp: do nonce initialization at subflow creation time
Date:   Tue, 30 Jun 2020 16:38:26 +0200
Message-Id: <cc811b8707d488492fb8e33ed651aab456de6f72.1593527763.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This clean-up the code a bit, reduces the number of
used hooks and indirect call requested, and allow
better error reporting from __mptcp_subflow_connect()

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/subflow.c | 54 +++++++++++++++++----------------------------
 1 file changed, 20 insertions(+), 34 deletions(-)

diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 548f9e347ff5..664aa9158363 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -29,34 +29,6 @@ static void SUBFLOW_REQ_INC_STATS(struct request_sock *req,
 	MPTCP_INC_STATS(sock_net(req_to_sk(req)), field);
 }
 
-static int subflow_rebuild_header(struct sock *sk)
-{
-	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
-	int local_id;
-
-	if (subflow->request_join && !subflow->local_nonce) {
-		struct mptcp_sock *msk = (struct mptcp_sock *)subflow->conn;
-
-		pr_debug("subflow=%p", sk);
-
-		do {
-			get_random_bytes(&subflow->local_nonce, sizeof(u32));
-		} while (!subflow->local_nonce);
-
-		if (subflow->local_id)
-			goto out;
-
-		local_id = mptcp_pm_get_local_id(msk, (struct sock_common *)sk);
-		if (local_id < 0)
-			return -EINVAL;
-
-		subflow->local_id = local_id;
-	}
-
-out:
-	return subflow->icsk_af_ops->rebuild_header(sk);
-}
-
 static void subflow_req_destructor(struct request_sock *req)
 {
 	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
@@ -984,7 +956,9 @@ int __mptcp_subflow_connect(struct sock *sk, int ifindex,
 	struct mptcp_sock *msk = mptcp_sk(sk);
 	struct mptcp_subflow_context *subflow;
 	struct sockaddr_storage addr;
+	int local_id = loc->id;
 	struct socket *sf;
+	struct sock *ssk;
 	u32 remote_token;
 	int addrlen;
 	int err;
@@ -996,7 +970,20 @@ int __mptcp_subflow_connect(struct sock *sk, int ifindex,
 	if (err)
 		return err;
 
-	subflow = mptcp_subflow_ctx(sf->sk);
+	ssk = sf->sk;
+	subflow = mptcp_subflow_ctx(ssk);
+	do {
+		get_random_bytes(&subflow->local_nonce, sizeof(u32));
+	} while (!subflow->local_nonce);
+
+	if (!local_id) {
+		err = mptcp_pm_get_local_id(msk, (struct sock_common *)ssk);
+		if (err < 0)
+			goto failed;
+
+		local_id = err;
+	}
+
 	subflow->remote_key = msk->remote_key;
 	subflow->local_key = msk->local_key;
 	subflow->token = msk->token;
@@ -1007,15 +994,16 @@ int __mptcp_subflow_connect(struct sock *sk, int ifindex,
 	if (loc->family == AF_INET6)
 		addrlen = sizeof(struct sockaddr_in6);
 #endif
-	sf->sk->sk_bound_dev_if = ifindex;
+	ssk->sk_bound_dev_if = ifindex;
 	err = kernel_bind(sf, (struct sockaddr *)&addr, addrlen);
 	if (err)
 		goto failed;
 
 	mptcp_crypto_key_sha(subflow->remote_key, &remote_token, NULL);
-	pr_debug("msk=%p remote_token=%u", msk, remote_token);
+	pr_debug("msk=%p remote_token=%u local_id=%d", msk, remote_token,
+		 local_id);
 	subflow->remote_token = remote_token;
-	subflow->local_id = loc->id;
+	subflow->local_id = local_id;
 	subflow->request_join = 1;
 	subflow->request_bkup = 1;
 	mptcp_info2sockaddr(remote, &addr);
@@ -1288,7 +1276,6 @@ void __init mptcp_subflow_init(void)
 	subflow_specific.conn_request = subflow_v4_conn_request;
 	subflow_specific.syn_recv_sock = subflow_syn_recv_sock;
 	subflow_specific.sk_rx_dst_set = subflow_finish_connect;
-	subflow_specific.rebuild_header = subflow_rebuild_header;
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	subflow_request_sock_ipv6_ops = tcp_request_sock_ipv6_ops;
@@ -1298,7 +1285,6 @@ void __init mptcp_subflow_init(void)
 	subflow_v6_specific.conn_request = subflow_v6_conn_request;
 	subflow_v6_specific.syn_recv_sock = subflow_syn_recv_sock;
 	subflow_v6_specific.sk_rx_dst_set = subflow_finish_connect;
-	subflow_v6_specific.rebuild_header = subflow_rebuild_header;
 
 	subflow_v6m_specific = subflow_v6_specific;
 	subflow_v6m_specific.queue_xmit = ipv4_specific.queue_xmit;
-- 
2.26.2

