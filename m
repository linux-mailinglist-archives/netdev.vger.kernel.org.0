Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69FA144641
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 22:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728896AbgAUVJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 16:09:48 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37474 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgAUVJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 16:09:48 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so4981741wru.4;
        Tue, 21 Jan 2020 13:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=USC5WNDE/HAboW02J0L9+U4XCEXb7DagbFu0m+UZCqY=;
        b=qIWjEZ/PY0mWS/WID2OXjq6XaThaCmq3qD8xY04LzWj0/+2wgnzLHyg5PRTEswz3jo
         filg8S5mLxmFio4nznI765fVDS1dGbu2tcCyhOvy69WaW0KeCxqCn+82dFprCqJGaxQl
         cpoiVK2MNgTGlzEHI/rRwtO0/qrXXjnifyqGQhfe6UmHXFncLEIWeQ7lWRDyXowEl0Pp
         2t82vnjDxuaY23p1iP+O10FvIQjj4qtHrz7wlnBExpcug5egvLHxhgnIzxXBL3Vtx+dc
         4XtKvkcXyppPm1a/WL0WS814w6nJOSazZ8ruXVdwe/B/+IKPUl/lGWdGZ2qd9IcR3hec
         Xtww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=USC5WNDE/HAboW02J0L9+U4XCEXb7DagbFu0m+UZCqY=;
        b=NrsP43xSctg71vloOvGZU6DVz/dz2VY+PKkB6OEshbL1+bB6EM+d14YSsVCaUx5eQi
         RX/SAiSn45hCzTVZ6BSt2kxNEykd8sdm+UUTa07JCBJfLbzF3W/VJVpCJUvZbrKRxE4A
         iES3LteGBX7vIUTuLtc4UPyiriYHw0XW7JGxEby1frezDAU9REZODGmOi86dY4+/BnLV
         a3oMg68mHhrKJqcxQ4oEjiAFKXRC70+0NdRGkLFMpPZBt1kTON0WIL/+BONIv0ff2Zly
         69NHmAa+kndxIfmQ0W6DGjluAuasI4olqIWS9gxeyPXdYtvT3SHmVTciyhB3NkLM0OVH
         WCWA==
X-Gm-Message-State: APjAAAVz7XFFzyIv5VK7D+MIxc9L4ISI8f6t4McR1VhshAZyS1QhAdZx
        zbfgvyW1e4l7RMEDomXV1lKjcGNV
X-Google-Smtp-Source: APXvYqzy1aNdd6Z6+LVkRLndzQGjv5U2HpRGo1umY/F/247Z4YunAPOd3XmtUP/HILVHd1edjG724A==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr7109966wrx.109.1579640983148;
        Tue, 21 Jan 2020 13:09:43 -0800 (PST)
Received: from [192.168.178.85] (pD9F901D9.dip0.t-ipconnect.de. [217.249.1.217])
        by smtp.googlemail.com with ESMTPSA id c9sm19876wme.41.2020.01.21.13.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 13:09:42 -0800 (PST)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net-next] net: convert suitable drivers to use
 phy_do_ioctl_running
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Doug Berger <opendmb@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Timur Tabi <timur@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        linux-renesas-soc@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <2db5d899-a550-456d-a725-f7cf009f53a3@gmail.com>
Date:   Tue, 21 Jan 2020 22:09:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert suitable drivers to use new helper phy_do_ioctl_running.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2: I forgot the netdev mailing list
---
 drivers/net/ethernet/allwinner/sun4i-emac.c    | 15 +--------------
 drivers/net/ethernet/amd/au1000_eth.c          | 13 +------------
 drivers/net/ethernet/arc/emac_main.c           | 14 +-------------
 drivers/net/ethernet/broadcom/bgmac.c          | 10 +---------
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 14 +-------------
 drivers/net/ethernet/dnet.c                    | 15 +--------------
 .../ethernet/freescale/fs_enet/fs_enet-main.c  | 10 +---------
 drivers/net/ethernet/hisilicon/hisi_femac.c    | 14 +-------------
 drivers/net/ethernet/hisilicon/hns/hns_enet.c  | 16 +---------------
 drivers/net/ethernet/nxp/lpc_eth.c             | 15 +--------------
 drivers/net/ethernet/qualcomm/emac/emac.c      | 14 +-------------
 drivers/net/ethernet/renesas/sh_eth.c          | 18 ++----------------
 drivers/net/ethernet/smsc/smsc911x.c           | 11 +----------
 drivers/net/ethernet/smsc/smsc9420.c           | 11 +----------
 drivers/net/ethernet/ti/cpmac.c                | 12 +-----------
 drivers/net/ethernet/toshiba/tc35815.c         | 12 +-----------
 drivers/net/ethernet/xilinx/ll_temac_main.c    | 13 +------------
 drivers/net/usb/ax88172a.c                     | 13 +------------
 drivers/net/usb/lan78xx.c                      | 10 +---------
 19 files changed, 20 insertions(+), 230 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 5ea806423..22cadfbee 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -207,19 +207,6 @@ static void emac_inblk_32bit(void __iomem *reg, void *data, int count)
 	readsl(reg, data, round_up(count, 4) / 4);
 }
 
-static int emac_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct phy_device *phydev = dev->phydev;
-
-	if (!netif_running(dev))
-		return -EINVAL;
-
-	if (!phydev)
-		return -ENODEV;
-
-	return phy_mii_ioctl(phydev, rq, cmd);
-}
-
 /* ethtool ops */
 static void emac_get_drvinfo(struct net_device *dev,
 			      struct ethtool_drvinfo *info)
@@ -791,7 +778,7 @@ static const struct net_device_ops emac_netdev_ops = {
 	.ndo_start_xmit		= emac_start_xmit,
 	.ndo_tx_timeout		= emac_timeout,
 	.ndo_set_rx_mode	= emac_set_rx_mode,
-	.ndo_do_ioctl		= emac_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= emac_set_mac_address,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 6acf5aa99..089a4fbc6 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -1053,23 +1053,12 @@ static void au1000_multicast_list(struct net_device *dev)
 	writel(reg, &aup->mac->control);
 }
 
-static int au1000_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	if (!netif_running(dev))
-		return -EINVAL;
-
-	if (!dev->phydev)
-		return -EINVAL; /* PHY not controllable */
-
-	return phy_mii_ioctl(dev->phydev, rq, cmd);
-}
-
 static const struct net_device_ops au1000_netdev_ops = {
 	.ndo_open		= au1000_open,
 	.ndo_stop		= au1000_close,
 	.ndo_start_xmit		= au1000_tx,
 	.ndo_set_rx_mode	= au1000_multicast_list,
-	.ndo_do_ioctl		= au1000_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_tx_timeout		= au1000_tx_timeout,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
diff --git a/drivers/net/ethernet/arc/emac_main.c b/drivers/net/ethernet/arc/emac_main.c
index 6f2c86778..17bda4e8c 100644
--- a/drivers/net/ethernet/arc/emac_main.c
+++ b/drivers/net/ethernet/arc/emac_main.c
@@ -781,18 +781,6 @@ static int arc_emac_set_address(struct net_device *ndev, void *p)
 	return 0;
 }
 
-static int arc_emac_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	if (!netif_running(dev))
-		return -EINVAL;
-
-	if (!dev->phydev)
-		return -ENODEV;
-
-	return phy_mii_ioctl(dev->phydev, rq, cmd);
-}
-
-
 /**
  * arc_emac_restart - Restart EMAC
  * @ndev:	Pointer to net_device structure.
@@ -857,7 +845,7 @@ static const struct net_device_ops arc_emac_netdev_ops = {
 	.ndo_set_mac_address	= arc_emac_set_address,
 	.ndo_get_stats		= arc_emac_stats,
 	.ndo_set_rx_mode	= arc_emac_set_rx_mode,
-	.ndo_do_ioctl		= arc_emac_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= arc_emac_poll_controller,
 #endif
diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index 148734b16..1bb07a5d8 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1248,14 +1248,6 @@ static int bgmac_set_mac_address(struct net_device *net_dev, void *addr)
 	return 0;
 }
 
-static int bgmac_ioctl(struct net_device *net_dev, struct ifreq *ifr, int cmd)
-{
-	if (!netif_running(net_dev))
-		return -EINVAL;
-
-	return phy_mii_ioctl(net_dev->phydev, ifr, cmd);
-}
-
 static const struct net_device_ops bgmac_netdev_ops = {
 	.ndo_open		= bgmac_open,
 	.ndo_stop		= bgmac_stop,
@@ -1263,7 +1255,7 @@ static const struct net_device_ops bgmac_netdev_ops = {
 	.ndo_set_rx_mode	= bgmac_set_rx_mode,
 	.ndo_set_mac_address	= bgmac_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl           = bgmac_ioctl,
+	.ndo_do_ioctl           = phy_do_ioctl_running,
 };
 
 /**************************************************
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 3ee7917e3..013959285 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1225,18 +1225,6 @@ static void bcmgenet_power_up(struct bcmgenet_priv *priv,
 	}
 }
 
-/* ioctl handle special commands that are not present in ethtool. */
-static int bcmgenet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	if (!netif_running(dev))
-		return -EINVAL;
-
-	if (!dev->phydev)
-		return -ENODEV;
-
-	return phy_mii_ioctl(dev->phydev, rq, cmd);
-}
-
 static struct enet_cb *bcmgenet_get_txcb(struct bcmgenet_priv *priv,
 					 struct bcmgenet_tx_ring *ring)
 {
@@ -3222,7 +3210,7 @@ static const struct net_device_ops bcmgenet_netdev_ops = {
 	.ndo_tx_timeout		= bcmgenet_timeout,
 	.ndo_set_rx_mode	= bcmgenet_set_rx_mode,
 	.ndo_set_mac_address	= bcmgenet_set_mac_addr,
-	.ndo_do_ioctl		= bcmgenet_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_set_features	= bcmgenet_set_features,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= bcmgenet_poll_controller,
diff --git a/drivers/net/ethernet/dnet.c b/drivers/net/ethernet/dnet.c
index e24979010..5f8fa1145 100644
--- a/drivers/net/ethernet/dnet.c
+++ b/drivers/net/ethernet/dnet.c
@@ -725,19 +725,6 @@ static struct net_device_stats *dnet_get_stats(struct net_device *dev)
 	return nstat;
 }
 
-static int dnet_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct phy_device *phydev = dev->phydev;
-
-	if (!netif_running(dev))
-		return -EINVAL;
-
-	if (!phydev)
-		return -ENODEV;
-
-	return phy_mii_ioctl(phydev, rq, cmd);
-}
-
 static void dnet_get_drvinfo(struct net_device *dev,
 			     struct ethtool_drvinfo *info)
 {
@@ -759,7 +746,7 @@ static const struct net_device_ops dnet_netdev_ops = {
 	.ndo_stop		= dnet_close,
 	.ndo_get_stats		= dnet_get_stats,
 	.ndo_start_xmit		= dnet_start_xmit,
-	.ndo_do_ioctl		= dnet_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 80903cd58..add61fed3 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -882,14 +882,6 @@ static const struct ethtool_ops fs_ethtool_ops = {
 	.set_tunable = fs_set_tunable,
 };
 
-static int fs_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	if (!netif_running(dev))
-		return -EINVAL;
-
-	return phy_mii_ioctl(dev->phydev, rq, cmd);
-}
-
 extern int fs_mii_connect(struct net_device *dev);
 extern void fs_mii_disconnect(struct net_device *dev);
 
@@ -907,7 +899,7 @@ static const struct net_device_ops fs_enet_netdev_ops = {
 	.ndo_start_xmit		= fs_enet_start_xmit,
 	.ndo_tx_timeout		= fs_timeout,
 	.ndo_set_rx_mode	= fs_set_multicast_list,
-	.ndo_do_ioctl		= fs_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index 90ab7ade4..57c3bc4f7 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -675,18 +675,6 @@ static void hisi_femac_net_set_rx_mode(struct net_device *dev)
 	}
 }
 
-static int hisi_femac_net_ioctl(struct net_device *dev,
-				struct ifreq *ifreq, int cmd)
-{
-	if (!netif_running(dev))
-		return -EINVAL;
-
-	if (!dev->phydev)
-		return -EINVAL;
-
-	return phy_mii_ioctl(dev->phydev, ifreq, cmd);
-}
-
 static const struct ethtool_ops hisi_femac_ethtools_ops = {
 	.get_link		= ethtool_op_get_link,
 	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
@@ -697,7 +685,7 @@ static const struct net_device_ops hisi_femac_netdev_ops = {
 	.ndo_open		= hisi_femac_net_open,
 	.ndo_stop		= hisi_femac_net_close,
 	.ndo_start_xmit		= hisi_femac_net_xmit,
-	.ndo_do_ioctl		= hisi_femac_net_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_set_mac_address	= hisi_femac_set_mac_address,
 	.ndo_set_rx_mode	= hisi_femac_net_set_rx_mode,
 };
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index e45553ec1..0c3b9b274 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1499,20 +1499,6 @@ static void hns_nic_net_timeout(struct net_device *ndev, unsigned int txqueue)
 	}
 }
 
-static int hns_nic_do_ioctl(struct net_device *netdev, struct ifreq *ifr,
-			    int cmd)
-{
-	struct phy_device *phy_dev = netdev->phydev;
-
-	if (!netif_running(netdev))
-		return -EINVAL;
-
-	if (!phy_dev)
-		return -ENOTSUPP;
-
-	return phy_mii_ioctl(phy_dev, ifr, cmd);
-}
-
 static netdev_tx_t hns_nic_net_xmit(struct sk_buff *skb,
 				    struct net_device *ndev)
 {
@@ -1960,7 +1946,7 @@ static const struct net_device_ops hns_nic_netdev_ops = {
 	.ndo_tx_timeout = hns_nic_net_timeout,
 	.ndo_set_mac_address = hns_nic_net_set_mac_address,
 	.ndo_change_mtu = hns_nic_change_mtu,
-	.ndo_do_ioctl = hns_nic_do_ioctl,
+	.ndo_do_ioctl = phy_do_ioctl_running,
 	.ndo_set_features = hns_nic_set_features,
 	.ndo_fix_features = hns_nic_fix_features,
 	.ndo_get_stats64 = hns_nic_get_stats64,
diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index 656169214..d20cf03a3 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1149,19 +1149,6 @@ static void lpc_eth_set_multicast_list(struct net_device *ndev)
 	spin_unlock_irqrestore(&pldat->lock, flags);
 }
 
-static int lpc_eth_ioctl(struct net_device *ndev, struct ifreq *req, int cmd)
-{
-	struct phy_device *phydev = ndev->phydev;
-
-	if (!netif_running(ndev))
-		return -EINVAL;
-
-	if (!phydev)
-		return -ENODEV;
-
-	return phy_mii_ioctl(phydev, req, cmd);
-}
-
 static int lpc_eth_open(struct net_device *ndev)
 {
 	struct netdata_local *pldat = netdev_priv(ndev);
@@ -1229,7 +1216,7 @@ static const struct net_device_ops lpc_netdev_ops = {
 	.ndo_stop		= lpc_eth_close,
 	.ndo_start_xmit		= lpc_eth_hard_start_xmit,
 	.ndo_set_rx_mode	= lpc_eth_set_multicast_list,
-	.ndo_do_ioctl		= lpc_eth_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_set_mac_address	= lpc_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 };
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 522fad4cb..18b0c7a2d 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -289,18 +289,6 @@ static void emac_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	schedule_work(&adpt->work_thread);
 }
 
-/* IOCTL support for the interface */
-static int emac_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
-{
-	if (!netif_running(netdev))
-		return -EINVAL;
-
-	if (!netdev->phydev)
-		return -ENODEV;
-
-	return phy_mii_ioctl(netdev->phydev, ifr, cmd);
-}
-
 /**
  * emac_update_hw_stats - read the EMAC stat registers
  *
@@ -387,7 +375,7 @@ static const struct net_device_ops emac_netdev_ops = {
 	.ndo_start_xmit		= emac_start_xmit,
 	.ndo_set_mac_address	= eth_mac_addr,
 	.ndo_change_mtu		= emac_change_mtu,
-	.ndo_do_ioctl		= emac_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_tx_timeout		= emac_tx_timeout,
 	.ndo_get_stats64	= emac_get_stats64,
 	.ndo_set_features       = emac_set_features,
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index c922d7a55..58ca12651 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2647,20 +2647,6 @@ static int sh_eth_close(struct net_device *ndev)
 	return 0;
 }
 
-/* ioctl to device function */
-static int sh_eth_do_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
-{
-	struct phy_device *phydev = ndev->phydev;
-
-	if (!netif_running(ndev))
-		return -EINVAL;
-
-	if (!phydev)
-		return -ENODEV;
-
-	return phy_mii_ioctl(phydev, rq, cmd);
-}
-
 static int sh_eth_change_mtu(struct net_device *ndev, int new_mtu)
 {
 	if (netif_running(ndev))
@@ -3159,7 +3145,7 @@ static const struct net_device_ops sh_eth_netdev_ops = {
 	.ndo_get_stats		= sh_eth_get_stats,
 	.ndo_set_rx_mode	= sh_eth_set_rx_mode,
 	.ndo_tx_timeout		= sh_eth_tx_timeout,
-	.ndo_do_ioctl		= sh_eth_do_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_change_mtu		= sh_eth_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
@@ -3175,7 +3161,7 @@ static const struct net_device_ops sh_eth_netdev_ops_tsu = {
 	.ndo_vlan_rx_add_vid	= sh_eth_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= sh_eth_vlan_rx_kill_vid,
 	.ndo_tx_timeout		= sh_eth_tx_timeout,
-	.ndo_do_ioctl		= sh_eth_do_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_change_mtu		= sh_eth_change_mtu,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 6d90a097c..49a6a9167 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1943,15 +1943,6 @@ static int smsc911x_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-/* Standard ioctls for mii-tool */
-static int smsc911x_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
-{
-	if (!netif_running(dev) || !dev->phydev)
-		return -EINVAL;
-
-	return phy_mii_ioctl(dev->phydev, ifr, cmd);
-}
-
 static void smsc911x_ethtool_getdrvinfo(struct net_device *dev,
 					struct ethtool_drvinfo *info)
 {
@@ -2151,7 +2142,7 @@ static const struct net_device_ops smsc911x_netdev_ops = {
 	.ndo_start_xmit		= smsc911x_hard_start_xmit,
 	.ndo_get_stats		= smsc911x_get_stats,
 	.ndo_set_rx_mode	= smsc911x_set_multicast_list,
-	.ndo_do_ioctl		= smsc911x_do_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= smsc911x_set_mac_address,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index a6962a41c..7312e522c 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -210,15 +210,6 @@ static int smsc9420_eeprom_reload(struct smsc9420_pdata *pd)
 	return -EIO;
 }
 
-/* Standard ioctls for mii-tool */
-static int smsc9420_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
-{
-	if (!netif_running(dev) || !dev->phydev)
-		return -EINVAL;
-
-	return phy_mii_ioctl(dev->phydev, ifr, cmd);
-}
-
 static void smsc9420_ethtool_get_drvinfo(struct net_device *netdev,
 					 struct ethtool_drvinfo *drvinfo)
 {
@@ -1504,7 +1495,7 @@ static const struct net_device_ops smsc9420_netdev_ops = {
 	.ndo_start_xmit		= smsc9420_hard_start_xmit,
 	.ndo_get_stats		= smsc9420_get_stats,
 	.ndo_set_rx_mode	= smsc9420_set_multicast_list,
-	.ndo_do_ioctl		= smsc9420_do_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address 	= eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/ethernet/ti/cpmac.c b/drivers/net/ethernet/ti/cpmac.c
index 5e1b8292c..a530afe3c 100644
--- a/drivers/net/ethernet/ti/cpmac.c
+++ b/drivers/net/ethernet/ti/cpmac.c
@@ -816,16 +816,6 @@ static void cpmac_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	netif_tx_wake_all_queues(priv->dev);
 }
 
-static int cpmac_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
-{
-	if (!(netif_running(dev)))
-		return -EINVAL;
-	if (!dev->phydev)
-		return -EINVAL;
-
-	return phy_mii_ioctl(dev->phydev, ifr, cmd);
-}
-
 static void cpmac_get_ringparam(struct net_device *dev,
 						struct ethtool_ringparam *ring)
 {
@@ -1054,7 +1044,7 @@ static const struct net_device_ops cpmac_netdev_ops = {
 	.ndo_start_xmit		= cpmac_start_xmit,
 	.ndo_tx_timeout		= cpmac_tx_timeout,
 	.ndo_set_rx_mode	= cpmac_set_multicast_list,
-	.ndo_do_ioctl		= cpmac_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
 };
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 708de8262..3fd43d30b 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -484,7 +484,6 @@ static int	tc35815_close(struct net_device *dev);
 static struct	net_device_stats *tc35815_get_stats(struct net_device *dev);
 static void	tc35815_set_multicast_list(struct net_device *dev);
 static void	tc35815_tx_timeout(struct net_device *dev, unsigned int txqueue);
-static int	tc35815_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void	tc35815_poll_controller(struct net_device *dev);
 #endif
@@ -751,7 +750,7 @@ static const struct net_device_ops tc35815_netdev_ops = {
 	.ndo_get_stats		= tc35815_get_stats,
 	.ndo_set_rx_mode	= tc35815_set_multicast_list,
 	.ndo_tx_timeout		= tc35815_tx_timeout,
-	.ndo_do_ioctl		= tc35815_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_mac_address	= eth_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
@@ -2009,15 +2008,6 @@ static const struct ethtool_ops tc35815_ethtool_ops = {
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
 };
 
-static int tc35815_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	if (!netif_running(dev))
-		return -EINVAL;
-	if (!dev->phydev)
-		return -ENODEV;
-	return phy_mii_ioctl(dev->phydev, rq, cmd);
-}
-
 static void tc35815_chip_reset(struct net_device *dev)
 {
 	struct tc35815_regs __iomem *tr =
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index c66aab78d..6f11f52c9 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1080,17 +1080,6 @@ temac_poll_controller(struct net_device *ndev)
 }
 #endif
 
-static int temac_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
-{
-	if (!netif_running(ndev))
-		return -EINVAL;
-
-	if (!ndev->phydev)
-		return -EINVAL;
-
-	return phy_mii_ioctl(ndev->phydev, rq, cmd);
-}
-
 static const struct net_device_ops temac_netdev_ops = {
 	.ndo_open = temac_open,
 	.ndo_stop = temac_stop,
@@ -1098,7 +1087,7 @@ static const struct net_device_ops temac_netdev_ops = {
 	.ndo_set_rx_mode = temac_set_multicast_list,
 	.ndo_set_mac_address = temac_set_mac_address,
 	.ndo_validate_addr = eth_validate_addr,
-	.ndo_do_ioctl = temac_ioctl,
+	.ndo_do_ioctl = phy_do_ioctl_running,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = temac_poll_controller,
 #endif
diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index af3994e08..4e514f5d7 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -39,17 +39,6 @@ static int asix_mdio_bus_write(struct mii_bus *bus, int phy_id, int regnum,
 	return 0;
 }
 
-static int ax88172a_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
-{
-	if (!netif_running(net))
-		return -EINVAL;
-
-	if (!net->phydev)
-		return -ENODEV;
-
-	return phy_mii_ioctl(net->phydev, rq, cmd);
-}
-
 /* set MAC link settings according to information from phylib */
 static void ax88172a_adjust_link(struct net_device *netdev)
 {
@@ -134,7 +123,7 @@ static const struct net_device_ops ax88172a_netdev_ops = {
 	.ndo_get_stats64	= usbnet_get_stats64,
 	.ndo_set_mac_address	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= ax88172a_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_set_rx_mode        = asix_set_multicast,
 };
 
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index c391f2521..d2d61f082 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1663,14 +1663,6 @@ static const struct ethtool_ops lan78xx_ethtool_ops = {
 	.get_regs	= lan78xx_get_regs,
 };
 
-static int lan78xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
-{
-	if (!netif_running(netdev))
-		return -EINVAL;
-
-	return phy_mii_ioctl(netdev->phydev, rq, cmd);
-}
-
 static void lan78xx_init_mac_address(struct lan78xx_net *dev)
 {
 	u32 addr_lo, addr_hi;
@@ -3676,7 +3668,7 @@ static const struct net_device_ops lan78xx_netdev_ops = {
 	.ndo_change_mtu		= lan78xx_change_mtu,
 	.ndo_set_mac_address	= lan78xx_set_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_do_ioctl		= lan78xx_ioctl,
+	.ndo_do_ioctl		= phy_do_ioctl_running,
 	.ndo_set_rx_mode	= lan78xx_set_multicast,
 	.ndo_set_features	= lan78xx_set_features,
 	.ndo_vlan_rx_add_vid	= lan78xx_vlan_rx_add_vid,
-- 
2.25.0

