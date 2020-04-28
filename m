Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC141BCE97
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgD1VYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:24:18 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:44631 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgD1VYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:24:17 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MwgKC-1jEb1M00Bm-00y6zy; Tue, 28 Apr 2020 23:24:02 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Leon Romanovsky <leonro@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/mlx5: reduce stack usage in qp_read_field
Date:   Tue, 28 Apr 2020 23:23:47 +0200
Message-Id: <20200428212357.2708786-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Y//QDx6YgP7glygIqcsEZBOzXCjSMjiFTvwLzkZNpCxtzgk5UEP
 2H37iRtxo8+W6u9R1r/9E1R6iobO65Ywx63Xtvcw6C3BvXtS7uIHLHlowdsCsjx//c+u9eY
 mcydsJSIEJA6sMtvZzCJsL5xzRvei0E4T4fgHACmwPmAqz95pe7E0JFQSKbpHr8AZObj1l9
 +feJa2jMvd3i/Y4tR6xtw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:g9B1afCIYdM=:/Fj51R/eE/4Llx9HHpFosi
 EO75hG5DBB1XvzOox7jLCjP7wZ4GGFKLXZT9qDNEupOP6f2MsP4v4ft/kUl2AT0rZRn9k+/8Q
 beGJ5hNkI9Wp7+q4jPJjrlWaZDmJ/93X3590m3Zy3XxcALvX6K8fqqL7joWN7PoVwxanb8ORP
 HhKI7PS6mHGuHTwd73wWLUpJwyVejEufJnJEUv5nvxcS/+DiqfTtw+P6fvoz6oY144Ca2Pqwj
 DdRQK9VGtD5Lfe+dO/01iNRDVmk7bzMfDqj+7XNbvoVkCdI0UU1PTXlXlivGBrLzh1/i1EwrG
 8q6xnem8DOwE07VSrbdpVLFwUG+HZqHGAjRl4cXfU/cHOqQNKPewt4YbqbdbjiBsghPnHMlAW
 D2JSY5ctWIiOnejYIyJxbAAq4dz/neLF0lq2+y/o2fhKghdf27G/govIHjeOiXJeGBDdwVK6x
 GpbXDHk8KdrRTrUMbaUwDmOCDhzQZzgHfsqYHz9L0KG0SsdDKJUtB0F1ni1KIibz+DJ3kRx7E
 0xOYqttZp3qMTQcUJqfoc7RLpKBXjqSFXj0GLp0ylIg5h90tHTbGlH+SqiFzMiqmgxPNeKcvD
 R/35SwSl54qhEmzsx53QAdcJlKw74CGfIi7DlWBlglsmaf5mWDKtAWZI6+mfxEn4+EVkASz0e
 jCa3Zzc/9tDm+h+sbjkpfT0lu2TnC57SELLUCvNnI/p7ckE/1MD3fSXrJHVOCBfexnIlMmkW0
 9S/5hRaAaRUpWfsLPcv2xH8UqAzG93tM4guBoXx+JPDjSi46mAcVS4RO3D3HWvCKzRFDPQg6R
 yJH1/xmom3QkWEgA3IFDdNtY/cLWpsNxkfm3t4kf5GXKC1oS2M=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moving the mlx5_ifc_query_qp_out_bits structure on the stack was a bit
excessive and now causes the compiler to complain on 32-bit architectures:

drivers/net/ethernet/mellanox/mlx5/core/debugfs.c: In function 'qp_read_field':
drivers/net/ethernet/mellanox/mlx5/core/debugfs.c:274:1: error: the frame size of 1104 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Revert the previous patch partially to use dynamically allocation as
the code did before. Unfortunately there is no good error handling
in case the allocation fails.

Fixes: 57a6c5e992f5 ("net/mlx5: Replace hand written QP context struct with automatic getters")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/mellanox/mlx5/core/debugfs.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 6409090b3ec5..d2d57213511b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -202,18 +202,23 @@ void mlx5_cq_debugfs_cleanup(struct mlx5_core_dev *dev)
 static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 			 int index, int *is_str)
 {
-	u32 out[MLX5_ST_SZ_BYTES(query_qp_out)] = {};
+	int outlen = MLX5_ST_SZ_BYTES(query_qp_out);
 	u32 in[MLX5_ST_SZ_DW(query_qp_in)] = {};
 	u64 param = 0;
+	u32 *out;
 	int state;
 	u32 *qpc;
 	int err;
 
+	out = kzalloc(outlen, GFP_KERNEL);
+	if (!out)
+		return 0;
+
 	MLX5_SET(query_qp_in, in, opcode, MLX5_CMD_OP_QUERY_QP);
 	MLX5_SET(query_qp_in, in, qpn, qp->qpn);
 	err = mlx5_cmd_exec_inout(dev, query_qp, in, out);
 	if (err)
-		return 0;
+		goto out;
 
 	*is_str = 0;
 
@@ -269,7 +274,8 @@ static u64 qp_read_field(struct mlx5_core_dev *dev, struct mlx5_core_qp *qp,
 		param = MLX5_GET(qpc, qpc, remote_qpn);
 		break;
 	}
-
+out:
+	kfree(out);
 	return param;
 }
 
-- 
2.26.0

