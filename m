Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E90C6BBC1
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 13:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfGQLqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 07:46:53 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55050 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725799AbfGQLqx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 07:46:53 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C45BA55E9D25C549D78B;
        Wed, 17 Jul 2019 19:46:45 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Wed, 17 Jul 2019 19:46:38 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] net: ag71xx: fix return value check in ag71xx_probe()
Date:   Wed, 17 Jul 2019 11:52:25 +0000
Message-ID: <20190717115225.23047-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of error, the function of_get_mac_address() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check should
be replaced with IS_ERR().

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/atheros/ag71xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 72a57c6cd254..3088a43e6436 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1732,9 +1732,9 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag->stop_desc->next = (u32)ag->stop_desc_dma;
 
 	mac_addr = of_get_mac_address(np);
-	if (mac_addr)
+	if (!IS_ERR(mac_addr))
 		memcpy(ndev->dev_addr, mac_addr, ETH_ALEN);
-	if (!mac_addr || !is_valid_ether_addr(ndev->dev_addr)) {
+	if (IS_ERR(mac_addr) || !is_valid_ether_addr(ndev->dev_addr)) {
 		netif_err(ag, probe, ndev, "invalid MAC address, using random address\n");
 		eth_random_addr(ndev->dev_addr);
 	}



