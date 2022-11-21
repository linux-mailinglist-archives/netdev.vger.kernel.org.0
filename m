Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8537632091
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiKUL3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiKUL2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:28:47 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6029AE03D;
        Mon, 21 Nov 2022 03:23:07 -0800 (PST)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NG4f83FqpzqSYP;
        Mon, 21 Nov 2022 19:19:12 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Mon, 21 Nov
 2022 19:23:05 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <saeedm@nvidia.com>, <leon@kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <moshe@nvidia.com>, <ogerlitz@mellanox.com>, <eli@mellanox.com>,
        <jackm@dev.mellanox.co.il>, <roland@purestorage.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net] net/mlx5: Fix uninitialized variable bug in outlen_write()
Date:   Mon, 21 Nov 2022 19:22:04 +0800
Message-ID: <20221121112204.24456-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If sscanf() return 0, outlen is uninitialized and used in kzalloc(),
this is unexpected. We should return -EINVAL if the string is invalid.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 2e0d59ca62b5..cfb1e9f18a6c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1508,8 +1508,8 @@ static ssize_t outlen_write(struct file *filp, const char __user *buf,
 		return -EFAULT;
 
 	err = sscanf(outlen_str, "%d", &outlen);
-	if (err < 0)
-		return err;
+	if (err != 1)
+		return -EINVAL;
 
 	ptr = kzalloc(outlen, GFP_KERNEL);
 	if (!ptr)
-- 
2.17.1

