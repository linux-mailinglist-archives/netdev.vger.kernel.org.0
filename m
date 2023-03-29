Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB5A6CF25F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjC2SmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjC2SmJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:42:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB3AD186
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:42:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D217B82403
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13EB2C433D2;
        Wed, 29 Mar 2023 18:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680115325;
        bh=QsIGq7WE1vwFXfzwp5+C4/cFEPgtXdkH9QVlcJQVFT8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qOyYb/VzT/vvskYBqk+sNc4FH9LApuky1i7hY1OLgmfBKjW4OycbkX9TLwoFftIl4
         pEtiDo5z+MYSclUMlq8Qp/27wCRqObdTujIPgVLIJ426OwB01nXCxfd29SgSuDvFyf
         5zA6mnxxw+9QWr+iuJ+V+oQ3FxRMxwJbcsRCNijQwHurh/LMpqic6ymQTwH36qzSO+
         jRE4Yq3FQfYkSqoeVe0bP/ouN3gDHXyIBsd9zi3LS3Z66SLNd6+jBp/uOYNcPtSSbV
         0cnJy+LLuYCXxzvC2TpCt+jZmL5JhJO5Q8Iv61gT0COwZUPylSSIC4uuYXQ3VG9srv
         K/PdcBrfWqgOg==
Date:   Wed, 29 Mar 2023 21:42:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Emeel Hakim <ehakim@nvidia.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <20230329184201.GB831478@unreal>
References: <20230329122107.22658-1-ehakim@nvidia.com>
 <20230329122107.22658-2-ehakim@nvidia.com>
 <ZCROr7DhsoRyU1qP@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCROr7DhsoRyU1qP@hog>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 04:43:59PM +0200, Sabrina Dubroca wrote:
> 2023-03-29, 15:21:04 +0300, Emeel Hakim wrote:
> > Add support for MACsec offload operations for VLAN driver
> > to allow offloading MACsec when VLAN's real device supports
> > Macsec offload by forwarding the offload request to it.
> > 
> > Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> > ---
> > V1 -> V2: - Consult vlan_features when adding NETIF_F_HW_MACSEC.
> 
> Uh? You're not actually doing that? You also dropped the
> changes to vlan_dev_fix_features without explaining why.

vlan_dev_fix_features() relies on real_dev->vlan_features which was set
in mlx5 part of this patch.

  643 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
  644         netdev_features_t features)
  645 {
  ...
  649
  650         lower_features = netdev_intersect_features((real_dev->vlan_features |
  651                                                     NETIF_F_RXCSUM),
  652                                                    real_dev->features);

This part ensure that once real_dev->vlan_features and real_dev->features have NETIF_F_HW_MACSEC,
the returned features will include NETIF_F_HW_MACSEC too.

> 
> [...]
> > @@ -572,6 +573,9 @@ static int vlan_dev_init(struct net_device *dev)
> >  			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
> >  			   NETIF_F_ALL_FCOE;
> >  
> > +	if (real_dev->features & NETIF_F_HW_MACSEC)
> > +		dev->hw_features |= NETIF_F_HW_MACSEC;
> > +
> >  	dev->features |= dev->hw_features | NETIF_F_LLTX;
> >  	netif_inherit_tso_max(dev, real_dev);
> >  	if (dev->features & NETIF_F_VLAN_FEATURES)
> > @@ -803,6 +807,100 @@ static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
> >  	return 0;
> >  }
> >  
> > +#if IS_ENABLED(CONFIG_MACSEC)
> > +
> > +static const struct macsec_ops *vlan_get_macsec_ops(struct macsec_context *ctx)
>                                                        ^ const?
> 
> > +{
> > +	return vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops;
> > +}
> > +
> > +#define _BUILD_VLAN_MACSEC_MDO(mdo) \
> > +	const struct macsec_ops *ops; \
> > +	ops =  vlan_get_macsec_ops(ctx); \
> > +	return ops ? ops->mdo_ ## mdo(ctx) : -EOPNOTSUPP
> > +
> > +static int vlan_macsec_add_txsa(struct macsec_context *ctx)
> > +{
> > +_BUILD_VLAN_MACSEC_MDO(add_txsa);
> 
> Shouldn't those be indented?
> 
> > +}
> > +
> 
> [...]
> > +
> > +#define VLAN_MACSEC_DECLARE_MDO(mdo) .mdo_ ## mdo = vlan_macsec_ ## mdo
> > +
> > +static const struct macsec_ops macsec_offload_ops = {
> > +	VLAN_MACSEC_DECLARE_MDO(add_txsa),
> 
> This completely breaks the ability to use cscope when looking for
> implementations of mdo_add_txsa. I'm not very fond of the c/p, but I
> don't think we should be using macros at all here. At least to me,
> being able to navigate directly from mdo_add_txsa to its
> implementation without expanding the macro manually is important.
> 
> So, IMHO, those should be:
> 
> 	.mdo_add_txsa = vlan_macsec_add_txsa,

Completely agree with you.

> 
> (etc)
> 
> -- 
> Sabrina
> 
