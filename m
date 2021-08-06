Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8EB3E2963
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245426AbhHFLUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235696AbhHFLUD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 07:20:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DBBC60EE8;
        Fri,  6 Aug 2021 11:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628248788;
        bh=hhbTJLJjQ/XJmlYN/Y7+JON3AAoCl+8L7bebfuu4Sc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YSXXUGYIXIT46BxK5a7sF9zmGFgCIp8Jmcqab4ELtwOZOLo5ojmcciJITeQHGU4yj
         RNxpD3xC4L4xeL6IKrYnZ673Jh4vf/y1B4T/eQZDoyDMS8K+YTUkVrCSI9Uz1RiAlk
         x+E7s4JE7V2LWNHGc2kATnV3A7Bf84VcaRl8AtBoPuE1y7QhNWaRFF2vWCh5ozwV3b
         SGfqi6koiGiJfGHw6rhDJfY/oMXdCvg1D721orUQzcIacDwk1zlvhyneEllRVnhdj/
         FcvERG0yDjmY83u3f9PonbNcul1ya070VgPyGK9y5FMqiyFdQEtbmYEiQ7X27a67PH
         yKB9wVe+rcDnw==
Date:   Fri, 6 Aug 2021 14:19:43 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] netdevsim: Forbid devlink reload when adding
 or deleting ports
Message-ID: <YQ0az49ARwITkbHW@unreal>
References: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
 <20210805061547.3e0869ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQvs4wRIIEDG6Dcu@unreal>
 <20210805072342.17faf851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQv2v5cTqLvoPc4n@unreal>
 <20210805082756.0b4e61d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQwhf+3oeqOv/OMU@unreal>
 <YQwnr/qel0oktItP@unreal>
 <20210805121203.1ac615d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805121203.1ac615d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 12:12:03PM -0700, Jakub Kicinski wrote:
> On Thu, 5 Aug 2021 21:02:23 +0300 Leon Romanovsky wrote:
> > > > As it should, given add/delete ports takes the port_list_lock which is
> > > > destroyed by down but not (due to the forced failure) re-initialized by
> > > > up.
> > > > 
> > > > If we want to handle adding ports while down we can just bump port
> > > > count and return, although I don't think there's a practical need
> > > > to support that.  
> > > 
> > > Sorry, but for me netdevsim looks like complete dumpster. 
> 
> I worry that netdevsim's gone unwieldy as a reflection of the quality of
> the devlink APIs that got added, not by itself :/
> 
> > > It was intended for fast prototyping, but ended to be huge pile of
> > > debugfs entries and selftest to execute random flows.
> 
> It's for selftests, IDK what fast prototyping is in terms of driver
> APIs. Fast prototyping makes me think of the "it works" attitude which
> is not sufficiently high bar for core APIs IMO, I'm sure you'll agree.
> 
> netdevsim was written specifically to be able to exercise HW APIs which
> are implemented by small fraction of drivers. Especially offload APIs
> as those can easily be broken by people changing the SW implementation
> without capable HW at hand.
> 
> BTW I wonder if there is a term in human science of situation like when
> a recent contributor tells the guy who wrote the code what the code was
> intended for :)

"Teaching grandmother to suck eggs" ? :)

> 
> > > Do you want me to move in_reload = false line to be after if (nsim_dev->fail_reload)
> > > check?  
> > 
> > BTW, the current implementation where in_reload before if, actually
> > preserves same behaviour as was with devlink_reload_enable() implementation.
> 
> Right, but I think as you rightly pointed out the current protection
> of reload is broken. I'm not saying you must make it perfect or else..
> just pointing out a gap you could address if you so choose.

I don't know, netdevsim needs some dedicated cleanup.

Thanks
