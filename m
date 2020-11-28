Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0782C7418
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388946AbgK1Vtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:47 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:8881 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728883AbgK1SZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 13:25:12 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CjsvG4RhYz717w;
        Sat, 28 Nov 2020 21:35:38 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Sat, 28 Nov 2020
 21:35:59 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-can@vger.kernel.org>
Subject: [PATCH 2/2] can: kvaser_pciefd: Fix error handling in kvaser_pciefd_open
Date:   Sat, 28 Nov 2020 21:39:22 +0800
Message-ID: <20201128133922.3276973-3-zhangqilong3@huawei.com>
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

If kvaser_pciefd_bus_on failed, we should call close_candev
to avoid reference leak.

Fixes: 26ad340e582d3 ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 drivers/net/can/kvaser_pciefd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 1bafa614950e..969cedb9b0b6 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -692,8 +692,10 @@ static int kvaser_pciefd_open(struct net_device *netdev)
 		return err;
 
 	err = kvaser_pciefd_bus_on(can);
-	if (err)
+	if (err) {
+		close_candev(netdev);
 		return err;
+	}
 
 	return 0;
 }
-- 
2.25.4

