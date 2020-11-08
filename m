Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3AB2AAA13
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 09:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgKHI0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 03:26:18 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7611 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgKHI0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 03:26:18 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CTRzJ13QzzLlcZ;
        Sun,  8 Nov 2020 16:26:04 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Sun, 8 Nov 2020
 16:26:11 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH v2] can: flexcan: fix reference count leak in flexcan ops
Date:   Sun, 8 Nov 2020 16:30:00 +0800
Message-ID: <20201108083000.2599705-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pm_runtime_get_sync() will increment pm usage at first and it
will resume the device later. If runtime of the device has
error or device is in inaccessible state(or other error state),
resume operation will fail. If we do not call put operation to
decrease the reference, it will result in reference leak in
the two function(flexcan_get_berr_counter and flexcan_open).
Moreover, this device cannot enter the idle state and always
stay busy or other non-idle state later. So we should fix it
through adding pm_runtime_put_noidle.

Fixes: ca10989632d88 ("can: flexcan: implement can Runtime PM")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
Changelog:
v2
- removed empty lines between tags.
---
 drivers/net/can/flexcan.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 881799bd9c5e..c42a1ae5ee46 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -728,8 +728,10 @@ static int flexcan_get_berr_counter(const struct net_device *dev,
 	int err;
 
 	err = pm_runtime_get_sync(priv->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_noidle(priv->dev);
 		return err;
+	}
 
 	err = __flexcan_get_berr_counter(dev, bec);
 
@@ -1654,8 +1656,10 @@ static int flexcan_open(struct net_device *dev)
 	}
 
 	err = pm_runtime_get_sync(priv->dev);
-	if (err < 0)
+	if (err < 0) {
+		pm_runtime_put_noidle(priv->dev);
 		return err;
+	}
 
 	err = open_candev(dev);
 	if (err)
-- 
2.25.4

