Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA062C741E
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388915AbgK1Vtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:47 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8880 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728737AbgK1SZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:25:07 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CjsvG4DPLz717F;
        Sat, 28 Nov 2020 21:35:38 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Sat, 28 Nov 2020
 21:35:58 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
Subject: [PATCH 1/2] can: c_can: Fix error handling in c_can_power_up
Date:   Sat, 28 Nov 2020 21:39:21 +0800
Message-ID: <20201128133922.3276973-2-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20201128133922.3276973-1-zhangqilong3@huawei.com>
References: <20201128133922.3276973-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the error handling in c_can_power_up, There are two
bugs:

    1) c_can_pm_runtime_get_sync will increase usage
       counter if device is not empty. Forgetting to
       call c_can_pm_runtime_put_sync will result in
       a reference leak here.

    2) c_can_reset_ram operation will set start bit
       when enable is true. We should clear it in the
       error handling.

We fix it by adding c_can_pm_runtime_put_sync for 1),
and c_can_reset_ram(enable is false) for 2) in the
error handling.

Fixes: 8212003260c60 ("can: c_can: Add d_can suspend resume support")
Fixes: 52cde85acc23f ("can: c_can: Add d_can raminit support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/net/can/c_can/c_can.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 0420f09f2b70..becfdff7f3fd 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -1295,12 +1295,22 @@ int c_can_power_up(struct net_device *dev)
 				time_after(time_out, jiffies))
 		cpu_relax();
 
-	if (time_after(jiffies, time_out))
-		return -ETIMEDOUT;
+	if (time_after(jiffies, time_out)) {
+		ret = -ETIMEDOUT;
+		goto err_out;
+	}
 
 	ret = c_can_start(dev);
-	if (!ret)
-		c_can_irq_control(priv, true);
+	if (ret)
+		goto err_out;
+
+	c_can_irq_control(priv, true);
+
+	return ret;
+
+err_out:
+	c_can_reset_ram(priv, false);
+	c_can_pm_runtime_put_sync(priv);
 
 	return ret;
 }
-- 
2.25.4

