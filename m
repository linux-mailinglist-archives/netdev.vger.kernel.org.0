Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14ED5B77B1
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 19:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiIMRWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 13:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiIMRVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 13:21:46 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4248C165B6;
        Tue, 13 Sep 2022 09:09:18 -0700 (PDT)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MRm3X5XfPzkWt4;
        Tue, 13 Sep 2022 22:26:00 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 13 Sep 2022 22:29:57 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 13 Sep
 2022 22:29:57 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>
CC:     <saeedm@nvidia.com>, <liorna@nvidia.com>, <raeds@nvidia.com>,
        <davem@davemloft.net>
Subject: [PATCH -next 2/2] net/mlx5e: Switch to kmemdup() when allocate dev_addr
Date:   Tue, 13 Sep 2022 22:37:13 +0800
Message-ID: <20220913143713.1998778-2-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220913143713.1998778-1-yangyingliang@huawei.com>
References: <20220913143713.1998778-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kmemdup() helper instead of open-coding to
simplify the code when allocate dev_addr.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 5fa3e22c8918..0f7c5b9a3541 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -934,14 +934,14 @@ static int mlx5e_macsec_add_secy(struct macsec_context *ctx)
 		goto out;
 	}
 
-	macsec_device->dev_addr = kzalloc(dev->addr_len, GFP_KERNEL);
+	macsec_device->dev_addr = kmemdup(dev->dev_addr, dev->addr_len,
+					  GFP_KERNEL);
 	if (!macsec_device->dev_addr) {
 		kfree(macsec_device);
 		err = -ENOMEM;
 		goto out;
 	}
 
-	memcpy(macsec_device->dev_addr, dev->dev_addr, dev->addr_len);
 	macsec_device->netdev = dev;
 
 	INIT_LIST_HEAD_RCU(&macsec_device->macsec_rx_sc_list_head);
-- 
2.25.1

