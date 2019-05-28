Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48FE32C285
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 11:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfE1JFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 05:05:42 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:17611 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727458AbfE1JEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 05:04:38 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6ACB1E1CDEA6B55D122F;
        Tue, 28 May 2019 17:04:36 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Tue, 28 May 2019 17:04:28 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, Huazhong Tan <tanhuazhong@huawei.com>,
        Peng Li <lipeng321@huawei.com>
Subject: [PATCH net-next 11/12] net: hns3: adjust hns3_uninit_phy()'s location in the hns3_client_uninit()
Date:   Tue, 28 May 2019 17:03:01 +0800
Message-ID: <1559034182-24737-12-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
References: <1559034182-24737-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hns3_uninit_phy() should be called before checking
HNS3_NIC_STATE_INITED flags, otherwise when this checking fails,
there is nobody to call hns3_uninit_phy().

Fixes: c8a8045b2d0a ("net: hns3: Fix NULL deref when unloading driver")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 5e12705..f6dc305 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -3901,6 +3901,8 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_client_stop(handle);
 
+	hns3_uninit_phy(netdev);
+
 	if (!test_and_clear_bit(HNS3_NIC_STATE_INITED, &priv->state)) {
 		netdev_warn(netdev, "already uninitialized\n");
 		goto out_netdev_free;
@@ -3910,8 +3912,6 @@ static void hns3_client_uninit(struct hnae3_handle *handle, bool reset)
 
 	hns3_force_clear_all_rx_ring(handle);
 
-	hns3_uninit_phy(netdev);
-
 	hns3_nic_uninit_vector_data(priv);
 
 	ret = hns3_nic_dealloc_vector_data(priv);
-- 
2.7.4

