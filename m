Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9FD12FFAF
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 01:37:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgADAhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 19:37:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37748 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgADAhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 19:37:20 -0500
Received: by mail-wm1-f67.google.com with SMTP id f129so9999837wmf.2
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 16:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=knNPLIhsUjfupGiycibXy0qG72jQF1aJdI10fFw6XUQ=;
        b=HhXc7EuO3uxRkwyxfhiNtzjF2CPBNJRU0c88KDDZfNorrHCkYSxvtXxZIX5AZ5/IxY
         GRs4MWTYVLneG9GKh0hDbNS4YCsszSiQbpvnB8ognfWkjIhOeshoviE8rpSWe5dwzZ0H
         1rZ63HameEXF8JixFuR40mOve9VoDSiHnPPlIJHeo15WyeMjEub0qKHgDEPDJ31rdWiH
         AEPbuqUIlToS3+rAn1oKKLquaLtsPAT7RuGSlikMlSWaVvJciEujfTVI3J9BIlAGSqKH
         jAOPuZv5v/m7sooLtjeNDTfQSHMdoKNb3CT+vmEFO4aSRwSPUniVcinTl6yaPI69mEyU
         e5Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=knNPLIhsUjfupGiycibXy0qG72jQF1aJdI10fFw6XUQ=;
        b=Oc/q9ylBEuf39aP7luuw8SKCRndNqh/+VR9lSlhKYYsiulwNdFmUFAHi09DTb8A+lZ
         uKlofy+26h6/jgimvzWUBQQJQk0mwXKRy3v0Vuj04AoctNEwDx9AA2/aUQ+DxxWqQYSe
         MiyM2i9OWt4BGTnchZOLi2NhIb54Zyo/x4xGS8yF4EpVWQx9CZK2/7xo45BO2iKoGrSA
         xB4hdJKWx8dj07htOmvSBdP4BfgDYRvujYLovoPKncD1j7JJQsL1UTOd0lcEpNllIe48
         37ftt/AKzDv9ZvkkBNUcgwUSodTc1HrlMrGLQr3VB3oOmNahAKbStQRe4ff1IUDTb4ON
         0p4Q==
X-Gm-Message-State: APjAAAVBCl13GYwNl/ASMrF9Vg0J92wCxkTckcmUTyDM7HWli7W0vnm+
        cJ173uq/5t+X8Fl4uMbsDe0=
X-Google-Smtp-Source: APXvYqz8JYOG4jX0+Nx/a/2oOfLTJLfsPFwSy2sVnv0K+Rb/0WEmu38V5YC7/KkzO5SEnYtGXLoyUg==
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr22727733wmc.111.1578098236887;
        Fri, 03 Jan 2020 16:37:16 -0800 (PST)
Received: from localhost.localdomain ([188.25.254.226])
        by smtp.gmail.com with ESMTPSA id x10sm59644167wrv.60.2020.01.03.16.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 16:37:16 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 2/3] net: dsa: Make deferred_xmit private to sja1105
Date:   Sat,  4 Jan 2020 02:37:10 +0200
Message-Id: <20200104003711.18366-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200104003711.18366-1-olteanv@gmail.com>
References: <20200104003711.18366-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 3 things that are wrong with the DSA deferred xmit mechanism:

1. Its introduction has made the DSA hotpath ever so slightly more
   inefficient for everybody, since DSA_SKB_CB(skb)->deferred_xmit needs
   to be initialized to false for every transmitted frame, in order to
   figure out whether the driver requested deferral or not (a very rare
   occasion, rare even for the only driver that does use this mechanism:
   sja1105). That was necessary to avoid kfree_skb from freeing the skb.

2. Because L2 PTP is a link-local protocol like STP, it requires
   management routes and deferred xmit with this switch. But as opposed
   to STP, the deferred work mechanism needs to schedule the packet
   rather quickly for the TX timstamp to be collected in time and sent
   to user space. But there is no provision for controlling the
   scheduling priority of this deferred xmit workqueue. Too bad this is
   a rather specific requirement for a feature that nobody else uses
   (more below).

3. Perhaps most importantly, it makes the DSA core adhere a bit too
   much to the NXP company-wide policy "Innovate Where It Doesn't
   Matter". The sja1105 is probably the only DSA switch that requires
   some frames sent from the CPU to be routed to the slave port via an
   out-of-band configuration (register write) rather than in-band (DSA
   tag). And there are indeed very good reasons to not want to do that:
   if that out-of-band register is at the other end of a slow bus such
   as SPI, then you limit that Ethernet flow's throughput to effectively
   the throughput of the SPI bus. So hardware vendors should definitely
   not be encouraged to design this way. We do _not_ want more
   widespread use of this mechanism.

Luckily we have a solution for each of the 3 issues:

For 1, we can just remove that variable in the skb->cb and counteract
the effect of kfree_skb with skb_get, much to the same effect. The
advantage, of course, being that anybody who doesn't use deferred xmit
doesn't need to do any extra operation in the hotpath.

For 2, we can create a kernel thread for each port's deferred xmit work.
If the user switch ports are named swp0, swp1, swp2, the kernel threads
will be named swp0_xmit, swp1_xmit, swp2_xmit (there appears to be a 15
character length limit on kernel thread names). With this, the user can
change the scheduling priority with chrt $(pidof swp2_xmit).

For 3, we can actually move the entire implementation to the sja1105
driver.

So this patch deletes the generic implementation from the DSA core and
adds a new one, more adequate to the requirements of PTP TX
timestamping, in sja1105_main.c.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
- Moved implementation completely within the sja1105 driver.
- Renamed dsa_swpN_xmit to swpN_xmit.

 drivers/net/dsa/sja1105/sja1105_main.c | 96 ++++++++++++++++++++------
 include/linux/dsa/sja1105.h            |  3 +
 include/net/dsa.h                      |  9 ---
 net/dsa/dsa_priv.h                     |  2 -
 net/dsa/slave.c                        | 37 +---------
 net/dsa/tag_sja1105.c                  | 15 +++-
 6 files changed, 93 insertions(+), 69 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 79dd965227bc..61795833c8f5 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1732,6 +1732,16 @@ static int sja1105_setup(struct dsa_switch *ds)
 static void sja1105_teardown(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
+	int port;
+
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		struct sja1105_port *sp = &priv->ports[port];
+
+		if (!dsa_is_user_port(ds, port))
+			continue;
+
+		kthread_destroy_worker(sp->xmit_worker);
+	}
 
 	sja1105_tas_teardown(ds);
 	sja1105_ptp_clock_unregister(ds);
@@ -1753,6 +1763,18 @@ static int sja1105_port_enable(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static void sja1105_port_disable(struct dsa_switch *ds, int port)
+{
+	struct sja1105_private *priv = ds->priv;
+	struct sja1105_port *sp = &priv->ports[port];
+
+	if (!dsa_is_user_port(ds, port))
+		return;
+
+	kthread_cancel_work_sync(&sp->xmit_work);
+	skb_queue_purge(&sp->xmit_queue);
+}
+
 static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
 			     struct sk_buff *skb, bool takets)
 {
@@ -1811,31 +1833,36 @@ static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
 	return NETDEV_TX_OK;
 }
 
+#define work_to_port(work) \
+		container_of((work), struct sja1105_port, xmit_work)
+#define tagger_to_sja1105(t) \
+		container_of((t), struct sja1105_private, tagger_data)
+
 /* Deferred work is unfortunately necessary because setting up the management
  * route cannot be done from atomit context (SPI transfer takes a sleepable
  * lock on the bus)
  */
-static netdev_tx_t sja1105_port_deferred_xmit(struct dsa_switch *ds, int port,
-					      struct sk_buff *skb)
+static void sja1105_port_deferred_xmit(struct kthread_work *work)
 {
-	struct sja1105_private *priv = ds->priv;
-	struct sk_buff *clone;
-
-	mutex_lock(&priv->mgmt_lock);
+	struct sja1105_port *sp = work_to_port(work);
+	struct sja1105_tagger_data *tagger_data = sp->data;
+	struct sja1105_private *priv = tagger_to_sja1105(tagger_data);
+	int port = sp - priv->ports;
+	struct sk_buff *skb;
 
-	/* The clone, if there, was made by dsa_skb_tx_timestamp */
-	clone = DSA_SKB_CB(skb)->clone;
+	while ((skb = skb_dequeue(&sp->xmit_queue)) != NULL) {
+		struct sk_buff *clone = DSA_SKB_CB(skb)->clone;
 
-	sja1105_mgmt_xmit(ds, port, 0, skb, !!clone);
+		mutex_lock(&priv->mgmt_lock);
 
-	if (!clone)
-		goto out;
+		sja1105_mgmt_xmit(priv->ds, port, 0, skb, !!clone);
 
-	sja1105_ptp_txtstamp_skb(ds, port, clone);
+		/* The clone, if there, was made by dsa_skb_tx_timestamp */
+		if (clone)
+			sja1105_ptp_txtstamp_skb(priv->ds, port, clone);
 
-out:
-	mutex_unlock(&priv->mgmt_lock);
-	return NETDEV_TX_OK;
+		mutex_unlock(&priv->mgmt_lock);
+	}
 }
 
 /* The MAXAGE setting belongs to the L2 Forwarding Parameters table,
@@ -1966,6 +1993,7 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_sset_count		= sja1105_get_sset_count,
 	.get_ts_info		= sja1105_get_ts_info,
 	.port_enable		= sja1105_port_enable,
+	.port_disable		= sja1105_port_disable,
 	.port_fdb_dump		= sja1105_fdb_dump,
 	.port_fdb_add		= sja1105_fdb_add,
 	.port_fdb_del		= sja1105_fdb_del,
@@ -1979,7 +2007,6 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_mdb_prepare	= sja1105_mdb_prepare,
 	.port_mdb_add		= sja1105_mdb_add,
 	.port_mdb_del		= sja1105_mdb_del,
-	.port_deferred_xmit	= sja1105_port_deferred_xmit,
 	.port_hwtstamp_get	= sja1105_hwtstamp_get,
 	.port_hwtstamp_set	= sja1105_hwtstamp_set,
 	.port_rxtstamp		= sja1105_port_rxtstamp,
@@ -2031,7 +2058,7 @@ static int sja1105_probe(struct spi_device *spi)
 	struct device *dev = &spi->dev;
 	struct sja1105_private *priv;
 	struct dsa_switch *ds;
-	int rc, i;
+	int rc, port;
 
 	if (!dev->of_node) {
 		dev_err(dev, "No DTS bindings for SJA1105 driver\n");
@@ -2096,15 +2123,42 @@ static int sja1105_probe(struct spi_device *spi)
 		return rc;
 
 	/* Connections between dsa_port and sja1105_port */
-	for (i = 0; i < SJA1105_NUM_PORTS; i++) {
-		struct sja1105_port *sp = &priv->ports[i];
+	for (port = 0; port < SJA1105_NUM_PORTS; port++) {
+		struct sja1105_port *sp = &priv->ports[port];
+		struct dsa_port *dp = dsa_to_port(ds, port);
+		struct net_device *slave;
+
+		if (!dsa_is_user_port(ds, port))
+			continue;
 
-		dsa_to_port(ds, i)->priv = sp;
-		sp->dp = dsa_to_port(ds, i);
+		dp->priv = sp;
+		sp->dp = dp;
 		sp->data = tagger_data;
+		slave = dp->slave;
+		kthread_init_work(&sp->xmit_work, sja1105_port_deferred_xmit);
+		sp->xmit_worker = kthread_create_worker(0, "%s_xmit",
+							slave->name);
+		if (IS_ERR(sp->xmit_worker)) {
+			rc = PTR_ERR(sp->xmit_worker);
+			dev_err(ds->dev,
+				"failed to create deferred xmit thread: %d\n",
+				rc);
+			goto out;
+		}
+		skb_queue_head_init(&sp->xmit_queue);
 	}
 
 	return 0;
+out:
+	while (port-- > 0) {
+		struct sja1105_port *sp = &priv->ports[port];
+
+		if (!dsa_is_user_port(ds, port))
+			continue;
+
+		kthread_destroy_worker(sp->xmit_worker);
+	}
+	return rc;
 }
 
 static int sja1105_remove(struct spi_device *spi)
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 317e05b2584b..fa5735c353cd 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -53,6 +53,9 @@ struct sja1105_skb_cb {
 	((struct sja1105_skb_cb *)DSA_SKB_CB_PRIV(skb))
 
 struct sja1105_port {
+	struct kthread_worker *xmit_worker;
+	struct kthread_work xmit_work;
+	struct sk_buff_head xmit_queue;
 	struct sja1105_tagger_data *data;
 	struct dsa_port *dp;
 	bool hwts_tx_en;
diff --git a/include/net/dsa.h b/include/net/dsa.h
index da5578db228e..23b1c58656d4 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -90,7 +90,6 @@ struct dsa_device_ops {
 
 struct dsa_skb_cb {
 	struct sk_buff *clone;
-	bool deferred_xmit;
 };
 
 struct __dsa_skb_cb {
@@ -192,9 +191,6 @@ struct dsa_port {
 	struct phylink		*pl;
 	struct phylink_config	pl_config;
 
-	struct work_struct	xmit_work;
-	struct sk_buff_head	xmit_queue;
-
 	struct list_head list;
 
 	/*
@@ -564,11 +560,6 @@ struct dsa_switch_ops {
 	bool	(*port_rxtstamp)(struct dsa_switch *ds, int port,
 				 struct sk_buff *skb, unsigned int type);
 
-	/*
-	 * Deferred frame Tx
-	 */
-	netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
-					  struct sk_buff *skb);
 	/* Devlink parameters */
 	int	(*devlink_param_get)(struct dsa_switch *ds, u32 id,
 				     struct devlink_param_gset_ctx *ctx);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 09ea2fd78c74..8a162605b861 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -162,8 +162,6 @@ int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
 
-void *dsa_defer_xmit(struct sk_buff *skb, struct net_device *dev);
-
 static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
 {
 	struct dsa_slave_priv *p = netdev_priv(dev);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 78ffc87dc25e..c1828bdc79dc 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -116,9 +116,6 @@ static int dsa_slave_close(struct net_device *dev)
 	struct net_device *master = dsa_slave_to_master(dev);
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 
-	cancel_work_sync(&dp->xmit_work);
-	skb_queue_purge(&dp->xmit_queue);
-
 	phylink_stop(dp->pl);
 
 	dsa_port_disable(dp);
@@ -518,7 +515,6 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	s->tx_bytes += skb->len;
 	u64_stats_update_end(&s->syncp);
 
-	DSA_SKB_CB(skb)->deferred_xmit = false;
 	DSA_SKB_CB(skb)->clone = NULL;
 
 	/* Identify PTP protocol packets, clone them, and pass them to the
@@ -531,39 +527,13 @@ static netdev_tx_t dsa_slave_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	nskb = p->xmit(skb, dev);
 	if (!nskb) {
-		if (!DSA_SKB_CB(skb)->deferred_xmit)
-			kfree_skb(skb);
+		kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
 	return dsa_enqueue_skb(nskb, dev);
 }
 
-void *dsa_defer_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	struct dsa_port *dp = dsa_slave_to_port(dev);
-
-	DSA_SKB_CB(skb)->deferred_xmit = true;
-
-	skb_queue_tail(&dp->xmit_queue, skb);
-	schedule_work(&dp->xmit_work);
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(dsa_defer_xmit);
-
-static void dsa_port_xmit_work(struct work_struct *work)
-{
-	struct dsa_port *dp = container_of(work, struct dsa_port, xmit_work);
-	struct dsa_switch *ds = dp->ds;
-	struct sk_buff *skb;
-
-	if (unlikely(!ds->ops->port_deferred_xmit))
-		return;
-
-	while ((skb = skb_dequeue(&dp->xmit_queue)) != NULL)
-		ds->ops->port_deferred_xmit(ds, dp->index, skb);
-}
-
 /* ethtool operations *******************************************************/
 
 static void dsa_slave_get_drvinfo(struct net_device *dev,
@@ -1367,9 +1337,6 @@ int dsa_slave_suspend(struct net_device *slave_dev)
 	if (!netif_running(slave_dev))
 		return 0;
 
-	cancel_work_sync(&dp->xmit_work);
-	skb_queue_purge(&dp->xmit_queue);
-
 	netif_device_detach(slave_dev);
 
 	rtnl_lock();
@@ -1455,8 +1422,6 @@ int dsa_slave_create(struct dsa_port *port)
 	}
 	p->dp = port;
 	INIT_LIST_HEAD(&p->mall_tc_list);
-	INIT_WORK(&port->xmit_work, dsa_port_xmit_work);
-	skb_queue_head_init(&port->xmit_queue);
 	p->xmit = cpu_dp->tag_ops->xmit;
 	port->slave = slave_dev;
 
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 63ef2a14c934..7c2b84393cc6 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -83,6 +83,19 @@ static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 	return false;
 }
 
+/* Calls sja1105_port_deferred_xmit in sja1105_main.c */
+static struct sk_buff *sja1105_defer_xmit(struct sja1105_port *sp,
+					  struct sk_buff *skb)
+{
+	/* Increase refcount so the kfree_skb in dsa_slave_xmit
+	 * won't really free the packet.
+	 */
+	skb_queue_tail(&sp->xmit_queue, skb_get(skb));
+	kthread_queue_work(sp->xmit_worker, &sp->xmit_work);
+
+	return NULL;
+}
+
 static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
@@ -97,7 +110,7 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	 * is the .port_deferred_xmit driver callback.
 	 */
 	if (unlikely(sja1105_is_link_local(skb)))
-		return dsa_defer_xmit(skb, netdev);
+		return sja1105_defer_xmit(dp->priv, skb);
 
 	/* If we are under a vlan_filtering bridge, IP termination on
 	 * switch ports based on 802.1Q tags is simply too brittle to
-- 
2.17.1

