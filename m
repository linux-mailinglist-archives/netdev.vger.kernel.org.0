Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 196D52EED08
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727271AbhAHFbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:31:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:35752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727001AbhAHFbh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 00:31:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2573B23406;
        Fri,  8 Jan 2021 05:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610083857;
        bh=PRD0C0CukMOoliU1TJTVvJ7qCD21WQBO6LpD3X7upIo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ks+y6OuX0XFs8TKF/ZGPhEw+0wkwvFm2m1FmZW3c2c5Th6UErI/YSbTVK4h/IONPS
         abglZCRP8qN8InBc3SrjNQSdGPxOkNoxAoWdh9Ind+0V9tLNHnuE73Tm+U+E122Nnc
         cJrOvLc9bM2QlfO2PIZ2I1uF9QZX0L6QFukQxqbydGOZxBon1sawUm9LOOGqRsoEC1
         MTT+/KwoNwvdtFUTbKGjpdB9GiBQHU/9xYre+XxjwBCiqneYbXr0/p7PdrEUgwluVL
         Klrc9t5L3BPjZ+jWpACr3DBDhraoH93NgauF9gMuYViSX6nrNkpJzotFKDKLztq5Ow
         X8a0FkRZGlvTQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eli Cohen <elic@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5e: Simplify condition on esw_vport_enable_qos()
Date:   Thu,  7 Jan 2021 21:30:41 -0800
Message-Id: <20210108053054.660499-3-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210108053054.660499-1-saeed@kernel.org>
References: <20210108053054.660499-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

esw->qos.enabled will only be true if both MLX5_CAP_GEN(dev, qos) and
MLX5_CAP_QOS(dev, esw_scheduling) are true. Therefore, remove them from
the condition in and rely only on esw->qos.enabled.

Fixes: 1bd27b11c1df ("net/mlx5: Introduce E-switch QoS management")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index da901e364656..876e6449edb3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1042,8 +1042,7 @@ static int esw_vport_enable_qos(struct mlx5_eswitch *esw,
 	void *vport_elem;
 	int err = 0;
 
-	if (!esw->qos.enabled || !MLX5_CAP_GEN(dev, qos) ||
-	    !MLX5_CAP_QOS(dev, esw_scheduling))
+	if (!esw->qos.enabled)
 		return 0;
 
 	if (vport->qos.enabled)
-- 
2.26.2

