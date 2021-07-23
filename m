Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2531E3D3ECC
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232657AbhGWQvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:51:49 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:8460 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232655AbhGWQvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627061530; x=1658597530;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f0PmlUxwF8paIIMeEqXgn8NIba0oVgCESJZMtBfvHm0=;
  b=idvnreWnPTQSvN/DC/L0POJSqb988yXV8QgffG8uIM4eHiXOJcco/T3j
   HKB957pJLdpqmjXHzdgcwjqBhdCErnbsRsYUXtWe9c+VKBpjdFeTWuUvM
   znRi8euvhtUxR33dwfb2gwi9wqQx00CVKkO0tzU6SmL2edsFhDzD67Jge
   yNFpdnAEqYVVfGoXA59RN3czA5hpixZYHvHQ7Jxtk/UH970RgogOV3brO
   5BLdTLDQBxX4akIdq2rbNrwla/3Nh4TLVyWJ9BEKahSs424Gqwu9XCJWv
   LJxU4kRdxby1Ds9HV80HRBKfiR6DjTfizwJj8SqZokICamBwKxlnmJV2A
   Q==;
IronPort-SDR: Xgbj82bmp7x93Yp39Td6VLBlZJIXJgUo5lVxScR1gucuuSVrbTLD7LSVqzveDrs0MJWBMYVHw6
 Dc4Ovvv3C8dFgCAoScuhnLbtdwOE+oVIa+Rtb+zosaa3FWrH9RKuQEdi1meBRmdTXzf9TP2yZw
 m6NV7ELXzd1+KwFMz3cV53lHxytncIpUu5IcP0Yu1a3hBf6AM4UD0SlckKAslOwxR4jgc6j+6a
 xyk8wMP+K4IwQs/yyLyEWQ3KayvP/qDXhU8aI8A9SxSnY7KRHSxDhutfmiisqPGZJ7GDKRHD6V
 +hm4ICu1oCXO2YIxhzXongHR
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="125755743"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2021 10:32:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 10:32:00 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 23 Jul 2021 10:31:55 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v3 net-next 08/10] net: dsa: microchip: add support for port mirror operations
Date:   Fri, 23 Jul 2021 23:01:06 +0530
Message-ID: <20210723173108.459770-9-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
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
 drivers/net/dsa/microchip/lan937x_main.c | 83 ++++++++++++++++++++++++
 1 file changed, 83 insertions(+)

diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
index 3380a4617725..171c46f37fa4 100644
--- a/drivers/net/dsa/microchip/lan937x_main.c
+++ b/drivers/net/dsa/microchip/lan937x_main.c
@@ -129,6 +129,87 @@ static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
 	mutex_unlock(&dev->dev_mutex);
 }
 
+static int lan937x_port_mirror_add(struct dsa_switch *ds, int port,
+				   struct dsa_mall_mirror_tc_entry *mirror,
+				   bool ingress)
+{
+	struct ksz_device *dev = ds->priv;
+	int ret, p;
+	u8 data;
+
+	/* Configure ingress/egress mirroring*/
+	if (ingress)
+		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
+				       true);
+	else
+		ret = lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
+				       true);
+	if (ret < 0)
+		return ret;
+
+	/* Configure sniffer port meanwhile limit to one sniffer port
+	 * Check if any of the port is already set for sniffing
+	 * If yes, instruct the user to remove the previous entry & exit
+	 */
+	for (p = 0; p < dev->port_cnt; p++) {
+		/*Skip the current sniffing port*/
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
+	ret = lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+			       PORT_MIRROR_SNIFFER, true);
+	if (ret < 0)
+		return ret;
+
+	ret = lan937x_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
+
+	return ret;
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
+	/* clear ingress/egress mirroring port*/
+	if (mirror->ingress)
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX,
+				 false);
+	else
+		lan937x_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX,
+				 false);
+
+	/* Check if any of the port is still referring to sniffer port*/
+	for (p = 0; p < dev->port_cnt; p++) {
+		lan937x_pread8(dev, p, P_MIRROR_CTRL, &data);
+
+		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
+			in_use = true;
+			break;
+		}
+	}
+
+	/* delete sniffing if there are no other mirroring rule exist*/
+	if (!in_use)
+		lan937x_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+				 PORT_MIRROR_SNIFFER, false);
+}
+
 static phy_interface_t lan937x_get_interface(struct ksz_device *dev, int port)
 {
 	phy_interface_t interface;
@@ -406,6 +487,8 @@ const struct dsa_switch_ops lan937x_switch_ops = {
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

