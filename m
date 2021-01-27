Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60431305E06
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 15:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233266AbhA0OQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 09:16:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233620AbhA0OPU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 09:15:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l4lac-002sPd-6I; Wed, 27 Jan 2021 15:14:34 +0100
Date:   Wed, 27 Jan 2021 15:14:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Ahern <dsahern@gmail.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com,
        vadimp@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <YBF1SmecdzLOgSIl@lunn.ch>
References: <20210120083605.GB3565223@nanopsycho.orion>
 <YAg2ngUQIty8U36l@lunn.ch>
 <20210120154158.206b8752@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210121153224.GE3565223@nanopsycho.orion>
 <971e9eff-0b71-8ff9-d72c-aebe73cab599@gmail.com>
 <20210122072814.GG3565223@nanopsycho.orion>
 <YArdeNwXb9v55o/Z@lunn.ch>
 <20210126113326.GO3565223@nanopsycho.orion>
 <YBAfeESYudCENZ2e@lunn.ch>
 <20210127075753.GP3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127075753.GP3565223@nanopsycho.orion>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >There are Linux standard APIs for controlling the power to devices,
> >the regulator API. So i assume mlxreg-pm will make use of that. There
> >are also standard APIs for thermal management, which again, mlxreg-pm
> >should be using. The regulator API allows you to find regulators by
> >name. So just define a sensible naming convention, and the switch
> >driver can lookup the regulator, and turn it on/off as needed.
> 
> 
> I don't think it would apply. The thing is, i2c driver has a channel to
> the linecard eeprom, from where it can read info about the linecard. The
> i2c driver also knows when the linecard is plugged in, unlike mlxsw.
> It acts as a standalone driver. Mlxsw has no way to directly find if the
> card was plugged in (unpowered) and which type it is.
> 
> Not sure how to "embed" it. I don't think any existing API could help.
> Basicall mlxsw would have to register a callback to the i2c driver
> called every time card is inserted to do auto-provision.
> Now consider a case when there are multiple instances of the ASIC on the
> system. How to assemble a relationship between mlxsw instance and i2c
> driver instance?

You have that knowledge already, otherwise you cannot solve this
problem at all. The switch is an PCIe device right? So when the bus is
enumerated, the driver loads. How do you bind the i2c driver to the
i2c bus? You cannot enumerate i2c, so you must have some hard coded
knowledge somewhere? You just need to get that knowledge into the
mlxsw driver so it can bind its internal i2c client driver to the i2c
bus. That way you avoid user space, i guess maybe udev rules, or some
daemon monitoring propriety /sys files?

> But again, auto-provision is only one usecase. Manual provisioning is
> needed anyway. And that is exactly what my patchset is aiming to
> introduce. Auto-provision can be added when/if needed later on.

I still don't actually get this use case. Why would i want to manually
provision?

	Andrew
