Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A3F13ECA
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfEEKTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:19:53 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54285 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbfEEKTs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:19:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id b10so12241908wmj.4
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=MprYmig8H31OGazDpgfBsjZmAtWycVx3vWhU4ImFGTE=;
        b=Bvg204N0OUAKTmzENhWaKg0ZrTJDbfR2La2p2BdkK5UttsDS8Ing3yfvbmO8pmwZ0g
         1KgKL7UTNSGDcXwbV/RtqX8yC/AGlClwvBXpLZaSeT08PMdEDREw5im6Z83RY/VQqkBQ
         /3vJo9mAO1uoO6+kf3oPwrMg+AJ1OJfDI1XXi/ya+6pxY8vk0Gh3tdQgfzJbF0DDJAEh
         HURWq+xHfsHAsrnvAIUfjuJo2G1z19hA+bJD1S0DWFJkXZHFiNJ6nwKlneB1//4zvnAI
         6NDTPkSyqMh/xp+M45A87dcXxEohdbxhWNpc9o3lpIz74LdYdU1nX/n57DKXdjixTeMN
         52ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=MprYmig8H31OGazDpgfBsjZmAtWycVx3vWhU4ImFGTE=;
        b=Wm7lRr/I5I3fKdBBiF2gVkm4dJjaGTA1dTUOAoIKG1OzBEglbTPmKn2PVjo4bYbryt
         wRbZEg+rUbhE+Clves1wJVp/UTiTdQDph7w0GXbqxAqSsd8v33GeZNMkCkPAkvAL4V6v
         uo0QHzgN74z2ZCnGDDOZilgDpZt6NRHdCS1WQkAKSst4zaL8S7t+KoSqwCdutmWYTVZ8
         oScogl3pUID2JYRydc5gC1K/wG2qBcZgR2xmaM2pka38aD5N0sLBjsCb1BjwVRmryhV4
         jaSKNe3WZ6I/Oqw7DefKpcxEwSFz+nRGiW6ZplgMTNV57DMvHxle6ZnjV1bhJdQqAqxm
         +3BA==
X-Gm-Message-State: APjAAAXuU8wTPN68Rm6emNzkL76JJ9Biu9fkyS90KgIOZLKjbffJ2xnk
        RQaRYEdC1YMY6PXIUl1m5UdK7Zxj
X-Google-Smtp-Source: APXvYqzoSdllzg4qfJhXEUJH6AF3gALZTmMbu6RZ26xi0reoThDGJkZeyuKR+g1hc+C3rKkrScGG8g==
X-Received: by 2002:a1c:eb18:: with SMTP id j24mr13476672wmh.32.1557051585532;
        Sun, 05 May 2019 03:19:45 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id n2sm12333193wra.89.2019.05.05.03.19.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:19:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 06/10] net: dsa: Add support for deferred xmit
Date:   Sun,  5 May 2019 13:19:25 +0300
Message-Id: <20190505101929.17056-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505101929.17056-1-olteanv@gmail.com>
References: <20190505101929.17056-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some hardware needs to take work to get convinced to receive frames on
the CPU port (such as the sja1105 which takes temporary L2 forwarding
rules over SPI that last for a single frame). Such work needs a
sleepable context, and because the regular .ndo_start_xmit is atomic,
this cannot be done in the tagger. So introduce a generic DSA mechanism
that sets up a transmit skb queue and a workqueue for deferred
transmission.

The new driver callback (.port_deferred_xmit) is in dsa_switch and not
in the tagger because the operations that require sleeping typically
also involve interacting with the hardware, and not simply skb
manipulations. Therefore having it there simplifies the structure a bit
and makes it unnecessary to export functions from the driver to the
tagger.

The driver is responsible of calling dsa_enqueue_skb which transfers it
to the master netdevice. This is so that it has a chance of performing
some more work afterwards, such as cleanup or TX timestamping.

To tell DSA that skb xmit deferral is required, I have thought about
changing the return type of the tagger .xmit from struct sk_buff * into
a enum dsa_tx_t that could potentially encode a DSA_XMIT_DEFER value.

But the trailer tagger is reallocating every skb on xmit and therefore
making a valid use of the pointer return value. So instead of reworking
the API in complicated ways, right now a boolean property in the newly
introduced DSA_SKB_CB is set.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:
  - None.

Changes in v2:
  - Prevented a race condition between the xmit workqueue and the
    dsa_slave_suspend.

 include/net/dsa.h  | 12 +++++++++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/slave.c    | 64 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 66 insertions(+), 12 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d628587e0bde..0260b73938e2 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -85,6 +85,7 @@ struct dsa_device_ops {
 
 struct dsa_skb_cb {
 	struct sk_buff *clone;
+	bool deferred_xmit;
 };
 
 struct __dsa_skb_cb {
@@ -205,6 +206,10 @@ struct dsa_port {
 	struct net_device	*bridge_dev;
 	struct devlink_port	devlink_port;
 	struct phylink		*pl;
+
+	struct work_struct	xmit_work;
+	struct sk_buff_head	xmit_queue;
+
 	/*
 	 * Original copy of the master netdev ethtool_ops
 	 */
@@ -539,6 +544,12 @@ struct dsa_switch_ops {
 				 struct sk_buff *clone, unsigned int type);
 	bool	(*port_rxtstamp)(struct dsa_switch *ds, int port,
 				 struct sk_buff *skb, unsigned int type);
+
+	/*
+	 * Deferred frame Tx
+	 */
+	netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
+					  struct sk_buff *skb);
 };
 
 struct dsa_switch_driver {
@@ -634,6 +645,7 @@ static inline int call_dsa_notifiers(unsigned long val, struct net_device *dev,
 #define BRCM_TAG_GET_QUEUE(v)		((v) & 0xff)
 
 
+netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev);
 int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data);
 int dsa_port_get_ethtool_phy_stats(struct dsa_port *dp, uint64_t *data);
 int dsa_port_get_phy_sset_count(struct dsa_port *dp);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index b434f5ff55ab..8f1222324646 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -174,6 +174,8 @@ int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
 
+void *dsa_defer_xmit(struct sk_buff *skb, struct net_device *dev);
+
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8ad9bf957da1..534dfbc27b1e 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -120,6 +120,9 @@ static int dsa_slave_close(struct net_device *dev)
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
+	cancel_work_sync(&dp->xmit_work);
+	skb_queue_purge(&dp->xmit_queue);
+
 	phylink_stop(dp->pl);
 
 	dsa_port_disable(dp);
@@ -430,6 +433,24 @@ static void dsa_skb_tx_timestamp(struct dsa_slave_priv *p,
 	kfree_skb(clone);
 }
 
+netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev)
+{
+	/* SKB for netpoll still need to be mangled with the protocol-specific
+	 * tag to be successfully transmitted
+	 */
+	if (unlikely(netpoll_tx_running(dev)))
+		return dsa_slave_netpoll_send_skb(dev, skb);
+
+	/* Queue the SKB for transmission on the parent interface, but
+	 * do not modify its EtherType
+	 */
+	skb->dev = dsa_slave_to_master(dev);
+	dev_queue_xmit(skb);
+
+	return NETDEV_TX_OK;
+}
+EXPORT_SYMBOL_GPL(dsa_enqueue_skb);
+
 static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
@@ -452,23 +473,37 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	nskb = p->xmit(skb, dev);
 	if (!nskb) {
-		kfree_skb(skb);
+		if (!DSA_SKB_CB(skb)->deferred_xmit)
+			kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
-	/* SKB for netpoll still need to be mangled with the protocol-specific
-	 * tag to be successfully transmitted
-	 */
-	if (unlikely(netpoll_tx_running(dev)))
-		return dsa_slave_netpoll_send_skb(dev, nskb);
+	return dsa_enqueue_skb(nskb, dev);
+}
 
-	/* Queue the SKB for transmission on the parent interface, but
-	 * do not modify its EtherType
-	 */
-	nskb->dev = dsa_slave_to_master(dev);
-	dev_queue_xmit(nskb);
+void *dsa_defer_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct dsa_port *dp = dsa_slave_to_port(dev);
 
-	return NETDEV_TX_OK;
+	DSA_SKB_CB(skb)->deferred_xmit = true;
+
+	skb_queue_tail(&dp->xmit_queue, skb);
+	schedule_work(&dp->xmit_work);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(dsa_defer_xmit);
+
+static void dsa_port_xmit_work(struct work_struct *work)
+{
+	struct dsa_port *dp = container_of(work, struct dsa_port, xmit_work);
+	struct dsa_switch *ds = dp->ds;
+	struct sk_buff *skb;
+
+	if (unlikely(!ds->ops->port_deferred_xmit))
+		return;
+
+	while ((skb = skb_dequeue(&dp->xmit_queue)) != NULL)
+		ds->ops->port_deferred_xmit(ds, dp->index, skb);
 }
 
 /* ethtool operations *******************************************************/
@@ -1320,6 +1355,9 @@ int dsa_slave_suspend(struct net_device *slave_dev)
 	if (!netif_running(slave_dev))
 		return 0;
 
+	cancel_work_sync(&dp->xmit_work);
+	skb_queue_purge(&dp->xmit_queue);
+
 	netif_device_detach(slave_dev);
 
 	rtnl_lock();
@@ -1407,6 +1445,8 @@ int dsa_slave_create(struct dsa_port *port)
 	}
 	p->dp = port;
 	INIT_LIST_HEAD(&p->mall_tc_list);
+	INIT_WORK(&port->xmit_work, dsa_port_xmit_work);
+	skb_queue_head_init(&port->xmit_queue);
 	p->xmit = cpu_dp->tag_ops->xmit;
 	port->slave = slave_dev;
 
-- 
2.17.1

