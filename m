Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B32BE6CF27A
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 20:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjC2SuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 14:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjC2SuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 14:50:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C34525A
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 11:50:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B8D461CEC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 18:50:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3367C433EF;
        Wed, 29 Mar 2023 18:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680115803;
        bh=r4coLDRXUGvOFDLAwPOP4vYNGYnqoQseZdjJBHr1uNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K8FmvHsBzMO+82V+xTE0+pjujO4wU6L11OYPEnE7gtIIonO+lLOLMNotmNvBRoZSp
         F3ZrYyFx/WjmV0i/pfSKoq+UPox8/Bs9TZAXqdL4obEgSbYst7wtawsAiXlfdt2bz2
         mky7lyixVpH8dwnCko3pURRxTyf57usemsoGSoZclqERw/vKFd+xp7ZrTmhjWArjpr
         VTl/RLhDp9DTWFvzj8vQO2EECLMfRTMc6hXs+1ujMo+aI5/UaCFTFHAsiR45+oxrJ7
         eWwET5iT/F8nn6KQvcP9sDVdvjNsdqe6wGbBT6XCOPSVWyjlKn/UOKv4bO+cAbh9Cm
         dfkN4x3tgTFzQ==
Date:   Wed, 29 Mar 2023 21:49:59 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Yinjun Zhang <yinjun.zhang@corigine.com>
Subject: Re: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Message-ID: <20230329184959.GC831478@unreal>
References: <20230329144548.66708-1-louis.peens@corigine.com>
 <20230329144548.66708-2-louis.peens@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230329144548.66708-2-louis.peens@corigine.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 04:45:47PM +0200, Louis Peens wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> `dev_port` is used to differentiate devices that share the same
> function, which is the case in most of NFP NICs.

And how did it work without dev_port?
I have no idea what does it mean "different devices that share the same
function".

Thanks

> 
> In some customized scenario, `dev_port` is used to rename netdev
> instead of `phys_port_name`, which requires to initialize it
> correctly to get expected netdev name.
> 
> Example rules using `dev_port`:
> 
>   SUBSYSTEM=="net", ACTION=="add", KERNELS=="0000:e1:00.0", ATTR{dev_port}=="0", NAME:="ens8np0"
>   SUBSYSTEM=="net", ACTION=="add", KERNELS=="0000:e1:00.0", ATTR{dev_port}=="1", NAME:="ens8np1"
> 
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Acked-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> ---
>  drivers/net/ethernet/netronome/nfp/nfp_port.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
> index 4f2308570dcf..54640bcb70fb 100644
> --- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
> +++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
> @@ -189,6 +189,7 @@ int nfp_port_init_phy_port(struct nfp_pf *pf, struct nfp_app *app,
>  
>  	port->eth_port = &pf->eth_tbl->ports[id];
>  	port->eth_id = pf->eth_tbl->ports[id].index;
> +	port->netdev->dev_port = id;
>  	if (pf->mac_stats_mem)
>  		port->eth_stats =
>  			pf->mac_stats_mem + port->eth_id * NFP_MAC_STATS_SIZE;
> -- 
> 2.34.1
> 
