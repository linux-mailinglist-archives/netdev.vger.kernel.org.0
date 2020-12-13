Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9482D8CE0
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 12:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406185AbgLMLup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 06:50:45 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:38340 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406111AbgLMLu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 06:50:27 -0500
Received: from localhost.localdomain ([93.22.148.240])
        by mwinf5d68 with ME
        id 3nod2400K5BSGut03noeyE; Sun, 13 Dec 2020 12:48:42 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Dec 2020 12:48:42 +0100
X-ME-IP: 93.22.148.240
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     UNGLinuxDriver@microchip.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] net: mscc: ocelot: Fix a resource leak in the error handling path of the probe function
Date:   Sun, 13 Dec 2020 12:48:38 +0100
Message-Id: <20201213114838.126922-1-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of error after calling 'ocelot_init()', it must be undone by a
corresponding 'ocelot_deinit()' call, as already done in the remove
function.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 1e7729421a82..9cf2bc5f4289 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1267,7 +1267,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 	err = mscc_ocelot_init_ports(pdev, ports);
 	if (err)
-		goto out_put_ports;
+		goto out_ocelot_deinit;
 
 	if (ocelot->ptp) {
 		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
@@ -1282,8 +1282,14 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	register_switchdev_notifier(&ocelot_switchdev_nb);
 	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 
+	of_node_put(ports);
+
 	dev_info(&pdev->dev, "Ocelot switch probed\n");
 
+	return 0;
+
+out_ocelot_deinit:
+	ocelot_deinit(ocelot);
 out_put_ports:
 	of_node_put(ports);
 	return err;
-- 
2.27.0

