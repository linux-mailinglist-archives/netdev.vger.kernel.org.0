Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 706AF3FA41F
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 09:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233476AbhH1HAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 03:00:30 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9378 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbhH1HAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Aug 2021 03:00:09 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GxS564Zc6z8vxh;
        Sat, 28 Aug 2021 14:55:06 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:14 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 28 Aug 2021 14:59:13 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net-next 5/7] net: hns3: don't config TM DWRR twice when set ETS
Date:   Sat, 28 Aug 2021 14:55:19 +0800
Message-ID: <1630133721-9260-6-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
References: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function hclge_tm_dwrr_cfg() will be called twice in function
hclge_ieee_setets() when map_changed is true, the calling flow is
hclge_ieee_setets()
    hclge_map_update()
    |   hclge_tm_schd_setup_hw()
    |       hclge_tm_dwrr_cfg()
    hclge_notify_init_up()
    hclge_tm_dwrr_cfg()

It is no need to call hclge_tm_dwrr_cfg() twice actually, so just
return after calling hclge_notify_init_up().

Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 39f56f245d84..127160416ca6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -234,9 +234,7 @@ static int hclge_ieee_setets(struct hnae3_handle *h, struct ieee_ets *ets)
 		if (ret)
 			goto err_out;
 
-		ret = hclge_notify_init_up(hdev);
-		if (ret)
-			return ret;
+		return hclge_notify_init_up(hdev);
 	}
 
 	return hclge_tm_dwrr_cfg(hdev);
-- 
2.8.1

