Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC3B23BB2B
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 15:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgHDN2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 09:28:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:56400 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725811AbgHDN2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 09:28:34 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 56585A9BC0901C135BB1;
        Tue,  4 Aug 2020 21:28:24 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Tue, 4 Aug 2020
 21:28:13 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <ioana.ciornei@nxp.com>, <ruxandra.radulescu@nxp.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] dpaa2-eth: Fix passing zero to 'PTR_ERR' warning
Date:   Tue, 4 Aug 2020 21:26:43 +0800
Message-ID: <20200804132643.42104-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix smatch warning:

drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c:2419
 alloc_channel() warn: passing zero to 'ERR_PTR'

setup_dpcon() should return ERR_PTR(err) instead of zero in error
handling case.

Fixes: d7f5a9d89a55 ("dpaa2-eth: defer probe on object allocate")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 9b4028c0e34c..5f680b953a90 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2375,7 +2375,7 @@ static struct fsl_mc_device *setup_dpcon(struct dpaa2_eth_priv *priv)
 free:
 	fsl_mc_object_free(dpcon);
 
-	return NULL;
+	return ERR_PTR(err);
 }
 
 static void free_dpcon(struct dpaa2_eth_priv *priv,
@@ -2399,8 +2399,8 @@ alloc_channel(struct dpaa2_eth_priv *priv)
 		return NULL;
 
 	channel->dpcon = setup_dpcon(priv);
-	if (IS_ERR_OR_NULL(channel->dpcon)) {
-		err = PTR_ERR_OR_ZERO(channel->dpcon);
+	if (IS_ERR(channel->dpcon)) {
+		err = PTR_ERR(channel->dpcon);
 		goto err_setup;
 	}
 
-- 
2.17.1


