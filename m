Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA3733A71
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 23:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfFCV55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 17:57:57 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:48927 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfFCV5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 17:57:52 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x53LvpWt003957
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 3 Jun 2019 15:57:51 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x53LvTMV008601
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 3 Jun 2019 15:57:35 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 14/18] net: axienet: Make missing MAC address non-fatal
Date:   Mon,  3 Jun 2019 15:57:13 -0600
Message-Id: <1559599037-8514-15-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
References: <1559599037-8514-1-git-send-email-hancock@sedsystems.ca>
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Failing initialization on a missing MAC address property is excessive.
We can just fall back to using a random MAC instead, which at least
leaves the interface in a functioning state.

Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 398e7e6..ee3834b 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -300,7 +300,7 @@ static void axienet_set_mac_address(struct net_device *ndev,
 {
 	struct axienet_local *lp = netdev_priv(ndev);
 
-	if (address)
+	if (!IS_ERR(address))
 		memcpy(ndev->dev_addr, address, ETH_ALEN);
 	if (!is_valid_ether_addr(ndev->dev_addr))
 		eth_hw_addr_random(ndev);
@@ -1722,8 +1722,7 @@ static int axienet_probe(struct platform_device *pdev)
 	/* Retrieve the MAC address */
 	mac_addr = of_get_mac_address(pdev->dev.of_node);
 	if (IS_ERR(mac_addr)) {
-		dev_err(&pdev->dev, "could not find MAC address\n");
-		goto free_netdev;
+		dev_warn(&pdev->dev, "could not find MAC address property\n");
 	}
 	axienet_set_mac_address(ndev, mac_addr);
 
-- 
1.8.3.1

