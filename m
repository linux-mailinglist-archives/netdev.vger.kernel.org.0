Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1F35A0F75
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239769AbiHYLl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240925AbiHYLkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:40:36 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3800C3E741
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:40:34 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id az27so4232409wrb.6
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=qu2XNRECKOf4oI4gEEvHtOdmxMGBMg0tx6LLPNxjxQA=;
        b=Xsa88s2u2gFun85HsgR4GxoQaRhV7rNW4LwDXFpY5xhuTH+k5XsIF1u2CwtDXS2Ghr
         /hCH4hga9ZY69qE5qTDsA/0/BDmXRACqAtf/v7SC5NgsprAuvRy2/OlArMVpiQZ8mVtW
         cSfmANKjr8OEdWEiA4jiXJB7Pdc4/AyGf4e10b1qkOx0zvjEvWDeWskPMgkTWYUfq7gR
         3hBiFzRVLjad3SHCrZd6pbXYrvT0UaQwIveYtswJvCQbToWl3/Ra6+Kg0LpymrI2sTLN
         XK5A36n+Sn2ZOAtbPOy+QpIYcrA+sjgrVUsQEjCM4YoiB+UY+6KTbLwQ2pChJzBv5SXO
         /1vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=qu2XNRECKOf4oI4gEEvHtOdmxMGBMg0tx6LLPNxjxQA=;
        b=kw+eACINqusBoOs7CDv20irYlWZiXb5iZxAhTDGDaBaGNKA/dwg7HmJ7pw3nd1K6bf
         xKKtZSIBoFgthC3mzLQiu/ZF8v/Wkis77SvQy1031KbGybxQVm/TU2HPZZU/cyU2jDqP
         A2jK0cEAlmFvwhlnlAe6wk08sAgv6f9GN+OMpxFEI76bOwdojABIcw8D3Mf/A11c0OFB
         NYViHMfRVhg9w07SA1fQaJaEaA5f+onu4ei4lPDkeQsePt+05T+Fwek7XYtrKnSAloj5
         iuUWcruet++1gZ+i9Jc0dVIOok5FWBWcRiGXUVofYDns50EHD/hw8sC6Voiu2HjW7LKw
         N1Og==
X-Gm-Message-State: ACgBeo2VGc/UYghrWu7rnI0OioDUPj+Lu/nXACbZgORAgfI9yV9M4iHr
        +oRqqq8y+Qx3Myk03mDZS6Ft1cuDz1rsSWxw
X-Google-Smtp-Source: AA6agR4t0oa9UD2UtRXVNdalnTxt4wagQDY5Nr4IbsE6DpnPLIhegQLSOGVFcBeIkLVajtS1TWNSew==
X-Received: by 2002:a05:6000:1888:b0:222:ca41:dc26 with SMTP id a8-20020a056000188800b00222ca41dc26mr1924650wri.442.1661427632710;
        Thu, 25 Aug 2022 04:40:32 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w1-20020a05600018c100b00225250f2d1bsm19477615wrq.94.2022.08.25.04.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 04:40:32 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com
Subject: [patch net-next] mlx4: Do type_clear() for devlink ports when type_set() was called previously
Date:   Thu, 25 Aug 2022 13:40:31 +0200
Message-Id: <20220825114031.1361478-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Whenever the type_set() is called on a devlink port, accompany it by
matching type_clear() during cleanup.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 78c5f40382c9..d3fc86cd3c1d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3071,6 +3071,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 	err = device_create_file(&dev->persist->pdev->dev, &info->port_attr);
 	if (err) {
 		mlx4_err(dev, "Failed to create file for port %d\n", port);
+		devlink_port_type_clear(&info->devlink_port);
 		devl_port_unregister(&info->devlink_port);
 		info->port = -1;
 		return err;
@@ -3093,6 +3094,7 @@ static int mlx4_init_port_info(struct mlx4_dev *dev, int port)
 		mlx4_err(dev, "Failed to create mtu file for port %d\n", port);
 		device_remove_file(&info->dev->persist->pdev->dev,
 				   &info->port_attr);
+		devlink_port_type_clear(&info->devlink_port);
 		devl_port_unregister(&info->devlink_port);
 		info->port = -1;
 		return err;
@@ -3109,6 +3111,7 @@ static void mlx4_cleanup_port_info(struct mlx4_port_info *info)
 	device_remove_file(&info->dev->persist->pdev->dev, &info->port_attr);
 	device_remove_file(&info->dev->persist->pdev->dev,
 			   &info->port_mtu_attr);
+	devlink_port_type_clear(&info->devlink_port);
 	devl_port_unregister(&info->devlink_port);
 
 #ifdef CONFIG_RFS_ACCEL
-- 
2.37.1

