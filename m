Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9DE255443E
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 10:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350823AbiFVHt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 03:49:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351483AbiFVHtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 03:49:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52631266C
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 00:49:18 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o3v5s-0000nJ-UD; Wed, 22 Jun 2022 09:48:08 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o3v5g-0000yF-8I; Wed, 22 Jun 2022 09:47:56 +0200
Date:   Wed, 22 Jun 2022 09:47:56 +0200
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2 7/9] driver core: Set fw_devlink.strict=1 by default
Message-ID: <20220622074756.GA1647@pengutronix.de>
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-8-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601070707.3946847-8-saravanak@google.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
From:   Sascha Hauer <sha@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 01, 2022 at 12:07:03AM -0700, Saravana Kannan wrote:
> Now that deferred_probe_timeout is non-zero by default, fw_devlink will
> never permanently block the probing of devices. It'll try its best to
> probe the devices in the right order and then finally let devices probe
> even if their suppliers don't have any drivers.
> 
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/base/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

As mentioned here:

https://lore.kernel.org/lkml/20220622062027.994614-1-peng.fan@oss.nxp.com/

This patch has the effect that console UART devices which have "dmas"
properties specified in the device tree get deferred for 10 to 20
seconds. This happens on i.MX and likely on other SoCs as well. On i.MX
the dma channel is only requested at UART startup time and not at probe
time. dma is not used for the console. Nevertheless with this driver probe
defers until the dma engine driver is available.

It shouldn't go in as-is.

Sascha

> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 61fdfe99b348..977b379a495b 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1613,7 +1613,7 @@ static int __init fw_devlink_setup(char *arg)
>  }
>  early_param("fw_devlink", fw_devlink_setup);
>  
> -static bool fw_devlink_strict;
> +static bool fw_devlink_strict = true;
>  static int __init fw_devlink_strict_setup(char *arg)
>  {
>  	return strtobool(arg, &fw_devlink_strict);
> -- 
> 2.36.1.255.ge46751e96f-goog
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
