Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC22442566E
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:13:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242530AbhJGPPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:15:11 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:53566 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242433AbhJGPPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:15:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633619588; x=1665155588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ltsQE5En3J9IYVrCSm0c1rW5geohv5eMI/LZq1iS4Eo=;
  b=tAAPdkrysfXgloa9Gvfa89edeqjSC8pfG6IHnktqedvRe/RVF78ohwyN
   wYSnY+nx7ihwUSMfc68Kr9qJmn4uIqOakREhsEeiWpuG+q2ZWEJGOd/NE
   IIZuIClrBsCR1OAE5IyvB1YnYhl8XT7ARdXj98OZgJX61nQ8t0113hlTX
   I7g5U2NJCmKxZ8vAYEabBOwGktUpnxzbYg13mBNJW9mcFdkTEkR1Kc1fp
   1ZB9z6U+dVrAt4ZSBrkSty2OXuWh4XWhFKA28zskaYEQrLiHihWXJYDDO
   /2dl/1MS2cfiTudE8a8JtpCQqZgJ09FE3cBDfEWHB/+cHF+EmCMlYRfm4
   A==;
IronPort-SDR: J4iLAoc62CwncNL3T0xjgLLKI0TejfWv4zC+Tapao5pJAmK7mVY6l/IXmXloRVOWiVSk4j46oW
 bYh14zghRI29DJhhGhTMUcfKuoHWc+9/IO24rV4ROzF7yeTM3PTs64BxX9b/hQbZCknuQnZ1Xl
 5dJHeRRkQEeKxAswjAItb+z5l7H3h6jAzDo94Um6basYSRjTEQ3aqJuln6P8IBVJoyxoYYCY3e
 18kw+Rj56csHvKSp22iTHjStcG2USiA8RTwdR2rbMESeLKk6YjprXfdW+kHWlsEjdAPG/ZdFBx
 Ewm0jPUB5Lc4ueY6T7t964pj
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="72034388"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2021 08:13:08 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 08:13:05 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 7 Oct 2021 08:13:00 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v4 net-next 08/10] net: dsa: microchip: add support for port mirror operations
Date:   Thu, 7 Oct 2021 20:41:58 +0530
Message-ID: <20211007151200.748944-9-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added support for port_mirror_add() and port_mirror_del operations

Sniffing is limited to one port & alert the user if any new
sniffing port is selected

Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
---
 drivers/net/dsa/microchip/lan937x_main.c | 84 ++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index f2f42b3bdb31..6cd23ef74d44 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -125,6 +125,88 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 		ksz_update_port_member(dev, port);
 }
 
+static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
+				   struct dsa_mall_mirror_tc_entry *mirror,
+				   bool ingress)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret, p;
+	u8 data;
+
+	/* Limit to one sniffer port
+	 * Check if any of the port is already set for sniffing
+	 * If yes, instruct the user to remove the previous entry & exit
+	 */
+	for (p = 0; p < dev->port_cnt; p++) {
+		/* Skip the current sniffing port */
+		if (p == mirror->to_local_port)
+			continue;
+
+		ret = lan937x_pread8(dev, p, P_MIRROR_CTRL, &data);
+		if (ret < 0)
+			return ret;
+
+		if (data & PORT_MIRROR_SNIFFER) {
+			dev_err(dev->dev,
+				"Delete existing rules towards %s & try\n",
+				dsa_to_port(ds, p)->name);
+			return -EBUSY;
+		}
+	}
+
+	/* Configure ingress/egress mirroring */
+	if (ingress)
+		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
+				       true);
+	else
+		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
+				       true);
+	if (ret < 0)
+		return ret;
+
+	/* Configure sniffer port as other ports do not have
+	 * PORT_MIRROR_SNIFFER is set
+	 */
+	ret = lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+			       PORT_MIRROR_SNIFFER, true);
+	if (ret < 0)
+		return ret;
+
+	return lan937x_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
+}
+
+static void lan937x_port_mirror_del(struct dsa_switch *ds, int port,
+				    struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct ksz_device *dev = ds->priv;
+	bool in_use = false;
+	u8 data;
+	int p;
+
+	/* clear ingress/egress mirroring port */
+	if (mirror->ingress)
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
+				 false);
+	else
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
+				 false);
+
+	/* Check if any of the port is still referring to sniffer port */
+	for (p = 0; p < dev->port_cnt; p++) {
+		lan937x_pread8(dev, p, P_MIRROR_CTRL, &data);
+
+		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
+			in_use = true;
+			break;
+		}
+	}
+
+	/* delete sniffing if there are no other mirroring rule exist */
+	if (!in_use)
+		lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+				 PORT_MIRROR_SNIFFER, false);
+}
+
 static phy_interface_t lan937x_get_interface(struct ksz_device *dev, int port)
 {
 	phy_interface_t interface;
@@ -494,6 +576,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
 	.port_bridge_leave = ksz_port_bridge_leave,
 	.port_stp_state_set = lan937x_port_stp_state_set,
 	.port_fast_age = ksz_port_fast_age,
+	.port_mirror_add = lan937x_port_mirror_add,
+	.port_mirror_del = lan937x_port_mirror_del,
 	.port_max_mtu = lan937x_get_max_mtu,
 	.port_change_mtu = lan937x_change_mtu,
 	.phylink_validate = lan937x_phylink_validate,
-- 
2.27.0

