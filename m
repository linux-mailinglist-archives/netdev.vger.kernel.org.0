Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9417215660
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 13:28:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgGFL16 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 07:27:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59686 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728943AbgGFL15 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 07:27:57 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 9B33FECF6DC5A044E1B;
        Mon,  6 Jul 2020 19:27:55 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Mon, 6 Jul 2020 19:27:46 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 1/4] net: hns3: check reset pending after FLR prepare
Date:   Mon, 6 Jul 2020 19:25:59 +0800
Message-ID: <1594034762-6445-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594034762-6445-1-git-send-email-tanhuazhong@huawei.com>
References: <1594034762-6445-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there is a PF reset pending before FLR prepare, FLR's
preparatory work will not fail, but the FLR rebuild procedure
will fail for this pending. So this PF reset pending should
be handled in the FLR preparatory.

Fixes: 8627bdedc435 ("net: hns3: refactor the precedure of PF FLR")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 96bfad5..d6bfdc6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9859,7 +9859,7 @@ static void hclge_flr_prepare(struct hnae3_ae_dev *ae_dev)
 	set_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
 	hdev->reset_type = HNAE3_FLR_RESET;
 	ret = hclge_reset_prepare(hdev);
-	if (ret) {
+	if (ret || hdev->reset_pending) {
 		dev_err(&hdev->pdev->dev, "fail to prepare FLR, ret=%d\n",
 			ret);
 		if (hdev->reset_pending ||
-- 
2.7.4

