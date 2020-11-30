Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148772C8D4F
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387597AbgK3Sxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:53:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727994AbgK3Sx3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:53:29 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F141C0613D4;
        Mon, 30 Nov 2020 10:52:49 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id l4so4555164pgu.5;
        Mon, 30 Nov 2020 10:52:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ROQPewlDIZikhUQm8VWG2wYdta6lahk0LWlwgo5VsUU=;
        b=f/N8v4HywGPMyIs5jYMKdayJDHXJ+XxuqdxmWZ8SBOcSkyoYPFe7FzSxb3WREwvkPQ
         rjDZi2+M7F1V9OWwRmSn/SxyWOpeT80yTWUG1FNfOYqzsp5Vi+DbYolDNvsHOnl3swSx
         ClQPvYGUsCLhQAHAzGVUKMfcdbn2sxIFvssiPts5gi9GQuvSy+znDPjI/z9VCjo+U439
         ZhIJMwLSatlxAdi4jdOdl09pfBX2bVNck8Bgr1MRpQkNg8LNt2AloRO9N0Mgcry/rGA7
         7/vdeDeYVIAfjq6w1GVxhfx8ZPaMjVoBL6S3A8Nmfq93WAEZCsDTDBuIoqtdwzcytZE9
         4jug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ROQPewlDIZikhUQm8VWG2wYdta6lahk0LWlwgo5VsUU=;
        b=AsKgYTjDArXdMv6wBhcYvz3vvUlbkWeZIbI9reXa30eS7j3C1XIn2wP1pz+/giZOIU
         BaglR6YvR4mhwPEBEoSS5+iBPJJz4Vk88TavCv/ywQQ2RKr/xe37e+2tKF/81nR1lnwi
         Be/1c4Aba1zPYaV9LfcjeNRIXdps3Hxgeigcj10ZEVDaTvFLwkf2Y5EDy+6aUbPn5fwu
         ZUVcSzi4MGyP0XIHvr7p0sacp4L2FEuhygqLQBfrIu+vxQs2/cUbtfuj/Bdut99tIRKk
         yZZjXTr5IIIR9wM535w++83pe1AcJgnpH3hDRKbgFR4Cn6VTuVIVIjI8ZZKzTVoZ7VdN
         zoJw==
X-Gm-Message-State: AOAM532z769rIEGf+bG/EWfjYUW6f9lJUfxKV+BoYi6r+m3Wmj3kqwge
        jdu8viFkwwdj6yU05CGHocyzgI9k0oS4V1/i
X-Google-Smtp-Source: ABdhPJxwGTC1uc2X1fuPER+0GYkFTroSL/pkerjOYqTcT4Mdjjs64SYS1bLFcZlbnP52+MoF5biX8g==
X-Received: by 2002:a63:5f49:: with SMTP id t70mr13091194pgb.288.1606762368611;
        Mon, 30 Nov 2020 10:52:48 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id i3sm12005978pgq.12.2020.11.30.10.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:52:47 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v4 03/10] xsk: add support for recvmsg()
Date:   Mon, 30 Nov 2020 19:51:58 +0100
Message-Id: <20201130185205.196029-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201130185205.196029-1-bjorn.topel@gmail.com>
References: <20201130185205.196029-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Add support for non-blocking recvmsg() to XDP sockets. Previously,
only sendmsg() was supported by XDP socket. Now, for symmetry and the
upcoming busy-polling support, recvmsg() is added.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3e33cb6e68e6..1d1e0cd51a95 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -531,6 +531,26 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	return __xsk_sendmsg(sk);
 }
 
+static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
+{
+	bool need_wait = !(flags & MSG_DONTWAIT);
+	struct sock *sk = sock->sk;
+	struct xdp_sock *xs = xdp_sk(sk);
+
+	if (unlikely(!(xs->dev->flags & IFF_UP)))
+		return -ENETDOWN;
+	if (unlikely(!xs->rx))
+		return -ENOBUFS;
+	if (unlikely(!xsk_is_bound(xs)))
+		return -ENXIO;
+	if (unlikely(need_wait))
+		return -EOPNOTSUPP;
+
+	if (xs->pool->cached_need_wakeup & XDP_WAKEUP_RX && xs->zc)
+		return xsk_wakeup(xs, XDP_WAKEUP_RX);
+	return 0;
+}
+
 static __poll_t xsk_poll(struct file *file, struct socket *sock,
 			     struct poll_table_struct *wait)
 {
@@ -1191,7 +1211,7 @@ static const struct proto_ops xsk_proto_ops = {
 	.setsockopt	= xsk_setsockopt,
 	.getsockopt	= xsk_getsockopt,
 	.sendmsg	= xsk_sendmsg,
-	.recvmsg	= sock_no_recvmsg,
+	.recvmsg	= xsk_recvmsg,
 	.mmap		= xsk_mmap,
 	.sendpage	= sock_no_sendpage,
 };
-- 
2.27.0

