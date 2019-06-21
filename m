Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44964EC05
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 17:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfFUPaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 11:30:05 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48095 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbfFUPaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 11:30:05 -0400
X-Originating-IP: 90.88.16.156
Received: from localhost (aaubervilliers-681-1-41-156.w90-88.abo.wanadoo.fr [90.88.16.156])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id D4C076000D;
        Fri, 21 Jun 2019 15:30:01 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, nicolas.ferre@microchip.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ludovic.desroches@microchip.com, alexandre.belloni@bootlin.com
Subject: [PATCH net] net: macb: do not copy the mac address if NULL
Date:   Fri, 21 Jun 2019 17:26:35 +0200
Message-Id: <20190621152635.29689-1-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the MAC address setup in the probe. The MAC address
retrieved using of_get_mac_address was checked for not containing an
error, but it may also be NULL which wasn't tested. Fix it by replacing
IS_ERR with IS_ERR_OR_NULL.

Fixes: 541ddc66d665 ("net: macb: support of_get_mac_address new ERR_PTR error")
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 1241a2a73438..1cd1f2c36d6f 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -4304,7 +4304,7 @@ static int macb_probe(struct platform_device *pdev)
 	if (PTR_ERR(mac) == -EPROBE_DEFER) {
 		err = -EPROBE_DEFER;
 		goto err_out_free_netdev;
-	} else if (!IS_ERR(mac)) {
+	} else if (!IS_ERR_OR_NULL(mac)) {
 		ether_addr_copy(bp->dev->dev_addr, mac);
 	} else {
 		macb_get_hwaddr(bp);
-- 
2.21.0

