Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248126EFE64
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242889AbjD0AUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:20:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242985AbjD0ATT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:19:19 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5423B448D;
        Wed, 26 Apr 2023 17:19:07 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-2f58125b957so7127692f8f.3;
        Wed, 26 Apr 2023 17:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554746; x=1685146746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fTXQkDrZZKZ9NP+ZntA7z4ey4eFFetW9y6L1uqW2c2o=;
        b=BdLd3Hpesr5MPJ+MQ55+Cy9vElb4yiFY1Ai/b1ACb5byzGZBsPTkhjw3IEJThFTTKk
         zL+Wxak75rupCNVj6ZHimUQoFPKCWzNdhzNBCS4okH1nyYndjp6GudCJLR0FTsyMtmKk
         yveLdKxoxSsMhj9FdEgb6h+sqKyobNagGAzENFIUib8u3S95cQM2Zz3KBAOITcogkhoZ
         /y77C8BCxB2m1sFMsrzQqYBordGzMTtgdCrbur3sBqVH4T7SISlN0XOA84f3bKuQ3b0I
         qXHSg26PEq67V8NML+Jkorv4QiuXb1CnYd3tim9/zEijLy+r67dAT9uxK6UZE5Q9CH0L
         h+Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554746; x=1685146746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fTXQkDrZZKZ9NP+ZntA7z4ey4eFFetW9y6L1uqW2c2o=;
        b=Kqz+4u7gfHQlCHcDGYjtWV+x0cpJg0KvJs4cOXTOwNd5+H5XvBU64PFPPIe5z3bxB8
         M4uL+FodyCdJU8FruLnXZHA8n+KTuobS8knQjGZa5Ab31fwmgOTzNeVixMzRcMY+H+cE
         0oXgFQCxGWn4l3iDFY4oDY7PYk1Hu85wmydOCSbhUDnSGsEm1kMr6vQpFauB2A2aEbfG
         8E3cTbwQfYROu21xtL0zNo5fGzSxYvCpJFgAXLvx5JYja30+fQNZTXeAHDi0o0l0tI0C
         FDWl3et1Gn5IYP1y/mblKTa8mQYjUtgusfEdqZRqWawgD1sLXmeV415JTt8VA3f5yCDl
         B3HQ==
X-Gm-Message-State: AAQBX9dUsMg8p/dIK+lsMzNEiqZQgey37ZphVq+prfssRZjD4FePdLWC
        kVte6Z2G2qp3t5PvLr77hI8=
X-Google-Smtp-Source: AKy350Ysp+3nhBb0hxVO4QFQ94CQgUWZUGxe+lx0npA0tp1+RiBjF2kiSuLfZOpJ0MdhPauopmovtg==
X-Received: by 2002:a5d:6585:0:b0:2f5:953a:4f59 with SMTP id q5-20020a5d6585000000b002f5953a4f59mr15096148wru.5.1682554745432;
        Wed, 26 Apr 2023 17:19:05 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:19:05 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 11/11] net: dsa: qca8k: implement hw_control ops
Date:   Thu, 27 Apr 2023 02:15:41 +0200
Message-Id: <20230427001541.18704-12-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230427001541.18704-1-ansuelsmth@gmail.com>
References: <20230427001541.18704-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement hw_control ops to drive Switch LEDs based on hardware events.

Netdev trigger is the declared supported trigger for hw control
operation and supports the following mode:
- tx
- rx

When hw_control_set is called, LEDs are set to follow the requested
mode.
Each LEDs will blink at 4Hz by default.

Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca/qca8k-leds.c | 156 +++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
index 1ecb29953600..54d3ff46e00a 100644
--- a/drivers/net/dsa/qca/qca8k-leds.c
+++ b/drivers/net/dsa/qca/qca8k-leds.c
@@ -30,6 +30,43 @@ qca8k_get_enable_led_reg(int port_num, int led_num, struct qca8k_led_pattern_en
 	return 0;
 }
 
+static int
+qca8k_get_control_led_reg(int port_num, int led_num, struct qca8k_led_pattern_en *reg_info)
+{
+	reg_info->reg = QCA8K_LED_CTRL_REG(led_num);
+
+	/* 6 total control rule:
+	 * 3 control rules for phy0-3 that applies to all their leds
+	 * 3 control rules for phy4
+	 */
+	if (port_num == 4)
+		reg_info->shift = QCA8K_LED_PHY4_CONTROL_RULE_SHIFT;
+	else
+		reg_info->shift = QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT;
+
+	return 0;
+}
+
+static int
+qca8k_parse_netdev(unsigned long rules, u32 *offload_trigger)
+{
+	/* Parsing specific to netdev trigger */
+	if (test_bit(TRIGGER_NETDEV_TX, &rules))
+		*offload_trigger |= QCA8K_LED_TX_BLINK_MASK;
+	if (test_bit(TRIGGER_NETDEV_RX, &rules))
+		*offload_trigger |= QCA8K_LED_RX_BLINK_MASK;
+
+	if (rules && !*offload_trigger)
+		return -EOPNOTSUPP;
+
+	/* Enable some default rule by default to the requested mode:
+	 * - Blink at 4Hz by default
+	 */
+	*offload_trigger |= QCA8K_LED_BLINK_4HZ;
+
+	return 0;
+}
+
 static int
 qca8k_led_brightness_set(struct qca8k_led *led,
 			 enum led_brightness brightness)
@@ -135,6 +172,119 @@ qca8k_cled_blink_set(struct led_classdev *ldev,
 	return 0;
 }
 
+static int
+qca8k_cled_trigger_offload(struct led_classdev *ldev, bool enable)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 mask, val = QCA8K_LED_ALWAYS_OFF;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	if (enable)
+		val = QCA8K_LED_RULE_CONTROLLED;
+
+	if (led->port_num == 0 || led->port_num == 4) {
+		mask = QCA8K_LED_PATTERN_EN_MASK;
+		val <<= QCA8K_LED_PATTERN_EN_SHIFT;
+	} else {
+		mask = QCA8K_LED_PHY123_PATTERN_EN_MASK;
+	}
+
+	return regmap_update_bits(priv->regmap, reg_info.reg, mask << reg_info.shift,
+				  val << reg_info.shift);
+}
+
+static bool
+qca8k_cled_hw_control_status(struct led_classdev *ldev)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 val;
+
+	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
+
+	regmap_read(priv->regmap, reg_info.reg, &val);
+
+	val >>= reg_info.shift;
+
+	if (led->port_num == 0 || led->port_num == 4) {
+		val &= QCA8K_LED_PATTERN_EN_MASK;
+		val >>= QCA8K_LED_PATTERN_EN_SHIFT;
+	} else {
+		val &= QCA8K_LED_PHY123_PATTERN_EN_MASK;
+	}
+
+	return val == QCA8K_LED_RULE_CONTROLLED;
+}
+
+static int
+qca8k_cled_hw_control_is_supported(struct led_classdev *ldev, unsigned long rules)
+{
+	u32 offload_trigger = 0;
+
+	return qca8k_parse_netdev(rules, &offload_trigger);
+}
+
+static int
+qca8k_cled_hw_control_set(struct led_classdev *ldev, unsigned long rules)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 offload_trigger = 0;
+	int ret;
+
+	ret = qca8k_parse_netdev(rules, &offload_trigger);
+	if (ret)
+		return ret;
+
+	ret = qca8k_cled_trigger_offload(ldev, true);
+	if (ret)
+		return ret;
+
+	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
+
+	return regmap_update_bits(priv->regmap, reg_info.reg,
+				  QCA8K_LED_RULE_MASK << reg_info.shift,
+				  offload_trigger << reg_info.shift);
+}
+
+static int
+qca8k_cled_hw_control_get(struct led_classdev *ldev, unsigned long *rules)
+{
+	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
+	struct qca8k_led_pattern_en reg_info;
+	struct qca8k_priv *priv = led->priv;
+	u32 val;
+	int ret;
+
+	/* With hw control not active return err */
+	if (!qca8k_cled_hw_control_status(ldev))
+		return -EINVAL;
+
+	qca8k_get_control_led_reg(led->port_num, led->led_num, &reg_info);
+
+	ret = regmap_read(priv->regmap, reg_info.reg, &val);
+	if (ret)
+		return ret;
+
+	val >>= reg_info.shift;
+	val &= QCA8K_LED_RULE_MASK;
+
+	/* Parsing specific to netdev trigger */
+	if (val & QCA8K_LED_TX_BLINK_MASK)
+		set_bit(TRIGGER_NETDEV_TX, rules);
+	if (val & QCA8K_LED_RX_BLINK_MASK)
+		set_bit(TRIGGER_NETDEV_RX, rules);
+
+	return 0;
+}
+
 static int
 qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
 {
@@ -193,6 +343,12 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
 		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
 		port_led->cdev.brightness_get = qca8k_cled_brightness_get;
 		port_led->cdev.blink_set = qca8k_cled_blink_set;
+		port_led->cdev.hw_control_is_supported = qca8k_cled_hw_control_is_supported;
+		port_led->cdev.hw_control_set = qca8k_cled_hw_control_set;
+		port_led->cdev.hw_control_get = qca8k_cled_hw_control_get;
+		port_led->cdev.hw_control_trigger = "netdev";
+		port_led->cdev.trigger_supported_flags_mask = BIT(TRIGGER_NETDEV_TX) |
+							      BIT(TRIGGER_NETDEV_RX);
 		init_data.default_label = ":port";
 		init_data.devicename = "qca8k";
 		init_data.fwnode = led;
-- 
2.39.2

