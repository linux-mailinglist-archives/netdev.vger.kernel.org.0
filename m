Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B67A6807EA
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235502AbjA3Iyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234978AbjA3Iyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:54:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09ABC199E2
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:54:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9C07560EF3
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 08:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B5EBC433D2;
        Mon, 30 Jan 2023 08:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675068883;
        bh=4Jg/7IZq3mnGnnSgi0TMzAgZd0vG40d/nebJozH1DDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U7s2fWuu2LWjgf/BFV3VsnKGTo4yu+bLQNEIWkWR381zPECwpbZLpkg0aPEW+FDPw
         FE/tRAenb5eJpD857irD7vHPWmL4cw3ptmHbR7spkznRiZwmcWe6c2LGX1irSC2jwJ
         MHnXctC57bXQy39/1XGpmZljy8fjPPmmCJE6hQm4BE3Ox8OYO2QSmQJQTzGLrFjsQG
         2IUhtqWTlQUz804KTn+KlZwEGc2H0awTxYBKMjpi7dVotW5IabHPNAkpDa9Xm1mem9
         elHZ1lGhQx4WIgSIuHn92ALjcsnXJVyZTbABA80UeobNAg8hl9OMwlKsqjNSDLPwyn
         NDfs7dVu5Xdcw==
Date:   Mon, 30 Jan 2023 10:54:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH net-next] gve: Introduce a way to disable queue formats
Message-ID: <Y9eFznRPUJ2QnJXc@unreal>
References: <20230127190744.3721063-1-jeroendb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127190744.3721063-1-jeroendb@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:07:44AM -0800, Jeroen de Borst wrote:
> The device is capable of simultaneously supporting multiple
> queue formats. With this change the driver can deliberately
> pick a queue format.
> 
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve.h         | 30 +++++++++-
>  drivers/net/ethernet/google/gve/gve_adminq.c  | 35 +++++++-----
>  drivers/net/ethernet/google/gve/gve_ethtool.c | 57 ++++++++++++-------
>  drivers/net/ethernet/google/gve/gve_main.c    | 26 ++++++++-
>  4 files changed, 110 insertions(+), 38 deletions(-)

<...>

>  	/* Interrupt coalescing settings */
>  	u32 tx_coalesce_usecs;
> @@ -609,7 +613,7 @@ enum gve_service_task_flags_bit {
>  	GVE_PRIV_FLAGS_DO_RESET			= 1,
>  	GVE_PRIV_FLAGS_RESET_IN_PROGRESS	= 2,
>  	GVE_PRIV_FLAGS_PROBE_IN_PROGRESS	= 3,
> -	GVE_PRIV_FLAGS_DO_REPORT_STATS = 4,
> +	GVE_PRIV_FLAGS_DO_REPORT_STATS		= 4,

Not relevant change.

>  };

<...>

>  static u32 gve_get_priv_flags(struct net_device *netdev)
>  {
>  	struct gve_priv *priv = netdev_priv(netdev);
> -	u32 ret_flags = 0;
> -
> -	/* Only 1 flag exists currently: report-stats (BIT(O)), so set that flag. */
> -	if (priv->ethtool_flags & BIT(0))
> -		ret_flags |= BIT(0);
> -	return ret_flags;
> +	return priv->ethtool_flags & GVE_PRIV_FLAGS_MASK;

It it possible to get ethtool_flags which has enabled bits other than
GVE_PRIV_FLAGS_MASK?

I would expect that gve_set_priv_flags() won't allow setting of such bits.

>  }
>  
>  static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
>  {
>  	struct gve_priv *priv = netdev_priv(netdev);
> -	u64 ori_flags, new_flags;
> +	u32 ori_flags;
> +	enum gve_queue_format new_format;

Reversed Xmas tree, please.

> +
> +	/* Make sure there is a queue format to use */
> +	if ((priv->ethtool_formats & flags) == 0) {
> +		dev_err(&priv->pdev->dev,
> +			"All available queue formats disabled\n");
> +		return -EINVAL;
> +	}

Thanks
