Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC90AD32BF
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 22:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfJJUqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 16:46:11 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:47175 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJJUqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 16:46:11 -0400
X-Originating-IP: 86.202.229.42
Received: from localhost (lfbn-lyo-1-146-42.w86-202.abo.wanadoo.fr [86.202.229.42])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 36D9DC000E;
        Thu, 10 Oct 2019 20:46:09 +0000 (UTC)
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH] net: lpc_eth: avoid resetting twice
Date:   Thu, 10 Oct 2019 22:46:06 +0200
Message-Id: <20191010204606.15279-1-alexandre.belloni@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__lpc_eth_shutdown is called after __lpc_eth_reset but it is already
calling __lpc_eth_reset. Avoid resetting the IP twice.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
---
 drivers/net/ethernet/nxp/lpc_eth.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/nxp/lpc_eth.c b/drivers/net/ethernet/nxp/lpc_eth.c
index fdcaf70151d4..e766a3e34d14 100644
--- a/drivers/net/ethernet/nxp/lpc_eth.c
+++ b/drivers/net/ethernet/nxp/lpc_eth.c
@@ -1364,9 +1364,6 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
 	if (!is_valid_ether_addr(ndev->dev_addr))
 		eth_hw_addr_random(ndev);
 
-	/* Reset the ethernet controller */
-	__lpc_eth_reset(pldat);
-
 	/* then shut everything down to save power */
 	__lpc_eth_shutdown(pldat);
 
-- 
2.21.0

