Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74B263F8D5D
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 19:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243258AbhHZRy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 13:54:28 -0400
Received: from mga04.intel.com ([192.55.52.120]:51076 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243252AbhHZRyX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 13:54:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="215955240"
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="215955240"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 10:53:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,354,1620716400"; 
   d="scan'208";a="685018525"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga006.fm.intel.com with ESMTP; 26 Aug 2021 10:53:32 -0700
Date:   Thu, 26 Aug 2021 19:37:33 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        songliubraving@fb.com, kafai@fb.com,
        Eric Dumazet <eric.dumazet@gmail.com>, daniel@iogearbox.net,
        Jason Xing <xingwanli@kuaishou.com>,
        netdev <netdev@vger.kernel.org>, ast@kernel.org,
        andrii@kernel.org, Shujin Li <lishujin@kuaishou.com>, yhs@fb.com,
        kpsingh@kernel.org, kuba@kernel.org, bpf@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, hawk@kernel.org
Subject: Re: [Intel-wired-lan] [PATCH v4] ixgbe: let the xdpdrv work with
 more than 64 cpus
Message-ID: <20210826173733.GA35972@ranger.igk.intel.com>
References: <20210826141623.8151-1-kerneljasonxing@gmail.com>
 <00890ff4-3264-337a-19cc-521a6434d1d0@gmail.com>
 <860ead37-87f4-22fa-e4f3-5cadd0f2c85c@intel.com>
 <CAL+tcoCovfAQmN_c43ScmjpO9D54CKP5XFTpx6VQpwJVxZhAdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL+tcoCovfAQmN_c43ScmjpO9D54CKP5XFTpx6VQpwJVxZhAdg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 01:03:16AM +0800, Jason Xing wrote:
> On Fri, Aug 27, 2021 at 12:41 AM Jesse Brandeburg
> <jesse.brandeburg@intel.com> wrote:
> >
> > On 8/26/2021 9:18 AM, Eric Dumazet wrote:
> >
> > >> +static inline int ixgbe_determine_xdp_q_idx(int cpu)
> > >> +{
> > >> +    if (static_key_enabled(&ixgbe_xdp_locking_key))
> > >> +            return cpu % IXGBE_MAX_XDP_QS;
> > >> +    else
> > >> +            return cpu;
> > >
> > > Even if num_online_cpus() is 8, the returned cpu here could be
> > >
> > > 0, 32, 64, 96, 128, 161, 197, 224
> > >
> > > Are we sure this will still be ok ?
> >
> > I'm not sure about that one myself. Jason?

I meant num_possible_cpus(), Jason should have yelled at me in the first
place, sorry. Lack of coffee probably. We use num_possible_cpus() on ice
side.

> >
> > >
> > >> +}
> > >> +
> > >>  static inline u8 ixgbe_max_rss_indices(struct ixgbe_adapter *adapter)
> > >>  {
> > >>      switch (adapter->hw.mac.type) {
> > >> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > >> index 0218f6c..884bf99 100644
> > >> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > >> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > >> @@ -299,7 +299,10 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
> > >>
> > >>  static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
> > >>  {
> > >> -    return adapter->xdp_prog ? nr_cpu_ids : 0;
> > >> +    int queues;
> > >> +
> > >> +    queues = min_t(int, IXGBE_MAX_XDP_QS, num_online_cpus());
> > >
> > > num_online_cpus() might change later...
> >
> > I saw that too, but I wonder if it doesn't matter to the driver. If a
> > CPU goes offline or comes online after the driver loads, we will use
> > this logic to try to pick an available TX queue. But this is a
> > complicated thing that is easy to get wrong, is there a common example
> > of how to get it right?
> >
> 
> Honestly, I'm a little confused right now. @nr_cpu_ids is the fixed
> number which means the total number of cpus the machine has.
> I think, using @nr_cpu_ids is safe one way or the other regardless of
> whether the cpu goes offline or not. What do you think?
> 
> > A possible problem I guess is that if the "static_key_enabled" check
> > returned false in the past, we would need to update that if the number
> > of CPUs changes, do we need a notifier?
> >
> 
> Things get complicated. If the number decreases down to
> @IXGBE_MAX_XDP_QS (which is 64), the notifier could be useful because
> we wouldn't need to use the @tx_lock. I'm wondering if we really need
> to implement one notifier for this kind of change?
> 
> > Also, now that I'm asking it, I dislike the global as it would apply to
> > all ixgbe ports and each PF would increment and decrement it
> > independently. Showing my ignorance here, but I haven't seen this
> > utility in the kernel before in detail. Not sure if this is "OK" from
> > multiple device (with the same driver / global namespace) perspective.

I'm not sure if there's a flawless solution to that. static key approach
won't have an impact for < 64 cpus systems but if you trigger this on one
PF then rest of the PFs that this driver is serving will be affected.

OTOH see the discussion I had with Toke on a different approach:
https://lore.kernel.org/bpf/20210601113236.42651-3-maciej.fijalkowski@intel.com/


> >
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
