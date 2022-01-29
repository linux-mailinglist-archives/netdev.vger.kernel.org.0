Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483DB4A2E72
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 12:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240572AbiA2Lzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 06:55:39 -0500
Received: from mxout02.lancloud.ru ([45.84.86.82]:39872 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240740AbiA2LzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 06:55:24 -0500
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru 8DD4922FB520
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-renesas-soc@vger.kernel.org>
Subject: [PATCH v2 2/2] sh_eth: sh_eth_close() always returns 0
Date:   Sat, 29 Jan 2022 14:55:17 +0300
Message-ID: <20220129115517.11891-3-s.shtylyov@omp.ru>
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

sh_eth_close() always returns 0, hence the check in sh_eth_wol_restore()
is pointless (however we cannot change the prototype of sh_eth_close() as
it implements the driver's ndo_stop() method).

Found by Linux Verification Center (linuxtesting.org) with the SVACE static
analysis tool.

Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
---
 drivers/net/ethernet/renesas/sh_eth.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index d947a628e166..b21e101b4484 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -3450,9 +3450,7 @@ static int sh_eth_wol_restore(struct net_device *ndev)
 	 * both be reset and all registers restored. This is what
 	 * happens during suspend and resume without WoL enabled.
 	 */
-	ret = sh_eth_close(ndev);
-	if (ret < 0)
-		return ret;
+	sh_eth_close(ndev);
 	ret = sh_eth_open(ndev);
 	if (ret < 0)
 		return ret;
-- 
2.26.3

