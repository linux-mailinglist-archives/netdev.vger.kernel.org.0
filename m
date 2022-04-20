Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50E4550889F
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 15:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378687AbiDTNC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 09:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353788AbiDTNCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 09:02:52 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF0D13E26;
        Wed, 20 Apr 2022 06:00:05 -0700 (PDT)
Received: from localhost.localdomain (36-229-224-240.dynamic-ip.hinet.net [36.229.224.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id B2A143FA44;
        Wed, 20 Apr 2022 12:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1650458486;
        bh=fXMvSxrY2aODO0+qKp3eX7m9XPpjBPG2a64kKMSOZyQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=OXnXrirEZez7fYw9oGdYhn+wnVci61w3zyuSi1uSYiyxWdF9k6G2DDaUhzrGLDv4Z
         hYQuE5hsqsFpT6qBGd2W/N8cqAJ+DFlH5gwPzEP8r4RmilYsBkLbXxogpxoYiZTmts
         FzS4QUm+L8CkKWXEWvyrhHz1geIpQidMmRut6ILmLQ+6I1EBigH7U+La7aseJZ0VlD
         kNrXUOG1uNnMw431VhKpraTcfnKA9wFvRX2BpX3bBG2DndYdeGiYj46ZaZbU6eDkpi
         2LdUAw9NmJ6GmWy4Tl+MeLGG3v0Soi1oLU3UuPdWmykeO9wG4QtMjko+6y/HABOL6j
         gYVbpQoibvyDQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] net: phy: marvell: Add LED accessors for Marvell 88E1510
Date:   Wed, 20 Apr 2022 20:40:51 +0800
Message-Id: <20220420124053.853891-5-kai.heng.feng@canonical.com>
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

Implement get_led_config() and set_led_config() callbacks so phy core
can use firmware LED as platform requested.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/phy/marvell.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 2702faf7b0f60..c5f13e09b0692 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -750,6 +750,30 @@ static int m88e1510_config_aneg(struct phy_device *phydev)
 	return err;
 }
 
+static int marvell_get_led_config(struct phy_device *phydev)
+{
+	int led;
+
+	led = phy_read_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL);
+	if (led < 0) {
+		phydev_warn(phydev, "Fail to get marvell phy LED.\n");
+		led = 0;
+	}
+
+	return led;
+}
+
+static void marvell_set_led_config(struct phy_device *phydev, int led_config)
+{
+	int err;
+
+	err = phy_write_paged(phydev, MII_MARVELL_LED_PAGE, MII_PHY_LED_CTRL,
+			      led_config);
+
+	if (err < 0)
+		phydev_warn(phydev, "Fail to set marvell phy LED.\n");
+}
+
 static void marvell_config_led(struct phy_device *phydev)
 {
 	u16 def_config;
@@ -3139,6 +3163,8 @@ static struct phy_driver marvell_drivers[] = {
 		.cable_test_start = marvell_vct7_cable_test_start,
 		.cable_test_tdr_start = marvell_vct5_cable_test_tdr_start,
 		.cable_test_get_status = marvell_vct7_cable_test_get_status,
+		.get_led_config = marvell_get_led_config,
+		.set_led_config = marvell_set_led_config,
 	},
 	{
 		.phy_id = MARVELL_PHY_ID_88E1540,
-- 
2.34.1

