Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277793F8666
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 13:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242308AbhHZL0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 07:26:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8779 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242162AbhHZL0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Aug 2021 07:26:43 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GwL9r0wJ0zYtrx;
        Thu, 26 Aug 2021 19:25:20 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:53 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 26 Aug 2021 19:25:52 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 7/7] net: hns3: fix get wrong pfc_en when query PFC configuration
Date:   Thu, 26 Aug 2021 19:22:01 +0800
Message-ID: <1629976921-43438-8-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
References: <1629976921-43438-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when query PFC configuration by dcbtool, driver will return
PFC enable status based on TC. As all priorities are mapped to TC0 by
default, if TC0 is enabled, then all priorities mapped to TC0 will be
shown as enabled status when query PFC setting, even though some
priorities have never been set.

for example:
$ dcb pfc show dev eth0
pfc-cap 4 macsec-bypass off delay 0
prio-pfc 0:off 1:off 2:off 3:off 4:off 5:off 6:off 7:off
$ dcb pfc set dev eth0 prio-pfc 0:on 1:on 2:on 3:on
$ dcb pfc show dev eth0
pfc-cap 4 macsec-bypass off delay 0
prio-pfc 0:on 1:on 2:on 3:on 4:on 5:on 6:on 7:on

To fix this problem, just returns user's PFC config parameter saved in
driver.

Fixes: cacde272dd00 ("net: hns3: Add hclge_dcb module for the support of DCB feature")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
index 5bf5db91d16c..39f56f245d84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.c
@@ -255,21 +255,12 @@ static int hclge_ieee_getpfc(struct hnae3_handle *h, struct ieee_pfc *pfc)
 	u64 requests[HNAE3_MAX_TC], indications[HNAE3_MAX_TC];
 	struct hclge_vport *vport = hclge_get_vport(h);
 	struct hclge_dev *hdev = vport->back;
-	u8 i, j, pfc_map, *prio_tc;
 	int ret;
+	u8 i;
 
 	memset(pfc, 0, sizeof(*pfc));
 	pfc->pfc_cap = hdev->pfc_max;
-	prio_tc = hdev->tm_info.prio_tc;
-	pfc_map = hdev->tm_info.hw_pfc_map;
-
-	/* Pfc setting is based on TC */
-	for (i = 0; i < hdev->tm_info.num_tc; i++) {
-		for (j = 0; j < HNAE3_MAX_USER_PRIO; j++) {
-			if ((prio_tc[j] == i) && (pfc_map & BIT(i)))
-				pfc->pfc_en |= BIT(j);
-		}
-	}
+	pfc->pfc_en = hdev->tm_info.pfc_en;
 
 	ret = hclge_pfc_tx_stats_get(hdev, requests);
 	if (ret)
-- 
2.8.1

