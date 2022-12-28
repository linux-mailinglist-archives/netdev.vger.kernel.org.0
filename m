Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3A5658335
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbiL1QpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 11:45:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbiL1Qoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 11:44:34 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F215B1CB1D;
        Wed, 28 Dec 2022 08:40:15 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id D7A46164F;
        Wed, 28 Dec 2022 17:40:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1672245614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fOtac2haGHAAUtssRyLivkuvpvDLBROt7UT90bRGM7w=;
        b=SkCJSnkOQzbb51y62g2o9GTW7ibk+LHtcVZDiiZHcOAdYnK5DQaEImB0DZsscfYU1X2mwb
        kU9LU6+psIJjOpWlNu9zFNrs1AhFgaixgpqwoYfUppjaN8RJdu4E4DVl1oMlpZ2wWS5Kzh
        E1nsID//If9yDHArPYbIueNCIpcxMz2j0S2saiE3/09GwhEGmbNT/54jsg8A7C6mWUFnjo
        UzShh5ffQtfmiU8sIhmJavL0+e3Be7w/gTn9nld0T5Qw3+VIgTY3wgQR9JC8Wx29TS/RML
        lHf26yoenBQqHtFbCx8BdWX/+0FlI/X+qwAXwdYqcbXCn5TFeFmP766W+7KpZA==
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH RFC net-next v2 1/2] net: phy: allow a phy to opt-out of interrupt handling
Date:   Wed, 28 Dec 2022 17:40:07 +0100
Message-Id: <20221228164008.1653348-2-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221228164008.1653348-1-michael@walle.cc>
References: <20221228164008.1653348-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Until now, it is not possible for a PHY driver to disable interrupts
during runtime. If a driver offers the .config_intr() as well as the
.handle_interrupt() ops, it is eligible for interrupt handling.
Introduce a new flag for the dev_flags property of struct phy_device, which
can be set by PHY driver to skip interrupt setup and fall back to polling
mode.

At the moment, this is used for the MaxLinear PHY which has broken
interrupt handling and there is a need to disable interrupts in some
cases.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/phy_device.c | 7 +++++++
 include/linux/phy.h          | 2 ++
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 716870a4499c..e4562859ac00 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1487,6 +1487,13 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	phydev->interrupts = PHY_INTERRUPT_DISABLED;
 
+	/* PHYs can request to use poll mode even though they have an
+	 * associated interrupt line. This could be the case if they
+	 * detect a broken interrupt handling.
+	 */
+	if (phydev->dev_flags & PHY_F_NO_IRQ)
+		phydev->irq = PHY_POLL;
+
 	/* Port is set to PORT_TP by default and the actual PHY driver will set
 	 * it to different value depending on the PHY configuration. If we have
 	 * the generic PHY driver we can't figure it out, thus set the old
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 71eeb4e3b1fd..f1566c7e47a8 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -82,6 +82,8 @@ extern const int phy_10gbit_features_array[1];
 #define PHY_POLL_CABLE_TEST	0x00000004
 #define MDIO_DEVICE_IS_PHY	0x80000000
 
+#define PHY_F_NO_IRQ		0x80000000
+
 /**
  * enum phy_interface_t - Interface Mode definitions
  *
-- 
2.30.2

