Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B88F50FFBA
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239414AbiDZN6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233861AbiDZN6d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:58:33 -0400
Received: from mxout3.routing.net (mxout3.routing.net [IPv6:2a03:2900:1:a::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433A213D2B
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 06:55:23 -0700 (PDT)
Received: from mxbox3.masterlogin.de (unknown [192.168.10.78])
        by mxout3.routing.net (Postfix) with ESMTP id 9AB776046E;
        Tue, 26 Apr 2022 13:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailerdienst.de;
        s=20200217; t=1650980974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9T6dfbFLzZWVvyVq0SMrDb0x/bFX4493F6lZIKD4BEA=;
        b=OXU/sxWXuSmpwGApm8WL8UWVW0Ylkm4b6uGIlOgLznGJkjdEf7iZ6FSy73KLWP11Ped9KD
        A7QpM75eZfHPjBbszJU8auHURDDMg6eKmhH24qbOWDiJPXAUd3sum4P5y9WRk+MytqVlu0
        pYEm+l7TIpM6Sr4VVbC6BybBtFBrkm0=
Received: from localhost.localdomain (fttx-pool-80.245.77.37.bambit.de [80.245.77.37])
        by mxbox3.masterlogin.de (Postfix) with ESMTPSA id A01D936065C;
        Tue, 26 Apr 2022 13:49:33 +0000 (UTC)
From:   Frank Wunderlich <linux@fw-web.de>
To:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC v1 1/3] net: dsa: mt753x: make reset optional
Date:   Tue, 26 Apr 2022 15:49:22 +0200
Message-Id: <20220426134924.30372-2-linux@fw-web.de>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220426134924.30372-1-linux@fw-web.de>
References: <20220426134924.30372-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Mail-ID: 136ca4f9-f5c5-40e4-a2e3-6f99f2bf827a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frank Wunderlich <frank-w@public-files.de>

Currently a reset line is required, but on BPI-R2-Pro board
this reset is shared with the gmac and prevents the switch to
be initialized because mdio is not ready fast enough after
the reset.

So make the reset optional to allow shared reset lines.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
---
 drivers/net/dsa/mt7530.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
index 19f0035d4410..ccf4cb944167 100644
--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -2134,7 +2134,7 @@ mt7530_setup(struct dsa_switch *ds)
 		reset_control_assert(priv->rstc);
 		usleep_range(1000, 1100);
 		reset_control_deassert(priv->rstc);
-	} else {
+	} else if (priv->reset) {
 		gpiod_set_value_cansleep(priv->reset, 0);
 		usleep_range(1000, 1100);
 		gpiod_set_value_cansleep(priv->reset, 1);
@@ -2276,7 +2276,7 @@ mt7531_setup(struct dsa_switch *ds)
 		reset_control_assert(priv->rstc);
 		usleep_range(1000, 1100);
 		reset_control_deassert(priv->rstc);
-	} else {
+	} else if (priv->reset) {
 		gpiod_set_value_cansleep(priv->reset, 0);
 		usleep_range(1000, 1100);
 		gpiod_set_value_cansleep(priv->reset, 1);
@@ -3272,8 +3272,7 @@ mt7530_probe(struct mdio_device *mdiodev)
 		priv->reset = devm_gpiod_get_optional(&mdiodev->dev, "reset",
 						      GPIOD_OUT_LOW);
 		if (IS_ERR(priv->reset)) {
-			dev_err(&mdiodev->dev, "Couldn't get our reset line\n");
-			return PTR_ERR(priv->reset);
+			dev_warn(&mdiodev->dev, "Couldn't get our reset line\n");
 		}
 	}
 
-- 
2.25.1

