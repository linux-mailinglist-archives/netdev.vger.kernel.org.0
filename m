Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9B43D312
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390815AbfFKQ4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:56:21 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:28391 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387767AbfFKQ4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:56:21 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x5BGuHd7005198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jun 2019 10:56:17 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x5BGuGWb008506
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 11 Jun 2019 10:56:16 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next] net: axienet: move use of resource after validity check
Date:   Tue, 11 Jun 2019 10:56:02 -0600
Message-Id: <1560272162-14856-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were accessing the pointer returned from platform_get_resource before
checking if it was valid, causing an oops if it was not. Move this access
after the call to devm_ioremap_resource which does the validity check.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---

This bug was introduced in my recent axienet patch series and so is only
needed on net-next.

 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index da420c8..561e28a 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1679,13 +1679,13 @@ static int axienet_probe(struct platform_device *pdev)
 	lp->tx_bd_num = TX_BD_NUM_DEFAULT;
 	/* Map device registers */
 	ethres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	lp->regs_start = ethres->start;
 	lp->regs = devm_ioremap_resource(&pdev->dev, ethres);
 	if (IS_ERR(lp->regs)) {
 		dev_err(&pdev->dev, "could not map Axi Ethernet regs.\n");
 		ret = PTR_ERR(lp->regs);
 		goto free_netdev;
 	}
+	lp->regs_start = ethres->start;
 
 	/* Setup checksum offload, but default to off if not specified */
 	lp->features = 0;
-- 
1.8.3.1

