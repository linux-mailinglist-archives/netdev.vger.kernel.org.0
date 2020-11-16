Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBAC2B422C
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729680AbgKPLFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgKPLFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:05:03 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2C1FC0613CF;
        Mon, 16 Nov 2020 03:05:03 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id y7so13739695pfq.11;
        Mon, 16 Nov 2020 03:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J/sQUNnR8paYLJkCpzOYLa3M/4T86xKuicfaQEy6v/Y=;
        b=CPB6QtpFkGUGzO14hoo/7aPj6dCnxJsmViCIqSCstC7t07M31cAebsZ2fC8XA/TXIR
         3O5izqkuaUnF4YU5ob/uhZJDxqnbKnKP/XyGUmvC9QI+UMn4ZSBqJkKLVG+hjQvWZ+IP
         mQzRG3IhHFsY0goeT3N09r6Nde/NUywnf/dYO9PIjsr2Cp5xRgV2wRE5HqKs1E2gtoiH
         mUqGm7f0AzCO9wYEhak3YYqyqvkZj8uV1nWsRXBwrah4iizVdnzolnxV4w2Ev+VEkVxW
         3l2MCjKyvvqvKrpbBBVpjvygDQz/gbh4sHlbm4IdCVd+qww7KamGv538/1pPm3gehQYG
         QZew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J/sQUNnR8paYLJkCpzOYLa3M/4T86xKuicfaQEy6v/Y=;
        b=XRDxBl6y9fcMK8L3p5/t3C4/XXtIavoObUZhstpztKJLaWt2WuoWh+Q1IJa5EjjZlB
         KmDXbQi3AlypTTI9AARvh6wwQHkJS6/iJ2T/Czx56WequceucpWsGQVtMYPKKueWyCCL
         mqdikopnic/tJntyI0uFjlVY5k4we65040Avf3vI7iTP2dlp1Aw/cocNstl03EFGNLkC
         vH/tx1JTMl77YhsBJAlyVgtCjMtTi1RozKNeIyJTJnta0I9KVP8yLfzS5obFvNTb/q0H
         vAAC2hWaH0qpsGxRO4zDpNSg8y9KwlOjIgMxQ/0DDJ1IwtwyWxBinKSIib6Ko3avnsCe
         BqCA==
X-Gm-Message-State: AOAM530k1Zttn1JX7mHoVviKrhigqj3sfT0v47yTXW3rTDBT6fLtrK0s
        /JaUVL+geVbnjiZ/mp4NQHqJgBujxjvKQQ==
X-Google-Smtp-Source: ABdhPJwVTyqvQ7aPoPc/6aRXHes3j91pRHx3x7BB4/o3gcOoqsiUq+mVPbb8vTh5lvJKMPgBi2gqwQ==
X-Received: by 2002:a63:6341:: with SMTP id x62mr12537625pgb.93.1605524702337;
        Mon, 16 Nov 2020 03:05:02 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id a23sm15752890pgv.35.2020.11.16.03.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 03:05:01 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v2 05/10] xsk: add busy-poll support for {recv,send}msg()
Date:   Mon, 16 Nov 2020 12:04:11 +0100
Message-Id: <20201116110416.10719-6-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201116110416.10719-1-bjorn.topel@gmail.com>
References: <20201116110416.10719-1-bjorn.topel@gmail.com>
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
 net/xdp/xsk.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 1cb04b5e4247..a71a14fedfec 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -23,6 +23,7 @@
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
 #include <net/xdp_sock_drv.h>
+#include <net/busy_poll.h>
 #include <net/xdp.h>
 
 #include "xsk_queue.h"
@@ -460,6 +461,17 @@ static int __xsk_sendmsg(struct sock *sk)
 	return xs->zc ? xsk_zc_xmit(xs) : xsk_generic_xmit(sk);
 }
 
+static bool xsk_no_wakeup(struct sock *sk)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	/* Prefer busy-polling, skip the wakeup. */
+	return READ_ONCE(sk->sk_prefer_busy_poll) && READ_ONCE(sk->sk_ll_usec) &&
+		READ_ONCE(sk->sk_napi_id) >= MIN_NAPI_ID;
+#else
+	return false;
+#endif
+}
+
 static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 {
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
@@ -472,6 +484,12 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
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
@@ -493,6 +511,12 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
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

