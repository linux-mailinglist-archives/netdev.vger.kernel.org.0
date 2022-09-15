Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C046B5B9BD4
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 15:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiIONaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 09:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiIONae (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 09:30:34 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CCE6C110
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:30:32 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id bj12so42093844ejb.13
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 06:30:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=IiwEvg7xStdXEy9AQ0RZ+E2bttEkvsFzPBzCVZl4qtU=;
        b=b11uXZdeBFK+BRYosGI3lneIDFvqKuCTZsgNk6WRklBhFQKU2f5vYNhQpCGfgI0XBR
         S6f/mR5VY/SomF7NPL3lRlwM3c9LcZ4gicncvNQ18AkJDj4yo8SDMYm2PZnjVotQrrhW
         qEg0EXMgev9z0t3TiLG2zyGYKpxwOid7n946o4hJkR4gUjAe/R2XEpQmKYP2FtuM1jPE
         LGZxHdbQTW1c6aDlVbEo+cRKdsmXCG3QZwB+vo3bi8GBejH/tanpdVh+tYZELyHRcFIq
         bXjc7njAPtStZHeSov90SdJV9VlKWkoL96+wvajlTMUc4SrKHn2mRTI1wSG7vdtIpr+6
         rtCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=IiwEvg7xStdXEy9AQ0RZ+E2bttEkvsFzPBzCVZl4qtU=;
        b=1VuyNxNzpZcCLQdRYXXEyj1cRjQ0V/9vwsEeqIse9xet4LeRIGZw8vQ3IJljc49CcU
         YFo9/JTOs7GU2ewUE970FZwGxnSJE8QgGKIsvfLZiDvaFV88j3pmaQeMeyDv+htIBTNO
         LUymI60mNW9yFxxB4c4I6cHdlIEuHlbRvJzDV5qw2lrSxVMwWKrFL2A3XGXpHg7O9G4u
         VUMvs4bNoySp1zBt9ekfRT/7i6+4XmXdm/fKMSD9xWs92nLMz238k5t+DjlWad2QZJYo
         E+bUFAdp+uiGiCzHIdCtu7ctMHzUGeivi7NdfJZ/wjwoD0L8etoLEAZParmewoSPXyCm
         7PeA==
X-Gm-Message-State: ACgBeo2MGHc/WUDPsHqPdvOLsxz50z1992xwSzmsXhAqYwb799gwHizK
        k+5fq531zMoT/Kj65gqt2K8=
X-Google-Smtp-Source: AA6agR7w5qGuaTqXlsgyYBuIXL/BLn7XIJifONA4lCD0frpOzThBYyzUAXmeZKdijDoQmIrkcng31w==
X-Received: by 2002:a17:906:974d:b0:780:2c07:7617 with SMTP id o13-20020a170906974d00b007802c077617mr6414134ejy.707.1663248631366;
        Thu, 15 Sep 2022 06:30:31 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id d4-20020a056402000400b0044e7c20d7a9sm11802619edu.37.2022.09.15.06.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 06:30:30 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] net: broadcom: bcm4908_enet: handle -EPROBE_DEFER when getting MAC
Date:   Thu, 15 Sep 2022 15:30:13 +0200
Message-Id: <20220915133013.2243-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Reading MAC from OF may return -EPROBE_DEFER if underlaying NVMEM device
isn't ready yet. In such case pass that error code up and "wait" to be
probed later.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/ethernet/broadcom/bcm4908_enet.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
index e5e17a182f9d..489367fa5748 100644
--- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
+++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
@@ -716,6 +716,8 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 
 	SET_NETDEV_DEV(netdev, &pdev->dev);
 	err = of_get_ethdev_address(dev->of_node, netdev);
+	if (err == -EPROBE_DEFER)
+		goto err_dma_free;
 	if (err)
 		eth_hw_addr_random(netdev);
 	netdev->netdev_ops = &bcm4908_enet_netdev_ops;
@@ -726,14 +728,17 @@ static int bcm4908_enet_probe(struct platform_device *pdev)
 	netif_napi_add(netdev, &enet->rx_ring.napi, bcm4908_enet_poll_rx, NAPI_POLL_WEIGHT);
 
 	err = register_netdev(netdev);
-	if (err) {
-		bcm4908_enet_dma_free(enet);
-		return err;
-	}
+	if (err)
+		goto err_dma_free;
 
 	platform_set_drvdata(pdev, enet);
 
 	return 0;
+
+err_dma_free:
+	bcm4908_enet_dma_free(enet);
+
+	return err;
 }
 
 static int bcm4908_enet_remove(struct platform_device *pdev)
-- 
2.34.1

