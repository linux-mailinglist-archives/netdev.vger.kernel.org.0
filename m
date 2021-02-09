Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7B0314B28
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbhBIJKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:10:44 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12156 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhBIJFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 04:05:12 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DZcN81pb6zlHyZ;
        Tue,  9 Feb 2021 17:02:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Tue, 9 Feb 2021 17:03:54 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Yufeng Mo <moyufeng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 3/3] net: hns3: add a check for index in hclge_get_rss_key()
Date:   Tue, 9 Feb 2021 17:03:07 +0800
Message-ID: <1612861387-35858-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612861387-35858-1-git-send-email-tanhuazhong@huawei.com>
References: <1612861387-35858-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The index is received from vf, if use it directly,
an out-of-bound issue may be caused, so add a check for
this index before using it in hclge_get_rss_key().

Fixes: a638b1d8cc87 ("net: hns3: fix get VF RSS issue")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index ea2dea99..ffb416e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -607,6 +607,17 @@ static void hclge_get_rss_key(struct hclge_vport *vport,
 
 	index = mbx_req->msg.data[0];
 
+	/* Check the query index of rss_hash_key from VF, make sure no
+	 * more than the size of rss_hash_key.
+	 */
+	if (((index + 1) * HCLGE_RSS_MBX_RESP_LEN) >
+	      sizeof(vport[0].rss_hash_key)) {
+		dev_warn(&hdev->pdev->dev,
+			 "failed to get the rss hash key, the index(%u) invalid !\n",
+			 index);
+		return;
+	}
+
 	memcpy(resp_msg->data,
 	       &hdev->vport[0].rss_hash_key[index * HCLGE_RSS_MBX_RESP_LEN],
 	       HCLGE_RSS_MBX_RESP_LEN);
-- 
2.7.4

