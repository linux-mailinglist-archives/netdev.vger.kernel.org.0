Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952BB390101
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232718AbhEYMaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232666AbhEYM37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:29:59 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADE36C06138A;
        Tue, 25 May 2021 05:28:28 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id m13so22903432qtk.13;
        Tue, 25 May 2021 05:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d0mlU653ZHAi1z8Z/h8nQvEb7mYuTzzrw09E6KPEru8=;
        b=fyiArXP91VEL8ckjAkRhHSYHjjGY6C0gPNcuombTNK9ml7ULwy++4eUIFqUGUsxA+w
         6ZHZk08DOFKd/t6YTd0/bGafXHiU1FX0QTzA5q2ndfDvjR8iUvAdI8reRVfqbr0H1+9t
         P1ydpSC4dmpcGrvdMofV9zuIqkV0CMtWWy8zU9lo6dQVtGeEHuy+nfdr61fQkaRMyBrJ
         MJ0sa599vZ+95biDh3PK9Z3rFu0nER6zGR1DCtyhoJuMak2616XI/6MX0CshrqNL73UJ
         lZ28BUVDbSjOsQbf7Lk9azR/rsPH1hGmJi37fzYUzUveINS9HLuurwqUMVt7CPurLJM9
         0DzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d0mlU653ZHAi1z8Z/h8nQvEb7mYuTzzrw09E6KPEru8=;
        b=OZGVfRDLWxKOZsUoVZr+cgJDrKeA55RT1rSg8BFzYy3RpgLGUFC+tIcyzxHdyhA/0x
         TFv8/To1RJFWw0JOeeB1xSGb3Gt5gz7p5mDkiBS7aPTIs3pcaJeoK4JyJmVcQ4ECAtC6
         5oK+yW4Z9PRiHg2l7qDQBZMwmLCOBRbf5aZ2aeJrMJ2ocRJCw/ag7K9p6ecQw7Ek1ttX
         ZOVKROy88hA8tKakyuiWGzEIGLsoBfQfaEJgVo5gC5jdLzGZBylxbQwri3jwP4sErSdp
         0qRYKC9c6UkaDmvWgGmkYdsUjEozVPX+uXTO5XnVa5zer4Iac0nDW0g7TDRRNpkjBQtN
         ysrA==
X-Gm-Message-State: AOAM532iWRNLnCD6f53ybvOWjyk7RqWSZFty6E5th3aXWRZkkqLC+BRU
        kDaZvu+88k5h9stlxE4N4PY=
X-Google-Smtp-Source: ABdhPJyxlIyl+45knbJvhcZRWn56oB8CpilV0x5SeAF0UzKsqwHEimxjda46mb9z+TE3eP0YMu/QfA==
X-Received: by 2002:ac8:604:: with SMTP id d4mr30870306qth.304.1621945707833;
        Tue, 25 May 2021 05:28:27 -0700 (PDT)
Received: from master-laptop.sparksnet ([2601:153:980:85b1:a465:c799:7794:b233])
        by smtp.gmail.com with ESMTPSA id t6sm13292572qkh.117.2021.05.25.05.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 05:28:27 -0700 (PDT)
From:   Peter Geis <pgwipeout@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Peter Geis <pgwipeout@gmail.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 2/2] net: phy: abort loading yt8511 driver in unsupported modes
Date:   Tue, 25 May 2021 08:26:15 -0400
Message-Id: <20210525122615.3972574-3-pgwipeout@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210525122615.3972574-1-pgwipeout@gmail.com>
References: <20210525122615.3972574-1-pgwipeout@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While investigating the clang `ge` uninitialized variable report, it was
discovered the default switch would have unintended consequences. Due to
the switch to __phy_modify, the driver would modify the ID values in the
default scenario.

Fix this by promoting the interface mode switch and aborting when the
mode is not a supported RGMII mode.

This prevents the `ge` and `fe` variables from ever being used
uninitialized.

Fixes: b1b41c047f73 ("net: phy: add driver for Motorcomm yt8511 phy")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Geis <pgwipeout@gmail.com>
---
 drivers/net/phy/motorcomm.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 5795f446c528..53178e978da7 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -53,15 +53,10 @@ static int yt8511_config_init(struct phy_device *phydev)
 	unsigned int ge, fe;
 	int oldpage, ret = 0;
 
-	/* set clock mode to 125mhz */
 	oldpage = phy_select_page(phydev, YT8511_EXT_CLK_GATE);
 	if (oldpage < 0)
 		goto err_restore_page;
 
-	ret = __phy_modify(phydev, YT8511_PAGE, 0, YT8511_CLK_125M);
-	if (ret < 0)
-		goto err_restore_page;
-
 	/* set rgmii delay mode */
 	switch (phydev->interface) {
 	case PHY_INTERFACE_MODE_RGMII:
@@ -80,14 +75,20 @@ static int yt8511_config_init(struct phy_device *phydev)
 		ge = YT8511_DELAY_RX | YT8511_DELAY_GE_TX_EN;
 		fe = YT8511_DELAY_FE_TX_EN;
 		break;
-	default: /* leave everything alone in other modes */
-		break;
+	default: /* do not support other modes */
+		ret = -EOPNOTSUPP;
+		goto err_restore_page;
 	}
 
 	ret = __phy_modify(phydev, YT8511_PAGE, (YT8511_DELAY_RX | YT8511_DELAY_GE_TX_EN), ge);
 	if (ret < 0)
 		goto err_restore_page;
 
+	/* set clock mode to 125mhz */
+	ret = __phy_modify(phydev, YT8511_PAGE, 0, YT8511_CLK_125M);
+	if (ret < 0)
+		goto err_restore_page;
+
 	/* fast ethernet delay is in a separate page */
 	ret = __phy_write(phydev, YT8511_PAGE_SELECT, YT8511_EXT_DELAY_DRIVE);
 	if (ret < 0)
-- 
2.25.1

