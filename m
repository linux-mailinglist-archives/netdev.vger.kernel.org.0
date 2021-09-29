Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA84A41C1BE
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245140AbhI2Jl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:41:56 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13392 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245099AbhI2Jlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 05:41:51 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HKB7R14Pbz8xwD;
        Wed, 29 Sep 2021 17:35:31 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 17:40:08 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 6/8] net: hns3: PF enable promisc for VF when mac table is overflow
Date:   Wed, 29 Sep 2021 17:35:54 +0800
Message-ID: <20210929093556.9146-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929093556.9146-1-huangguangbin2@huawei.com>
References: <20210929093556.9146-1-huangguangbin2@huawei.com>
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

If unicast mac address table is full, and user add a new mac address, the
unicast promisc needs to be enabled for the new unicast mac address can be
used. So does the multicast promisc.

Now this feature has been implemented for PF, and VF should be implemented
too. When the mac table of VF is overflow, PF will enable promisc for this
VF.

Fixes: 1e6e76101fd9 ("net: hns3: configure promisc mode for VF asynchronously")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 3391244d9d3d..f5b8d1fee0f1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -12796,8 +12796,12 @@ static void hclge_sync_promisc_mode(struct hclge_dev *hdev)
 			continue;
 
 		if (vport->vf_info.trusted) {
-			uc_en = vport->vf_info.request_uc_en > 0;
-			mc_en = vport->vf_info.request_mc_en > 0;
+			uc_en = vport->vf_info.request_uc_en > 0 ||
+				vport->overflow_promisc_flags &
+				HNAE3_OVERFLOW_UPE;
+			mc_en = vport->vf_info.request_mc_en > 0 ||
+				vport->overflow_promisc_flags &
+				HNAE3_OVERFLOW_MPE;
 		}
 		bc_en = vport->vf_info.request_bc_en > 0;
 
-- 
2.33.0

