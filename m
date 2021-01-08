Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6390E2EF815
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 20:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728869AbhAHT0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 14:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:38516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727974AbhAHT0V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Jan 2021 14:26:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE0AD23A9F;
        Fri,  8 Jan 2021 19:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610133940;
        bh=55Y56FCmCII6MsIgGjsXJcerySadO0Nnrz07Agyk6ZE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mNkq8m72co4MEhyUmFAT1+lRjLeeM95/WcBlU8LP0SEvTTTf6Opx1p6dO8t0lyURk
         VUm4GT7uRGg/K5Foz0bZG7xCiDpkNLyEiPbIiK3A3VDY9phUjU7JGbtGjzRvsI+bkV
         Zr2bPQoZAO2WtMDPh8ID1ILDoOy9hiJTgSQarR2/lb4LwFwNNurctdRi4Jw4qy6gyC
         8KIF0cFmxDfzHasEndUEXyhc8Y5ADJlkSLEhL2jtbCa5t3snlKsQ3RAjzwt6CSbsMK
         HFt0ugAFFbN3TAQAfUX47gccFHSwxt/+m1EU/yO1cFzUVloALoVpTR8tYNU/frcqz6
         0lh+c0kYFHqXA==
Message-ID: <281b9e63da008c89629bd2066f8597d3d437296a.camel@kernel.org>
Subject: Re: [PATCH v3 net-next 10/12] net: bonding: ensure .ndo_get_stats64
 can sleep
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
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
        Jiri Pirko <jiri@mellanox.com>,
        Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Date:   Fri, 08 Jan 2021 11:25:38 -0800
In-Reply-To: <20210108085758.yvokxncj3twrsxko@skbuf>
References: <20210107094951.1772183-1-olteanv@gmail.com>
         <20210107094951.1772183-11-olteanv@gmail.com>
         <CANn89i+NfBw7ZpL-DTDA3QGBK=neT2R7qKYn_pcvDmRAOkaUsQ@mail.gmail.com>
         <20210107113313.q4e42cj6jigmdmbs@skbuf>
         <CANn89iJ_qbo6dP3YqXCeDPfopjBFZ8h6JxbpufVBGUpsG=D7+Q@mail.gmail.com>
         <ac66e1838894f96d2bb460b7969b6c9b903fee6a.camel@kernel.org>
         <20210108085758.yvokxncj3twrsxko@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-01-08 at 10:57 +0200, Vladimir Oltean wrote:
> On Thu, Jan 07, 2021 at 07:59:37PM -0800, Saeed Mahameed wrote:
> > On Thu, 2021-01-07 at 13:58 +0100, Eric Dumazet wrote:
> > > On Thu, Jan 7, 2021 at 12:33 PM Vladimir Oltean <
> > > olteanv@gmail.com>
> > > wrote:

...

> > > 
> > > > There is an effort initiated by Jakub to standardize the
> > > > ethtool
> > > > statistics. My objection was that you can't expect that to
> > > > happen
> > > > unless
> > > > dev_get_stats is sleepable just like ethtool -S is. So I think
> > > > the
> > > > same
> > > > reasoning should apply to ethtool -S too, really.
> > > 
> > > I think we all agree on the principles, once we make sure to not
> > > add more pressure on RTNL. It seems you addressed our feedback,
> > > all
> > > is fine.
> > > 
> > 
> > Eric, about two years ago you were totally against sleeping in
> > ndo_get_stats, what happened ? :)
> > https://lore.kernel.org/netdev/4cc44e85-cb5e-502c-30f3-c6ea564fe9ac@gmail.com/
> 
> I believe that what is different this time is that DSA switches are
> typically connected over a slow and bottlenecked bus (so periodic
> driver-level readouts would only make things worse for phc2sys and
> such other latency-sensitive programs), plus they are offloading
> interfaces for forwarding (so software-based counters could never be
> accurate). Support those, and supporting firmware-based high-speed
> devices will come as a nice side-effect.
> FWIW that discussion took place here:
> https://patchwork.ozlabs.org/project/netdev/patch/20201125193740.36825-3-george.mccollister@gmail.com/
> 

I understand the motivation and I agree with the concept, 
hence my patchset :)

> > My approach to solve this was much simpler and didn't require  a
> > new
> > mutex nor RTNL lock, all i did is to reduce the rcu critical
> > section to
> > not include the call to the driver by simply holding the netdev via
> > dev_hold()
> 
> I feel this is a call for the bonding maintainers to make. If they're
> willing to replace rtnl_dereference with bond_dereference throughout
> the
> whole driver, and reduce other guys' amount of work when other NDOs
> start losing the rtnl_mutex too, then I can't see what's wrong with
> my
> approach (despite not being "as simple"). If they think that update-
> side
> protection of the slaves array is just fine the way it is, then I
> suppose that RCU protection + dev_hold is indeed all that I can do.

To be honest i haven't really looked at your patches, I just quickly
went through them to get an idea of what you did, but let me take a
more careful look and will give my ultimate feedback.


