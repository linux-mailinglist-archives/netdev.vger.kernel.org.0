Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E00224843C
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 13:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgHRLxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 07:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:55144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgHRLxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 07:53:03 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BC59206B5;
        Tue, 18 Aug 2020 11:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597751583;
        bh=E80QrRchRW6GbwYhm6lf6rkN6ZEwCY2fqzcWabSBVOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0/W6dNLH4U38BzIBeOTU3NTwskS/LBJmVXVinrntppZ4d6FHCQcRCPMGsn0AeXN84
         PA7qAftT/WQJku5ejxgJDtpx6B4qaE+IrSJExjxCfll3r3ipTE6CdX2KSBN7yL4/2v
         aEBUn+pagonyfxiqRaE9Yc6mer40QErs36reshlk=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Mark Zhang <markz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 1/2] IB/mlx5: Add tx_affinity support for DCI QP
Date:   Tue, 18 Aug 2020 14:52:44 +0300
Message-Id: <20200818115245.700581-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818115245.700581-1-leon@kernel.org>
References: <20200818115245.700581-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

DCI QP supports tx_affinity as well.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index da9f15e0a644..0526d574cd9b 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -3667,14 +3667,12 @@ static unsigned int get_tx_affinity_rr(struct mlx5_ib_dev *dev,
 		MLX5_MAX_PORTS + 1;
 }

-static bool qp_supports_affinity(struct ib_qp *qp)
+static bool qp_supports_affinity(struct mlx5_ib_qp *qp)
 {
-	if ((qp->qp_type == IB_QPT_RC) ||
-	    (qp->qp_type == IB_QPT_UD) ||
-	    (qp->qp_type == IB_QPT_UC) ||
-	    (qp->qp_type == IB_QPT_RAW_PACKET) ||
-	    (qp->qp_type == IB_QPT_XRC_INI) ||
-	    (qp->qp_type == IB_QPT_XRC_TGT))
+	if ((qp->type == IB_QPT_RC) || (qp->type == IB_QPT_UD) ||
+	    (qp->type == IB_QPT_UC) || (qp->type == IB_QPT_RAW_PACKET) ||
+	    (qp->type == IB_QPT_XRC_INI) || (qp->type == IB_QPT_XRC_TGT) ||
+	    (qp->type == MLX5_IB_QPT_DCI))
 		return true;
 	return false;
 }
@@ -3692,7 +3690,7 @@ static unsigned int get_tx_affinity(struct ib_qp *qp,
 	unsigned int tx_affinity;

 	if (!(mlx5_ib_lag_should_assign_affinity(dev) &&
-	      qp_supports_affinity(qp)))
+	      qp_supports_affinity(mqp)))
 		return 0;

 	if (mqp->flags & MLX5_IB_QP_CREATE_SQPN_QP1)
--
2.26.2

