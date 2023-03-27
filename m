Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF9886CAAE3
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 18:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjC0QoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 12:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232624AbjC0Qns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 12:43:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80444203
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 09:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A8FEB81732
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 16:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB630C433D2;
        Mon, 27 Mar 2023 16:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679935417;
        bh=T11luKW4vsxC5CRgI1NJ2jFILQBzBJ0cs4PyH+sMJkg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lAau5Pb387hbVL+t3Lo5aW2l+l/NwFR7tEGpfov7MAZSrLwnakHXCxP8QCdvkWkjU
         kxLy16YROgIvHAUk5Lz4vcewsBVFfFh//Fwh2W0eztZlBjIg6KKJ12RbZwo/3GT5mL
         dOCNKePY3X+rEUutTfBoBCImk6SoppyhO+ty9qct4ZkQMY5ktW70boFKfxffqgaxe9
         1k76f1BnWA/y149pwIz4aV7NZbjaDop6r4g3usF/G4GE8Rml+8lWdHYBF3DpQk4HVq
         0KsAfmblcPxm1K5YiROJnjWVlmCZyckHP2Wx/4/f08hhGou0kT+OJnW3toQfYtaf0Q
         NSE2cV8U8SCJg==
Date:   Mon, 27 Mar 2023 09:43:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <sd@queasysnail.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <20230327094335.07f462f9@kernel.org>
In-Reply-To: <20230326072636.3507-2-ehakim@nvidia.com>
References: <20230326072636.3507-1-ehakim@nvidia.com>
        <20230326072636.3507-2-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Mar 2023 10:26:33 +0300 Emeel Hakim wrote:
> @@ -572,6 +573,9 @@ static int vlan_dev_init(struct net_device *dev)
>  			   NETIF_F_HIGHDMA | NETIF_F_SCTP_CRC |
>  			   NETIF_F_ALL_FCOE;
>  
> +	if (real_dev->features & NETIF_F_HW_MACSEC)
> +		dev->hw_features |= NETIF_F_HW_MACSEC;
> +
>  	dev->features |= dev->hw_features | NETIF_F_LLTX;
>  	netif_inherit_tso_max(dev, real_dev);
>  	if (dev->features & NETIF_F_VLAN_FEATURES)
> @@ -660,6 +664,9 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
>  	features |= old_features & (NETIF_F_SOFT_FEATURES | NETIF_F_GSO_SOFTWARE);
>  	features |= NETIF_F_LLTX;
>  
> +	if (real_dev->features & NETIF_F_HW_MACSEC)
> +		features |= NETIF_F_HW_MACSEC;
> +
>  	return features;
>  }

Shouldn't vlan_features be consulted somehow?

> @@ -803,6 +810,49 @@ static int vlan_dev_fill_forward_path(struct net_device_path_ctx *ctx,
>  	return 0;
>  }
>  
> +#if IS_ENABLED(CONFIG_MACSEC)
> +#define VLAN_MACSEC_MDO(mdo) \
> +static int vlan_macsec_ ## mdo(struct macsec_context *ctx) \
> +{ \
> +	const struct macsec_ops *ops; \
> +	ops =  vlan_dev_priv(ctx->netdev)->real_dev->macsec_ops; \
> +	return ops ? ops->mdo_ ## mdo(ctx) : -EOPNOTSUPP; \
> +}
> +
> +#define VLAN_MACSEC_DECLARE_MDO(mdo) vlan_macsec_ ## mdo
> +
> +VLAN_MACSEC_MDO(add_txsa);
> +VLAN_MACSEC_MDO(upd_txsa);
> +VLAN_MACSEC_MDO(del_txsa);
> +
> +VLAN_MACSEC_MDO(add_rxsa);
> +VLAN_MACSEC_MDO(upd_rxsa);
> +VLAN_MACSEC_MDO(del_rxsa);
> +
> +VLAN_MACSEC_MDO(add_rxsc);
> +VLAN_MACSEC_MDO(upd_rxsc);
> +VLAN_MACSEC_MDO(del_rxsc);
> +
> +VLAN_MACSEC_MDO(add_secy);
> +VLAN_MACSEC_MDO(upd_secy);
> +VLAN_MACSEC_MDO(del_secy);

-1

impossible to grep for the functions :( but maybe others don't care
