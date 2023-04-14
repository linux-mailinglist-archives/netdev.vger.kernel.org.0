Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0A1D6E2554
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjDNOJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:09:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbjDNOJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:09:24 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD63C162
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:08:52 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id n42-20020a05600c3baa00b003f0b12814aaso1113368wms.0
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google; t=1681481312; x=1684073312;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CICDEU8TaCbg1GGQaZtC7SyRvWqn9IgSTFJRC3tOWbI=;
        b=M97x6TTNZC5Qr26UxgFeMre1y1tvfELn2/p/fczNWD4CSnqzG/x5eDIGfkD0dbJQx/
         nuRVNlFpMG6HjI5n0AmX19DarI5xtVq80bnKtrU5tIQP6qnn0NrwfxAJSU2cWi0hDV76
         sD2p9YorJuSEaTC81vPt8bqZhEtsQzrpMcW+lwbNZOEYjTNPs1dToWbtwERUVewm5QBV
         MiS76EfR+0u+20u3jX4tuA4f9HWK/lJYVEIXYq7Rgl4pQw2rCBiXzOYeelgbyMG7Zumz
         htF/WQ5aMFsTaHwgNYYznG3GbWg+/Xw41l7DrRTh/mvYAPe6tSx3BXMr/b78miYq+N1N
         VCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681481312; x=1684073312;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CICDEU8TaCbg1GGQaZtC7SyRvWqn9IgSTFJRC3tOWbI=;
        b=JENrhfOoiYiIPCz6acQ9bO8SRRG1feMwhxs25JawDsHPuv/IP5MNLGXYsdEA24F9v/
         NdiRkEWHdI8X+2QCJO/k4rUR4VRBFYtnUN4sGtUB4NE61jadNPNpGz4c5pgRWd/8tJbb
         z0nUkQgPAFmLjaem7bX5hLaXcH7kw3pbJhjrgGxgxk1EYgTmiBEnxnC7oDE5hCbQGv4q
         /Yfurcp5O0s1roD0uvcIBiJM262UdAIvHYq1VsdlHNWKxoKdt3qPy2ZNwF88ea9XrKhH
         y9zpdUlzJRbx1RSF/NUFh3NTrryoGUBW2his2Z78RPO2eH8xTIxhDIFhQGgBgvbsDp0r
         2HPA==
X-Gm-Message-State: AAQBX9d4/R9O75qrPkui7J3WbRd6t4JxgZ1TWlYQDY/27z1fkp+UO4Ir
        ff4zhzyFGF9ilCsBhfdrh27sNg==
X-Google-Smtp-Source: AKy350b4tvNEY3y7gEBTVqXReipSB/QUaoa5QCceuvf1AJ2yXMR8I2Nw06+1zBexwAzVFR90P7RQsw==
X-Received: by 2002:a1c:7918:0:b0:3f0:8ed8:853c with SMTP id l24-20020a1c7918000000b003f08ed8853cmr4410719wme.37.1681481311706;
        Fri, 14 Apr 2023 07:08:31 -0700 (PDT)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id o5-20020a5d58c5000000b002f47ae62fe0sm3648185wrf.115.2023.04.14.07.08.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 07:08:31 -0700 (PDT)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Fri, 14 Apr 2023 16:08:03 +0200
Subject: [PATCH net-next 4/5] mptcp: move first subflow allocation at mpc
 access time
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-4-04d177057eb9@tessares.net>
References: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-0-04d177057eb9@tessares.net>
In-Reply-To: <20230414-upstream-net-next-20230414-mptcp-refactor-first-subflow-init-v1-0-04d177057eb9@tessares.net>
To:     mptcp@lists.linux.dev, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=7808;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=5Y9EfyE2tJuCdvufBWHqISerg4pT1Ev9GzL9oU/i0Ew=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBkOV5Zj5iqs/ESmRSVO7FxR1JDWbjdG0TCigkvj
 m6e+3Z3Fg2JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZDleWQAKCRD2t4JPQmmg
 cxY/EACqAMhEgib2HptA0PI/AJBsNCGmF+xNwxY8QfBzJh/w/JqT1LQ0V+lqPLP1njmobzTPo5G
 zS6UnF0Rz+tZzaONcYBlPknWGXzD20eArWrX4stJh+T475AUaHMAZW2h98yCjf/UmG/trzg1jTJ
 1doZJ/Plyuicyy+IwiXwZmp24dT5MNcjOt8etsCeKacPGo0GVsl+91aWjX1D8rDBDx+mLqq7Kqa
 Vgv4L5EUdtV5Y1UzARZ7a2exLEUILgGedGrI3fUuKojL0taBt17nTFwy6/ecEoBmoLKDVNWmi1W
 MIO8QWYozUd5v2DLk17XG+ZegUKR2XD5FSNiK8Y7WM51wR8fpDa+sBNLSpxla6pxIeuOdsqyeiE
 6Yr+feTXZyeLo+nYCV5YyGWFofwThBz+w9lbVVEUszIh71cNnPeHPnpdML6iBGnqtJ9k8abdNJn
 S4hEySSuWPRm9qojyN795A5ZaFpvZeDI2WTZHEbEDmevzz3i3MaXjIWsLQjlLeLYH2mp8/yKoSW
 4CXAi4kHFs7Kcu/o//W037HpSuiKcvVqt5LbWHlwlZ92w3T6ZoYY8SN5HDwnUXayEwi4XuupQzd
 4xDCongkzVCYqVscyylJuyQ0TQDixR2LPKRtyYIfMflKZd/OvzVIrf/YL7A8WE3zJngsbhIwR3J
 gSe00yljSSb6+KA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

In the long run this will simplify the mptcp code and will
allow for more consistent behavior. Move the first subflow
allocation out of the sock->init ops into the __mptcp_nmpc_socket()
helper.

Since the first subflow creation can now happen after the first
setsockopt() we additionally need to invoke mptcp_sockopt_sync()
on it.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/pm_netlink.c |  4 ++--
 net/mptcp/protocol.c   | 61 ++++++++++++++++++++++++++++++--------------------
 net/mptcp/protocol.h   |  2 +-
 net/mptcp/sockopt.c    | 24 +++++++++++---------
 4 files changed, 54 insertions(+), 37 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 1c42bebca39e..bc343dab5e3f 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1035,8 +1035,8 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	lock_sock(newsk);
 	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
 	release_sock(newsk);
-	if (!ssock)
-		return -EINVAL;
+	if (IS_ERR(ssock))
+		return PTR_ERR(ssock);
 
 	mptcp_info2sockaddr(&entry->addr, &addr, entry->addr.family);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 22e073b373af..a676ac1bb9f1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -49,18 +49,6 @@ static void __mptcp_check_send_data_fin(struct sock *sk);
 DEFINE_PER_CPU(struct mptcp_delegated_action, mptcp_delegated_actions);
 static struct net_device mptcp_napi_dev;
 
-/* If msk has an initial subflow socket, and the MP_CAPABLE handshake has not
- * completed yet or has failed, return the subflow socket.
- * Otherwise return NULL.
- */
-struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk)
-{
-	if (!msk->subflow || READ_ONCE(msk->can_ack))
-		return NULL;
-
-	return msk->subflow;
-}
-
 /* Returns end sequence number of the receiver's advertised window */
 static u64 mptcp_wnd_end(const struct mptcp_sock *msk)
 {
@@ -116,6 +104,31 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 	return 0;
 }
 
+/* If the MPC handshake is not started, returns the first subflow,
+ * eventually allocating it.
+ */
+struct socket *__mptcp_nmpc_socket(struct mptcp_sock *msk)
+{
+	struct sock *sk = (struct sock *)msk;
+	int ret;
+
+	if (!((1 << sk->sk_state) & (TCPF_CLOSE | TCPF_LISTEN)))
+		return ERR_PTR(-EINVAL);
+
+	if (!msk->subflow) {
+		if (msk->first)
+			return ERR_PTR(-EINVAL);
+
+		ret = __mptcp_socket_create(msk);
+		if (ret)
+			return ERR_PTR(ret);
+
+		mptcp_sockopt_sync(msk, msk->first);
+	}
+
+	return msk->subflow;
+}
+
 static void mptcp_drop(struct sock *sk, struct sk_buff *skb)
 {
 	sk_drops_add(sk, skb);
@@ -1667,6 +1680,7 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 {
 	unsigned int saved_flags = msg->msg_flags;
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct socket *ssock;
 	struct sock *ssk;
 	int ret;
 
@@ -1676,8 +1690,11 @@ static int mptcp_sendmsg_fastopen(struct sock *sk, struct msghdr *msg,
 	 * Since the defer_connect flag is cleared after the first succsful
 	 * fastopen attempt, no need to check for additional subflow status.
 	 */
-	if (msg->msg_flags & MSG_FASTOPEN && !__mptcp_nmpc_socket(msk))
-		return -EINVAL;
+	if (msg->msg_flags & MSG_FASTOPEN) {
+		ssock = __mptcp_nmpc_socket(msk);
+		if (IS_ERR(ssock))
+			return PTR_ERR(ssock);
+	}
 	if (!msk->first)
 		return -EINVAL;
 
@@ -2740,10 +2757,6 @@ static int mptcp_init_sock(struct sock *sk)
 	if (unlikely(!net->mib.mptcp_statistics) && !mptcp_mib_alloc(net))
 		return -ENOMEM;
 
-	ret = __mptcp_socket_create(mptcp_sk(sk));
-	if (ret)
-		return ret;
-
 	set_bit(SOCK_CUSTOM_SOCKOPT, &sk->sk_socket->flags);
 
 	/* fetch the ca name; do it outside __mptcp_init_sock(), so that clone will
@@ -3563,8 +3576,8 @@ static int mptcp_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len)
 	int err = -EINVAL;
 
 	ssock = __mptcp_nmpc_socket(msk);
-	if (!ssock)
-		return -EINVAL;
+	if (IS_ERR(ssock))
+		return PTR_ERR(ssock);
 
 	mptcp_token_destroy(msk);
 	inet_sk_state_store(sk, TCP_SYN_SENT);
@@ -3652,8 +3665,8 @@ static int mptcp_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 
 	lock_sock(sock->sk);
 	ssock = __mptcp_nmpc_socket(msk);
-	if (!ssock) {
-		err = -EINVAL;
+	if (IS_ERR(ssock)) {
+		err = PTR_ERR(ssock);
 		goto unlock;
 	}
 
@@ -3689,8 +3702,8 @@ static int mptcp_listen(struct socket *sock, int backlog)
 
 	lock_sock(sk);
 	ssock = __mptcp_nmpc_socket(msk);
-	if (!ssock) {
-		err = -EINVAL;
+	if (IS_ERR(ssock)) {
+		err = PTR_ERR(ssock);
 		goto unlock;
 	}
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a9eb0e428a6b..21eda9cd0c52 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -627,7 +627,7 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 void __mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
-struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
+struct socket *__mptcp_nmpc_socket(struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
 void mptcp_cancel_work(struct sock *sk);
 void mptcp_set_owner_r(struct sk_buff *skb, struct sock *sk);
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index b655cebda0f3..d4258869ac48 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -301,9 +301,9 @@ static int mptcp_setsockopt_sol_socket(struct mptcp_sock *msk, int optname,
 	case SO_BINDTOIFINDEX:
 		lock_sock(sk);
 		ssock = __mptcp_nmpc_socket(msk);
-		if (!ssock) {
+		if (IS_ERR(ssock)) {
 			release_sock(sk);
-			return -EINVAL;
+			return PTR_ERR(ssock);
 		}
 
 		ret = sock_setsockopt(ssock, SOL_SOCKET, optname, optval, optlen);
@@ -396,9 +396,9 @@ static int mptcp_setsockopt_v6(struct mptcp_sock *msk, int optname,
 	case IPV6_FREEBIND:
 		lock_sock(sk);
 		ssock = __mptcp_nmpc_socket(msk);
-		if (!ssock) {
+		if (IS_ERR(ssock)) {
 			release_sock(sk);
-			return -EINVAL;
+			return PTR_ERR(ssock);
 		}
 
 		ret = tcp_setsockopt(ssock->sk, SOL_IPV6, optname, optval, optlen);
@@ -693,9 +693,9 @@ static int mptcp_setsockopt_sol_ip_set_transparent(struct mptcp_sock *msk, int o
 	lock_sock(sk);
 
 	ssock = __mptcp_nmpc_socket(msk);
-	if (!ssock) {
+	if (IS_ERR(ssock)) {
 		release_sock(sk);
-		return -EINVAL;
+		return PTR_ERR(ssock);
 	}
 
 	issk = inet_sk(ssock->sk);
@@ -762,13 +762,15 @@ static int mptcp_setsockopt_first_sf_only(struct mptcp_sock *msk, int level, int
 {
 	struct sock *sk = (struct sock *)msk;
 	struct socket *sock;
-	int ret = -EINVAL;
+	int ret;
 
 	/* Limit to first subflow, before the connection establishment */
 	lock_sock(sk);
 	sock = __mptcp_nmpc_socket(msk);
-	if (!sock)
+	if (IS_ERR(sock)) {
+		ret = PTR_ERR(sock);
 		goto unlock;
+	}
 
 	ret = tcp_setsockopt(sock->sk, level, optname, optval, optlen);
 
@@ -861,7 +863,7 @@ static int mptcp_getsockopt_first_sf_only(struct mptcp_sock *msk, int level, int
 {
 	struct sock *sk = (struct sock *)msk;
 	struct socket *ssock;
-	int ret = -EINVAL;
+	int ret;
 	struct sock *ssk;
 
 	lock_sock(sk);
@@ -872,8 +874,10 @@ static int mptcp_getsockopt_first_sf_only(struct mptcp_sock *msk, int level, int
 	}
 
 	ssock = __mptcp_nmpc_socket(msk);
-	if (!ssock)
+	if (IS_ERR(ssock)) {
+		ret = PTR_ERR(ssock);
 		goto out;
+	}
 
 	ret = tcp_getsockopt(ssock->sk, level, optname, optval, optlen);
 

-- 
2.39.2

