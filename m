Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7403F61FB
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238428AbhHXPs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:48:59 -0400
Received: from mga12.intel.com ([192.55.52.136]:27746 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238287AbhHXPs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 11:48:58 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="196914374"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="196914374"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 08:48:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="455619246"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 24 Aug 2021 08:48:06 -0700
Date:   Tue, 24 Aug 2021 17:32:25 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        brouer@redhat.com, intel-wired-lan@lists.osuosl.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>,
        =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Subject: Re: [PATCH] ixgbe: let the xdpdrv work with more than 64 cpus
Message-ID: <20210824153225.GA16546@ranger.igk.intel.com>
References: <20210824104918.7930-1-kerneljasonxing@gmail.com>
 <59dff551-2d52-5ecc-14ac-4a6ada5b1275@redhat.com>
 <CAL+tcoDERDZqtjK1BCc0vYYwYtvgRtb8H6z2FTVbGqr+N7bVmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL+tcoDERDZqtjK1BCc0vYYwYtvgRtb8H6z2FTVbGqr+N7bVmA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 11:23:29PM +0800, Jason Xing wrote:
> On Tue, Aug 24, 2021 at 9:32 PM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
> >
> >
> >
> > On 24/08/2021 12.49, kerneljasonxing@gmail.com wrote:
> > > From: Jason Xing <xingwanli@kuaishou.com>
> > >
> > > Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
> > > server is equipped with more than 64 cpus online. So it turns out that
> > > the loading of xdpdrv causes the "NOMEM" failure.
> > >
> > > Actually, we can adjust the algorithm and then make it work, which has
> > > no harm at all, only if we set the maxmium number of xdp queues.
> >
> > This is not true, it can cause harm, because XDP transmission queues are
> > used without locking. See drivers ndo_xdp_xmit function ixgbe_xdp_xmit().
> > As driver assumption is that each CPU have its own XDP TX-queue.

Thanks Jesper for chiming in.

> >
> 
> Point taken. I indeed miss that part which would cause bad behavior if it
> happens.
> 
> At this point, I think I should find all the allocation and use of XDP
> related, say,
> queues and rings, then adjust them all?
> 
> Let's say if the server is shipped with 128 cpus, we could map 128 cpus to 64
> rings in the function ixgbe_xdp_xmit(). However, it sounds a little bit odd.
> 
> Do you think that it makes any sense?

We need a fallback path for ixgbe. I did the following for ice:
https://x-lore.kernel.org/bpf/20210819120004.34392-9-maciej.fijalkowski@intel.com/T/#u

> 
> Thanks,
> Jason
> 
> > This patch is not a proper fix.
> >
> > I do think we need a proper fix for this issue on ixgbe.
> >
> >
> > > Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
> > > Co-developed-by: Shujin Li <lishujin@kuaishou.com>
> > > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > > ---
> > >   drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 2 +-
> > >   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ---
> > >   2 files changed, 1 insertion(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > > index 0218f6c..5953996 100644
> > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
> > > @@ -299,7 +299,7 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
> > >
> > >   static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
> > >   {
> > > -     return adapter->xdp_prog ? nr_cpu_ids : 0;
> > > +     return adapter->xdp_prog ? min_t(int, MAX_XDP_QUEUES, nr_cpu_ids) : 0;
> > >   }
> > >
> > >   #define IXGBE_RSS_64Q_MASK  0x3F
> > > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > index 14aea40..b36d16b 100644
> > > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > > @@ -10130,9 +10130,6 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
> > >                       return -EINVAL;
> > >       }
> > >
> > > -     if (nr_cpu_ids > MAX_XDP_QUEUES)
> > > -             return -ENOMEM;
> > > -
> > >       old_prog = xchg(&adapter->xdp_prog, prog);
> > >       need_reset = (!!prog != !!old_prog);
> > >
> > >
> >
