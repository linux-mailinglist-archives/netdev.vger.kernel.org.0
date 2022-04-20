Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355825088A2
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 15:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378681AbiDTNCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 09:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353867AbiDTNCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 09:02:52 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A139813EB8;
        Wed, 20 Apr 2022 06:00:05 -0700 (PDT)
Received: from localhost.localdomain (36-229-224-240.dynamic-ip.hinet.net [36.229.224.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id AE6313F151;
        Wed, 20 Apr 2022 12:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1650458481;
        bh=VntAryp7pHS3IpGhF1ep2QtdusC6JspGmTfDst4i0T0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Bcq9fWIS45Ke4/bGsBi2ya90q7vx4PUBxQ0Rb2jKYjZK2ysKAu+z08ubBuQ7nd7tU
         /zToGHu9RMwbv572gaa6c3ynEDBAW+0iNCR5n8t6UYTx1voSItZt+nshR8/vNDA6My
         Pt9+p0yfFCla4Xcln9vGb50Gyty0E76uQeqQJApZeT6aHN3Q8zd0mwkptA0h/XZdSK
         ifDgSlzASR9navM2IbkumU7ixyGMy2Tl1J3z5Aozj0dz+nOdvQdrn3WU98YHG0vn0r
         1Dokb624F+D2nJfJD0ztHQKTlhm9KRiw+RpydmvAaR8v1QU7cQFCAptn19+4C8+m4h
         rvoZy4fntC2Ng==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] net: phy: Add helpers to save and restore firmware LED
Date:   Wed, 20 Apr 2022 20:40:50 +0800
Message-Id: <20220420124053.853891-4-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220420124053.853891-1-kai.heng.feng@canonical.com>
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PHY drivers may set hardcoded LED config in phy_init_hw(), so to
preserve the firmware LED after init or system sleep, it needs to be
saved before init and be restored after.

To do so, create helpers and driver callbacks to access and save LED
config for the need.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/phy/phy_device.c | 22 ++++++++++++++++++++++
 include/linux/phy.h          |  4 ++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8406ac739def8..33b402279febe 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1154,6 +1154,24 @@ static int phy_poll_reset(struct phy_device *phydev)
 	return 0;
 }
 
+static void phy_save_led(struct phy_device *phydev)
+{
+	if (!phydev->use_firmware_led)
+		return;
+
+	if (phydev->drv->get_led_config)
+		phydev->led_config = phydev->drv->get_led_config(phydev);
+}
+
+static void phy_restore_led(struct phy_device *phydev)
+{
+	if (!phydev->use_firmware_led)
+		return;
+
+	if (phydev->drv->set_led_config && phydev->led_config)
+		phydev->drv->set_led_config(phydev, phydev->led_config);
+}
+
 int phy_init_hw(struct phy_device *phydev)
 {
 	int ret = 0;
@@ -1463,6 +1481,8 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	if (dev)
 		netif_carrier_off(phydev->attached_dev);
 
+	phy_save_led(phydev);
+
 	/* Do initial configuration here, now that
 	 * we have certain key parameters
 	 * (dev_flags and interface)
@@ -1803,6 +1823,8 @@ int __phy_resume(struct phy_device *phydev)
 	if (!ret)
 		phydev->suspended = false;
 
+	phy_restore_led(phydev);
+
 	return ret;
 }
 EXPORT_SYMBOL(__phy_resume);
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 53e693b3430ec..cd9c05ff75ee1 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -657,6 +657,7 @@ struct phy_device {
 	u32 eee_broken_modes;
 
 	bool use_firmware_led;
+	int led_config;
 #ifdef CONFIG_LED_TRIGGER_PHY
 	struct phy_led_trigger *phy_led_triggers;
 	unsigned int phy_num_led_triggers;
@@ -933,6 +934,9 @@ struct phy_driver {
 	int (*get_sqi)(struct phy_device *dev);
 	/** @get_sqi_max: Get the maximum signal quality indication */
 	int (*get_sqi_max)(struct phy_device *dev);
+
+	int (*get_led_config)(struct phy_device *dev);
+	void (*set_led_config)(struct phy_device *dev, int led_config);
 };
 #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
 				      struct phy_driver, mdiodrv)
-- 
2.34.1

