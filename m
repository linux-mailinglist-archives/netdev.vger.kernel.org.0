Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE147A0798
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfH1Qlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:41:53 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:38444 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726315AbfH1Qlw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 12:41:52 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from vladbu@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 28 Aug 2019 19:41:45 +0300
Received: from reg-r-vrt-018-180.mtr.labs.mlnx. (reg-r-vrt-018-180.mtr.labs.mlnx [10.215.1.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7SGfjCv013915;
        Wed, 28 Aug 2019 19:41:45 +0300
From:   Vlad Buslov <vladbu@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, saeedm@mellanox.com, idosch@mellanox.com,
        Vlad Buslov <vladbu@mellanox.com>,
        tanhuazhong <tanhuazhong@huawei.com>
Subject: [PATCH net-next 2/2] net/mlx5e: Move local var definition into ifdef block
Date:   Wed, 28 Aug 2019 19:41:04 +0300
Message-Id: <20190828164104.6020-3-vladbu@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190828164104.6020-1-vladbu@mellanox.com>
References: <20190828164104.6020-1-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New local variable "struct flow_block_offload *f" was added to
mlx5e_setup_tc() in recent rtnl lock removal patches. The variable is used
in code that is only compiled when CONFIG_MLX5_ESWITCH is enabled. This
results compilation warning about unused variable when CONFIG_MLX5_ESWITCH
is not set. Move the variable definition into eswitch-specific code block
from the begging of mlx5e_setup_tc() function.

Fixes: c9f14470d048 ("net: sched: add API for registering unlocked offload block callbacks")
Reported-by: tanhuazhong <tanhuazhong@huawei.com>
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8592b98d0e70..c10a1fc8e469 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3470,16 +3470,18 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
-	struct flow_block_offload *f = type_data;
 
 	switch (type) {
 #ifdef CONFIG_MLX5_ESWITCH
-	case TC_SETUP_BLOCK:
+	case TC_SETUP_BLOCK: {
+		struct flow_block_offload *f = type_data;
+
 		f->unlocked_driver_cb = true;
 		return flow_block_cb_setup_simple(type_data,
 						  &mlx5e_block_cb_list,
 						  mlx5e_setup_tc_block_cb,
 						  priv, priv, true);
+	}
 #endif
 	case TC_SETUP_QDISC_MQPRIO:
 		return mlx5e_setup_tc_mqprio(priv, type_data);
-- 
2.21.0

