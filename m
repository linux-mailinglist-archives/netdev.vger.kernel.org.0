Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0344E567B95
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiGFBjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiGFBjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:39:07 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28513167DE;
        Tue,  5 Jul 2022 18:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8C430CE1DB7;
        Wed,  6 Jul 2022 01:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67522C341C7;
        Wed,  6 Jul 2022 01:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657071542;
        bh=OpEg2gefaTAXZe+He2PzfPBEUwHabrTqWe6gD+yQEXg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AM0tvoDgxo5loGKNMcWQDMXttVUz748Ed+n3XRXJDFqYIPdzT2HIfS4x0Zsa12XqP
         HUv+Cm/tk1y7Lq3W7m2npYTrpUWVM/zleaURSl+q3OPHe6cc+drDlMRhzk3RbnsxT0
         NV7RQp0/OPuGrqdfY2RH5EnEfMMDxXLvNJGj5K+WNOYvfB0JTE5DQuZCYmTDc0DVbo
         eImVd6eE19r3IJFskUd/FQl0uoE7Ce51r9W6Wh6WS6MfxAIQCyKEgXkOSbwkZjpqlz
         u29MsPEXzREC79iSjz93+DNnnojKaaxIaMqx1VsSrnvfNTohlMx6dbCuSY8Pj76paS
         zGYdmTokDFKRg==
Date:   Tue, 5 Jul 2022 18:39:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     <davem@davemloft.net>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <vigneshr@ti.com>, <grygorii.strashko@ti.com>
Subject: Re: [PATCH net v2] net: ethernet: ti: am65-cpsw: Fix devlink port
 register sequence
Message-ID: <20220705183901.2a536d50@kernel.org>
In-Reply-To: <20220704073040.7542-1-s-vadapalli@ti.com>
References: <20220704073040.7542-1-s-vadapalli@ti.com>
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

On Mon, 4 Jul 2022 13:00:40 +0530 Siddharth Vadapalli wrote:
> @@ -2527,6 +2527,10 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
>  		return ret;
>  	}
>  
> +	ret = am65_cpsw_nuss_register_devlink(common);
> +	if (ret)
> +		goto err_cleanup_ndev;
> +
>  	for (i = 0; i < common->port_num; i++) {
>  		port = &common->ports[i];
>  
> @@ -2539,23 +2543,21 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
>  				i, ret);
>  			goto err_cleanup_ndev;
>  		}
> +
> +		dl_port = &port->devlink_port;
> +		devlink_port_type_eth_set(dl_port, port->ndev);
>  	}
>  
>  	ret = am65_cpsw_register_notifiers(common);
>  	if (ret)
>  		goto err_cleanup_ndev;
>  
> -	ret = am65_cpsw_nuss_register_devlink(common);
> -	if (ret)
> -		goto clean_unregister_notifiers;
> -
>  	/* can't auto unregister ndev using devm_add_action() due to
>  	 * devres release sequence in DD core for DMA
>  	 */
>  
>  	return 0;
> -clean_unregister_notifiers:
> -	am65_cpsw_unregister_notifiers(common);
> +
>  err_cleanup_ndev:
>  	am65_cpsw_nuss_cleanup_ndev(common);

No additions to the error handling path? Slightly suspicious.
Do the devlink ports not have to be removed if netdev registration
fails?
