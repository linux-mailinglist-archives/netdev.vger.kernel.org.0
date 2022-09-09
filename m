Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104CE5B2E3D
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 07:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiIIFnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 01:43:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiIIFnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 01:43:11 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E7C80B4C;
        Thu,  8 Sep 2022 22:43:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VP83TeQ_1662702166;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VP83TeQ_1662702166)
          by smtp.aliyun-inc.com;
          Fri, 09 Sep 2022 13:43:06 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     borisp@nvidia.com
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] net/mlx5: use kmemdup() to replace kzalloc + memcpy
Date:   Fri,  9 Sep 2022 13:42:44 +0800
Message-Id: <20220909054244.73956-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

./drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c:932:27-34: WARNING opportunity for kmemdup.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2107
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index d9d18b039d8c..e32892943ee5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -929,14 +929,13 @@ static int mlx5e_macsec_add_secy(struct macsec_context *ctx)
 		goto out;
 	}
 
-	macsec_device->dev_addr = kzalloc(dev->addr_len, GFP_KERNEL);
+	macsec_device->dev_addr = kmemdup(dev->dev_addr, dev->addr_len, GFP_KERNEL);
 	if (!macsec_device->dev_addr) {
 		kfree(macsec_device);
 		err = -ENOMEM;
 		goto out;
 	}
 
-	memcpy(macsec_device->dev_addr, dev->dev_addr, dev->addr_len);
 	macsec_device->netdev = dev;
 
 	INIT_LIST_HEAD_RCU(&macsec_device->macsec_rx_sc_list_head);
-- 
2.20.1.7.g153144c

