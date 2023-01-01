Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1065965A932
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 07:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjAAGwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 01:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbjAAGwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 01:52:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743953B8
        for <netdev@vger.kernel.org>; Sat, 31 Dec 2022 22:52:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06BAA60CBA
        for <netdev@vger.kernel.org>; Sun,  1 Jan 2023 06:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD4BC433EF;
        Sun,  1 Jan 2023 06:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672555958;
        bh=lqetQb5JAs6P6MwR8wtETKh7xfFOhl300RoNLLBF1co=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cycte21c0d59XEFEGVUlZm/O/NeDmDlWe5gfOKqH52POiwvUaGUYvjIGdInNASJNT
         E/Xni8zkklliFEy3/2GVvL2wbir4Vn2d+lU962kgkYpDuP4LDa8iGlEp26a94VunG4
         j+h6YCzqvQyX0pd6Ga1wvwJxrO5OtRzDTTqY3N0KwgF5MReDVwn8ACrj5DoHa+0udT
         Py24hO6rx29KBqIiwAwt6R+ybX1x6CB5TKKQXwG8LXIq5p/j2JGmu6hMlr9igY7BuJ
         ZuLz/DuyasXgzo/Bt1W+nVigwaO8XopYbdH4WDu9lYGo4SceQY2RUSsyKtO17CG6T8
         l7LX8+px2v2wA==
Date:   Sun, 1 Jan 2023 08:52:33 +0200
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
Message-ID: <Y7Etsai7gb5jv+LA@unreal>
References: <20221228194331.70419-1-saeed@kernel.org>
 <20221228194331.70419-5-saeed@kernel.org>
 <Y600yfAjhObdtaJb@unreal>
 <Y63cpg47dpl7c6BM@x130>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y63cpg47dpl7c6BM@x130>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 29, 2022 at 10:29:58AM -0800, Saeed Mahameed wrote:
> On 29 Dec 08:33, Leon Romanovsky wrote:
> > On Wed, Dec 28, 2022 at 11:43:23AM -0800, Saeed Mahameed wrote:
> > > From: Shay Drory <shayd@nvidia.com>
> > > 
> > > Currently, recovery is done without considering whether the device is
> > > still in probe flow.
> > > This may lead to recovery before device have finished probed
> > > successfully. e.g.: while mlx5_init_one() is running. Recovery flow is
> > > using functionality that is loaded only by mlx5_init_one(), and there
> > > is no point in running recovery without mlx5_init_one() finished
> > > successfully.
> > > 
> > > Fix it by waiting for probe flow to finish and checking whether the
> > > device is probed before trying to perform recovery.
> > > 
> > > Fixes: 51d138c2610a ("net/mlx5: Fix health error state handling")
> > > Signed-off-by: Shay Drory <shayd@nvidia.com>
> > > Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> > > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > > ---
> > >  drivers/net/ethernet/mellanox/mlx5/core/health.c | 6 ++++++
> > >  1 file changed, 6 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > > index 86ed87d704f7..96417c5feed7 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> > > @@ -674,6 +674,12 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
> > >  	dev = container_of(priv, struct mlx5_core_dev, priv);
> > >  	devlink = priv_to_devlink(dev);
> > > 
> > > +	mutex_lock(&dev->intf_state_mutex);
> > > +	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
> > > +		mlx5_core_err(dev, "health works are not permitted at this stage\n");
> > > +		return;
> > > +	}
> > 

<...>

> > Or another solution is to start health polling only when init complete.
> > 
> 
> Also very complex and very risky to do in rc.
> Health poll should be running on dynamic driver reloads,
> for example devlink reload, but not on first probe.. if we are going to
> start after probe then we will have to stop (sync) any
> health work before .remove, which is a locking nightmare.. we've been there
> before.

I afraid that my proposed solution distracted you. The real issue is
that this patch can't be correct.

Let's focus on MLX5_DROP_NEW_HEALTH_WORK bit. It is checked while holding different
locks, so one of the locks is wrong and not needed.

If MLX5_DROP_NEW_HEALTH_WORK bit can't be changed after/during queuing the work, the newly
added check in mlx5_fw_fatal_reporter_err_work will be redundant.

If MLX5_DROP_NEW_HEALTH_WORK bit can be changed after queuing the work. the check is racy and
can have different results immediately after releasing intf_state_mutex.

Thanks
