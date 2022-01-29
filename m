Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E944A2E71
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 12:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241133AbiA2Lzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 06:55:37 -0500
Received: from mxout01.lancloud.ru ([45.84.86.81]:55078 "EHLO
        mxout01.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240763AbiA2LzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 06:55:24 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout01.lancloud.ru 2A12520E2571
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
Subject: [PATCH v2 1/2] ravb: ravb_close() always returns 0
Date:   Sat, 29 Jan 2022 14:55:16 +0300
Message-ID: <20220129115517.11891-2-s.shtylyov@omp.ru>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20220129115517.11891-1-s.shtylyov@omp.ru>
References: <20220129115517.11891-1-s.shtylyov@omp.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1907.lancloud.ru (fd00:f066::207)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ravb_close() always returns 0, hence the check in ravb_wol_restore() is
pointless (however, we cannot change the prototype of ravb_close() as it
implements the driver's ndo_stop() method).

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
Changes in version 2:
- removed no longer used local variable in ravb_wol_restore().

 drivers/net/ethernet/renesas/ravb_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b215cde68e10..9ee246796a77 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2854,7 +2854,6 @@ static int ravb_wol_restore(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
-	int ret;
 
 	if (info->nc_queues)
 		napi_enable(&priv->napi[RAVB_NC]);
@@ -2863,9 +2862,7 @@ static int ravb_wol_restore(struct net_device *ndev)
 	/* Disable MagicPacket */
 	ravb_modify(ndev, ECMR, ECMR_MPDE, 0);
 
-	ret = ravb_close(ndev);
-	if (ret < 0)
-		return ret;
+	ravb_close(ndev);
 
 	return disable_irq_wake(priv->emac_irq);
 }
-- 
2.26.3

