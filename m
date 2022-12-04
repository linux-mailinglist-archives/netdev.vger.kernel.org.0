Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA0C641D1A
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 13:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLDMrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 07:47:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLDMrV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 07:47:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9667215A01;
        Sun,  4 Dec 2022 04:47:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B52660E99;
        Sun,  4 Dec 2022 12:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C31BC433D6;
        Sun,  4 Dec 2022 12:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670158039;
        bh=vWrHmUQFza2of6fZwYZ4HQi+bQkmf+7YBhTSi5hkTCU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pt1TUiUO1h3+c9k197D8KcfytKulua8X/uiswBtBrAujKkHlF+YaEDuM6ibknnIKX
         TtllzNkzr778tl38um8zI9BLMcU6w7jUtiAd57xuOQ/g5HSvLL2bt8jUrGFKa+0mkT
         u/7V5F5aPxURUO0GT4xdPun3lZUgSjb1ufuQcUDNY5ViZGUxkiKfSDtK6bb7UtCmZF
         rpfTJeeqt66NtOH8JqWYab5KK5xjWrrjAI/oNYJH3mz9umVy8BtU5wgTED/TM5qGth
         TZ6qo54E+10k4MmMX7Vt8LdpYSVxk5nmXYpXSDf1aFt5kIiVXgLp1BCACmjtepa8qB
         Vjdpw28f6+HGg==
Date:   Sun, 4 Dec 2022 14:47:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: mvneta: Prevent out of bounds read in
 mvneta_config_rss()
Message-ID: <Y4yW0fhKuoG3i7w3@unreal>
References: <Y4nMQuEtuVO+rlQy@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4nMQuEtuVO+rlQy@kili>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 12:58:26PM +0300, Dan Carpenter wrote:
> The pp->indir[0] value comes from the user.  It is passed to:
> 
> 	if (cpu_online(pp->rxq_def))
> 
> inside the mvneta_percpu_elect() function.  It needs bounds checkeding
> to ensure that it is not beyond the end of the cpu bitmap.
> 
> Fixes: cad5d847a093 ("net: mvneta: Fix the CPU choice in mvneta_percpu_elect")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 3 +++
>  1 file changed, 3 insertions(+)

I would expect that ethtool_copy_validate_indir() will prevent this.

Thanks

> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index c2cb98d24f5c..5abc7c3e399e 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -4927,6 +4927,9 @@ static int  mvneta_config_rss(struct mvneta_port *pp)
>  		napi_disable(&pp->napi);
>  	}
>  
> +	if (pp->indir[0] >= nr_cpu_ids)
> +		return -EINVAL;
> +
>  	pp->rxq_def = pp->indir[0];
>  
>  	/* Update unicast mapping */
> -- 
> 2.35.1
> 
