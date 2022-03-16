Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6445E4DAC24
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 08:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354378AbiCPIAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244787AbiCPIA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:00:29 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB895C354
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 00:59:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gb19so1517527pjb.1
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 00:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vt/4tSjL+xrmlkWGsgt4zXDm0u2OOt+RrGGQss4pnVA=;
        b=W3BuIrUaEfCTSURj7mVVWShjggJRnFTyliA/Joh4RgREAq2Z5hztXjmnXtx37NVSC/
         rCiAM8A/hxaF06wGiRGPV2RuNtJiikoqSsBvioFl9J91CGmKNrhlSOxY1ga7InQv3dTh
         gDf9QgiBA18oH/KI9YKy89ujZkTeOm3Avxop2LxrblhZgyoL4MSu977AXmC7WmppAg3f
         bDxHC9g51h2CikbmPHFKkEQquOyNRAX2VHhK0YhiOx0gu/D6G4hi62Gj7HCSigHXhzSw
         /KI58Q05xDloOmMIkGjyzHQ8BKKETWd1qswV3HtNTj8fJ9rYcdNXs8GUcJDz7+6HP7Sp
         q75A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vt/4tSjL+xrmlkWGsgt4zXDm0u2OOt+RrGGQss4pnVA=;
        b=tOrLzOUSM9tn+tzrEHPgPW4SN8nHtmHpCUfJInE8Taz55CNmxPubINzLjjA8BQqo27
         q9Wu1Kun8reO3yS6XNZlaozHOlGBZtoxXrI0E8CAkKNSRHGZNNXsLP97NAYjvKWnbwaB
         nsLld4jlGP5FGNozWv97GFaef5vHiQr2uEjk/p+TBNJtfZvDUGznXy8RFV4JaoGB7cj1
         UvaQGphKn+MJYZ0HBy2OU+LtO4Iidr+re1d0UBXurR23Ruzjyp4Q7xjxiJNDalRWt1/n
         aF5xe9cPYpryhBHbdGeif5AX47H5qDPalLh70k+QNP/4qcCnw8Pj3H0DKaGwT3DimRU9
         ym8A==
X-Gm-Message-State: AOAM533OGCMezK3dnDENchOayNt4Gn6/q9iOmP5112PIpq7mn8gDpnKI
        vHr5W53+HOESw2mqBZXujPLLgw==
X-Google-Smtp-Source: ABdhPJzU998sw/aDQLXkT4JuBPCyd5/6CmhhWcMi0ZXS0Po5YnBSIBP/4a5K6xjoGlrkmXJ2YZlk7Q==
X-Received: by 2002:a17:902:d511:b0:151:fa36:f1a1 with SMTP id b17-20020a170902d51100b00151fa36f1a1mr31805315plg.17.1647417554353;
        Wed, 16 Mar 2022 00:59:14 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id e10-20020a056a00162a00b004f6fc39c081sm1612275pfc.211.2022.03.16.00.59.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 00:59:14 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        linux@armlinux.org.uk, robert.hancock@calian.co,
        netdev@vger.kernel.org
Cc:     Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH] net: axiemac: initialize PHY before device reset
Date:   Wed, 16 Mar 2022 15:57:07 +0800
Message-Id: <20220316075707.61321-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On some platforms, the clock of internal (Xilinx's PCS/PMA) PHY was
sourced externally and was not enabled by the time the FPGA logic was
loaded. Specifically, the clock was souced from an external PHY's
SGMII ref clock, which would not start until the driver configured it
, on vcu118. Under such condition, the core would boot up in a state
where the PCS PHY could not be found on the bus. Or, even if the PCS PHY
could be found, the link would be broken and A/N would not complete. To
fix this, the Ethernet should be reset every time after the clock being
restarted at phylink_of_phy_connect().

Since phylink_of_phy_connect() configures the external PHY
base on DT only, it is safe to move it prior to the device reset.

Related-to: 'd836ed73a3cb ("net: axienet: reset core on initialization prior to MDIO access")'
Fixes: '1a02556086fc ("net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode")'
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index c7eb05e4a6bf..6fd5157f0a6d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1141,6 +1141,12 @@ static int axienet_open(struct net_device *ndev)
 
 	dev_dbg(&ndev->dev, "axienet_open()\n");
 
+	ret = phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
+	if (ret) {
+		dev_err(lp->dev, "phylink_of_phy_connect() failed: %d\n", ret);
+		return ret;
+	}
+
 	/* When we do an Axi Ethernet reset, it resets the complete core
 	 * including the MDIO. MDIO must be disabled before resetting.
 	 * Hold MDIO bus lock to avoid MDIO accesses during the reset.
@@ -1149,12 +1155,6 @@ static int axienet_open(struct net_device *ndev)
 	ret = axienet_device_reset(ndev);
 	axienet_unlock_mii(lp);
 
-	ret = phylink_of_phy_connect(lp->phylink, lp->dev->of_node, 0);
-	if (ret) {
-		dev_err(lp->dev, "phylink_of_phy_connect() failed: %d\n", ret);
-		return ret;
-	}
-
 	phylink_start(lp->phylink);
 
 	/* Enable worker thread for Axi DMA error handling */
-- 
2.34.1

