Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD3845ED96
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 13:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377411AbhKZMNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 07:13:15 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:31911 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377469AbhKZMLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 07:11:11 -0500
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4J0tmS0K2tzcbXN;
        Fri, 26 Nov 2021 20:07:52 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 20:07:55 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 26 Nov 2021 20:07:54 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 1/4] net: hns3: fix VF RSS failed problem after PF enable multi-TCs
Date:   Fri, 26 Nov 2021 20:03:15 +0800
Message-ID: <20211126120318.33921-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126120318.33921-1-huangguangbin2@huawei.com>
References: <20211126120318.33921-1-huangguangbin2@huawei.com>
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

When PF is set to multi-TCs and configured mapping relationship between
priorities and TCs, the hardware will active these settings for this PF
and its VFs.

In this case when VF just uses one TC and its rx packets contain priority,
and if the priority is not mapped to TC0, as other TCs of VF is not valid,
hardware always put this kind of packets to the queue 0. It cause this kind
of packets of VF can not be used RSS function.

To fix this problem, set tc mode of all unused TCs of VF to the setting of
TC0, then rx packet with priority which map to unused TC will be direct to
TC0.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 25c419d40066..41afaeea881b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -703,9 +703,9 @@ static int hclgevf_set_rss_tc_mode(struct hclgevf_dev *hdev,  u16 rss_size)
 	roundup_size = ilog2(roundup_size);
 
 	for (i = 0; i < HCLGEVF_MAX_TC_NUM; i++) {
-		tc_valid[i] = !!(hdev->hw_tc_map & BIT(i));
+		tc_valid[i] = 1;
 		tc_size[i] = roundup_size;
-		tc_offset[i] = rss_size * i;
+		tc_offset[i] = (hdev->hw_tc_map & BIT(i)) ? rss_size * i : 0;
 	}
 
 	hclgevf_cmd_setup_basic_desc(&desc, HCLGEVF_OPC_RSS_TC_MODE, false);
-- 
2.33.0

