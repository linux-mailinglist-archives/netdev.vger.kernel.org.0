Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2200648D15
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 05:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbiLJEOK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 23:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbiLJEN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 23:13:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 214042FC09;
        Fri,  9 Dec 2022 20:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A694BB8282B;
        Sat, 10 Dec 2022 04:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0796CC433D2;
        Sat, 10 Dec 2022 04:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670645634;
        bh=8TwOUGgN5Iqvaj2/pS9j9BQVHmRbgPx3GEesx7wnsEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tMeTBQUkDmWk8FVh0QZbL8qVbFYMi7bei1HS+jizCvxntTj78Gq/SqjgydD3/bh/g
         v6zK36egf1d1WmtbAvSyXDDZTkm11rn9MfTY6NO3gpH/pa+pQ41mx7rdHfhTPKhHrc
         blw+S6ykr+uIG+s3apYJgwYzXTuZfh3WPOblD/ObIVrL5znZeHWzvtNosbhRk4+3pr
         haHZmzJdf4nQ4t4cQU7Y8vkm7XbGuhwrKo9Xps9xHwJzi32hqe58Uy7lbMnmOEGWK7
         vqF00QVkHMERWaIVllTAdYxSxPkyqhzyWgK1zt5hnnf32Bh6RKjcCWP6URT38/bYzk
         S95wkLJPFmzrg==
Date:   Fri, 9 Dec 2022 20:13:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Paolo Abeni" <pabeni@redhat.com>, <jbe@pengutronix.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v5 2/6] dsa: lan9303: move Turbo Mode bit
 initialization
Message-ID: <20221209201353.2d6f4852@kernel.org>
In-Reply-To: <20221209224713.19980-3-jerry.ray@microchip.com>
References: <20221209224713.19980-1-jerry.ray@microchip.com>
        <20221209224713.19980-3-jerry.ray@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Dec 2022 16:47:09 -0600 Jerry Ray wrote:
> In preparing to remove the .adjust_link api, I am moving the one-time
> initialization of the device's Turbo Mode bit into a different execution
> path. This code clears (disables) the Turbo Mode bit which is never used
> by this driver. Turbo Mode is a non-standard mode that would allow the
> 100Mbps RMII interface to run at 200Mbps.

> @@ -1073,14 +1079,6 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
>  		ctl &= ~BMCR_FULLDPLX;
>  
>  	lan9303_phy_write(ds, port, MII_BMCR, ctl);
> -
> -	if (port == chip->phy_addr_base) {
> -		/* Virtual Phy: Remove Turbo 200Mbit mode */
> -		lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ctl);
> -
> -		ctl &= ~LAN9303_VIRT_SPECIAL_TURBO;
> -		regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl);
> -	}
>  }
>  
>  static int lan9303_port_enable(struct dsa_switch *ds, int port,

The chip variable has to go, otherwise there will be a warning in
bisection until patch 6 removes this entire function:

drivers/net/dsa/lan9303-core.c:1059:18: warning: unused variable 'chip' [-Wunused-variable]
        struct lan9303 *chip = ds->priv;
                        ^
