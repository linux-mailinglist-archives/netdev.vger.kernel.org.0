Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D08935D368
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 00:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343843AbhDLWr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 18:47:27 -0400
Received: from mail.nic.cz ([217.31.204.67]:56968 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239204AbhDLWr1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 18:47:27 -0400
Received: from thinkpad (unknown [IPv6:2a0e:b107:ae1:0:3e97:eff:fe61:c680])
        by mail.nic.cz (Postfix) with ESMTPSA id 5CABE140679;
        Tue, 13 Apr 2021 00:47:07 +0200 (CEST)
Date:   Tue, 13 Apr 2021 00:47:06 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        zhang kai <zhangkaiheb@126.com>,
        Weilong Chen <chenweilong@huawei.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Di Zhu <zhudi21@huawei.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20210413004706.6413d615@thinkpad>
In-Reply-To: <20210412221721.3gszur3hbrkhe76m@skbuf>
References: <20210410133454.4768-1-ansuelsmth@gmail.com>
        <20210411200135.35fb5985@thinkpad>
        <20210411185017.3xf7kxzzq2vefpwu@skbuf>
        <20210412150045.929508-1-dqfext@gmail.com>
        <20210412163211.jrqtwwz2f7ftyli6@skbuf>
        <20210413000457.61050ea3@thinkpad>
        <20210412221721.3gszur3hbrkhe76m@skbuf>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-100.0 required=5.9 tests=SHORTCIRCUIT,
        USER_IN_WELCOMELIST,USER_IN_WHITELIST shortcircuit=ham
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 01:17:21 +0300
Vladimir Oltean <olteanv@gmail.com> wrote:

> On Tue, Apr 13, 2021 at 12:04:57AM +0200, Marek Behun wrote:
> > On Mon, 12 Apr 2021 19:32:11 +0300
> > Vladimir Oltean <olteanv@gmail.com> wrote:
> >  
> > > On Mon, Apr 12, 2021 at 11:00:45PM +0800, DENG Qingfang wrote:  
> > > > On Sun, Apr 11, 2021 at 09:50:17PM +0300, Vladimir Oltean wrote:  
> > > > >
> > > > > So I'd be tempted to say 'tough luck' if all your ports are not up, and
> > > > > the ones that are are assigned statically to the same CPU port. It's a
> > > > > compromise between flexibility and simplicity, and I would go for
> > > > > simplicity here. That's the most you can achieve with static assignment,
> > > > > just put the CPU ports in a LAG if you want better dynamic load balancing
> > > > > (for details read on below).
> > > > >  
> > > >
> > > > Many switches such as mv88e6xxx only support MAC DA/SA load balancing,
> > > > which make it not ideal in router application (Router WAN <--> ISP BRAS
> > > > traffic will always have the same DA/SA and thus use only one port).  
> > >
> > > Is this supposed to make a difference? Choose a better switch vendor!  
> >
> > :-) Are you saying that we shall abandon trying to make the DSA
> > subsystem work with better performace for our routers, in order to
> > punish ourselves for our bad decision to use Marvell switches?  
> 
> No, not at all, I just don't understand what is the point you and
> Qingfang are trying to make.

I am not trying to make a point for this patch series. I did not touch
it since the last time I sent it. Ansuel just took over this series and
I am just contributing my thoughts to the RFC :)

I agree with you that this patch series still needs a lot of work.

> LAG is useful in general for load balancing.
> With the particular case of point-to-point links with Marvell Linkstreet,
> not so much. Okay. With a different workload, maybe it is useful with
> Marvell Linkstreet too. Again okay. Same for static assignment,
> sometimes it is what is needed and sometimes it just isn't.
> It was proposed that you write up a user space program that picks the
> CPU port assignment based on your favorite metric and just tells DSA to
> reconfigure itself, either using a custom fancy static assignment based
> on traffic rate (read MIB counters every minute) or simply based on LAG.
> All the data laid out so far would indicate that this would give you the
> flexibility you need, however you didn't leave any comment on that,
> either acknowledging or explaining why it wouldn't be what you want.

Yes, you are right. A custom userspace utility for assigning CPU ports
would be better here than adding lots of complication into the kernel
abstraction.
