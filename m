Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081692236ED
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 10:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgGQIV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 04:21:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45222 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbgGQIVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 04:21:55 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 819B289213D0C3FE4821;
        Fri, 17 Jul 2020 16:21:52 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Jul 2020
 16:21:49 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <madalin.bucur@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <laurentiu.tudor@nxp.com>, <netdev@vger.kernel.org>
Subject: [PATCH net-next] dpaa_eth: Fix one possible memleak in dpaa_eth_probe
Date:   Fri, 17 Jul 2020 17:05:28 +0800
Message-ID: <20200717090528.19683-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When dma_coerce_mask_and_coherent() fails, the alloced netdev need to be freed.

Fixes: 060ad66f9795 ("dpaa_eth: change DMA device")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 2972244e6eb0..43570f4911ea 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2938,7 +2938,7 @@ static int dpaa_eth_probe(struct platform_device *pdev)
 						   DMA_BIT_MASK(40));
 	if (err) {
 		netdev_err(net_dev, "dma_coerce_mask_and_coherent() failed\n");
-		return err;
+		goto free_netdev;
 	}
 
 	/* If fsl_fm_max_frm is set to a higher value than the all-common 1500,
-- 
2.17.1

