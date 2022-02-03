Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831844A874C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351658AbiBCPJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:09:22 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:24924 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235565AbiBCPJV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 10:09:21 -0500
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app4 (Coremail) with SMTP id cS_KCgCnHSkN8PthWcOkCA--.54810S2;
        Thu, 03 Feb 2022 23:09:05 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     dan.carpenter@oracle.com, thomas@osteried.de, jreuter@yaina.de,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH] ax25: fix reference count leaks of ax25_dev
Date:   Thu,  3 Feb 2022 23:08:11 +0800
Message-Id: <20220203150811.42256-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgCnHSkN8PthWcOkCA--.54810S2
X-Coremail-Antispam: 1UD129KBjvJXoW3JFy5Jr1DKFW5ZFW8uw4fuFg_yoWxtr18pF
        W0kayrArWktF47Ar4rGw4xWF15AryIv39rXryUuF1Ikw1rX3s8JF18tryUKry3GrWfAr18
        X34DXr45Ar48AF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvm1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2
        z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnU
        UI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous commit d01ffb9eee4a ("ax25: add refcount in ax25_dev
to avoid UAF bugs") introduces refcount into ax25_dev, but there
are reference leak paths in ax25_ctl_ioctl(), ax25_fwd_ioctl(),
ax25_rt_add(), ax25_rt_del() and ax25_rt_opt().

This patch uses ax25_dev_put() and adjusts the position of
ax25_addr_ax25dev() to fix reference cout leaks of ax25_dev.

Fixes: d01ffb9eee4a ("ax25: add refcount in ax25_dev to avoid UAF bugs")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 include/net/ax25.h    |  8 +++++---
 net/ax25/af_ax25.c    | 12 ++++++++----
 net/ax25/ax25_dev.c   | 24 +++++++++++++++++-------
 net/ax25/ax25_route.c | 16 +++++++++++-----
 4 files changed, 41 insertions(+), 19 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 50b417df622..8221af1811d 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -294,10 +294,12 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
 	}
 }
 
-#define ax25_dev_hold(__ax25_dev) \
-	refcount_inc(&((__ax25_dev)->refcount))
+static inline void ax25_dev_hold(ax25_dev *ax25_dev)
+{
+	refcount_inc(&ax25_dev->refcount);
+}
 
-static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)
+static inline void ax25_dev_put(ax25_dev *ax25_dev)
 {
 	if (refcount_dec_and_test(&ax25_dev->refcount)) {
 		kfree(ax25_dev);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 32f61978ff2..3e49d28824e 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -359,21 +359,25 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	if (copy_from_user(&ax25_ctl, arg, sizeof(ax25_ctl)))
 		return -EFAULT;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr)) == NULL)
-		return -ENODEV;
-
 	if (ax25_ctl.digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
 	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr);
+	if (!ax25_dev)
+		return -ENODEV;
+
 	digi.ndigi = ax25_ctl.digi_count;
 	for (k = 0; k < digi.ndigi; k++)
 		digi.calls[k] = ax25_ctl.digi_addr[k];
 
-	if ((ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev)) == NULL)
+	ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev);
+	if (!ax25) {
+		ax25_dev_put(ax25_dev);
 		return -ENOTCONN;
+	}
 
 	switch (ax25_ctl.cmd) {
 	case AX25_KILL:
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 770b787fb7b..d2a244e1c26 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -85,8 +85,8 @@ void ax25_dev_device_up(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
-	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
+	ax25_dev_hold(ax25_dev);
 
 	ax25_register_dev_sysctl(ax25_dev);
 }
@@ -115,8 +115,8 @@ void ax25_dev_device_down(struct net_device *dev)
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
-		ax25_dev_put(ax25_dev);
 		spin_unlock_bh(&ax25_dev_lock);
+		ax25_dev_put(ax25_dev);
 		dev->ax25_ptr = NULL;
 		dev_put_track(dev, &ax25_dev->dev_tracker);
 		ax25_dev_put(ax25_dev);
@@ -126,8 +126,8 @@ void ax25_dev_device_down(struct net_device *dev)
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
-			ax25_dev_put(ax25_dev);
 			spin_unlock_bh(&ax25_dev_lock);
+			ax25_dev_put(ax25_dev);
 			dev->ax25_ptr = NULL;
 			dev_put_track(dev, &ax25_dev->dev_tracker);
 			ax25_dev_put(ax25_dev);
@@ -150,25 +150,35 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 
 	switch (cmd) {
 	case SIOCAX25ADDFWD:
-		if ((fwd_dev = ax25_addr_ax25dev(&fwd->port_to)) == NULL)
+		fwd_dev = ax25_addr_ax25dev(&fwd->port_to);
+		if (!fwd_dev) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
-		if (ax25_dev->forward != NULL)
+		}
+		if (ax25_dev->forward) {
+			ax25_dev_put(fwd_dev);
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = fwd_dev->dev;
 		ax25_dev_put(fwd_dev);
+		ax25_dev_put(ax25_dev);
 		break;
 
 	case SIOCAX25DELFWD:
-		if (ax25_dev->forward == NULL)
+		if (!ax25_dev->forward) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = NULL;
+		ax25_dev_put(ax25_dev);
 		break;
 
 	default:
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
 	}
 
-	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index 1e32693833e..9751207f775 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -75,11 +75,13 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_dev *ax25_dev;
 	int i;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
-		return -EINVAL;
 	if (route->digi_count > AX25_MAX_DIGIS)
 		return -EINVAL;
 
+	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
+	if (!ax25_dev)
+		return -EINVAL;
+
 	write_lock_bh(&ax25_route_lock);
 
 	ax25_rt = ax25_route_list;
@@ -91,6 +93,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 			if (route->digi_count != 0) {
 				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 					write_unlock_bh(&ax25_route_lock);
+					ax25_dev_put(ax25_dev);
 					return -ENOMEM;
 				}
 				ax25_rt->digipeat->lastrepeat = -1;
@@ -101,6 +104,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 				}
 			}
 			write_unlock_bh(&ax25_route_lock);
+			ax25_dev_put(ax25_dev);
 			return 0;
 		}
 		ax25_rt = ax25_rt->next;
@@ -108,6 +112,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 
 	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
 		write_unlock_bh(&ax25_route_lock);
+		ax25_dev_put(ax25_dev);
 		return -ENOMEM;
 	}
 
@@ -116,11 +121,11 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
-	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
 			kfree(ax25_rt);
+			ax25_dev_put(ax25_dev);
 			return -ENOMEM;
 		}
 		ax25_rt->digipeat->lastrepeat = -1;
@@ -133,6 +138,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->next   = ax25_route_list;
 	ax25_route_list = ax25_rt;
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -173,8 +179,8 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 			}
 		}
 	}
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -216,8 +222,8 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	}
 
 out:
-	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 	return err;
 }
 
-- 
2.17.1

