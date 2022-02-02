Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB004A75A0
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 17:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbiBBQTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 11:19:09 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:56268 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230078AbiBBQTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Feb 2022 11:19:09 -0500
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app2 (Coremail) with SMTP id by_KCgDX34fnrvph4n+QAQ--.673S2;
        Thu, 03 Feb 2022 00:18:53 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     dan.carpenter@oracle.com
Cc:     linux-hams@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [Fixes] ax25: add refcount in ax25_dev to avoid UAF bugs
Date:   Thu,  3 Feb 2022 00:18:46 +0800
Message-Id: <20220202161846.26198-1-duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgDX34fnrvph4n+QAQ--.673S2
X-Coremail-Antispam: 1UD129KBjvJXoW3AF4UWryxXr15GFW8CFy3Jwb_yoWDJFWDpF
        WjkFWrArWktF47Ars5Wr4xGF1YyryIq39rXr17uF1Ikw1rJ3s8JF18tryUtry3GrWfAr18
        X34DXr45Ar48CF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkS1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVCY1x0267AKxVWxJr0_GcWle2I262IYc4
        CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
        0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vIr41l42xK82IY6x8E
        rcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr
        0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0E
        wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJV
        W8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAI
        cVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qssqjiasttq6lmxovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we dereference ax25_dev after we call kfree(ax25_dev) in
ax25_dev_device_down(), it will lead to concurrency UAF bugs.
There are eight syscall functions suffer from UAF bugs, include
ax25_bind(), ax25_release(), ax25_connect(), ax25_ioctl(),
ax25_getname(), ax25_sendmsg(), ax25_getsockopt() and
ax25_info_show().

One of the concurrency UAF can be shown as below:

  (USE)                       |    (FREE)
                              |  ax25_device_event
                              |    ax25_dev_device_down
ax25_bind                     |    ...
  ...                         |      kfree(ax25_dev)
  ax25_fillin_cb()            |    ...
    ax25_fillin_cb_from_dev() |
  ...                         |

The root cause of UAF bugs is that kfree(ax25_dev) in
ax25_dev_device_down() is not protected by any locks.
When ax25_dev, which there are still pointers point to,
is released, the concurrency UAF bug will happen.

This patch introduces refcount into ax25_dev in order to
guarantee that there are no pointers point to it when ax25_dev
is released.

Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
---
 include/net/ax25.h    | 12 ++++++++++++
 net/ax25/af_ax25.c    | 20 ++++++++++++++++----
 net/ax25/ax25_dev.c   | 33 +++++++++++++++++++++++++++------
 net/ax25/ax25_route.c | 27 ++++++++++++++++++++++-----
 4 files changed, 77 insertions(+), 15 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 526e4958919..1a38b1ad529 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -239,6 +239,7 @@ typedef struct ax25_dev {
 #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
 	ax25_dama_info		dama;
 #endif
+	refcount_t		refcount;
 } ax25_dev;
 
 typedef struct ax25_cb {
@@ -293,6 +294,17 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
 	}
 }
 
+static inline void ax25_dev_hold(ax25_dev *ax25_dev)
+{
+	refcount_inc(&ax25_dev->refcount);
+}
+
+static inline void ax25_dev_put(ax25_dev *ax25_dev)
+{
+	if (refcount_dec_and_test(&ax25_dev->refcount))
+		kfree(ax25_dev);
+}
+
 static inline __be16 ax25_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
 	skb->dev      = dev;
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 44a8730c26a..7463bbd4e63 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -91,6 +91,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 			spin_unlock_bh(&ax25_list_lock);
 			lock_sock(sk);
 			s->ax25_dev = NULL;
+			ax25_dev_put(ax25_dev);
 			release_sock(sk);
 			ax25_disconnect(s, ENETUNREACH);
 			spin_lock_bh(&ax25_list_lock);
@@ -358,21 +359,31 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	if (copy_from_user(&ax25_ctl, arg, sizeof(ax25_ctl)))
 		return -EFAULT;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr)) == NULL)
+	ax25_dev = ax25_addr_ax25dev(&ax25_ctl.port_addr);
+	if (ax25_dev == NULL) {
+		ax25_dev_put(ax25_dev);
 		return -ENODEV;
+	}
 
-	if (ax25_ctl.digi_count > AX25_MAX_DIGIS)
+	if (ax25_ctl.digi_count > AX25_MAX_DIGIS) {
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
+	}
 
-	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL)
+	if (ax25_ctl.arg > ULONG_MAX / HZ && ax25_ctl.cmd != AX25_KILL) {
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
+	}
 
 	digi.ndigi = ax25_ctl.digi_count;
 	for (k = 0; k < digi.ndigi; k++)
 		digi.calls[k] = ax25_ctl.digi_addr[k];
 
-	if ((ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev)) == NULL)
+	ax25 = ax25_find_cb(&ax25_ctl.source_addr, &ax25_ctl.dest_addr, &digi, ax25_dev->dev);
+	if (ax25 == NULL) {
+		ax25_dev_put(ax25_dev);
 		return -ENOTCONN;
+	}
 
 	switch (ax25_ctl.cmd) {
 	case AX25_KILL:
@@ -439,6 +450,7 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	  }
 
 out_put:
+	ax25_dev_put(ax25_dev);
 	ax25_cb_put(ax25);
 	return ret;
 
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 256fadb94df..77d9aa2ccab 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -37,6 +37,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
 	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
 		if (ax25cmp(addr, (const ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
+			ax25_dev_hold(ax25_dev);
 		}
 	spin_unlock_bh(&ax25_dev_lock);
 
@@ -56,6 +57,7 @@ void ax25_dev_device_up(struct net_device *dev)
 		return;
 	}
 
+	refcount_set(&ax25_dev->refcount, 1);
 	dev->ax25_ptr     = ax25_dev;
 	ax25_dev->dev     = dev;
 	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
@@ -83,6 +85,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	spin_lock_bh(&ax25_dev_lock);
 	ax25_dev->next = ax25_dev_list;
 	ax25_dev_list  = ax25_dev;
+	ax25_dev_hold(ax25_dev);
 	spin_unlock_bh(&ax25_dev_lock);
 
 	ax25_register_dev_sysctl(ax25_dev);
@@ -111,21 +114,23 @@ void ax25_dev_device_down(struct net_device *dev)
 			s->forward = NULL;
 
 	if ((s = ax25_dev_list) == ax25_dev) {
+		ax25_dev_put(ax25_dev_list);
 		ax25_dev_list = s->next;
 		spin_unlock_bh(&ax25_dev_lock);
 		dev->ax25_ptr = NULL;
 		dev_put_track(dev, &ax25_dev->dev_tracker);
-		kfree(ax25_dev);
+		ax25_dev_put(ax25_dev);
 		return;
 	}
 
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
+			ax25_dev_put(s->next);
 			s->next = ax25_dev->next;
 			spin_unlock_bh(&ax25_dev_lock);
 			dev->ax25_ptr = NULL;
 			dev_put_track(dev, &ax25_dev->dev_tracker);
-			kfree(ax25_dev);
+			ax25_dev_put(ax25_dev);
 			return;
 		}
 
@@ -133,31 +138,47 @@ void ax25_dev_device_down(struct net_device *dev)
 	}
 	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
+	ax25_dev_put(ax25_dev);
 }
 
 int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 {
 	ax25_dev *ax25_dev, *fwd_dev;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&fwd->port_from)) == NULL)
+	ax25_dev = ax25_addr_ax25dev(&fwd->port_from);
+	if (ax25_dev == NULL) {
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
+	}
 
 	switch (cmd) {
 	case SIOCAX25ADDFWD:
-		if ((fwd_dev = ax25_addr_ax25dev(&fwd->port_to)) == NULL)
+		fwd_dev = ax25_addr_ax25dev(&fwd->port_to);
+		if (fwd_dev == NULL) {
+			ax25_dev_put(fwd_dev);
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
-		if (ax25_dev->forward != NULL)
+		}
+		if (ax25_dev->forward != NULL) {
+			ax25_dev_put(ax25_dev);
 			return -EINVAL;
+		}
 		ax25_dev->forward = fwd_dev->dev;
+		ax25_dev_put(fwd_dev);
+		ax25_dev_put(ax25_dev);
 		break;
 
 	case SIOCAX25DELFWD:
-		if (ax25_dev->forward == NULL)
+		if (ax25_dev->forward == NULL) {
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
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index d0b2e094bd5..7fe7a83b2a3 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -75,10 +75,15 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_dev *ax25_dev;
 	int i;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
+	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
+	if (ax25_dev == NULL) {
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
-	if (route->digi_count > AX25_MAX_DIGIS)
+	}
+	if (route->digi_count > AX25_MAX_DIGIS) {
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
+	}
 
 	write_lock_bh(&ax25_route_lock);
 
@@ -91,6 +96,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 			if (route->digi_count != 0) {
 				if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 					write_unlock_bh(&ax25_route_lock);
+					ax25_dev_put(ax25_dev);
 					return -ENOMEM;
 				}
 				ax25_rt->digipeat->lastrepeat = -1;
@@ -101,6 +107,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 				}
 			}
 			write_unlock_bh(&ax25_route_lock);
+			ax25_dev_put(ax25_dev);
 			return 0;
 		}
 		ax25_rt = ax25_rt->next;
@@ -108,6 +115,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 
 	if ((ax25_rt = kmalloc(sizeof(ax25_route), GFP_ATOMIC)) == NULL) {
 		write_unlock_bh(&ax25_route_lock);
+		ax25_dev_put(ax25_dev);
 		return -ENOMEM;
 	}
 
@@ -120,6 +128,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
 			kfree(ax25_rt);
+			ax25_dev_put(ax25_dev);
 			return -ENOMEM;
 		}
 		ax25_rt->digipeat->lastrepeat = -1;
@@ -132,6 +141,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->next   = ax25_route_list;
 	ax25_route_list = ax25_rt;
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 
 	return 0;
 }
@@ -147,8 +157,11 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 	ax25_route *s, *t, *ax25_rt;
 	ax25_dev *ax25_dev;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&route->port_addr)) == NULL)
+	ax25_dev = ax25_addr_ax25dev(&route->port_addr);
+	if (ax25_dev == NULL) {
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
+	}
 
 	write_lock_bh(&ax25_route_lock);
 
@@ -173,7 +186,7 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 		}
 	}
 	write_unlock_bh(&ax25_route_lock);
-
+	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
@@ -183,8 +196,11 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	ax25_dev *ax25_dev;
 	int err = 0;
 
-	if ((ax25_dev = ax25_addr_ax25dev(&rt_option->port_addr)) == NULL)
+	ax25_dev = ax25_addr_ax25dev(&rt_option->port_addr);
+	if (ax25_dev == NULL) {
+		ax25_dev_put(ax25_dev);
 		return -EINVAL;
+	}
 
 	write_lock_bh(&ax25_route_lock);
 
@@ -215,6 +231,7 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 
 out:
 	write_unlock_bh(&ax25_route_lock);
+	ax25_dev_put(ax25_dev);
 	return err;
 }
 
-- 
2.17.1

