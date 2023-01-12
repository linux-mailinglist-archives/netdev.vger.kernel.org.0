Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFA2667DA3
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240221AbjALSO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240520AbjALSNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:13:49 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48D046DBAD
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 09:43:18 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so15720470wms.4
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 09:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8YUfEdizU6etVNTRXoI4GW0/pb7ruC4LypASoGIVwPU=;
        b=2KtC7802s32bVsm7NZjN7KH4JundRVEoKhT7MLX3ExFrG8IJ4+v3cCKL/BOb6NeuAr
         WflCfYzguxCXWVA84P4+arDan1X86BYFIMJc8Y37BZtvt/1ck7WxQwvtJAZwNSkBkY+N
         Ao2M2KztoSLHYoEPIuX8nTrP8drcderZ0PMpldAK8AiU6Xoz9UxEYf+yVxocKa7zwcI5
         xefZ9mwdftJ4KjE38zxYWn8GLitnxJjyHexF+ZI+6mKgAdUpokoIhNTVwt01pCC4sOBC
         XxUxhiu5SQl/tKVWAkiI6k5Xm6azWV1eUWUvOpCV7ln/SeqgZ4w/uH+8R9+wyRCb3DS3
         noig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8YUfEdizU6etVNTRXoI4GW0/pb7ruC4LypASoGIVwPU=;
        b=fBlk3la/ppKCzZC865iMPinPkxACpi9LLrgA6F/fTUD62U0wc/ILh/9zuY4fS7PDEy
         e2pi1ceHpt63z9067EYHMNIDGn+uqtvex8/+5SJ75OLQ7q/nEZG8QchJevAMWWEoP96b
         U2ZXJibUeS4EgaacE8VeLBwju7S/cqZ/bmhtYnvOFkeMyAZoDWZ9zkW2DVJvgjvFbRop
         POdhgm6CTT2/MDNOm+YCR73P1+aHIujhEBkv231Nm2M8peaYmG/2Y7TVGndqmtM7tgD6
         HsPKlDHaApjMW0Ip2sUUENENKY9R1FHFhwC0LAeNXctU9BgpoxBIA4gn6hGS+DQO3PI/
         ykVg==
X-Gm-Message-State: AFqh2kpA56nM5e/Fb4BA28k+q/1b+j67u2Wn6zWtMkPQ9VmTHPAcH/Il
        deuf91zXXpQR7opMaEYYSDGJvQ==
X-Google-Smtp-Source: AMrXdXvK/Dxj0h2KI8ZmmNzOHGYhNVCFb4CLn9xyRam5mqbJmKWsmKzga/swbRi3y8zBS1sJHNoECg==
X-Received: by 2002:a05:600c:c87:b0:3d9:73fb:8aaa with SMTP id fj7-20020a05600c0c8700b003d973fb8aaamr46696670wmb.8.1673545396847;
        Thu, 12 Jan 2023 09:43:16 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id hg9-20020a05600c538900b003cfa622a18asm26448769wmb.3.2023.01.12.09.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 09:43:16 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Thu, 12 Jan 2023 18:42:51 +0100
Subject: [PATCH net 1/3] mptcp: explicitly specify sock family at subflow
 creation time
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-upstream-net-20230112-netlink-v4-v6-v1-1-6a8363a221d2@tessares.net>
References: <20230112-upstream-net-20230112-netlink-v4-v6-v1-0-6a8363a221d2@tessares.net>
In-Reply-To: <20230112-upstream-net-20230112-netlink-v4-v6-v1-0-6a8363a221d2@tessares.net>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Kishen Maloor <kishen.maloor@intel.com>,
        Florian Westphal <fw@strlen.de>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        stable@vger.kernel.org
X-Mailer: b4 0.11.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3907;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=s+3xVgukLGyOe4wr8E0yNyqO1BWR4F9rZ7m7xbrXwhc=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjwEayyEL2TZPccGTRXgPHRC1HAS9t3XYCkU15kPTM
 hAQuVZSJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY8BGsgAKCRD2t4JPQmmgcy48D/
 9INvcrgJwYWWJjoPXs3GnIhV9aEsw999RC4xYkwhfyvmT5af/I4pDPHMyCWBNf+u3N2iJnVMnSoLK6
 omjUZ8KvNuhlK8RJ178lcVztmvyYpVL+17/zoeArxUH+w1Hmr4cqHGpv8rGC/9we34lmQ3zWBgECmd
 a/aDROtQYsnfBu/FIavm64IzA3g5ouCfUAy4WAVDy5PfHe3OVGfQ4ftaZM61TCo/3AvZwF9k19MIx7
 imwoUl9YY7g6PGf8Sm65Non2oe5C12DXIlxSA1h3uAKGKoTsdE2Qtpk00yZykK68kN1rwZA9ivUuXn
 eE2OYIjs/RNDPMwBbwNlafJsLt523vDgIJyE/+eeqYOZftWuF6b4SBxMpCVBHOCdERDE/6NN9aA0V3
 SXFsGGD+ravF6uD/uAtMnV/bHf3Dc3rDKALgtdfbf9mWdgKV/oxuVFzruIK3ARyVQilefKpYlwMnbl
 h5Twxa6KnBGr11FMnX8/Cpr6Dst54q8JvhftvLSOnGc+8ZuHuiKFcMczOOHh5fGatQI/StezvT9sC2
 uBOBuI3umttX8BqL/lkD4eI9OkZpL7GEGZCaozGnqOcRNyWuriGWXdMWoh0d09Mns8DtkyJTLKoL4I
 BiLiqqt6Cg9RcWaMEVUb0LOs1+a0nz2HuUgdLAcf4ItdD+0wffRxfn5RtqVg==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Let the caller specify the to-be-created subflow family.

For a given MPTCP socket created with the AF_INET6 family, the current
userspace PM can already ask the kernel to create subflows in v4 and v6.
If "plain" IPv4 addresses are passed to the kernel, they are
automatically mapped in v6 addresses "by accident". This can be
problematic because the userspace will need to pass different addresses,
now the v4-mapped-v6 addresses to destroy this new subflow.

On the other hand, if the MPTCP socket has been created with the AF_INET
family, the command to create a subflow in v6 will be accepted but the
result will not be the one as expected as new subflow will be created in
IPv4 using part of the v6 addresses passed to the kernel: not creating
the expected subflow then.

No functional change intended for the in-kernel PM where an explicit
enforcement is currently in place. This arbitrary enforcement will be
leveraged by other patches in a future version.

Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Cc: stable@vger.kernel.org
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 net/mptcp/protocol.c | 2 +-
 net/mptcp/protocol.h | 3 ++-
 net/mptcp/subflow.c  | 9 +++++----
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b7ad030dfe89..8cd6cc67c2c5 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -98,7 +98,7 @@ static int __mptcp_socket_create(struct mptcp_sock *msk)
 	struct socket *ssock;
 	int err;
 
-	err = mptcp_subflow_create_socket(sk, &ssock);
+	err = mptcp_subflow_create_socket(sk, sk->sk_family, &ssock);
 	if (err)
 		return err;
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index a0d1658ce59e..a9e0355744b6 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -641,7 +641,8 @@ bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
 /* called with sk socket lock held */
 int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 			    const struct mptcp_addr_info *remote);
-int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock);
+int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
+				struct socket **new_sock);
 void mptcp_info2sockaddr(const struct mptcp_addr_info *info,
 			 struct sockaddr_storage *addr,
 			 unsigned short family);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index bd387d4b5a38..ec54413fb31f 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1547,7 +1547,7 @@ int __mptcp_subflow_connect(struct sock *sk, const struct mptcp_addr_info *loc,
 	if (!mptcp_is_fully_established(sk))
 		goto err_out;
 
-	err = mptcp_subflow_create_socket(sk, &sf);
+	err = mptcp_subflow_create_socket(sk, loc->family, &sf);
 	if (err)
 		goto err_out;
 
@@ -1660,7 +1660,9 @@ static void mptcp_subflow_ops_undo_override(struct sock *ssk)
 #endif
 		ssk->sk_prot = &tcp_prot;
 }
-int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
+
+int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
+				struct socket **new_sock)
 {
 	struct mptcp_subflow_context *subflow;
 	struct net *net = sock_net(sk);
@@ -1673,8 +1675,7 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	if (unlikely(!sk->sk_socket))
 		return -EINVAL;
 
-	err = sock_create_kern(net, sk->sk_family, SOCK_STREAM, IPPROTO_TCP,
-			       &sf);
+	err = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP, &sf);
 	if (err)
 		return err;
 

-- 
2.37.2
