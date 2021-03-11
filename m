Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7153380E2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhCKWtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:49:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhCKWsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:48:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68EE164F26;
        Thu, 11 Mar 2021 22:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502934;
        bh=eUmrK8GRXsZr57Q1ma7ZCQ5zHLOd6SiqvFB7Dvv46JA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KKem5FVuuzjhWF4GcRWDO/e1alGIXIs1oX6WxhCK+d8KKYDMi0gCrhWRe3KnlqifY
         J0s3cO/Xn9/w2VkisqvUItwNJHfyijp+LKTfxX6ocs/uo4SEmY2RPH35NHnDP5tluf
         YfuGPOC6UoBK5yYUKqbyyF40Fb+Nfjt5yoOMgWug1BR1trwqGbaXgLn3wxJTNm4ho7
         X0kSp89rk6jjw/U0otzFCiusd+2OD9pgtQO2LrdvDZjPCfvjaPyK8xfws1A2jTN+JU
         VJWi6JAS1nEuAaGR7F9D+mvL3XPGcwFwZHZZDJI8hkylTuE1ZRjyRVei4lNJg3+gGg
         l2Y3rGjtgElgA==
Message-ID: <3bcd5407728640109a1868b2425132461cacc6fc.camel@kernel.org>
Subject: Re: [PATCH] net/mlx5e: allocate 'indirection_rqt' buffer dynamically
From:   Saeed Mahameed <saeed@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Noam Stolero <noams@nvidia.com>, Tal Gilboa <talgi@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>, Oz Shlomo <ozsh@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Date:   Thu, 11 Mar 2021 14:48:52 -0800
In-Reply-To: <31a031b3-e44e-66cb-a713-627be1f64ff6@gmail.com>
References: <20210308153318.2486939-1-arnd@kernel.org>
         <31a031b3-e44e-66cb-a713-627be1f64ff6@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-08 at 18:28 +0200, Tariq Toukan wrote:
> 
> 
> On 3/8/2021 5:32 PM, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > Increasing the size of the indirection_rqt array from 128 to 256
> > bytes
> > pushed the stack usage of the mlx5e_hairpin_fill_rqt_rqns()
> > function
> > over the warning limit when building with clang and CONFIG_KASAN:
> > 
> > drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:970:1: error: stack
> > frame size of 1180 bytes in function 'mlx5e_tc_add_nic_flow' [-
> > Werror,-Wframe-larger-than=]
> > 
> > Using dynamic allocation here is safe because the caller does the
> > same, and it reduces the stack usage of the function to just a few
> > bytes.
> > 
> > Fixes: 1dd55ba2fb70 ("net/mlx5e: Increase indirection RQ table size
> > to 256")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >   drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 16
> > +++++++++++++---
> >   1 file changed, 13 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > index 0da69b98f38f..66f98618dc13 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > @@ -445,12 +445,16 @@ static void
> > mlx5e_hairpin_destroy_transport(struct mlx5e_hairpin *hp)
> >         mlx5_core_dealloc_transport_domain(hp->func_mdev, hp->tdn);
> >   }
> >   
> > -static void mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp,
> > void *rqtc)
> > +static int mlx5e_hairpin_fill_rqt_rqns(struct mlx5e_hairpin *hp,
> > void *rqtc)
> >   {
> > -       u32 indirection_rqt[MLX5E_INDIR_RQT_SIZE], rqn;
> > +       u32 *indirection_rqt, rqn;
> >         struct mlx5e_priv *priv = hp->func_priv;
> >         int i, ix, sz = MLX5E_INDIR_RQT_SIZE;
> >   
> > +       indirection_rqt = kzalloc(sz, GFP_KERNEL);
> > +       if (!indirection_rqt)
> > +               return -ENOMEM;
> > +
> >         mlx5e_build_default_indir_rqt(indirection_rqt, sz,
> >                                       hp->num_channels);
> >   
> > @@ -462,6 +466,9 @@ static void mlx5e_hairpin_fill_rqt_rqns(struct
> > mlx5e_hairpin *hp, void *rqtc)
> >                 rqn = hp->pair->rqn[ix];
> >                 MLX5_SET(rqtc, rqtc, rq_num[i], rqn);
> >         }
> > +
> > +       kfree(indirection_rqt);
> > +       return 0;
> >   }
> >   
> >   static int mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin
> > *hp)
> > @@ -482,12 +489,15 @@ static int
> > mlx5e_hairpin_create_indirect_rqt(struct mlx5e_hairpin *hp)
> >         MLX5_SET(rqtc, rqtc, rqt_actual_size, sz);
> >         MLX5_SET(rqtc, rqtc, rqt_max_size, sz);
> >   
> > -       mlx5e_hairpin_fill_rqt_rqns(hp, rqtc);
> > +       err = mlx5e_hairpin_fill_rqt_rqns(hp, rqtc);
> > +       if (err)
> > +               goto out;
> >   
> >         err = mlx5_core_create_rqt(mdev, in, inlen, &hp-
> > >indir_rqt.rqtn);
> >         if (!err)
> >                 hp->indir_rqt.enabled = true;
> >   
> > +out:
> >         kvfree(in);
> >         return err;
> >   }
> > 
> 
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> Thanks for your patch.
> 
> Tariq

Applied to net-next-mlx5
Thanks!


