Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1052EC7B1
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbhAGBZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbhAGBZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 20:25:56 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACF3C0612F3
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 17:25:16 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id qw4so7510431ejb.12
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 17:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9hcFonlCv5i0BsUw49e8mYBm+WY5pAuaSjOGGq/fj10=;
        b=FTcsa4osk0+iRvNL9Uvz/FkguW4aZj+ObHzk0W2ZMVbPxgLvDNX7Spt7e3EofPb1jr
         ZAJHigTVvpwghNQhsWDMEZD56kpehmjWvl7euNoCGR0cRDywzrFf2+ovIxQfvrQcoHaQ
         Jyi83ESsmaNX7R7Ar0UPzsUtch2tS2jJX3WL0JQye2qsjLKoIBmTBKYqce8f5QyfrBko
         67ALEVT2T/IvCsKm+yz+94DfTLsxY7DoY4QU7YZhA48u4V3EV8sjhwKviYmr/3r6F/aC
         PSdySGPRiu2qVgChDPs75Y6GpWcaNjiOWWP1mcsjef2FYaI7OPOlfF1m5G/BZ3FJrcIx
         JYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9hcFonlCv5i0BsUw49e8mYBm+WY5pAuaSjOGGq/fj10=;
        b=X8KDnoiFb4/5sS56dvhyMxsTtozjIspoDxKTkvbdJn18C0Iig5XFR4PEXw9wuZgEM3
         IBSTnZ15VzK1FL2P7JzMzqloe+/vy+zE3TtNqF36zzQygXXu/7BKrQP8VhRn4twn5Nqn
         j6OTmpDpaqZjXzN7nnM3T6nBMjgnlE0eiFF/ZEfQt4YR9tQVH+codAyXAaDaofXb/dx9
         9m7pP98imYNrQey5ya75OT7CcDCAnOT72saBpKGDr8BtjCJMJKatQmV1/T2ctVjmntt5
         b4FezJNmch4j1MpZ9ocVpySJ80ULnrOfKkz9bw+eK8kDoCRX4MYHEt6sT9mJJ4KtFMrj
         HbDg==
X-Gm-Message-State: AOAM5312NlHlpZ9Qj3pUgZ2jYWUiP84Yhhdy3lIU891pOuOVoZ6jn6rM
        6K/jl3Up83qOsrmUFw8qsYA=
X-Google-Smtp-Source: ABdhPJzQAOJOO/YUPyIzz50/PiWCoNkbSHBuwNq1aJlJASqLt2fNQLEdVseksrdYwa3dpHBDSqxmUQ==
X-Received: by 2002:a17:906:56ca:: with SMTP id an10mr4766481ejc.498.1609982714869;
        Wed, 06 Jan 2021 17:25:14 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm2041858edv.74.2021.01.06.17.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 17:25:14 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH v2 net-next 3/4] net: systemport: use standard netdevice notifier to detect DSA presence
Date:   Thu,  7 Jan 2021 03:24:02 +0200
Message-Id: <20210107012403.1521114-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107012403.1521114-1-olteanv@gmail.com>
References: <20210107012403.1521114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SYSTEMPORT driver maps each port of the embedded Broadcom DSA switch
port to a certain queue of the master Ethernet controller. For that it
currently uses a dedicated notifier infrastructure which was added in
commit 60724d4bae14 ("net: dsa: Add support for DSA specific notifiers").

However, since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the
DSA master to get rid of lockdep warnings"), DSA is actually an upper of
the Broadcom SYSTEMPORT as far as the netdevice adjacency lists are
concerned. So naturally, the plain NETDEV_CHANGEUPPER net device notifiers
are emitted. It looks like there is enough API exposed by DSA to the
outside world already to make the call_dsa_notifiers API redundant. So
let's convert its only user to plain netdev notifiers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
Kept the container_of(nb, struct bcm_sysport_priv, dsa_notifier) in the
code, which repairs an issue introduced in v1.

 drivers/net/ethernet/broadcom/bcmsysport.c | 81 ++++++++++------------
 drivers/net/ethernet/broadcom/bcmsysport.h |  2 +-
 2 files changed, 37 insertions(+), 46 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 9ef743d6ba67..a8b20441ca7c 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2311,33 +2311,22 @@ static const struct net_device_ops bcm_sysport_netdev_ops = {
 	.ndo_select_queue	= bcm_sysport_select_queue,
 };
 
-static int bcm_sysport_map_queues(struct notifier_block *nb,
-				  struct dsa_notifier_register_info *info)
+static int bcm_sysport_map_queues(struct net_device *dev,
+				  struct net_device *slave_dev)
 {
+	struct dsa_port *dp = dsa_port_from_netdev(slave_dev);
+	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	struct bcm_sysport_tx_ring *ring;
-	struct bcm_sysport_priv *priv;
-	struct net_device *slave_dev;
 	unsigned int num_tx_queues;
 	unsigned int q, qp, port;
-	struct net_device *dev;
-
-	priv = container_of(nb, struct bcm_sysport_priv, dsa_notifier);
-	if (priv->netdev != info->master)
-		return 0;
-
-	dev = info->master;
 
 	/* We can't be setting up queue inspection for non directly attached
 	 * switches
 	 */
-	if (info->switch_number)
+	if (dp->ds->index)
 		return 0;
 
-	if (dev->netdev_ops != &bcm_sysport_netdev_ops)
-		return 0;
-
-	port = info->port_number;
-	slave_dev = info->info.dev;
+	port = dp->index;
 
 	/* On SYSTEMPORT Lite we have twice as less queues, so we cannot do a
 	 * 1:1 mapping, we can only do a 2:1 mapping. By reducing the number of
@@ -2377,27 +2366,16 @@ static int bcm_sysport_map_queues(struct notifier_block *nb,
 	return 0;
 }
 
-static int bcm_sysport_unmap_queues(struct notifier_block *nb,
-				    struct dsa_notifier_register_info *info)
+static int bcm_sysport_unmap_queues(struct net_device *dev,
+				    struct net_device *slave_dev)
 {
+	struct dsa_port *dp = dsa_port_from_netdev(slave_dev);
+	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	struct bcm_sysport_tx_ring *ring;
-	struct bcm_sysport_priv *priv;
-	struct net_device *slave_dev;
 	unsigned int num_tx_queues;
-	struct net_device *dev;
 	unsigned int q, qp, port;
 
-	priv = container_of(nb, struct bcm_sysport_priv, dsa_notifier);
-	if (priv->netdev != info->master)
-		return 0;
-
-	dev = info->master;
-
-	if (dev->netdev_ops != &bcm_sysport_netdev_ops)
-		return 0;
-
-	port = info->port_number;
-	slave_dev = info->info.dev;
+	port = dp->index;
 
 	num_tx_queues = slave_dev->real_num_tx_queues;
 
@@ -2418,17 +2396,30 @@ static int bcm_sysport_unmap_queues(struct notifier_block *nb,
 	return 0;
 }
 
-static int bcm_sysport_dsa_notifier(struct notifier_block *nb,
-				    unsigned long event, void *ptr)
+static int bcm_sysport_netdevice_event(struct notifier_block *nb,
+				       unsigned long event, void *ptr)
 {
-	int ret = NOTIFY_DONE;
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct netdev_notifier_changeupper_info *info = ptr;
+	struct bcm_sysport_priv *priv;
+	int ret = 0;
+
+	priv = container_of(nb, struct bcm_sysport_priv, netdev_notifier);
+	if (priv->netdev != dev)
+		return NOTIFY_DONE;
 
 	switch (event) {
-	case DSA_PORT_REGISTER:
-		ret = bcm_sysport_map_queues(nb, ptr);
-		break;
-	case DSA_PORT_UNREGISTER:
-		ret = bcm_sysport_unmap_queues(nb, ptr);
+	case NETDEV_CHANGEUPPER:
+		if (dev->netdev_ops != &bcm_sysport_netdev_ops)
+			return NOTIFY_DONE;
+
+		if (!dsa_slave_dev_check(info->upper_dev))
+			return NOTIFY_DONE;
+
+		if (info->linking)
+			ret = bcm_sysport_map_queues(dev, info->upper_dev);
+		else
+			ret = bcm_sysport_unmap_queues(dev, info->upper_dev);
 		break;
 	}
 
@@ -2601,9 +2592,9 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	priv->rx_max_coalesced_frames = 1;
 	u64_stats_init(&priv->syncp);
 
-	priv->dsa_notifier.notifier_call = bcm_sysport_dsa_notifier;
+	priv->netdev_notifier.notifier_call = bcm_sysport_netdevice_event;
 
-	ret = register_dsa_notifier(&priv->dsa_notifier);
+	ret = register_netdevice_notifier(&priv->netdev_notifier);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register DSA notifier\n");
 		goto err_deregister_fixed_link;
@@ -2630,7 +2621,7 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	return 0;
 
 err_deregister_notifier:
-	unregister_dsa_notifier(&priv->dsa_notifier);
+	unregister_netdevice_notifier(&priv->netdev_notifier);
 err_deregister_fixed_link:
 	if (of_phy_is_fixed_link(dn))
 		of_phy_deregister_fixed_link(dn);
@@ -2648,7 +2639,7 @@ static int bcm_sysport_remove(struct platform_device *pdev)
 	/* Not much to do, ndo_close has been called
 	 * and we use managed allocations
 	 */
-	unregister_dsa_notifier(&priv->dsa_notifier);
+	unregister_netdevice_notifier(&priv->netdev_notifier);
 	unregister_netdev(dev);
 	if (of_phy_is_fixed_link(dn))
 		of_phy_deregister_fixed_link(dn);
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 3a5cb6f128f5..fefd3ccf0379 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -787,7 +787,7 @@ struct bcm_sysport_priv {
 	struct u64_stats_sync	syncp;
 
 	/* map information between switch port queues and local queues */
-	struct notifier_block	dsa_notifier;
+	struct notifier_block	netdev_notifier;
 	unsigned int		per_port_num_tx_queues;
 	struct bcm_sysport_tx_ring *ring_map[DSA_MAX_PORTS * 8];
 
-- 
2.25.1

