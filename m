Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA23344E67
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbhCVSWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 14:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbhCVSVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 14:21:54 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D3FC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 11:21:52 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id u19so9169622pgh.10
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 11:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nxd4ehcRB+EzIkIZyZJwvOpb0K1GzeoO8rHw1Rz9f3Q=;
        b=kGJeeEvjaGriSgnyk8W1MH1bDThpV6t8ZTdKXua0Q/Lflqe4e05bvXLY6Q5ndylO1i
         il6QUkRjNxcQpN/Pl0Xhip7ua5JBg8CB3R2qx1yLfaNxUcLgkUtCJ599/IdgnCx6h15O
         epDE8iyIxVXKDs7bGHWLENYL0ChxkVaubvkr6l7QBY7ooxlO1RKFYhYubl67BvFMWo48
         1rl4GCtUfiGv3OvPiOsLbr8LySq+MXr63DmL8LdtAPlcemCT6ByCbPr9juO96u/1Wc/P
         ZsezjNu0mnijES63EuEszfjN6ne2YFf/KztuzWVncVmfuXiBpaKvAnT2l7yyFSeVDY2l
         ZefQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Nxd4ehcRB+EzIkIZyZJwvOpb0K1GzeoO8rHw1Rz9f3Q=;
        b=hPKS09TIqrjV+7sf8FmeMxB3jV1ZL9YYwQf+C9qFMLPVLPKHwJys3gAWncvjXE1mVs
         I4WYRc7yHBUdjOckWNYpEIdQrnvJepc0/RdBFczl2eXcHMt7FYGKniBjrVPDgxZ/U6ax
         L0eJD9E/yhvwb0aMU1IOJMXyfeT6OHuwgyMraWt7LHshLC9gQ9jOF7z4t25n9IAhDjUZ
         JTdRMVbLfx63RKDwNRtyriDvEHedPAHG7ADSFcBMVlXBb5WDjEvpSMj5dUAgRGB7nnZW
         +MTNL9wZ9f2rpPBmyko2bX3GC8QiV/eJmQNWXnDBaPvWGs4V5nuwuhDVKkdGuu7bIQPl
         mg5w==
X-Gm-Message-State: AOAM533MTW+NjFxdDcr2yrle0f/HL18lmChtyqFHsY8C+znfasT7f3qa
        cdXwjlMcl00I7vUtUCcZgTc=
X-Google-Smtp-Source: ABdhPJxV0WBsQ35Zg8e+MXhA5BOYVG89MMzHyHUE0DqTlyHaDpLEePPO39rNZGQcwxVRXX/2vTWQwA==
X-Received: by 2002:a63:c84a:: with SMTP id l10mr716964pgi.159.1616437312421;
        Mon, 22 Mar 2021 11:21:52 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2ce7:87d:6920:2d0])
        by smtp.gmail.com with ESMTPSA id g18sm14320837pfb.178.2021.03.22.11.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:21:51 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Guenter Roeck <groeck@google.com>
Subject: [PATCH net-next] net: set initial device refcount to 1
Date:   Mon, 22 Mar 2021 11:21:45 -0700
Message-Id: <20210322182145.531377-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

When adding CONFIG_PCPU_DEV_REFCNT, I forgot that the
initial net device refcount was 0.

When CONFIG_PCPU_DEV_REFCNT is not set, this means
the first dev_hold() triggers an illegal refcount
operation (addition on 0)

refcount_t: addition on 0; use-after-free.
WARNING: CPU: 0 PID: 1 at lib/refcount.c:25 refcount_warn_saturate+0x128/0x1a4

Fix is to change initial (and final) refcount to be 1.

Also add a missing kerneldoc piece, as reported by
Stephen Rothwell.

Fixes: 919067cc845f ("net: add CONFIG_PCPU_DEV_REFCNT")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Guenter Roeck <groeck@google.com>
---
 include/linux/netdevice.h | 1 +
 net/core/dev.c            | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8f003955c485b81210ed56f7e1c24080b4bb46eb..b11c2c1890b2a28ba2d02fc4466380703a12efaf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1792,6 +1792,7 @@ enum netdev_ml_priv_type {
  *
  *	@proto_down_reason:	reason a netdev interface is held down
  *	@pcpu_refcnt:		Number of references to this device
+ *	@dev_refcnt:		Number of references to this device
  *	@todo_list:		Delayed register/unregister
  *	@link_watch_list:	XXX: need comments on this one
  *
diff --git a/net/core/dev.c b/net/core/dev.c
index be941ed754ac71d0839604bcfdd8ab67c339d27f..95c78279d900796c8a3ed0df59b168d5c5e0e309 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10348,7 +10348,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
 	rebroadcast_time = warning_time = jiffies;
 	refcnt = netdev_refcnt_read(dev);
 
-	while (refcnt != 0) {
+	while (refcnt != 1) {
 		if (time_after(jiffies, rebroadcast_time + 1 * HZ)) {
 			rtnl_lock();
 
@@ -10385,7 +10385,7 @@ static void netdev_wait_allrefs(struct net_device *dev)
 
 		refcnt = netdev_refcnt_read(dev);
 
-		if (refcnt && time_after(jiffies, warning_time + 10 * HZ)) {
+		if (refcnt != 1 && time_after(jiffies, warning_time + 10 * HZ)) {
 			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
 				 dev->name, refcnt);
 			warning_time = jiffies;
@@ -10461,7 +10461,7 @@ void netdev_run_todo(void)
 		netdev_wait_allrefs(dev);
 
 		/* paranoia */
-		BUG_ON(netdev_refcnt_read(dev));
+		BUG_ON(netdev_refcnt_read(dev) != 1);
 		BUG_ON(!list_empty(&dev->ptype_all));
 		BUG_ON(!list_empty(&dev->ptype_specific));
 		WARN_ON(rcu_access_pointer(dev->ip_ptr));
@@ -10682,6 +10682,9 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 	dev->pcpu_refcnt = alloc_percpu(int);
 	if (!dev->pcpu_refcnt)
 		goto free_dev;
+	dev_hold(dev);
+#else
+	refcount_set(&dev->dev_refcnt, 1);
 #endif
 
 	if (dev_addr_init(dev))
-- 
2.31.0.291.g576ba9dcdaf-goog

