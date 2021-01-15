Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0AD02F855F
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731525AbhAOT07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:26:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727049AbhAOT06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 14:26:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03701235F8;
        Fri, 15 Jan 2021 19:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610738778;
        bh=H5G8eGoBoAb87BIVNQjIxm7imUUOeFnLnGVrmVtyAdQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NP8k+Xt+KslGyCVm+KjP8tZ+YRSFojorkgTFAptqTiDfmlV4ZNJ6+MQRVN8TzPuQt
         +U1ksiyyDtRvJtAbrn/9PWi5SyATLJ9or/fm00tGurrq+zE5uHWTGtnNfHFyK3Y8L1
         YAxLH8+A4dblscFCqxwwYh90WBWVagNcivlW8I3m7YyZhVUFGaP1DN8j0Oo31JYW5J
         26Yc9OOwLzTeDFrT2uETMkwX+9Dq1lcCnPrlbbGgCNKjY/gWCRrumdDhlSzN/WLyYt
         VscIpPgLwvxRReLw67p77SrS+j0TfwfuYbm19e5QsyMDET8GBPITvcq0MpK0XgtdlU
         hu5slZlulCOog==
Date:   Fri, 15 Jan 2021 11:26:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jacob.e.keller@intel.com, roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
Message-ID: <20210115112617.064deda8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210115143906.GM3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.us>
        <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210114074804.GK3565223@nanopsycho.orion>
        <20210114153013.2ce357b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210115143906.GM3565223@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jan 2021 15:39:06 +0100 Jiri Pirko wrote:
> >I'm not a SFP experts so maybe someone will correct me but AFAIU
> >the QSFP (for optics) is the same regardless of breakout. It's the
> >passive optical strands that are either bundled or not. So there is 
> >no way for the system to detect the cable type (AFAIK).  
> 
> For SFP module, you are able to detect those.

Not sure you understand what I'm saying. Maybe you're thinking about
DACs? This is a optical cable for breakout:

https://www.fs.com/products/68048.html

There is no electronics in it to "detect" things AFAIU. Same QSFP can
be used with this cable or a non-breakout.

> >Or to put it differently IMO the netdev should be provisioned if the
> >system has a port into which user can plug in a cable. When there is   
> 
> Not really. For slit cables, the ports are provisioned not matter which
> cable is connected, slitter 1->2/1->4 or 1->1 cable.
> 
> 
> >a line card-sized hole in the chassis, I'd be surprised to see ports.
> >
> >That said I never worked with real world routers so maybe that's what
> >they do. Maybe some with a Cisco router in the basement can tell us? :)  
> 
> The need for provision/pre-configure splitter/linecard is that the
> ports/netdevices do not disapper/reappear when you replace
> splitter/linecard. Consider a faulty linecard with one port burned. You
> just want to replace it with new one. And in that case, you really don't
> want kernel to remove netdevices and possibly mess up routing for
> example.

Having a single burned port sounds like a relatively rare scenario.
Reconfiguring routing is not the end of the world.

> >If the device really needs this configuration / can't detect things
> >automatically, then we gotta do something like what you have.
> >The only question is do we still want to call it a line card.
> >Sounds more like a front panel module. At Netronome we called 
> >those phymods.  
> 
> Sure, the name is up to the discussion. We call it "linecard"
> internally. I don't care about the name.

Yeah, let's call it something more appropriate to indicate its
breakout/retimer/gearbox nature, and we'll be good :)
