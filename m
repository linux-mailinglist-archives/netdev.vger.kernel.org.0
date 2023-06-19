Return-Path: <netdev+bounces-12089-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96253735F70
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 23:58:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A609281095
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E65DA154BD;
	Mon, 19 Jun 2023 21:57:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D634F154B4
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 21:57:21 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F86AE54
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
	Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=XtDYKdew3rEhjb+BLQYGrrzpb8oeokelun9vRymiprY=; b=M83YW7j8fXINqmjuGjWVdBo2ih
	4yrWZzGk+zLsvKB0C5ii67+QZUokzR3g9xoKXnrhybYzIfJao8t3o+8OCw4YqaoHzc1UvBLoArHCy
	2Klg2wdRwBBq8byOLFDUPELxGVFmV4hMe1MIpxAo8pup2SLV4rhCsR+wIqY246isYiUM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qBMs9-00GwdN-Jq; Mon, 19 Jun 2023 23:57:17 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: netdev <netdev@vger.kernel.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Simon Horman <simon.horman@corigine.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v1 3/3] net: phy: marvell: Add support for offloading LED blinking
Date: Mon, 19 Jun 2023 23:57:03 +0200
Message-Id: <20230619215703.4038619-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230619215703.4038619-1-andrew@lunn.ch>
References: <20230619215703.4038619-1-andrew@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add the code needed to indicate if a given blinking pattern can be
offloaded, to offload a pattern and to try to return the current
pattern. It is expected that ledtrig-netdev will gain support for
other patterns, such as different link speeds etc. So the code is
over-engineers to make adding such additional patterns easy.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/phy/marvell.c | 243 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 243 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 43b6cb725551..a443df3034f3 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -2893,6 +2893,234 @@ static int m88e1318_led_blink_set(struct phy_device *phydev, u8 index,
 			       MII_88E1318S_PHY_LED_FUNC, reg);
 }
 
+struct marvell_led_rules {
+	int mode;
+	unsigned long rules;
+};
+
+static const struct marvell_led_rules marvell_led0[] = {
+	{
+		.mode = 0,
+		.rules = BIT(TRIGGER_NETDEV_LINK),
+	},
+	{
+		.mode = 3,
+		.rules = (BIT(TRIGGER_NETDEV_RX) |
+			  BIT(TRIGGER_NETDEV_TX)),
+	},
+	{
+		.mode = 4,
+		.rules = (BIT(TRIGGER_NETDEV_RX) |
+			  BIT(TRIGGER_NETDEV_TX)),
+	},
+	{
+		.mode = 5,
+		.rules = BIT(TRIGGER_NETDEV_TX),
+	},
+	{
+		.mode = 8,
+		.rules = 0,
+	},
+};
+
+static const struct marvell_led_rules marvell_led1[] = {
+	{
+		.mode = 1,
+		.rules = (BIT(TRIGGER_NETDEV_LINK) |
+			  BIT(TRIGGER_NETDEV_RX) |
+			  BIT(TRIGGER_NETDEV_TX)),
+	},
+	{
+		.mode = 2,
+		.rules = (BIT(TRIGGER_NETDEV_LINK) |
+			  BIT(TRIGGER_NETDEV_RX)),
+	},
+	{
+		.mode = 3,
+		.rules = (BIT(TRIGGER_NETDEV_RX) |
+			  BIT(TRIGGER_NETDEV_TX)),
+	},
+	{
+		.mode = 4,
+		.rules = (BIT(TRIGGER_NETDEV_RX) |
+			  BIT(TRIGGER_NETDEV_TX)),
+	},
+	{
+		.mode = 8,
+		.rules = 0,
+	},
+};
+
+static const struct marvell_led_rules marvell_led2[] = {
+	{
+		.mode = 0,
+		.rules = BIT(TRIGGER_NETDEV_LINK),
+	},
+	{
+		.mode = 1,
+		.rules = (BIT(TRIGGER_NETDEV_LINK) |
+			  BIT(TRIGGER_NETDEV_RX) |
+			  BIT(TRIGGER_NETDEV_TX)),
+	},
+	{
+		.mode = 3,
+		.rules = (BIT(TRIGGER_NETDEV_RX) |
+			  BIT(TRIGGER_NETDEV_TX)),
+	},
+	{
+		.mode = 4,
+		.rules = (BIT(TRIGGER_NETDEV_RX) |
+			  BIT(TRIGGER_NETDEV_TX)),
+	},
+	{
+		.mode = 5,
+		.rules = BIT(TRIGGER_NETDEV_TX),
+	},
+	{
+		.mode = 8,
+		.rules = 0,
+	},
+};
+
+static int marvell_find_led_mode(unsigned long rules,
+				 const struct marvell_led_rules *marvell_rules,
+				 int count,
+				 int *mode)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if (marvell_rules[i].rules == rules) {
+			*mode = marvell_rules[i].mode;
+			return 0;
+		}
+	}
+	return -EOPNOTSUPP;
+}
+
+static int marvell_get_led_mode(u8 index, unsigned long rules, int *mode)
+{
+	int ret;
+
+	switch (index) {
+	case 0:
+		ret = marvell_find_led_mode(rules, marvell_led0,
+					    ARRAY_SIZE(marvell_led0), mode);
+		break;
+	case 1:
+		ret = marvell_find_led_mode(rules, marvell_led1,
+					    ARRAY_SIZE(marvell_led1), mode);
+		break;
+	case 2:
+		ret = marvell_find_led_mode(rules, marvell_led2,
+					    ARRAY_SIZE(marvell_led2), mode);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static int marvell_find_led_rules(unsigned long *rules,
+				  const struct marvell_led_rules *marvell_rules,
+				  int count,
+				  int mode)
+{
+	int i;
+
+	for (i = 0; i < count; i++) {
+		if (marvell_rules[i].mode == mode) {
+			*rules = marvell_rules[i].rules;
+			return 0;
+		}
+	}
+	return -EOPNOTSUPP;
+}
+
+static int marvell_get_led_rules(u8 index, unsigned long *rules, int mode)
+{
+	int ret;
+
+	switch (index) {
+	case 0:
+		ret = marvell_find_led_rules(rules, marvell_led0,
+					     ARRAY_SIZE(marvell_led0), mode);
+		break;
+	case 1:
+		ret = marvell_find_led_rules(rules, marvell_led1,
+					     ARRAY_SIZE(marvell_led1), mode);
+		break;
+	case 2:
+		ret = marvell_find_led_rules(rules, marvell_led2,
+					     ARRAY_SIZE(marvell_led2), mode);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+static int m88e1318_led_hw_is_supported(struct phy_device *phydev, u8 index,
+					unsigned long rules)
+{
+	int mode, ret;
+
+	switch (index) {
+	case 0:
+	case 1:
+	case 2:
+		ret = marvell_get_led_mode(index, rules, &mode);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int m88e1318_led_hw_control_set(struct phy_device *phydev, u8 index,
+				       unsigned long rules)
+{
+	int mode, ret, reg;
+
+	switch (index) {
+	case 0:
+	case 1:
+	case 2:
+		ret = marvell_get_led_mode(index, rules, &mode);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	if (ret < 0)
+		return ret;
+
+	reg = phy_read_paged(phydev, MII_MARVELL_LED_PAGE,
+			     MII_88E1318S_PHY_LED_FUNC);
+	reg &= ~(0xf << (4 * index));
+	reg |= mode << (4 * index);
+	return phy_write_paged(phydev, MII_MARVELL_LED_PAGE,
+			       MII_88E1318S_PHY_LED_FUNC, reg);
+}
+
+static int m88e1318_led_hw_control_get(struct phy_device *phydev, u8 index,
+				       unsigned long *rules)
+{
+	int mode, reg;
+
+	if (index > 2)
+		return -EINVAL;
+
+	reg = phy_read_paged(phydev, MII_MARVELL_LED_PAGE,
+			     MII_88E1318S_PHY_LED_FUNC);
+	mode = (reg >> (4 * index)) & 0xf;
+
+	return marvell_get_led_rules(index, rules, mode);
+}
+
 static int marvell_probe(struct phy_device *phydev)
 {
 	struct marvell_priv *priv;
@@ -3144,6 +3372,9 @@ static struct phy_driver marvell_drivers[] = {
 		.get_stats = marvell_get_stats,
 		.led_brightness_set = m88e1318_led_brightness_set,
 		.led_blink_set = m88e1318_led_blink_set,
+		.led_hw_is_supported = m88e1318_led_hw_is_supported,
+		.led_hw_control_set = m88e1318_led_hw_control_set,
+		.led_hw_control_get = m88e1318_led_hw_control_get,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1145,
@@ -3252,6 +3483,9 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 		.led_brightness_set = m88e1318_led_brightness_set,
 		.led_blink_set = m88e1318_led_blink_set,
+		.led_hw_is_supported = m88e1318_led_hw_is_supported,
+		.led_hw_control_set = m88e1318_led_hw_control_set,
+		.led_hw_control_get = m88e1318_led_hw_control_get,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
@@ -3280,6 +3514,9 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 		.led_brightness_set = m88e1318_led_brightness_set,
 		.led_blink_set = m88e1318_led_blink_set,
+		.led_hw_is_supported = m88e1318_led_hw_is_supported,
+		.led_hw_control_set = m88e1318_led_hw_control_set,
+		.led_hw_control_get = m88e1318_led_hw_control_get,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1545,
@@ -3308,6 +3545,9 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
 		.led_brightness_set = m88e1318_led_brightness_set,
 		.led_blink_set = m88e1318_led_blink_set,
+		.led_hw_is_supported = m88e1318_led_hw_is_supported,
+		.led_hw_control_set = m88e1318_led_hw_control_set,
+		.led_hw_control_get = m88e1318_led_hw_control_get,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E3016,
@@ -3451,6 +3691,9 @@ static struct phy_driver marvell_drivers[] = {
 		.set_tunable = m88e1540_set_tunable,
 		.led_brightness_set = m88e1318_led_brightness_set,
 		.led_blink_set = m88e1318_led_blink_set,
+		.led_hw_is_supported = m88e1318_led_hw_is_supported,
+		.led_hw_control_set = m88e1318_led_hw_control_set,
+		.led_hw_control_get = m88e1318_led_hw_control_get,
 	},
 };
 
-- 
2.40.1


