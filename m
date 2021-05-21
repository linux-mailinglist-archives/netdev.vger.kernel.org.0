Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9CAF38C44A
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 12:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhEUKDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 06:03:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39738 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233340AbhEUKDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 06:03:19 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lk1yU-0006X0-CW; Fri, 21 May 2021 10:01:46 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: hns3: Fix return of uninitialized variable ret
Date:   Fri, 21 May 2021 11:01:46 +0100
Message-Id: <20210521100146.42980-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the unlikely event that rule_cnt is zero the variable ret is
not assigned a value and function hclge_dbg_dump_fd_tcam can end
up returning an unitialized value in ret. Fix this by explicitly
setting ret to zero before the for-loop.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: b5a0b70d77b9 ("net: hns3: refactor dump fd tcam of debugfs")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index dd9eb6e6f5a7..0b7c6838d905 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -1519,6 +1519,7 @@ static int hclge_dbg_dump_fd_tcam(struct hclge_dev *hdev, char *buf, int len)
 		goto out;
 	}
 
+	ret = 0;
 	for (i = 0; i < rule_cnt; i++) {
 		tcam_msg.stage = HCLGE_FD_STAGE_1;
 		tcam_msg.loc = rule_locs[i];
-- 
2.31.1

