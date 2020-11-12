Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182C92B044D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgKLLtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:49:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbgKLLlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:41:39 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3772C061A48;
        Thu, 12 Nov 2020 03:41:38 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i26so3958402pgl.5;
        Thu, 12 Nov 2020 03:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ufh2efn8kosWj9C5LrJElMuwpCX+AajKJO1rUrpxvvE=;
        b=bSKtDBImwRuIkiCTvKw3GL9rIsU+3m0G8QmbKOVwHtPKoOZ7K8SBztuJ0WW9Dv+ksP
         f15Y9uwFmUNrLpwBCuY+ZkF+Tiev/IjuJRtNx7zjpC2KowhUDyzQDcXp+PLbX5UPmBQj
         mPrlj5eRFpjujpNHId5LrcXNavMsC6tLoAgF1hs0hexWwMMyFndcorTrEfWzSA0SkJFP
         0y0dBoHz94JTqhhO4CFy5ntj9Go2sk6YcDIZHikP/OpA9zv6v9p5Op71oGrrxFdfNUwv
         o/wjm4JWwopiEgcSIKIyv9M1i5fYaU8R7Cc5DKCWzTSxLMXzBh4eTqgi0pc/Q80jT4iE
         j1Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ufh2efn8kosWj9C5LrJElMuwpCX+AajKJO1rUrpxvvE=;
        b=ikc0MACc7aV6Ikd44lsh/JT8Ck4FasbsVUCpXxtxhpAPAb7d6jNYBi63xwYUd4oHwX
         iXn7b+6dN81sQhw03ITlDg+Goy1KIXaC35ro7Y8WpkIWmPylC2R/GXRrk46x+jwLtHio
         9Uiw1ybVYg/YpSO5JXyPxb3C8mFQaIDFJ19TqT0N15p6tNY8SBW1PAtTyikv3xcL3er+
         rwGha6dMsfhC8n/V1D6xJuHBxxsaRut57leNi6W0mMU5r8jymotwQPWyUQ4JUGKyXMHC
         AYMgUbQaekV8exJJ/cIz70hvYLrhnx5vb89fMqBczhS5EmKIX9bkNWAt4pxb+rhNYut2
         wqpA==
X-Gm-Message-State: AOAM531Crba7C470mYkShIN7N6yRaHnrfQ2jMG9EYS965vcKHLRG+FYN
        1x2ofl9zO/sWfgc8F0q1xV8sQi9IcMHt7Q==
X-Google-Smtp-Source: ABdhPJxw6UbaNF4D+sWXKVnTkhCx6TKp3dZxRxE5k7cmnJZmyDRFE+letQWOQ87ZPeJXA6m2zz6d/w==
X-Received: by 2002:a17:90a:a501:: with SMTP id a1mr941654pjq.24.1605181297745;
        Thu, 12 Nov 2020 03:41:37 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id y8sm6161629pfe.33.2020.11.12.03.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:41:36 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next 5/9] xsk: add busy-poll support for {recv,send}msg()
Date:   Thu, 12 Nov 2020 12:40:37 +0100
Message-Id: <20201112114041.131998-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112114041.131998-1-bjorn.topel@gmail.com>
References: <20201112114041.131998-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Wire-up XDP socket busy-poll support for recvmsg() and sendmsg(). If
the XDP socket prefers busy-polling, make sure that no wakeup/IPI is
performed.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 2e5b9f27c7a3..00663390a4a8 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -23,6 +23,7 @@
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
 #include <net/xdp_sock_drv.h>
+#include <net/busy_poll.h>
 #include <net/xdp.h>
 
 #include "xsk_queue.h"
@@ -460,6 +461,16 @@ static int __xsk_sendmsg(struct sock *sk)
 	return xs->zc ? xsk_zc_xmit(xs) : xsk_generic_xmit(sk);
 }
 
+static bool xsk_no_wakeup(struct sock *sk)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	/* Prefer busy-polling, skip the wakeup. */
+	return sk->sk_prefer_busy_poll && sk->sk_ll_usec && sk->sk_napi_id >= MIN_NAPI_ID;
+#else
+	return false;
+#endif
+}
+
 static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 {
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
@@ -472,6 +483,12 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
+	if (sk_can_busy_loop(sk))
+		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
+
+	if (xsk_no_wakeup(sk))
+		return 0;
+
 	pool = xs->pool;
 	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
 		return __xsk_sendmsg(sk);
@@ -493,6 +510,12 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
+	if (sk_can_busy_loop(sk))
+		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
+
+	if (xsk_no_wakeup(sk))
+		return 0;
+
 	if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
 		return xsk_wakeup(xs, XDP_WAKEUP_RX);
 	return 0;
-- 
2.27.0

