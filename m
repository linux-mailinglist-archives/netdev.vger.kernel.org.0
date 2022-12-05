Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E078C6422FD
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 07:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231699AbiLEGYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 01:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiLEGYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 01:24:13 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890AA11456;
        Sun,  4 Dec 2022 22:24:12 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NQYRG6g33z8RTZJ;
        Mon,  5 Dec 2022 14:24:10 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl2.zte.com.cn with SMTP id 2B56NxYw049730;
        Mon, 5 Dec 2022 14:23:59 +0800 (+08)
        (envelope-from zhang.songyi@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Mon, 5 Dec 2022 14:24:01 +0800 (CST)
Date:   Mon, 5 Dec 2022 14:24:01 +0800 (CST)
X-Zmail-TransId: 2af9638d8e811cbafd79
X-Mailer: Zmail v1.0
Message-ID: <202212051424013653827@zte.com.cn>
Mime-Version: 1.0
From:   <zhang.songyi@zte.com.cn>
To:     <leon@kernel.org>
Cc:     <saeedm@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <kliteyn@nvidia.com>,
        <shunh@nvidia.com>, <rongweil@nvidia.com>, <valex@nvidia.com>,
        <zhang.songyi@zte.com.cn>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSBuZXQvbWx4NTogcmVtb3ZlIHJlZHVuZGFudCByZXQgdmFyaWFibGU=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B56NxYw049730
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 638D8E8A.001 by FangMail milter!
X-FangMail-Envelope: 1670221450/4NQYRG6g33z8RTZJ/638D8E8A.001/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<zhang.songyi@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 638D8E8A.001/4NQYRG6g33z8RTZJ
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhang songyi <zhang.songyi@zte.com.cn>

Return value from mlx5dr_send_postsend_action() directly instead of taking
this in another redundant variable.

Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index a4476cb4c3b3..fd2d31cdbcf9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -724,7 +724,6 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 				struct mlx5dr_action *action)
 {
 	struct postsend_info send_info = {};
-	int ret;

 	send_info.write.addr = (uintptr_t)action->rewrite->data;
 	send_info.write.length = action->rewrite->num_of_actions *
@@ -734,9 +733,7 @@ int mlx5dr_send_postsend_action(struct mlx5dr_domain *dmn,
 		mlx5dr_icm_pool_get_chunk_mr_addr(action->rewrite->chunk);
 	send_info.rkey = mlx5dr_icm_pool_get_chunk_rkey(action->rewrite->chunk);

-	ret = dr_postsend_icm_data(dmn, &send_info);
-
-	return ret;
+	return dr_postsend_icm_data(dmn, &send_info);
 }

 static int dr_modify_qp_rst2init(struct mlx5_core_dev *mdev,
-- 
2.15.2
