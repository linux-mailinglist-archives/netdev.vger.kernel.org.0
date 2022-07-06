Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF55567BA7
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiGFBsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiGFBsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:48:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21654A471
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 18:48:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEC416185C
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 01:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68E7C341C7;
        Wed,  6 Jul 2022 01:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657072087;
        bh=Tj6Zpxo5zlrJolN+uD+IS7pTthQr1Qj3FDA9XIY/Bgw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ffhciezYhrNfAaYGSqfIYHm/igBp10tSmwJJk9Dv11Du0LurFL+KLpVrtnAwNDyTt
         yWb645XMblym1zKux8dwcIQE+xqT02ILd7n8XGiSadYjl2wX4MzQqSbATcfSUHoM10
         U5OVYlQB+GFm4Z5gY9cWA70eGpRihOC3JxX/foqd6FVSFWK3WfyqmMUPYn1y47UYPo
         onJwodxbiv6VVDreb8dotIgndDdGkYtj5BE9fWn5kCKk8SXt8PAkKepq0mNDJh5ca6
         MzXaiDZQfkYm4WkiU539/lGVg1kJ+2WlzoPQoeL2OGJ3+w03HDJ1A+r2SKqOx+cfmP
         1pueH/4CELugQ==
Date:   Tue, 5 Jul 2022 18:48:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Liang He <windhl@126.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ftgmac100: Hold reference returned by
 of_get_child_by_name()
Message-ID: <20220705184805.2619caca@kernel.org>
In-Reply-To: <20220704151819.279513-1-windhl@126.com>
References: <20220704151819.279513-1-windhl@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  4 Jul 2022 23:18:19 +0800 Liang He wrote:
> In ftgmac100_probe(), we should hold the refernece returned by
> of_get_child_by_name() and use it to call of_node_put() for
> reference balance.
> 
> Signed-off-by: Liang He <windhl@126.com>
> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 5231818943c6..e50bd7beb09b 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -1770,7 +1770,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
>  	int irq;
>  	struct net_device *netdev;
>  	struct ftgmac100 *priv;
> -	struct device_node *np;
> +	struct device_node *np, *child_np;
>  	int err = 0;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -1883,7 +1883,7 @@ static int ftgmac100_probe(struct platform_device *pdev)
>  
>  		/* Display what we found */
>  		phy_attached_info(phy);
> -	} else if (np && !of_get_child_by_name(np, "mdio")) {
> +	} else if (np && !(child_np = of_get_child_by_name(np, "mdio"))) {
>  		/* Support legacy ASPEED devicetree descriptions that decribe a
>  		 * MAC with an embedded MDIO controller but have no "mdio"
>  		 * child node. Automatically scan the MDIO bus for available
> @@ -1901,6 +1901,8 @@ static int ftgmac100_probe(struct platform_device *pdev)
>  		}
>  
>  	}
> +	if (child_np)
> +		of_node_put(child_np);

Since we don't care about the value of the node we should add a helper
which checks for presence of the node and releases the reference,
rather than have to do that in this large function.

Please also add a Fixes tag.
