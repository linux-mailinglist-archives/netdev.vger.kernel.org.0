Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42EB5139273
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgAMNqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:46:20 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:39949 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAMNqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:46:20 -0500
Received: from nexussix.ar.arcelik (unknown [84.44.14.226])
        (Authenticated sender: cengiz@kernel.wtf)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 01116200012;
        Mon, 13 Jan 2020 13:46:10 +0000 (UTC)
From:   Cengiz Can <cengiz@kernel.wtf>
To:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Yevgeny Kliteynik <kliteyn@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cengiz Can <cengiz@kernel.wtf>
Subject: [PATCH] net: mellanox: prevent resource leak on htbl
Date:   Mon, 13 Jan 2020 16:44:16 +0300
Message-Id: <20200113134415.86110-1-cengiz@kernel.wtf>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to a Coverity static analysis tool,
`drivers/net/mellanox/mlx5/core/steering/dr_rule.c#63` leaks a
`struct mlx5dr_ste_htbl *` named `new_htbl` while returning from
`dr_rule_create_collision_htbl` function.

A annotated snippet of the possible resource leak follows:

```
static struct mlx5dr_ste *
dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
                              struct mlx5dr_matcher_rx_tx *nic_matcher,
                              u8 *hw_ste)
   /* ... */
   /* ... */

   /* Storage is returned from allocation function mlx5dr_ste_htbl_alloc. */
   /* Assigning: new_htbl = storage returned from mlx5dr_ste_htbl_alloc(..) */
        new_htbl = mlx5dr_ste_htbl_alloc(dmn->ste_icm_pool,
                                         DR_CHUNK_SIZE_1,
                                         MLX5DR_STE_LU_TYPE_DONT_CARE,
                                         0);
   /* Condition !new_htbl, taking false branch. */
        if (!new_htbl) {
                mlx5dr_dbg(dmn, "Failed allocating collision table\n");
                return NULL;
        }

        /* One and only entry, never grows */
        ste = new_htbl->ste_arr;
        mlx5dr_ste_set_miss_addr(hw_ste, nic_matcher->e_anchor->chunk->icm_addr);
   /* Resource new_htbl is not freed or pointed-to in mlx5dr_htbl_get */
        mlx5dr_htbl_get(new_htbl);

   /* Variable new_htbl going out of scope leaks the storage it points to. */
        return ste;
```

There's a caller of this function which does refcounting and free'ing by
itself but that function also skips free'ing `new_htbl` due to missing
jump to error label. (referring to `dr_rule_create_collision_entry lines
75-77. They don't jump to `free_tbl`)

Added a `kfree(new_htbl)` just before returning `ste` pointer to fix the
leak.

Signed-off-by: Cengiz Can <cengiz@kernel.wtf>
---

This might be totally breaking the refcounting logic in the file so
please provide any feedback so I can evolve this into something more
suitable.

For the record, Coverity scan id is CID 1457773.

 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index e4cff7abb348..047b403c61db 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -60,6 +60,8 @@ dr_rule_create_collision_htbl(struct mlx5dr_matcher *matcher,
 	mlx5dr_ste_set_miss_addr(hw_ste, nic_matcher->e_anchor->chunk->icm_addr);
 	mlx5dr_htbl_get(new_htbl);

+	kfree(new_htbl);
+
 	return ste;
 }

--
2.24.1

