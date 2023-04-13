Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 436836E0CE9
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 13:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDMLqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 07:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjDMLqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 07:46:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C9E2D44
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 04:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9122D614E5
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 11:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732D3C433D2;
        Thu, 13 Apr 2023 11:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681386401;
        bh=UP4ktkTQke4ZgM63u2E6YC2/9E6MHVBd/IF2QRFRFYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rysCAt4+FCjJHuYw20uKSsyZVy/Ryc6U3QJP9fB+zjtEQvbTkXLCex2/XLVuSbCVg
         ZQreu1/s/Vu2U1Io5qUUs2CkNy1YFJxx6oUMzko8dqWcoP1V6JQ7sVWMWZk6eBnhPl
         p9RaORajt1QXAvt8OVpdIN2sCypfbJxixkUweNtwvazJ6/zzEo3mEozCWrAe3YGxT4
         21itjOmQU5QVQvmP3WM+uD0XKhtDpKU7qm8Yww2Vgs1NOy6DN92QVeUT1Dp+bn+dOu
         +K40+j5XFaduwfXjZN83VT4Gyg8LKF3/neD3GoYcOK2DmdlHs04V+3y+A09s7wQPm1
         ide/8HsKQoNbg==
Date:   Thu, 13 Apr 2023 14:46:36 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next 05/10] net/mlx5e: Support IPsec RX packet
 offload in tunnel mode
Message-ID: <20230413114636.GL17993@unreal>
References: <cover.1681106636.git.leonro@nvidia.com>
 <255b601d3652bb8c770571ed3e683f695614923f.1681106636.git.leonro@nvidia.com>
 <ZDWMr/CTs5kqzcNV@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDWMr/CTs5kqzcNV@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 06:37:03PM +0200, Simon Horman wrote:
> On Mon, Apr 10, 2023 at 09:19:07AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Extend mlx5 driver with logic to support IPsec RX packet offload
> > in tunnel mode.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > index 980583fb1e52..8ecaf4100b9c 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > @@ -836,6 +836,60 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
> >  	return 0;
> >  }
> >  
> > +static int
> > +setup_pkt_tunnel_reformat(struct mlx5_core_dev *mdev,
> > +			  struct mlx5_accel_esp_xfrm_attrs *attrs,
> > +			  struct mlx5_pkt_reformat_params *reformat_params)
> > +{
> > +	union {
> > +		struct {
> > +			u8 dmac[6];
> > +			u8 smac[6];
> > +			__be16 ethertype;
> > +		} __packed;
> > +		u8 raw[ETH_HLEN];
> > +	} __packed *mac_hdr;
> 
> Can struct ethhrd be used here?
> I think it has the same layout as the fields of the inner structure above.

Yes, it can, will change.

> And I don't think the union is giving us much: the raw field seems unused.

Thanks, it isn't needed here.

> 
> > +	char *reformatbf;
> > +	size_t bfflen;
> > +
> > +	bfflen = sizeof(*mac_hdr);
> > +
> > +	reformatbf = kzalloc(bfflen, GFP_KERNEL);
> 
> I'm not sure that reformatbf is providing much value.

It is more useful in next patch, where reformatbf will hold ESP, ipv4/6 and ETH
headers.

> Perhaps:
> 
> 	mac_hdr = kzalloc(bfflen, GFP_KERNEL);
> 
> > +	if (!reformatbf)
> > +		return -ENOMEM;
> > +
> > +	mac_hdr = (void *)reformatbf;
> 
> If you must cast, perhaps to the type of mac_hdr, which is not void *.

I'll change.

> 
> > +	switch (attrs->family) {
> > +	case AF_INET:
> > +		mac_hdr->ethertype = htons(ETH_P_IP);
> > +		break;
> > +	case AF_INET6:
> > +		mac_hdr->ethertype = htons(ETH_P_IPV6);
> > +		break;
> > +	default:
> > +		goto free_reformatbf;
> > +	}
> > +
> > +	ether_addr_copy(mac_hdr->dmac, attrs->dmac);
> > +	ether_addr_copy(mac_hdr->smac, attrs->smac);
> > +
> > +	switch (attrs->dir) {
> > +	case XFRM_DEV_OFFLOAD_IN:
> > +		reformat_params->type = MLX5_REFORMAT_TYPE_L3_ESP_TUNNEL_TO_L2;
> > +		break;
> > +	default:
> > +		goto free_reformatbf;
> > +	}
> > +
> > +	reformat_params->size = bfflen;
> > +	reformat_params->data = reformatbf;
> > +	return 0;
> > +
> > +free_reformatbf:
> > +	kfree(reformatbf);
> > +	return -EINVAL;
> > +}
> 
> ...
