Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97F52DA47D
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 01:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgLOABd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 19:01:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41073 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726618AbgLOABX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 19:01:23 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1koxla-0004B0-LB; Tue, 15 Dec 2020 00:00:34 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Jian Shen <shenjian15@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: hns3: fix expression that is currently always true
Date:   Tue, 15 Dec 2020 00:00:33 +0000
Message-Id: <20201215000033.85383-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The ||  condition in hdev->fd_active_type != HCLGE_FD_ARFS_ACTIVE ||
hdev->fd_active_type != HCLGE_FD_RULE_NONE will always be true because
hdev->fd_active_type cannot be equal to two different values at the same
time. The expression is always true which is not correct. Fix this by
replacing || with && to correct the logic in the expression.

Addresses-Coverity: ("Constant expression result")
Fixes: 0205ec041ec6 ("net: hns3: add support for hw tc offload of tc flower")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7a164115c845..e6f37f91c489 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6485,7 +6485,7 @@ static int hclge_add_fd_entry_by_arfs(struct hnae3_handle *handle, u16 queue_id,
 	 * arfs should not work
 	 */
 	spin_lock_bh(&hdev->fd_rule_lock);
-	if (hdev->fd_active_type != HCLGE_FD_ARFS_ACTIVE ||
+	if (hdev->fd_active_type != HCLGE_FD_ARFS_ACTIVE &&
 	    hdev->fd_active_type != HCLGE_FD_RULE_NONE) {
 		spin_unlock_bh(&hdev->fd_rule_lock);
 		return -EOPNOTSUPP;
-- 
2.29.2

