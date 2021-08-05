Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F943E1C34
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 21:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242435AbhHETMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 15:12:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:51540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242387AbhHETMT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 15:12:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A91A461078;
        Thu,  5 Aug 2021 19:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628190724;
        bh=o0VwOFsvUwEaZiHlwNBNlDuhwACz69ebYo9Gt89iPwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fuAsSYJ2Gfs7DmYaxoD1v92H7+JSU+RjKbI869FOuAaDZr+gxAmUHYHqtdi/eMKPj
         q+kRSUPMvk6/HDofECo2ofQVIlRhzvCwR7utH3QfOaU5ROL6nF0mcnRRY8HK5BEeRK
         C98fayl5Klev9lhy/9DIYrAD2mOdBYVuFwNGnmOvfTVzk8LrQkMCK0bS81euClv7A1
         9GQSGyWuHuXw5o3cKbW9FvxoGrHo+hMhO1rbcXMwTL17HaaagXI921Nb4nQUjczZjJ
         vKKrCs3NfAVbXFkY1zwhRhVo+7TE0N3u22IQXuHsk8tCBLb5QRsr3IMCds7bbF4vpF
         zc/NWNxM3KR+w==
Date:   Thu, 5 Aug 2021 12:12:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] netdevsim: Forbid devlink reload when
 adding or deleting ports
Message-ID: <20210805121203.1ac615d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YQwnr/qel0oktItP@unreal>
References: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
        <20210805061547.3e0869ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YQvs4wRIIEDG6Dcu@unreal>
        <20210805072342.17faf851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YQv2v5cTqLvoPc4n@unreal>
        <20210805082756.0b4e61d7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YQwhf+3oeqOv/OMU@unreal>
        <YQwnr/qel0oktItP@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Aug 2021 21:02:23 +0300 Leon Romanovsky wrote:
> > > As it should, given add/delete ports takes the port_list_lock which is
> > > destroyed by down but not (due to the forced failure) re-initialized by
> > > up.
> > > 
> > > If we want to handle adding ports while down we can just bump port
> > > count and return, although I don't think there's a practical need
> > > to support that.  
> > 
> > Sorry, but for me netdevsim looks like complete dumpster. 

I worry that netdevsim's gone unwieldy as a reflection of the quality of
the devlink APIs that got added, not by itself :/

> > It was intended for fast prototyping, but ended to be huge pile of
> > debugfs entries and selftest to execute random flows.

It's for selftests, IDK what fast prototyping is in terms of driver
APIs. Fast prototyping makes me think of the "it works" attitude which
is not sufficiently high bar for core APIs IMO, I'm sure you'll agree.

netdevsim was written specifically to be able to exercise HW APIs which
are implemented by small fraction of drivers. Especially offload APIs
as those can easily be broken by people changing the SW implementation
without capable HW at hand.

BTW I wonder if there is a term in human science of situation like when
a recent contributor tells the guy who wrote the code what the code was
intended for :)

> > Do you want me to move in_reload = false line to be after if (nsim_dev->fail_reload)
> > check?  
> 
> BTW, the current implementation where in_reload before if, actually
> preserves same behaviour as was with devlink_reload_enable() implementation.

Right, but I think as you rightly pointed out the current protection
of reload is broken. I'm not saying you must make it perfect or else..
just pointing out a gap you could address if you so choose.
