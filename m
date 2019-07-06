Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 228D460E9C
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 05:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfGFDjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 23:39:14 -0400
Received: from mxhk.zte.com.cn ([63.217.80.70]:19562 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725813AbfGFDjN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 23:39:13 -0400
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id F081A44A3710DFFE5160;
        Sat,  6 Jul 2019 11:39:10 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id x663cvi1081481;
        Sat, 6 Jul 2019 11:38:57 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019070611394122-2124336 ;
          Sat, 6 Jul 2019 11:39:41 +0800 
From:   Wen Yang <wen.yang99@zte.com.cn>
To:     linux-kernel@vger.kernel.org
Cc:     xue.zhihong@zte.com.cn, wang.yi59@zte.com.cn,
        cheng.shengyu@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH] can: flexcan: fix an use-after-free in flexcan_setup_stop_mode()
Date:   Sat, 6 Jul 2019 11:37:20 +0800
Message-Id: <1562384240-46581-1-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-07-06 11:39:41,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-07-06 11:39:04,
        Serialize complete at 2019-07-06 11:39:04
X-MAIL: mse-fl1.zte.com.cn x663cvi1081481
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The gpr_np variable is still being used in dev_dbg() after the
of_node_put() call, which may result in use-after-free.

Fixes: de3578c198c6 ("can: flexcan: add self wakeup support")
Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/can/flexcan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index f2fe344..33ce45d 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1437,10 +1437,10 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 
 	priv = netdev_priv(dev);
 	priv->stm.gpr = syscon_node_to_regmap(gpr_np);
-	of_node_put(gpr_np);
 	if (IS_ERR(priv->stm.gpr)) {
 		dev_dbg(&pdev->dev, "could not find gpr regmap\n");
-		return PTR_ERR(priv->stm.gpr);
+		ret = PTR_ERR(priv->stm.gpr);
+		goto out_put_node;
 	}
 
 	priv->stm.req_gpr = out_val[1];
@@ -1455,7 +1455,9 @@ static int flexcan_setup_stop_mode(struct platform_device *pdev)
 
 	device_set_wakeup_capable(&pdev->dev, true);
 
-	return 0;
+out_put_node:
+	of_node_put(gpr_np);
+	return ret;
 }
 
 static const struct of_device_id flexcan_of_match[] = {
-- 
2.9.5

