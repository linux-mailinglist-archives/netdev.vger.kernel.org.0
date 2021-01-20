Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388302FD5B4
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 17:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404075AbhATQaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 11:30:08 -0500
Received: from mga11.intel.com ([192.55.52.93]:19519 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404066AbhATQ3q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 11:29:46 -0500
IronPort-SDR: RnQSOg7qm9x5xyTAsVlXinh9tPfTEF8mx2ZdSqFDWKih3vOa34zBqYxAsnr2ryh8GYl/XgrRr3
 yQTw+tMyZg0A==
X-IronPort-AV: E=McAfee;i="6000,8403,9870"; a="175630943"
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="175630943"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2021 08:29:00 -0800
IronPort-SDR: xKfFrjJPowG/BWEH2HAPzosNE5Kjf3IqTwhiBLquV5Gb0a/PTTJ0KHL0FH8AQgTs6ONE3CJRtb
 H5xd2tSO1LQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,361,1602572400"; 
   d="scan'208";a="426952824"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 20 Jan 2021 08:28:56 -0800
Date:   Wed, 20 Jan 2021 17:19:31 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Maxim Mikityanskiy <maximmi@nvidia.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, kuba@kernel.org,
        jonathan.lemon@gmail.com, davem@davemloft.net,
        john.fastabend@gmail.com, ciara.loftus@intel.com,
        weqaar.a.janjua@intel.com
Subject: Re: [PATCH bpf-next v2 0/8] Introduce bpf_redirect_xsk() helper
Message-ID: <20210120161931.GA32916@ranger.igk.intel.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <7dcee85b-b3ef-947f-f433-03ad7066c5dd@nvidia.com>
 <20210120165708.243f83cb@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210120165708.243f83cb@carbon>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 04:57:08PM +0100, Jesper Dangaard Brouer wrote:
> On Wed, 20 Jan 2021 15:15:22 +0200
> Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> 
> > On 2021-01-19 17:50, Björn Töpel wrote:
> > > This series extends bind() for XDP sockets, so that the bound socket
> > > is added to the netdev_rx_queue _rx array in the netdevice. We call
> > > this to register the socket. To redirect packets to the registered
> > > socket, a new BPF helper is used: bpf_redirect_xsk().
> > > 
> > > For shared XDP sockets, only the first bound socket is
> > > registered. Users that need more complex setup has to use XSKMAP and
> > > bpf_redirect_map().
> > > 
> > > Now, why would one use bpf_redirect_xsk() over the regular
> > > bpf_redirect_map() helper?
> > > 
> > > * Better performance!
> > > * Convenience; Most user use one socket per queue. This scenario is
> > >    what registered sockets support. There is no need to create an
> > >    XSKMAP. This can also reduce complexity from containerized setups,
> > >    where users might what to use XDP sockets without CAP_SYS_ADMIN
> > >    capabilities.
> 
> I'm buying into the convenience and reduce complexity, and XDP sockets
> without CAP_SYS_ADMIN into containers.
> 
> People might be surprised that I'm actually NOT buying into the better
> performance argument here.  At these speeds we are basically comparing
> how close we are to zero (and have to use nanosec time scale for our
> comparisons), more below.
> 
>  
> > > The first patch restructures xdp_do_redirect() a bit, to make it
> > > easier to add the new helper. This restructure also give us a slight
> > > performance benefit. The following three patches extends bind() and
> > > adds the new helper. After that, two libbpf patches that selects XDP
> > > program based on what kernel is running. Finally, selftests for the new
> > > functionality is added.
> > > 
> > > Note that the libbpf "auto-selection" is based on kernel version, so
> > > it is hard coded to the "-next" version (5.12). If you would like to
> > > try this is out, you will need to change the libbpf patch locally!
> > > 
> > > Thanks to Maciej and Magnus for the internal review/comments!
> > > 
> > > Performance (rxdrop, zero-copy)
> > > 
> > > Baseline
> > > Two cores:                   21.3 Mpps
> > > One core:                    24.5 Mpps  
> > 
> > Two cores is slower? It used to be faster all the time, didn't it?
> > 
> > > Patched
> > > Two cores, bpf_redirect_map: 21.7 Mpps + 2%
> > > One core, bpf_redirect_map:  24.9 Mpps + 2%
> > > 
> > > Two cores, bpf_redirect_xsk: 24.0 Mpps +13%  
> > 
> > Nice, impressive improvement!
> 
> I do appreciate you work and performance optimizations at this level,
> because when we are using this few CPU cycles per packet, then it is
> really hard to find new ways to reduce cycles further.
> 
> Thank for you saying +13% instead of saying +2.7 Mpps.
> It *is* impressive to basically reduce cycles with 13%.
> 
>  21.3 Mpps = 46.94 nanosec per packet
>  24.0 Mpps = 41.66 nanosec per packet
> 
>  21.3 Mpps -> 24.0 Mpps = 5.28 nanosec saved
> 
> On my 3.60GHz testlab machine that gives me 19 cycles.
> 
>  
> > > One core, bpf_redirect_xsk:  25.5 Mpps + 4%
> > >
> 
>  24.5 Mpps -> 25.5 Mpps = 1.6 nanosec saved
> 
> At this point with saving 1.6 ns this is around the cost of a function call 1.3 ns.
> 
> 
> We still need these optimization in the kernel, but end-users in
> userspace are very quickly going to waste the 19 cycles we found.
> I still support/believe that the OS need to have a little overhead as
> possible, but for me 42 nanosec overhead is close to zero overhead. For
> comparison, I just ran a udp_sink[3] test, and it "cost" 625 ns for
> delivery of UDP packets into socket (almost 15 times slower).
> 
> I guess my point is that with XDP we have already achieved and exceeded
> (my original) performance goals, making it even faster is just showing off ;-P

Even though I'll let Bjorn elaborating on this, we're talking here about
AF-XDP which is a bit different pair of shoes to me in terms of
performance. AFAIK we still have a gap when compared to DPDK's numbers. So
I'm really not sure why better performance bothers you? :)

Let's rather be more harsh on changes that actually decrease the
performance, not the other way around. And I suppose you were the one that
always was bringing up the 'death by a 1000 paper cuts' of XDP. So yeah,
I'm a bit confused with your statement.

> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
> [1] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_sample.c
> [2] https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/lib/time_bench_memset.c
> [3] https://github.com/netoptimizer/network-testing/blob/master/src/udp_sink.c
> 
