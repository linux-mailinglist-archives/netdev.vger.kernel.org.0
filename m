Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A3E2F243E
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405479AbhALAZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:37214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404212AbhAKXwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 18:52:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C362522CA2;
        Mon, 11 Jan 2021 23:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610409101;
        bh=ZPYc4GFouwm3fx5C95hfGBzL/wcWXKcGSjaireBf2bc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=m9mwyBiqnBKczqX7DPieHgm1/eAYOnSN+Zrq7xY3nmTmFMkceF4tp+EOjVJ6a55Re
         DUNIAAyFtT0dTImxC2Ivs33Md+xwvxA64Mxwhq1J1VUd3YxFvRwUqZCHRB1FX17/aV
         tXxgAfRbKRBbGVK7wFUTqtAn25D4UEccRMmjYS9c87BogfjNArEzLHZeuqc3Ybd4Hj
         58Qr+btcSa31dSQP8PnMnoCYsXSXH7LKMYcIZxHeyQbDGUJKJtCX47ZSzvejs0OhIK
         rjAhzu2kmTWOi/5Sx8r3gUw8AVV6pnDKnb0h+03mHGda0qQ2pGaj3+DgUWlWWGOFyc
         mwhieA+KpYUTw==
Message-ID: <6a6f5e835255a196f461b0e63a68b9bfa576ca1f.camel@kernel.org>
Subject: Re: [PATCH v6 net-next 11/15] net: catch errors from dev_get_stats
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
Date:   Mon, 11 Jan 2021 15:51:39 -0800
In-Reply-To: <20210111231535.lfkv7ggjzynbiicc@skbuf>
References: <20210109172624.2028156-1-olteanv@gmail.com>
         <20210109172624.2028156-12-olteanv@gmail.com>
         <b517b9a54761a0ee650d6d64712844606cf8a631.camel@kernel.org>
         <20210111231535.lfkv7ggjzynbiicc@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-01-12 at 01:15 +0200, Vladimir Oltean wrote:
> On Mon, Jan 11, 2021 at 02:54:50PM -0800, Saeed Mahameed wrote:
> > On Sat, 2021-01-09 at 19:26 +0200, Vladimir Oltean wrote:
> > > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > 
> > > dev_get_stats can now return error codes. Convert all remaining
> > > call
> > > sites to look at that error code and stop processing.
> > > 
> > > The effects of simulating a kernel error (returning -ENOMEM) upon
> > > existing programs or kernel interfaces:
> > > 
> > > - ifconfig and "cat /proc/net/dev" print up until the interface
> > > that
> > >   failed, and there they return:
> > > cat: read error: Cannot allocate memory
> > > 
> > > - ifstat and "ip -s -s link show":
> > > RTNETLINK answers: Cannot allocate memory
> > > Dump terminated
> > > 
> > > Some call sites are coming from a context that returns void
> > > (ethtool
> > > stats, workqueue context). So since we can't report to the upper
> > > layer,
> > > do the next best thing: print an error to the console.
> > > 
> > 
> > another concern, one buggy netdev driver in a system will cause
> > unnecessary global failures when reading stats via netlink/procfs
> > for
> > all the netdev in a netns, when other drivers will be happy to
> > report.
> > 
> > can't we just show a message in that driver's stats line about the
> > occurred err ? and show the normal stats line of all others ?
> 
> So you're worried that user space apps won't handle an error code
> when
> reading from a file, but you're not worried that they'll start
> scraping
> junk from procfs when we print this?
> 

both are equivalently concerning.
to avoid any user crashes, we can just toss failed netdevs out from the
output.

> cat /proc/net/dev
> Inter-
> |   Receive                                                |  Transmi
> t
>  face |bytes    packets errs drop fifo frame compressed
> multicast|bytes    packets errs drop fifo colls carrier compressed
>     lo:       0       0    0    0    0     0          0         0    
>     0       0    0    0    0     0       0          0
>  bond0: Cannot allocate memory
>  
> sit0:       0       0    0    0    0     0          0         0      
>   0       0    0    0    0     0       0          0

