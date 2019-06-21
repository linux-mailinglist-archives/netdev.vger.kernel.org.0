Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415EF4EC42
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfFUPj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:39:27 -0400
Received: from inva020.nxp.com ([92.121.34.13]:40110 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbfFUPi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 11:38:57 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 655651A0A89;
        Fri, 21 Jun 2019 17:38:55 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 58B201A0A85;
        Fri, 21 Jun 2019 17:38:55 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DD3F720629;
        Fri, 21 Jun 2019 17:38:54 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Rob Herring <robh+dt@kernel.org>,
        Allan Nielsen <Allan.Nielsen@microsemi.com>,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/6] ocelot: Refactor common ocelot probing code to ocelot_init
Date:   Fri, 21 Jun 2019 18:38:48 +0300
Message-Id: <1561131532-14860-3-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
References: <1561131532-14860-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is just common path code that belogs to ocelot_init,
it has nothing to do with a specific SoC/board instance.
Add allocation err check in the process.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c       | 6 ++++++
 drivers/net/ethernet/mscc/ocelot_board.c | 4 ----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 66cf57e6fd76..f07c398f8b21 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1674,6 +1674,11 @@ int ocelot_init(struct ocelot *ocelot)
 	int i, cpu = ocelot->num_phys_ports;
 	char queue_name[32];
 
+	ocelot->ports = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
+				     sizeof(struct ocelot_port *), GFP_KERNEL);
+	if (!ocelot->ports)
+		return -ENOMEM;
+
 	ocelot->lags = devm_kcalloc(ocelot->dev, ocelot->num_phys_ports,
 				    sizeof(u32), GFP_KERNEL);
 	if (!ocelot->lags)
@@ -1692,6 +1697,7 @@ int ocelot_init(struct ocelot *ocelot)
 	if (!ocelot->stats_queue)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&ocelot->multicast);
 	ocelot_mact_init(ocelot);
 	ocelot_vlan_init(ocelot);
 	ocelot_ace_init(ocelot);
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 58bde1a9eacb..2a6ee4edb858 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -255,10 +255,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	ocelot->num_phys_ports = of_get_child_count(ports);
 
-	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
-				     sizeof(struct ocelot_port *), GFP_KERNEL);
-
-	INIT_LIST_HEAD(&ocelot->multicast);
 	ocelot_init(ocelot);
 
 	for_each_available_child_of_node(ports, portnp) {
-- 
2.17.1

