Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16A2552C0C
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 09:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347638AbiFUH3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 03:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347706AbiFUH2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 03:28:50 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A1D1CCE22;
        Tue, 21 Jun 2022 00:28:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id EC05F809F;
        Tue, 21 Jun 2022 07:23:46 +0000 (UTC)
Date:   Tue, 21 Jun 2022 10:28:43 +0300
From:   Tony Lindgren <tony@atomide.com>
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
        linux-gpio@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of
 driver_deferred_probe_check_state()
Message-ID: <YrFzK6EiVvXmzVG6@atomide.com>
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601070707.3946847-2-saravanak@google.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

* Saravana Kannan <saravanak@google.com> [700101 02:00]:
> Now that fw_devlink=on by default and fw_devlink supports
> "power-domains" property, the execution will never get to the point
> where driver_deferred_probe_check_state() is called before the supplier
> has probed successfully or before deferred probe timeout has expired.
> 
> So, delete the call and replace it with -ENODEV.

Looks like this causes omaps to not boot in Linux next. With this
simple-pm-bus fails to probe initially as the power-domain is not
yet available. On platform_probe() genpd_get_from_provider() returns
-ENOENT.

Seems like other stuff is potentially broken too, any ideas on
how to fix this?

Regards,

Tony



> 
> Signed-off-by: Saravana Kannan <saravanak@google.com>
> ---
>  drivers/base/power/domain.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index 739e52cd4aba..3e86772d5fac 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -2730,7 +2730,7 @@ static int __genpd_dev_pm_attach(struct device *dev, struct device *base_dev,
>  		mutex_unlock(&gpd_list_lock);
>  		dev_dbg(dev, "%s() failed to find PM domain: %ld\n",
>  			__func__, PTR_ERR(pd));
> -		return driver_deferred_probe_check_state(base_dev);
> +		return -ENODEV;
>  	}
>  
>  	dev_dbg(dev, "adding to PM domain %s\n", pd->name);
> -- 
> 2.36.1.255.ge46751e96f-goog
> 
