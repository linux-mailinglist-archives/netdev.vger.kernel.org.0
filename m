Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96E66589BD
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 07:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiL2Gdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 01:33:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiL2Gdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 01:33:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B915927F
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 22:33:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A8476171C
        for <netdev@vger.kernel.org>; Thu, 29 Dec 2022 06:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65E5C433EF;
        Thu, 29 Dec 2022 06:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672295630;
        bh=4BnnwzDbEDD29vJLAnaSNNPiYmRLLQ6FRcDo8u2WocQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bt1Jtwyg07mxN9dIVUbMrEk7vHivXYk84fGZl1FljUsL+hENFpM/FI8rTvzWSDXks
         NqPUeTs1zMtHNwpZi1holW4H0TejGUc7+nRa7byvl3fRWczSx3ulDFNpiBQzIIsjA+
         exkyPl79UrCHTWBg5F7zIqapPCH7YPX79Z/+sYGUptn0j//bVTrzkMbi8pHkil//h1
         KF3KHcV9aGMnqSMPj1K3jzCkKbZI5r+8K60y5rT8eDxyVRz9CqzdmBljpO2wc2Fwm1
         w4Ar8C+4IWA/f0vxYlBOte4oMjywAzEaBS4Q1dEWGree1patl3PuKEutc8MHmRJeEu
         Gn+/g9U6GJEow==
Date:   Thu, 29 Dec 2022 08:33:45 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [net 04/12] net/mlx5: Avoid recovery in probe flows
Message-ID: <Y600yfAjhObdtaJb@unreal>
References: <20221228194331.70419-1-saeed@kernel.org>
 <20221228194331.70419-5-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221228194331.70419-5-saeed@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 11:43:23AM -0800, Saeed Mahameed wrote:
> From: Shay Drory <shayd@nvidia.com>
> 
> Currently, recovery is done without considering whether the device is
> still in probe flow.
> This may lead to recovery before device have finished probed
> successfully. e.g.: while mlx5_init_one() is running. Recovery flow is
> using functionality that is loaded only by mlx5_init_one(), and there
> is no point in running recovery without mlx5_init_one() finished
> successfully.
> 
> Fix it by waiting for probe flow to finish and checking whether the
> device is probed before trying to perform recovery.
> 
> Fixes: 51d138c2610a ("net/mlx5: Fix health error state handling")
> Signed-off-by: Shay Drory <shayd@nvidia.com>
> Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/health.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> index 86ed87d704f7..96417c5feed7 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> @@ -674,6 +674,12 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
>  	dev = container_of(priv, struct mlx5_core_dev, priv);
>  	devlink = priv_to_devlink(dev);
>  
> +	mutex_lock(&dev->intf_state_mutex);
> +	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
> +		mlx5_core_err(dev, "health works are not permitted at this stage\n");
> +		return;
> +	}

This bit is already checked when health recovery is queued in mlx5_trigger_health_work().

  764 void mlx5_trigger_health_work(struct mlx5_core_dev *dev)
  765 {
  766         struct mlx5_core_health *health = &dev->priv.health;
  767         unsigned long flags;
  768
  769         spin_lock_irqsave(&health->wq_lock, flags);
  770         if (!test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags))
  771                 queue_work(health->wq, &health->fatal_report_work);
  772         else
  773                 mlx5_core_err(dev, "new health works are not permitted at this stage\n");
  774         spin_unlock_irqrestore(&health->wq_lock, flags);
  775 }

You probably need to elevate this check to poll_health() routine and
change intf_state_mutex to be spinlock.

Or another solution is to start health polling only when init complete.

Thanks


> +	mutex_unlock(&dev->intf_state_mutex);
>  	enter_error_state(dev, false);
>  	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
>  		devl_lock(devlink);
> -- 
> 2.38.1
> 
