Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59BA94F3ECE
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344283AbiDEUAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573712AbiDETut (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 15:50:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A861B7B3;
        Tue,  5 Apr 2022 12:48:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3EB8618DF;
        Tue,  5 Apr 2022 19:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A35C385A3;
        Tue,  5 Apr 2022 19:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649188127;
        bh=3cx2HlRw5UuwWQnD4r+Bq8Bs1343pRf5RQaY1RJUjFg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gn5j0EirRVPADPDCHdFHvxrX19bAfA7ZY649lONoQ0JI8Kv8e3MG5cIPjMESNQgWQ
         M2YAt6biR1xLVV1tWDhzNPPIOVQZgu+dbDngcHTIcc62HxOjUvKTH9Uus19CGgbOYn
         JQ6vSzmFyOaMHBhUPcFd26KaOaJvv9hMwCAsvlBmUD/HsatZ81a07IILcspGIopIxv
         LDRbIhkuQeHq2zKPzE9OfY/1zteVNTBQ2GyrJD+56QA+pQq5ekvJgeoliwSc+I3N8w
         DYY7OqlxJRhgEhMTaT2KIC3FN253Qary9ggacWM4OAB5YcRG9HVryFLmt8m4SzmzQI
         j40FwCAobAUew==
Date:   Tue, 5 Apr 2022 12:48:45 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Patrisious Haddad <phaddad@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH mlx5-next 1/3] net/mlx5: Nullify eq->dbg and qp->dbg
 pointers post destruction
Message-ID: <20220405194845.c443x4gf522c2kgv@sx1>
References: <cover.1649139915.git.leonro@nvidia.com>
 <032d54e1ed92d0f288b385d6343a5b6e109daabe.1649139915.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <032d54e1ed92d0f288b385d6343a5b6e109daabe.1649139915.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05 Apr 11:12, Leon Romanovsky wrote:
>From: Patrisious Haddad <phaddad@nvidia.com>
>
>Prior to this patch in the case that destroy_unmap_eq()
>failed and was called again, it triggered an additional call of

Where is it being failed and called again ? this shouldn't even be an
option, we try to keep mlx5 symmetrical, constructors and destructors are
supposed to be called only once in their respective positions.
the callers must be fixed to avoid re-entry, or change destructors to clear
up all resources even on failures, no matter what do not invent a reentry
protocols to mlx5 destructors.

>mlx5_debug_eq_remove() which causes a kernel crash, since
>eq->dbg was not nullified in previous call.
>

[...]

> int mlx5_debug_cq_add(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq)
>diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
>index 229728c80233..3c61f355cdac 100644
>--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
>+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
>@@ -386,16 +386,20 @@ void mlx5_eq_disable(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
> }
> EXPORT_SYMBOL(mlx5_eq_disable);
>
>-static int destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
>+static int destroy_unmap_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
>+			    bool reentry)
> {
> 	int err;
>
> 	mlx5_debug_eq_remove(dev, eq);
>
> 	err = mlx5_cmd_destroy_eq(dev, eq->eqn);
>-	if (err)
>+	if (err) {
> 		mlx5_core_warn(dev, "failed to destroy a previously created eq: eqn %d\n",
> 			       eq->eqn);
>+		if (reentry)
>+			return err;
>+	}
>
> 	mlx5_frag_buf_free(dev, &eq->frag_buf);
> 	return err;
>@@ -481,7 +485,7 @@ static int destroy_async_eq(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
> 	int err;
>
> 	mutex_lock(&eq_table->lock);
>-	err = destroy_unmap_eq(dev, eq);
>+	err = destroy_unmap_eq(dev, eq, false);
> 	mutex_unlock(&eq_table->lock);
> 	return err;
> }
>@@ -748,12 +752,15 @@ EXPORT_SYMBOL(mlx5_eq_create_generic);
>
> int mlx5_eq_destroy_generic(struct mlx5_core_dev *dev, struct mlx5_eq *eq)
> {
>+	struct mlx5_eq_table *eq_table = dev->priv.eq_table;
> 	int err;
>
> 	if (IS_ERR(eq))
> 		return -EINVAL;
>
>-	err = destroy_async_eq(dev, eq);
>+	mutex_lock(&eq_table->lock);

Here you are inventing the re-entry. 
Please drop this and fix properly. And avoid boolean parameters to mlx5 core
functions as much as possible, let's keep mlx5_core simple.

>+	err = destroy_unmap_eq(dev, eq, true);
>+	mutex_unlock(&eq_table->lock);
> 	if (err)
> 		goto out;
>
>@@ -851,7 +858,7 @@ static void destroy_comp_eqs(struct mlx5_core_dev *dev)
> 	list_for_each_entry_safe(eq, n, &table->comp_eqs_list, list) {
> 		list_del(&eq->list);
> 		mlx5_eq_disable(dev, &eq->core, &eq->irq_nb);
>-		if (destroy_unmap_eq(dev, &eq->core))
>+		if (destroy_unmap_eq(dev, &eq->core, false))
> 			mlx5_core_warn(dev, "failed to destroy comp EQ 0x%x\n",
> 				       eq->core.eqn);
> 		tasklet_disable(&eq->tasklet_ctx.task);
>@@ -915,7 +922,7 @@ static int create_comp_eqs(struct mlx5_core_dev *dev)
> 			goto clean_eq;
> 		err = mlx5_eq_enable(dev, &eq->core, &eq->irq_nb);
> 		if (err) {
>-			destroy_unmap_eq(dev, &eq->core);
>+			destroy_unmap_eq(dev, &eq->core, false);
> 			goto clean_eq;
> 		}
>
>-- 
>2.35.1
>
