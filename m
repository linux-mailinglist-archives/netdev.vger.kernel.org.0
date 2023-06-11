Return-Path: <netdev+bounces-9900-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E90FA72B170
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 12:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF7201C209D0
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D93B79F9;
	Sun, 11 Jun 2023 10:40:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE0615BE
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 10:40:32 +0000 (UTC)
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34FD21B1;
	Sun, 11 Jun 2023 03:40:30 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1686480028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=C55nMeIDtiQJBRlRcKRFLbxtCKPrKUT5Uj3r1tMKd3M=;
	b=VXXXJ0grXoG5uje5MHKFDs6efk0qeKbQwieCwCx1NG18jdG2FVSZbbIgIc1EVxgz77GB5B
	z5CX0xzDjrD4UlwcZBINJG767DR2N66m3UsH/4JfAB4qstQoTJtzDISUYKHyG9NN3FJ2Wm
	iIQ8G0X3dKsUjZlYSGtWMV9ucCYNP7e3rrdWILpUff+zkvTzi999Iv0YH3mCWVaY3HduBp
	vXDUy9xkuCN0I7xIP+9m/ePEKU29Z31OleAhZ1t5haUF4Q5c9dkkwqjUVk3TSKGCgfhqkA
	ePdhX1KFqcgLphRumZGInKA6ixbzzM1Nza+1TeFtA3i15lPAse6bz+FB4g3w2g==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 8A424FF80A;
	Sun, 11 Jun 2023 10:40:24 +0000 (UTC)
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: davem@davemloft.net
Cc: Maxime Chevallier <maxime.chevallier@bootlin.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org,
	Simon Horman <simon.horman@corigine.com>,
	alexis.lothore@bootlin.com
Subject: [PATCH net-next] net: altera_tse: fix init sequence to avoid races with register_netdev
Date: Sun, 11 Jun 2023 12:40:19 +0200
Message-Id: <20230611104019.33793-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

As reported here[1], the init sequence in altera_tse can be racy should
any operation on the registered netdev happen after netdev registration
but before phylink initialization.

Fix the registering order to avoid such races by making register_netdev
the last step of the probing sequence.

[1]: https://lore.kernel.org/netdev/ZH9XK5yEGyoDMIs%2F@shell.armlinux.org.uk/

Fixes: fef2998203e1 ("net: altera: tse: convert to phylink")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
This patch targets net-next as it fixes a commit that is in net-next
too.

 drivers/net/ethernet/altera/altera_tse_main.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 2e15800e5310..54f1b5ad84ce 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1395,12 +1395,6 @@ static int altera_tse_probe(struct platform_device *pdev)
 	spin_lock_init(&priv->rxdma_irq_lock);
 
 	netif_carrier_off(ndev);
-	ret = register_netdev(ndev);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to register TSE net device\n");
-		goto err_register_netdev;
-	}
-
 	platform_set_drvdata(pdev, ndev);
 
 	priv->revision = ioread32(&priv->mac_dev->megacore_revision);
@@ -1449,12 +1443,16 @@ static int altera_tse_probe(struct platform_device *pdev)
 		goto err_init_phylink;
 	}
 
+	ret = register_netdev(ndev);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to register TSE net device\n");
+		return ret;
+	}
+
 	return 0;
 err_init_phylink:
 	lynx_pcs_destroy(priv->pcs);
 err_init_pcs:
-	unregister_netdev(ndev);
-err_register_netdev:
 	netif_napi_del(&priv->napi);
 	altera_tse_mdio_destroy(ndev);
 err_free_netdev:
-- 
2.40.1


