Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD5C697B07
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 12:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbjBOLqi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 06:46:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbjBOLqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 06:46:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E9CA5D9
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 03:46:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAC86B82136
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:46:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A2FC433EF;
        Wed, 15 Feb 2023 11:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676461593;
        bh=oLd+bTemaeHCTFjqESqMPP68AI68PtWwrxVwKSbgU04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CL8XSHUF4jnnwEjwrjf92MqCpDLNYZPEycMTyDbQ9vCf9dVrsFz1XQkMiut8hSiN7
         SZpB8mUAfYsZx0eBjBafIIW/9B5i6dOmwp1OfRvwz2wFOgQvINlrmjXG9a54zaR+xU
         xe/Czz2X2y3nRdbUMTZhpCM7aiOXujmWtpm/zWaq0C7NbJ6X7kqxQfmKuP3st2k2Es
         f61b9hA4cep4JGq20J5QxKq+6lOTKkfj/OfEn/apsy/fB7u32Nv/cjKqLV9Ioqg8J6
         SqLvkS3oDcgFXaw/Hl1vSsre4CQuwOq2SNsY0VsMxcIOobQVU8W3B3g3BNkEHbZIGu
         i4sxIrF/gS4Sw==
Date:   Wed, 15 Feb 2023 13:46:29 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: Re: [net-next 01/15] net/mlx5: Lag, Let user configure multiport
 eswitch
Message-ID: <Y+zGFVZPj2UzY0K2@unreal>
References: <20230210221821.271571-1-saeed@kernel.org>
 <20230210221821.271571-2-saeed@kernel.org>
 <23c46b99-1fbf-0155-b2d0-2ea3d1fe9d17@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23c46b99-1fbf-0155-b2d0-2ea3d1fe9d17@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 06:07:54PM +0100, Alexander Lobakin wrote:
> From: Saeed Mahameed <saeed@kernel.org>
> Date: Fri, 10 Feb 2023 14:18:07 -0800
> 
> > From: Roi Dayan <roid@nvidia.com>
> > 
> > Instead of activating multiport eswitch dynamically through
> > adding a TC rule and meeting certain conditions, allow the user
> > to activate it through devlink.
> > This will remove the forced requirement of using TC.
> > e.g. Bridge offload.
> > 
> > Example:
> >     $ devlink dev param set pci/0000:00:0b.0 name esw_multiport value 1 \
> >                   cmode runtime
> > 
> > Signed-off-by: Roi Dayan <roid@nvidia.com>
> > Reviewed-by: Maor Dickman <maord@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > ---
> >  Documentation/networking/devlink/mlx5.rst     |  4 ++
> >  .../net/ethernet/mellanox/mlx5/core/devlink.c | 56 +++++++++++++++++++
> >  .../net/ethernet/mellanox/mlx5/core/devlink.h |  1 +
> >  .../mellanox/mlx5/core/en/tc/act/mirred.c     |  9 ---
> >  .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 22 +-------
> >  .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  6 --
> >  .../net/ethernet/mellanox/mlx5/core/lag/lag.c |  4 +-
> >  .../net/ethernet/mellanox/mlx5/core/lag/lag.h |  1 +
> >  .../ethernet/mellanox/mlx5/core/lag/mpesw.c   | 46 +++++++--------
> >  .../ethernet/mellanox/mlx5/core/lag/mpesw.h   | 12 +---
> >  10 files changed, 87 insertions(+), 74 deletions(-)
> > 
> > diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
> > index 29ad304e6fba..1d2ad2727da1 100644
> > --- a/Documentation/networking/devlink/mlx5.rst
> > +++ b/Documentation/networking/devlink/mlx5.rst
> > @@ -54,6 +54,10 @@ parameters.
> >       - Control the number of large groups (size > 1) in the FDB table.
> >  
> >         * The default value is 15, and the range is between 1 and 1024.
> > +   * - ``esw_multiport``
> > +     - Boolean
> > +     - runtime
> > +     - Set the E-Switch lag mode to multiport.
> >  
> >  The ``mlx5`` driver supports reloading via ``DEVLINK_CMD_RELOAD``
> >  
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> > index b742e04deec1..49392870f695 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
> > @@ -7,6 +7,7 @@
> >  #include "fw_reset.h"
> >  #include "fs_core.h"
> >  #include "eswitch.h"
> > +#include "lag/lag.h"
> >  #include "esw/qos.h"
> >  #include "sf/dev/dev.h"
> >  #include "sf/sf.h"
> > @@ -437,6 +438,55 @@ static int mlx5_devlink_large_group_num_validate(struct devlink *devlink, u32 id
> >  	return 0;
> >  }
> >  
> > +static int mlx5_devlink_esw_multiport_set(struct devlink *devlink, u32 id,
> > +					  struct devlink_param_gset_ctx *ctx)
> > +{
> > +	struct mlx5_core_dev *dev = devlink_priv(devlink);
> > +	int err = 0;
> > +
> > +	if (!MLX5_ESWITCH_MANAGER(dev))
> > +		return -EOPNOTSUPP;
> > +
> > +	if (ctx->val.vbool)
> > +		err = mlx5_lag_mpesw_enable(dev);
> > +	else
> > +		mlx5_lag_mpesw_disable(dev);
> > +
> > +	return err;
> 
> How about
> 
> 	if (ctx->val.vbool)
> 		return mlx5_lag_mpesw_enable(dev);
> 	else
> 		mlx5_lag_mpesw_disable(dev);
> 
> 	return 0;

If such construction is used, there won't need in "else".

 	if (ctx->val.vbool)
 		return mlx5_lag_mpesw_enable(dev);

 	mlx5_lag_mpesw_disable(dev);
 	return 0;




> 
> ?
> 
> > +}
> > +
> > +static int mlx5_devlink_esw_multiport_get(struct devlink *devlink, u32 id,
> > +					  struct devlink_param_gset_ctx *ctx)
> [...]
> 
> Thanks,
> Olek
