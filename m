Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3145D5124BD
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 23:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234471AbiD0Vra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 17:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbiD0Vr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 17:47:29 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F3590CFA;
        Wed, 27 Apr 2022 14:44:17 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id BF68A2224E;
        Wed, 27 Apr 2022 23:44:15 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1651095855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HeKJkEt71bPubaeR0ycQvqtsMk9+SsEa9Z7AHhT5DRY=;
        b=Ip8NKiKDkDXeOimKLZyz1lCJlyT8FF+bqmxZsTRAB60biA70Yg0rry2fvDz4LgvUQ01xZS
        5W3ukYcCA8zyry815LGwnbh/c6+r+3iWRml3ZsjiWKLAFZIVxQ30FmQVmucCCiUzTrl0Fj
        NBdM79vREfzwAtUVjXI7itiyj+pUhbs=
From:   Michael Walle <michael@walle.cc>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH net-next v1 2/3] net: phy: micrel: move the PHY timestamping check
Date:   Wed, 27 Apr 2022 23:44:05 +0200
Message-Id: <20220427214406.1348872-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220427214406.1348872-1-michael@walle.cc>
References: <20220427214406.1348872-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both lan8814_ptp_init() and lan8814_ptp_probe_once() are only used if
PTP and PHY timestamping is enabed. Up until now the probe function just
returns early, if they are not needed. But we need the
phy_package_init_once() functionality for the coma mode GPIO setup. Move
the check into the functions itself.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/micrel.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 96840695debd..b981c5eaac33 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -2729,6 +2729,10 @@ static void lan8814_ptp_init(struct phy_device *phydev)
 	struct kszphy_ptp_priv *ptp_priv = &priv->ptp_priv;
 	u32 temp;
 
+	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
+	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
+		return;
+
 	lanphy_write_page_reg(phydev, 5, TSU_HARD_RESET, TSU_HARD_RESET_);
 
 	temp = lanphy_read_page_reg(phydev, 5, PTP_TX_MOD);
@@ -2767,6 +2771,10 @@ static int lan8814_ptp_probe_once(struct phy_device *phydev)
 {
 	struct lan8814_shared_priv *shared = phydev->shared->priv;
 
+	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
+	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
+		return 0;
+
 	/* Initialise shared lock for clock*/
 	mutex_init(&shared->shared_lock);
 
@@ -2843,10 +2851,6 @@ static int lan8814_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
-	if (!IS_ENABLED(CONFIG_PTP_1588_CLOCK) ||
-	    !IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING))
-		return 0;
-
 	/* Strap-in value for PHY address, below register read gives starting
 	 * phy address value
 	 */
-- 
2.30.2

