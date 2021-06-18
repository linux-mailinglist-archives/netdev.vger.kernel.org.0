Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57963ACAAA
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 14:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhFRMPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 08:15:11 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7489 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbhFRMPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 08:15:11 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G5yRG4hrzzZjjq;
        Fri, 18 Jun 2021 20:10:02 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 20:12:58 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Fri, 18 Jun 2021 20:12:58 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next] net: hns3: fix reuse conflict of the rx page
Date:   Fri, 18 Jun 2021 20:09:45 +0800
Message-ID: <1624018185-38469-1-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

In the current rx page reuse handling process, the rx page buffer may
have conflict between driver and stack in high-pressure scenario.

To fix this problem, we need to check whether the page is only owned
by driver at the begin and at the end of a page to make sure there is
no reuse conflict between driver and stack when desc_cb->page_offset
is rollbacked to zero or increased.

Fixes: fa7711b888f2 ("net: hns3: optimize the rx page reuse handling process")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 26 ++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 51bbf5f760c5..cdb5f14fb6bc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3537,21 +3537,33 @@ static void hns3_nic_reuse_page(struct sk_buff *skb, int i,
 	int size = le16_to_cpu(desc->rx.size);
 	u32 truesize = hns3_buf_size(ring);
 	u32 frag_size = size - pull_len;
+	bool reused;
 
 	/* Avoid re-using remote or pfmem page */
 	if (unlikely(!dev_page_is_reusable(desc_cb->priv)))
 		goto out;
 
-	/* Stack is not using and current page_offset is non-zero, we can
-	 * reuse from the zero offset.
+	reused = hns3_can_reuse_page(desc_cb);
+
+	/* Rx page can be reused when:
+	 * 1. Rx page is only owned by the driver when page_offset
+	 *    is zero, which means 0 @ truesize will be used by
+	 *    stack after skb_add_rx_frag() is called, and the rest
+	 *    of rx page can be reused by driver.
+	 * Or
+	 * 2. Rx page is only owned by the driver when page_offset
+	 *    is non-zero, which means page_offset @ truesize will
+	 *    be used by stack after skb_add_rx_frag() is called,
+	 *    and 0 @ truesize can be reused by driver.
 	 */
-	if (desc_cb->page_offset && hns3_can_reuse_page(desc_cb)) {
-		desc_cb->page_offset = 0;
-		desc_cb->reuse_flag = 1;
-	} else if (desc_cb->page_offset + truesize * 2 <=
-		   hns3_page_size(ring)) {
+	if ((!desc_cb->page_offset && reused) ||
+	    ((desc_cb->page_offset + truesize + truesize) <=
+	     hns3_page_size(ring) && desc_cb->page_offset)) {
 		desc_cb->page_offset += truesize;
 		desc_cb->reuse_flag = 1;
+	} else if (desc_cb->page_offset && reused) {
+		desc_cb->page_offset = 0;
+		desc_cb->reuse_flag = 1;
 	} else if (frag_size <= ring->rx_copybreak) {
 		void *frag = napi_alloc_frag(frag_size);
 
-- 
2.8.1

