Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98A6343384C
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhJSOXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:23:16 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14827 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJSOXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 10:23:07 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HYbPm339Zz90LV;
        Tue, 19 Oct 2021 22:15:56 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:51 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 19 Oct 2021 22:20:51 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 2/8] net: hns3: reset DWRR of unused tc to zero
Date:   Tue, 19 Oct 2021 22:16:29 +0800
Message-ID: <20211019141635.43695-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211019141635.43695-1-huangguangbin2@huawei.com>
References: <20211019141635.43695-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, DWRR of tc will be initialized to a fixed value when this tc
is enabled, but it is not been reset to 0 when this tc is disabled. It
cause a problem that the DWRR of unused tc is not 0 after using tc tool
to add and delete multi-tc parameters.

For examples, after enabling 4 TCs and restoring to 1 TC by follow
tc commands:

$ tc qdisc add dev eth0 root mqprio num_tc 4 map 0 1 2 3 0 1 2 3 queues \
  8@0 8@8 8@16 8@24 hw 1 mode channel
$ tc qdisc del dev eth0 root

Now there is just one TC is enabled for eth0, but the tc info querying by
debugfs is shown as follow:

$ cat /mnt/hns3/0000:7d:00.0/tm/tc_sch_info
enabled tc number: 1
weight_offset: 14
TC    MODE  WEIGHT
0     dwrr    100
1     dwrr    100
2     dwrr    100
3     dwrr    100
4     dwrr      0
5     dwrr      0
6     dwrr      0
7     dwrr      0

This patch fixes it by resetting DWRR of tc to 0 when tc is disabled.

Fixes: 848440544b41 ("net: hns3: Add support of TX Scheduler & Shaper to HNS3 driver")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
index f314dbd3ce11..95074e91a846 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -752,6 +752,8 @@ static void hclge_tm_pg_info_init(struct hclge_dev *hdev)
 		hdev->tm_info.pg_info[i].tc_bit_map = hdev->hw_tc_map;
 		for (k = 0; k < hdev->tm_info.num_tc; k++)
 			hdev->tm_info.pg_info[i].tc_dwrr[k] = BW_PERCENT;
+		for (; k < HNAE3_MAX_TC; k++)
+			hdev->tm_info.pg_info[i].tc_dwrr[k] = 0;
 	}
 }
 
-- 
2.33.0

