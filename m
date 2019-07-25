Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D365B74F8A
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 15:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfGYNdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 09:33:21 -0400
Received: from inva021.nxp.com ([92.121.34.21]:34790 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728081AbfGYNdV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 09:33:21 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 8584120071B;
        Thu, 25 Jul 2019 15:33:19 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 792EB200709;
        Thu, 25 Jul 2019 15:33:19 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 37B64205E8;
        Thu, 25 Jul 2019 15:33:19 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net] ocelot: Cancel delayed work before wq destruction
Date:   Thu, 25 Jul 2019 16:33:18 +0300
Message-Id: <1564061598-4440-1-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make sure the delayed work for stats update is not pending before
wq destruction.
This fixes the module unload path.
The issue is there since day 1.

Fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b71e4ecbe469..6932e615d4b0 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1818,6 +1818,7 @@ EXPORT_SYMBOL(ocelot_init);
 
 void ocelot_deinit(struct ocelot *ocelot)
 {
+	cancel_delayed_work(&ocelot->stats_work);
 	destroy_workqueue(ocelot->stats_queue);
 	mutex_destroy(&ocelot->stats_lock);
 	ocelot_ace_deinit();
-- 
2.17.1

