Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4873077C2
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231178AbhA1OSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:18:05 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36412 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229870AbhA1OSE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:18:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l586j-0032l3-J9; Thu, 28 Jan 2021 15:17:13 +0100
Date:   Thu, 28 Jan 2021 15:17:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com,
        vadimp@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <YBLHaagSmqqUVap+@lunn.ch>
References: <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121153224.GE3565223@nanopsycho.orion>
 <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
 <20210122072814.GG3565223@nanopsycho.orion>
 <YArdeNwXb9v55o/Z@lunn.ch>
 <20210126113326.GO3565223@nanopsycho.orion>
 <YBAfeESYudCENZ2e@lunn.ch>
 <20210127075753.GP3565223@nanopsycho.orion>
 <YBF1SmecdzLOgSIl@lunn.ch>
 <20210128081434.GV3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210128081434.GV3565223@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 09:14:34AM +0100, Jiri Pirko wrote:
> Wed, Jan 27, 2021 at 03:14:34PM CET, andrew@lunn.ch wrote:
> >> >There are Linux standard APIs for controlling the power to devices,
> >> >the regulator API. So i assume mlxreg-pm will make use of that. There
> >> >are also standard APIs for thermal management, which again, mlxreg-pm
> >> >should be using. The regulator API allows you to find regulators by
> >> >name. So just define a sensible naming convention, and the switch
> >> >driver can lookup the regulator, and turn it on/off as needed.
> >> 
> >> 
> >> I don't think it would apply. The thing is, i2c driver has a channel to
> >> the linecard eeprom, from where it can read info about the linecard. The
> >> i2c driver also knows when the linecard is plugged in, unlike mlxsw.
> >> It acts as a standalone driver. Mlxsw has no way to directly find if the
> >> card was plugged in (unpowered) and which type it is.
> >> 
> >> Not sure how to "embed" it. I don't think any existing API could help.
> >> Basicall mlxsw would have to register a callback to the i2c driver
> >> called every time card is inserted to do auto-provision.
> >> Now consider a case when there are multiple instances of the ASIC on the
> >> system. How to assemble a relationship between mlxsw instance and i2c
> >> driver instance?
> >
> >You have that knowledge already, otherwise you cannot solve this
> 
> No I don't have it. I'm not sure why do you say so. The mlxsw and i2c
> driver act independently.

Ah, so you just export some information in /sys from the i2c driver?
And you expect the poor user to look at the values, and copy paste
them to the correct mlxsw instance? 50/50 guess if you have two
switches, and hope they don't make a typO?

> >I still don't actually get this use case. Why would i want to manually
> >provision?
> 
> Because user might want to see the system with all netdevices, configure
> them, change the linecard if they got broken and all config, like
> bridge, tc, etc will stay on the netdevices. Again, this is the same we
> do for split port. This is important requirement, user don't want to see
> netdevices come and go when he is plugging/unplugging cables. Linecards
> are the same in this matter. Basically is is a "splitter module",
> replacing the "splitter cable"

So, what is the real use case here? Why might the user want to do
this?

Is it: The magic smoke has escaped. The user takes a spare switch, and
wants to put it on her desk to configure it where she has a comfy chair
and piece and quiet, unlike in the data centre, which is very noise,
only has hard plastic chair, no coffee allowed. She makes her best
guess at the configuration, up/downs the interfaces, reboots, to make
sure it is permanent, and only then moves to the data centre to swap
the dead router for the new one, and fix up whatever configuration
errors there are, while sat on the hard chair?

So this feature is about comfy chair vs hard chair?

I'm also wondering about the splitter port use case. At what point do
you tell the user that it is physically impossible to split the port
because the SFP simply does not support it? You say the netdevs don't
come/go. I assume the link never goes up, but how does the user know
the configuration is FUBAR, not the SFP? To me, it seems a lot more
intuitive that when i remove an SFP which has been split into 4, and
pop in an SFP which only supports a single stream, the 3 extra netdevs
would just vanish.

   Andrew

