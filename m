Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41E3A1304C0
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 22:52:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726373AbgADVwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 16:52:09 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:37265 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbgADVwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 16:52:09 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1M3UEW-1ioPZE0kDa-000dUZ; Sat, 04 Jan 2020 22:51:58 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Adhemerval Zanella <adhemerval.zanella@linaro.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Shay Agroskin <shayag@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mlx5: work around high stack usage with gcc
Date:   Sat,  4 Jan 2020 22:51:44 +0100
Message-Id: <20200104215156.689245-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:g72rzurjLl3a9U3yjh/EbwX9fa7SXEwNpbEDnrITAImdtZIfC7N
 evlvGuMj0S9VcMfKOlipNf+RIBizk5jL/mKupNu9QMLUMfq8+dj6g0zi+RHMTfaeUCEnINu
 uruwYWICaYjJ8WxZ6RJkoI+IXkKpHr9WKegoiTdG9DK+UP9Vk89jmGIO7a/LghtDHdq8GQQ
 N3jNZ5qZGTm7hw8+xsFxw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oaTz2g1s6cM=:TQvMn5LxbABK3px/0bp5mg
 j7zGiJuuBm6sMzRmi/SAofqpVlUH23ublfdfvXBZLagx02K9DSO4v7d4znLbpaiUw2lUyKJd4
 R37P9RTnvJJcBlGPk2Nk+Av6uVpnjOdyhaj0mWWZr29VrUdNDRosKQl7AkHsPShf06dVxivRN
 JJ5e8vPfwP99nqktLJQCMp6e71eDx7WK7zRI+wQOFFA7kkKU4vtE+cBqmEHqmfJsAs6o++8mj
 TFwDc38Nu5iAq7pqV2pYpdWIxCv2Ex3ZNGUfoFzwqnXV1gami9Pje1xNbU2vTdNSQfLxjs5x8
 6T3/KHZOUAnmzH1WFvxoYxbwS/YVZTrHIRH4B53Qh959E50qaXtxDGoEIKcGvvz0SV1/Mezbp
 uBj6QPrOUG7PDeL5y7HhKuUSFtnrrL6RrnCSje0l1wKG99pzBBhvMkOoWwvveeSTgxWEM67XM
 f+nzi/Axus1rzO+bZ6cH30avx6+uRjOws2THQwXNiM9hSPa9FFD9IFRji1/Bt5eZwAeaQzoln
 DmoV2v+9AFIqoNqJwTrWViuCHPfoPnuTy6nUtMNBv8rAUwiqAv4CEEgIWJ5XdYw4Ctvu9xP9K
 li4cAUbFgmJ4/8E222G8SSR/eSzbeS53lXSifSZj3zjb22IenHjqpef+rXpjTl7dFq7iSV497
 d0Y5xv2uSfBXGqH5fu7BcYtbO9kL261P8xT+AVTThi7XcER1yrtBBOQQWL8n8/G/viG1PgtEl
 tWtDYW8IG+WTOO9QL50xYhkIZx6Da5yRZq/IuYWfIkpeQpiHN8q7qW20GV2bBUdZmRr1HZqa6
 OR573yzv1PHQcyaPYdzpTGlltRDKPbL/iLHn8jOh8GTZKoyQRKFrUNgDo0uGLCSCFpCbu8kqU
 mxVOvqVihoBfAvmFq4bw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some configurations, gcc tries too hard to optimize this code:

drivers/net/ethernet/mellanox/mlx5/core/en_stats.c: In function 'mlx5e_grp_sw_update_stats':
drivers/net/ethernet/mellanox/mlx5/core/en_stats.c:302:1: error: the frame size of 1336 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

As was stated in the bug report, the reason is that gcc runs into a corner
case in the register allocator that is rather hard to fix in a good way.

As there is an easy way to work around it, just add a comment and the
barrier that stops gcc from trying to overoptimize the function.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657
Cc: Adhemerval Zanella <adhemerval.zanella@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
index 9f09253f9f46..a05158472ed1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -297,6 +297,9 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv *priv)
 			s->tx_tls_drop_bypass_req   += sq_stats->tls_drop_bypass_req;
 #endif
 			s->tx_cqes		+= sq_stats->cqes;
+
+			/* https://gcc.gnu.org/bugzilla/show_bug.cgi?id=92657 */
+			barrier();
 		}
 	}
 }
-- 
2.20.0

