Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25691E81C3
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgE2PZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:25:25 -0400
Received: from out28-99.mail.aliyun.com ([115.124.28.99]:56979 "EHLO
        out28-99.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgE2PZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:25:25 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.2575274|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.164164-0.0016903-0.834146;FP=0|0|0|0|0|-1|-1|-1;HT=e02c03303;MF=liu.xiang@zlingsmart.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.HfSn9bf_1590765903;
Received: from localhost(mailfrom:liu.xiang@zlingsmart.com fp:SMTPD_---.HfSn9bf_1590765903)
          by smtp.aliyun-inc.com(10.194.97.171);
          Fri, 29 May 2020 23:25:03 +0800
From:   Liu Xiang <liuxiang_1999@126.com>
To:     fugang.duan@nxp.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liu Xiang <liuxiang_1999@126.com>
Subject: [PATCH] net: fec: disable correct clk in the err path of fec_enet_clk_enable
Date:   Fri, 29 May 2020 23:24:56 +0800
Message-Id: <1590765896-3390-1-git-send-email-liuxiang_1999@126.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When enable clk_ref failed, clk_ptp should be disabled rather than
clk_ref itself.

Signed-off-by: Liu Xiang <liuxiang_1999@126.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index dc6f876..ac8d868 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1986,8 +1986,12 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 	return 0;
 
 failed_clk_ref:
-	if (fep->clk_ref)
-		clk_disable_unprepare(fep->clk_ref);
+	if (fep->clk_ptp) {
+		mutex_lock(&fep->ptp_clk_mutex);
+		clk_disable_unprepare(fep->clk_ptp);
+		fep->ptp_clk_on = false;
+		mutex_unlock(&fep->ptp_clk_mutex);
+	}
 failed_clk_ptp:
 	if (fep->clk_enet_out)
 		clk_disable_unprepare(fep->clk_enet_out);
-- 
1.9.1

