Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88568464742
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbhLAGk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346960AbhLAGkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66550C061756
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:37:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B225FCE1D49
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ACDC53FD3;
        Wed,  1 Dec 2021 06:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340644;
        bh=Bok9KkenqvsafCpkZcq9UC8vbfgTDpDWTgF7EfXOaaQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RyHbVyto1E4B7Fpy5GVxTx/zkehb+HoBLQULzbP+TnfQK0/5ZThLt9OWpGfz/pRMs
         amdlFQHMSv9rMQiHDh4E4whw4HSPN4VFBk3RBOIy2RzJTCP96LUQzXedp+IFQD+kqE
         5dA6CINKHeC/FqdM73UMFAKsn6xn4l0fRw7jZXXAS1MPt6AF2tAWXIBo3UTAcHNH6a
         sHgdiR0MZmooaArSKxLAjYw3n1Dx9zOQHApOVDUFGyxko+7WkOATT5in664/SFXxs+
         6FOMcvkdcRJ+Xc+43eCSj7DB3N2HBQDQwd0JpUF0dwMz+Sq/cXCuM1vEHzoyHsw+85
         Bc7dll5dVuvcw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/13] net/mlx5: E-Switch, fix single FDB creation on BlueField
Date:   Tue, 30 Nov 2021 22:37:03 -0800
Message-Id: <20211201063709.229103-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Bloch <mbloch@nvidia.com>

Always use MLX5_FLOW_TABLE_OTHER_VPORT flag when creating egress ACL
table for single FDB. Not doing so on BlueField will make firmware fail
the command. On BlueField the E-Switch manager is the ECPF (vport 0xFFFE)
which is filled in the flow table creation command but as the
other_vport field wasn't set the firmware complains about a bad parameter.

This is different from a regular HCA where the E-Switch manager vport is
the PF (vport 0x0). Passing MLX5_FLOW_TABLE_OTHER_VPORT will make the
firmware happy both on BlueField and on regular HCAs without special
condition for each.

This fixes the bellow firmware syndrome:
mlx5_cmd_check:819:(pid 571): CREATE_FLOW_TABLE(0x930) op_mod(0x0) failed, status bad parameter(0x3), syndrome (0x754a4)

Fixes: db202995f503 ("net/mlx5: E-Switch, add logic to enable shared FDB")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index a46455694f7a..275af1d2b4d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2512,6 +2512,7 @@ static int esw_set_master_egress_rule(struct mlx5_core_dev *master,
 	struct mlx5_eswitch *esw = master->priv.eswitch;
 	struct mlx5_flow_table_attr ft_attr = {
 		.max_fte = 1, .prio = 0, .level = 0,
+		.flags = MLX5_FLOW_TABLE_OTHER_VPORT,
 	};
 	struct mlx5_flow_namespace *egress_ns;
 	struct mlx5_flow_table *acl;
-- 
2.31.1

