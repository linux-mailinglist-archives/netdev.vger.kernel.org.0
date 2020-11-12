Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7A52B038E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 12:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbgKLLJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 06:09:58 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7885 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbgKLLJ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 06:09:57 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CWzQJ66Prz73VV;
        Thu, 12 Nov 2020 19:09:44 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Thu, 12 Nov 2020 19:09:51 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <hauke@hauke-m.de>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: dsa: lantiq_gswip: add missed clk_disable_unprepare() in gswip_gphy_fw_load()
Date:   Thu, 12 Nov 2020 19:11:35 +0800
Message-ID: <1605179495-818-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix missing clk_disable_unprepare() before return from
gswip_gphy_fw_load() in the error handling case.

Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/dsa/lantiq_gswip.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 74db81d..8936d65 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1682,6 +1682,7 @@ static int gswip_gphy_fw_load(struct gswip_priv *priv, struct gswip_gphy_fw *gph
 	if (ret) {
 		dev_err(dev, "failed to load firmware: %s, error: %i\n",
 			gphy_fw->fw_name, ret);
+		clk_disable_unprepare(gphy_fw->clk_gate);
 		return ret;
 	}
 
@@ -1698,14 +1699,17 @@ static int gswip_gphy_fw_load(struct gswip_priv *priv, struct gswip_gphy_fw *gph
 	} else {
 		dev_err(dev, "failed to alloc firmware memory\n");
 		release_firmware(fw);
+		clk_disable_unprepare(gphy_fw->clk_gate);
 		return -ENOMEM;
 	}
 
 	release_firmware(fw);
 
 	ret = regmap_write(priv->rcu_regmap, gphy_fw->fw_addr_offset, dev_addr);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(gphy_fw->clk_gate);
 		return ret;
+	}
 
 	reset_control_deassert(gphy_fw->reset);
 
-- 
2.9.5

