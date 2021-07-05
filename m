Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351073BB52E
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 04:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhGECkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 22:40:33 -0400
Received: from m12-17.163.com ([220.181.12.17]:40525 "EHLO m12-17.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229652AbhGECkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Jul 2021 22:40:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=KArCps4OywHghZ+yT1
        h8OdtuuvpvtFsIa5UE6bF8H2M=; b=Sv4+QyMldEoXIJk+b+XEaJfDPHxUsit9XC
        WqZmqFmqmJu2gvgyz5fAxDOfFZSYj7mQ8KHd56xPlM4h0efBEEoYYZQlIzEEqFjs
        OwZ4DW2OXjhO3CvhtoiF5C2WIhTM0U3S3aAKMbSKJsc/L+QuIdtIsbSOPc/9gMx0
        bHJB9jdBo=
Received: from wengjianfeng.ccdomain.com (unknown [218.17.89.92])
        by smtp13 (Coremail) with SMTP id EcCowABnb5drcOJgrUmD_A--.35062S2;
        Mon, 05 Jul 2021 10:37:33 +0800 (CST)
From:   samirweng1979 <samirweng1979@163.com>
To:     ajay.kathat@microchip.com, claudiu.beznea@microchip.com,
        kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
Subject: [PATCH] wilc1000: remove redundant code
Date:   Mon,  5 Jul 2021 10:37:31 +0800
Message-Id: <20210705023731.31496-1-samirweng1979@163.com>
X-Mailer: git-send-email 2.15.0.windows.1
X-CM-TRANSID: EcCowABnb5drcOJgrUmD_A--.35062S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZFWxCrW8uF1xKrW5Cr1rJFb_yoW5CrWUpa
        1UZrWDtryDtw4kCas3JFs5uFnYyryDt3yxWFWkGa4fZF4Iyr1ktrn3JFW0gr4kCF93A343
        Xr40yrWkJFyrWFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bj7KsUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: pvdpx25zhqwiqzxzqiywtou0bp/xtbBLA7GsV++MbyVyAAAsk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wengjianfeng <wengjianfeng@yulong.com>

Some of the code is redundant, so goto statements are used to remove them

Signed-off-by: wengjianfeng <wengjianfeng@yulong.com>
---
 drivers/net/wireless/microchip/wilc1000/wlan.c | 38 +++++++++++---------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 2030fc7..200a103 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1127,27 +1127,22 @@ int wilc_wlan_start(struct wilc *wilc)
 	}
 	acquire_bus(wilc, WILC_BUS_ACQUIRE_ONLY);
 	ret = wilc->hif_func->hif_write_reg(wilc, WILC_VMM_CORE_CFG, reg);
-	if (ret) {
-		release_bus(wilc, WILC_BUS_RELEASE_ONLY);
-		return ret;
-	}
+	if (ret)
+		goto release;
+
 	reg = 0;
 	if (wilc->io_type == WILC_HIF_SDIO && wilc->dev_irq_num)
 		reg |= WILC_HAVE_SDIO_IRQ_GPIO;
 
 	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GP_REG_1, reg);
-	if (ret) {
-		release_bus(wilc, WILC_BUS_RELEASE_ONLY);
-		return ret;
-	}
+	if (ret)
+		goto release;
 
 	wilc->hif_func->hif_sync_ext(wilc, NUM_INT_EXT);
 
 	ret = wilc->hif_func->hif_read_reg(wilc, WILC_CHIPID, &chipid);
-	if (ret) {
-		release_bus(wilc, WILC_BUS_RELEASE_ONLY);
-		return ret;
-	}
+	if (ret)
+		goto release;
 
 	wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
 	if ((reg & BIT(10)) == BIT(10)) {
@@ -1159,8 +1154,9 @@ int wilc_wlan_start(struct wilc *wilc)
 	reg |= BIT(10);
 	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GLB_RESET_0, reg);
 	wilc->hif_func->hif_read_reg(wilc, WILC_GLB_RESET_0, &reg);
-	release_bus(wilc, WILC_BUS_RELEASE_ONLY);
 
+release:
+	release_bus(wilc, WILC_BUS_RELEASE_ONLY);
 	return ret;
 }
 
@@ -1174,36 +1170,34 @@ int wilc_wlan_stop(struct wilc *wilc, struct wilc_vif *vif)
 	ret = wilc->hif_func->hif_read_reg(wilc, WILC_GP_REG_0, &reg);
 	if (ret) {
 		netdev_err(vif->ndev, "Error while reading reg\n");
-		release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
-		return ret;
+		goto release;
 	}
 
 	ret = wilc->hif_func->hif_write_reg(wilc, WILC_GP_REG_0,
 					(reg | WILC_ABORT_REQ_BIT));
 	if (ret) {
 		netdev_err(vif->ndev, "Error while writing reg\n");
-		release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
-		return ret;
+		goto release;
 	}
 
 	ret = wilc->hif_func->hif_read_reg(wilc, WILC_FW_HOST_COMM, &reg);
 	if (ret) {
 		netdev_err(vif->ndev, "Error while reading reg\n");
-		release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
-		return ret;
+		goto release;
 	}
 	reg = BIT(0);
 
 	ret = wilc->hif_func->hif_write_reg(wilc, WILC_FW_HOST_COMM, reg);
 	if (ret) {
 		netdev_err(vif->ndev, "Error while writing reg\n");
-		release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
-		return ret;
+		goto release;
 	}
 
+	ret = 0;
+release:
 	release_bus(wilc, WILC_BUS_RELEASE_ALLOW_SLEEP);
 
-	return 0;
+	return ret;
 }
 
 void wilc_wlan_cleanup(struct net_device *dev)
-- 
1.9.1


