Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B79740C6D0
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 15:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237688AbhION5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 09:57:41 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:16214 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234729AbhION5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 09:57:38 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4H8hYZ3sDFz1DGv5;
        Wed, 15 Sep 2021 21:55:14 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:15 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 21:56:14 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 2/6] net: hns3: fix inconsistent vf id print
Date:   Wed, 15 Sep 2021 21:52:07 +0800
Message-ID: <20210915135211.9129-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915135211.9129-1-huangguangbin2@huawei.com>
References: <20210915135211.9129-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

The vf id from ethtool is added 1 before configured to driver.
So it's necessary to minus 1 when printing it, in order to
keep consistent with user's configuration.

Fixes: dd74f815dd41 ("net: hns3: Add support for rule add/delete for flow director")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 36c8741445e8..c0f25ea043b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6642,10 +6642,13 @@ static int hclge_fd_parse_ring_cookie(struct hclge_dev *hdev, u64 ring_cookie,
 		u8 vf = ethtool_get_flow_spec_ring_vf(ring_cookie);
 		u16 tqps;
 
+		/* To keep consistent with user's configuration, minus 1 when
+		 * printing 'vf', because vf id from ethtool is added 1 for vf.
+		 */
 		if (vf > hdev->num_req_vfs) {
 			dev_err(&hdev->pdev->dev,
-				"Error: vf id (%u) > max vf num (%u)\n",
-				vf, hdev->num_req_vfs);
+				"Error: vf id (%u) should be less than %u\n",
+				vf - 1, hdev->num_req_vfs);
 			return -EINVAL;
 		}
 
-- 
2.33.0

