Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D1F526150
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379988AbiEMLqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378423AbiEMLq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:46:29 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93598275E0
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:46:23 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id w130so9874615oig.0
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l8ACeZsVDDPCahRKVeDrr11bf5fhg05CS/FIvEPfNmw=;
        b=ZM/quJ2eyPfnV4ct5dd6Bd3NNNgBIa8nMSqmH8hRQzvK2VkEqjCHMMp8hfPoYXD6OA
         GlKP8S2+5HMiFVt6A1exyo92QddRvGWb0IiOnWFvmL1FTjlZsGbolSkRYNfrJipv4kax
         BdqJKQp+5WjIxPqkJ8/hMM0PeFEnEc9/TMmRNC/iaiBOhSfUpqgwdlAjq4TywJNKgH6J
         wPArRcnmH9OcPCUPpS05AWEd10mBfUoDzdEYPYKaNn1ymsTfUYDeTzv78frnbhVXwZRb
         8GCKo5+2QodfL0G+/Gk+u+EtxCCeZrFVcm+duyGKVgcPnadReP42nXpBdKEwuBl5c3BF
         cK8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l8ACeZsVDDPCahRKVeDrr11bf5fhg05CS/FIvEPfNmw=;
        b=qPrMyGLvIv75aRc9+LxJEy8ieeDguBf9IOJpASnGGwb+rEwW43puuI1TDl89ItyxGT
         cqYdxpjcxrk8C/uYe+BNi+HrPSBDNwu2LVYcBVsHVBG+HxsHToK0VHhxe7dCPJmrc/M7
         TqZkNJ0YTAIy1GVky9B710hJvcq43mLX9YqevwFVqbzCxf8/L9Se0Xw0j8Dp8UF7Ie7k
         iWbmRMpAzKb0KqLaHp3sP+sUB9ecVIOGNwJn6LEpGKQSk6oMxjU64STDeo/ldOMA9m18
         wpBWT1jymRfHk+aDf7y3//6sA8pnioXnaaP1g1BjtlsSG2K7ap7+Z31A8oQyBEjcg0wC
         hdeQ==
X-Gm-Message-State: AOAM532FMADu/kffIB1+fbiPwOQUC628iuBOHicaCXNb6yrvKc79j8pt
        F1npdzb8UxTfoqeFxaNi4bhgDbJON6vmtQ==
X-Google-Smtp-Source: ABdhPJwvmy1teuvWeq0uD161HKh9MC6mhFnpCLNxttZLGHk4wssNogBnmgx9EzS5eJacmdvEHdso3A==
X-Received: by 2002:a54:4386:0:b0:325:91ed:9b18 with SMTP id u6-20020a544386000000b0032591ed9b18mr2093152oiv.286.1652442382654;
        Fri, 13 May 2022 04:46:22 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:7c3a:c7b:fd8a:c501])
        by smtp.gmail.com with ESMTPSA id b18-20020a9d6b92000000b00606b1f72fcbsm872458otq.31.2022.05.13.04.46.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 04:46:22 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, netdev@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH net-next 1/2] net: phy: micrel: Allow probing without .driver_data
Date:   Fri, 13 May 2022 08:46:12 -0300
Message-Id: <20220513114613.762810-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

Currently, if the .probe element is present in the phy_driver structure
and the .driver_data is not, a NULL pointer dereference happens.

Allow passing .probe without .driver_data by inserting NULL checks
for priv->type.

Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 drivers/net/phy/micrel.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index c34a93403d1e..5e356e23c1b7 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -520,7 +520,7 @@ static int kszphy_config_reset(struct phy_device *phydev)
 		}
 	}
 
-	if (priv->led_mode >= 0)
+	if (priv->type && priv->led_mode >= 0)
 		kszphy_setup_led(phydev, priv->type->led_mode_reg, priv->led_mode);
 
 	return 0;
@@ -536,10 +536,10 @@ static int kszphy_config_init(struct phy_device *phydev)
 
 	type = priv->type;
 
-	if (type->has_broadcast_disable)
+	if (type && type->has_broadcast_disable)
 		kszphy_broadcast_disable(phydev);
 
-	if (type->has_nand_tree_disable)
+	if (type && type->has_nand_tree_disable)
 		kszphy_nand_tree_disable(phydev);
 
 	return kszphy_config_reset(phydev);
@@ -1730,7 +1730,7 @@ static int kszphy_probe(struct phy_device *phydev)
 
 	priv->type = type;
 
-	if (type->led_mode_reg) {
+	if (type && type->led_mode_reg) {
 		ret = of_property_read_u32(np, "micrel,led-mode",
 				&priv->led_mode);
 		if (ret)
@@ -1751,7 +1751,8 @@ static int kszphy_probe(struct phy_device *phydev)
 		unsigned long rate = clk_get_rate(clk);
 		bool rmii_ref_clk_sel_25_mhz;
 
-		priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
+		if (type)
+			priv->rmii_ref_clk_sel = type->has_rmii_ref_clk_sel;
 		rmii_ref_clk_sel_25_mhz = of_property_read_bool(np,
 				"micrel,rmii-reference-clock-select-25-mhz");
 
-- 
2.25.1

