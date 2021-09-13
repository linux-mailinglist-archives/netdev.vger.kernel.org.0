Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 661CE408C2B
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239603AbhIMNOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:14:01 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9861 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238633AbhIMNNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:13:50 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H7Rc52pTNz8xry;
        Mon, 13 Sep 2021 21:08:05 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:30 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:29 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 6/6] net: hns3: fix the timing issue of VF clearing interrupt sources
Date:   Mon, 13 Sep 2021 21:08:25 +0800
Message-ID: <20210913130825.27025-7-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130825.27025-1-huangguangbin2@huawei.com>
References: <20210913130825.27025-1-huangguangbin2@huawei.com>
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

From: Jiaran Zhang <zhangjiaran@huawei.com>

Currently, the VF does not clear the interrupt source immediately after
receiving the interrupt. As a result, if the second interrupt task is
triggered when processing the first interrupt task, clearing the
interrupt source before exiting will clear the interrupt sources of the
two tasks at the same time. As a result, no interrupt is triggered for
the second task. The VF detects the missed message only when the next
interrupt is generated.

Clearing it immediately after executing check_evt_cause ensures that:
1. Even if two interrupt tasks are triggered at the same time, they can
be processed.
2. If the second task is triggered during the processing of the first
task and the interrupt source is not cleared, the interrupt is reported
after vector0 is enabled.

Fixes: b90fcc5bd904 ("net: hns3: add reset handling for VF when doing Core/Global/IMP reset")
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 82e727020120..a69e892277b3 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2465,6 +2465,8 @@ static irqreturn_t hclgevf_misc_irq_handle(int irq, void *data)
 
 	hclgevf_enable_vector(&hdev->misc_vector, false);
 	event_cause = hclgevf_check_evt_cause(hdev, &clearval);
+	if (event_cause != HCLGEVF_VECTOR0_EVENT_OTHER)
+		hclgevf_clear_event_cause(hdev, clearval);
 
 	switch (event_cause) {
 	case HCLGEVF_VECTOR0_EVENT_RST:
@@ -2477,10 +2479,8 @@ static irqreturn_t hclgevf_misc_irq_handle(int irq, void *data)
 		break;
 	}
 
-	if (event_cause != HCLGEVF_VECTOR0_EVENT_OTHER) {
-		hclgevf_clear_event_cause(hdev, clearval);
+	if (event_cause != HCLGEVF_VECTOR0_EVENT_OTHER)
 		hclgevf_enable_vector(&hdev->misc_vector, true);
-	}
 
 	return IRQ_HANDLED;
 }
-- 
2.33.0

