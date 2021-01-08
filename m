Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5862EEC14
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 05:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbhAHEAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 23:00:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:53466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726113AbhAHEAU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 23:00:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3BA523601;
        Fri,  8 Jan 2021 03:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610078379;
        bh=AjBm+wiy6Poaq9RWrgoy84NTKsQuWmPFOw9gMV7J24c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f2K7GWj/0lt7zuCuBlfwWRXpYyoNGjR22EDONvzbH65KYy/zByIvxGGzz76puTcP9
         PaRTMwpXejbczw1lPDxOXURVt0eb5b+g51IXPatajvJsokqRxxlTydrECcILqNk5DO
         IDlnhlMUVxBtao4aK//zh3VRgcgJ7E+WApxkyDtYKCDmWb689ly3CW/c/1QcG4Ymgf
         l87e0vdoABTQxc9+wZe+PVdO9IFriOdtbtlcdcGHmPZrqYAfSwI4A7uYBHBdVSOEW3
         QaL77SxVReZTHMAsQG1JXQZpIhD8drutxcHLhznehsV29iutRMndx6YrZQG7/Bxr29
         QZ8OCyMdHYkTw==
Message-ID: <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
Subject: Re: [PATCH v3 net-next 10/12] net: bonding: ensure .ndo_get_stats64
 can sleep
From:   Saeed Mahameed <saeed@kernel.org>
To:     Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Date:   Thu, 07 Jan 2021 19:59:37 -0800
In-Reply-To: <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
References: <20210107094951.1772183-1-olteanv@gmail.com>
         <20210107094951.1772183-11-olteanv@gmail.com>
         <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
         <20210107113313.q4e42cj6jigmdmbs@skbuf>
         <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-07 at 13:58 +0100, Eric Dumazet wrote:
> On Thu, Jan 7, 2021 at 12:33 PM Vladimir Oltean <olteanv@gmail.com>
> wrote:
> > On Thu, Jan 07, 2021 at 12:18:28PM +0100, Eric Dumazet wrote:
> > > What a mess really.
> > 
> > Thanks, that's at least _some_ feedback :)
> 
> Yeah, I was on PTO for the last two weeks.
> 
> > > You chose to keep the assumption that ndo_get_stats() would not
> > > fail,
> > > since we were providing the needed storage from callers.
> > > 
> > > If ndo_get_stats() are now allowed to sleep, and presumably
> > > allocate
> > > memory, we need to make sure
> > > we report potential errors back to the user.
> > > 
> > > I think your patch series is mostly good, but I would prefer not
> > > hiding errors and always report them to user space.
> > > And no, netdev_err() is not appropriate, we do not want tools to
> > > look
> > > at syslog to guess something went wrong.
> > 
> > Well, there are only 22 dev_get_stats callers in the kernel, so I
> > assume
> > that after the conversion to return void, I can do another
> > conversion to
> > return int, and then I can convert the ndo_get_stats64 method to
> > return
> > int too. I will keep the plain ndo_get_stats still void (no reason
> > not
> > to).
> > 
> > > Last point about drivers having to go to slow path, talking to
> > > firmware : Make sure that malicious/innocent users
> > > reading /proc/net/dev from many threads in parallel wont brick
> > > these devices.
> > > 
> > > Maybe they implicitly _relied_ on the fact that firmware was
> > > gently
> > > read every second and results were cached from a work queue or
> > > something.
> > 
> > How? I don't understand how I can make sure of that.
> 
> Your patches do not attempt to change these drivers, but I guess your
> cover letter might send to driver maintainers incentive to get rid of
> their
> logic, that is all.
> 
> We might simply warn maintainers and ask them to test their future
> changes
> with tests using 1000 concurrent theads reading /proc/net/dev
> 
> > There is an effort initiated by Jakub to standardize the ethtool
> > statistics. My objection was that you can't expect that to happen
> > unless
> > dev_get_stats is sleepable just like ethtool -S is. So I think the
> > same
> > reasoning should apply to ethtool -S too, really.
> 
> I think we all agree on the principles, once we make sure to not
> add more pressure on RTNL. It seems you addressed our feedback, all
> is fine.
> 

Eric, about two years ago you were totally against sleeping in
ndo_get_stats, what happened ? :) 
https://lore.kernel.org/netdev/4cc44e85-cb5e-502c-30f3-c6ea564fe9ac@gmail.com/

My approach to solve this was much simpler and didn't require  a new
mutex nor RTNL lock, all i did is to reduce the rcu critical section to
not include the call to the driver by simply holding the netdev via
dev_hold()



