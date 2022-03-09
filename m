Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683D44D2B84
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbiCIJNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231877AbiCIJMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:12:53 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA85616BFB3;
        Wed,  9 Mar 2022 01:11:55 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id mg21-20020a17090b371500b001bef9e4657cso4710905pjb.0;
        Wed, 09 Mar 2022 01:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=oajkNxPEtUGCoRw60Kh+hjbhxD8g39tgk6M9/aAms/4=;
        b=B5h5iaT6jAgMvBj4+b8Ifxl1guCDtK2WJTNiON1iyyzH3SZcfdgdbwzZfcFHlQX7CV
         fJYlLhfpNJUCXfYpEy78XSpNVl9WUsRyKSqXnldVx9rdsJnL8lnQQ7zdAV1IEa7Aadnb
         F6jLbFCPZOJMDjIefnIuHD68FoIHcaH1Gpev+5EiDfZZQIbJfksrG4G9Occ4nY9yF42Z
         U+DSc2mt9ywU4ddByvRC1avu9d51Y/oY3+2iU/iDnl1gOnyFm1M/Nz00Al1l6I36djjh
         EXhBRnAvanWJzxGkrwhiX1ah4BNmQ93ZHmBJGFKcP+/6pXPts1O91JM+J5f8oDC0R2Fa
         FMfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=oajkNxPEtUGCoRw60Kh+hjbhxD8g39tgk6M9/aAms/4=;
        b=iLpT6mmGX1aT715btAnUIPqEVgfVUrjGVZDh1gcjEIHf2jISMDU3D96q5krKT8pNhX
         LjtBIVpRfUWh7mGSkVSpHCmKLq7mUPk0aAo5hSQAY88Rz9N1bTEl0udxOfHlqFdcQpC0
         UlqaDczhbPEek2fvQ/sLbSa3wuKQRN9q8/Gg6OSdeLQ0C9XeuesJ0hE6haovLTzOn3Z7
         m0+mD3qrKI+dgmUfIO/x1RevCq1z4uFr8SgbU+iZUHFcTvu5LEpEvGLwKZoZgdGnmD91
         au/Hcc+LIF2TJp/TnOAwYQ11bDbAhfcbrtzl2rX0+pwlp42copLxGEzzPL4Y+lX9rhkF
         ibDA==
X-Gm-Message-State: AOAM532Lms8ysFsqw2MSwUfu+LJxnaxCgbjNxKGclZgo4e+MbaMXH4qL
        jwEhIQlV5gStH39Ajas2Zok=
X-Google-Smtp-Source: ABdhPJwTsGkKuYkcqGVbZ+U/xEcW/zM2/FAJtxB8qzCWOCZKC4FB3UB9hs+7kBP0Dxzf8eo8inJnXQ==
X-Received: by 2002:a17:90b:3a81:b0:1bf:9a17:99b7 with SMTP id om1-20020a17090b3a8100b001bf9a1799b7mr5616183pjb.68.1646817115167;
        Wed, 09 Mar 2022 01:11:55 -0800 (PST)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id d10-20020a63360a000000b0037947abe4bbsm1681514pga.34.2022.03.09.01.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 01:11:54 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] ethtool: Fix refcount leak in gfar_get_ts_info
Date:   Wed,  9 Mar 2022 09:11:49 +0000
Message-Id: <20220309091149.775-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The of_find_compatible_node() function returns a node pointer with
refcount incremented, We should use of_node_put() on it when done
Add the missing of_node_put() to release the refcount.

Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index through drvdata")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/freescale/gianfar_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index ff756265d58f..9a2c16d69e2c 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -1464,6 +1464,7 @@ static int gfar_get_ts_info(struct net_device *dev,
 	ptp_node = of_find_compatible_node(NULL, NULL, "fsl,etsec-ptp");
 	if (ptp_node) {
 		ptp_dev = of_find_device_by_node(ptp_node);
+		of_node_put(ptp_node);
 		if (ptp_dev)
 			ptp = platform_get_drvdata(ptp_dev);
 	}
-- 
2.17.1

