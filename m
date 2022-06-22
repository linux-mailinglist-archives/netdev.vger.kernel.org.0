Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D075541F3
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 06:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357007AbiFVE7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 00:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356969AbiFVE7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 00:59:04 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0F64289B8;
        Tue, 21 Jun 2022 21:59:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 6B48A809F;
        Wed, 22 Jun 2022 04:54:00 +0000 (UTC)
Date:   Wed, 22 Jun 2022 07:58:58 +0300
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
Message-ID: <YrKhkmj3jCQA39X/@atomide.com>
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com>
 <YrFzK6EiVvXmzVG6@atomide.com>
 <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

* Saravana Kannan <saravanak@google.com> [220621 19:29]:
> On Tue, Jun 21, 2022 at 12:28 AM Tony Lindgren <tony@atomide.com> wrote:
> >
> > Hi,
> >
> > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > Now that fw_devlink=on by default and fw_devlink supports
> > > "power-domains" property, the execution will never get to the point
> > > where driver_deferred_probe_check_state() is called before the supplier
> > > has probed successfully or before deferred probe timeout has expired.
> > >
> > > So, delete the call and replace it with -ENODEV.
> >
> > Looks like this causes omaps to not boot in Linux next.
> 
> Can you please point me to an example DTS I could use for debugging
> this? I'm assuming you are leaving fw_devlink=on and not turning it
> off or putting it in permissive mode.

Sure, this seems to happen at least with simple-pm-bus as the top
level interconnect with a configured power-domains property:

$ git grep -A10 "ocp {" arch/arm/boot/dts/*.dtsi | grep -B3 -A4 simple-pm-bus

This issue is no directly related fw_devlink. It is a side effect of
removing driver_deferred_probe_check_state(). We no longer return
-EPROBE_DEFER at the end of driver_deferred_probe_check_state().

> > On platform_probe() genpd_get_from_provider() returns
> > -ENOENT.
> 
> This error is with the series I assume?

On the first probe genpd_get_from_provider() will return -ENOENT in
both cases. The list is empty on the first probe and there are no
genpd providers at this point.

Earlier with driver_deferred_probe_check_state(), the initial -ENOENT
ends up getting changed to -EPROBE_DEFER at the end of
driver_deferred_probe_check_state(), we are now missing that.

Regards,

Tony
