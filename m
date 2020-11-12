Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0186D2B07FB
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 15:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbgKLO70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 09:59:26 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7527 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgKLO70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 09:59:26 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CX4W22t36zhjsj;
        Thu, 12 Nov 2020 22:59:10 +0800 (CST)
Received: from localhost (10.174.176.180) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Nov 2020
 22:59:10 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <simon.horman@netronome.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <yuehaibing@huawei.com>
CC:     <oss-drivers@netronome.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] nfp: Fix passing zero to 'PTR_ERR'
Date:   Thu, 12 Nov 2020 22:58:52 +0800
Message-ID: <20201112145852.6580-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.176.180]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nfp_cpp_from_nfp6000_pcie() returns ERR_PTR() and never returns
NULL. The NULL test should be removed, also return correct err.

Fixes: 63461a028f76 ("nfp: add the PF driver")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_main.c b/drivers/net/ethernet/netronome/nfp/nfp_main.c
index 7ff2ccbd43b0..e672614d2906 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_main.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_main.c
@@ -724,10 +724,8 @@ static int nfp_pci_probe(struct pci_dev *pdev,
 	}
 
 	pf->cpp = nfp_cpp_from_nfp6000_pcie(pdev);
-	if (IS_ERR_OR_NULL(pf->cpp)) {
+	if (IS_ERR(pf->cpp)) {
 		err = PTR_ERR(pf->cpp);
-		if (err >= 0)
-			err = -ENOMEM;
 		goto err_disable_msix;
 	}
 
-- 
2.17.1

