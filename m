Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A524A2B4229
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgKPLE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:04:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgKPLE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:04:58 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62882C0613CF;
        Mon, 16 Nov 2020 03:04:57 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 81so4497467pgf.0;
        Mon, 16 Nov 2020 03:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=55VcV51XnMogBMy7CJMlxZcUUPNr6D/0rTjgteVQ9KA=;
        b=Eb0MLP0InY85o/H9yR29rjKI865fu8oh4km3jXCESOMjhvI7/8wQ9Gg6k77eexukm3
         JpGJ0bBjDN39fcdoaaw2p3lgA7szbRznG9Y8DCjfVhQ88c621YE7xqQdvSmjlbPN9t5E
         N+wfFPtS1u+U0FspH/kSUGGrwZVff1ukN1+HGqN2yoiguYGpV++8se5Qf23EkdapM9Gx
         2KQjGkGQp7Y4zPpVX6iNzHqPHf1bfa3enbDBqGpg1SdgVre1mNtm912T3YLNV9S7pZ3a
         uUx43Ra/Wz6cNguQWAgdZNmBQMCOvlQtsNLta/zBMzH/oZblA9WK0DcvXidtu8/GK/KY
         nNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=55VcV51XnMogBMy7CJMlxZcUUPNr6D/0rTjgteVQ9KA=;
        b=MIqslCb4I0fWWR4MSNdtqdpIG+rPbm5mb47A4RQzmuRUdrPitgWPJ6ZMZ6CGseq919
         TUjk91ELS3tMOp7hi7IgT60JaBE0sGpRFAW1kCCHmEoDJhBjBq/F8JmUy39X1X8sPGjy
         VevaO+ylyFFU1AU/d9NYXHrT4B7qaRZPBFCmKgMW/t2HzkZqsmUTKiOOhnYmNBknF0Jf
         Wyi5jenSzu9nR8s+uQm98mYQt0GUjUoRFpW518Sgwo552qFFVsoIxKoypUJ01x4yMBQv
         yOfTTdXLO8hUxStPqwp18CrL6xR4eDu9T06LuI/TOEc3Gv6Z0Bv/zjIKvl6utYmUyage
         Sdrw==
X-Gm-Message-State: AOAM5301pee67BdSG3vQxNIpq1qZzeWUU51Rnw0Ajqp242mTvLQsrY0k
        6r54j/Odppin/OXuXqLpTZ0dt07sdR8DBg==
X-Google-Smtp-Source: ABdhPJz6c7yWkXzKIIRD+Zsxu0WDaG3wK3dQ17YslQvOhvbLJJvdi/KWRu0EgvodlUG698Do3dTUHA==
X-Received: by 2002:a63:4a57:: with SMTP id j23mr11918750pgl.296.1605524696416;
        Mon, 16 Nov 2020 03:04:56 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id a23sm15752890pgv.35.2020.11.16.03.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 03:04:55 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: [PATCH bpf-next v2 04/10] xsk: check need wakeup flag in sendmsg()
Date:   Mon, 16 Nov 2020 12:04:10 +0100
Message-Id: <20201116110416.10719-5-bjorn.topel@gmail.com>
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
index bda23bd919ad..1cb04b5e4247 100644
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

