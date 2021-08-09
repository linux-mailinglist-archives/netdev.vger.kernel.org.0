Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6340D3E41EA
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 10:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbhHII44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 04:56:56 -0400
Received: from m12-17.163.com ([220.181.12.17]:41950 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhHII4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 04:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=SaLiU
        6rl8I1fehJTnnti4e5laXVkApwI2Fxq28Tv9oc=; b=jSW1ffuodRCzBZgodTEWc
        PwjQDbLJg4nCWZGIGlLcFMbeHZusG4YSRXTZRDT2snBdOP4b5ic5Y8ShAlXM0YZs
        AlFCsUyVeLarrgD5xXyw0ZkslGyLCinwxaxUuWWCo5pZU/Zfj0R1hIZzKrAAdk8/
        9DYRNYSasgRTTA7hbSvm6Y=
Received: from asura.lan (unknown [182.149.135.186])
        by smtp13 (Coremail) with SMTP id EcCowACHrYmK7RBhJOasFA--.10715S2;
        Mon, 09 Aug 2021 16:55:38 +0800 (CST)
From:   chaochao2021666@163.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Chao Zeng <chao.zeng@siemens.com>
Subject: [PATCH 2/2] net:phy:dp83867:implement the binding for status led
Date:   Mon,  9 Aug 2021 16:55:10 +0800
Message-Id: <20210809085510.324205-1-chaochao2021666@163.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EcCowACHrYmK7RBhJOasFA--.10715S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AFyUJF1ftw43Aw4kZw47Jwb_yoW8Wr1xpr
        4Y9Fy3A3yUtF4xGw4SqF4kCryYgw4IqryfKrWagan5Zw15AFy8AF1jqFyUXF93CrWrAFy3
        uF4rAFW2gas8Z3JanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jhYFZUUUUU=
X-Originating-IP: [182.149.135.186]
X-CM-SenderInfo: 5fkd0uhkdrjiasrwlli6rwjhhfrp/1tbiqwvpdVUMacs2JAAAsV
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chao Zeng <chao.zeng@siemens.com>

the DP83867 has different function option for the status led.
It is possible to set the status led for different function

Signed-off-by: Chao Zeng <chao.zeng@siemens.com>
---
 drivers/net/phy/dp83867.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 6bbc81ad295f..71dc3101ce28 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -148,6 +148,10 @@
 /* FLD_THR_CFG */
 #define DP83867_FLD_THR_CFG_ENERGY_LOST_THR_MASK	0x7
 
+/* Led Configuration */
+#define DP83867_LEDCR_1      0x0018
+#define LED_GPIO_NUM_SEL	 0x4
+
 enum {
 	DP83867_PORT_MIRROING_KEEP,
 	DP83867_PORT_MIRROING_EN,
@@ -527,6 +531,9 @@ static int dp83867_of_init(struct phy_device *phydev)
 	struct device *dev = &phydev->mdio.dev;
 	struct device_node *of_node = dev->of_node;
 	int ret;
+	u32 led_conf;
+	u32 led_select_value;
+	int index;
 
 	if (!of_node)
 		return -ENODEV;
@@ -614,6 +621,19 @@ static int dp83867_of_init(struct phy_device *phydev)
 		return -EINVAL;
 	}
 
+	/* Optional LED configuration */
+	for (index = 0; index < LED_GPIO_NUM_SEL; index++) {
+		ret = of_property_read_u32_index(of_node, "ti,led-sel",
+						 index, &led_select_value);
+		if (ret < 0) {
+			phydev_info(phydev, "Use default value for led configuration\n");
+			return -EINVAL;
+		}
+		led_conf = led_conf << 4 | led_select_value;
+	}
+
+	phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_LEDCR_1, led_conf);
+
 	return 0;
 }
 #else
-- 
2.32.0


