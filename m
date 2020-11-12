Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356382B044F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgKLLtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgKLLlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:41:32 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0BBC0613D4;
        Thu, 12 Nov 2020 03:41:32 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 34so680522pgp.10;
        Thu, 12 Nov 2020 03:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q3bRujA0ZEsvdVE3nlPl8w/UbQx3Egjm7KQDsrceDhQ=;
        b=OPc4PyHJzCmhUlJvJakj8YMZRC7/k7BMwWn9xaY2p1QBsde2tkG0a1U++dZwv31ozB
         rb/f3YZliOSosTl6wIZTqECJPd/lTmZhqYNpyB1Y7jdF4Qkf50YXDj6tE5T1pwgsZt9H
         c0OdmsnCL4BDB4v1cWC3pMYxDaK5WftA3PJCYigqg3C83zQlRWIZDRK2PyrgeTpsBcvu
         XiGd3Qd9O8XG5m9zKs6eZwLHZIp91l9V8+vJXuSGDkaUGH7vDBy6/dqZ/zqATMShBsPJ
         ebPNYGDT2Yx0IxB7sv6slN1n8kDSYI3Gcogg5+Qukst08Mvy1QNGurpWDsrAdV+zigxb
         d/0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q3bRujA0ZEsvdVE3nlPl8w/UbQx3Egjm7KQDsrceDhQ=;
        b=j3AERvAcmAoedUcBYJL9D/4uj3Gbwarii7C492QLbZwo9MMag99jnaMf2UlYx8IRrf
         Q11JQnid60xBz1lAXzC9aYJUMQceuYA0fHc9Mw9EpMs55JxxPdmHbBoHntq5xNl5Rb+n
         atvpzie8b1CFAYeQU4UyCoiOYIBYrzBkRr0qohso+SpXGEXiaRttZ2UR7wgu9D+VsXOU
         dahmbvW5RTlxzHPI30CH/hYV1sk5PVgCb6uPAA+h6ICp3Dks3/YUg9HEKUV0wnYJWzYG
         3C30gW1hBF7rtxHuPs1xPr+rUXYkhbj2O7pfzxCy15oFdJGOaDtCbXDwxWuMqsaEvm+6
         llFg==
X-Gm-Message-State: AOAM532kVX6yiEWSzUWdXfMCQoGA4uLF0cpJ2AvmQ1n5wataHZAsPqWT
        x+GkvqSTsRkYRssIgpxmg9i6nZLCJT/WAw==
X-Google-Smtp-Source: ABdhPJyGAUWK/n7jqeLK8/+5C+dEuN5198YndBNhBfzpWy6Y4locfICB/N9jkauhE/Jki8tyLRXrUw==
X-Received: by 2002:a17:90a:8b0e:: with SMTP id y14mr3809895pjn.57.1605181291383;
        Thu, 12 Nov 2020 03:41:31 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id y8sm6161629pfe.33.2020.11.12.03.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 03:41:30 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next 4/9] xsk: check need wakeup flag in sendmsg()
Date:   Thu, 12 Nov 2020 12:40:36 +0100
Message-Id: <20201112114041.131998-5-bjorn.topel@gmail.com>
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

Add a check for need wake up in sendmsg(), so that if a user calls
sendmsg() when no wakeup is needed, do not trigger a wakeup.

To simplify the need wakeup check in the syscall, unconditionally
enable the need wakeup flag for Tx. This has a side-effect for poll();
If poll() is called for a socket without enabled need wakeup, a Tx
wakeup is unconditionally performed.

The wakeup matrix for AF_XDP now looks like:

need wakeup | poll()       | sendmsg()   | recvmsg()
------------+--------------+-------------+------------
disabled    | wake Tx      | wake Tx     | nop
enabled     | check flag;  | check flag; | check flag;
            |   wake Tx/Rx |   wake Tx   |   wake Rx

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c           |  6 +++++-
 net/xdp/xsk_buff_pool.c | 13 ++++++-------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 17d51d1a5752..2e5b9f27c7a3 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -465,13 +465,17 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	bool need_wait = !(m->msg_flags & MSG_DONTWAIT);
 	struct sock *sk = sock->sk;
 	struct xdp_sock *xs = xdp_sk(sk);
+	struct xsk_buff_pool *pool;
 
 	if (unlikely(!xsk_is_bound(xs)))
 		return -ENXIO;
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
-	return __xsk_sendmsg(sk);
+	pool = xs->pool;
+	if (pool->cached_need_wakeup & XDP_WAKEUP_TX)
+		return __xsk_sendmsg(sk);
+	return 0;
 }
 
 static int xsk_recvmsg(struct socket *sock, struct msghdr *m, size_t len, int flags)
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 64c9e55d4d4e..a4acb5e9576f 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -144,14 +144,13 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
 	if (err)
 		return err;
 
-	if (flags & XDP_USE_NEED_WAKEUP) {
+	if (flags & XDP_USE_NEED_WAKEUP)
 		pool->uses_need_wakeup = true;
-		/* Tx needs to be explicitly woken up the first time.
-		 * Also for supporting drivers that do not implement this
-		 * feature. They will always have to call sendto().
-		 */
-		pool->cached_need_wakeup = XDP_WAKEUP_TX;
-	}
+	/* Tx needs to be explicitly woken up the first time.  Also
+	 * for supporting drivers that do not implement this
+	 * feature. They will always have to call sendto() or poll().
+	 */
+	pool->cached_need_wakeup = XDP_WAKEUP_TX;
 
 	dev_hold(netdev);
 
-- 
2.27.0

