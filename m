Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214C62EF5D4
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbhAHQdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728367AbhAHQdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:33:15 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885DBC06129F
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 08:32:31 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id ce23so15273861ejb.8
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 08:32:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Txs71qFcti7jW5li5cu6lszM23fwsuzTg8OlUoo2SPU=;
        b=jVib4MJqrtlos5hLYVM8MpeD4yCCP7u48WnoiB7y9AwxLitZ65/8HKbX0Gy/+yOApj
         Dt+2Iyg6NrmujsceAJpoY0RkVh9N/1knNhTOnsxC1adH864k7odNsYggulOtzuYHFM4p
         QVdRcI4YLMWbqFotmzCtyQxd6vYQFlfnEUYzdhsRfGxj18nEpImD6ihKVGm1cXfoe8iq
         k6RWwZlZ7VtTRRf1Pc3U4BHBOOOuaudlHaBeUPQVDekJyXyB0hwDw6j3IuWaynlyyrAZ
         j2Lvqthm6NxekwwF+5o/JKvGkF5r55TgEkoGbHOGWbmxhDx3xmjH1TUU0wVZ7p2gN2lG
         QXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Txs71qFcti7jW5li5cu6lszM23fwsuzTg8OlUoo2SPU=;
        b=tzXzoo02m9l8ikEds2azYsnU9+thvxolmxCO3jGKYiUBsj1Q94EMQslc4iN/OnnHuU
         JUFG26ikS1isZF0PG1bePv7WHKJCSF/DjIFkIkKkeFMtocFwFujs1CXtX2vC57GRtI7o
         N2RV8qg7G0T12o/rZwns97QKp4RI+Yog6It38Dz9/HDTV3r8IOIbOWgDJzHLdeC+ofNh
         BhYxLgVxKKWKF3mNetw3lJaMOIZRiZGLR8cYz3IjsmGKI2Dc8/QR7dZhmgDDy6jjGvl7
         2DZlMH0TCD9WkVB96pxzUEtcj+BZJFUoWyx73Qypcc4HgCuWMQkAFTS6E+3sYTBwofMD
         AMbw==
X-Gm-Message-State: AOAM533HKkyoJrq1mhcklkOZvyAmv5XDVjIG850Afq8P8X48cJh7Sy0l
        vx1suSeqGlvpyKK5EP1PMqnYJZ31LYs=
X-Google-Smtp-Source: ABdhPJz7GZB7eH+YN4XrocQ6VZwneIT2r2gUQpOoY8aHY2tN0HSk8tOjB6EKOsdt822KMlxX4sVrPA==
X-Received: by 2002:a17:906:fcda:: with SMTP id qx26mr3180920ejb.213.1610123549059;
        Fri, 08 Jan 2021 08:32:29 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x6sm3957737edl.67.2021.01.08.08.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 08:32:28 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH v5 net-next 07/16] net: remove return value from dev_get_stats
Date:   Fri,  8 Jan 2021 18:31:50 +0200
Message-Id: <20210108163159.358043-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108163159.358043-1-olteanv@gmail.com>
References: <20210108163159.358043-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

After commit 28172739f0a2 ("net: fix 64 bit counters on 32 bit arches"),
dev_get_stats got an additional argument for storage of statistics. At
this point, dev_get_stats could return either the passed "storage"
argument, or the output of .ndo_get_stats64.

Then commit caf586e5f23c ("net: add a core netdev->rx_dropped counter")
came, and the output of .ndo_get_stats64 (still returning a pointer to
struct rtnl_link_stats64) started being ignored.

Then came commit bc1f44709cf2 ("net: make ndo_get_stats64 a void
function") which made .ndo_get_stats64 stop returning anything.

So now, dev_get_stats always reports the "storage" pointer received as
argument. This is useless. Some drivers are dealing with unnecessary
complexity due to this, using another pointer to poke around the
returned statistics, when they can do that directly through the
stack-allocated struct rtnl_link_stats64.

Refactor these callers to ignore the return value completely and just
access the values from their struct rtnl_link_stats64 local variable.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
- Renamed "stats" to "dev_stats" in fcoe_transport.c.
- Slightly reworded the commit title and message.

Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Patch is new.

 arch/s390/appldata/appldata_net_sum.c         | 25 +++++----
 drivers/leds/trigger/ledtrig-netdev.c         |  9 ++--
 drivers/net/bonding/bond_main.c               |  7 ++-
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  | 51 +++++++++----------
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  7 ++-
 drivers/net/ethernet/intel/ixgbevf/ethtool.c  |  7 ++-
 drivers/net/net_failover.c                    | 13 +++--
 drivers/parisc/led.c                          |  9 ++--
 drivers/scsi/fcoe/fcoe_transport.c            |  6 +--
 drivers/usb/gadget/function/rndis.c           | 45 ++++++----------
 include/linux/netdevice.h                     |  3 +-
 net/8021q/vlanproc.c                          | 15 +++---
 net/core/dev.c                                |  6 +--
 net/core/net-procfs.c                         | 35 ++++++-------
 net/core/net-sysfs.c                          |  7 +--
 net/openvswitch/vport.c                       | 25 +++++----
 16 files changed, 123 insertions(+), 147 deletions(-)

diff --git a/arch/s390/appldata/appldata_net_sum.c b/arch/s390/appldata/appldata_net_sum.c
index 4db886980cba..6146606ac9a3 100644
--- a/arch/s390/appldata/appldata_net_sum.c
+++ b/arch/s390/appldata/appldata_net_sum.c
@@ -81,19 +81,18 @@ static void appldata_get_net_sum_data(void *data)
 	netif_lists_lock(&init_net);
 
 	for_each_netdev(&init_net, dev) {
-		const struct rtnl_link_stats64 *stats;
-		struct rtnl_link_stats64 temp;
-
-		stats = dev_get_stats(dev, &temp);
-		rx_packets += stats->rx_packets;
-		tx_packets += stats->tx_packets;
-		rx_bytes   += stats->rx_bytes;
-		tx_bytes   += stats->tx_bytes;
-		rx_errors  += stats->rx_errors;
-		tx_errors  += stats->tx_errors;
-		rx_dropped += stats->rx_dropped;
-		tx_dropped += stats->tx_dropped;
-		collisions += stats->collisions;
+		struct rtnl_link_stats64 stats;
+
+		dev_get_stats(dev, &stats);
+		rx_packets += stats.rx_packets;
+		tx_packets += stats.tx_packets;
+		rx_bytes   += stats.rx_bytes;
+		tx_bytes   += stats.tx_bytes;
+		rx_errors  += stats.rx_errors;
+		tx_errors  += stats.tx_errors;
+		rx_dropped += stats.rx_dropped;
+		tx_dropped += stats.tx_dropped;
+		collisions += stats.collisions;
 		i++;
 	}
 
diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index d5e774d83021..4382ee278309 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -347,9 +347,8 @@ static void netdev_trig_work(struct work_struct *work)
 {
 	struct led_netdev_data *trigger_data =
 		container_of(work, struct led_netdev_data, work.work);
-	struct rtnl_link_stats64 *dev_stats;
+	struct rtnl_link_stats64 dev_stats;
 	unsigned int new_activity;
-	struct rtnl_link_stats64 temp;
 	unsigned long interval;
 	int invert;
 
@@ -364,12 +363,12 @@ static void netdev_trig_work(struct work_struct *work)
 	    !test_bit(NETDEV_LED_RX, &trigger_data->mode))
 		return;
 
-	dev_stats = dev_get_stats(trigger_data->net_dev, &temp);
+	dev_get_stats(trigger_data->net_dev, &dev_stats);
 	new_activity =
 	    (test_bit(NETDEV_LED_TX, &trigger_data->mode) ?
-		dev_stats->tx_packets : 0) +
+		dev_stats.tx_packets : 0) +
 	    (test_bit(NETDEV_LED_RX, &trigger_data->mode) ?
-		dev_stats->rx_packets : 0);
+		dev_stats.rx_packets : 0);
 
 	if (trigger_data->last_activity != new_activity) {
 		led_stop_software_blink(trigger_data->led_cdev);
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 5fe5232cc3f3..714aa0e5d041 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3753,13 +3753,12 @@ static void bond_get_stats(struct net_device *bond_dev,
 	memcpy(stats, &bond->bond_stats, sizeof(*stats));
 
 	bond_for_each_slave_rcu(bond, slave, iter) {
-		const struct rtnl_link_stats64 *new =
-			dev_get_stats(slave->dev, &temp);
+		dev_get_stats(slave->dev, &temp);
 
-		bond_fold_stats(stats, new, &slave->slave_stats);
+		bond_fold_stats(stats, &temp, &slave->slave_stats);
 
 		/* save off the slave stats for the next run */
-		memcpy(&slave->slave_stats, new, sizeof(*new));
+		memcpy(&slave->slave_stats, &temp, sizeof(temp));
 	}
 
 	memcpy(&bond->bond_stats, stats, sizeof(*stats));
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index a6e3f07caf99..ee2172011051 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -839,8 +839,7 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 	u64 *p = data;
 	struct hns_nic_priv *priv = netdev_priv(netdev);
 	struct hnae_handle *h = priv->ae_handle;
-	const struct rtnl_link_stats64 *net_stats;
-	struct rtnl_link_stats64 temp;
+	struct rtnl_link_stats64 net_stats;
 
 	if (!h->dev->ops->get_stats || !h->dev->ops->update_stats) {
 		netdev_err(netdev, "get_stats or update_stats is null!\n");
@@ -849,32 +848,32 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 
 	h->dev->ops->update_stats(h, &netdev->stats);
 
-	net_stats = dev_get_stats(netdev, &temp);
+	dev_get_stats(netdev, &net_stats);
 
 	/* get netdev statistics */
-	p[0] = net_stats->rx_packets;
-	p[1] = net_stats->tx_packets;
-	p[2] = net_stats->rx_bytes;
-	p[3] = net_stats->tx_bytes;
-	p[4] = net_stats->rx_errors;
-	p[5] = net_stats->tx_errors;
-	p[6] = net_stats->rx_dropped;
-	p[7] = net_stats->tx_dropped;
-	p[8] = net_stats->multicast;
-	p[9] = net_stats->collisions;
-	p[10] = net_stats->rx_over_errors;
-	p[11] = net_stats->rx_crc_errors;
-	p[12] = net_stats->rx_frame_errors;
-	p[13] = net_stats->rx_fifo_errors;
-	p[14] = net_stats->rx_missed_errors;
-	p[15] = net_stats->tx_aborted_errors;
-	p[16] = net_stats->tx_carrier_errors;
-	p[17] = net_stats->tx_fifo_errors;
-	p[18] = net_stats->tx_heartbeat_errors;
-	p[19] = net_stats->rx_length_errors;
-	p[20] = net_stats->tx_window_errors;
-	p[21] = net_stats->rx_compressed;
-	p[22] = net_stats->tx_compressed;
+	p[0] = net_stats.rx_packets;
+	p[1] = net_stats.tx_packets;
+	p[2] = net_stats.rx_bytes;
+	p[3] = net_stats.tx_bytes;
+	p[4] = net_stats.rx_errors;
+	p[5] = net_stats.tx_errors;
+	p[6] = net_stats.rx_dropped;
+	p[7] = net_stats.tx_dropped;
+	p[8] = net_stats.multicast;
+	p[9] = net_stats.collisions;
+	p[10] = net_stats.rx_over_errors;
+	p[11] = net_stats.rx_crc_errors;
+	p[12] = net_stats.rx_frame_errors;
+	p[13] = net_stats.rx_fifo_errors;
+	p[14] = net_stats.rx_missed_errors;
+	p[15] = net_stats.tx_aborted_errors;
+	p[16] = net_stats.tx_carrier_errors;
+	p[17] = net_stats.tx_fifo_errors;
+	p[18] = net_stats.tx_heartbeat_errors;
+	p[19] = net_stats.rx_length_errors;
+	p[20] = net_stats.tx_window_errors;
+	p[21] = net_stats.rx_compressed;
+	p[22] = net_stats.tx_compressed;
 
 	p[23] = netdev->rx_dropped.counter;
 	p[24] = netdev->tx_dropped.counter;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index a280aa34ca1d..2b8084664403 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1295,19 +1295,18 @@ static void ixgbe_get_ethtool_stats(struct net_device *netdev,
 				    struct ethtool_stats *stats, u64 *data)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
-	struct rtnl_link_stats64 temp;
-	const struct rtnl_link_stats64 *net_stats;
+	struct rtnl_link_stats64 net_stats;
 	unsigned int start;
 	struct ixgbe_ring *ring;
 	int i, j;
 	char *p = NULL;
 
 	ixgbe_update_stats(adapter);
-	net_stats = dev_get_stats(netdev, &temp);
+	dev_get_stats(netdev, &net_stats);
 	for (i = 0; i < IXGBE_GLOBAL_STATS_LEN; i++) {
 		switch (ixgbe_gstrings_stats[i].type) {
 		case NETDEV_STATS:
-			p = (char *) net_stats +
+			p = (char *) &net_stats +
 					ixgbe_gstrings_stats[i].stat_offset;
 			break;
 		case IXGBE_STATS:
diff --git a/drivers/net/ethernet/intel/ixgbevf/ethtool.c b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
index e49fb1cd9a99..3b9b7e5c2998 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ethtool.c
@@ -420,19 +420,18 @@ static void ixgbevf_get_ethtool_stats(struct net_device *netdev,
 				      struct ethtool_stats *stats, u64 *data)
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
-	struct rtnl_link_stats64 temp;
-	const struct rtnl_link_stats64 *net_stats;
+	struct rtnl_link_stats64 net_stats;
 	unsigned int start;
 	struct ixgbevf_ring *ring;
 	int i, j;
 	char *p;
 
 	ixgbevf_update_stats(adapter);
-	net_stats = dev_get_stats(netdev, &temp);
+	dev_get_stats(netdev, &net_stats);
 	for (i = 0; i < IXGBEVF_GLOBAL_STATS_LEN; i++) {
 		switch (ixgbevf_gstrings_stats[i].type) {
 		case NETDEV_STATS:
-			p = (char *)net_stats +
+			p = (char *)&net_stats +
 					ixgbevf_gstrings_stats[i].stat_offset;
 			break;
 		case IXGBEVF_STATS:
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 2a4892402ed8..4f83165412bd 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -183,7 +183,6 @@ static void net_failover_get_stats(struct net_device *dev,
 				   struct rtnl_link_stats64 *stats)
 {
 	struct net_failover_info *nfo_info = netdev_priv(dev);
-	const struct rtnl_link_stats64 *new;
 	struct rtnl_link_stats64 temp;
 	struct net_device *slave_dev;
 
@@ -194,16 +193,16 @@ static void net_failover_get_stats(struct net_device *dev,
 
 	slave_dev = rcu_dereference(nfo_info->primary_dev);
 	if (slave_dev) {
-		new = dev_get_stats(slave_dev, &temp);
-		net_failover_fold_stats(stats, new, &nfo_info->primary_stats);
-		memcpy(&nfo_info->primary_stats, new, sizeof(*new));
+		dev_get_stats(slave_dev, &temp);
+		net_failover_fold_stats(stats, &temp, &nfo_info->primary_stats);
+		memcpy(&nfo_info->primary_stats, &temp, sizeof(temp));
 	}
 
 	slave_dev = rcu_dereference(nfo_info->standby_dev);
 	if (slave_dev) {
-		new = dev_get_stats(slave_dev, &temp);
-		net_failover_fold_stats(stats, new, &nfo_info->standby_stats);
-		memcpy(&nfo_info->standby_stats, new, sizeof(*new));
+		dev_get_stats(slave_dev, &temp);
+		net_failover_fold_stats(stats, &temp, &nfo_info->standby_stats);
+		memcpy(&nfo_info->standby_stats, &temp, sizeof(temp));
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index c8c6b2301dc9..cc6108785323 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -360,8 +360,7 @@ static __inline__ int led_get_net_activity(void)
 
 	for_each_netdev(&init_net, dev) {
 		struct in_device *in_dev = in_dev_get(dev);
-		const struct rtnl_link_stats64 *stats;
-		struct rtnl_link_stats64 temp;
+		struct rtnl_link_stats64 stats;
 
 		if (!in_dev || !in_dev->ifa_list ||
 		    ipv4_is_loopback(in_dev->ifa_list->ifa_local)) {
@@ -371,9 +370,9 @@ static __inline__ int led_get_net_activity(void)
 
 		in_dev_put(in_dev);
 
-		stats = dev_get_stats(dev, &temp);
-		rx_total += stats->rx_packets;
-		tx_total += stats->tx_packets;
+		dev_get_stats(dev, &stats);
+		rx_total += stats.rx_packets;
+		tx_total += stats.tx_packets;
 	}
 
 	netif_lists_unlock(&init_net);
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index b927b3d84523..213ee9efb044 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -170,11 +170,11 @@ void __fcoe_get_lesb(struct fc_lport *lport,
 		     struct fc_els_lesb *fc_lesb,
 		     struct net_device *netdev)
 {
+	struct rtnl_link_stats64 dev_stats;
 	unsigned int cpu;
 	u32 lfc, vlfc, mdac;
 	struct fc_stats *stats;
 	struct fcoe_fc_els_lesb *lesb;
-	struct rtnl_link_stats64 temp;
 
 	lfc = 0;
 	vlfc = 0;
@@ -190,8 +190,8 @@ void __fcoe_get_lesb(struct fc_lport *lport,
 	lesb->lesb_link_fail = htonl(lfc);
 	lesb->lesb_vlink_fail = htonl(vlfc);
 	lesb->lesb_miss_fka = htonl(mdac);
-	lesb->lesb_fcs_error =
-			htonl(dev_get_stats(netdev, &temp)->rx_crc_errors);
+	dev_get_stats(netdev, &dev_stats);
+	lesb->lesb_fcs_error = htonl(dev_stats.rx_crc_errors);
 }
 EXPORT_SYMBOL_GPL(__fcoe_get_lesb);
 
diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index 64de9f1b874c..7ec29e007ae9 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -169,14 +169,13 @@ static const u32 oid_supported_list[] = {
 static int gen_ndis_query_resp(struct rndis_params *params, u32 OID, u8 *buf,
 			       unsigned buf_len, rndis_resp_t *r)
 {
+	struct rtnl_link_stats64 stats;
 	int retval = -ENOTSUPP;
 	u32 length = 4;	/* usually */
 	__le32 *outbuf;
 	int i, count;
 	rndis_query_cmplt_type *resp;
 	struct net_device *net;
-	struct rtnl_link_stats64 temp;
-	const struct rtnl_link_stats64 *stats;
 
 	if (!r) return -ENOMEM;
 	resp = (rndis_query_cmplt_type *)r->buf;
@@ -199,7 +198,7 @@ static int gen_ndis_query_resp(struct rndis_params *params, u32 OID, u8 *buf,
 	resp->InformationBufferOffset = cpu_to_le32(16);
 
 	net = params->dev;
-	stats = dev_get_stats(net, &temp);
+	dev_get_stats(net, &stats);
 
 	switch (OID) {
 
@@ -353,51 +352,41 @@ static int gen_ndis_query_resp(struct rndis_params *params, u32 OID, u8 *buf,
 	case RNDIS_OID_GEN_XMIT_OK:
 		if (rndis_debug > 1)
 			pr_debug("%s: RNDIS_OID_GEN_XMIT_OK\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->tx_packets
-				- stats->tx_errors - stats->tx_dropped);
-			retval = 0;
-		}
+		*outbuf = cpu_to_le32(stats.tx_packets - stats.tx_errors -
+				      stats.tx_dropped);
+		retval = 0;
 		break;
 
 	/* mandatory */
 	case RNDIS_OID_GEN_RCV_OK:
 		if (rndis_debug > 1)
 			pr_debug("%s: RNDIS_OID_GEN_RCV_OK\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->rx_packets
-				- stats->rx_errors - stats->rx_dropped);
-			retval = 0;
-		}
+		*outbuf = cpu_to_le32(stats.rx_packets - stats.rx_errors -
+				      stats.rx_dropped);
+		retval = 0;
 		break;
 
 	/* mandatory */
 	case RNDIS_OID_GEN_XMIT_ERROR:
 		if (rndis_debug > 1)
 			pr_debug("%s: RNDIS_OID_GEN_XMIT_ERROR\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->tx_errors);
-			retval = 0;
-		}
+		*outbuf = cpu_to_le32(stats.tx_errors);
+		retval = 0;
 		break;
 
 	/* mandatory */
 	case RNDIS_OID_GEN_RCV_ERROR:
 		if (rndis_debug > 1)
 			pr_debug("%s: RNDIS_OID_GEN_RCV_ERROR\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->rx_errors);
-			retval = 0;
-		}
+		*outbuf = cpu_to_le32(stats.rx_errors);
+		retval = 0;
 		break;
 
 	/* mandatory */
 	case RNDIS_OID_GEN_RCV_NO_BUFFER:
 		pr_debug("%s: RNDIS_OID_GEN_RCV_NO_BUFFER\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->rx_dropped);
-			retval = 0;
-		}
+		*outbuf = cpu_to_le32(stats.rx_dropped);
+		retval = 0;
 		break;
 
 	/* ieee802.3 OIDs (table 4-3) */
@@ -449,10 +438,8 @@ static int gen_ndis_query_resp(struct rndis_params *params, u32 OID, u8 *buf,
 	/* mandatory */
 	case RNDIS_OID_802_3_RCV_ERROR_ALIGNMENT:
 		pr_debug("%s: RNDIS_OID_802_3_RCV_ERROR_ALIGNMENT\n", __func__);
-		if (stats) {
-			*outbuf = cpu_to_le32(stats->rx_frame_errors);
-			retval = 0;
-		}
+		*outbuf = cpu_to_le32(stats.rx_frame_errors);
+		retval = 0;
 		break;
 
 	/* mandatory */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8aae2386bd37..9faaacbfe45a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4545,8 +4545,7 @@ void netdev_notify_peers(struct net_device *dev);
 void netdev_features_change(struct net_device *dev);
 /* Load a device via the kmod */
 void dev_load(struct net *net, const char *name);
-struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
-					struct rtnl_link_stats64 *storage);
+void dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage);
 void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats);
 void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
diff --git a/net/8021q/vlanproc.c b/net/8021q/vlanproc.c
index ec87dea23719..3a6682d79630 100644
--- a/net/8021q/vlanproc.c
+++ b/net/8021q/vlanproc.c
@@ -242,26 +242,25 @@ static int vlandev_seq_show(struct seq_file *seq, void *offset)
 {
 	struct net_device *vlandev = (struct net_device *) seq->private;
 	const struct vlan_dev_priv *vlan = vlan_dev_priv(vlandev);
-	struct rtnl_link_stats64 temp;
-	const struct rtnl_link_stats64 *stats;
 	static const char fmt64[] = "%30s %12llu\n";
+	struct rtnl_link_stats64 stats;
 	int i;
 
 	if (!is_vlan_dev(vlandev))
 		return 0;
 
-	stats = dev_get_stats(vlandev, &temp);
+	dev_get_stats(vlandev, &stats);
 	seq_printf(seq,
 		   "%s  VID: %d	 REORDER_HDR: %i  dev->priv_flags: %hx\n",
 		   vlandev->name, vlan->vlan_id,
 		   (int)(vlan->flags & 1), vlandev->priv_flags);
 
-	seq_printf(seq, fmt64, "total frames received", stats->rx_packets);
-	seq_printf(seq, fmt64, "total bytes received", stats->rx_bytes);
-	seq_printf(seq, fmt64, "Broadcast/Multicast Rcvd", stats->multicast);
+	seq_printf(seq, fmt64, "total frames received", stats.rx_packets);
+	seq_printf(seq, fmt64, "total bytes received", stats.rx_bytes);
+	seq_printf(seq, fmt64, "Broadcast/Multicast Rcvd", stats.multicast);
 	seq_puts(seq, "\n");
-	seq_printf(seq, fmt64, "total frames transmitted", stats->tx_packets);
-	seq_printf(seq, fmt64, "total bytes transmitted", stats->tx_bytes);
+	seq_printf(seq, fmt64, "total frames transmitted", stats.tx_packets);
+	seq_printf(seq, fmt64, "total bytes transmitted", stats.tx_bytes);
 	seq_printf(seq, "Device: %s", vlan->real_dev->name);
 	/* now show all PRIORITY mappings relating to this VLAN */
 	seq_printf(seq, "\nINGRESS priority mappings: "
diff --git a/net/core/dev.c b/net/core/dev.c
index 53c12f92025c..2b423d7a39e7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10398,13 +10398,12 @@ EXPORT_SYMBOL(netdev_stats_to_stats64);
  *	@dev: device to get statistics from
  *	@storage: place to store stats
  *
- *	Get network statistics from device. Return @storage.
+ *	Get network statistics from device.
  *	The device driver may provide its own method by setting
  *	dev->netdev_ops->get_stats64 or dev->netdev_ops->get_stats;
  *	otherwise the internal statistics structure is used.
  */
-struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
-					struct rtnl_link_stats64 *storage)
+void dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 
@@ -10419,7 +10418,6 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 	storage->rx_dropped += (unsigned long)atomic_long_read(&dev->rx_dropped);
 	storage->tx_dropped += (unsigned long)atomic_long_read(&dev->tx_dropped);
 	storage->rx_nohandler += (unsigned long)atomic_long_read(&dev->rx_nohandler);
-	return storage;
 }
 EXPORT_SYMBOL(dev_get_stats);
 
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 4784703c1e39..64666ba7ccab 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -80,26 +80,27 @@ static void dev_seq_stop(struct seq_file *seq, void *v)
 
 static void dev_seq_printf_stats(struct seq_file *seq, struct net_device *dev)
 {
-	struct rtnl_link_stats64 temp;
-	const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
+	struct rtnl_link_stats64 stats;
+
+	dev_get_stats(dev, &stats);
 
 	seq_printf(seq, "%6s: %7llu %7llu %4llu %4llu %4llu %5llu %10llu %9llu "
 		   "%8llu %7llu %4llu %4llu %4llu %5llu %7llu %10llu\n",
-		   dev->name, stats->rx_bytes, stats->rx_packets,
-		   stats->rx_errors,
-		   stats->rx_dropped + stats->rx_missed_errors,
-		   stats->rx_fifo_errors,
-		   stats->rx_length_errors + stats->rx_over_errors +
-		    stats->rx_crc_errors + stats->rx_frame_errors,
-		   stats->rx_compressed, stats->multicast,
-		   stats->tx_bytes, stats->tx_packets,
-		   stats->tx_errors, stats->tx_dropped,
-		   stats->tx_fifo_errors, stats->collisions,
-		   stats->tx_carrier_errors +
-		    stats->tx_aborted_errors +
-		    stats->tx_window_errors +
-		    stats->tx_heartbeat_errors,
-		   stats->tx_compressed);
+		   dev->name, stats.rx_bytes, stats.rx_packets,
+		   stats.rx_errors,
+		   stats.rx_dropped + stats.rx_missed_errors,
+		   stats.rx_fifo_errors,
+		   stats.rx_length_errors + stats.rx_over_errors +
+		    stats.rx_crc_errors + stats.rx_frame_errors,
+		   stats.rx_compressed, stats.multicast,
+		   stats.tx_bytes, stats.tx_packets,
+		   stats.tx_errors, stats.tx_dropped,
+		   stats.tx_fifo_errors, stats.collisions,
+		   stats.tx_carrier_errors +
+		    stats.tx_aborted_errors +
+		    stats.tx_window_errors +
+		    stats.tx_heartbeat_errors,
+		   stats.tx_compressed);
 }
 
 /*
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 8604183678fc..5d89c85b42d4 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -586,10 +586,11 @@ static ssize_t netstat_show(const struct device *d,
 		offset % sizeof(u64) != 0);
 
 	if (dev_isalive(dev)) {
-		struct rtnl_link_stats64 temp;
-		const struct rtnl_link_stats64 *stats = dev_get_stats(dev, &temp);
+		struct rtnl_link_stats64 stats;
 
-		ret = sprintf(buf, fmt_u64, *(u64 *)(((u8 *)stats) + offset));
+		dev_get_stats(dev, &stats);
+
+		ret = sprintf(buf, fmt_u64, *(u64 *)(((u8 *)&stats) + offset));
 	}
 
 	return ret;
diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 4ed7e52c7012..215a818bf9ce 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -269,19 +269,18 @@ void ovs_vport_del(struct vport *vport)
  */
 void ovs_vport_get_stats(struct vport *vport, struct ovs_vport_stats *stats)
 {
-	const struct rtnl_link_stats64 *dev_stats;
-	struct rtnl_link_stats64 temp;
-
-	dev_stats = dev_get_stats(vport->dev, &temp);
-	stats->rx_errors  = dev_stats->rx_errors;
-	stats->tx_errors  = dev_stats->tx_errors;
-	stats->tx_dropped = dev_stats->tx_dropped;
-	stats->rx_dropped = dev_stats->rx_dropped;
-
-	stats->rx_bytes	  = dev_stats->rx_bytes;
-	stats->rx_packets = dev_stats->rx_packets;
-	stats->tx_bytes	  = dev_stats->tx_bytes;
-	stats->tx_packets = dev_stats->tx_packets;
+	struct rtnl_link_stats64 dev_stats;
+
+	dev_get_stats(vport->dev, &dev_stats);
+	stats->rx_errors  = dev_stats.rx_errors;
+	stats->tx_errors  = dev_stats.tx_errors;
+	stats->tx_dropped = dev_stats.tx_dropped;
+	stats->rx_dropped = dev_stats.rx_dropped;
+
+	stats->rx_bytes	  = dev_stats.rx_bytes;
+	stats->rx_packets = dev_stats.rx_packets;
+	stats->tx_bytes	  = dev_stats.tx_bytes;
+	stats->tx_packets = dev_stats.tx_packets;
 }
 
 /**
-- 
2.25.1

