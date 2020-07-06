Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA7921565A
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 13:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729012AbgGFL17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 07:27:59 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:59682 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728946AbgGFL16 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 07:27:58 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 95ACA980027EC2B21D8E;
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
Subject: [PATCH net 2/4] net: hns3: fix for mishandle of asserting VF reset fail
Date:   Mon, 6 Jul 2020 19:26:00 +0800
Message-ID: <1594034762-6445-3-git-send-email-tanhuazhong@huawei.com>
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

When asserts VF reset fail, flag HCLGEVF_STATE_CMD_DISABLE
and handshake status should not set, otherwise the retry will
fail. So adds a check for asserting VF reset and returns
directly when fails.

Fixes: ef5f8e507ec9 ("net: hns3: stop handling command queue while resetting VF")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 1b9578d..a10b022 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1793,6 +1793,11 @@ static int hclgevf_reset_prepare_wait(struct hclgevf_dev *hdev)
 	if (hdev->reset_type == HNAE3_VF_FUNC_RESET) {
 		hclgevf_build_send_msg(&send_msg, HCLGE_MBX_RESET, 0);
 		ret = hclgevf_send_mbx_msg(hdev, &send_msg, true, NULL, 0);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"failed to assert VF reset, ret = %d\n", ret);
+			return ret;
+		}
 		hdev->rst_stats.vf_func_rst_cnt++;
 	}
 
-- 
2.7.4

