Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68B24659A78
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 17:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbiL3QRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 11:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbiL3QRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 11:17:47 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F163636F;
        Fri, 30 Dec 2022 08:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XsTtrjg75si90dxfNtwbabByETT2NBXCVBmC40eZH04=; b=IZ0KhtNn2y1QLsmjvOkmntLu97
        IbeYhdPHWUsp0yyWMS9oytIY+1lx1y1oqlUglRtNTiMkqNaGYHa+p4NoQEEoJbRFCtUx6oJ+Umoho
        BHgk7XDQen41+LoPAmU+XCiLwtQrKUJGHHpsGHXwcCIFKn2Zyn6FwP/7p2sztzXXEIdY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pBI4N-000leV-Mk; Fri, 30 Dec 2022 17:17:19 +0100
Date:   Fri, 30 Dec 2022 17:17:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Lixue Liang <lianglixuehao@126.com>,
        anthony.l.nguyen@intel.com, linux-kernel@vger.kernel.org,
        jesse.brandeburg@intel.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        lianglixue@greatwall.com.cn
Subject: Re: [PATCH v7] igb: Assign random MAC address instead of fail in
 case of invalid one
Message-ID: <Y68PD9G2tXkb9AZ/@lunn.ch>
References: <20221213074726.51756-1-lianglixuehao@126.com>
 <Y5l5pUKBW9DvHJAW@unreal>
 <20221214085106.42a88df1@kernel.org>
 <Y5obql8TVeYEsRw8@unreal>
 <20221214125016.5a23c32a@kernel.org>
 <Y57SPPmui6cwD5Ma@unreal>
 <CAKgT0UfZk3=b0q3AQiexaJ=gCz6vW_hnHRnFiYLFSCESYdenOw@mail.gmail.com>
 <Y6wJFYMZVQ7V+ogG@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6wJFYMZVQ7V+ogG@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 11:15:01AM +0200, Leon Romanovsky wrote:
> On Mon, Dec 19, 2022 at 07:30:45AM -0800, Alexander Duyck wrote:
> > On Sun, Dec 18, 2022 at 12:41 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Wed, Dec 14, 2022 at 12:50:16PM -0800, Jakub Kicinski wrote:
> > > > On Wed, 14 Dec 2022 20:53:30 +0200 Leon Romanovsky wrote:
> > > > > On Wed, Dec 14, 2022 at 08:51:06AM -0800, Jakub Kicinski wrote:
> > > > > > On Wed, 14 Dec 2022 09:22:13 +0200 Leon Romanovsky wrote:
> > > > > > > NAK to any module driver parameter. If it is applicable to all drivers,
> > > > > > > please find a way to configure it to more user-friendly. If it is not,
> > > > > > > try to do the same as other drivers do.
> > > > > >
> > > > > > I think this one may be fine. Configuration which has to be set before
> > > > > > device probing can't really be per-device.
> > > > >
> > > > > This configuration can be different between multiple devices
> > > > > which use same igb module. Module parameters doesn't allow such
> > > > > separation.
> > > >
> > > > Configuration of the device, sure, but this module param is more of
> > > > a system policy.
> > >
> > > And system policy should be controlled by userspace and applicable to as
> > > much as possible NICs, without custom module parameters.
> > >
> > > I would imagine global (at the beginning, till someone comes forward and
> > > requests this parameter be per-device) to whole stack parameter with policies:
> > >  * Be strict - fail if mac is not valid
> > >  * Fallback to random
> > >  * Random only ???
> > >
> > > Thanks
> > 
> > So are you suggesting you would rather see something like this as a
> > sysctl then? Maybe something like net.core.netdev_mac_behavior where
> > we have some enum with a predetermined set of behaviors available? I
> > would be fine with us making this a global policy if that is the route
> > we want to go. It would just be a matter of adding the sysctl and an
> > accessor so that drivers can determine if it is set or not.
> 
> Something like that and maybe convert drivers and/or to honor this policy.

Converting drivers is very unlikely to happen. There are over 240
calls to register_netdev() under drivers/net/ethernet. Who has the
time to add such code to so many drivers?

What many drivers do is called one of platform_get_ethdev_addr(),
of_get_mac_address(), or device_get_ethdev_address() etc, which will
look around DT, ACPI and maybe in NVMEM, etc. It is not user space
controllable policy, but most drivers fall back to a random MAC
address, and a warning, if no fixed MAC addresses can be found.

So i would recommend doing what most drivers do, if everything else
fails, us a random address.

       Andrew
