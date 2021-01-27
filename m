Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558E63067BF
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:23:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhA0XWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:22:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:41122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233664AbhA0XHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 18:07:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 942C964DCC;
        Wed, 27 Jan 2021 23:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611788792;
        bh=CvG3XrKRNFHlQh8hI3roxCvS5hGggHwU2f1ui4sm7iY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G5Gn/VJ1FXkO0euk3ioj/F1xjr6ynXqIFgM2eA1ha5x0YdxFVp9rVEY3x1/oolACU
         IEmgv9oPtomZK4A0OBd3iiVnI+zY/xAw7m/XAyL7nw/YsLFjCQuzDZUHXSNMIKff51
         Mo13vF00Z/5RAgQaLhtrewcFq6e02mTQZWOUJ6Yp1ufkutrsMiZ2vzgtHpebmpryiI
         8FnRrdB+4xrXcxV67bkgjEe0aXMWl/Jr63t6P8AEga4WOxWwHouv8Ua6bjp+vHDi+o
         maniu1663oCiM/FBpsxTkZnwtMpKiw0tu/2IuKybPvR1RGsXhQcsuzFt/2ztn0z3wq
         FlpQpXfQfFJqg==
Message-ID: <76eaee81f200b57d00b9b0f9084267832db01337.camel@kernel.org>
Subject: Re: [net 11/12] net/mlx5e: Revert parameters on errors when
 changing MTU and LRO state without reset
From:   Saeed Mahameed <saeed@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>
Date:   Wed, 27 Jan 2021 15:06:30 -0800
In-Reply-To: <CAF=yD-+DGf_PAQzWScXR7O2J5WY2G5maxMbDQQCNbJXYE6R1Mw@mail.gmail.com>
References: <20210126234345.202096-1-saeedm@nvidia.com>
         <20210126234345.202096-12-saeedm@nvidia.com>
         <CAF=yD-+DGf_PAQzWScXR7O2J5WY2G5maxMbDQQCNbJXYE6R1Mw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-27 at 15:00 -0500, Willem de Bruijn wrote:
> On Wed, Jan 27, 2021 at 3:58 AM Saeed Mahameed <saeedm@nvidia.com>
> wrote:
> > 
> > From: Maxim Mikityanskiy <maximmi@mellanox.com>
> > 
> > Sometimes, channel params are changed without recreating the
> > channels.
> > It happens in two basic cases: when the channels are closed, and
> > when
> > the parameter being changed doesn't affect how channels are
> > configured.
> > Such changes invoke a hardware command that might fail. The whole
> > operation should be reverted in such cases, but the code that
> > restores
> > the parameters' values in the driver was missing. This commit adds
> > this
> > handling.
> > 
> > Fixes: 2e20a151205b ("net/mlx5e: Fail safe mtu and lro setting")
> > Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > ---
> >  .../net/ethernet/mellanox/mlx5/core/en_main.c | 30 +++++++++++++--
> > ----
> >  1 file changed, 21 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index ac76d32bad7d..a9d824a9cb05 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -3764,7 +3764,7 @@ static int set_feature_lro(struct net_device
> > *netdev, bool enable)
> >         struct mlx5e_priv *priv = netdev_priv(netdev);
> >         struct mlx5_core_dev *mdev = priv->mdev;
> >         struct mlx5e_channels new_channels = {};
> > -       struct mlx5e_params *old_params;
> > +       struct mlx5e_params *cur_params;
> >         int err = 0;
> >         bool reset;
> > 
> > @@ -3777,8 +3777,8 @@ static int set_feature_lro(struct net_device
> > *netdev, bool enable)
> >                 goto out;
> >         }
> > 
> > -       old_params = &priv->channels.params;
> > -       if (enable && !MLX5E_GET_PFLAG(old_params,
> > MLX5E_PFLAG_RX_STRIDING_RQ)) {
> > +       cur_params = &priv->channels.params;
> > +       if (enable && !MLX5E_GET_PFLAG(cur_params,
> > MLX5E_PFLAG_RX_STRIDING_RQ)) {
> >                 netdev_warn(netdev, "can't set LRO with legacy
> > RQ\n");
> >                 err = -EINVAL;
> >                 goto out;
> > @@ -3786,18 +3786,23 @@ static int set_feature_lro(struct
> > net_device *netdev, bool enable)
> > 
> >         reset = test_bit(MLX5E_STATE_OPENED, &priv->state);
> > 
> > -       new_channels.params = *old_params;
> > +       new_channels.params = *cur_params;
> >         new_channels.params.lro_en = enable;
> > 
> > -       if (old_params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
> > -               if (mlx5e_rx_mpwqe_is_linear_skb(mdev, old_params,
> > NULL) ==
> > +       if (cur_params->rq_wq_type != MLX5_WQ_TYPE_CYCLIC) {
> > +               if (mlx5e_rx_mpwqe_is_linear_skb(mdev, cur_params,
> > NULL) ==
> >                     mlx5e_rx_mpwqe_is_linear_skb(mdev,
> > &new_channels.params, NULL))
> >                         reset = false;
> >         }
> > 
> >         if (!reset) {
> > -               *old_params = new_channels.params;
> > +               struct mlx5e_params old_params;
> > +
> > +               old_params = *cur_params;
> > +               *cur_params = new_channels.params;
> >                 err = mlx5e_modify_tirs_lro(priv);
> > +               if (err)
> > +                       *cur_params = old_params;
> 
> No need to explicitly save and restore all params if the only one
> changed is lro_en?

not a big deal, this is a practice we follow in all of our unwind
procedures, 
the code will change in net-next to use a generic function that would
restore all params regardless of what changed and what not .. so we
figured to have a one flow that will be easy to replace in net-next.


