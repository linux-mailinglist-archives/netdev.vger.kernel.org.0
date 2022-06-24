Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E0555A4F9
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 01:42:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbiFXXmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 19:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231565AbiFXXmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 19:42:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0DE8AC2F;
        Fri, 24 Jun 2022 16:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B6B6247A;
        Fri, 24 Jun 2022 23:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9120BC34114;
        Fri, 24 Jun 2022 23:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656114163;
        bh=mMsl6VDk27tUqj2hs7gILfd5usTjSE5nYWVBee1g1Z0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jj+rfupmd0kO6Z5Zt9eBnqXVsPvcTysVqbhXaB2dtJmYXCk9rC6fMV6q6Nez6+07G
         EuCt/d461eNx1MqhobwFE1TE82k+1+ne7DTI14Rh/B9APA7uIAUcZuYzPnlK3VsMDH
         KBOkIuH8BVgUbgMW3iYbJbZSo6xxEkmJOtswiwTtwxmOhv36Tal9keh/72JMEpsUG5
         1G46IqacjynvUXXDqM0UlG0PgkBGLM0BDar5C1WnK7aGKIbpjZgMFX8eQIsX6BcejD
         d2QzGgJxE1g88vDzu/lw0rD213mBMdHfABIBzIxad37io5nv5ndlBY6HFQK1DLrNYP
         XmfED6sDsin8A==
Date:   Fri, 24 Jun 2022 16:42:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     <davem@davemloft.net>, <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <vigneshr@ti.com>, <grygorii.strashko@ti.com>
Subject: Re: [PATCH] net: ethernet: ti: am65-cpsw: Fix devlink port register
 sequence
Message-ID: <20220624164234.6268f2b7@kernel.org>
In-Reply-To: <20220623044337.6179-1-s-vadapalli@ti.com>
References: <20220623044337.6179-1-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Jun 2022 10:13:37 +0530 Siddharth Vadapalli wrote:
> Renaming interfaces using udevd depends on the interface being registered
> before its netdev is registered. Otherwise, udevd reads an empty
> phys_port_name value, resulting in the interface not being renamed.
> 
> Fix this by registering the interface before registering its netdev
> by invoking am65_cpsw_nuss_register_devlink() before invoking
> register_netdev() for the interface.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Please add a Fixes tag and [PATCH net] in the subject.

> diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> index fb92d4c1547d..47a6c4e5360b 100644
> --- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> +++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
> @@ -2527,6 +2527,10 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
>  		return ret;
>  	}
>  
> +	ret = am65_cpsw_nuss_register_devlink(common);
> +	if (ret)
> +		goto err_cleanup_ndev;

You need to take the devlink_port_type_eth_set() out of this function
if it's now called before netdev registration and call it after netdev
registration. Otherwise devlink will generate a netlink notification
about the port state change with a half-initialized netdev.

>  	for (i = 0; i < common->port_num; i++) {
>  		port = &common->ports[i];
>  
> @@ -2545,17 +2549,12 @@ static int am65_cpsw_nuss_register_ndevs(struct am65_cpsw_common *common)
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
>  

