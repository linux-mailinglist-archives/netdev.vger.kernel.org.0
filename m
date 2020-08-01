Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2E72350FD
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 09:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgHAHTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 03:19:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:34362 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725283AbgHAHTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 03:19:10 -0400
IronPort-SDR: +O18yqpXbWZzWCm2FJzuQIq89nn/fnwHoyF2axbVULWQGjxKHD/XKherUFwEd98SlbASju2EhK
 RpJVfMCDn28A==
X-IronPort-AV: E=McAfee;i="6000,8403,9699"; a="170018819"
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800"; 
   d="scan'208";a="170018819"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2020 00:19:10 -0700
IronPort-SDR: Zo2derKvn82YH/lYinaB54acmt0x8hQMNm+RRz6vaZU7cPCumIWnSQDDlulX+EYZF52CDRVhYu
 lxgICzo2g4NA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,420,1589266800"; 
   d="scan'208";a="491786526"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga005.fm.intel.com with ESMTP; 01 Aug 2020 00:19:08 -0700
Date:   Sat, 1 Aug 2020 09:13:57 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com
Subject: Re: [PATCH v6 bpf-next 0/6] bpf: tailcalls in BPF subprograms
Message-ID: <20200801071357.GA19421@ranger.igk.intel.com>
References: <20200731000324.2253-1-maciej.fijalkowski@intel.com>
 <fbe6e5ca-65ba-7698-3b8d-1214b5881e88@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbe6e5ca-65ba-7698-3b8d-1214b5881e88@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 03:03:19AM +0200, Daniel Borkmann wrote:
> On 7/31/20 2:03 AM, Maciej Fijalkowski wrote:
> > v5->v6:
> > - propagate only those poke descriptors that individual subprogram is
> >    actually using (Daniel)
> > - drop the cumbersome check if poke desc got filled in map_poke_run()
> > - move poke->ip renaming in bpf_jit_add_poke_descriptor() from patch 4
> >    to patch 3 to provide bisectability (Daniel)
> 
> I did a basic test with Cilium on K8s with this set, spawning a few Pods
> and checking connectivity & whether we're not crashing since it has bit more
> elaborate tail call use. So far so good. I was inclined to push the series
> out, but there is one more issue I noticed and didn't notice earlier when
> reviewing, and that is overall stack size:
> 
> What happens when you create a single program that has nested BPF to BPF
> calls e.g. either up to the maximum nesting or one call that is using up
> the max stack size which is then doing another BPF to BPF call that contains
> the tail call. In the tail call map, you have the same program in there.
> This means we create a worst case stack from BPF size of max_stack_size *
> max_tail_call_size, that is, 512*32. So that adds 16k worst case. For x86
> we have a stack of arch/x86/include/asm/page_64_types.h:
> 
>   #define THREAD_SIZE_ORDER       (2 + KASAN_STACK_ORDER)
>  #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
> 
> So we end up with 16k in a typical case. And this will cause kernel stack
> overflow; I'm at least not seeing where we handle this situation in the
> set. Hm, need to think more, but maybe this needs tracking of max stack
> across tail calls to force an upper limit..

My knee jerk reaction would be to decrement the allowed max tail calls,
but not sure if it's an option and if it would help.

Otherwise I'm not sure how to pass around the stack size just like we're
doing it in this set with tail call counter that sits in %rax.

> 
> Thanks,
> Daniel
