Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 742BF3F3954
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 09:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhHUHgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 03:36:08 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:55806 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbhHUHgG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Aug 2021 03:36:06 -0400
Received: from pop-os.home ([90.126.253.178])
        by mwinf5d09 with ME
        id k7bR2500N3riaq2037bRPo; Sat, 21 Aug 2021 09:35:26 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 21 Aug 2021 09:35:26 +0200
X-ME-IP: 90.126.253.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     iyappan@os.amperecomputing.com, keyur@os.amperecomputing.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] xgene-v2: Fix a resource leak in the error handling path of 'xge_probe()'
Date:   Sat, 21 Aug 2021 09:35:23 +0200
Message-Id: <ea7a73e68cd33652850b5392303b417693575dc4.1629531259.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A successful 'xge_mdio_config()' call should be balanced by a corresponding
'xge_mdio_remove()' call in the error handling path of the probe, as
already done in the remove function.

Update the error handling path accordingly.

Fixes: ea8ab16ab225 ("drivers: net: xgene-v2: Add MDIO support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/apm/xgene-v2/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 860c18fb7aae..80399c8980bd 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -677,11 +677,13 @@ static int xge_probe(struct platform_device *pdev)
 	ret = register_netdev(ndev);
 	if (ret) {
 		netdev_err(ndev, "Failed to register netdev\n");
-		goto err;
+		goto err_mdio_remove;
 	}
 
 	return 0;
 
+err_mdio_remove:
+	xge_mdio_remove(ndev);
 err:
 	free_netdev(ndev);
 
-- 
2.30.2

