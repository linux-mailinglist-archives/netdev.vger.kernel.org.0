Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE064CC235
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 17:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234878AbiCCQFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 11:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiCCQFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 11:05:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150E8197B47;
        Thu,  3 Mar 2022 08:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1D4F60C26;
        Thu,  3 Mar 2022 16:04:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2ACC340F0;
        Thu,  3 Mar 2022 16:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646323488;
        bh=xd/ksvyLQUW2y1zrJT9Hnz3UCVLnr9jF+4S7+2ediM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dUbzGqsHmw8LdiIS/pqHeFDLxIZ3w4fF0dNkjrebnIyE3t9g1p8j6KVDaNbnxLBAT
         xHkv8uTQlR+mtx2fLvJiokUpaXHBUJXcIMxxIbzT1Tvf+goMBhgVhBYw3LTb6WP0Fn
         8WjtqPFkMFnS3BiNfuAS5DlLxkc+4xKzoqdhb2VmlK+ysxLlxNM/5sdWsAZOo1BopT
         DSIeN5JOe9T7UVtwdg3IpRs6G9wd5vw+jtSliYKkiRXq4N4i6xBJWlpCu02/GnxCod
         4Iwc5VoLz7VURBChhGvHVjjDUgU/dEQbLUra42f1bOVJpes8fCdUJE6dEi4Ho0B4mn
         rUWR7vCmg1/Xg==
Date:   Thu, 3 Mar 2022 08:04:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     davem@davemloft.net, caihuoqing@baidu.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: arc_emac: Fix use after free in arc_mdio_probe()
Message-ID: <20220303080446.0acabae9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220303013022.459154-1-niejianglei2021@163.com>
References: <20220303013022.459154-1-niejianglei2021@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Mar 2022 09:30:22 +0800 Jianglei Nie wrote:
> If bus->state is equal to MDIOBUS_ALLOCATED, mdiobus_free(bus) will free
> the "bus". But bus->name is still used in the next line, which will lead
> to a use after free.
> 
> We can fix it by assigning dev_err_probe() to dev_err before the bus is
> freed to avoid the uaf.
> 
> Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
> ---
>  drivers/net/ethernet/arc/emac_mdio.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/arc/emac_mdio.c b/drivers/net/ethernet/arc/emac_mdio.c
> index 9acf589b1178..795a25c5848a 100644
> --- a/drivers/net/ethernet/arc/emac_mdio.c
> +++ b/drivers/net/ethernet/arc/emac_mdio.c
> @@ -165,9 +165,10 @@ int arc_mdio_probe(struct arc_emac_priv *priv)
>  
>  	error = of_mdiobus_register(bus, priv->dev->of_node);
>  	if (error) {
> -		mdiobus_free(bus);
> -		return dev_err_probe(priv->dev, error,
> +		int dev_err = dev_err_probe(priv->dev, error,
>  				     "cannot register MDIO bus %s\n", bus->name);

Bus name is a constant please put it in a local variable:

	const char *name = "Synopsys MII Bus";

	...
	bus->name = name;

and then you can use name in the error message without referring to bus.

> +		mdiobus_free(bus);
> +		return dev_err;
>  	}
>  
>  	return 0;

