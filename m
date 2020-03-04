Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F85179506
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388273AbgCDQYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:24:18 -0500
Received: from mx2.suse.de ([195.135.220.15]:42312 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388254AbgCDQYR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:24:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 54129B4C4;
        Wed,  4 Mar 2020 16:24:15 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id F19C3E037F; Wed,  4 Mar 2020 17:24:14 +0100 (CET)
Message-Id: <fd9f73a61a1c70d20d254d32eae0d8cf33888f20.1583337972.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583337972.git.mkubecek@suse.cz>
References: <cover.1583337972.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 4/5] tun: replace tun_debug() by netif_info()
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Wed,  4 Mar 2020 17:24:14 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tun driver uses custom macro tun_debug() which is only available if
TUN_DEBUG is set. Replace it by standard netif_ifinfo(). For that purpose,
rename tun_struct::debug to msg_enable and make it u32 and always present.
Finally, make tun_get_msglevel(), tun_set_msglevel() and TUNSETDEBUG ioctl
independent of TUN_DEBUG.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/tun.c | 60 +++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 33 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 15ae2050ab5b..42110aba0014 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -81,7 +81,7 @@ static void tun_default_link_ksettings(struct net_device *dev,
 #ifdef TUN_DEBUG
 #define tun_debug(level, tun, fmt, args...)			\
 do {								\
-	if (tun->debug)						\
+	if (tun->msg_enable)					\
 		netdev_printk(level, tun->dev, fmt, ##args);	\
 } while (0)
 #else
@@ -213,9 +213,7 @@ struct tun_struct {
 	struct sock_fprog	fprog;
 	/* protected by rtnl lock */
 	bool			filter_attached;
-#ifdef TUN_DEBUG
-	int debug;
-#endif
+	u32			msg_enable;
 	spinlock_t lock;
 	struct hlist_head flows[TUN_NUM_FLOW_ENTRIES];
 	struct timer_list flow_gc_timer;
@@ -411,8 +409,9 @@ static struct tun_flow_entry *tun_flow_create(struct tun_struct *tun,
 	struct tun_flow_entry *e = kmalloc(sizeof(*e), GFP_ATOMIC);
 
 	if (e) {
-		tun_debug(KERN_INFO, tun, "create flow: hash %u index %u\n",
-			  rxhash, queue_index);
+		netif_info(tun, tx_queued, tun->dev,
+			   "create flow: hash %u index %u\n",
+			   rxhash, queue_index);
 		e->updated = jiffies;
 		e->rxhash = rxhash;
 		e->rps_rxhash = 0;
@@ -426,8 +425,8 @@ static struct tun_flow_entry *tun_flow_create(struct tun_struct *tun,
 
 static void tun_flow_delete(struct tun_struct *tun, struct tun_flow_entry *e)
 {
-	tun_debug(KERN_INFO, tun, "delete flow: hash %u index %u\n",
-		  e->rxhash, e->queue_index);
+	netif_info(tun, tx_queued, tun->dev, "delete flow: hash %u index %u\n",
+		   e->rxhash, e->queue_index);
 	hlist_del_rcu(&e->hash_link);
 	kfree_rcu(e, rcu);
 	--tun->flow_count;
@@ -1061,7 +1060,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (!rcu_dereference(tun->steering_prog))
 		tun_automq_xmit(tun, skb);
 
-	tun_debug(KERN_INFO, tun, "tun_net_xmit %d\n", skb->len);
+	netif_info(tun, tx_queued, tun->dev, "%s %d\n", __func__, skb->len);
 
 	/* Drop if the filter does not like it.
 	 * This is a noop if the filter is disabled.
@@ -3085,7 +3084,7 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	if (!tun)
 		goto unlock;
 
-	tun_debug(KERN_INFO, tun, "tun_chr_ioctl cmd %u\n", cmd);
+	netif_info(tun, drv, tun->dev, "tun_chr_ioctl cmd %u\n", cmd);
 
 	net = dev_net(tun->dev);
 	ret = 0;
@@ -3106,8 +3105,8 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		/* Disable/Enable checksum */
 
 		/* [unimplemented] */
-		tun_debug(KERN_INFO, tun, "ignored: set checksum %s\n",
-			  arg ? "disabled" : "enabled");
+		netif_info(tun, drv, tun->dev, "ignored: set checksum %s\n",
+			   arg ? "disabled" : "enabled");
 		break;
 
 	case TUNSETPERSIST:
@@ -3125,8 +3124,8 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 			do_notify = true;
 		}
 
-		tun_debug(KERN_INFO, tun, "persist %s\n",
-			  arg ? "enabled" : "disabled");
+		netif_info(tun, drv, tun->dev, "persist %s\n",
+			   arg ? "enabled" : "disabled");
 		break;
 
 	case TUNSETOWNER:
@@ -3138,8 +3137,8 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		}
 		tun->owner = owner;
 		do_notify = true;
-		tun_debug(KERN_INFO, tun, "owner set to %u\n",
-			  from_kuid(&init_user_ns, tun->owner));
+		netif_info(tun, drv, tun->dev, "owner set to %u\n",
+			   from_kuid(&init_user_ns, tun->owner));
 		break;
 
 	case TUNSETGROUP:
@@ -3151,29 +3150,28 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 		}
 		tun->group = group;
 		do_notify = true;
-		tun_debug(KERN_INFO, tun, "group set to %u\n",
-			  from_kgid(&init_user_ns, tun->group));
+		netif_info(tun, drv, tun->dev, "group set to %u\n",
+			   from_kgid(&init_user_ns, tun->group));
 		break;
 
 	case TUNSETLINK:
 		/* Only allow setting the type when the interface is down */
 		if (tun->dev->flags & IFF_UP) {
-			tun_debug(KERN_INFO, tun,
-				  "Linktype set failed because interface is up\n");
+			netif_info(tun, drv, tun->dev,
+				   "Linktype set failed because interface is up\n");
 			ret = -EBUSY;
 		} else {
 			tun->dev->type = (int) arg;
-			tun_debug(KERN_INFO, tun, "linktype set to %d\n",
-				  tun->dev->type);
+			netif_info(tun, drv, tun->dev, "linktype set to %d\n",
+				   tun->dev->type);
 			ret = 0;
 		}
 		break;
 
-#ifdef TUN_DEBUG
 	case TUNSETDEBUG:
-		tun->debug = arg;
+		tun->msg_enable = (u32)arg;
 		break;
-#endif
+
 	case TUNSETOFFLOAD:
 		ret = set_offload(tun, arg);
 		break;
@@ -3529,20 +3527,16 @@ static void tun_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info
 
 static u32 tun_get_msglevel(struct net_device *dev)
 {
-#ifdef TUN_DEBUG
 	struct tun_struct *tun = netdev_priv(dev);
-	return tun->debug;
-#else
-	return -EOPNOTSUPP;
-#endif
+
+	return tun->msg_enable;
 }
 
 static void tun_set_msglevel(struct net_device *dev, u32 value)
 {
-#ifdef TUN_DEBUG
 	struct tun_struct *tun = netdev_priv(dev);
-	tun->debug = value;
-#endif
+
+	tun->msg_enable = value;
 }
 
 static int tun_get_coalesce(struct net_device *dev,
-- 
2.25.1

