Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FA24CD30B
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiCDLIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:08:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239478AbiCDLIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:08:05 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA811B0C6C;
        Fri,  4 Mar 2022 03:07:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646392032; x=1677928032;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6TIwgyXaeJav5VQrD4lmOBn/UsBEtEOR02PNV3sQ2NM=;
  b=T9vcp5VweZEH2QRngHaDPnlP9dWHqiwWOlpOKfhQqlr+je8XuB1ZsWUg
   T9dcqIbPa08OlhJmVAWZsrbOsTKsmdEkOGKO43iNcpvqyazR7Oi23pfM0
   mr5ElJ49NqzFD0uqNyZkTvFzTMxAI7vzdHbv2Ju0/SSft+VVwf+pMegWz
   neNk0r6jZJtdccmT9eSSSI40crSXPuGUzyKC9bZ1sgw7jOzGMqoNcLLTS
   YFF4p7xocu/7YJoV3h1J6Ce4dIOMp+hpbLhH1oAjXIqMd1EWQ1gAW4IZo
   yK7qza7vVd8lvtPKwWdkMrtM1ayOpyhfFuT2+fv7aCH0SMsrju/XcPJ0K
   g==;
X-IronPort-AV: E=Sophos;i="5.90,155,1643698800"; 
   d="scan'208";a="150853665"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 04:06:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 04:06:48 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 04:06:46 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 6/9] net: sparx5: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP
Date:   Fri, 4 Mar 2022 12:08:57 +0100
Message-ID: <20220304110900.3199904-7-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
References: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the ioctl callbacks SIOCSHWTSTAMP and SIOCGHWTSTAMP to allow
to configure the ports to enable/disable timestamping for TX. The RX
timestamping is always enabled. The HW is capable to run both 1-step
timestamping and 2-step timestamping.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.h   |  9 +++
 .../ethernet/microchip/sparx5/sparx5_netdev.c | 19 +++++
 .../ethernet/microchip/sparx5/sparx5_ptp.c    | 74 +++++++++++++++++++
 3 files changed, 102 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index cf68b3f90834..8f3c7a904f71 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -84,6 +84,10 @@ enum sparx5_vlan_port_type {
 #define SPARX5_PHC_COUNT		3
 #define SPARX5_PHC_PORT			0
 
+#define IFH_REW_OP_NOOP			0x0
+#define IFH_REW_OP_ONE_STEP_PTP		0x3
+#define IFH_REW_OP_TWO_STEP_PTP		0x4
+
 struct sparx5;
 
 struct sparx5_db_hw {
@@ -174,6 +178,8 @@ struct sparx5_port {
 	u32 custom_etype;
 	bool vlan_aware;
 	struct hrtimer inj_timer;
+	/* ptp */
+	u8 ptp_cmd;
 };
 
 enum sparx5_core_clockfreq {
@@ -242,6 +248,7 @@ struct sparx5 {
 	bool ptp;
 	struct sparx5_phc phc[SPARX5_PHC_COUNT];
 	spinlock_t ptp_clock_lock; /* lock for phc */
+	struct mutex ptp_lock; /* lock for ptp interface state */
 };
 
 /* sparx5_switchdev.c */
@@ -314,6 +321,8 @@ void sparx5_unregister_netdevs(struct sparx5 *sparx5);
 /* sparx5_ptp.c */
 int sparx5_ptp_init(struct sparx5 *sparx5);
 void sparx5_ptp_deinit(struct sparx5 *sparx5);
+int sparx5_ptp_hwtstamp_set(struct sparx5_port *port, struct ifreq *ifr);
+int sparx5_ptp_hwtstamp_get(struct sparx5_port *port, struct ifreq *ifr);
 
 /* Clock period in picoseconds */
 static inline u32 sparx5_clk_period(enum sparx5_core_clockfreq cclock)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index 86cae8bf42da..5fd0b2eea021 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -179,6 +179,24 @@ static int sparx5_get_port_parent_id(struct net_device *dev,
 	return 0;
 }
 
+static int sparx5_port_ioctl(struct net_device *dev, struct ifreq *ifr,
+			     int cmd)
+{
+	struct sparx5_port *sparx5_port = netdev_priv(dev);
+	struct sparx5 *sparx5 = sparx5_port->sparx5;
+
+	if (!phy_has_hwtstamp(dev->phydev) && sparx5->ptp) {
+		switch (cmd) {
+		case SIOCSHWTSTAMP:
+			return sparx5_ptp_hwtstamp_set(sparx5_port, ifr);
+		case SIOCGHWTSTAMP:
+			return sparx5_ptp_hwtstamp_get(sparx5_port, ifr);
+		}
+	}
+
+	return phy_mii_ioctl(dev->phydev, ifr, cmd);
+}
+
 static const struct net_device_ops sparx5_port_netdev_ops = {
 	.ndo_open               = sparx5_port_open,
 	.ndo_stop               = sparx5_port_stop,
@@ -189,6 +207,7 @@ static const struct net_device_ops sparx5_port_netdev_ops = {
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_get_stats64        = sparx5_get_stats64,
 	.ndo_get_port_parent_id = sparx5_get_port_parent_id,
+	.ndo_eth_ioctl          = sparx5_port_ioctl,
 };
 
 bool sparx5_netdevice_check(const struct net_device *dev)
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 0203d872929c..0d919e249aef 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -74,6 +74,79 @@ static u64 sparx5_ptp_get_nominal_value(struct sparx5 *sparx5)
 	return res;
 }
 
+int sparx5_ptp_hwtstamp_set(struct sparx5_port *port, struct ifreq *ifr)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	struct hwtstamp_config cfg;
+	struct sparx5_phc *phc;
+
+	/* For now don't allow to run ptp on ports that are part of a bridge,
+	 * because in case of transparent clock the HW will still forward the
+	 * frames, so there would be duplicate frames
+	 */
+
+	if (test_bit(port->portno, sparx5->bridge_mask))
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
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		break;
+	case HWTSTAMP_FILTER_ALL:
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+	case HWTSTAMP_FILTER_NTP_ALL:
+		cfg.rx_filter = HWTSTAMP_FILTER_ALL;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	/* Commit back the result & save it */
+	mutex_lock(&sparx5->ptp_lock);
+	phc = &sparx5->phc[SPARX5_PHC_PORT];
+	memcpy(&phc->hwtstamp_config, &cfg, sizeof(cfg));
+	mutex_unlock(&sparx5->ptp_lock);
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+int sparx5_ptp_hwtstamp_get(struct sparx5_port *port, struct ifreq *ifr)
+{
+	struct sparx5 *sparx5 = port->sparx5;
+	struct sparx5_phc *phc;
+
+	phc = &sparx5->phc[SPARX5_PHC_PORT];
+	return copy_to_user(ifr->ifr_data, &phc->hwtstamp_config,
+			    sizeof(phc->hwtstamp_config)) ? -EFAULT : 0;
+}
+
 static int sparx5_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
 {
 	struct sparx5_phc *phc = container_of(ptp, struct sparx5_phc, info);
@@ -291,6 +364,7 @@ int sparx5_ptp_init(struct sparx5 *sparx5)
 	}
 
 	spin_lock_init(&sparx5->ptp_clock_lock);
+	mutex_init(&sparx5->ptp_lock);
 
 	/* Disable master counters */
 	spx5_wr(PTP_PTP_DOM_CFG_PTP_ENA_SET(0), sparx5, PTP_PTP_DOM_CFG);
-- 
2.33.0

