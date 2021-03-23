Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45073457FC
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 07:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhCWGt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 02:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbhCWGtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 02:49:32 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B81EC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 23:49:28 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id y5so654227wrp.2
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 23:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=pditvg/nc0NLp+p2M+bo/XsGI8wzVr1z5D5T5xN+BK0=;
        b=pD3GJ4+4okoHKwwo6ruL+u4wUBi7/p22gschG4mFHjG+1UHklTrafFGqEVUAEAV1VL
         HSBAfqGpmArEQJwg1bipPS3fR8+FxmB+QK++3coIYvZkZVSTkZ/ZKvnp0NhfFlynMaTx
         Lia8SWM8MPDsNxI7IG2J0WyrYJEUFn1eCV+pd5ALQq7A3hBVb/P//I9mv75CoavPoM2r
         Yrpc5b0vghqmZobcKVN+b7t7zIKD0YKt85YiGO3SVFyL5WMDojbT6YOwjyhnWz56fBZS
         fOqJ/W5XlWlrFullfwfmE3HZfMcgguY1+D4IChzQAot7rgQv/SYUpxkdwtNNG+YLaTY2
         PB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=pditvg/nc0NLp+p2M+bo/XsGI8wzVr1z5D5T5xN+BK0=;
        b=qiKsPuvDlXwgzQwPkubP+A1SSXAi6u8PoFbF3qErcKh99MzFmOBc+Ar8ndq2iGul9A
         AUzgd6EZtK2hd0rblzp16OoOsQTvySBrTNmyu12yTNg8MxcdFu840JrENzeoTE8XrnlB
         m8S+LLOkp5AG6YjJoIpQVjqUb0lhtQersrJOUCRhT1D52BbeRp2xfBRGC1EOkcKnbais
         OxO4Dhg3XuJTTV6VAhCh2hqe8pd3QlVLr3O8yLsEMk/Cjv2Vsw8EKLsvwyBylSuDjj0p
         EerWOZPMmNIWxZVTnUcnI7lXKyuMNA4eOjcKynOxxv1lnC4zq3RRSOx/+AmMbuAHnWiu
         DnfA==
X-Gm-Message-State: AOAM531kWsT1NwvDqliv2wfsDItNb9utmmjP9zvDnQDDxMlA9RCMnp4+
        R1bYSanWytkqji47XA7wbCLr75gSeDzO
X-Google-Smtp-Source: ABdhPJwCEn8gixp+xlt4DyGdnlAg3sme9Kew9fjXQeafOZX+ZOjfUZ+ilzQTeEfnQMi47mt+wi/Q5YfHX7Rp
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:15:13:d80d:9d4d:16e4:a16c])
 (user=dvyukov job=sendgmr) by 2002:a05:600c:49aa:: with SMTP id
 h42mr1828173wmp.49.1616482166965; Mon, 22 Mar 2021 23:49:26 -0700 (PDT)
Date:   Tue, 23 Mar 2021 07:49:23 +0100
Message-Id: <20210323064923.2098711-1-dvyukov@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v2] net: make unregister netdev warning timeout configurable
From:   Dmitry Vyukov <dvyukov@google.com>
To:     davem@davemloft.net, edumazet@google.com, leon@kernel.org
Cc:     Dmitry Vyukov <dvyukov@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netdev_wait_allrefs() issues a warning if refcount does not drop to 0
after 10 seconds. While 10 second wait generally should not happen
under normal workload in normal environment, it seems to fire falsely
very often during fuzzing and/or in qemu emulation (~10x slower).
At least it's not possible to understand if it's really a false
positive or not. Automated testing generally bumps all timeouts
to very high values to avoid flake failures.
Add net.core.netdev_unregister_timeout_secs sysctl to make
the timeout configurable for automated testing systems.
Lowering the timeout may also be useful for e.g. manual bisection.
The default value matches the current behavior.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=211877
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
Changes since v1:
 - use sysctl instead of a config
---
 Documentation/admin-guide/sysctl/net.rst | 11 +++++++++++
 include/linux/netdevice.h                |  1 +
 net/core/dev.c                           |  6 +++++-
 net/core/sysctl_net_core.c               | 10 ++++++++++
 4 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index f2ab8a5b6a4b8..2090bfc69aa50 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -311,6 +311,17 @@ permit to distribute the load on several cpus.
 If set to 1 (default), timestamps are sampled as soon as possible, before
 queueing.
 
+netdev_unregister_timeout_secs
+------------------------------
+
+Unregister network device timeout in seconds.
+This option controls the timeout (in seconds) used to issue a warning while
+waiting for a network device refcount to drop to 0 during device
+unregistration. A lower value may be useful during bisection to detect
+a leaked reference faster. A larger value may be useful to prevent false
+warnings on slow/loaded systems.
+Default value is 10, minimum 0, maximum 3600.
+
 optmem_max
 ----------
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 87a5d186faff4..179c5693f5119 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4611,6 +4611,7 @@ void dev_get_tstats64(struct net_device *dev, struct rtnl_link_stats64 *s);
 
 extern int		netdev_max_backlog;
 extern int		netdev_tstamp_prequeue;
+extern int		netdev_unregister_timeout_secs;
 extern int		weight_p;
 extern int		dev_weight_rx_bias;
 extern int		dev_weight_tx_bias;
diff --git a/net/core/dev.c b/net/core/dev.c
index 0f72ff5d34ba0..7accbd4a3bec1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10344,6 +10344,8 @@ int netdev_refcnt_read(const struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_refcnt_read);
 
+int netdev_unregister_timeout_secs __read_mostly = 10;
+
 #define WAIT_REFS_MIN_MSECS 1
 #define WAIT_REFS_MAX_MSECS 250
 /**
@@ -10405,7 +10407,9 @@ static void netdev_wait_allrefs(struct net_device *dev)
 
 		refcnt = netdev_refcnt_read(dev);
 
-		if (refcnt && time_after(jiffies, warning_time + 10 * HZ)) {
+		if (refcnt &&
+		    time_after(jiffies, warning_time +
+			       netdev_unregister_timeout_secs * HZ)) {
 			pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
 				 dev->name, refcnt);
 			warning_time = jiffies;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 4567de519603b..d84c8a1b280e2 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -24,6 +24,7 @@
 
 static int two = 2;
 static int three = 3;
+static int int_3600 = 3600;
 static int min_sndbuf = SOCK_MIN_SNDBUF;
 static int min_rcvbuf = SOCK_MIN_RCVBUF;
 static int max_skb_frags = MAX_SKB_FRAGS;
@@ -570,6 +571,15 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ONE,
 	},
+	{
+		.procname	= "netdev_unregister_timeout_secs",
+		.data		= &netdev_unregister_timeout_secs,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &int_3600,
+	},
 	{ }
 };
 

base-commit: e0c755a45f6fb6e81e3a62a94db0400ef0cdc046
-- 
2.31.0.291.g576ba9dcdaf-goog

