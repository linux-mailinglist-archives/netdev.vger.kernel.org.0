Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 545EA63CFC5
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 08:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234052AbiK3Hlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 02:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbiK3Hll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 02:41:41 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04005B5A5;
        Tue, 29 Nov 2022 23:41:40 -0800 (PST)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NMWNz0ttpz8RTZM;
        Wed, 30 Nov 2022 15:41:39 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl1.zte.com.cn with SMTP id 2AU7fOKX001717;
        Wed, 30 Nov 2022 15:41:24 +0800 (+08)
        (envelope-from zhang.songyi@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Wed, 30 Nov 2022 15:41:27 +0800 (CST)
Date:   Wed, 30 Nov 2022 15:41:27 +0800 (CST)
X-Zmail-TransId: 2af9638709276644dd5b
X-Mailer: Zmail v1.0
Message-ID: <202211301541270908055@zte.com.cn>
Mime-Version: 1.0
From:   <zhang.songyi@zte.com.cn>
To:     <saeedm@nvidia.com>, <pabeni@redhat.com>
Cc:     <leon@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <mbloch@nvidia.com>, <maorg@nvidia.com>,
        <elic@nvidia.com>, <jerrliu@nvidia.com>, <cmi@nvidia.com>,
        <vladbu@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <zhang.songyi@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIG5ldC1uZXh0XSBuZXQvbWx4NTogcmVtb3ZlIE5VTEwgY2hlY2sgYmVmb3JlIGRldl97cHV0LCBob2xkfQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 2AU7fOKX001717
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.137.novalocal with ID 63870933.000 by FangMail milter!
X-FangMail-Envelope: 1669794099/4NMWNz0ttpz8RTZM/63870933.000/10.5.228.132/[10.5.228.132]/mse-fl1.zte.com.cn/<zhang.songyi@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 63870933.000/4NMWNz0ttpz8RTZM
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhang songyi <zhang.songyi@zte.com.cn>

The call netdev_{put, hold} of dev_{put, hold} will check NULL,
so there is no need to check before using dev_{put, hold}.

Fix the following coccicheck warning:
/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c:1450:2-10:
WARNING:
WARNING  NULL check before dev_{put, hold} functions is not needed.

Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 32c3e0a649a7..6ab3a6b6dd8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1448,8 +1448,7 @@ struct net_device *mlx5_lag_get_roce_netdev(struct mlx5_core_dev *dev)
        } else {
                ndev = ldev->pf[MLX5_LAG_P1].netdev;
        }
-       if (ndev)
-               dev_hold(ndev);
+       dev_hold(ndev);

 unlock:
        spin_unlock_irqrestore(&lag_lock, flags);
--
2.25.1
