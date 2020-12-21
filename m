Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130342DFA2A
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 09:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbgLUIvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 03:51:44 -0500
Received: from spam.zju.edu.cn ([61.164.42.155]:8864 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726168AbgLUIvo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 03:51:44 -0500
Received: from localhost.localdomain (unknown [10.192.85.18])
        by mail-app3 (Coremail) with SMTP id cC_KCgA37w7WYeBfFXRhAA--.42123S4;
        Mon, 21 Dec 2020 16:50:34 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5e: Fix two double free cases
Date:   Mon, 21 Dec 2020 16:50:31 +0800
Message-Id: <20201221085031.6591-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgA37w7WYeBfFXRhAA--.42123S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uFWDXr1UXFWDKF47Cr18Grg_yoW8GF1Dpa
        1rCr9FgFyfX34UXayDAFWFqw1rCw4ktay0g3WS934Svr1DGrW0vFyrWrWDAF97GFWUWF4a
        qw1xAw1UAF4DJa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkI1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
        6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgUMBlZdtRf+rwANs4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5e_create_ttc_table_groups() frees ft->g on failure of
kvzalloc(), but such failure will be caught by its caller
in mlx5e_create_ttc_table() and ft->g will be freed again
in mlx5e_destroy_flow_table(). The same issue also occurs
in mlx5e_create_ttc_table_groups().

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index fa8149f6eb08..63323c5b6a50 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -940,10 +940,8 @@ static int mlx5e_create_ttc_table_groups(struct mlx5e_ttc_table *ttc,
 	if (!ft->g)
 		return -ENOMEM;
 	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in) {
-		kfree(ft->g);
+	if (!in)
 		return -ENOMEM;
-	}
 
 	/* L4 Group */
 	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
@@ -1085,10 +1083,8 @@ static int mlx5e_create_inner_ttc_table_groups(struct mlx5e_ttc_table *ttc)
 	if (!ft->g)
 		return -ENOMEM;
 	in = kvzalloc(inlen, GFP_KERNEL);
-	if (!in) {
-		kfree(ft->g);
+	if (!in)
 		return -ENOMEM;
-	}
 
 	/* L4 Group */
 	mc = MLX5_ADDR_OF(create_flow_group_in, in, match_criteria);
-- 
2.17.1

