Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A025D6E0D38
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:08:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjDMMIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDMMIB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:08:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA59269E
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 05:08:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ABC160F90
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 12:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E626BC433D2;
        Thu, 13 Apr 2023 12:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681387679;
        bh=j3jZLD5+MtNHCjK1uj/pe7PKku2xb919GZ+R6M6MkjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=f0oasAVv91n09hx3S64cqMfnLeuI7zZ4nFRkHghI2os3EgFYGopyYOLCdVt45g7Py
         MXSBhB7CeSmCkF5UcXt0aMBWA7wcJAR9oEYQAwVa8Rdztity0PE8wt0eVD4qxWN5TQ
         EBY/AoH+8TDNc2Rm8xkPBbeTwvkajfExoRQmEEKUvjcvQzvpixubJRjy0SQgrixduH
         PMl1KNIRl9Sj7L2wfHbWUrTQyhGfxKBr75K7wc6S+ltp9mGmlLSmsbMyU7pSPYHzO8
         cDg03pRhfa1Cbc55bKlg+CKXdFSKLn7kgstxmmnYhRxMgs44JfMZVaxI/6JEVxEnfQ
         I2NAglQ/EcfYw==
Date:   Thu, 13 Apr 2023 15:07:55 +0300
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
Subject: Re: [PATCH net-next 04/10] net/mlx5e: Prepare IPsec packet reformat
 code for tunnel mode
Message-ID: <20230413120755.GM17993@unreal>
References: <cover.1681106636.git.leonro@nvidia.com>
 <2f80bcfa0f7afdfa65848de9ddcba2c4c09cfe32.1681106636.git.leonro@nvidia.com>
 <ZDWEACmSLgk83pIw@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDWEACmSLgk83pIw@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 06:00:00PM +0200, Simon Horman wrote:
> On Mon, Apr 10, 2023 at 09:19:06AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Refactor setup_pkt_reformat() function to accommodate future extension
> > to support tunnel mode.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> ...
> 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > index 060be020ca64..980583fb1e52 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
> > @@ -836,40 +836,78 @@ static int setup_modify_header(struct mlx5_core_dev *mdev, u32 val, u8 dir,
> >  	return 0;
> >  }
> >  
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
> Maybe this is nicer? Maybe not.
> 
> 		reformat_params->type = attrs->family == AF_INET ?
> 			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4 :
> 			MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6;
> 
> > +
> > +		reformatbf = kzalloc(16, GFP_KERNEL);
> 
> I know you are just moving code around.
> But 16 is doing a lot of work in this function.
> Could it be a #define ?

Done

> 
> > +		if (!reformatbf)
> > +			return -ENOMEM;
> > +
> > +		/* convert to network format */
> > +		spi = htonl(attrs->spi);
> > +		memcpy(reformatbf, &spi, 4);
> 
> This seems to be a lot of work to copy a word.
> But anyway, maybe:
> 
> 		memcpy(reformatbf, &spi, sizeof(spi));

Done

> 
> > +
> > +		reformat_params->param_0 = attrs->authsize;
> > +		reformat_params->size = 16;
> > +		reformat_params->data = reformatbf;
> > +		break;
> > +	default:
> > +		return -EINVAL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> 
> ...
