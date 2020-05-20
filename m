Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887D21DA8A8
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 05:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgETDiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 23:38:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4821 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726352AbgETDiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 23:38:05 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 0C31F2F45DC2F7886A89;
        Wed, 20 May 2020 11:38:04 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Wed, 20 May 2020 11:37:57 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <netdev@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Colin Ian King <colin.king@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Wei Yongjun <weiyongjun1@huawei.com>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH 2/2 v3] net: ethernet: ti: am65-cpsw-nuss: fix error handling of am65_cpsw_nuss_probe
Date:   Wed, 20 May 2020 11:41:16 +0800
Message-ID: <20200520034116.170946-3-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200520034116.170946-1-weiyongjun1@huawei.com>
References: <20200520034116.170946-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert to using IS_ERR() instead of NULL test for cpsw_ale_create()
error handling. Also fix to return negative error code from this error
handling case instead of 0 in.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 2517ffba8178..88f52a2f85b3 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1895,8 +1895,9 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	ale_params.nu_switch_ale = true;
 
 	common->ale = cpsw_ale_create(&ale_params);
-	if (!common->ale) {
+	if (IS_ERR(common->ale)) {
 		dev_err(dev, "error initializing ale engine\n");
+		ret = PTR_ERR(common->ale);
 		goto err_of_clear;
 	}
 
-- 
2.25.1

