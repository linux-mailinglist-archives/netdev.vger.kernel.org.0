Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E181B147F
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgDTSbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:31:03 -0400
Received: from mga03.intel.com ([134.134.136.65]:6362 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725784AbgDTSbD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 14:31:03 -0400
IronPort-SDR: kh/2HXxybPwI/M4TCM0lJgtxjygkszFbrfw4IBBqr9sj3DnobmGSTQnV4wnGKL1CxGlu3POidu
 g0h1gkRaw3vQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 11:31:02 -0700
IronPort-SDR: PwUn+A0tvfLr7WppRE2E68Zli3/EXsKSeY4pUOPJnWVmpgtSXzhHNc/wTM0q2/ApfEGF3+2Bvj
 wc+lRHsRMEhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="290674476"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 20 Apr 2020 11:31:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 96018190; Mon, 20 Apr 2020 21:30:58 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1] net: bcmgenet: Use devm_clk_get_optional() to get the clocks
Date:   Mon, 20 Apr 2020 21:30:58 +0300
Message-Id: <20200420183058.67457-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Conversion to devm_clk_get_optional() makes it explicit that clocks are
optional. This change allows to handle deferred probe in case clocks are
defined, but not yet probed. Due to above changes replace dev_dbg() by
dev_err() and bail out in error case.

While here, check potential error when enable main clock.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 25 +++++++++++--------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ef275db018f73..045f7b7f0b5d3 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3487,13 +3487,16 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		priv->dma_max_burst_length = DMA_MAX_BURST_LENGTH;
 	}
 
-	priv->clk = devm_clk_get(&priv->pdev->dev, "enet");
+	priv->clk = devm_clk_get_optional(&priv->pdev->dev, "enet");
 	if (IS_ERR(priv->clk)) {
-		dev_dbg(&priv->pdev->dev, "failed to get enet clock\n");
-		priv->clk = NULL;
+		dev_err(&priv->pdev->dev, "failed to get enet clock\n");
+		err = PTR_ERR(priv->clk);
+		goto err;
 	}
 
-	clk_prepare_enable(priv->clk);
+	err = clk_prepare_enable(priv->clk);
+	if (err)
+		goto err;
 
 	bcmgenet_set_hw_params(priv);
 
@@ -3511,16 +3514,18 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	priv->rx_buf_len = RX_BUF_LENGTH;
 	INIT_WORK(&priv->bcmgenet_irq_work, bcmgenet_irq_task);
 
-	priv->clk_wol = devm_clk_get(&priv->pdev->dev, "enet-wol");
+	priv->clk_wol = devm_clk_get_optional(&priv->pdev->dev, "enet-wol");
 	if (IS_ERR(priv->clk_wol)) {
-		dev_dbg(&priv->pdev->dev, "failed to get enet-wol clock\n");
-		priv->clk_wol = NULL;
+		dev_err(&priv->pdev->dev, "failed to get enet-wol clock\n");
+		err = PTR_ERR(priv->clk_wol);
+		goto err;
 	}
 
-	priv->clk_eee = devm_clk_get(&priv->pdev->dev, "enet-eee");
+	priv->clk_eee = devm_clk_get_optional(&priv->pdev->dev, "enet-eee");
 	if (IS_ERR(priv->clk_eee)) {
-		dev_dbg(&priv->pdev->dev, "failed to get enet-eee clock\n");
-		priv->clk_eee = NULL;
+		dev_err(&priv->pdev->dev, "failed to get enet-eee clock\n");
+		err = PTR_ERR(priv->clk_eee);
+		goto err;
 	}
 
 	/* If this is an internal GPHY, power it on now, before UniMAC is
-- 
2.26.1

