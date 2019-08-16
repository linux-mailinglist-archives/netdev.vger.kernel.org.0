Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21D98FD5E
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 10:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfHPIMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 04:12:13 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50780 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726826AbfHPIML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 04:12:11 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 6E27AB6E25FBFAEFDB64;
        Fri, 16 Aug 2019 16:11:58 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Fri, 16 Aug 2019 16:11:49 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 5/6] net: hns3: prevent unnecessary MAC TNL interrupt
Date:   Fri, 16 Aug 2019 16:09:41 +0800
Message-ID: <1565942982-12105-6-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
References: <1565942982-12105-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MAC TNL interrupt is used to collect statistic info about
link status changing suddenly when netdev is running.

But when stopping netdev, the enabled MAC TNL interrupt is
unnecessary, and may add some noises to the statistic info.
So this patch disables it before stopping MAC.

Fixes: a63457878b12 ("net: hns3: Add handling of MAC tunnel interruption")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 24b59f0..9d64c43 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6380,6 +6380,8 @@ static void hclge_ae_stop(struct hnae3_handle *handle)
 	for (i = 0; i < handle->kinfo.num_tqps; i++)
 		hclge_reset_tqp(handle, i);
 
+	hclge_config_mac_tnl_int(hdev, false);
+
 	/* Mac disable */
 	hclge_cfg_mac_mode(hdev, false);
 
-- 
2.7.4

