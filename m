Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F34482608
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 23:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhLaWqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 17:46:18 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56552 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231847AbhLaWqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 17:46:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E4C261826;
        Fri, 31 Dec 2021 22:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7488FC36AE9;
        Fri, 31 Dec 2021 22:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640990776;
        bh=WH9X1Ez5mzTdfGWS1Cc+jTto7XALQCuzQE0nmz4pGvY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=INeUZ04sSy4VFgM2zqD2UAtAPMbCQLZ8/5cIP1UNP8DMsIf6tBZzEgGGekmgGRbPY
         6vESN3V8WuvuFqvbwkcRUlc3hZ9C+rj0EK8TQqGQ1d98eHhN397VwOo+r9+5r6U0cr
         Ow5nZEikvDg4r2/fYY5xQM7bL7icWI0OUJkzkpIdX0MLb5E5u1eWPohQ5lEos2W64s
         Xe2XvGXA9GGvi8xUtgnNEUaG8M78Ia3PCQOU5yvrP3n7y6SJf1bg+9f3Q8b0JPQSG8
         KM4M3X1lZ2WREvp2yMkWRs9lcrbFkmlEYrUXqzVOfRz+psNSctYDcakpG6RAA3UUKV
         bAK8IEikQzOOA==
Date:   Fri, 31 Dec 2021 14:46:15 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Zizhuang Deng <sunsetdzz@gmail.com>, mbloch@nvidia.com
Cc:     saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx5: Add vport return value checks
Message-ID: <20211231224615.oneibk4ks5wofgf7@sx1>
References: <20211230052558.959617-1-sunsetdzz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211230052558.959617-1-sunsetdzz@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 01:25:58PM +0800, Zizhuang Deng wrote:
>add missing vport return value checks for recent code, as in [1].
>
>Ref:
>[1] https://lkml.org/lkml/2020/11/1/315
>

Where did this patch come from ? real bug ? or just aligning the code to
be according the link below ? 
because all the use-cases below are supposed to be guaranteed to have a
valid vport object for uplink/pf/and ecpf vportrs, i am not against the
patch, I am just trying to understand if there is a hidden bug somewhere .. 



>Signed-off-by: Zizhuang Deng <sunsetdzz@gmail.com>
>---
> .../mellanox/mlx5/core/eswitch_offloads.c     | 20 +++++++++++++++++++
> 1 file changed, 20 insertions(+)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>index f4eaa5893886..fda214021738 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c

[...]

>@@ -1309,11 +1317,15 @@ static void esw_del_fdb_peer_miss_rules(struct mlx5_eswitch *esw)
>
> 	if (mlx5_ecpf_vport_exists(esw->dev)) {
> 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_ECPF);
>+		if (IS_ERR(vport))
>+			return;

memleak, we need to hit kvfree(flows) below, 
instead of returning you should make the del_flow conditional and continue
to next steps in the esw_del_fdb_peer_miss_rules routine, 
e.g:
if (vport)
	mlx5_del_flow_rules(flows[vport->index]);

> 		mlx5_del_flow_rules(flows[vport->index]);
> 	}
>
> 	if (mlx5_core_is_ecpf_esw_manager(esw->dev)) {
> 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_PF);
>+		if (IS_ERR(vport))
>+			return;

ditto 

> 		mlx5_del_flow_rules(flows[vport->index]);
> 	}
> 	kvfree(flows);
>@@ -2385,6 +2397,9 @@ static int esw_set_uplink_slave_ingress_root(struct mlx5_core_dev *master,
> 	if (master) {
> 		esw = master->priv.eswitch;
> 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
>+		if (IS_ERR(vport))
>+			return PTR_ERR(vport);
>+
> 		MLX5_SET(set_flow_table_root_in, in, table_of_other_vport, 1);
> 		MLX5_SET(set_flow_table_root_in, in, table_vport_number,
> 			 MLX5_VPORT_UPLINK);
>@@ -2405,6 +2420,9 @@ static int esw_set_uplink_slave_ingress_root(struct mlx5_core_dev *master,
> 	} else {
> 		esw = slave->priv.eswitch;
> 		vport = mlx5_eswitch_get_vport(esw, MLX5_VPORT_UPLINK);
>+		if (IS_ERR(vport))
>+			return PTR_ERR(vport);
>+
> 		ns = mlx5_get_flow_vport_acl_namespace(slave,
> 						       MLX5_FLOW_NAMESPACE_ESW_INGRESS,
> 						       vport->index);
>@@ -2590,6 +2608,8 @@ static void esw_unset_master_egress_rule(struct mlx5_core_dev *dev)
>
> 	vport = mlx5_eswitch_get_vport(dev->priv.eswitch,
> 				       dev->priv.eswitch->manager_vport);
>+	if (IS_ERR(vport))
>+		return;
>
> 	esw_acl_egress_ofld_cleanup(vport);
> }
>-- 
>2.25.1
>
