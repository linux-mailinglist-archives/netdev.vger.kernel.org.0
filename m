Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462972DFB9C
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 12:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbgLULh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 06:37:29 -0500
Received: from spam.zju.edu.cn ([210.32.2.5]:23398 "EHLO zju.edu.cn"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725791AbgLULh2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 06:37:28 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Dec 2020 06:37:25 EST
Received: from localhost.localdomain (unknown [10.192.85.18])
        by mail-app2 (Coremail) with SMTP id by_KCgAnDwKhhuBf2PhfAA--.59381S4;
        Mon, 21 Dec 2020 19:27:33 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5e: Fix memleak in mlx5e_create_l2_table_groups
Date:   Mon, 21 Dec 2020 19:27:31 +0800
Message-Id: <20201221112731.32545-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: by_KCgAnDwKhhuBf2PhfAA--.59381S4
X-Coremail-Antispam: 1UD129KBjvdXoW7GF47XrW3KrW5tFWDur1kuFg_yoWfXwc_Gr
        y8X3Z5X3yYvr4Ykw1jgrZ8J3yIkrn8ur4SyFZIqFy5Jw1Uur4Uu3yfua4xXF4xGFyUK34D
        tFZxt3W3A3yjvjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb2AFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4UJVW0owA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWU
        GwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv
        6cx26r4fKr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
        C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48J
        MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
        IF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvE
        x4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAgUMBlZdtRf+rwAPs6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When mlx5_create_flow_group() fails, ft->g should be
freed just like when kvzalloc() fails. The caller of
mlx5e_create_l2_table_groups() does not catch this
issue on failure, which leads to memleak.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index fa8149f6eb08..72de1009b104 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -1390,6 +1390,7 @@ static int mlx5e_create_l2_table_groups(struct mlx5e_l2_table *l2_table)
 	ft->g[ft->num_groups] = NULL;
 	mlx5e_destroy_groups(ft);
 	kvfree(in);
+	kfree(ft->g);
 
 	return err;
 }
-- 
2.17.1

