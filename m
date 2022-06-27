Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4D155C28A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbiF0JK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 05:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233571AbiF0JK0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 05:10:26 -0400
Received: from muru.com (muru.com [72.249.23.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6419F2667;
        Mon, 27 Jun 2022 02:10:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 310998106;
        Mon, 27 Jun 2022 09:05:11 +0000 (UTC)
Date:   Mon, 27 Jun 2022 12:10:20 +0300
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
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: Re: [PATCH v2 1/9] PM: domains: Delete usage of
 driver_deferred_probe_check_state()
Message-ID: <Yrlz/P6Un2fACG98@atomide.com>
References: <20220601070707.3946847-1-saravanak@google.com>
 <20220601070707.3946847-2-saravanak@google.com>
 <YrFzK6EiVvXmzVG6@atomide.com>
 <CAGETcx_1USPRbFKV5j00qkQ-QXJkp7=FAfnFcfiNnM4J5KF1cQ@mail.gmail.com>
 <YrKhkmj3jCQA39X/@atomide.com>
 <CAGETcx_11wO-HkZ2QsBF8o1+L9L3Xe1QBQ_GzegwozxAx1i0jg@mail.gmail.com>
 <YrQP3OZbe8aCQxKU@atomide.com>
 <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx9aFBzMcuOiTAEy5SJyWw3UfajZ8DVQfW2DGmzzDabZVg@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Saravana Kannan <saravanak@google.com> [220623 08:17]:
> On Thu, Jun 23, 2022 at 12:01 AM Tony Lindgren <tony@atomide.com> wrote:
> >
> > * Saravana Kannan <saravanak@google.com> [220622 19:05]:
> > > On Tue, Jun 21, 2022 at 9:59 PM Tony Lindgren <tony@atomide.com> wrote:
> > > > This issue is no directly related fw_devlink. It is a side effect of
> > > > removing driver_deferred_probe_check_state(). We no longer return
> > > > -EPROBE_DEFER at the end of driver_deferred_probe_check_state().
> > >
> > > Yes, I understand the issue. But driver_deferred_probe_check_state()
> > > was deleted because fw_devlink=on should have short circuited the
> > > probe attempt with an  -EPROBE_DEFER before reaching the bus/driver
> > > probe function and hitting this -ENOENT failure. That's why I was
> > > asking the other questions.
> >
> > OK. So where is the -EPROBE_DEFER supposed to happen without
> > driver_deferred_probe_check_state() then?
> 
> device_links_check_suppliers() call inside really_probe() would short
> circuit and return an -EPROBE_DEFER if the device links are created as
> expected.

OK

> > Hmm so I'm not seeing any supplier for the top level ocp device in
> > the booting case without your patches. I see the suppliers for the
> > ocp child device instances only.
> 
> Hmmm... this is strange (that the device link isn't there), but this
> is what I suspected.

Yup, maybe it's because of the supplier being a device in the child
interconnect for the ocp.

> Now we need to figure out why it's missing. There are only a few
> things that could cause this and I don't see any of those. I already
> checked to make sure the power domain in this instance had a proper
> driver with a probe() function -- if it didn't, then that's one thing
> that'd could have caused the missing device link. The device does seem
> to have a proper driver, so looks like I can rule that out.
> 
> Can you point me to the dts file that corresponds to the specific
> board you are testing this one? I probably won't find anything, but I
> want to rule out some of the possibilities.

You can use the beaglebone black dts for example, that's
arch/arm/boot/dts/am335x-boneblack.dts and uses am33xx.dtsi for
ocp interconnect with simple-pm-bus.

> All the device link creation logic is inside drivers/base/core.c. So
> if you can look at the existing messages or add other stuff to figure
> out why the device link isn't getting created, that'd be handy. In
> either case, I'll continue staring at the DT and code to see what
> might be happening here.

In device_links_check_suppliers() I see these ocp suppliers:

platform ocp: device_links_check_suppliers: 1024: supplier 44e00d00.prm: link->status: 0 link->flags: 000001c0
platform ocp: device_links_check_suppliers: 1024: supplier 44e01000.prm: link->status: 0 link->flags: 000001c0
platform ocp: device_links_check_suppliers: 1024: supplier 44e00c00.prm: link->status: 0 link->flags: 000001c0
platform ocp: device_links_check_suppliers: 1024: supplier 44e00e00.prm: link->status: 0 link->flags: 000001c0
platform ocp: device_links_check_suppliers: 1024: supplier 44e01100.prm: link->status: 0 link->flags: 000001c0
platform ocp: device_links_check_suppliers: 1024: supplier fixedregulator0: link->status: 1 link->flags: 000001c0

No -EPROBE_DEFER is returned in device_links_check_suppliers() for
44e00c00.prm supplier for beaglebone black for example, 0 gets
returned.

Regards,

Tony
