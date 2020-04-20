Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D583C1B07A1
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 13:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgDTLly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 07:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgDTLlx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 07:41:53 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7553B214AF;
        Mon, 20 Apr 2020 11:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587382913;
        bh=2/KYDJWZ4oxNPd1NRGm8KRo++sFgNeLMXDTAIP2kYAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G26hb5q+B6RhQCZvWfcL4OrH2ZXMMDU8V0Osh/CwpCErd/Ma4AypV/sZcd98mL13Y
         AOEEdUakqQtJOf/pz7772u95vLX89vHLOAKpUCrxHhexBPyF2A62DpXZsQX0mv2I9e
         qXkD4+xVKmUx7WWE8NkXtm2nYQMjNBh3OMPnb78g=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 04/24] net/mlx5: Update ecpf.c to new cmd interface
Date:   Mon, 20 Apr 2020 14:41:16 +0300
Message-Id: <20200420114136.264924-5-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200420114136.264924-1-leon@kernel.org>
References: <20200420114136.264924-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Do mass update of ecpf.c to reuse newly introduced
mlx5_cmd_exec_in*() interfaces.

Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/ecpf.c    | 30 ++++---------------
 1 file changed, 6 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index d2228e37450f..a894ea98c95a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -8,33 +8,13 @@ bool mlx5_read_embedded_cpu(struct mlx5_core_dev *dev)
 	return (ioread32be(&dev->iseg->initializing) >> MLX5_ECPU_BIT_NUM) & 1;
 }
 
-static int mlx5_peer_pf_enable_hca(struct mlx5_core_dev *dev)
-{
-	u32 out[MLX5_ST_SZ_DW(enable_hca_out)] = {};
-	u32 in[MLX5_ST_SZ_DW(enable_hca_in)]   = {};
-
-	MLX5_SET(enable_hca_in, in, opcode, MLX5_CMD_OP_ENABLE_HCA);
-	MLX5_SET(enable_hca_in, in, function_id, 0);
-	MLX5_SET(enable_hca_in, in, embedded_cpu_function, 0);
-	return mlx5_cmd_exec(dev, &in, sizeof(in), &out, sizeof(out));
-}
-
-static int mlx5_peer_pf_disable_hca(struct mlx5_core_dev *dev)
-{
-	u32 out[MLX5_ST_SZ_DW(disable_hca_out)] = {};
-	u32 in[MLX5_ST_SZ_DW(disable_hca_in)]   = {};
-
-	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
-	MLX5_SET(disable_hca_in, in, function_id, 0);
-	MLX5_SET(disable_hca_in, in, embedded_cpu_function, 0);
-	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
-}
-
 static int mlx5_peer_pf_init(struct mlx5_core_dev *dev)
 {
+	u32 in[MLX5_ST_SZ_DW(enable_hca_in)] = {};
 	int err;
 
-	err = mlx5_peer_pf_enable_hca(dev);
+	MLX5_SET(enable_hca_in, in, opcode, MLX5_CMD_OP_ENABLE_HCA);
+	err = mlx5_cmd_exec_in(dev, enable_hca, in);
 	if (err)
 		mlx5_core_err(dev, "Failed to enable peer PF HCA err(%d)\n",
 			      err);
@@ -44,9 +24,11 @@ static int mlx5_peer_pf_init(struct mlx5_core_dev *dev)
 
 static void mlx5_peer_pf_cleanup(struct mlx5_core_dev *dev)
 {
+	u32 in[MLX5_ST_SZ_DW(disable_hca_in)] = {};
 	int err;
 
-	err = mlx5_peer_pf_disable_hca(dev);
+	MLX5_SET(disable_hca_in, in, opcode, MLX5_CMD_OP_DISABLE_HCA);
+	err = mlx5_cmd_exec_in(dev, disable_hca, in);
 	if (err) {
 		mlx5_core_err(dev, "Failed to disable peer PF HCA err(%d)\n",
 			      err);
-- 
2.25.2

