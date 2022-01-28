Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E03F49F2A6
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 05:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237388AbiA1Ezs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 23:55:48 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:40514 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346147AbiA1EzU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 23:55:20 -0500
Received: from ubuntu.localdomain (unknown [10.15.192.164])
        by mail-app2 (Coremail) with SMTP id by_KCgBHTIRXdfNhomB5AQ--.44160S4;
        Fri, 28 Jan 2022 12:47:26 +0800 (CST)
From:   Duoming Zhou <duoming@zju.edu.cn>
To:     linux-hams@vger.kernel.org
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Duoming Zhou <duoming@zju.edu.cn>
Subject: [PATCH 2/2] ax25: add refcount in ax25_dev to avoid UAF bugs
Date:   Fri, 28 Jan 2022 12:47:16 +0800
Message-Id: <855641b37699b6ff501c4bae8370d26f59da9c81.1643343397.git.duoming@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1643343397.git.duoming@zju.edu.cn>
References: <cover.1643343397.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1643343397.git.duoming@zju.edu.cn>
References: <cover.1643343397.git.duoming@zju.edu.cn>
X-CM-TRANSID: by_KCgBHTIRXdfNhomB5AQ--.44160S4
X-Coremail-Antispam: 1UD129KBjvJXoW3AF4UWryxGFykGFyUKr1Dtrb_yoW7ur1rpF
        W0kayrArZ7tFy7Ars5Wr1xWF1jyryjq39rAr1UuF1Skw15J3s8JF18tryUKry7GrW3AF18
        X34DXr4UAr48ZF7anT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUka1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y
        6r17McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v
        1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r
        18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vI
        r41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr
        1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUp6wZUUUUU=
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
 include/net/ax25.h    | 10 ++++++++++
 net/ax25/af_ax25.c    |  2 ++
 net/ax25/ax25_dev.c   | 12 ++++++++++--
 net/ax25/ax25_route.c |  3 +++
 4 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 526e4958919..50b417df622 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -239,6 +239,7 @@ typedef struct ax25_dev {
 #if defined(CONFIG_AX25_DAMA_SLAVE) || defined(CONFIG_AX25_DAMA_MASTER)
 	ax25_dama_info		dama;
 #endif
+	refcount_t		refcount;
 } ax25_dev;
 
 typedef struct ax25_cb {
@@ -293,6 +294,15 @@ static __inline__ void ax25_cb_put(ax25_cb *ax25)
 	}
 }
 
+#define ax25_dev_hold(__ax25_dev) \
+	refcount_inc(&((__ax25_dev)->refcount))
+
+static __inline__ void ax25_dev_put(ax25_dev *ax25_dev)
+{
+	if (refcount_dec_and_test(&ax25_dev->refcount)) {
+		kfree(ax25_dev);
+	}
+}
 static inline __be16 ax25_type_trans(struct sk_buff *skb, struct net_device *dev)
 {
 	skb->dev      = dev;
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 44a8730c26a..32f61978ff2 100644
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
@@ -439,6 +440,7 @@ static int ax25_ctl_ioctl(const unsigned int cmd, void __user *arg)
 	  }
 
 out_put:
+	ax25_dev_put(ax25_dev);
 	ax25_cb_put(ax25);
 	return ret;
 
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 256fadb94df..770b787fb7b 100644
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
@@ -112,20 +115,22 @@ void ax25_dev_device_down(struct net_device *dev)
 
 	if ((s = ax25_dev_list) == ax25_dev) {
 		ax25_dev_list = s->next;
+		ax25_dev_put(ax25_dev);
 		spin_unlock_bh(&ax25_dev_lock);
 		dev->ax25_ptr = NULL;
 		dev_put_track(dev, &ax25_dev->dev_tracker);
-		kfree(ax25_dev);
+		ax25_dev_put(ax25_dev);
 		return;
 	}
 
 	while (s != NULL && s->next != NULL) {
 		if (s->next == ax25_dev) {
 			s->next = ax25_dev->next;
+			ax25_dev_put(ax25_dev);
 			spin_unlock_bh(&ax25_dev_lock);
 			dev->ax25_ptr = NULL;
 			dev_put_track(dev, &ax25_dev->dev_tracker);
-			kfree(ax25_dev);
+			ax25_dev_put(ax25_dev);
 			return;
 		}
 
@@ -133,6 +138,7 @@ void ax25_dev_device_down(struct net_device *dev)
 	}
 	spin_unlock_bh(&ax25_dev_lock);
 	dev->ax25_ptr = NULL;
+	ax25_dev_put(ax25_dev);
 }
 
 int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
@@ -149,6 +155,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 		if (ax25_dev->forward != NULL)
 			return -EINVAL;
 		ax25_dev->forward = fwd_dev->dev;
+		ax25_dev_put(fwd_dev);
 		break;
 
 	case SIOCAX25DELFWD:
@@ -161,6 +168,7 @@ int ax25_fwd_ioctl(unsigned int cmd, struct ax25_fwd_struct *fwd)
 		return -EINVAL;
 	}
 
+	ax25_dev_put(ax25_dev);
 	return 0;
 }
 
diff --git a/net/ax25/ax25_route.c b/net/ax25/ax25_route.c
index d0b2e094bd5..1e32693833e 100644
--- a/net/ax25/ax25_route.c
+++ b/net/ax25/ax25_route.c
@@ -116,6 +116,7 @@ static int __must_check ax25_rt_add(struct ax25_routes_struct *route)
 	ax25_rt->dev          = ax25_dev->dev;
 	ax25_rt->digipeat     = NULL;
 	ax25_rt->ip_mode      = ' ';
+	ax25_dev_put(ax25_dev);
 	if (route->digi_count != 0) {
 		if ((ax25_rt->digipeat = kmalloc(sizeof(ax25_digi), GFP_ATOMIC)) == NULL) {
 			write_unlock_bh(&ax25_route_lock);
@@ -172,6 +173,7 @@ static int ax25_rt_del(struct ax25_routes_struct *route)
 			}
 		}
 	}
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 
 	return 0;
@@ -214,6 +216,7 @@ static int ax25_rt_opt(struct ax25_route_opt_struct *rt_option)
 	}
 
 out:
+	ax25_dev_put(ax25_dev);
 	write_unlock_bh(&ax25_route_lock);
 	return err;
 }
-- 
2.17.1

