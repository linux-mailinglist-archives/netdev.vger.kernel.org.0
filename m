Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE1263D38D2
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 12:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231871AbhGWJzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 05:55:46 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:32816 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231519AbhGWJzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 05:55:45 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UgiGgeH_1627036571;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UgiGgeH_1627036571)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 23 Jul 2021 18:36:17 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     tariqt@nvidia.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] mlx4: Fix missing error code in mlx4_load_one()
Date:   Fri, 23 Jul 2021 18:36:09 +0800
Message-Id: <1627036569-71880-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'err'.

Eliminate the follow smatch warning:

drivers/net/ethernet/mellanox/mlx4/main.c:3538 mlx4_load_one() warn:
missing error code 'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Fixes: 7ae0e400cd93 ("net/mlx4_core: Flexible (asymmetric) allocation of
EQs and MSI-X vectors for PF/VFs")
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 00c8465..28ac469 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3535,6 +3535,7 @@ static int mlx4_load_one(struct pci_dev *pdev, int pci_dev_data,
 
 		if (!SRIOV_VALID_STATE(dev->flags)) {
 			mlx4_err(dev, "Invalid SRIOV state\n");
+			err = -EINVAL;
 			goto err_close;
 		}
 	}
-- 
1.8.3.1

