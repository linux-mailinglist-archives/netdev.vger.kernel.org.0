Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3BC365C5
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 22:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfFEUnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 16:43:05 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:41863 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726731AbfFEUnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 16:43:01 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x55Kgqrr009251
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 Jun 2019 14:42:57 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x55Kghj6021149
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 5 Jun 2019 14:42:52 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     anirudh@xilinx.com, John.Linn@xilinx.com, andrew@lunn.ch,
        Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next v4 14/20] net: axienet: Make missing MAC address non-fatal
Date:   Wed,  5 Jun 2019 14:42:27 -0600
Message-Id: <1559767353-17301-15-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
References: <1559767353-17301-1-git-send-email-hancock@sedsystems.ca>
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
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index fba59c5..7b38819 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1733,8 +1733,9 @@ static int axienet_probe(struct platform_device *pdev)
 	/* Retrieve the MAC address */
 	mac_addr = of_get_mac_address(pdev->dev.of_node);
 	if (IS_ERR(mac_addr)) {
-		dev_err(&pdev->dev, "could not find MAC address\n");
-		goto free_netdev;
+		dev_warn(&pdev->dev, "could not find MAC address property: %ld\n",
+			 PTR_ERR(mac_addr));
+		mac_addr = NULL;
 	}
 	axienet_set_mac_address(ndev, mac_addr);
 
-- 
1.8.3.1

