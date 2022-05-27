Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0EB535D54
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349784AbiE0JZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiE0JZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:25:55 -0400
Received: from smtp.smtpout.orange.fr (smtp09.smtpout.orange.fr [80.12.242.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B81FEF6882
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 02:25:53 -0700 (PDT)
Received: from pop-os.home ([90.11.191.102])
        by smtp.orange.fr with ESMTPA
        id uWE9n3MmXOXCyuWEAnkQcb; Fri, 27 May 2022 11:25:51 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Fri, 27 May 2022 11:25:51 +0200
X-ME-IP: 90.11.191.102
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] net: enetc: Use pci_release_region() to release some resources
Date:   Fri, 27 May 2022 11:25:47 +0200
Message-Id: <b0dcb6124717d13900e48b2f1fa697b922f672b2.1653643529.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some resources are allocated using pci_request_region().
It is more straightforward to release them with pci_release_region().

Fixes: 231ece36f50d ("enetc: Add mdio bus driver for the PCIe MDIO endpoint")

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
This patch is speculative, mainly based on the inconsistency between some
function's names.
Using pci_request_mem_regions() would also have things look consistent.

Review with care.
---
 drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
index 15f37c5b8dc1..dafb26f81f95 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pci_mdio.c
@@ -69,7 +69,7 @@ static int enetc_pci_mdio_probe(struct pci_dev *pdev,
 	return 0;
 
 err_mdiobus_reg:
-	pci_release_mem_regions(pdev);
+	pci_release_region(pdev, 0);
 err_pci_mem_reg:
 	pci_disable_device(pdev);
 err_pci_enable:
@@ -88,7 +88,7 @@ static void enetc_pci_mdio_remove(struct pci_dev *pdev)
 	mdiobus_unregister(bus);
 	mdio_priv = bus->priv;
 	iounmap(mdio_priv->hw->port);
-	pci_release_mem_regions(pdev);
+	pci_release_region(pdev, 0);
 	pci_disable_device(pdev);
 }
 
-- 
2.34.1

