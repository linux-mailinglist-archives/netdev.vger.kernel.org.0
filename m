Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59C84855AD
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241309AbiAEPSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:18:21 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:60435 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241329AbiAEPSM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:18:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V127ybZ_1641395873;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0V127ybZ_1641395873)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Jan 2022 23:17:59 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     saeedm@nvidia.com
Cc:     leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] net/mlx5e: Fix missing error code in mlx5e_rx_reporter_err_icosq_cqe_recover()
Date:   Wed,  5 Jan 2022 23:17:51 +0800
Message-Id: <20220105151751.40723-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'err'.

Eliminate the follow smatch warning:

drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c:91
mlx5e_rx_reporter_err_icosq_cqe_recover() warn: missing error code
'err'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 2684e9da9f41..ceb21573db6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -87,8 +87,10 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 		goto out;
 	}
 
-	if (state != MLX5_SQC_STATE_ERR)
+	if (state != MLX5_SQC_STATE_ERR) {
+		err = -EINVAL;
 		goto out;
+	}
 
 	mlx5e_deactivate_rq(rq);
 	if (xskrq)
-- 
2.20.1.7.g153144c

