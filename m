Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671A52FA82F
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407424AbhARSAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:00:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:50704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407406AbhARSAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 13:00:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 64AF222CA1;
        Mon, 18 Jan 2021 17:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610992769;
        bh=Q3CznFJObrOdiKKsNCmp4RFd+ncbsGgt9PXPMokl0Xs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RiB57tevKDMTI8lM9qC/2fpsy8nluGaJWX5VAyLl+L+BAx9Puqr0VfmP/bofb4cOz
         3xoqYhWR02HLpZMjomISFwDnqZKTJ7GBneQb1dQyINaom68ZjuNGrdR6d1PxRQFG80
         q5NFHLf8U8t8Htqq4TJhRptSphSv7GlWYmTOwg30CX/DNXdSSLiJ98osjs9pTQFPJK
         bCCBfKacW4e47FpMdisHavWMfXVLYecIZP7pNhWo2itGOcKx0qGuaKl2Y5cmt06t53
         6XPOVzy/91xhvTn6wPGLL60b6nQgxIs2v4PP6vvvC7/AmQfe4DFFAm/DkpEiGqbGqQ
         fKd6Av5AqyuMQ==
Date:   Mon, 18 Jan 2021 09:59:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210118095928.001b5687@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210118130009.GU3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
        <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210114074804.GK3565223@nanopsycho.orion>
        <20210114153013.2ce357b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210115143906.GM3565223@nanopsycho.orion>
        <20210115112617.064deda8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210118130009.GU3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 18 Jan 2021 14:00:09 +0100 Jiri Pirko wrote:
> >> >Or to put it differently IMO the netdev should be provisioned if the
> >> >system has a port into which user can plug in a cable. When there is     
> >> 
> >> Not really. For slit cables, the ports are provisioned not matter which
> >> cable is connected, slitter 1->2/1->4 or 1->1 cable.
> >> 
> >>   
> >> >a line card-sized hole in the chassis, I'd be surprised to see ports.
> >> >
> >> >That said I never worked with real world routers so maybe that's what
> >> >they do. Maybe some with a Cisco router in the basement can tell us? :)    
> >> 
> >> The need for provision/pre-configure splitter/linecard is that the
> >> ports/netdevices do not disapper/reappear when you replace
> >> splitter/linecard. Consider a faulty linecard with one port burned. You
> >> just want to replace it with new one. And in that case, you really don't
> >> want kernel to remove netdevices and possibly mess up routing for
> >> example.  
> >
> >Having a single burned port sounds like a relatively rare scenario.  
> 
> Hmm, rare in scale is common...

Sure but at a scale of million switches it doesn't matter if a couple
are re-configuring their routing.

> >Reconfiguring routing is not the end of the world.  
> 
> Well, yes, but you don't really want netdevices to come and go then you
> plug in/out cables/modules. That's why we have split implemented as we
> do. I don't understand why do you think linecards are different.

If I have an unused port it will still show up as a netdev.
If I have an unused phymod slot w/ a slot cover in it, why would there
be a netdev? Our definition of a physical port is something like "a
socket for a networking cable on the outside of the device". With your
code I can "provision" a phymod and there is no whole to plug in a
cable. If we follow the same logic, if I have a server with PCIe
hotplug, why can't I "provision" some netdevs for a NIC that I will
plug in later?

> Plus, I'm not really sure that our hw can report the type, will check.

I think that's key.

> One way or another, I think that both configuration flows have valid
> usecase. Some user may want pre-configuration, some user may want auto.
> Btw, it is possible to implement splitter cable in auto mode as well.

Auto as in iterate over possible configs until link up? That's nasty.

> >> >If the device really needs this configuration / can't detect things
> >> >automatically, then we gotta do something like what you have.
> >> >The only question is do we still want to call it a line card.
> >> >Sounds more like a front panel module. At Netronome we called 
> >> >those phymods.    
> >> 
> >> Sure, the name is up to the discussion. We call it "linecard"
> >> internally. I don't care about the name.  
> >
> >Yeah, let's call it something more appropriate to indicate its
> >breakout/retimer/gearbox nature, and we'll be good :)  
> 
> Well, it can contain much more. It can contain a smartnic/fpga/whatever
> for example. Not sure we can find something that fits to all cases.
> I was thinking about it in the past, I think that the linecard is quite
> appropriate. It connects with lines/lanes, and it does something,
> either phy/gearbox, or just interconnects the lanes using smartnic/fpga
> for example.

If it has a FPGA / NPU in it, it's definitely auto-discoverable. 
I don't understand why you think that it's okay to "provision" NICs
which aren't there but only for this particular use case.
