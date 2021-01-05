Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFCD72EA3F8
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 04:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbhAEDix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 22:38:53 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9667 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbhAEDiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 22:38:52 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4D8yqJ2nYWz15p06;
        Tue,  5 Jan 2021 11:37:16 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.498.0; Tue, 5 Jan 2021 11:38:03 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <kuba@kernel.org>,
        <huangdaode@huawei.com>, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net 1/3] net: hns3: fix a phy loopback fail issue
Date:   Tue, 5 Jan 2021 11:37:26 +0800
Message-ID: <1609817848-47370-2-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1609817848-47370-1-git-send-email-tanhuazhong@huawei.com>
References: <1609817848-47370-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

When phy driver does not implement the set_loopback interface,
phy loopback test will return -EOPNOTSUPP, and the loopback test
will fail. So when phy driver does not implement the set_loopback
interface, don't do phy loopback test.

Fixes: c9765a89d142 ("net: hns3: add phy selftest function")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index e6f37f9..135bd0a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -752,7 +752,8 @@ static int hclge_get_sset_count(struct hnae3_handle *handle, int stringset)
 		handle->flags |= HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK;
 		handle->flags |= HNAE3_SUPPORT_SERDES_PARALLEL_LOOPBACK;
 
-		if (hdev->hw.mac.phydev) {
+		if (hdev->hw.mac.phydev && hdev->hw.mac.phydev->drv &&
+		    hdev->hw.mac.phydev->drv->set_loopback) {
 			count += 1;
 			handle->flags |= HNAE3_SUPPORT_PHY_LOOPBACK;
 		}
-- 
2.7.4

