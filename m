Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89BBE2F3D6F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405457AbhALVgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:36:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436695AbhALULV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:11:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8106022B4B;
        Tue, 12 Jan 2021 20:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610482241;
        bh=ZTt+6woZSonBj4+dQImSe3XHLhl9qf3tp0jA5qezGhQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SpWkND1pPV6dgizIJoCrMV4DPz5VVyBR7uM5ztL1EyRDEiI7c3jvxkwmxAv+vPlTc
         BFEbc0p5m+YYqWJ2Mql+7Ky7rLDTqXC+qBBPoHhrhriXR1Mpn1D/jLbk2tK2IDFPkt
         lNu4bYnIiuf1MZn1pZJZRJsc2v/2YkJr8CBi9QDVOcwq/05lzP3UHKbHvTXqSPcNbl
         zXuZBLn32C16rRU+uKYLrUOy1g2g4Iey4ly4PMh34P0UTfE2KKvP84cqpnLLy4akkU
         7SUr4SfwT0vkfgeptSXdLjRtrIEmYIHLvdwbOaxb0HerOEyuTzlhx5M8Q2CLvGaWG7
         /S8lP4tmgvoOg==
Message-ID: <4c4c08e37aeff87f0dd2ea52037c32d07d2868d1.camel@kernel.org>
Subject: Re: [PATCH v6 net-next 14/15] net: bonding: ensure .ndo_get_stats64
 can sleep
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Date:   Tue, 12 Jan 2021 12:10:38 -0800
In-Reply-To: <20210112143710.nxpxnlcojhvqipw7@skbuf>
References: <20210109172624.2028156-1-olteanv@gmail.com>
         <20210109172624.2028156-15-olteanv@gmail.com>
         <cbead0479ef0b601bada5ae2ad0f8c28e5b242c9.camel@kernel.org>
         <20210112143710.nxpxnlcojhvqipw7@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-12 at 16:37 +0200, Vladimir Oltean wrote:
> On Mon, Jan 11, 2021 at 03:38:49PM -0800, Saeed Mahameed wrote:
> > GFP_ATOMIC is a little bit aggressive especially when user daemons
> > are
> > periodically reading stats. This can be avoided.
> > 
> > You can pre-allocate with GFP_KERNEL an array with an "approximate"
> > size.
> > then fill the array up with whatever slaves the the bond has at
> > that
> > moment, num_of_slaves  can be less, equal or more than the array
> > you
> > just allocated but we shouldn't care ..
> > 
> > something like:
> > rcu_read_lock()
> > nslaves = bond_get_num_slaves();
> > rcu_read_unlock()
> > sarray = kcalloc(nslaves, sizeof(struct bonding_slave_dev),
> > GFP_KERNEL);
> > rcu_read_lock();
> > bond_fill_slaves_array(bond, sarray); // also do: dev_hold()
> > rcu_read_unlock();
> > 
> > 
> > bond_get_slaves_array_stats(sarray);
> > 
> > bond_put_slaves_array(sarray);
> 
> I don't know what to say about acquiring RCU read lock twice and
> traversing the list of interfaces three or four times.

You can optimize this by tracking #num_slaves.

> On the other hand, what's the worst that can happen if the GFP_ATOMIC
> memory allocation fails. It's not like there is any data loss.
> User space will retry when there is less memory pressure.

Anyway Up to you, i just don't like it when we use GFP_ATOMIC when it
can be avoided, especially for periodic jobs, like stats polling.. 

