Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F62C4A0200
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbiA1Uim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:38:42 -0500
Received: from mxout03.lancloud.ru ([45.84.86.113]:45920 "EHLO
        mxout03.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbiA1Uim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 15:38:42 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout03.lancloud.ru 9E82920A441C
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
Subject: [PATCH 1/2] ravb: ravb_close() always returns 0
Date:   Fri, 28 Jan 2022 23:38:37 +0300
Message-ID: <20220128203838.17423-2-s.shtylyov@omp.ru>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20220128203838.17423-1-s.shtylyov@omp.ru>
References: <20220128203838.17423-1-s.shtylyov@omp.ru>
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
 drivers/net/ethernet/renesas/ravb_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index b215cde68e10..02fa8cfc2b7b 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2863,9 +2863,7 @@ static int ravb_wol_restore(struct net_device *ndev)
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

