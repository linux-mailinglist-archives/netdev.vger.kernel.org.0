Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAAF6D83B
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 03:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfGSBQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 21:16:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2680 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726072AbfGSBQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jul 2019 21:16:29 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2940B6CDDC014F673A20;
        Fri, 19 Jul 2019 09:16:27 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Fri, 19 Jul 2019 09:16:17 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH v2] ag71xx: fix error return code in ag71xx_probe()
Date:   Fri, 19 Jul 2019 01:21:57 +0000
Message-ID: <20190719012157.100396-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190717115215.22965-1-weiyongjun1@huawei.com>
References: <20190717115215.22965-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return error code -ENOMEM from the dmam_alloc_coherent() error
handling case instead of 0, as done elsewhere in this function.

Fixes: d51b6ce441d3 ("net: ethernet: add ag71xx driver")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
v1 -> v2: fix subsystem prefix
---
 drivers/net/ethernet/atheros/ag71xx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 72a57c6cd254..446d62e93439 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1724,8 +1724,10 @@ static int ag71xx_probe(struct platform_device *pdev)
 	ag->stop_desc = dmam_alloc_coherent(&pdev->dev,
 					    sizeof(struct ag71xx_desc),
 					    &ag->stop_desc_dma, GFP_KERNEL);
-	if (!ag->stop_desc)
+	if (!ag->stop_desc) {
+		err = -ENOMEM;
 		goto err_free;
+	}
 
 	ag->stop_desc->data = 0;
 	ag->stop_desc->ctrl = 0;



