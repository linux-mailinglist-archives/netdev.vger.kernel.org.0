Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A68AE2B8D4D
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 09:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgKSIbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 03:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbgKSIbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 03:31:15 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A6CC0613CF;
        Thu, 19 Nov 2020 00:31:13 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id 34so3556238pgp.10;
        Thu, 19 Nov 2020 00:31:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aCTEvKvaohGdF6Bs/IDmMS8lzGvtuo4EDdbcxsDGwF0=;
        b=Mg2QpAmf9d/0N2dmBAiPkgh2ogpNtO2WsocIYLzzU8Wg2o5CoF4w9jBwmqnqEP2r4C
         aR10Cix2hppfauz9nBqXkqgZS6fa8VitRTqPxAoJk4plQasOs8FJqUtHguEUfJTGJfCe
         xBAXMVTpaifz4eUB7lmf0HjaJDjFh/55lHY0U5+alzbz+vpEla9a2Hl5uNbDFOjBBzHH
         /MCUTY3YIafAiSVcfoXnYGBJO7IgL7t1ankygzFte4vDC+eBgShxsXgDbRBprzzBvd59
         CHU/sbaWVCz0wIEoaQSci1G7ipCuM2iexYH9Mj2Q1SbD0es4Wd6+hhfqFLWQtl4Hy6hs
         K9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aCTEvKvaohGdF6Bs/IDmMS8lzGvtuo4EDdbcxsDGwF0=;
        b=KTF4kruTsfF4MzBrnB4SbCRGBeDQw0buZ6uMExxAMrNmzysH2vtlXKsZQkHlukgKGy
         IVZUcwEO1cFCiNqS3PSiY/lLt25O4ej7bSDiN5q0IjPxShzqPhcXAVc/LrCRy2lWKreR
         afbpBOY5Hey9YrbTbdCgeGT1PdY/h5oiT/2U5Q4aG2XPhiL+6Pyj1unEc6Hr0iJOMep+
         IetQCGbUpfUnKsQ9Pa3lLhk/Cgzdiy1HuOqA63aODLzohWZAJEyXCfZpbZeOWJqfsCNk
         B9LcygwxF1LbSYHdFY+IyC4uVUux3vMGZ6o5M4kVgepeTkJPCgAcnxs0Gc4YaDcsmtrw
         QeXA==
X-Gm-Message-State: AOAM532xCDLUkMqWNhdqWo4dZNT+MVxGhrJaH7cVaYmfNL2VfIjtGiwH
        wskl0YrXOb1d+1Qn5uqxwC5siYH3c1HcLOvx
X-Google-Smtp-Source: ABdhPJweVSSm1SdW+OanSq3AcWlxaEdM3npdk2j4vJvW1GzhCmZbbEKY+o50OksKUtrpwZZpcjHOog==
X-Received: by 2002:a17:90a:4482:: with SMTP id t2mr3202574pjg.44.1605774672928;
        Thu, 19 Nov 2020 00:31:12 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id r2sm5517713pji.55.2020.11.19.00.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 00:31:11 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v3 04/10] xsk: check need wakeup flag in sendmsg()
Date:   Thu, 19 Nov 2020 09:30:18 +0100
Message-Id: <20201119083024.119566-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201119083024.119566-1-bjorn.topel@gmail.com>
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
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
index 56a52ec75696..bf0f5c34af6c 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -522,13 +522,17 @@ static int xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
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
index 8a3bf4e1318e..96bb607853ad 100644
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

