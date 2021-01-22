Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA92D2FFF9A
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbhAVJ4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:56:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:60969 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727200AbhAVJ4O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 04:56:14 -0500
IronPort-SDR: YdyaPivU96x5eP+21Za+IaMTCerKcS7xj4WEmAF2eX5gvbe3lai83z/fmsaZPomQu8Z8i+s+Ab
 kJuMo8+RdOIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9871"; a="175913610"
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="175913610"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2021 01:55:10 -0800
IronPort-SDR: UdiKqc9igkxD/D284xaFkCp+DWe9XueR73/kf+zPIJ/74hDIXeyY+hUNxKBfEK6xfqozIAZWFC
 3iqG9pVfTSNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,366,1602572400"; 
   d="scan'208";a="502631283"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 22 Jan 2021 01:55:06 -0800
Date:   Fri, 22 Jan 2021 10:45:28 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Ciara Loftus <ciara.loftus@intel.com>,
        Weqaar Janjua <weqaar.a.janjua@intel.com>
Subject: Re: [PATCH bpf-next v2 0/8] Introduce bpf_redirect_xsk() helper
Message-ID: <20210122094528.GA52373@ranger.igk.intel.com>
References: <20210119155013.154808-1-bjorn.topel@gmail.com>
 <7dcee85b-b3ef-947f-f433-03ad7066c5dd@nvidia.com>
 <20210120165708.243f83cb@carbon>
 <20210120161931.GA32916@ranger.igk.intel.com>
 <20210121180134.51070b74@carbon>
 <CAJ8uoz2JJpd9aqhp84noA-_TspR4=sJeE2bRWYoXUKKuB2ty+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ8uoz2JJpd9aqhp84noA-_TspR4=sJeE2bRWYoXUKKuB2ty+Q@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 09:59:53AM +0100, Magnus Karlsson wrote:
> On Thu, Jan 21, 2021 at 6:07 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
> >
> > On Wed, 20 Jan 2021 17:19:31 +0100
> > Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
> >
> > > On Wed, Jan 20, 2021 at 04:57:08PM +0100, Jesper Dangaard Brouer wrote:
> > > > On Wed, 20 Jan 2021 15:15:22 +0200
> > > > Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> > > >
> > > > > On 2021-01-19 17:50, Björn Töpel wrote:
> > > > > > This series extends bind() for XDP sockets, so that the bound socket
> > > > > > is added to the netdev_rx_queue _rx array in the netdevice. We call
> > > > > > this to register the socket. To redirect packets to the registered
> > > > > > socket, a new BPF helper is used: bpf_redirect_xsk().
> > > > > >
> > > > > > For shared XDP sockets, only the first bound socket is
> > > > > > registered. Users that need more complex setup has to use XSKMAP and
> > > > > > bpf_redirect_map().
> > > > > >
> > > > > > Now, why would one use bpf_redirect_xsk() over the regular
> > > > > > bpf_redirect_map() helper?
> > > > > >
> > > > > > * Better performance!
> > > > > > * Convenience; Most user use one socket per queue. This scenario is
> > > > > >    what registered sockets support. There is no need to create an
> > > > > >    XSKMAP. This can also reduce complexity from containerized setups,
> > > > > >    where users might what to use XDP sockets without CAP_SYS_ADMIN
> > > > > >    capabilities.
> > > >
> > > > I'm buying into the convenience and reduce complexity, and XDP sockets
> > > > without CAP_SYS_ADMIN into containers.
> > > >
> > > > People might be surprised that I'm actually NOT buying into the better
> > > > performance argument here.  At these speeds we are basically comparing
> > > > how close we are to zero (and have to use nanosec time scale for our
> > > > comparisons), more below.
> > > >
> > > >
> > > > > > The first patch restructures xdp_do_redirect() a bit, to make it
> > > > > > easier to add the new helper. This restructure also give us a slight
> > > > > > performance benefit. The following three patches extends bind() and
> > > > > > adds the new helper. After that, two libbpf patches that selects XDP
> > > > > > program based on what kernel is running. Finally, selftests for the new
> > > > > > functionality is added.
> > > > > >
> > > > > > Note that the libbpf "auto-selection" is based on kernel version, so
> > > > > > it is hard coded to the "-next" version (5.12). If you would like to
> > > > > > try this is out, you will need to change the libbpf patch locally!
> > > > > >
> > > > > > Thanks to Maciej and Magnus for the internal review/comments!
> > > > > >
> > > > > > Performance (rxdrop, zero-copy)
> > > > > >
> > > > > > Baseline
> > > > > > Two cores:                   21.3 Mpps
> > > > > > One core:                    24.5 Mpps
> > > > >
> > > > > Two cores is slower? It used to be faster all the time, didn't it?
> > > > >
> > > > > > Patched
> > > > > > Two cores, bpf_redirect_map: 21.7 Mpps + 2%
> > > > > > One core, bpf_redirect_map:  24.9 Mpps + 2%
> > > > > >
> > > > > > Two cores, bpf_redirect_xsk: 24.0 Mpps +13%
> > > > >
> > > > > Nice, impressive improvement!
> > > >
> > > > I do appreciate you work and performance optimizations at this level,
> > > > because when we are using this few CPU cycles per packet, then it is
> > > > really hard to find new ways to reduce cycles further.
> > > >
> > > > Thank for you saying +13% instead of saying +2.7 Mpps.
> > > > It *is* impressive to basically reduce cycles with 13%.
> > > >
> > > >  21.3 Mpps = 46.94 nanosec per packet
> > > >  24.0 Mpps = 41.66 nanosec per packet
> > > >
> > > >  21.3 Mpps -> 24.0 Mpps = 5.28 nanosec saved
> > > >
> > > > On my 3.60GHz testlab machine that gives me 19 cycles.
> > > >
> > > >
> > > > > > One core, bpf_redirect_xsk:  25.5 Mpps + 4%
> > > > > >
> > > >
> > > >  24.5 Mpps -> 25.5 Mpps = 1.6 nanosec saved
> > > >
> > > > At this point with saving 1.6 ns this is around the cost of a function call 1.3 ns.
> > > >
> > > >
> > > > We still need these optimization in the kernel, but end-users in
> > > > userspace are very quickly going to waste the 19 cycles we found.
> > > > I still support/believe that the OS need to have a little overhead as
> > > > possible, but for me 42 nanosec overhead is close to zero overhead. For
> > > > comparison, I just ran a udp_sink[3] test, and it "cost" 625 ns for
> > > > delivery of UDP packets into socket (almost 15 times slower).
> > > >
> > > > I guess my point is that with XDP we have already achieved and exceeded
> > > > (my original) performance goals, making it even faster is just showing off ;-P
> > >
> > > Even though I'll let Bjorn elaborating on this, we're talking here about
> > > AF-XDP which is a bit different pair of shoes to me in terms of
> > > performance. AFAIK we still have a gap when compared to DPDK's numbers. So
> >
> > AFAIK the gap on this i40e hardware is DPDK=36Mpps, and lets say
> > AF_XDP=25.5 Mpps, that looks large +10.5Mpps, but it is only 11.4
> > nanosec.
> >
> > > I'm really not sure why better performance bothers you? :)
> >
> > Finding those 11.4 nanosec is going to be really difficult and take a
> > huge effort. My fear is also that some of these optimizations will make
> > the code harder to maintain and understand.
> >
> > If you are ready to do this huge effort, then I'm actually ready to
> > provide ideas on what you can optimize.
> >
> > E.g. you can get 2-4 nanosec if we prefetch to L2 in driver (assuming
> > data is DDIO in L3 already).  (CPU supports L2 prefetch, but kernel
> > have no users of that feature).

Just to add to what Magnus wrote below, when comparing technologies, XDP
is confronted with kernel's netstack and as we know, difference is really
big and there's no secret who's the winner in terms of performance in
specific scenarios. So, I'm not saying I'm super OK with that, but we can
allow ourselves for having a cool feature that boosts our control plane,
but degrades performance a bit, as you found out with egress XDP prog. We
are still going to be fine.

For AF_XDP the case is the opposite, meaning, we are the chaser in this
scenario. Performance work is still the top priority for AF_XDP in my
eyes.

> 
> In my experience, I would caution starting to use L2 prefetch at this
> point since it is somewhat finicky. It is possible to get better
> performance using it on one platform, but significantly harder to get
> it to work also on a three year older one, not to mention other
> platforms and architectures.
> 
> Instead, I would start with optimizations that always work such as not
> having to execute code (or removing code) that is not necessary for
> the functionality that is provided. One example of this is having to
> execute all the bpf_redirect code when we are using packet steering in
> HW to AF_XDP sockets and other potential consumers. In this scenario,
> the core bpf_redirect code (xdp_do_redirect + bpf_xdp_redirect_map +
> __xsk_map_redirect for the XSKMAP case) provides no value and amounts
> to 19% of the total execution time on my machine (application plus
> kernel, and the XDP program itself is another 7% on top of the 19%).
> By removing this, you could cut down a large chunk of those 11.4 ns we
> would need to find in our optimization work. Just to be clear, there
> are plenty of other scenarios where the bpf_redirect functionality
> provides great value, so it is really good to have. I just think it is
> weird that it has to be executed all the time even when it is not
> needed. The big question is just how to achieve this in an
> architecturally sound way. Any ideas?
> 
> Just note that there are plenty that could be done in other areas too.
> For example, the Rx part of the driver is around 22% of the execution
> time and I am sure we can optimize this part too and increase the
> readability and maintainability of the code at the same time. But not
> trim it down to 0% as some of this is actually necessary work in all
> cases where traffic is received :-). xp_alloc is another big time
> consumer of cycles, but for this one I do have a patch set that cuts
> it down from 21% to 8% that I plan on submitting in February.
> 
> perf top data:
> 21.58%  [ice]                      [k] ice_clean_rx_irq_zc
> 21.21%  [kernel]                   [k] xp_alloc
> 13.93%  [kernel]                   [k] __xsk_rcv_zc
> 8.53%  [kernel]                   [k] xdp_do_redirect
> 8.15%  [kernel]                   [k] xsk_rcv
> 6.66%  [kernel]                   [k] bpf_xdp_redirect_map
> 5.08%  bpf_prog_992d9ddc835e5629  [k] bpf_prog_992d9ddc835e5629
> 3.73%  [ice]                      [k] ice_alloc_rx_bufs_zc
> 3.36%  [kernel]                   [k] __xsk_map_redirect
> 2.62%  xdpsock                    [.] main
> 0.96%  [kernel]                   [k] rcu_read_unlock_strict
> 0.90%  bpf_dispatcher_xdp         [k] bpf_dispatcher_xdp
> 0.87%  [kernel]                   [k] bpf_dispatcher_xdp_func
> 0.51%  [kernel]                   [k] xsk_flush
> 0.38%  [kernel]                   [k] lapic_next_deadline
> 0.13%  [ice]                      [k] ice_napi_poll
> 
> > The base design of XDP redirect API, that have a number of function
> > calls per packet, in itself becomes a limiting factor.  Even the cost
> > of getting the per-CPU pointer to bpf_redirect_info becomes something
> > to look at.
> >
> >
> > > Let's rather be more harsh on changes that actually decrease the
> > > performance, not the other way around. And I suppose you were the one that
> > > always was bringing up the 'death by a 1000 paper cuts' of XDP. So yeah,
> > > I'm a bit confused with your statement.
> >
> > Yes, we really need to protect the existing the performance.
> >
> > I think I'm mostly demotivated by the 'death by a 1000 paper cuts'.
> > People with good intentions are adding features, and performance slowly
> > disappears.  I've been spending weeks/months finding nanosec level
> > improvements, which I don't have time to "defend". Recently I realized
> > that the 2nd XDP prog on egress, even when no prog is attached, is
> > slowing down the performance of base redirect (I don't fully understand
> > why, maybe it is simply the I-cache increase, I didn't realize when
> > reviewing the code).
> >
> > --
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> >
