Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE7B549DF2B
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbiA0KVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:21:52 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:56253 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239236AbiA0KVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:21:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643278910; x=1674814910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lx5VdUQOGKz/Rsx5nOuadN3WJ2sablyuHpJsYZtnXCs=;
  b=Czd/WkZHDf/qKQxrIawZbXJpEIGxtAAG0d4xG9sT0SK31cp3fhDdUoS7
   jJFOkW2kVGaTM/+WsWpc64VJjX3SwgUPYyu9zzlCOUWSOSpuIUYL95u0U
   dWSxVajGQwL5pdCUMMqb2OXmM3wRp3ularut5RrEwS7YPtZr0ESHtT9TR
   eJcglVnYYXE6kLDZxSNF//sOkuEh5OpS8W/hSk2PdtP5XOjaXv/uALec/
   g/0+E4QhBloGLWM1hRaekUqu/f6eH/4mfVEp4p6F8dwpUFIVz7KZNR5OW
   bjPVflLp2oyTrit0KLFcK335ySj48A4UxyMaE6FIpWdRW7Uh1nc92qwi4
   A==;
IronPort-SDR: c5gl7B1vWTnQPgun/eMmdsEBrQ8Rmmwcba+MTjh6jxwE+BudmncfPOD6gQNVANl+jnmodY0dqP
 FEXyCTN3ZUoE8wz+jV/NcpELBig5xEycNI7rWwZEjI+u+XCicy9B5ae1DDoeS/rhuekwxvSBEx
 R1O/zL91G+W03xPmwNSDguVAzP3duDHCflW3g7jAB0TFQqGge3cPlU+UH9ZoPNKKOiq+quFPvX
 mi9/s0BzJZSqIWK0GgJst4mZ5EiQ/Wt71TXSdgrGVF6MmxS7hN9qJg3S54VgebkZKAeCaX8IKg
 uYrXIln0t1EGB8cVGRzfwZ1Q
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="146782901"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2022 03:21:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 03:21:49 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Thu, 27 Jan 2022 03:21:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <linux@armlinux.org.uk>,
        <richardcochran@gmail.com>, <f.fainelli@gmail.com>,
        <vivien.didelot@gmail.com>, <vladimir.oltean@nxp.com>,
        <andrew@lunn.ch>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 4/7] net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
Date:   Thu, 27 Jan 2022 11:23:30 +0100
Message-ID: <20220127102333.987195-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220127102333.987195-1-horatiu.vultur@microchip.com>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the ioctl callbacks SIOCSHWTSTAMP and SIOCGHWTSTAMP to allow
to configure the ports to enable/disable timestamping. The HW is capable
to run both 1-step timestamping and 2-step timestamping.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c | 18 ++++
 .../ethernet/microchip/lan966x/lan966x_main.h |  9 ++
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 85 +++++++++++++++++++
 3 files changed, 112 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index ee3505318c5c..c62615b9d101 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -351,6 +351,23 @@ static int lan966x_port_get_parent_id(struct net_device *dev,
 	return 0;
 }
 
+static int lan966x_port_ioctl(struct net_device *dev, struct ifreq *ifr,
+			      int cmd)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+
+	if (!phy_has_hwtstamp(dev->phydev) && port->lan966x->ptp) {
+		switch (cmd) {
+		case SIOCSHWTSTAMP:
+			return lan966x_ptp_hwtstamp_set(port, ifr);
+		case SIOCGHWTSTAMP:
+			return lan966x_ptp_hwtstamp_get(port, ifr);
+		}
+	}
+
+	return phy_mii_ioctl(dev->phydev, ifr, cmd);
+}
+
 static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_open			= lan966x_port_open,
 	.ndo_stop			= lan966x_port_stop,
@@ -361,6 +378,7 @@ static const struct net_device_ops lan966x_port_netdev_ops = {
 	.ndo_get_stats64		= lan966x_stats_get,
 	.ndo_set_mac_address		= lan966x_port_set_mac_address,
 	.ndo_get_port_parent_id		= lan966x_port_get_parent_id,
+	.ndo_eth_ioctl			= lan966x_port_ioctl,
 };
 
 bool lan966x_netdevice_check(const struct net_device *dev)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index c77a91aa24e7..55fa5e56b8d1 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -54,6 +54,10 @@
 #define LAN966X_PHC_COUNT		3
 #define LAN966X_PHC_PORT		0
 
+#define IFH_REW_OP_NOOP			0x0
+#define IFH_REW_OP_ONE_STEP_PTP		0x3
+#define IFH_REW_OP_TWO_STEP_PTP		0x4
+
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
@@ -130,6 +134,7 @@ struct lan966x {
 	bool ptp;
 	struct lan966x_phc phc[LAN966X_PHC_COUNT];
 	spinlock_t ptp_clock_lock; /* lock for phc */
+	struct mutex ptp_lock; /* lock for ptp interface state */
 };
 
 struct lan966x_port_config {
@@ -159,6 +164,8 @@ struct lan966x_port {
 	struct phylink *phylink;
 	struct phy *serdes;
 	struct fwnode_handle *fwnode;
+
+	u8 ptp_cmd;
 };
 
 extern const struct phylink_mac_ops lan966x_phylink_mac_ops;
@@ -247,6 +254,8 @@ void lan966x_mdb_write_entries(struct lan966x *lan966x, u16 vid);
 
 int lan966x_ptp_init(struct lan966x *lan966x);
 void lan966x_ptp_deinit(struct lan966x *lan966x);
+int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr);
+int lan966x_ptp_hwtstamp_get(struct lan966x_port *port, struct ifreq *ifr);
 
 static inline void __iomem *lan_addr(void __iomem *base[],
 				     int id, int tinst, int tcnt,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 69d8f43e2b1b..9ff4d3fca5a1 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -35,6 +35,90 @@ static u64 lan966x_ptp_get_nominal_value(void)
 	return res;
 }
 
+int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
+{
+	struct lan966x *lan966x = port->lan966x;
+	bool l2 = false, l4 = false;
+	struct hwtstamp_config cfg;
+	struct lan966x_phc *phc;
+
+	/* For now don't allow to run ptp on ports that are part of a bridge,
+	 * because in case of transparent clock the HW will still forward the
+	 * frames, so there would be duplicate frames
+	 */
+	if (lan966x->bridge_mask & BIT(port->chip_port))
+		return -EINVAL;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	switch (cfg.tx_type) {
+	case HWTSTAMP_TX_ON:
+		port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
+		break;
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+		port->ptp_cmd = IFH_REW_OP_ONE_STEP_PTP;
+		break;
+	case HWTSTAMP_TX_OFF:
+		port->ptp_cmd = IFH_REW_OP_NOOP;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	mutex_lock(&lan966x->ptp_lock);
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		l4 = true;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		l2 = true;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		l2 = true;
+		l4 = true;
+		break;
+	default:
+		mutex_unlock(&lan966x->ptp_lock);
+		return -ERANGE;
+	}
+
+	if (l2 && l4)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
+	else if (l2)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
+	else if (l4)
+		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+	else
+		cfg.rx_filter = HWTSTAMP_FILTER_NONE;
+
+	/* Commit back the result & save it */
+	phc = &lan966x->phc[LAN966X_PHC_PORT];
+	memcpy(&phc->hwtstamp_config, &cfg, sizeof(cfg));
+	mutex_unlock(&lan966x->ptp_lock);
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+int lan966x_ptp_hwtstamp_get(struct lan966x_port *port, struct ifreq *ifr)
+{
+	struct lan966x *lan966x = port->lan966x;
+	struct lan966x_phc *phc;
+
+	phc = &lan966x->phc[LAN966X_PHC_PORT];
+	return copy_to_user(ifr->ifr_data, &phc->hwtstamp_config,
+			    sizeof(phc->hwtstamp_config)) ? -EFAULT : 0;
+}
+
 static int lan966x_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct lan966x_phc *phc = container_of(ptp, struct lan966x_phc, info);
@@ -252,6 +336,7 @@ int lan966x_ptp_init(struct lan966x *lan966x)
 	}
 
 	spin_lock_init(&lan966x->ptp_clock_lock);
+	mutex_init(&lan966x->ptp_lock);
 
 	/* Disable master counters */
 	lan_wr(PTP_DOM_CFG_ENA_SET(0), lan966x, PTP_DOM_CFG);
-- 
2.33.0

