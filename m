Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCF667FEF5
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 13:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjA2Ml0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 07:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjA2MlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 07:41:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650281ADD9;
        Sun, 29 Jan 2023 04:41:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05A4360D32;
        Sun, 29 Jan 2023 12:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1AFC433EF;
        Sun, 29 Jan 2023 12:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674996083;
        bh=dZD+rzOSjX42kmHVyg3LzYODAILdeEhb0jDAg6t0HgM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DbYOMZ0jEvOYocRi/x5k21whomnHqgCSD4ZSK9ztewy8okvbpTnV6HIj/9MHXwI7x
         a0QL4swqSmACFyq4XyH5zZ0jHraKHP9G/JvnOaZEtouw8Kv0ExiLobXHHKuYij6u6U
         LtRi14JoS2Py2avT0Yy+BXPCp38sJkynGdN7pisW9i1eIGxDblaD95cWcp7yI8OlOw
         BYWCRXbEy7wOs8YvRFPvEaqy7YyPVDuzy6icUiFi3vYzbpHAUTD+V9nJ+WKerRVVRa
         JsMhKQgW2Qge0bociQiOb2KYlj5YZaKVv5BJCldy1N6cDgqHM4n7WRYsiOUm3GKn48
         7/xOEFbrLAXwA==
Date:   Sun, 29 Jan 2023 14:41:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sgoutham@marvell.com
Subject: Re: [net PATCH] octeontx2-af: Fix devlink unregister
Message-ID: <Y9ZpbqKmt7uNZVmF@unreal>
References: <20230127094652.666693-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127094652.666693-1-rkannoth@marvell.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 03:16:51PM +0530, Ratheesh Kannoth wrote:
> Exact match devlink entry is only for CN10K-B.
> Unregistration devlink should subtract this
> entry before invoking devlink unregistration
> 
> Fixes: 87e4ea29b030 ("octeontx2-af: Debugsfs support for exact match.")
> Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
> ---
>  .../net/ethernet/marvell/octeontx2/af/rvu_devlink.c    | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
> index bda1a6fa2ec4..d058eeadb23f 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
> @@ -1603,10 +1603,16 @@ void rvu_unregister_dl(struct rvu *rvu)
>  {
>  	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
>  	struct devlink *dl = rvu_dl->dl;
> +	size_t size;
>  
>  	devlink_unregister(dl);
> -	devlink_params_unregister(dl, rvu_af_dl_params,
> -				  ARRAY_SIZE(rvu_af_dl_params));
> +	/* Unregister exact match devlink only for CN10K-B */
> +	size = ARRAY_SIZE(rvu_af_dl_params);
> +	if (!rvu_npc_exact_has_match_table(rvu))
> +		size -= 1;
> +
> +	devlink_params_unregister(dl, rvu_af_dl_params, size);

The code is ok, but it will be much better if you separate
rvu_af_dl_params to two structs and call to devlink_params_register()
twice with relevant parameters.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
