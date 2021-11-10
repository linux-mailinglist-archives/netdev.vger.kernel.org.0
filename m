Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3204C44C269
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbhKJNuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:50:23 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:26299 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbhKJNuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:50:17 -0500
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Hq5d83XHfzbhlw;
        Wed, 10 Nov 2021 21:42:36 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:26 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:26 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 6/8] net: hns3: fix some mac statistics is always 0 in device version V2
Date:   Wed, 10 Nov 2021 21:42:54 +0800
Message-ID: <20211110134256.25025-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211110134256.25025-1-huangguangbin2@huawei.com>
References: <20211110134256.25025-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When driver queries the register number of mac statistics from firmware,
the old firmware runs in device version V2 only returns number of valid
registers, not include number of three reserved registers among of them.
It cause driver doesn't record the last three data when query mac
statistics.

To fix this problem, driver never query register number in device version
V2 and set it to a fixed value which include three reserved registers.

Fixes: c8af2887c941 ("net: hns3: add support pause/pfc durations for mac statistics")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 10 ++++++++++
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h    |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 21aec4e470cf..de9cadf9b9f3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -566,6 +566,16 @@ static int hclge_mac_query_reg_num(struct hclge_dev *hdev, u32 *reg_num)
 	struct hclge_desc desc;
 	int ret;
 
+	/* Driver needs total register number of both valid registers and
+	 * reserved registers, but the old firmware only returns number
+	 * of valid registers in device V2. To be compatible with these
+	 * devices, driver uses a fixed value.
+	 */
+	if (hdev->ae_dev->dev_version == HNAE3_DEVICE_VERSION_V2) {
+		*reg_num = HCLGE_MAC_STATS_MAX_NUM_V1;
+		return 0;
+	}
+
 	hclge_cmd_setup_basic_desc(&desc, HCLGE_OPC_QUERY_MAC_REG_NUM, true);
 	ret = hclge_cmd_send(&hdev->hw, &desc, 1);
 	if (ret) {
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 3c95c957d1e3..ebba603483a0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -404,7 +404,7 @@ struct hclge_tm_info {
 };
 
 /* max number of mac statistics on each version */
-#define HCLGE_MAC_STATS_MAX_NUM_V1		84
+#define HCLGE_MAC_STATS_MAX_NUM_V1		87
 #define HCLGE_MAC_STATS_MAX_NUM_V2		105
 
 struct hclge_comm_stats_str {
-- 
2.33.0

