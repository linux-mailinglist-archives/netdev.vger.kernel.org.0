Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25BEE6481B
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 16:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfGJOSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 10:18:35 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:32447 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbfGJOSf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 10:18:35 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 859EA416CA;
        Wed, 10 Jul 2019 22:18:31 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH nf-next] net/mlx5e: Fix kernel NULL pointer dereference
Date:   Wed, 10 Jul 2019 22:18:30 +0800
Message-Id: <1562768310-20468-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVPSkxLS0tLTk5ISkhKSllXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OiI6Dgw4Pjg3GA0MHyMuMh5P
        AUIKCh5VSlVKTk1JTE1DSEpKTUlDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhITkw3Bg++
X-HM-Tid: 0a6bdc4005062086kuqy859ea416ca
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ 3444.666552] BUG: kernel NULL pointer dereference, address: 0000000000000000
[ 3444.666631] #PF: supervisor read access in kernel mode
[ 3444.666701] #PF: error_code(0x0000) - not-present page
[ 3444.666769] PGD 8000000812dd7067 P4D 8000000812dd7067 PUD 8207cc067 PMD 0
[ 3444.666843] Oops: 0000 [#1] SMP PTI
[ 3444.666910] CPU: 17 PID: 27387 Comm: nft Kdump: loaded Tainted: G           O      5.2.0-rc6+ #1
[ 3444.666987] Hardware name: Huawei Technologies Co., Ltd. RH1288 V3/BC11HGSC0, BIOS 3.57 02/26/2017
[ 3444.667071] RIP: 0010:flow_block_cb_setup_simple+0x127/0x240
[ 3444.667141] Code: 02 48 89 43 08 31 c0 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 83 c4 10 b8 a1 ff ff ff 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <49> 8b 04 24 49 39 c4 75 0a eb 2f 48 8b 00 49 39 c4 74 27 4c 3b 68
[ 3444.668201] RSP: 0018:ffffc90007b7b888 EFLAGS: 00010246
[ 3444.668595] RAX: 0000000000000000 RBX: ffff8890439a9b40 RCX: ffff88904d5008c0
[ 3444.668992] RDX: ffffffffa0879850 RSI: 0000000000000000 RDI: ffffc90007b7b908
[ 3444.669389] RBP: ffffc90007b7b8c0 R08: ffff88904d5008c0 R09: 0000000000000001
[ 3444.669787] R10: ffff88885a797d00 R11: ffff8890439a9b00 R12: 0000000000000000
[ 3444.670186] R13: ffffffffa0879850 R14: ffffc90007b7b908 R15: ffffffff823a8480
[ 3444.670588] FS:  00007f357c2fa740(0000) GS:ffff88885fe40000(0000) knlGS:0000000000000000
[ 3444.671313] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3444.671705] CR2: 0000000000000000 CR3: 00000001a1600002 CR4: 00000000001626e0
[ 3444.672103] Call Trace:
[ 3444.672505]  ? jump_label_update+0x5f/0xc0
[ 3444.672933]  mlx5e_rep_setup_tc+0x32/0x40 [mlx5_core]
[ 3444.673335]  nft_flow_offload_chain+0xd0/0x1d0 [nf_tables]
[ 3444.673729]  nft_flow_rule_offload_commit+0x91/0x11b [nf_tables]
[ 3444.674129]  nf_tables_commit+0x90/0xe30 [nf_tables]
[ 3444.674529]  nfnetlink_rcv_batch+0x3b9/0x750 [nfnetlink]

Init the driver_block_list parameter

Fixes: 955bcb6ea0df ("drivers: net: use flow block API")
Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 10ef90a..90c6de9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1182,7 +1182,7 @@ static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return flow_block_cb_setup_simple(type_data, NULL,
+		return flow_block_cb_setup_simple(type_data, &mlx5e_block_cb_list,
 						  mlx5e_rep_setup_tc_cb,
 						  priv, priv, true);
 	default:
-- 
1.8.3.1

