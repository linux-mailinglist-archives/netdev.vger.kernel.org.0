Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4836E6E2FC7
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 10:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjDOItY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 04:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDOItW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 04:49:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448C95583
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 01:49:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB46761019
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 08:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37DEC433EF;
        Sat, 15 Apr 2023 08:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681548560;
        bh=LZ2zqqwFWiribnSRQA+fdrS8hBsr8T4OIUGo7tIkoug=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oRUFozlz5pRM1t3KHnacUtj5AnijHlZNgrDAQReJ2mWrvhXn8bitleiAAU+xB+jj7
         jwgALHvW6xQCmQ2VKGs8C+2zZf+OE6LY9Rf3b7/3SomTMzmhWljJELtcSd62LHyo51
         smZiEJa8TQ9c2Tb2I5+dVQE9l5de+gqr050CDrfC7TaWtX6yNEdI4IVvamUdeF3kk3
         v96C/kBJ63HgHcYsjcDtCLDFCvl3sKm3VGKHpfJvsIL4xLR/8ohQPnMcHbTJT0/BaQ
         H/xxUIKDubXllsjNihNTM+htMexNB/B5CpDSEbCuXPfNTyqgTelgEJWaAU8Q/7kv/t
         YsjaBi/CqnCyA==
Date:   Sat, 15 Apr 2023 11:49:15 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v1 04/10] net/mlx5e: Prepare IPsec packet
 reformat code for tunnel mode
Message-ID: <20230415084915.GB17993@unreal>
References: <cover.1681388425.git.leonro@nvidia.com>
 <f9e31cf8ff6a60ea4eb714c93e5fad7fbd56b860.1681388425.git.leonro@nvidia.com>
 <7815a749-f10a-ff5b-6050-6ca766a263b4@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7815a749-f10a-ff5b-6050-6ca766a263b4@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 05:40:40PM -0500, Samudrala, Sridhar wrote:
> 
> 
> On 4/13/2023 7:29 AM, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Refactor setup_pkt_reformat() function to accommodate future extension
> > to support tunnel mode.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >   .../mellanox/mlx5/core/en_accel/ipsec.c       |  1 +
> >   .../mellanox/mlx5/core/en_accel/ipsec.h       |  2 +-
> >   .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 81 ++++++++++++++-----
> >   3 files changed, 63 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > index def01bfde610..359da277c03a 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > @@ -297,6 +297,7 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
> >   	attrs->upspec.sport = ntohs(x->sel.sport);
> >   	attrs->upspec.sport_mask = ntohs(x->sel.sport_mask);
> >   	attrs->upspec.proto = x->sel.proto;
> > +	attrs->mode = x->props.mode;
> >   	mlx5e_ipsec_init_limits(sa_entry, attrs);
> >   }
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > index bb89e18b17b4..ae525420a492 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
> > @@ -77,7 +77,7 @@ struct mlx5_replay_esn {
> >   struct mlx5_accel_esp_xfrm_attrs {
> >   	u32   spi;
> > -	u32   flags;
> > +	u32   mode;
> >   	struct aes_gcm_keymat aes_gcm;
> >   	union {
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > index 060be020ca64..6a1ed4114054 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > @@ -10,6 +10,7 @@
> >   #include "lib/fs_chains.h"
> >   #define NUM_IPSEC_FTE BIT(15)
> > +#define MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_SIZE 16
> >   struct mlx5e_ipsec_fc {
> >   	struct mlx5_fc *cnt;
> > @@ -836,40 +837,80 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
> >   	return 0;
> >   }
> > +static int
> > +setup_pkt_transport_reformat(struct mlx5_accel_esp_xfrm_attrs *attrs,
> > +			     struct mlx5_pkt_reformat_params *reformat_params)
> > +{
> > +	u8 *reformatbf;
> > +	__be32 spi;
> > +
> > +	switch (attrs->dir) {
> > +	case XFRM_DEV_OFFLOAD_IN:
> > +		reformat_params->type = MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT;
> > +		break;
> > +	case XFRM_DEV_OFFLOAD_OUT:
> > +		if (attrs->family == AF_INET)
> > +			reformat_params->type =
> > +				MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4;
> > +		else
> > +			reformat_params->type =
> > +				MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;
> 
> Is it guaranteed that attrs->family will be either AF_INET or AF_INET6?
> Later patches seem to indicate that this may not be true as they use
> switch statement and includes default case

Yes, we have relevant check in mlx5e_xfrm_validate_state():

   380         if (x->props.family != AF_INET &&
   381             x->props.family != AF_INET6) {
   382                 NL_SET_ERR_MSG_MOD(extack, "Only IPv4/6 xfrm states may be offloaded");
   383                 return -EINVAL;
   384         }

> 

<...>

> > -	if (attrs->family == AF_INET)
> > -		reformat_params.type =
> > -			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4;
> > -	else
> > -		reformat_params.type =
> > -			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;
> 
> same here

See my answer above.

Thanks
