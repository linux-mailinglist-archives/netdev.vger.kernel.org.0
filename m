Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68562306DDC
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 07:49:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbhA1Gqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 01:46:53 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:29386 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbhA1GqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 01:46:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611816374; x=1643352374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=71Mg6U+AYgcqKsgprhctms49xl0Ct0S0CM972OvFfCU=;
  b=DVM8YmIhxc54HeAQwwlaRaeGOXrZx4eeLx4M0Ct3ZZB4SMAKOuLhE1Cz
   i84bxGOher6pKeKyXPNposIS2afayUwohSXX7klQBUVJ47w48Djpj18No
   bhrJldQAItQXuxcTh81Fw2UVeoAsLbZzvvaUwLfSZwbm2NdEPDSiUfhZO
   /NTpCVsyCVBIxV4C43btMhbpYOUUYy4aPL693miWHEphQcZHtoTkT6DbC
   ZlhsKgLRGSBVKXO2BOO7jEwfcg9YB+rft1m/QC6EWoeuGFtR7eFJVmFR/
   urv8FBQ3fsZxRoFNtkoia2V8lufWSk29po0pQuByITs1TN80HZs21OGOE
   A==;
IronPort-SDR: SFnSCSWYaQ+FWtZb129AuO9xPvWJkhgX+I34QtWAcX+N20nbL8Ap8rGgwo01RBmGTEO+Ik5hAz
 +Xk6suz6RlhKFppkTigy99/8lwNlL4lxS0ApMRmN5i7fxwwSyBoevh0xpcNKOwuVLlLIgzPNiR
 jP7Y8RCuazZRdIbg1CpIPyjZrWS+pCRDdrfGbf0ZybnZeyBrJG+/0bL9JYuSpw5Cos7RP3EzyH
 YP+O6Q9DMoHYGpbmoBLPfaXfQjTCJLM7hIJeAzQfMiX52WlozB3PTmkjWrvA7O35PwRQQWl6EA
 MS8=
X-IronPort-AV: E=Sophos;i="5.79,381,1602572400"; 
   d="scan'208";a="104520577"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Jan 2021 23:44:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 27 Jan 2021 23:44:41 -0700
Received: from CHE-LT-I21427U.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Wed, 27 Jan 2021 23:44:36 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <olteanv@gmail.com>, <netdev@vger.kernel.org>,
        <robh+dt@kernel.org>
CC:     <kuba@kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: [PATCH net-next 6/8] net: dsa: microchip: add support for port mirror operations
Date:   Thu, 28 Jan 2021 12:11:10 +0530
Message-ID: <20210128064112.372883-7-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
References: <20210128064112.372883-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for port_mirror_add() and port_mirror_del operations

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 42 ++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 5693c59df497..aa2efa4e5823 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -162,6 +162,46 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	mutex_unlock(&dev->dev_mutex);
 }
 
+static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
+				   struct dsa_mall_mirror_tc_entry *mirror,
+				   bool ingress)
+{
+	struct ksz_device *dev = ds->priv;
+
+	if (ingress)
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
+	else
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, true);
+
+	lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_SNIFFER, false);
+
+	/* configure mirror port */
+	lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+			 PORT_MIRROR_SNIFFER, true);
+
+	lan937x_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
+
+	return 0;
+}
+
+static void lan937x_port_mirror_del(struct dsa_switch *ds, int port,
+				    struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct ksz_device *dev = ds->priv;
+	u8 data;
+
+	if (mirror->ingress)
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, false);
+	else
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, false);
+
+	lan937x_pread8(dev, port, P_MIRROR_CTRL, &data);
+
+	if (!(data & (PORT_MIRROR_RX | PORT_MIRROR_TX)))
+		lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+				 PORT_MIRROR_SNIFFER, false);
+}
+
 static phy_interface_t lan937x_get_interface(struct ksz_device *dev, int port)
 {
 	phy_interface_t interface;
@@ -393,6 +433,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_leave	= ksz_port_bridge_leave,
 	.port_stp_state_set	= lan937x_port_stp_state_set,
 	.port_fast_age		= ksz_port_fast_age,
+	.port_mirror_add	= lan937x_port_mirror_add,
+	.port_mirror_del	= lan937x_port_mirror_del,
 	.port_max_mtu		= lan937x_get_max_mtu,
 	.port_change_mtu	= lan937x_change_mtu,
 	.phylink_validate	= lan937x_phylink_validate,
-- 
2.25.1

