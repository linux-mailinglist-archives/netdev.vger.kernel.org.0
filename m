Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF25A587475
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235099AbiHAXeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiHAXeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:34:09 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FB82124D;
        Mon,  1 Aug 2022 16:34:08 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 130so4187775pfv.13;
        Mon, 01 Aug 2022 16:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=c/yw066D04uIPMCeJE5oF6oln9znD0/tYczOQYYzKWc=;
        b=i7gMnJCPPVZYoaf0i4Ml+8ciwbBjlk14dE10fFH2d35vjCOhUPOYXRjDmMuUE+boun
         6V5bUaSf328sC+i41S9hfpyDP8QSdIeiql7tDCRh81vzp0JC3FmPU3NqTPbVnbNlWW+a
         FuhFAJyZP/nbievJDNyUBN26t7VTyEyje932UC/3LzL38lx5VPe7abIPmBbggvxiVPMp
         1I1lRjz9Fn2I4Ovyvu4UgviLWMOPdxiWp5n7EE33/P32qJiGGR7xM97cM6RLmwe6Njz6
         I1XbA/0mc4B0xC12XP/AFOh8PeybnhosSIgjoZFSIyA4xe2s04kaWo6FD0ncuvvQ+v2n
         0JJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=c/yw066D04uIPMCeJE5oF6oln9znD0/tYczOQYYzKWc=;
        b=NEpnOLn4z3KzTp5ah/TPrXxxKkxX+23feXt6y70Lr+NRJUIC+n4vrrxd+DbVIAs5rV
         WVSzgZNQ9LRrX5ujZRUOd5o4AWxAAWdbcASDZqPE5PyjH3xXB5FXhSHY+tJiX65LAKhe
         pXWbcJaL4ZIJ77B5NbnHFfW5JwFphgNflVUCZU/VGBkmdsdd9Fuv8ZzCPL89g/zTBMcB
         LYQ3EOIGygpRAvuZwcrHY8lvfxFBvfgiq/9Thru3CxahUtTKvm9taM3o+z6T2vi3bC2Z
         /12/b87b4t4T1pmYuF5xAljAMkNF6/gPZb0HRmvoynpqoQo5Jwm5sxibXWUIuSUS47lq
         GHUw==
X-Gm-Message-State: ACgBeo1JAhsk/UgtR4cSalq8/BkA4uifRvShPKq7Uuj/ysCKw0u9WMs3
        iJIMRtu86o5xsB2NR12RDyXe2cJ9mgQ=
X-Google-Smtp-Source: AA6agR6/S67eYKG5TQtWC/TvZFWTcDalMwQ647iIUKbzhDvNzBkTy+VJ7MEOUpIBf1+GP86hHuknCg==
X-Received: by 2002:a62:1d86:0:b0:52d:9df0:2151 with SMTP id d128-20020a621d86000000b0052d9df02151mr4436655pfd.33.1659396847470;
        Mon, 01 Aug 2022 16:34:07 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902ecc400b0016d6963cb12sm10305468plh.304.2022.08.01.16.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 16:34:06 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     opendmb@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] net: phy: Warn about incorrect mdio_bus_phy_resume() state
Date:   Mon,  1 Aug 2022 16:34:03 -0700
Message-Id: <20220801233403.258871-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling mdio_bus_phy_resume() with neither the PHY state machine set to
PHY_HALTED nor phydev->mac_managed_pm set to true is a good indication
that we can produce a race condition looking like this:

CPU0						CPU1
bcmgenet_resume
 -> phy_resume
   -> phy_init_hw
 -> phy_start
   -> phy_resume
                                                phy_start_aneg()
mdio_bus_phy_resume
 -> phy_resume
    -> phy_write(..., BMCR_RESET)
     -> usleep()                                  -> phy_read()

with the phy_resume() function triggering a PHY behavior that might have
to be worked around with (see bf8bfc4336f7 ("net: phy: broadcom: Fix
brcm_fet_config_init()") for instance) that ultimately leads to an error
reading from the PHY.

Fixes: fba863b81604 ("net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy_device.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 46acddd865a7..608de5a94165 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -316,6 +316,12 @@ static __maybe_unused int mdio_bus_phy_resume(struct device *dev)
 
 	phydev->suspended_by_mdio_bus = 0;
 
+	/* If we managed to get here with the PHY state machine in a state other
+	 * than PHY_HALTED this is an indication that something went wrong and
+	 * we should most likely be using MAC managed PM and we are not.
+	 */
+	WARN_ON(phydev->state != PHY_HALTED && !phydev->mac_managed_pm);
+
 	ret = phy_init_hw(phydev);
 	if (ret < 0)
 		return ret;
-- 
2.25.1

