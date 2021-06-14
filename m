Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78403A6662
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhFNMVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 08:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbhFNMVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 08:21:14 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89438C061766
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:19:11 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id s6so46190957edu.10
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jy+Z0i/vBPb9oX2mtg1eXhWrQ/0sEDVU1KgykJJ2lGM=;
        b=dB8zKfwgx3KMHJ9H+4m7ANykFBZHUb8z2JMRLnWj9Lcn0uTzrK8olNnrEI0s1Ifo7A
         E6DNrEMIXQ32L7iwBlSv1LrIQvuhxNls66zA2NE8znxYU/r4X17cbzqY/XK+lUX00X4e
         xqa0hWo3GQmz5cXOBPRIercZJlntKSuCv91Lao7aL+jHogIIMiiw5f46jjhqSEFTcJyK
         /gyd/SX+Rtw4FVc8j3p9aUG9Kg44K0fKmJ0kesoYzFg4c99Iv0aZ3NOTwGfJ4/1xaPW1
         osngmsDv/fBO9GLp5Jt5TTMyLmhNLBm3NTHe2ddSSeAYcZIgL6RhhlF32eAJ4owgQDoG
         CKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jy+Z0i/vBPb9oX2mtg1eXhWrQ/0sEDVU1KgykJJ2lGM=;
        b=feduJUmEq9GDz0vFtRcy0qxT5AdMN6BD3T+mWGWMx293MR2x0dKXP8wqIvzRPDJHRh
         ArwEzGy5rUYVJ/3hXYleTj4BMhLBKxCdJYDOIarQn/LaF8tJitWNS6/MH4zo70yRAx65
         OmLiqOyh3vJkMrjS+npFHQyl8JeUARnJFgfnQ7pb/LmgXHSDxE8j1KPFhpao2aw64eHM
         pTHt4VXoIvcNzF2mfbOdzRBbw03jL74QNgtezyefY3QrqyEYnLgLntd4JAS/gsuWXQVP
         e+knfQawiEu1mAbXf/Za4voqJIxJhjU3mvgWZC641+lL3atX1EltkwBhECE3PqHM96wn
         1KbQ==
X-Gm-Message-State: AOAM532n/NJAtZc/Wv4lxWljPI+Xr+xgClAqJrRadWdbTItoXraz1rdZ
        d1wiCQ9yrwftsSr+6qZBIKc=
X-Google-Smtp-Source: ABdhPJxf21Lknp5dKM71TkkWvph0L0l/b48vgn+y+L6ZlKAZ2LtJU1emuMg6dfVS+97WCVtw6t/RTg==
X-Received: by 2002:a05:6402:1d0c:: with SMTP id dg12mr16569800edb.155.1623673150113;
        Mon, 14 Jun 2021 05:19:10 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id c18sm8722495edt.97.2021.06.14.05.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 05:19:09 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 3/3] net: phy: nxp-c45-tja11xx: enable MDIO write access to the master/slave registers
Date:   Mon, 14 Jun 2021 15:18:49 +0300
Message-Id: <20210614121849.437119-4-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210614121849.437119-1-olteanv@gmail.com>
References: <20210614121849.437119-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The SJA1110 switch integrates TJA1103 PHYs, but in SJA1110 switch rev B
silicon, there is a bug in that the registers for selecting the 100base-T1
autoneg master/slave roles are not writable.

To enable write access to the master/slave registers, these additional
PHY writes are necessary during initialization.

The issue has been corrected in later SJA1110 silicon versions and is
not present in the standalone PHY variants, but applying the workaround
unconditionally in the driver should not do any harm.

Suggested-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/nxp-c45-tja11xx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
index 118b393b1cbb..b4dc112d4881 100644
--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1035,6 +1035,9 @@ static int nxp_c45_config_init(struct phy_device *phydev)
 		return ret;
 	}
 
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F8, 1);
+	phy_write_mmd(phydev, MDIO_MMD_VEND1, 0x01F9, 2);
+
 	phy_set_bits_mmd(phydev, MDIO_MMD_VEND1, VEND1_PHY_CONFIG,
 			 PHY_CONFIG_AUTO);
 
-- 
2.25.1

