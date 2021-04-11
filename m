Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601FE35B69A
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 20:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhDKSkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 14:40:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44454 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235559AbhDKSkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 14:40:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lVezI-00G7pZ-G6; Sun, 11 Apr 2021 20:39:12 +0200
Date:   Sun, 11 Apr 2021 20:39:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <YHNCUDJrz7ISiLVT@lunn.ch>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
 <20210411200135.35fb5985@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210411200135.35fb5985@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 08:01:35PM +0200, Marek Behun wrote:
> On Sat, 10 Apr 2021 15:34:46 +0200
> Ansuel Smith <ansuelsmth@gmail.com> wrote:
> 
> > Hi,
> > this is a respin of the Marek series in hope that this time we can
> > finally make some progress with dsa supporting multi-cpu port.
> > 
> > This implementation is similar to the Marek series but with some tweaks.
> > This adds support for multiple-cpu port but leave the driver the
> > decision of the type of logic to use about assigning a CPU port to the
> > various port. The driver can also provide no preference and the CPU port
> > is decided using a round-robin way.
> 
> In the last couple of months I have been giving some thought to this
> problem, and came up with one important thing: if there are multiple
> upstream ports, it would make a lot of sense to dynamically reallocate
> them to each user port, based on which user port is actually used, and
> at what speed.
> 
> For example on Turris Omnia we have 2 CPU ports and 5 user ports. All
> ports support at most 1 Gbps. Round-robin would assign:
>   CPU port 0 - Port 0
>   CPU port 1 - Port 1
>   CPU port 0 - Port 2
>   CPU port 1 - Port 3
>   CPU port 0 - Port 4
> 
> Now suppose that the user plugs ethernet cables only into ports 0 and 2,
> with 1, 3 and 4 free:
>   CPU port 0 - Port 0 (plugged)
>   CPU port 1 - Port 1 (free)
>   CPU port 0 - Port 2 (plugged)
>   CPU port 1 - Port 3 (free)
>   CPU port 0 - Port 4 (free)
> 
> We end up in a situation where ports 0 and 2 share 1 Gbps bandwidth to
> CPU, and the second CPU port is not used at all.
> 
> A mechanism for automatic reassignment of CPU ports would be ideal here.

One thing you need to watch out for here source MAC addresses. I've
not looked at the details, so this is more a heads up, it needs to be
thought about.

DSA slaves get there MAC address from the master interface. For a
single CPU port, all the slaves have the same MAC address. What
happens when you have multiple CPU ports? Does the slave interface get
the MAC address from its CPU port? What happens when a slave moves
from one CPU interface to another CPU interface? Does its MAC address
change. ARP is going to be unhappy for a while? Also, how is the
switch deciding on which CPU port to use? Some switches are probably
learning the MAC address being used by the interface and doing
forwarding based on that. So you might need unique slave MAC
addresses, and when a slave moves, it takes it MAC address with it,
and you hope the switch learns about the move. But considered trapped
frames as opposed to forwarded frames. So BPDU, IGMP, etc. Generally,
you only have the choice to send such trapped frames to one CPU
port. So potentially, such frames are going to ingress on the wrong
port. Does this matter? What about multicast? How do you control what
port that ingresses on? What about RX filters on the master
interfaces? Could it be we added it to the wrong master?

For this series to make progress, we need to know what has been
tested, and if all the more complex functionality works, not just
basic pings.

      Andrew
