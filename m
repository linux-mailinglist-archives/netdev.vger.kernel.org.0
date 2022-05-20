Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD9052F66E
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 01:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354153AbiETX6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 19:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351624AbiETX6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 19:58:53 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF99B1A0AE2
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 16:58:51 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id bg25so5279496wmb.4
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 16:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CZudmt8QjK7Ob0wwst9Iisd3ub5uSgdUrqhdvCAPlJY=;
        b=n8YxOwsVsDs+d/Xov7EF5yekr3+BjzL7dG3FuFiONfF/sfoECLWTB3fLCdqaQTT5Bc
         KCx4DZrjRGSNXTM14Rem+/1taT7VIFFAclXaS9I/+TrXfOlxiQJBpxtkVZF2h6HyfFkR
         G0vtzP5zKGwENv+H7JPdHm4S6+BLi+JIfWofs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CZudmt8QjK7Ob0wwst9Iisd3ub5uSgdUrqhdvCAPlJY=;
        b=zPDG2Aud2sd4RWRH5MNQUD7uQ780QqnRZzi5U2S8dENUQnGmw3yNmietgocytdkwCb
         MhEE66zUK++p0Z9l58RupFbZU5DP5mcCjQCjItAxO81G6wXPfpl9uQnxE3XTCo5tEqoP
         SrtuiyUWUXnBHmFKb8uWKektaqJEIiTNTzyAMZHYjRkuBiwGdj9LGZTWt+3zzpN5pKmp
         B2XsQWnj0ab58tDlUfAIWLL7HZokTWjFmYlh+3eorESdEjf16wpANHh2anGhtEcO7d+a
         HXDDIirLd3JBDebZ0V4rJZqGkpGHXkxrdJavGXYF9YXcu1+6YZxsntlbDnLbFv8VPmXu
         9hpQ==
X-Gm-Message-State: AOAM531GwNErLAP1MJUseX7ah1TRH8fw8YxZmkNp1tDeZdthRe3V38oy
        nw6jciTz1RZ14KqOmiBdSoDlSQ==
X-Google-Smtp-Source: ABdhPJyDdA9UiEi//2k2WCzJgQm8Dc/PW76V4KuUHKDVaRIJJzXRJoXMEnvbcpjfiuMh8OSv8ZtKIA==
X-Received: by 2002:a05:600c:3c8b:b0:397:2db3:97a8 with SMTP id bg11-20020a05600c3c8b00b003972db397a8mr9203193wmb.132.1653091130092;
        Fri, 20 May 2022 16:58:50 -0700 (PDT)
Received: from tom-ThinkPad-T14s-Gen-2i.station (net-188-217-53-154.cust.vodafonedsl.it. [188.217.53.154])
        by smtp.gmail.com with ESMTPSA id l41-20020a05600c1d2900b003973343c014sm3216306wms.33.2022.05.20.16.58.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 16:58:49 -0700 (PDT)
From:   Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Cc:     tommaso.merciai@amarulasolutions.com, michael@amarulasolutions.com,
        alberto.bianchi@amarulasolutions.com,
        linux-amarula@amarulasolutions.com, linuxfancy@googlegroups.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] net: phy: DP83822: enable rgmii mode if phy_interface_is_rgmii
Date:   Sat, 21 May 2022 01:58:46 +0200
Message-Id: <20220520235846.1919954-1-tommaso.merciai@amarulasolutions.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGMII mode can be enable from dp83822 straps, and also writing bit 9
of register 0x17 - RMII and Status Register (RCSR).
When phy_interface_is_rgmii rgmii mode must be enabled, same for
contrary, this prevents malconfigurations of hw straps

References:
 - https://www.ti.com/lit/gpn/dp83822i p66

Signed-off-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Suggested-by: Alberto Bianchi <alberto.bianchi@amarulasolutions.com>
Tested-by: Tommaso Merciai <tommaso.merciai@amarulasolutions.com>
---
Changes since v2:
 - Fix comment of register name RSCR -> RCSR
 - Fix define DP83822_RGMII_MODE_EN location

Changes since v1:
 - Improve commit msg
 - Add definition of bit 9 reg rcsr (rgmii mode en)
 - Handle case: phy_interface_is_rgmii is false

 drivers/net/phy/dp83822.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index ce17b2af3218..e6ad3a494d32 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -94,7 +94,8 @@
 #define DP83822_WOL_INDICATION_SEL BIT(8)
 #define DP83822_WOL_CLR_INDICATION BIT(11)
 
-/* RSCR bits */
+/* RCSR bits */
+#define DP83822_RGMII_MODE_EN	BIT(9)
 #define DP83822_RX_CLK_SHIFT	BIT(12)
 #define DP83822_TX_CLK_SHIFT	BIT(11)
 
@@ -408,6 +409,12 @@ static int dp83822_config_init(struct phy_device *phydev)
 			if (err)
 				return err;
 		}
+
+		phy_set_bits_mmd(phydev, DP83822_DEVADDR,
+					MII_DP83822_RCSR, DP83822_RGMII_MODE_EN);
+	} else {
+		phy_clear_bits_mmd(phydev, DP83822_DEVADDR,
+					MII_DP83822_RCSR, DP83822_RGMII_MODE_EN);
 	}
 
 	if (dp83822->fx_enabled) {
-- 
2.25.1

