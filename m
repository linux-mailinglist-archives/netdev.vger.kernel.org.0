Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD88E34B5A6
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 10:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhC0Ja2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 05:30:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14165 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhC0JaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 05:30:18 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6tmG0SDQznZZl;
        Sat, 27 Mar 2021 17:27:42 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Sat, 27 Mar 2021
 17:30:12 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <qiangqing.zhang@nxp.com>
Subject: [PATCH -next] net: stmmac: fix missing unlock on error in stmmac_suspend()
Date:   Sat, 27 Mar 2021 17:33:22 +0800
Message-ID: <20210327093322.1649580-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the missing unlock before return from stmmac_suspend()
in the error handling case.

Fixes: 5ec55823438e ("net: stmmac: add clocks management for gmac driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 170296820af0..973bdf11e59d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5605,8 +5605,10 @@ int stmmac_suspend(struct device *dev)
 		/* Disable clock in case of PWM is off */
 		clk_disable_unprepare(priv->plat->clk_ptp_ref);
 		ret = pm_runtime_force_suspend(dev);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&priv->lock);
 			return ret;
+		}
 	}
 
 	mutex_unlock(&priv->lock);
-- 
2.25.1

