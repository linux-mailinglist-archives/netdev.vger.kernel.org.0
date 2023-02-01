Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8B76862D7
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:30:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjBAJar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbjBAJap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:30:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436C25CD30
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 01:30:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80D7461718
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23896C433D2;
        Wed,  1 Feb 2023 09:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675243841;
        bh=9RdFDZZQlJjQwCSrtpYdSmezwzkMIsEYrKYyugjjZZs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nfflRbJOI4z96jYtTpifPZu6U12JKwRMQwfHn+OrMvgEqChBUklVPTeoRcg13yi73
         DhSr6MmaX8ImQ6dYUE9HCiFDVzZXuvbt989Iqm6b/xwjupXuXEXN+tVIbEfzrekfS0
         /4KMIAJFQFQeMg0AAbCwPhafCo6XT01zSGl2aNxLNyflQwaC0fhfEzA3OURhvRKOL3
         MjiQul+f9Z1hXgZd2rnnlta1uVx1T4GRQNhY1LTqj0UxIFPgfm3/qb9AzyODazxUXx
         NCM8oUThNiKmYtMX3d4yANT7S5750fV9LA9VFk/wVCdgNO0CzxyTw8RnPQB+bny8fQ
         cTJXNKbCrPs4Q==
Date:   Wed, 1 Feb 2023 11:30:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Huayu Chen <huayu.chen@corigine.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@corigine.com>
Subject: Re: [PATCH net-next] nfp: correct cleanup related to DCB resources
Message-ID: <Y9oxOvJuENfnJ2zS@unreal>
References: <20230131163033.981937-1-simon.horman@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230131163033.981937-1-simon.horman@corigine.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 05:30:33PM +0100, Simon Horman wrote:
> From: Huayu Chen <huayu.chen@corigine.com>
> 
> This patch corrects two oversights relating to releasing resources
> and DCB initialisation.
> 
> 1. If mapping of the dcbcfg_tbl area fails: an error should be
>    propagated, allowing partial initialisation (probe) to be unwound.
> 
> 2. Conversely, if where dcbcfg_tbl is successfully mapped: it should
>    be unmapped in nfp_nic_dcb_clean() which is called via various error
>    cleanup paths, and shutdown or removal of the PCIE device.
> 
> Fixes: 9b7fe8046d74 ("nfp: add DCB IEEE support")
> Signed-off-by: Huayu Chen <huayu.chen@corigine.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nic/main.c | 8 ++++++--
>  drivers/net/ethernet/netronome/nfp/nic/main.h | 2 +-
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.c b/drivers/net/ethernet/netronome/nfp/nic/main.c
> index f78c2447d45b..9dd5afe37f6e 100644
> --- a/drivers/net/ethernet/netronome/nfp/nic/main.c
> +++ b/drivers/net/ethernet/netronome/nfp/nic/main.c
> @@ -32,9 +32,12 @@ static void nfp_nic_sriov_disable(struct nfp_app *app)
>  
>  static int nfp_nic_vnic_init(struct nfp_app *app, struct nfp_net *nn)
>  {
> -	nfp_nic_dcb_init(nn);
> +	return nfp_nic_dcb_init(nn);
> +}
>  
> -	return 0;
> +static void nfp_nic_vnic_clean(struct nfp_app *app, struct nfp_net *nn)
> +{
> +	nfp_nic_dcb_clean(nn);
>  }
>  
>  static int nfp_nic_vnic_alloc(struct nfp_app *app, struct nfp_net *nn,
> @@ -72,4 +75,5 @@ const struct nfp_app_type app_nic = {
>  	.sriov_disable	= nfp_nic_sriov_disable,
>  
>  	.vnic_init      = nfp_nic_vnic_init,
> +	.vnic_clean     = nfp_nic_vnic_clean,
>  };
> diff --git a/drivers/net/ethernet/netronome/nfp/nic/main.h b/drivers/net/ethernet/netronome/nfp/nic/main.h
> index 7ba04451b8ba..094374df42b8 100644
> --- a/drivers/net/ethernet/netronome/nfp/nic/main.h
> +++ b/drivers/net/ethernet/netronome/nfp/nic/main.h
> @@ -33,7 +33,7 @@ struct nfp_dcb {
>  int nfp_nic_dcb_init(struct nfp_net *nn);
>  void nfp_nic_dcb_clean(struct nfp_net *nn);
>  #else
> -static inline int nfp_nic_dcb_init(struct nfp_net *nn) {return 0; }
> +static inline int nfp_nic_dcb_init(struct nfp_net *nn) { return 0; }

Not related change, but I would do the same.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
