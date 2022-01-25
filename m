Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741EF49AD37
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442727AbiAYHKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:10:45 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:17805 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377695AbiAYHIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 02:08:24 -0500
Received: from kwepemi500003.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JjdFf65y5z9sS2;
        Tue, 25 Jan 2022 15:07:02 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500003.china.huawei.com (7.221.188.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 15:08:21 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 25 Jan 2022 15:08:21 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net] net: hns3: handle empty unknown interrupt for VF
Date:   Tue, 25 Jan 2022 15:03:12 +0800
Message-ID: <20220125070312.53945-1-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
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

From: Yufeng Mo <moyufeng@huawei.com>

Since some interrupt states may be cleared by hardware, the driver
may receive an empty interrupt. Currently, the VF driver directly
disables the vector0 interrupt in this case. As a result, the VF
is unavailable. Therefore, the vector0 interrupt should be enabled
in this case.

Fixes: b90fcc5bd904 ("net: hns3: add reset handling for VF when doing Core/Global/IMP reset")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 7df87610ad96..21442a9bb996 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2043,8 +2043,7 @@ static irqreturn_t hclgevf_misc_irq_handle(int irq, void *data)
 		break;
 	}
 
-	if (event_cause != HCLGEVF_VECTOR0_EVENT_OTHER)
-		hclgevf_enable_vector(&hdev->misc_vector, true);
+	hclgevf_enable_vector(&hdev->misc_vector, true);
 
 	return IRQ_HANDLED;
 }
-- 
2.33.0

