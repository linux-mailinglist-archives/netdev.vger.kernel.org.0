Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA464DAC2B
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347506AbiCPIDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354423AbiCPIDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:03:01 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA46F5C354
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:01:47 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mr24-20020a17090b239800b001bf0a375440so4320395pjb.4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNHB/LDPEbEU9+GMAzA5A9sNL4Voiov9LtGyFzCxSsg=;
        b=EEon7ntvpe0JkNJl/A7Cnv856N6fexj7EAAddr3+p3ThKkG+bZZegZzAsjcuHZ2vR1
         EETtdue6b7824j06f6/mBm+jwFbPHaW57Kgxo3NXSk2nN44Bxob/Jau+PYbOsD6VKH/H
         xVnvAwx1NAnv8faQ3woXIgQczQYpf/qet43IwZ1jFNglGoAx+I/xAtqeVHpbS9uZOKqH
         oMWBQo7HzJfyB28sbqMf+9nCLlfa4Rs92RK/sFnURYEPi2HNpvKBCJH20EZn3gv8nqKv
         l1sk68liDBx4/0+GuPhDRX6It9zoAmtTtiLysFhMWrA9vy+5KtxKa8YQIH92A28jnjBl
         ivVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WNHB/LDPEbEU9+GMAzA5A9sNL4Voiov9LtGyFzCxSsg=;
        b=N+AQ8/BBzAWFYLGv9u8jejTu4suETso+cgLYTHQZzCGGxoE1JPTAkP4d6IUs2OuSTC
         dwDjxwv0kMdKgF7NfrCy4TQKAyGW+ESJe84tH0wvEc74dHPTRlVaw1PKBCNiEhB5SCS7
         L8gJkgY/VfraafG9cVD/XeAB/GoiTOEo72wUZ7ly504F1XDR7W6EECUogC86qsO+nUPy
         rviVx23h8yFPTXiYXbTZr23ttvAFuMBj5KcaMkbkfMQXAr36EWzqc29ejYe01jdvLB2R
         yZRc6GT6cB/gCJrWXcxmytByrYIcp8UdVuFHtstKJ+QO2VZ6LzlJK81LsyuMg9j41jGM
         IkwQ==
X-Gm-Message-State: AOAM5308EX/CaP1jpzV6+++fGIIj73APMD0PcH/pMDAY+VSu3q+GCpFC
        Tu+GNTOo7BOmtY/sZn2CiQAx2w==
X-Google-Smtp-Source: ABdhPJzL9pIaw3K+dOJEpO/iBxD3lRbIC/0gBTSRsn4F3uH5bJZ7NHBLK4RjJ29DaXtwyYIpHlayTw==
X-Received: by 2002:a17:90b:4b06:b0:1bf:8e05:84a9 with SMTP id lx6-20020a17090b4b0600b001bf8e0584a9mr8753993pjb.27.1647417707258;
        Wed, 16 Mar 2022 01:01:47 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id e6-20020a63aa06000000b00380c8bed5a6sm1731865pgf.46.2022.03.16.01.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 01:01:46 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        linux@armlinux.org.uk, robert.hancock@calian.co, andrew@lunn.ch,
        netdev@vger.kernel.org
Cc:     Andy Chiu <andy.chiu@sifive.com>,
        Greentime Hu <greentime.hu@sifive.com>
Subject: [PATCH] net: axiemac: use a phandle to reference pcs_phy
Date:   Wed, 16 Mar 2022 15:59:53 +0800
Message-Id: <20220316075953.61398-1-andy.chiu@sifive.com>
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

The `of_mdio_find_device()` would get a reference to `mdio_device` by
a given device tree node. Thus, getting a reference to the internal
PCS/PMA PHY by `lp->phy_node` is incorrect since "phy-handle" in the DT
sould point to the external PHY. This incorrect use of "phy-hanlde"
would cause a problem when the driver called `phylink_of_phy_connect()`,
where it would use "phy-handle" in the DT to connect the external PHY.
To fix it, we could add a phandle, "pcs-phy", in the DT so that it would
point to the internal PHY. And the driver would get the correct address
of PCS/PHY.

Fixes: 1a02556086fc (net: axienet: Properly handle PCS/PMA PHY for 1000BaseX mode)
Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 6fd5157f0a6d..293189aab4e6 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -2073,12 +2073,15 @@ static int axienet_probe(struct platform_device *pdev)
 	}
 	if (lp->phy_mode == PHY_INTERFACE_MODE_SGMII ||
 	    lp->phy_mode == PHY_INTERFACE_MODE_1000BASEX) {
-		if (!lp->phy_node) {
-			dev_err(&pdev->dev, "phy-handle required for 1000BaseX/SGMII\n");
+		np = of_parse_phandle(pdev->dev.of_node, "pcs-phy", 0);
+		if (!lp->phy_node || !np) {
+			dev_err(&pdev->dev, "phy-handle and pcs-phy are required for 1000BaseX/SGMII\n");
+			of_node_put(np);
 			ret = -EINVAL;
 			goto cleanup_mdio;
 		}
-		lp->pcs_phy = of_mdio_find_device(lp->phy_node);
+		lp->pcs_phy = of_mdio_find_device(np);
+		of_node_put(np);
 		if (!lp->pcs_phy) {
 			ret = -EPROBE_DEFER;
 			goto cleanup_mdio;
-- 
2.34.1

