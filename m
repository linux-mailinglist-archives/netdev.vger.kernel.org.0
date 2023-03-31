Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3A46D1481
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjCaA5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjCaA5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:57:40 -0400
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE2F12CCD;
        Thu, 30 Mar 2023 17:57:24 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R921e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vf02poT_1680224239;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Vf02poT_1680224239)
          by smtp.aliyun-inc.com;
          Fri, 31 Mar 2023 08:57:20 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        saeedm@nvidia.com, leon@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH net-next] net/mlx5e: Remove NULL check before dev_{put, hold}
Date:   Fri, 31 Mar 2023 08:57:18 +0800
Message-Id: <20230331005718.50060-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The call netdev_{put, hold} of dev_{put, hold} will check NULL,
so there is no need to check before using dev_{put, hold},
remove it to silence the warnings:

./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:734:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.
./drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c:769:2-9: WARNING: NULL check before dev_{put, hold} functions is not needed.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4667
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index 20c2d2ecaf93..69ac30a728f4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -730,8 +730,7 @@ static int mlx5e_set_vf_tunnel(struct mlx5_eswitch *esw,
 	}
 
 out:
-	if (route_dev)
-		dev_put(route_dev);
+	dev_put(route_dev);
 	return err;
 }
 
@@ -765,8 +764,7 @@ static int mlx5e_update_vf_tunnel(struct mlx5_eswitch *esw,
 	mlx5e_tc_match_to_reg_mod_hdr_change(esw->dev, mod_hdr_acts, VPORT_TO_REG, act_id, data);
 
 out:
-	if (route_dev)
-		dev_put(route_dev);
+	dev_put(route_dev);
 	return err;
 }
 
-- 
2.20.1.7.g153144c

