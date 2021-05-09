Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE87F37777C
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 18:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhEIQEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 12:04:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:32381 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229645AbhEIQD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 May 2021 12:03:59 -0400
IronPort-SDR: si5NvEiD2di93DP2zfEtOI2tvKIrI37IXIWohBA74J1oGLwZyC/nbS1K+wSgD8pb3/V8LC1nwV
 qoZAe9324HrA==
X-IronPort-AV: E=McAfee;i="6200,9189,9979"; a="186489813"
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="scan'208";a="186489813"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2021 09:02:56 -0700
IronPort-SDR: 4JNVOgTvcpa06LIRy1rMiVxFwO+gvDGWg19/1fEpTBI0W5D9vS/kYpIWXwc/3yAhZvUhof636H
 dbjORZuoZ8JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,286,1613462400"; 
   d="scan'208";a="460897375"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by FMSMGA003.fm.intel.com with ESMTP; 09 May 2021 09:02:52 -0700
Date:   Sun, 9 May 2021 17:50:33 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Zvi Effron <zeffron@riotgames.com>,
        T K Sourabh <sourabhtk37@gmail.com>,
        Xdp <xdp-newbies@vger.kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, kuba@kernel.org
Subject: Re: Dropped packets mapping IRQs for adjusted queue counts on i40e
Message-ID: <20210509155033.GB36905@ranger.igk.intel.com>
References: <CAC1LvL1NHj6n+RNYRmja2YDhkcCwREuhjaBz_k255rU1jdO8Sw@mail.gmail.com>
 <CADS2XXpjasmJKP__oHsrvv3EG8n-FjB6sqHwgQfh7QgeJ8GrrQ@mail.gmail.com>
 <CAC1LvL2Q=s8pmwKAh2615fsTFEETKp96jpoLJS+75=0ztwuLFQ@mail.gmail.com>
 <CADS2XXptoyPTBObKgp3gcRZnWzoVyZrC26tDpLWhC9YrGMSefw@mail.gmail.com>
 <CAC1LvL2zmO1ntKeAoUMkJSarJBgxNhnTva3Di4047MTKqo8rPA@mail.gmail.com>
 <CAC1LvL1Kd-TCuPk0BEQyGvEiLzgUqkZHOKQNOUnxXSY6NjFMmw@mail.gmail.com>
 <20210505130128.00006720@intel.com>
 <20210505212157.GA63266@ranger.igk.intel.com>
 <87fsz0w3xn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87fsz0w3xn.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 06, 2021 at 12:29:40PM +0200, Toke Høiland-Jørgensen wrote:
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> 
> > On Wed, May 05, 2021 at 01:01:28PM -0700, Jesse Brandeburg wrote:
> >> Zvi Effron wrote:
> >> 
> >> > On Tue, May 4, 2021 at 4:07 PM Zvi Effron <zeffron@riotgames.com> wrote:
> >> > > I'm suspecting it's something with how XDP_REDIRECT is implemented in
> >> > > the i40e driver, but I don't know if this is a) cross driver behavior,
> >> > > b) expected behavior, or c) a bug.
> >> > I think I've found the issue, and it appears to be specific to i40e
> >> > (and maybe other drivers, too, but not XDP itself).
> >> > 
> >> > When performing the XDP xmit, i40e uses the smp_processor_id() to
> >> > select the tx queue (see
> >> > https://elixir.bootlin.com/linux/v5.12.1/source/drivers/net/ethernet/intel/i40e/i40e_txrx.c#L3846).
> >> > I'm not 100% clear on how the CPU is selected (since we don't use
> >> > cores 0 and 1), we end up on a core whose id is higher than any
> >> > available queue.
> >> > 
> >> > I'm going to try to modify our IRQ mappings to test this.
> >> > 
> >> > If I'm correct, this feels like a bug to me, since it requires a user
> >> > to understand low level driver details to do IRQ remapping, which is a
> >> > bit higher level. But if it's intended, we'll just have to figure out
> >> > how to work around this. (Unfortunately, using split tx and rx queues
> >> > is not possible with i40e, so that easy solution is unavailable.)
> >> > 
> >> > --Zvi
> >
> > Hey Zvi, sorry for the lack of assistance, there has been statutory free
> > time in Poland and today i'm in the birthday mode, but we managed to
> > discuss the issue with Magnus and we feel like we could have a solution
> > for that, more below.
> >
> >> 
> >> 
> >> It seems like for Intel drivers, igc, ixgbe, i40e, ice all have
> >> this problem.
> >> 
> >> Notably, igb, fixes it like I would expect.
> >
> > igb is correct but I think that we would like to avoid the introduction of
> > locking for higher speed NICs in XDP data path.
> >
> > We talked with Magnus that for i40e and ice that have lots of HW
> > resources, we could always create the xdp_rings array of num_online_cpus()
> > size and use smp_processor_id() for accesses, regardless of the user's
> > changes to queue count.
> 
> What is "lots"? Systems with hundreds of CPUs exist (and I seem to
> recall an issue with just such a system on Intel hardware(?)). Also,
> what if num_online_cpus() changes?

"Lots" is 16k for ice. For i40e datasheet tells that it's only 1536 for
whole device, so I back off from the statement that i40e has a lot of
resources :)

Also, s/num_online_cpus()/num_possible_cpus().

> 
> > This way the smp_processor_id() provides the serialization by itself as
> > we're under napi on a given cpu, so there's no need for locking
> > introduction - there is a per-cpu XDP ring provided. If we would stick to
> > the approach where you adjust the size of xdp_rings down to the shrinked
> > Rx queue count and use a smp_processor_id() % vsi->num_queue_pairs formula
> > then we could have a resource contention. Say that you did on a 16 core
> > system:
> > $ ethtool -L eth0 combined 2
> >
> > and then mapped the q0 to cpu1 and q1 to cpu 11. Both queues will grab the
> > xdp_rings[1], so we would have to introduce the locking.
> >
> > Proposed approach would just result with more Tx queues packed onto Tx
> > ring container of queue vector.
> >
> > Thoughts? Any concerns? Should we have a 'fallback' mode if we would be
> > out of queues?
> 
> Yes, please :)

How to have a fallback (in drivers that need it) in a way that wouldn't
hurt the scenario where queue per cpu requirement is satisfied?

> 
> -Toke
> 
