Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99424BDF3E
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356802AbiBULwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 06:52:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356822AbiBULwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 06:52:24 -0500
X-Greylist: delayed 318 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 21 Feb 2022 03:52:00 PST
Received: from mx.tkos.co.il (guitar.tcltek.co.il [84.110.109.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1884B2BCA
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 03:51:58 -0800 (PST)
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 270DC44054B;
        Mon, 21 Feb 2022 13:46:03 +0200 (IST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tkos.co.il;
        s=default; t=1645443963;
        bh=DXl6zSHyL6xzcZPueiyZyEWv1FJoMaN44o4k6mex8h0=;
        h=From:To:Cc:Subject:Date:From;
        b=ilQrx3EjNxDH1vHV31sB/ieVVIuDeR3/ChOC/E8F+efG8ZJirdX/h/Z7tIOWl+TIV
         7LbPQHX8G1BPpv9V5BJIROr9yYdkdSOifjLFLuZMRFMVJDwgr0lWzl5ZvpgKpQ96jv
         ZbfjsWF2R3Y2NZMgwSQ6XDJgtZCJTQ3290fDt4UbNMsAKozpW2W/XNMVXx0rUE9DBH
         /BYCRvzEFXBzCFVh8sWyyiUnJo8wXkvx1dkE036Xj4rVMMxruSNjhb5YPWBm0GIX0Q
         zoyqkolhDL3YIJENT9oKwm7XM6aRz0BMYEXalVX5PezmR10H+LQ98KdizQgnQN8dSL
         skxE87mwWon0w==
From:   Baruch Siach <baruch@tkos.co.il>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Baruch Siach <baruch.siach@siklu.com>,
        Robert Marko <robert.marko@sartura.hr>,
        Luo Jie <luoj@codeaurora.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] net: mdio-ipq4019: add delay after clock enable
Date:   Mon, 21 Feb 2022 13:45:57 +0200
Message-Id: <01c6b6afb00c02a48fa99542c5b4c6a2c69092b0.1645443957.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Baruch Siach <baruch.siach@siklu.com>

Experimentation shows that PHY detect might fail when the code attempts
MDIO bus read immediately after clock enable. Add delay to stabilize the
clock before bus access.

PHY detect failure started to show after commit 7590fc6f80ac ("net:
mdio: Demote probed message to debug print") that removed coincidental
delay between clock enable and bus access.

10ms is meant to match the time it take to send the probed message over
UART at 115200 bps. This might be a far overshoot.

Fixes: 23a890d493e3 ("net: mdio: Add the reset function for IPQ MDIO driver")
Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
---
 drivers/net/mdio/mdio-ipq4019.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/mdio-ipq4019.c b/drivers/net/mdio/mdio-ipq4019.c
index 5f4cd24a0241..4eba5a91075c 100644
--- a/drivers/net/mdio/mdio-ipq4019.c
+++ b/drivers/net/mdio/mdio-ipq4019.c
@@ -200,7 +200,11 @@ static int ipq_mdio_reset(struct mii_bus *bus)
 	if (ret)
 		return ret;
 
-	return clk_prepare_enable(priv->mdio_clk);
+	ret = clk_prepare_enable(priv->mdio_clk);
+	if (ret == 0)
+		mdelay(10);
+
+	return ret;
 }
 
 static int ipq4019_mdio_probe(struct platform_device *pdev)
-- 
2.34.1

