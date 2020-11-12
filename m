Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AF32B07E6
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 15:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgKLOz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 09:55:59 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7224 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLOz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 09:55:59 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CX4R30KNVzkgRp;
        Thu, 12 Nov 2020 22:55:43 +0800 (CST)
Received: from localhost (10.174.176.180) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Nov 2020
 22:55:50 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] net: dsa: sja1105: Fix return value check in sja1105_ptp_clock_register()
Date:   Thu, 12 Nov 2020 22:55:32 +0800
Message-ID: <20201112145532.38320-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.176.180]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/dsa/sja1105/sja1105_ptp.c:869 sja1105_ptp_clock_register() warn: passing zero to 'PTR_ERR'

ptp_clock_register() returns ERR_PTR() and never returns
NULL. The NULL test should be removed.

Fixes: bb77f36ac21d ("net: dsa: sja1105: Add support for the PTP clock")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 1b90570b257b..1e41d491c854 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -865,7 +865,7 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds)
 	spin_lock_init(&tagger_data->meta_lock);
 
 	ptp_data->clock = ptp_clock_register(&ptp_data->caps, ds->dev);
-	if (IS_ERR_OR_NULL(ptp_data->clock))
+	if (IS_ERR(ptp_data->clock))
 		return PTR_ERR(ptp_data->clock);
 
 	ptp_data->cmd.corrclk4ts = true;
-- 
2.17.1

