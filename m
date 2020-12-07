Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083AF2D1D7F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 23:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728032AbgLGWio (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 17:38:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbgLGWio (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 17:38:44 -0500
Message-ID: <9a224bc0ae7853178f2db7e2c1abe94500032018.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607380683;
        bh=uQu2GXYTBm90vG9wxg3tl/ZjwTerCKY5alr6hiEup4o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kETtHEx6rH1Nu/8tLKusIF6RIF2tkDZe5QXQ2p71noP16EowHvtIcO/WmvcLmUMV5
         UinhSNY7N+PfCZ452p2BlZTiTrWarr5O5FbMx6hORiD7PAhsf0DXxjncqaCkINYiM9
         nPsoKtqew6ESyfUz/9EReK0a1ts+D5xET25EqzW3UUrSJp6gFkPpnQOLKoXHKrcQYr
         Hk6hhU0aNXD4r+KwVcSNexnPTh9HRpUu5y5XsZZWT3btsB0BhgmhXZo6qcgZ3n1oXL
         xArZKs7WBb+q2oPStJZi8Mq0fAhqmV8Y5SKV/UhYVkx7DZ3Wq+FwZR09opklyuvmif
         SEo9U70J3C38Q==
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
From:   Saeed Mahameed <saeed@kernel.org>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Date:   Mon, 07 Dec 2020 14:38:01 -0800
In-Reply-To: <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
         <20201204102901.109709-2-marekx.majtyka@intel.com> <878sad933c.fsf@toke.dk>
         <20201204124618.GA23696@ranger.igk.intel.com>
         <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
         <20201207135433.41172202@carbon>
         <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-07 at 12:52 -0800, John Fastabend wrote:
> Jesper Dangaard Brouer wrote:
> > On Fri, 4 Dec 2020 16:21:08 +0100
> > Daniel Borkmann <daniel@iogearbox.net> wrote:
> > 
> > > On 12/4/20 1:46 PM, Maciej Fijalkowski wrote:
> > > > On Fri, Dec 04, 2020 at 01:18:31PM +0100, Toke Høiland-
> > > > Jørgensen wrote:  
> > > > > alardam@gmail.com writes:  
> > > > > > From: Marek Majtyka <marekx.majtyka@intel.com>
> > > > > > 
> > > > > > Implement support for checking what kind of xdp
> > > > > > functionality a netdev
> > > > > > supports. Previously, there was no way to do this other
> > > > > > than to try
> > > > > > to create an AF_XDP socket on the interface or load an XDP
> > > > > > program and see
> > > > > > if it worked. This commit changes this by adding a new
> > > > > > variable which
> > > > > > describes all xdp supported functions on pretty detailed
> > > > > > level:  
> > > > > 
> > > > > I like the direction this is going! :)
> > 
> > (Me too, don't get discouraged by our nitpicking, keep working on
> > this! :-))
> > 
> > > > >  
> > > > > >   - aborted
> > > > > >   - drop
> > > > > >   - pass
> > > > > >   - tx  
> > > 
> > > I strongly think we should _not_ merge any native XDP driver
> > > patchset
> > > that does not support/implement the above return codes. 
> > 
> > I agree, with above statement.
> > 
> > > Could we instead group them together and call this something like
> > > XDP_BASE functionality to not give a wrong impression?
> > 
> > I disagree.  I can accept that XDP_BASE include aborted+drop+pass.
> > 
XDP_BASE is a weird name i vote:  
XDP_FLAG_RX,
XDP_FLAG_TX,
XDP_FLAG_REDIRECT,
XDP_FLAG_AF_XDP,
XDP_FLAG_AFXDP_ZC

> > I think we need to keep XDP_TX action separate, because I think
> > that
> > there are use-cases where the we want to disable XDP_TX due to end-
> > user
> > policy or hardware limitations.
> 
> How about we discover this at load time though. Meaning if the
> program
> doesn't use XDP_TX then the hardware can skip resource allocations
> for
> it. I think we could have verifier or extra pass discover the use of
> XDP_TX and then pass a bit down to driver to enable/disable TX caps.
> 

+1, how about we also attach some attributes to the program that would
tell the kernel/driver how to prepare configure itself for the new
program ?

Attributes like how much headroom the program needs, what meta data
driver must provide, should the driver do csum on tx, etc .. 

some attribute can be extracted from the byte code/logic others are
stated explicitly in some predefined section in the XDP prog itself.

On a second thought, this could be disruptive, users will eventually
want to replace XDP progs, and they might want a persistent config
prior to loading/reloading any prog to avoid reconfigs (packet drops)
between progs.

> > Use-case(1): Cloud-provider want to give customers (running VMs)
> > ability
> > to load XDP program for DDoS protection (only), but don't want to
> > allow
> > customer to use XDP_TX (that can implement LB or cheat their VM
> > isolation policy).
> 
> Not following. What interface do they want to allow loading on? If
> its
> the VM interface then I don't see how it matters. From outside the
> VM there should be no way to discover if its done in VM or in tc or
> some other stack.
> 
> If its doing some onloading/offloading I would assume they need to
> ensure the isolation, etc. is still maintained because you can't
> let one VMs program work on other VMs packets safely.
> 
> So what did I miss, above doesn't make sense to me.
> 
> > Use-case(2): Disable XDP_TX on a driver to save hardware TX-queue
> > resources, as the use-case is only DDoS.  Today we have this
> > problem
> > with the ixgbe hardware, that cannot load XDP programs on systems
> > with
> > more than 192 CPUs.
> 
> The ixgbe issues is just a bug or missing-feature in my opinion.
> 
> I think we just document that XDP_TX consumes resources and if users
> care they shouldn't use XD_TX in programs and in that case hardware
> should via program discovery not allocate the resource. This seems
> cleaner in my opinion then more bits for features.
> 
> > 
> > > If this is properly documented that these are basic must-have
> > > _requirements_, then users and driver developers both know what
> > > the
> > > expectations are.
> > 
> > We can still document that XDP_TX is a must-have requirement, when
> > a
> > driver implements XDP.
> 
> +1
> 

Ho about xdp redirect ? 
do we still need to load a no-op program on the egress netdev so it
would allocate the xdp tx/redirect queues ? 

Adding the above discovery feature will break xdp redirect native mode
and will require to have a special flag for xdp_redirect, so it
actually makes more sense to have a unique knob to turn on XDP tx, for
the redirect use case.





