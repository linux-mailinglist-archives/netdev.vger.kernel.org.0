Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012DC2D3F7D
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 11:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbgLIKEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 05:04:34 -0500
Received: from mga06.intel.com ([134.134.136.31]:61390 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729095AbgLIKEZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 05:04:25 -0500
IronPort-SDR: h7vpWAFR3atm6+Q1mA3cr6vgPO9BF2vdvIKuZ2u13ij6PdzDPBEQlzWq/GNJL2DXpzham3C+Qp
 HQ+WQtJSgj6w==
X-IronPort-AV: E=McAfee;i="6000,8403,9829"; a="235650006"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="235650006"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 02:03:43 -0800
IronPort-SDR: d8an/rdxe67D+HZW5JB918O5qeQZfAy5xaguhK5JjfA7LKIbQSqzf/A3iXUOOZUl4K6r/mWRNk
 b9IGTnoSyejw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="376290545"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by FMSMGA003.fm.intel.com with ESMTP; 09 Dec 2020 02:03:38 -0800
Date:   Wed, 9 Dec 2020 10:54:54 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        alardam@gmail.com, magnus.karlsson@intel.com,
        bjorn.topel@intel.com, andrii.nakryiko@gmail.com, kuba@kernel.org,
        ast@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        hawk@kernel.org, jonathan.lemon@gmail.com, bpf@vger.kernel.org,
        jeffrey.t.kirsher@intel.com, maciejromanfijalkowski@gmail.com,
        intel-wired-lan@lists.osuosl.org,
        Marek Majtyka <marekx.majtyka@intel.com>
Subject: Re: [PATCH v2 bpf 1/5] net: ethtool: add xdp properties flag set
Message-ID: <20201209095454.GA36812@ranger.igk.intel.com>
References: <20201204102901.109709-1-marekx.majtyka@intel.com>
 <20201204102901.109709-2-marekx.majtyka@intel.com>
 <878sad933c.fsf@toke.dk>
 <20201204124618.GA23696@ranger.igk.intel.com>
 <048bd986-2e05-ee5b-2c03-cd8c473f6636@iogearbox.net>
 <20201207135433.41172202@carbon>
 <5fce960682c41_5a96208e4@john-XPS-13-9370.notmuch>
 <20201207230755.GB27205@ranger.igk.intel.com>
 <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fd068c75b92d_50ce20814@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 08, 2020 at 10:03:51PM -0800, John Fastabend wrote:
> > On Mon, Dec 07, 2020 at 12:52:22PM -0800, John Fastabend wrote:
> > > Jesper Dangaard Brouer wrote:
> > > > On Fri, 4 Dec 2020 16:21:08 +0100
> > > > Daniel Borkmann <daniel@iogearbox.net> wrote:
> 
> [...] pruning the thread to answer Jesper.

I think you meant me, but thanks anyway for responding :)

> 
> > > > 
> > > > Use-case(2): Disable XDP_TX on a driver to save hardware TX-queue
> > > > resources, as the use-case is only DDoS.  Today we have this problem
> > > > with the ixgbe hardware, that cannot load XDP programs on systems with
> > > > more than 192 CPUs.
> > > 
> > > The ixgbe issues is just a bug or missing-feature in my opinion.
> > 
> > Not a bug, rather HW limitation?
> 
> Well hardware has some max queue limit. Likely <192 otherwise I would
> have kept doing queue per core on up to 192. But, ideally we should

Data sheet states its 128 Tx qs for ixgbe.

> still load and either share queues across multiple cores or restirct
> down to a subset of CPUs.

And that's the missing piece of logic, I suppose.

> Do you need 192 cores for a 10gbps nic, probably not.

Let's hear from Jesper :p

> Yes, it requires some extra care, but should be doable
> if someone cares enough. I gather current limitation/bug is because
> no one has that configuration and/or has complained loud enough.

I would say we're safe for queue per core approach for newer devices where
we have thousands of queues to play with. Older devices combined with big
cpu count can cause us some problems.

Wondering if drivers could have a problem when user would do something
weird as limiting the queue count to a lower value than cpu count and then
changing the irq affinity?

> 
> > 
> > > 
> > > I think we just document that XDP_TX consumes resources and if users
> > > care they shouldn't use XD_TX in programs and in that case hardware
> > > should via program discovery not allocate the resource. This seems
> > > cleaner in my opinion then more bits for features.
> > 
> > But what if I'm with some limited HW that actually has a support for XDP
> > and I would like to utilize XDP_TX?
> > 
> > Not all drivers that support XDP consume Tx resources. Recently igb got
> > support and it shares Tx queues between netstack and XDP.
> 
> Makes sense to me.
> 
> > 
> > I feel like we should have a sort-of best effort approach in case we
> > stumble upon the XDP_TX in prog being loaded and query the driver if it
> > would be able to provide the Tx resources on the current system, given
> > that normally we tend to have a queue per core.
> 
> Why do we need to query? I guess you want some indication from the
> driver its not going to be running in the ideal NIC configuraition?
> I guess printing a warning would be the normal way to show that. But,
> maybe your point is you want something easier to query?

I meant that given Jesper's example, what should we do? You don't have Tx
resources to pull at all. Should we have a data path for that case that
would share Tx qs between XDP/netstack? Probably not.

> 
> > 
> > In that case igb would say yes, ixgbe would say no and prog would be
> > rejected.
> 
> I think the driver should load even if it can't meet the queue per
> core quota. Refusing to load at all or just dropping packets on the
> floor is not very friendly. I think we agree on that point.

Agreed on that. But it needs some work. I can dabble on that a bit.
