Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04F7A557373
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiFWHBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiFWHBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:01:51 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6103645065;
        Thu, 23 Jun 2022 00:01:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id B6087804D;
        Thu, 23 Jun 2022 06:56:47 +0000 (UTC)
Date:   Thu, 23 Jun 2022 10:01:48 +0300
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
Message-ID: <YrQP3OZbe8aCQxKU@atomide.com>
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com>
 <YrFzK6EiVvXmzVG6@atomide.com>
 <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
 <YrKhkmj3jCQA39X/@atomide.com>
 <CAGETcx_11wO-HkZ2QsBF8o1+L9L3Xe1QBQ_GzegwozxAx1i0jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_11wO-HkZ2QsBF8o1+L9L3Xe1QBQ_GzegwozxAx1i0jg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Saravana Kannan <saravanak@google.com> [220622 19:05]:
> On Tue, Jun 21, 2022 at 9:59 PM Tony Lindgren <tony@atomide.com> wrote:
> >
> > Hi,
> >
> > * Saravana Kannan <saravanak@google.com> [220621 19:29]:
> > > On Tue, Jun 21, 2022 at 12:28 AM Tony Lindgren <tony@atomide.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > * Saravana Kannan <saravanak@google.com> [700101 02:00]:
> > > > > Now that fw_devlink=on by default and fw_devlink supports
> > > > > "power-domains" property, the execution will never get to the point
> > > > > where driver_deferred_probe_check_state() is called before the supplier
> > > > > has probed successfully or before deferred probe timeout has expired.
> > > > >
> > > > > So, delete the call and replace it with -ENODEV.
> > > >
> > > > Looks like this causes omaps to not boot in Linux next.
> > >
> > > Can you please point me to an example DTS I could use for debugging
> > > this? I'm assuming you are leaving fw_devlink=on and not turning it
> > > off or putting it in permissive mode.
> >
> > Sure, this seems to happen at least with simple-pm-bus as the top
> > level interconnect with a configured power-domains property:
> >
> > $ git grep -A10 "ocp {" arch/arm/boot/dts/*.dtsi | grep -B3 -A4 simple-pm-bus
> 
> Thanks for the example. I generally start looking from dts (not dtsi)
> files in case there are some DT property override/additions after the
> dtsi files are included in the dts file. But I'll assume for now
> that's not the case. If there's a specific dts file for a board I can
> look from that'd be helpful to rule out those kinds of issues.
> 
> For now, I looked at arch/arm/boot/dts/omap4.dtsi.

OK it should be very similar for all the affected SoCs.

> > This issue is no directly related fw_devlink. It is a side effect of
> > removing driver_deferred_probe_check_state(). We no longer return
> > -EPROBE_DEFER at the end of driver_deferred_probe_check_state().
> 
> Yes, I understand the issue. But driver_deferred_probe_check_state()
> was deleted because fw_devlink=on should have short circuited the
> probe attempt with an  -EPROBE_DEFER before reaching the bus/driver
> probe function and hitting this -ENOENT failure. That's why I was
> asking the other questions.

OK. So where is the -EPROBE_DEFER supposed to happen without
driver_deferred_probe_check_state() then?

> > > > On platform_probe() genpd_get_from_provider() returns
> > > > -ENOENT.
> > >
> > > This error is with the series I assume?
> >
> > On the first probe genpd_get_from_provider() will return -ENOENT in
> > both cases. The list is empty on the first probe and there are no
> > genpd providers at this point.
> >
> > Earlier with driver_deferred_probe_check_state(), the initial -ENOENT
> > ends up getting changed to -EPROBE_DEFER at the end of
> > driver_deferred_probe_check_state(), we are now missing that.
> 
> Right, I was aware -ENOENT would be returned if we got this far. But
> the point of this series is that you shouldn't have gotten that far
> before your pm domain device is ready. Hence my questions from the
> earlier reply.

OK

> Can I get answers to rest of my questions in the first reply please?
> That should help us figure out why fw_devlink let us get this far.
> Summarize them here to make it easy:
> * Are you running with fw_devlink=on?

Yes with the default with no specific kernel params so looks like
FW_DEVLINK_FLAGS_ON.

> * Is the"ti,omap4-prm-inst"/"ti,omap-prm-inst" built-in in this case?

Yes

> * If it's not built-in, can you please try deferred_probe_timeout=0
> and deferred_probe_timeout=30 and see if either one of them help?

It's built in so I did not try these.

> * Can I get the output of "ls -d supplier:*" and "cat
> supplier:*/status" output from the sysfs dir for the ocp device
> without this series where it boots properly.

Hmm so I'm not seeing any supplier for the top level ocp device in
the booting case without your patches. I see the suppliers for the
ocp child device instances only.

Without your patches I see simple-pm-bus probe initially with
EPROBE_DEFER like I described earlier, and then simple-pm-bus probes
on the second try.

Regards,

Tony
