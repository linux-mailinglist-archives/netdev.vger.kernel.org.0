Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A372C8D54
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388038AbgK3Sxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:53:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387973AbgK3Sxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:53:50 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F314C0617A6;
        Mon, 30 Nov 2020 10:53:03 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id n137so11018652pfd.3;
        Mon, 30 Nov 2020 10:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LH7Sw3V4LJlwW+1kWBdhvDdansinX+voulSeYgx/7Lg=;
        b=uNhAZky2zYu+v3GclfTq8LqVHaF+bdWnvmUrOKBgl2ap333LZFiqfYbxaU30Q66+iA
         1Qum1y4rz44gyjSV5N+z5SzzGuP8zGKL3liWiPTTJZKE6eylB+itNdCiCt+0oIXeOlGm
         dPIheOUW5D1+zL+nVC0CAJ1YGp6GIkzdaru0048d2E8h0X//Dww/8jzQVcuQjW0ZvMPv
         C90Udk8w5kAOx8KYROSfT0TqembDYcHD8K9CWsZttIzo9aEd2qEXB5jLD/1WtL5UYlef
         8gAEE0RVCFpW1/1fE6+qCC79TPXgSmp0sHWAEyEMe2Gsfger3xVONCp5ltmKDVWnkpnV
         wksA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LH7Sw3V4LJlwW+1kWBdhvDdansinX+voulSeYgx/7Lg=;
        b=cwRrqZCLBgWXjRsmrrWgt3K4ZmnPRBVjtXXU2ULcjn0iHPDPjhh/iYDgdW9No1mFHf
         4rzojJKjMwNlUNxQnhrcmcEdAROc/qrG/qLzUa8atp8N4AZmBONLIMjnvhu4IvuU04Ph
         q9Drm1ZHTCkEDaTN6l3wl+x2Ubfc7KETp8j+RYDxyjJB8WXfmrJJiXXi/6JmFw5l2rbH
         Z2VZDzsl43tcM53GDssXJnBRT1gLPS7swCgcU3tcHgxIZlSlsQMULgfzcpSHhbt0KM8G
         X7g8LPbPv8IQSKlByGwRlWwtFe5CL71Tomr/uIOULrgaYLx4mkVPbWfGNPDHoWni39Io
         8m/Q==
X-Gm-Message-State: AOAM531rdz0KvMJ8zVErzc9SMs7qyIiZsP71AftDxIP2QKrOTc51k7bu
        3IH6UlW3kYZHmNCi+uYvELcFbJH2ALmtDwZ7
X-Google-Smtp-Source: ABdhPJxSE+kIDXb53rslbZiaeJSanGiMwErLImrKX10TaqiWmSbuon6pUF2ujbj3wh7oB6DuzhAZHA==
X-Received: by 2002:a63:2351:: with SMTP id u17mr2834290pgm.72.1606762382018;
        Mon, 30 Nov 2020 10:53:02 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id i3sm12005978pgq.12.2020.11.30.10.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:53:01 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v4 05/10] xsk: add busy-poll support for {recv,send}msg()
Date:   Mon, 30 Nov 2020 19:52:00 +0100
Message-Id: <20201130185205.196029-6-bjorn.topel@gmail.com>
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

Wire-up XDP socket busy-poll support for recvmsg() and sendmsg(). If
the XDP socket prefers busy-polling, make sure that no wakeup/IPI is
performed.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index c72b4dba2878..a8501a5477cf 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -23,6 +23,7 @@
 #include <linux/netdevice.h>
 #include <linux/rculist.h>
 #include <net/xdp_sock_drv.h>
+#include <net/busy_poll.h>
 #include <net/xdp.h>
 
 #include "xsk_queue.h"
@@ -517,6 +518,17 @@ static int __xsk_sendmsg(struct sock *sk)
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
@@ -529,6 +541,12 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
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
@@ -550,6 +568,12 @@ static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int fl
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

