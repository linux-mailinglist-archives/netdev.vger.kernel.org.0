Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E46A4A2AEE
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 02:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352007AbiA2BPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 20:15:30 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17830 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234324AbiA2BP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 20:15:29 -0500
Received: from canpemm500009.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JlxDY0cSsz9sRN;
        Sat, 29 Jan 2022 09:14:05 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 canpemm500009.china.huawei.com (7.192.105.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Sat, 29 Jan 2022 09:15:26 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] net/fsl: xgmac_mdio: fix return value check in xgmac_mdio_probe()
Date:   Sat, 29 Jan 2022 01:27:02 +0000
Message-ID: <20220129012702.3220704-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500009.china.huawei.com (7.192.105.203)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case of error, the function devm_ioremap() returns NULL pointer
not ERR_PTR(). The IS_ERR() test in the return value check should
be replaced with NULL test.

Fixes: 1d14eb15dc2c ("net/fsl: xgmac_mdio: Use managed device resources")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/freescale/xgmac_mdio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/xgmac_mdio.c b/drivers/net/ethernet/freescale/xgmac_mdio.c
index d38d0c372585..264162049c6d 100644
--- a/drivers/net/ethernet/freescale/xgmac_mdio.c
+++ b/drivers/net/ethernet/freescale/xgmac_mdio.c
@@ -335,8 +335,8 @@ static int xgmac_mdio_probe(struct platform_device *pdev)
 	priv = bus->priv;
 	priv->mdio_base = devm_ioremap(&pdev->dev, res->start,
 				       resource_size(res));
-	if (IS_ERR(priv->mdio_base))
-		return PTR_ERR(priv->mdio_base);
+	if (!priv->mdio_base)
+		return -ENOMEM;
 
 	/* For both ACPI and DT cases, endianness of MDIO controller
 	 * needs to be specified using "little-endian" property.

