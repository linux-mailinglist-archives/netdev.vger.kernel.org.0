Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2592E353B
	for <lists+netdev@lfdr.de>; Mon, 28 Dec 2020 09:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgL1Itt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 03:49:49 -0500
Received: from mail.zju.edu.cn ([61.164.42.155]:19642 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726531AbgL1Itt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 03:49:49 -0500
Received: from localhost.localdomain (unknown [222.205.25.254])
        by mail-app4 (Coremail) with SMTP id cS_KCgDXbjrpm+lfCDchAA--.52913S4;
        Mon, 28 Dec 2020 16:48:46 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Gal Pressman <galp@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] net/mlx5e: Fix two double free cases
Date:   Mon, 28 Dec 2020 16:48:40 +0800
Message-Id: <20201228084840.5013-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cS_KCgDXbjrpm+lfCDchAA--.52913S4
X-Coremail-Antispam: 1UD129KBjvJXoW7uFWDXr1UXFWUJF1ftFykAFb_yoW8Xr17pF
        4rZr9Fgay3X348Xa1DArWFqryrCw4UtayIg3Wak3ySvr1DWFWrAF98uFZxCF97WFWUXa1j
        qw1xAw1UAF4DJa7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IY
        c2Ij64vIr41l42xK82IY6x8ErcxFaVAv8VW8uw4UJr1UMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgYEBlZdtRrnPgAbsg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5e_create_ttc_table_groups() frees ft->g on failure of
kvzalloc(), but such failure will be caught by its caller
in mlx5e_create_ttc_table() and ft->g will be freed again
in mlx5e_destroy_flow_table(). The same issue also occurs
in mlx5e_create_ttc_table_groups(). Set ft->g to NULL after
kfree() to avoid double free.

Fixes: 7b3722fa9ef64 ("net/mlx5e: Support RSS for GRE tunneled packets")
Fixes: 33cfaaa8f36ff ("net/mlx5e: Split the main flow steering table")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---

Changelog:

v2: - Set ft->g to NULL after kfree() instead of removing kfree().
      Refine commit message.
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index fa8149f6eb08..44a2dfbc3853 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -942,6 +942,7 @@ static int mlx5e_create_ttc_table_groups(struct mlx5e_ttc_table *ttc,
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 
@@ -1087,6 +1088,7 @@ static int mlx5e_create_inner_ttc_table_groups(struct mlx5e_ttc_table *ttc)
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in) {
 		kfree(ft->g);
+		ft->g = NULL;
 		return -ENOMEM;
 	}
 
-- 
2.17.1

