Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CA452411B
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349397AbiEKXiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349382AbiEKXiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:38:10 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8726D951
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:08 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id e24so3625490pjt.2
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kd9mGCouSC4r1agU0tm4NQVZAdOkhAaqRidEJfSBRdw=;
        b=F6Qp3ctXJB3s4iaTMP7gcgFyX20A/Q1v9s7uIiFZwKL+VsmztqyFgE7akLHyxZHUvi
         Ljv1e+GgPKZksorNFYfa93kia63w0Vn6Bt3CPdXBnn9K38pA9KkCTwA00W2LgX2pxvLB
         q+kOpoK9AbIe2VxPbbtDgxmXrxhqnhDF1rPBxKoRTL43livEhhijtGHbO14LfZXHOdbm
         HtKgq2ugaTi4Js9tehvA51ySOltemmwxVwa+T9so8j4vRl6cNmz69Q80oPLg9z/6Zbgk
         EpjgM5A3RdXqw4JzD2xan0nY6lzJJoyWnPXFc8/I4B9II2qasp3dJcNIdHgliwkj7XO+
         ZpXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kd9mGCouSC4r1agU0tm4NQVZAdOkhAaqRidEJfSBRdw=;
        b=sZoN+10RCSRwQswV7L49xh3FA0Z0toIsNvi26ki6162mOt9Oi5TvNR+UqY9El/wF0f
         /1hazbu2QkNxwA2UTLfHWOFwlZjzOBSiP9Tw5MhtkxDoB/K+BQLdNi8a7h5tt2yWsBXf
         uk0HnoYQ8Kc6nMcjjer86jmPWu7n5FWh2FeZNzEQpAB8AIBCEaeGrU8vdcO6wgG1DEdy
         vWWuw9l06S6Bh0Kch2oWEnO6RcKRnBpZXbRvHuGia8Btnx+2s6fsKGDbCFvELHlPnFzA
         2DDKks4iWwGVT6qLJdQP4iagVsW+GwIfibbsZqeMq1osehoxU4n5pqZnakzutHl/Hz4V
         xbzg==
X-Gm-Message-State: AOAM5337cw5XVycTnTP/e+w9IAT3jkFyzM8QCWt1zhkqnkCUix56YUEY
        PAcc3rMRTarB1seNUkLAMZ4=
X-Google-Smtp-Source: ABdhPJxwRxwsrLKVlamUtlSdglWxycRtv9CK+6eFR7eyPFrE+kl9IZYRmM6KWCjDfs/HoG/CcQ3Fmg==
X-Received: by 2002:a17:902:7783:b0:15f:21f8:a1d6 with SMTP id o3-20020a170902778300b0015f21f8a1d6mr11233956pll.66.1652312288307;
        Wed, 11 May 2022 16:38:08 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:4ded:7658:34ff:528e])
        by smtp.gmail.com with ESMTPSA id x6-20020a623106000000b0050dc76281acsm2308668pfx.134.2022.05.11.16.38.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 16:38:08 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 04/10] net: core: add READ_ONCE/WRITE_ONCE annotations for sk->sk_bound_dev_if
Date:   Wed, 11 May 2022 16:37:51 -0700
Message-Id: <20220511233757.2001218-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220511233757.2001218-1-eric.dumazet@gmail.com>
References: <20220511233757.2001218-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

sock_bindtoindex_locked() needs to use WRITE_ONCE(sk->sk_bound_dev_if, val),
because other cpus/threads might locklessly read this field.

sock_getbindtodevice(), sock_getsockopt() need READ_ONCE()
because they run without socket lock held.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 6b287eb5427b32865d25fc22122fefeff3a4ccf5..2500f9989117441a67ce2c457af25bf8f780b110 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -635,7 +635,9 @@ static int sock_bindtoindex_locked(struct sock *sk, int ifindex)
 	if (ifindex < 0)
 		goto out;
 
-	sk->sk_bound_dev_if = ifindex;
+	/* Paired with all READ_ONCE() done locklessly. */
+	WRITE_ONCE(sk->sk_bound_dev_if, ifindex);
+
 	if (sk->sk_prot->rehash)
 		sk->sk_prot->rehash(sk);
 	sk_dst_reset(sk);
@@ -713,10 +715,11 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
 {
 	int ret = -ENOPROTOOPT;
 #ifdef CONFIG_NETDEVICES
+	int bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
 	struct net *net = sock_net(sk);
 	char devname[IFNAMSIZ];
 
-	if (sk->sk_bound_dev_if == 0) {
+	if (bound_dev_if == 0) {
 		len = 0;
 		goto zero;
 	}
@@ -725,7 +728,7 @@ static int sock_getbindtodevice(struct sock *sk, char __user *optval,
 	if (len < IFNAMSIZ)
 		goto out;
 
-	ret = netdev_get_name(net, devname, sk->sk_bound_dev_if);
+	ret = netdev_get_name(net, devname, bound_dev_if);
 	if (ret)
 		goto out;
 
@@ -1861,7 +1864,7 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_BINDTOIFINDEX:
-		v.val = sk->sk_bound_dev_if;
+		v.val = READ_ONCE(sk->sk_bound_dev_if);
 		break;
 
 	case SO_NETNS_COOKIE:
-- 
2.36.0.512.ge40c2bad7a-goog

