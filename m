Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAB442B3E8
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 06:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbhJMEGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 00:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhJMEGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 00:06:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0B8C061570;
        Tue, 12 Oct 2021 21:04:06 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ls18so1170575pjb.3;
        Tue, 12 Oct 2021 21:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=umM/A6X0CVoXZKDZIkn1A4Vpk8phdeUsf1Vnw4z7UnI=;
        b=AzMNuA7bT2w7CcbFo7mCVWstw+O+A3KWW3DZF6WBv2ct7fiQZ/9UqMU52OYArl8O4T
         T/vk2/ECSeNx4pPa+HrhPEXRZTCV9INHQ5lNKtoMfMWn+cjM3J4x4/clnPbSBOYRApVM
         6PdetwHhzyQd0eAKUw3HwrArNXS7VcvOJNK6Zng+2EIRhBR2X5e6pmEiHHxlYEfXjqpx
         qIOU4gcLnqo5rlt45eUkxDHymFGAj1ctFSRG7djcxGklPg3ly/8WBUxV0lYokcfLv/Ih
         dRBDU4yQgeljR6V3/gTVy5GEprmoAi/Q7KHH/b2zv9GTEehry8MoHUzlrBeQW4NaALyb
         TkTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=umM/A6X0CVoXZKDZIkn1A4Vpk8phdeUsf1Vnw4z7UnI=;
        b=UULDe+hGN6JkEC9sP0gcHJxRTxhDGOTK32lrAi6ngbyQaSoeLsGuyuK/3p+DNjBcQn
         BucUD+tbvJwVczdJlfwCKqIUKLXPQ08V23d8Povi8MlrAo4k2F1sfL+vG4yxE63YkI4D
         paa/wZcbmTBKwrRRH14H+ruojHSyjuhve0m2rXF5sfjcERvaG2dxV+zlk9vgwwpJPVOc
         mgXAQtjmgXdnQMhUO1q3PnvV2IL+ngdzw12MTvOfhbxrueU3s5EX3wmzbeSJttN9jVox
         /whqcijGXEjILzwC6yEIm4xVjZ+Ht/QBjbpKCgDqToB83GypVdf5hvYDoyIzzrdRX+7B
         qnwA==
X-Gm-Message-State: AOAM5329gGur+sBl2mXEqTvEstmAwDwB6oDd/tspIJ5YtDL0FrdBFol6
        AsvJ2Nm4myD29DgM5GRmpMA=
X-Google-Smtp-Source: ABdhPJxmw+bpQLcmFok+uS324k3xfmU7Yu2KBpeUnPoNtSaEuu5b5YASB1Nu/ib2ARMcTswrk0xdBQ==
X-Received: by 2002:a17:90b:4f87:: with SMTP id qe7mr131288pjb.29.1634097846120;
        Tue, 12 Oct 2021 21:04:06 -0700 (PDT)
Received: from localhost.localdomain ([94.177.118.45])
        by smtp.gmail.com with ESMTPSA id e6sm12386370pfm.212.2021.10.12.21.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 21:04:05 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Simek <michal.simek@xilinx.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] driver: net: can: delete napi if register_candev fails
Date:   Wed, 13 Oct 2021 12:03:49 +0800
Message-Id: <20211013040349.2858773-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If register_candev fails, xcan_probe does not clean the napi
created by netif_napi_add.

Fix this by adding error handling code to clean napi when
register_candev fails.

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/can/xilinx_can.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 3b883e607d8b..6ee0b5a8cdfc 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1807,7 +1807,7 @@ static int xcan_probe(struct platform_device *pdev)
 	ret = register_candev(ndev);
 	if (ret) {
 		dev_err(&pdev->dev, "fail to register failed (err=%d)\n", ret);
-		goto err_disableclks;
+		goto err_del_napi;
 	}
 
 	devm_can_led_init(ndev);
@@ -1825,6 +1825,8 @@ static int xcan_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_del_napi:
+	netif_napi_del(&priv->napi);
 err_disableclks:
 	pm_runtime_put(priv->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.25.1

