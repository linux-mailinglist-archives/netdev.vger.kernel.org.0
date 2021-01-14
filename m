Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5326B2F6EF6
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 00:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731015AbhANXa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 18:30:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:35252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730937AbhANXa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 18:30:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF83223A6C;
        Thu, 14 Jan 2021 23:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610667015;
        bh=hDyYVACMbaDVPJ9ddvcc57s/N+BhZjAulMmh/Y2hCPE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rA26G1zyOJ4j1w7eAZF9R4xKWvGCU9lp6+TuphqrzMjOPmAXeHjuNDX0BdSiLitvT
         4jSZ3SUDH5Rbhdc4VE7Yt8eKg5vOFcFgslFB49+jZjMobqYF6l1agUjCwJd0iA+T8m
         pG18xGkjcOkE6sBGAaaFmLAlaYus+U2cL2sEH4P6Y4H8aI+rL7SAqkLbqR+h6UJm2a
         QR6B+41ru8/4pwC86FJvZmcYCqt8edAzqbsh0/LiJrUQPNKLFnVrrQUeodOC3YbXz0
         3z1UEIhaqQtB75AImcnGjUUJY3fAp11rkkVgmmn4OaAmDfT7WBoH99Ut5Nn4A05C+q
         f0sDbEt3OoJ9g==
Date:   Thu, 14 Jan 2021 15:30:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210114153013.2ce357b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210114074804.GK3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
        <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210114074804.GK3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jan 2021 08:48:04 +0100 Jiri Pirko wrote:
> Thu, Jan 14, 2021 at 03:27:16AM CET, kuba@kernel.org wrote:
> >On Wed, 13 Jan 2021 13:12:12 +0100 Jiri Pirko wrote:  
> >> This patchset introduces support for modular switch systems.
> >> NVIDIA Mellanox SN4800 is an example of such. It contains 8 slots
> >> to accomodate line cards. Available line cards include:
> >> 16X 100GbE (QSFP28)
> >> 8X 200GbE (QSFP56)
> >> 4X 400GbE (QSFP-DD)
> >> 
> >> Similar to split cabels, it is essencial for the correctness of
> >> configuration and funcionality to treat the line card entities
> >> in the same way, no matter the line card is inserted or not.
> >> Meaning, the netdevice of a line card port cannot just disappear
> >> when line card is removed. Also, system admin needs to be able
> >> to apply configuration on netdevices belonging to line card port
> >> even before the linecard gets inserted.  
> >
> >I don't understand why that would be. Please provide reasoning, 
> >e.g. what the FW/HW limitation is.  
> 
> Well, for split cable, you need to be able to say:
> port 2, split into 4. And you will have 4 netdevices. These netdevices
> you can use to put into bridge, configure mtu, speeds, routes, etc.
> These will exist no matter if the splitter cable is actually inserted or
> not.

The difference is that the line card is more detectable (I hope).

I'm not a SFP experts so maybe someone will correct me but AFAIU
the QSFP (for optics) is the same regardless of breakout. It's the
passive optical strands that are either bundled or not. So there is 
no way for the system to detect the cable type (AFAIK).

Or to put it differently IMO the netdev should be provisioned if the
system has a port into which user can plug in a cable. When there is 
a line card-sized hole in the chassis, I'd be surprised to see ports.

That said I never worked with real world routers so maybe that's what
they do. Maybe some with a Cisco router in the basement can tell us? :)

> With linecards, this is very similar. By provisioning, you also create
> certain number of ports, according to the linecard that you plan to
> insert. And similarly to the splitter, the netdevices are created.
> 
> You may combine the linecard/splitter config when splitter cable is
> connected to a linecard port. Then you provision a linecard,
> port is going to appear and you will split this port.
> 
> >> To resolve this, a concept of "provisioning" is introduced.
> >> The user may "provision" certain slot with a line card type.
> >> Driver then creates all instances (devlink ports, netdevices, etc)
> >> related to this line card type. The carrier of netdevices stays down.
> >> Once the line card is inserted and activated, the carrier of the
> >> related netdevices goes up.  
> >
> >Dunno what "line card" means for Mellovidia but I don't think 
> >the analogy of port splitting works. To my knowledge traditional
> >line cards often carry processors w/ full MACs etc. so I'd say 
> >plugging in a line card is much more like plugging in a new NIC.  
> 
> No. It is basically a phy gearbox. The mac is not there. The interface
> between asic and linecard are lanes. The linecards is basically an
> attachable phy.

If the device really needs this configuration / can't detect things
automatically, then we gotta do something like what you have.
The only question is do we still want to call it a line card.
Sounds more like a front panel module. At Netronome we called 
those phymods.
