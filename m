Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878611B18C6
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgDTVv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:51:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:8706 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgDTVvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:51:25 -0400
IronPort-SDR: dAvdxqrRvaoifbiO0J2OlRfVx3LDJT0P/oodc8xXhmOrkEZC6U8fF5jql/ddscM52987Z+WXMi
 aujuncblQukA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2020 14:51:25 -0700
IronPort-SDR: R8FeNdprlkONRUq+pgX3vuwEGO09E6BwQFIJkpH58yBJVafMpLpZ6TVDr4yeiqRaQCPNETP1ma
 HNABldccp4Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,407,1580803200"; 
   d="scan'208";a="455845894"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 20 Apr 2020 14:51:23 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id E577E238; Tue, 21 Apr 2020 00:51:22 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 3/5] net: bcmgenet: Use devm_clk_get_optional() to get the clocks
Date:   Tue, 21 Apr 2020 00:51:19 +0300
Message-Id: <20200420215121.17735-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
References: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Conversion to devm_clk_get_optional() makes it explicit that clocks are
optional. This change allows to handle deferred probe in case clocks are
defined, but not yet probed. Due to above changes bail out in error case.

While here, check potential error when enable main clock.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index ef275db018f7..86666e9ab3e7 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3487,13 +3487,16 @@ static int bcmgenet_probe(struct platform_device *pdev)
 		priv->dma_max_burst_length = DMA_MAX_BURST_LENGTH;
 	}
 
-	priv->clk = devm_clk_get(&priv->pdev->dev, "enet");
+	priv->clk = devm_clk_get_optional(&priv->pdev->dev, "enet");
 	if (IS_ERR(priv->clk)) {
 		dev_dbg(&priv->pdev->dev, "failed to get enet clock\n");
-		priv->clk = NULL;
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
 		dev_dbg(&priv->pdev->dev, "failed to get enet-wol clock\n");
-		priv->clk_wol = NULL;
+		err = PTR_ERR(priv->clk_wol);
+		goto err;
 	}
 
-	priv->clk_eee = devm_clk_get(&priv->pdev->dev, "enet-eee");
+	priv->clk_eee = devm_clk_get_optional(&priv->pdev->dev, "enet-eee");
 	if (IS_ERR(priv->clk_eee)) {
 		dev_dbg(&priv->pdev->dev, "failed to get enet-eee clock\n");
-		priv->clk_eee = NULL;
+		err = PTR_ERR(priv->clk_eee);
+		goto err;
 	}
 
 	/* If this is an internal GPHY, power it on now, before UniMAC is
-- 
2.26.1

