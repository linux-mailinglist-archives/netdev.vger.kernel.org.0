Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F09B557763
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 12:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbiFWKGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 06:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiFWKGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 06:06:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93E549CBE
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 03:06:10 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o4JhK-0001s4-PU; Thu, 23 Jun 2022 12:04:26 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1o4JhF-0006Dc-DA; Thu, 23 Jun 2022 12:04:21 +0200
Date:   Thu, 23 Jun 2022 12:04:21 +0200
From:   sascha hauer <sha@pengutronix.de>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Len Brown <lenb@kernel.org>, peng fan <peng.fan@nxp.com>,
        kevin hilman <khilman@kernel.org>,
        ulf hansson <ulf.hansson@linaro.org>,
        len brown <len.brown@intel.com>, pavel machek <pavel@ucw.cz>,
        joerg roedel <joro@8bytes.org>, will deacon <will@kernel.org>,
        andrew lunn <andrew@lunn.ch>,
        heiner kallweit <hkallweit1@gmail.com>,
        russell king <linux@armlinux.org.uk>,
        "david s. miller" <davem@davemloft.net>,
        eric dumazet <edumazet@google.com>,
        jakub kicinski <kuba@kernel.org>,
        paolo abeni <pabeni@redhat.com>,
        linus walleij <linus.walleij@linaro.org>,
        hideaki yoshifuji <yoshfuji@linux-ipv6.org>,
        david ahern <dsahern@kernel.org>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        iommu@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] of: base: Avoid console probe delay when
 fw_devlink.strict=1
Message-ID: <20220623100421.GY1615@pengutronix.de>
References: <20220623080344.783549-1-saravanak@google.com>
 <20220623080344.783549-3-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623080344.783549-3-saravanak@google.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
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

On Thu, Jun 23, 2022 at 01:03:43AM -0700, Saravana Kannan wrote:
> Commit 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> enabled iommus and dmas dependency enforcement by default. On some
> systems, this caused the console device's probe to get delayed until the
> deferred_probe_timeout expires.
> 
> We need consoles to work as soon as possible, so mark the console device
> node with FWNODE_FLAG_BEST_EFFORT so that fw_delink knows not to delay
> the probe of the console device for suppliers without drivers. The
> driver can then make the decision on where it can probe without those
> suppliers or defer its probe.
> 
> Fixes: 71066545b48e ("driver core: Set fw_devlink.strict=1 by default")
> Reported-by: Sascha Hauer <sha@pengutronix.de>
> Reported-by: Peng Fan <peng.fan@nxp.com>
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> Tested-by: Peng Fan <peng.fan@nxp.com>
> ---
>  drivers/of/base.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index d4f98c8469ed..a19cd0c73644 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1919,6 +1919,8 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>  			of_property_read_string(of_aliases, "stdout", &name);
>  		if (name)
>  			of_stdout = of_find_node_opts_by_path(name, &of_stdout_options);
> +		if (of_stdout)
> +			of_stdout->fwnode.flags |= FWNODE_FLAG_BEST_EFFORT;

The device given in the stdout-path property doesn't necessarily have to
be consistent with the console= parameter. The former is usually
statically set in the device trees contained in the kernel while the
latter is dynamically set by the bootloader. So if you change the
console uart in the bootloader then you'll still run into this trap.

It's problematic to consult only the device tree for dependencies. I
found several examples of drivers in the tree for which dma support
is optional. They use it if they can, but continue without it when
not available. "hwlock" is another property which consider several
drivers as optional. Also consider SoCs in early upstreaming phases
when the device tree is merged with "dmas" or "hwlock" properties,
but the corresponding drivers are not yet upstreamed. It's not nice
to defer probing of all these devices for a long time.

I wonder if it wouldn't be a better approach to just probe all devices
and record the device(node) they are waiting on. Then you know that you
don't need to probe them again until the device they are waiting for
is available.

Sascha


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
