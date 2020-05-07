Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37661C9696
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 18:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgEGQck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 12:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727822AbgEGQcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 12:32:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB55C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 09:32:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o196so4559803ybg.8
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 09:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xQxw16jsUu5l0sr4XAG5knxiJfNpnviEkNfEhUYgOkU=;
        b=FO7lsvriKsOB/nIiMtHWOfvVlKUV2v/3TI5HUGhOtrc+o4oar26f7S1x0h+BeKLgvn
         MNl3mOXAKgOc/1MM5Q6ctt4r5ubL1YDofY4whgRZQVIPR0p4pVjVvuu0gTWd360UuxAV
         OvD8GvOy8TpeX2fJA3RSm6GEglqFofifaUVIFSC5xJ0z20nU/6shQ7RQcD8ukBpMa0XB
         3xBI/hdTfgNigdDHINFJfixQPQy/49duZRocwpnDgzfkY25MzevA7yChUY5XH868tCl5
         PvVX0nh9OtHHbff2+N+c3xJtOnWm46gcY/gDmjzrCsbhdp3yOcyEFejPtgp6R+CfOaFm
         PD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xQxw16jsUu5l0sr4XAG5knxiJfNpnviEkNfEhUYgOkU=;
        b=tOQIqsyFDP5bdyLrjupylhn7Ba9SsseY6HNN8JhI50Lqo4+/r8Y/6cWGJUZZC+TlXq
         OR58CvqOfpXDAOdAZBNcj24VtkyZ6tQ+a0AxRqItloTOhGL90prWPOGb4kRw3XC8Cd+X
         6pPvpa2x99pseJOfgaSo5NufsvSL/Luki+k2L4NO+NB150FFnzz3baQz82rJR4/N72kp
         F+JbvKfL94U0tm3hG6ZV55uw0lgO1elX+HUD5uZ1+N09dV3PienN1bjtaBGVoA0kv3Vn
         qttrRbdjyGEyWEZpRckOOEn79GAa1eQD5YElDXnLcBLNigKYBghcJYfsC9Mop9t3zGtt
         X87g==
X-Gm-Message-State: AGi0PuYJdruohBgqrqS7njdqHXK4IgIpTCTlGCSqKjEm9XsuzHEo/Xc8
        lybw2BxUEbNQ4fOFxuyXC4Pxmy0eJHm+cA==
X-Google-Smtp-Source: APiQypLKxCBYeUVEZ3ofshS0qtmM1uSUNrjTuPr6qLW91r0yijraQ3hHW10T0XrXrL6E2vw3ieQsddtHhTZ3Uw==
X-Received: by 2002:a25:ae5f:: with SMTP id g31mr24534771ybe.141.1588869157275;
 Thu, 07 May 2020 09:32:37 -0700 (PDT)
Date:   Thu,  7 May 2020 09:32:22 -0700
In-Reply-To: <20200507163222.122469-1-edumazet@google.com>
Message-Id: <20200507163222.122469-6-edumazet@google.com>
Mime-Version: 1.0
References: <20200507163222.122469-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 5/5] bonding: propagate transmit status
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, bonding always returns NETDEV_TX_OK to its caller.

It is worth trying to be more accurate : TCP for instance
can have different recovery strategies if it can have more
precise status, if packet was dropped by slave qdisc.

This is especially important when host is under stress.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
---
 drivers/net/bonding/bond_alb.c  |  7 ++--
 drivers/net/bonding/bond_main.c | 60 ++++++++++++---------------------
 include/net/bonding.h           | 13 ++++---
 3 files changed, 32 insertions(+), 48 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index c81698550e5a78b091a761638ee35f887aacba1d..3a598d04b1568fbceb42ffe852d193da179d3d17 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -1318,8 +1318,7 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 					tx_slave->dev->dev_addr);
 		}
 
-		bond_dev_queue_xmit(bond, skb, tx_slave->dev);
-		goto out;
+		return bond_dev_queue_xmit(bond, skb, tx_slave->dev);
 	}
 
 	if (tx_slave && bond->params.tlb_dynamic_lb) {
@@ -1329,9 +1328,7 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 	}
 
 	/* no suitable interface, frame not sent */
-	bond_tx_drop(bond->dev, skb);
-out:
-	return NETDEV_TX_OK;
+	return bond_tx_drop(bond->dev, skb);
 }
 
 netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev)
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index baa93191dfdd93ed93625ff922d58d7cf9e1b751..4f9e7c421f57d7841f11c03135e721ae759c31a8 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -287,7 +287,7 @@ const char *bond_mode_name(int mode)
  * @skb: hw accel VLAN tagged skb to transmit
  * @slave_dev: slave that is supposed to xmit this skbuff
  */
-void bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
+netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
 			struct net_device *slave_dev)
 {
 	skb->dev = slave_dev;
@@ -297,9 +297,9 @@ void bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb,
 	skb_set_queue_mapping(skb, qdisc_skb_cb(skb)->slave_dev_queue_mapping);
 
 	if (unlikely(netpoll_tx_running(bond->dev)))
-		bond_netpoll_send_skb(bond_get_slave_by_dev(bond, slave_dev), skb);
-	else
-		dev_queue_xmit(skb);
+		return bond_netpoll_send_skb(bond_get_slave_by_dev(bond, slave_dev), skb);
+
+	return dev_queue_xmit(skb);
 }
 
 /* In the following 2 functions, bond_vlan_rx_add_vid and bond_vlan_rx_kill_vid,
@@ -3932,7 +3932,7 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
  * it fails, it tries to find the first available slave for transmission.
  * The skb is consumed in all cases, thus the function is void.
  */
-static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int slave_id)
+static netdev_tx_t bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int slave_id)
 {
 	struct list_head *iter;
 	struct slave *slave;
@@ -3941,10 +3941,8 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
 	/* Here we start from the slave with slave_id */
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		if (--i < 0) {
-			if (bond_slave_can_tx(slave)) {
-				bond_dev_queue_xmit(bond, skb, slave->dev);
-				return;
-			}
+			if (bond_slave_can_tx(slave))
+				return bond_dev_queue_xmit(bond, skb, slave->dev);
 		}
 	}
 
@@ -3953,13 +3951,11 @@ static void bond_xmit_slave_id(struct bonding *bond, struct sk_buff *skb, int sl
 	bond_for_each_slave_rcu(bond, slave, iter) {
 		if (--i < 0)
 			break;
-		if (bond_slave_can_tx(slave)) {
-			bond_dev_queue_xmit(bond, skb, slave->dev);
-			return;
-		}
+		if (bond_slave_can_tx(slave))
+			return bond_dev_queue_xmit(bond, skb, slave->dev);
 	}
 	/* no slave that can tx has been found */
-	bond_tx_drop(bond->dev, skb);
+	return bond_tx_drop(bond->dev, skb);
 }
 
 /**
@@ -4020,10 +4016,8 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 		if (iph->protocol == IPPROTO_IGMP) {
 			slave = rcu_dereference(bond->curr_active_slave);
 			if (slave)
-				bond_dev_queue_xmit(bond, skb, slave->dev);
-			else
-				bond_xmit_slave_id(bond, skb, 0);
-			return NETDEV_TX_OK;
+				return bond_dev_queue_xmit(bond, skb, slave->dev);
+			return bond_xmit_slave_id(bond, skb, 0);
 		}
 	}
 
@@ -4031,11 +4025,9 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 	slave_cnt = READ_ONCE(bond->slave_cnt);
 	if (likely(slave_cnt)) {
 		slave_id = bond_rr_gen_slave_id(bond);
-		bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
-	} else {
-		bond_tx_drop(bond_dev, skb);
+		return bond_xmit_slave_id(bond, skb, slave_id % slave_cnt);
 	}
-	return NETDEV_TX_OK;
+	return bond_tx_drop(bond_dev, skb);
 }
 
 /* In active-backup mode, we know that bond->curr_active_slave is always valid if
@@ -4049,11 +4041,9 @@ static netdev_tx_t bond_xmit_activebackup(struct sk_buff *skb,
 
 	slave = rcu_dereference(bond->curr_active_slave);
 	if (slave)
-		bond_dev_queue_xmit(bond, skb, slave->dev);
-	else
-		bond_tx_drop(bond_dev, skb);
+		return bond_dev_queue_xmit(bond, skb, slave->dev);
 
-	return NETDEV_TX_OK;
+	return bond_tx_drop(bond_dev, skb);
 }
 
 /* Use this to update slave_array when (a) it's not appropriate to update
@@ -4196,12 +4186,9 @@ static netdev_tx_t bond_3ad_xor_xmit(struct sk_buff *skb,
 	count = slaves ? READ_ONCE(slaves->count) : 0;
 	if (likely(count)) {
 		slave = slaves->arr[bond_xmit_hash(bond, skb) % count];
-		bond_dev_queue_xmit(bond, skb, slave->dev);
-	} else {
-		bond_tx_drop(dev, skb);
+		return bond_dev_queue_xmit(bond, skb, slave->dev);
 	}
-
-	return NETDEV_TX_OK;
+	return bond_tx_drop(dev, skb);
 }
 
 /* in broadcast mode, we send everything to all usable interfaces. */
@@ -4227,11 +4214,9 @@ static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
 		}
 	}
 	if (slave && bond_slave_is_up(slave) && slave->link == BOND_LINK_UP)
-		bond_dev_queue_xmit(bond, skb, slave->dev);
-	else
-		bond_tx_drop(bond_dev, skb);
+		return bond_dev_queue_xmit(bond, skb, slave->dev);
 
-	return NETDEV_TX_OK;
+	return bond_tx_drop(bond_dev, skb);
 }
 
 /*------------------------- Device initialization ---------------------------*/
@@ -4310,8 +4295,7 @@ static netdev_tx_t __bond_start_xmit(struct sk_buff *skb, struct net_device *dev
 		/* Should never happen, mode already checked */
 		netdev_err(dev, "Unknown bonding mode %d\n", BOND_MODE(bond));
 		WARN_ON_ONCE(1);
-		bond_tx_drop(dev, skb);
-		return NETDEV_TX_OK;
+		return bond_tx_drop(dev, skb);
 	}
 }
 
@@ -4330,7 +4314,7 @@ static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (bond_has_slaves(bond))
 		ret = __bond_start_xmit(skb, dev);
 	else
-		bond_tx_drop(dev, skb);
+		ret = bond_tx_drop(dev, skb);
 	rcu_read_unlock();
 
 	return ret;
diff --git a/include/net/bonding.h b/include/net/bonding.h
index f211983cd52a81804f0ad555eaaa876ad927b40b..9b1e76515a9cc4d329f98dd5e9455c41d074420d 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -504,15 +504,17 @@ static inline unsigned long slave_last_rx(struct bonding *bond,
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
-static inline void bond_netpoll_send_skb(const struct slave *slave,
+static inline netdev_tx_t bond_netpoll_send_skb(const struct slave *slave,
 					 struct sk_buff *skb)
 {
-	netpoll_send_skb(slave->np, skb);
+	return netpoll_send_skb(slave->np, skb);
 }
 #else
-static inline void bond_netpoll_send_skb(const struct slave *slave,
+static inline netdev_tx_t bond_netpoll_send_skb(const struct slave *slave,
 					 struct sk_buff *skb)
 {
+	BUG();
+	return NETDEV_TX_OK;
 }
 #endif
 
@@ -606,7 +608,7 @@ struct bond_net {
 };
 
 int bond_arp_rcv(const struct sk_buff *skb, struct bonding *bond, struct slave *slave);
-void bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb, struct net_device *slave_dev);
+netdev_tx_t bond_dev_queue_xmit(struct bonding *bond, struct sk_buff *skb, struct net_device *slave_dev);
 int bond_create(struct net *net, const char *name);
 int bond_create_sysfs(struct bond_net *net);
 void bond_destroy_sysfs(struct bond_net *net);
@@ -739,10 +741,11 @@ extern struct bond_parm_tbl ad_select_tbl[];
 /* exported from bond_netlink.c */
 extern struct rtnl_link_ops bond_link_ops;
 
-static inline void bond_tx_drop(struct net_device *dev, struct sk_buff *skb)
+static inline netdev_tx_t bond_tx_drop(struct net_device *dev, struct sk_buff *skb)
 {
 	atomic_long_inc(&dev->tx_dropped);
 	dev_kfree_skb_any(skb);
+	return NET_XMIT_DROP;
 }
 
 #endif /* _NET_BONDING_H */
-- 
2.26.2.526.g744177e7f7-goog

