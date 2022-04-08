Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FF74F916F
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 11:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232747AbiDHJKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 05:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbiDHJKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 05:10:50 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3E711D78D;
        Fri,  8 Apr 2022 02:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649408926; x=1680944926;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZKdzglGLb5Yacw4vNCuGGPl/MNftiFw9nrbMfFNMqZk=;
  b=Ukrhf/4QMGb5TeJdQbRaq15+T5xcWLGCUVEXxSmVrI5sj+WM5Y2lrJkC
   y0qxt5WJOWp1EXCWYT3aU8oN5aHbgoQ2fI2Vys2R+fRkhMiTJ3QSSSmKP
   bLswVnwwuaL5NQ5Fwyt2+osnT1vYP6BXVdPN6pKPfouqZPS6fjuko4X5d
   GkxJoheI6D5oNhdVnpY7SqeHmcPfb1yo+U4Vbfo6wVk9c7CXyQ1bA7cE1
   fICFP41lI4D3cT9a06cYCqzjBIxmpjZnz4yCDegHdOzOLBS/APBjyiqAF
   EuzNjUM5Q4k/dw2us1oTBZ9VpsMcWgQW3I7izmNP3OJvyloEWbKff/Ay5
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="259148802"
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="259148802"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2022 02:08:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,244,1643702400"; 
   d="scan'208";a="589158507"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga001.jf.intel.com with ESMTP; 08 Apr 2022 02:08:42 -0700
Date:   Fri, 8 Apr 2022 11:08:42 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        netdev@vger.kernel.org, brouer@redhat.com,
        alexandr.lobakin@intel.com, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH bpf-next 00/10] xsk: stop softirq processing on full XSK
 Rx queue
Message-ID: <Yk/7mkNi52hLKyr6@boxer>
References: <20220405110631.404427-1-maciej.fijalkowski@intel.com>
 <8a81791e-342e-be8b-fc96-312f30b44be6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a81791e-342e-be8b-fc96-312f30b44be6@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 01:49:02PM +0300, Maxim Mikityanskiy wrote:
> On 2022-04-05 14:06, Maciej Fijalkowski wrote:
> > Hi!
> > 
> > This is a revival of Bjorn's idea [0] to break NAPI loop when XSK Rx
> > queue gets full which in turn makes it impossible to keep on
> > successfully producing descriptors to XSK Rx ring. By breaking out of
> > the driver side immediately we will give the user space opportunity for
> > consuming descriptors from XSK Rx ring and therefore provide room in the
> > ring so that HW Rx -> XSK Rx redirection can be done.
> > 
> > Maxim asked and Jesper agreed on simplifying Bjorn's original API used
> > for detecting the event of interest, so let's just simply check for
> > -ENOBUFS within Intel's ZC drivers after an attempt to redirect a buffer
> > to XSK Rx. No real need for redirect API extension.
> 

Hey Maxim!

> I believe some of the other comments under the old series [0] might be still
> relevant:
> 
> 1. need_wakeup behavior. If need_wakeup is disabled, the expected behavior
> is busy-looping in NAPI, you shouldn't break out early, as the application
> does not restart NAPI, and the driver restarts it itself, leading to a less
> efficient loop. If need_wakeup is enabled, it should be set on ENOBUFS - I
> believe this is the case here, right?

Good point. We currently set need_wakeup flag for -ENOBUFS case as it is
being done for failure == true. You are right that we shouldn't be
breaking the loop on -ENOBUFS if need_wakeup flag is not set on xsk_pool,
will fix!

> 
> 2. 50/50 AF_XDP and XDP_TX mix usecase. By breaking out early, you prevent
> further packets from being XDP_TXed, leading to unnecessary latency
> increase. The new feature should be opt-in, otherwise such usecases suffer.

Anyone performing a lot of XDP_TX (or XDP_PASS, etc) should be using the
regular copy-mode driver, while the zero-copy driver should be used when most
packets are sent up to user-space. For the zero-copy driver, this opt in is not
necessary. But it sounds like a valid option for copy mode, though could we
think about the proper way as a follow up to this work?

> 
> 3. When the driver receives ENOBUFS, it has to drop the packet before
> returning to the application. It would be better experience if your feature
> saved all N packets from being dropped, not just N-1.

Sure, I'll re-run tests and see if we can omit freeing the current
xdp_buff and ntc bump, so that we would come back later on to the same
entry.

> 
> 4. A slow or malicious AF_XDP application may easily cause an overflow of
> the hardware receive ring. Your feature introduces a mechanism to pause the
> driver while the congestion is on the application side, but no symmetric
> mechanism to pause the application when the driver is close to an overflow.
> I don't know the behavior of Intel NICs on overflow, but in our NICs it's
> considered a critical error, that is followed by a recovery procedure, so
> it's not something that should happen under normal workloads.

I'm not sure I follow on this one. Feature is about overflowing the XSK
receive ring, not the HW one, right? Driver picks entries from fill ring
that were produced by app, so if app is slow on producing those I believe
this would be rather an underflow of ring, we would simply receive less
frames. For HW Rx ring actually being full, I think that HW would be
dropping the incoming frames, so I don't see the real reason to treat this
as critical error that needs to go through recovery.

Am I missing something? Maybe I have just misunderstood you.

> 
> > One might ask why it is still relevant even after having proper busy
> > poll support in place - here is the justification.
> > 
> > For xdpsock that was:
> > - run for l2fwd scenario,
> > - app/driver processing took place on the same core in busy poll
> >    with 2048 budget,
> > - HW ring sizes Tx 256, Rx 2048,
> > 
> > this work improved throughput by 78% and reduced Rx queue full statistic
> > bump by 99%.
> > 
> > For testing ice, make sure that you have [1] present on your side.
> > 
> > This set, besides the work described above, also carries also
> > improvements around return codes in various XSK paths and lastly a minor
> > optimization for xskq_cons_has_entries(), a helper that might be used
> > when XSK Rx batching would make it to the kernel.
> 
> Regarding error codes, I would like them to be consistent across all
> drivers, otherwise all the debuggability improvements are not useful enough.
> Your series only changed Intel drivers. Here also applies the backward
> compatibility concern: the same error codes than were in use have been
> repurposed, which may confuse some of existing applications.

I'll double check if ZC drivers are doing something unusual with return
values from xdp_do_redirect(). Regarding backward comp, I suppose you
refer only to changes in ndo_xsk_wakeup() callbacks as others are not
exposed to user space? They're not crucial to me, but it improved my
debugging experience.

FYI, your mail landed in my junk folder and the links [0] [1] are messed up in
the reply you sent. And this is true even on lore.kernel.org. They suddenly
refer to "nam11.safelinks.protection.outlook.com". Maybe something worth
looking into if you have this problem in the future.

> 
> > Thanks!
> > MF
> > 
> > [0]: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fbpf%2F20200904135332.60259-1-bjorn.topel%40gmail.com%2F&amp;data=04%7C01%7Cmaximmi%40nvidia.com%7Cc9cefaa3a1cd465ccdb908da16f45eaf%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637847536077594100%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=sLpTcgboo9YU55wtUtaY1%2F%2FbeiYxeWP5ubk%2FQ6X8vB8%3D&amp;reserved=0
> > [1]: https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fnetdev%2F20220317175727.340251-1-maciej.fijalkowski%40intel.com%2F&amp;data=04%7C01%7Cmaximmi%40nvidia.com%7Cc9cefaa3a1cd465ccdb908da16f45eaf%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637847536077594100%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=OWXeZhc2Nouz%2FTMWBxvtTYbw%2FS8HWQfbfEqnVc5478k%3D&amp;reserved=0
> > 
> > Björn Töpel (1):
> >    xsk: improve xdp_do_redirect() error codes
> > 
> > Maciej Fijalkowski (9):
> >    xsk: diversify return codes in xsk_rcv_check()
> >    ice: xsk: terminate NAPI when XSK Rx queue gets full
> >    i40e: xsk: terminate NAPI when XSK Rx queue gets full
> >    ixgbe: xsk: terminate NAPI when XSK Rx queue gets full
> >    ice: xsk: diversify return values from xsk_wakeup call paths
> >    i40e: xsk: diversify return values from xsk_wakeup call paths
> >    ixgbe: xsk: diversify return values from xsk_wakeup call paths
> >    ice: xsk: avoid refilling single Rx descriptors
> >    xsk: drop ternary operator from xskq_cons_has_entries
> > 
> >   .../ethernet/intel/i40e/i40e_txrx_common.h    |  1 +
> >   drivers/net/ethernet/intel/i40e/i40e_xsk.c    | 27 +++++++++------
> >   drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
> >   drivers/net/ethernet/intel/ice/ice_xsk.c      | 34 ++++++++++++-------
> >   .../ethernet/intel/ixgbe/ixgbe_txrx_common.h  |  1 +
> >   drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c  | 29 ++++++++++------
> >   net/xdp/xsk.c                                 |  4 +--
> >   net/xdp/xsk_queue.h                           |  4 +--
> >   8 files changed, 64 insertions(+), 37 deletions(-)
> > 
> 
