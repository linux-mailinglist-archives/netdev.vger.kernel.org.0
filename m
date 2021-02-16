Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C413931C549
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 03:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbhBPCMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 21:12:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:27088 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229777AbhBPCME (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 21:12:04 -0500
IronPort-SDR: J66eDvTERw4nodrzB/EvnvbQUdkVIVxSWSj7aqyg6N5edIjqUGbdTeY6a7Seq/VkPnx8+csmXW
 XuWd8b+cSGGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="182012871"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="182012871"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:11:18 -0800
IronPort-SDR: AOyaOKEDOj4Sj1p5SzIYISJBXDXCNUvvB9D5q9cU7kkQrEKB8ZiIVLf0ErF6TG5H/YcRyytLKp
 bmpborES6hxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="426113585"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga002.fm.intel.com with ESMTP; 15 Feb 2021 18:11:16 -0800
Date:   Tue, 16 Feb 2021 03:01:28 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org,
        magnus.karlsson@intel.com, ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Message-ID: <20210216020128.GA9572@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
 <875z2tcef2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875z2tcef2.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 08:35:29PM +0100, Toke Høiland-Jørgensen wrote:
> Björn Töpel <bjorn.topel@intel.com> writes:
> 
> > On 2021-02-15 18:07, Toke Høiland-Jørgensen wrote:
> >> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> >> 
> >>> Currently, if there are multiple xdpsock instances running on a single
> >>> interface and in case one of the instances is terminated, the rest of
> >>> them are left in an inoperable state due to the fact of unloaded XDP
> >>> prog from interface.
> >>>
> >>> To address that, step away from setting bpf prog in favour of bpf_link.
> >>> This means that refcounting of BPF resources will be done automatically
> >>> by bpf_link itself.
> >>>
> >>> When setting up BPF resources during xsk socket creation, check whether
> >>> bpf_link for a given ifindex already exists via set of calls to
> >>> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> >>> and comparing the ifindexes from bpf_link and xsk socket.
> >> 
> >> One consideration here is that bpf_link_get_fd_by_id() is a privileged
> >> operation (privileged as in CAP_SYS_ADMIN), so this has the side effect
> >> of making AF_XDP privileged as well. Is that the intention?
> >>
> >
> > We're already using, e.g., bpf_map_get_fd_by_id() which has that
> > as well. So we're assuming that for XDP setup already!
> 
> Ah, right, didn't realise that one is CAP_SYS_ADMIN as well; I
> remembered this as being specific to the bpf_link operation.
> 
> >> Another is that the AF_XDP code is in the process of moving to libxdp
> >> (see in-progress PR [0]), and this approach won't carry over as-is to
> >> that model, because libxdp has to pin the bpf_link fds.
> >>
> >
> > I was assuming there were two modes of operations for AF_XDP in libxdp.
> > One which is with the multi-program support (which AFAIK is why the
> > pinning is required), and one "like the current libbpf" one. For the
> > latter Maciej's series would be a good fit, no?
> 
> We haven't added an explicit mode switch for now; libxdp will fall back
> to regular interface attach if the kernel doesn't support the needed
> features for multi-attach, but if it's possible to just have libxdp
> transparently do the right thing I'd much prefer that. So we're still
> exploring that (part of which is that Magnus has promised to run some
> performance tests to see if there's a difference).
> 
> However, even if there's an explicit mode switch I'd like to avoid
> different *semantics* between the two modes if possible, to keep the two
> as compatible as possible. And since we can't currently do "auto-detach
> on bpf_link fd close" when using multi-prog, introducing this now would
> lead to just such a semantic difference. So my preference would be to do
> it differently... :)
> 
> >> However, in libxdp we can solve the original problem in a different way,
> >> and in fact I already suggested to Magnus that we should do this (see
> >> [1]); so one way forward could be to address it during the merge in
> >> libxdp? It should be possible to address the original issue (two
> >> instances of xdpsock breaking each other when they exit), but
> >> applications will still need to do an explicit unload operation before
> >> exiting (i.e., the automatic detach on bpf_link fd closure will take
> >> more work, and likely require extending the bpf_link kernel support)...
> >>
> >
> > I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
> > we're months ahead, then I'd really like to see this in libbpf until the
> > merge. However, I'll leave that for Magnus/you to decide!

WDYM by libbpf 1.0/libxdp merge? I glanced through thread and I saw that
John was also not aware of that. Not sure where it was discussed?

If you're saying 'merge', then is libxdp going to be a part of kernel or
as an AF-XDP related guy I would be forced to include yet another
repository in the BPF developer toolchain? :<

> 
> Well, as far as libxdp support goes, the PR I linked is pretty close to
> being mergeable. One of the few outstanding issues is whether we should
> solve just this issue before merging, actually :)
> 
> Not sure exactly which timeframe Andrii is envisioning for libbpf 1.0,
> but last I heard he'll announce something next week.
> 
> > Bottom line; I'd *really* like bpf_link behavior (process scoped) for
> > AF_XDP sooner than later! ;-)
> 
> Totally agree that we should solve the multi-process coexistence
> problem! And as I said, I think we can do so in libxdp by using the same
> synchronisation mechanism we use for setting up the multi-prog
> dispatcher. So it doesn't *have* to hold things up :)

Am I reading this right or you're trying to reject the fix of the long
standing issue due to a PR that is not ready yet on a standalone
project/library? :P

Once libxdp is the standard way of playing with AF-XDP and there are
actual users of that, then I'm happy to work/help on that issue.

Spawning a few xdpsock instances on the same interface has been a
standard/easiest way of measuring the scalability of AF-XDP ZC
implementations. This has been a real PITA for quite a long time. So, I
second Bjorn's statement - the sooner we have this fixed, the better.

Thanks! I hope I haven't sounded harsh, not my intent at all,
Maciej

> 
> -Toke
> 
