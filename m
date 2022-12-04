Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF463641CBF
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 12:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiLDLq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 06:46:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiLDLq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 06:46:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2ED16590;
        Sun,  4 Dec 2022 03:46:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4067FB80884;
        Sun,  4 Dec 2022 11:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F10C433C1;
        Sun,  4 Dec 2022 11:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670154383;
        bh=rBxLCr2I1DJGDcTRYutZqMc0b53O4bxzzlIsLXyEE1A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BEHK3QjZatQ0qykFhaaT2M94VVL77GScaN7RABqienEwoodCp7e038VPzoE2JGKmK
         1Iu/b9fMqkCwcJZyfcE/6NL2YIiWtJ97vVILKOyD8BWbxDyq+RTvFLdrd5XXtSQOgh
         JeD/BYkEaszAPmpmsbezM1rRtgUo0DXF3bEYxY5iUYB4VEYXf+noIzHtjm50HndgsQ
         oZIjQcSWo1qR/y39CvxiiH84LWVl5VDMyq65OpGjwUYKYSQapgQcyha3Dj2UhrVOBn
         g3+N34G73yB75VgD1QJ2G0m2gQ3XN04MDRJgrk5XNGpImdWWkU5nkqy/byD1LgwwtB
         sPJTPLR7SvSSw==
Date:   Sun, 4 Dec 2022 13:46:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lucas Stach <l.stach@pengutronix.de>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        patchwork-lst@pengutronix.de
Subject: Re: [PATCH 1/2] net: asix: Simplify return value check after
 asix_check_host_enable
Message-ID: <Y4yIfi4GZQZ0D0h7@unreal>
References: <20221201175525.2733125-1-l.stach@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201175525.2733125-1-l.stach@pengutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 06:55:24PM +0100, Lucas Stach wrote:
> Any negative return value from this function is indicative of an
> error. Simplify the condition to cover all possible error codes.

Some calls to asix_read_cmd() in asix_check_host_enable() return -ENODATA
and such are simply skipped (... continue ...). It is unclear if it
indicates an error or not.

Thanks

> 
> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
> ---
>  drivers/net/usb/asix_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index 72ffc89b477a..be1e103b7a95 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -504,7 +504,7 @@ static int __asix_mdio_read(struct net_device *netdev, int phy_id, int loc,
>  	mutex_lock(&dev->phy_mutex);
>  
>  	ret = asix_check_host_enable(dev, in_pm);
> -	if (ret == -ENODEV || ret == -ETIMEDOUT) {
> +	if (ret < 0) {
>  		mutex_unlock(&dev->phy_mutex);
>  		return ret;
>  	}
> @@ -542,7 +542,7 @@ static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
>  	mutex_lock(&dev->phy_mutex);
>  
>  	ret = asix_check_host_enable(dev, in_pm);
> -	if (ret == -ENODEV)
> +	if (ret < 0)
>  		goto out;
>  
>  	ret = asix_write_cmd(dev, AX_CMD_WRITE_MII_REG, phy_id, (__u16)loc, 2,
> -- 
> 2.30.2
> 
