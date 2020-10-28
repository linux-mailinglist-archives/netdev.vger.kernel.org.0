Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D835629DA70
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 00:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390293AbgJ1XXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 19:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389991AbgJ1XWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 19:22:42 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792FCC0613CF;
        Wed, 28 Oct 2020 16:22:42 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id u127so1362844oib.6;
        Wed, 28 Oct 2020 16:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y6HWVZiVbe0DlTeVilFZZF5KBmHXDNnXyxJw5KGNE18=;
        b=Q9pVa6xIH+HoZ+K1VGiQHxhDmSJCKl7x7+ZbKUN+1xgaFlZPQuHBPSYv5HYuTA0sjG
         LaBrJYUGQdfYPMrxeuLTCcoLcIdvfoyLKCgD7ctg9GhjENImdx+SP4vUIz3jxNzJax00
         KzTrt0WGUUcaVDXm2LnN12lN30pJptzbO0zN4RL/FSLHYsv/H9aUFTnj4kX35RAW+xzI
         2kQ0qioK0hLQ7eZDqfUs3BDOnpbhE3mkNc//l4MlMpMe0/e86tfXaORAtZ5ZT7v/WJUH
         LxhfRoWvRFmbHww3nS6kAmBDTl5Gc5meNz4ZAo/GWNGbR/0ivPMwYTrnoTIqxcUZ4uSV
         mC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y6HWVZiVbe0DlTeVilFZZF5KBmHXDNnXyxJw5KGNE18=;
        b=m6/kUnJ+AqPYQ2ZgncTLXYzEX4RI5WDWSbx3AgseD8/+BpOuscxi11of5Sspi257tu
         CK3vWN5f/oVwoxALf8ZRjWGKmFdtq2f0J6KrmKUY5qUrx23ubr08qOUCPtNr9/8Vj9kt
         ueixVsZGaqVJAAdrWITbKsWSPmxVZ3nhxS3UTuQnxWnACfsBhR5pzbAZ6DD0Ih1CNotj
         g5EMRlyzWvDZvv8RcKpfCWnihZNbAm9L8ERp/Rzx6UD8xf9JxQ92njTe85Phez/vkrdR
         RxoOajhXwYzzNAbNXw2ZQZge77TTgEn2SxEUNMOoHA2Z/U0CfUYuMuSDEdOkunpvl3LS
         PlhQ==
X-Gm-Message-State: AOAM533LBdxZ1OEswZhCUIri2oAQ9CIQM6hV7df9JBgMLYDCbQqs2TAV
        b9BJp4ONtDrvD6rrPk2JurIPW0gKuClv8eiW
X-Google-Smtp-Source: ABdhPJyLrY/Dmb/oakRjXGVfkc2hQL0ea2nhABJdqF8y6eKgUaX7nxSXT40wSwQ545JBnNZK8RbSXQ==
X-Received: by 2002:a17:90b:204:: with SMTP id fy4mr7400019pjb.156.1603892127374;
        Wed, 28 Oct 2020 06:35:27 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.43])
        by smtp.gmail.com with ESMTPSA id q14sm5935393pjp.43.2020.10.28.06.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 06:35:26 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        maciej.fijalkowski@intel.com, sridhar.samudrala@intel.com,
        jesse.brandeburg@intel.com, qi.z.zhang@intel.com, kuba@kernel.org,
        edumazet@google.com, intel-wired-lan@lists.osuosl.org,
        jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 4/9] xsk: check need wakeup flag in sendmsg()
Date:   Wed, 28 Oct 2020 14:34:32 +0100
Message-Id: <20201028133437.212503-5-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028133437.212503-1-bjorn.topel@gmail.com>
References: <20201028133437.212503-1-bjorn.topel@gmail.com>
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

need wakeup | poll()                 | sendmsg()           | recvmsg()
------------+------------------------+---------------------+---------------------
disabled    | wake Tx                | wake Tx             | nop
enabled     | check flag; wake Tx/Rx | check flag; wake Tx | check flag; wake Rx

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

