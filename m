Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645E3306DE9
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:52:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhA1GtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:49:14 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10106 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbhA1GrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:47:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611816420; x=1643352420;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CJ86UUKaMEUWVhcvbzeSVDsrGyjAILrA2OIyBFsXvMM=;
  b=1+02it4XRxapECFO3vDfviaPkJTvJ5WoJCdu2zFG1x/Kjjt+h64R6Jaz
   X+zQ6h97u5tqAynI+69h4WCsD1f3hvEEleODojNtf6XMMBvEyYjcFAC90
   DIdi/HeQa9LoinK3VSfTxo4b67pQbQENyy73zXw1gkT4onJeBlCyJnOr7
   JRLol8Fg/3R2UMnIaYQ2fl8vZh4tJcTHjetONjRvRxSd4tkk6TJMscTDq
   GJaD+Ao3xSNeEesppulIosShaMse7XRviPiRJYesR8UdzkcLWyF5bVfNZ
   HM5qbV2N+LUY07E41OoQ8sEc8V4OaYPMOQeNMjANL3sz64/voZ0ZHMI+G
   w==;
IronPort-SDR: SZ2ETMDEkiHwAt2jPfEDGwf6clOfQc+3Aqd7zNmzxX9h4IgBVvOMOROLgW/sYZmSccG925MWpO
 xp8uOJYN+BkMiWrUeOBXVCAXFnMKryY2duMuHQKabwng6GV85oudUCPXloPsGRgKNZmweP6qXg
 KGC4cIEnxjD+lgQESAITb4sgymQpcWWdxDRwITZxtRPKl0rDRzlVbrRB1FpMrWDCYnunEx3cXa
 IR9nP2x8uqpjvc6GBh3ggUtDMDp9xo5g616qWeqsg0slQHtwOI1y1RMVi+Im8mQ68JWnCdmw5Z
 etI=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="107076592"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 23:44:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 23:44:35 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 23:44:31 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
CC:     <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH net-next 5/8] net: dsa: microchip: add support for ethtool port counters
Date:   Thu, 28 Jan 2021 12:11:09 +0530
Message-ID: <20210128064112.372883-6-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reused the KSZ common APIs for get_ethtool_stats() & get_sset_count()
along with relevant lan937x hooks for KSZ common layer and added
support for get_strings()

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_dev.c  | 36 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_main.c | 18 ++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_dev.c b/drivers/net/dsa/microchip/lan937x_dev.c
index 84540180ff2f..20ee485fb796 100644
--- a/drivers/net/dsa/microchip/lan937x_dev.c
+++ b/drivers/net/dsa/microchip/lan937x_dev.c
@@ -209,6 +209,40 @@ static void lan937x_flush_dyn_mac_table(struct ksz_device *dev, int port)
 	}
 }
 
+static void lan937x_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
+			      u64 *cnt)
+{
+	unsigned int val;
+	u32 data;
+	int ret;
+
+	/* Enable MIB Counter read*/
+	data = MIB_COUNTER_READ;
+	data |= (addr << MIB_COUNTER_INDEX_S);
+	lan937x_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT__4, data);
+
+	ret = regmap_read_poll_timeout(dev->regmap[2],
+				       PORT_CTRL_ADDR(port,
+						      REG_PORT_MIB_CTRL_STAT__4),
+					   val, !(val & MIB_COUNTER_READ), 10, 1000);
+	/* failed to read MIB. get out of loop */
+	if (ret) {
+		dev_err(dev->dev, "Failed to get MIB\n");
+		return;
+	}
+
+	/* count resets upon read */
+	lan937x_pread32(dev, port, REG_PORT_MIB_DATA, &data);
+	*cnt += data;
+}
+
+static void lan937x_r_mib_pkt(struct ksz_device *dev, int port, u16 addr,
+			      u64 *dropped, u64 *cnt)
+{
+	addr = lan937x_mib_names[addr].index;
+	lan937x_r_mib_cnt(dev, port, addr, cnt);
+}
+
 static void lan937x_port_init_cnt(struct ksz_device *dev, int port)
 {
 	struct ksz_port_mib *mib = &dev->ports[port].mib;
@@ -851,6 +885,8 @@ const struct ksz_dev_ops lan937x_dev_ops = {
 	.cfg_port_member = lan937x_cfg_port_member,
 	.flush_dyn_mac_table = lan937x_flush_dyn_mac_table,
 	.port_setup = lan937x_port_setup,
+	.r_mib_cnt = lan937x_r_mib_cnt,
+	.r_mib_pkt = lan937x_r_mib_pkt,
 	.port_init_cnt = lan937x_port_init_cnt,
 	.shutdown = lan937x_reset_switch,
 	.detect = lan937x_switch_detect,
diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index b38735e36aef..5693c59df497 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -69,6 +69,21 @@ static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
 	return lan937x_t1_tx_phy_write(dev, addr, reg, val);
 }
 
+static void lan937x_get_strings(struct dsa_switch *ds, int port,
+				u32 stringset, uint8_t *buf)
+{
+	struct ksz_device *dev = ds->priv;
+	int i;
+
+	if (stringset != ETH_SS_STATS)
+		return;
+
+	for (i = 0; i < dev->mib_cnt; i++) {
+		memcpy(buf + i * ETH_GSTRING_LEN, lan937x_mib_names[i].string,
+		       ETH_GSTRING_LEN);
+	}
+}
+
 static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 				       u8 state)
 {
@@ -371,6 +386,9 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.phy_read		= lan937x_phy_read16,
 	.phy_write		= lan937x_phy_write16,
 	.port_enable		= ksz_enable_port,
+	.get_strings		= lan937x_get_strings,
+	.get_ethtool_stats	= ksz_get_ethtool_stats,
+	.get_sset_count		= ksz_sset_count,
 	.port_bridge_join	= ksz_port_bridge_join,
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= lan937x_port_stp_state_set,
-- 
2.25.1

