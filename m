Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03AF4C067B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 01:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236490AbiBWA4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 19:56:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiBWA42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 19:56:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3972C42EF8;
        Tue, 22 Feb 2022 16:56:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E04C1B81DA1;
        Wed, 23 Feb 2022 00:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E37C340E8;
        Wed, 23 Feb 2022 00:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645577759;
        bh=izPrhdaF7Kmy45OBsl7cJwcWFkXZS3c2dOp/YJ7KBiE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ds8NCXlpkef8GgEQb9xBWapsdplhKXWUHVx1tG1VqmIv3pfpU0Dfjg3Oiqcgsi4oY
         M2acR2fC5iIzjupo93CswjkBFB2zcA8VY6iRDwnl03UnYYIwHD8xrmvpuSUPGpZ09k
         EPVXOmaJhdL+C24tcjej72acC/8xRR2mUZzj/AeY5kHeInw66TOOvycK1ydveubbtZ
         E7sPaTOsr9Vr1FlZsRPy/DmdPVOHXfw8qxCWsCofAIsL0EuoIrQHVj4WaOh0wVxNeq
         IBXrXq0c0VfxaY1hKxXDi4cpuL14srsmGE9o/Zn1riNk5De6dhw4X7UtoveYrgcPgo
         O3sHZ+9gezisg==
Date:   Tue, 22 Feb 2022 16:55:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz9477: reduce
 polling interval for statistics
Message-ID: <20220222165558.0a43b2ee@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220221084129.3660124-1-o.rempel@pengutronix.de>
References: <20220221084129.3660124-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Feb 2022 09:41:29 +0100 Oleksij Rempel wrote:
> 30 seconds is too long interval especially if it used with ip -s l.
> Reduce polling interval to 5 sec.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
> index 27cae9f04322..0531aa671574 100644
> --- a/drivers/net/dsa/microchip/ksz_common.c
> +++ b/drivers/net/dsa/microchip/ksz_common.c
> @@ -453,7 +453,7 @@ int ksz_switch_register(struct ksz_device *dev,
>  	}
>  
>  	/* Read MIB counters every 30 seconds to avoid overflow. */
> -	dev->mib_read_interval = msecs_to_jiffies(30000);
> +	dev->mib_read_interval = msecs_to_jiffies(5000);
>  
>  	/* Start the MIB timer. */
>  	schedule_delayed_work(&dev->mib_read, 0);

Seems reasonable, although who knows how slow the buses get.
In case we need to make it configurable in the future there's already
uAPI for it - stats_block_coalesce_usecs
