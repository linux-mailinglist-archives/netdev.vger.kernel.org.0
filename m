Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF281EEFFA
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 05:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgFEDcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 23:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbgFEDcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 23:32:47 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52980C08C5C0;
        Thu,  4 Jun 2020 20:32:46 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d7so8792594ioq.5;
        Thu, 04 Jun 2020 20:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IJPenuFpVQx0seln/2dhfFsuGNNRm+UZljRAm/AqGEU=;
        b=MiErTzzaT/PL3m/OS3OyrwrC6z+MwypmJk0i8+CZtkeIpwIXb7dASWDz86qGp6MT3G
         FJvG3eA5rF2AYahvF/mv6FgxBmKfg8+qVxthXvdCfEHFxx+PEvmgH6PG1LOUmNnsNDdO
         K3R/oh7eckba8nnLxO1cRHHHxzX5U1T3lUJxurEp87Vs/UMKzL1VIFFIbUCgxHxaLgMG
         iOzoi+A5aN8b69VblICG9RmWlASoQWhTFoK9BPj5zFfcKROqMe/EYFIdIeLZFMqN3ej7
         krWP1MD9yZ3dT5ECXByCFKtdNm/m0W/pH0zCzRfbz5JS7Er8Dr1mygmBzN4dFGhMxxdo
         E2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IJPenuFpVQx0seln/2dhfFsuGNNRm+UZljRAm/AqGEU=;
        b=pemwabohi3DmsBiPuqrJsICyos5WLcDERDAbxr9DsTsqAR7956ezWoqi8PkBxtyBU5
         xhCW4GDueiUJM6Dn5wire6sHG+/bkSMu1RH4VUv4lfTyMEcgnLAK9y+pEl0QZ9QmzvMi
         IzTDJR7pdn2tDBr8eswJ135JgiLDIOw18J13iuwdcUe4zteQyThAcP402uFRV5suGBB5
         1QFZKPajh6mNx1iVUyHWno5KzZ3pFB+wiO5vo/2Rwxtrxw6WE19TSwSmv4sYxblso4kP
         L07RwdS99scb++++X9o3UOFm+nCvgj0DvX+01eH5P6vI/iHjzDCtgEA5oYIHnaScm3z1
         IN2A==
X-Gm-Message-State: AOAM531grXGrk88lGCJ5B7XAXfC0QtzAnQZ9SY3ucB1tFCoqJtYWM/Db
        RRoOM0/Sa0bbrAmaTma1AH8=
X-Google-Smtp-Source: ABdhPJwRa2Z/m55HcVea1dDNvCKek/cSG6DIqGXdC4XhaAbVQRT83cYwoF0le9D7FEU0ikAN8oZ0TQ==
X-Received: by 2002:a6b:39c3:: with SMTP id g186mr6519042ioa.91.1591327965688;
        Thu, 04 Jun 2020 20:32:45 -0700 (PDT)
Received: from cs-u-kase.dtc.umn.edu (cs-u-kase.cs.umn.edu. [160.94.64.2])
        by smtp.googlemail.com with ESMTPSA id c72sm2464004ilg.3.2020.06.04.20.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 20:32:45 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Appana Durga Kedareswara rao <appana.durga.rao@xilinx.com>,
        Naga Sureshkumar Relli <naga.sureshkumar.relli@xilinx.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, wu000273@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] can: xilinx_can: handle failure cases of pm_runtime_get_sync
Date:   Thu,  4 Jun 2020 22:32:39 -0500
Message-Id: <20200605033239.60664-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Calling pm_runtime_get_sync increments the counter even in case of
failure, causing incorrect ref count. Call pm_runtime_put if
pm_runtime_get_sync fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/can/xilinx_can.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index c1dbab8c896d..748ff70f6a7b 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -1391,7 +1391,7 @@ static int xcan_open(struct net_device *ndev)
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
 			   __func__, ret);
-		return ret;
+		goto err;
 	}
 
 	ret = request_irq(ndev->irq, xcan_interrupt, priv->irq_flags,
@@ -1475,6 +1475,7 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
 			   __func__, ret);
+		pm_runtime_put(priv->dev);
 		return ret;
 	}
 
@@ -1789,7 +1790,7 @@ static int xcan_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		netdev_err(ndev, "%s: pm_runtime_get failed(%d)\n",
 			   __func__, ret);
-		goto err_pmdisable;
+		goto err_disableclks;
 	}
 
 	if (priv->read_reg(priv, XCAN_SR_OFFSET) != XCAN_SR_CONFIG_MASK) {
@@ -1824,7 +1825,6 @@ static int xcan_probe(struct platform_device *pdev)
 
 err_disableclks:
 	pm_runtime_put(priv->dev);
-err_pmdisable:
 	pm_runtime_disable(&pdev->dev);
 err_free:
 	free_candev(ndev);
-- 
2.17.1

