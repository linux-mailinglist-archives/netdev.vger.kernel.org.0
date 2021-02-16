Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F309231C575
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 03:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhBPCVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 21:21:54 -0500
Received: from mga06.intel.com ([134.134.136.31]:39370 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230145AbhBPCVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 21:21:12 -0500
IronPort-SDR: Rua3KV16YSykH5alZnD5m08ndjq0LEmioUYQ4ApyR92YDZu8l6iA4+difhh+BKrBjfLga6kW0a
 /16Hq90D0Vwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244270692"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="244270692"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:20:00 -0800
IronPort-SDR: r8KQutqmSIcLiY9B+LCl8Z3x0aB1zqonW58lAuRLUXbhFQP0EF7+EXlF9UwzJwEteMDRXJMi17
 NM2IumgMUQcA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="493056686"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 15 Feb 2021 18:19:57 -0800
Date:   Tue, 16 Feb 2021 03:10:09 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org,
        magnus.karlsson@intel.com, ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Message-ID: <20210216021009.GB9572@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <87eehhcl9x.fsf@toke.dk>
 <fe0c957e-d212-4265-a271-ba301c3c5eca@intel.com>
 <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <602ad80c566ea_3ed4120871@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 12:22:36PM -0800, John Fastabend wrote:
> Björn Töpel wrote:
> > On 2021-02-15 18:07, Toke Høiland-Jørgensen wrote:
> > > Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> > > 
> > >> Currently, if there are multiple xdpsock instances running on a single
> > >> interface and in case one of the instances is terminated, the rest of
> > >> them are left in an inoperable state due to the fact of unloaded XDP
> > >> prog from interface.
> 
> I'm a bit confused by the above. This is only the case if the instance
> that terminated is the one that loaded the XDP program and it also didn't
> pin the program correct? If so lets make the commit message a bit more
> clear about the exact case we are solving.

I can include the following from the cover letter:

<quote>
$ sudo ./xdpsock -i ens801f0 -t -q 10 // load xdp prog and xskmap and
                                      // add entry to xskmap at idx 10

$ sudo ./xdpsock -i ens801f0 -t -q 11 // add entry to xskmap at idx 11

terminate one of the processes and another one is unable to work due to
the fact that the XDP prog was unloaded from interface.
</quote>

We don't do the prog pinning and it doesn't really matter which of the
instances you terminate.

> 
> > >>
> > >> To address that, step away from setting bpf prog in favour of bpf_link.
> > >> This means that refcounting of BPF resources will be done automatically
> > >> by bpf_link itself.
> 
> +1
> 
> > >>
> > >> When setting up BPF resources during xsk socket creation, check whether
> > >> bpf_link for a given ifindex already exists via set of calls to
> > >> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> > >> and comparing the ifindexes from bpf_link and xsk socket.
> > > 
> > > One consideration here is that bpf_link_get_fd_by_id() is a privileged
> > > operation (privileged as in CAP_SYS_ADMIN), so this has the side effect
> > > of making AF_XDP privileged as well. Is that the intention?
> > >
> > 
> > We're already using, e.g., bpf_map_get_fd_by_id() which has that
> > as well. So we're assuming that for XDP setup already!
> > 
> > > Another is that the AF_XDP code is in the process of moving to libxdp
> > > (see in-progress PR [0]), and this approach won't carry over as-is to
> > > that model, because libxdp has to pin the bpf_link fds.
> > >
> > 
> > I was assuming there were two modes of operations for AF_XDP in libxdp.
> > One which is with the multi-program support (which AFAIK is why the
> > pinning is required), and one "like the current libbpf" one. For the
> > latter Maciej's series would be a good fit, no?
> > 
> > > However, in libxdp we can solve the original problem in a different way,
> > > and in fact I already suggested to Magnus that we should do this (see
> > > [1]); so one way forward could be to address it during the merge in
> > > libxdp? It should be possible to address the original issue (two
> > > instances of xdpsock breaking each other when they exit), but
> > > applications will still need to do an explicit unload operation before
> > > exiting (i.e., the automatic detach on bpf_link fd closure will take
> > > more work, and likely require extending the bpf_link kernel support)...
> > >
> > 
> > I'd say it's depending on the libbpf 1.0/libxdp merge timeframe. If
> > we're months ahead, then I'd really like to see this in libbpf until the
> > merge. However, I'll leave that for Magnus/you to decide!
> 
> Did I miss some thread? What does this mean libbpf 1.0/libxdp merge? From
> my side libbpf should support the basic operations: load, attach, pin,
> and link for all my BPF objects. I view libxdp as providing 'extra'
> goodness on top of that. Everyone agree?
> 
> > 
> > Bottom line; I'd *really* like bpf_link behavior (process scoped) for
> > AF_XDP sooner than later! ;-)
> 
> Because I use libbpf as my base management for BPF objects I want it
> to support the basic ops for all objects so link ops should land there.
> 
> > 
> > 
> > Thanks for the input!
> > Björn
> > 
> > 
> > > -Toke
> > > 
> > > [0] https://github.com/xdp-project/xdp-tools/pull/92
> > > [1] https://github.com/xdp-project/xdp-tools/pull/92#discussion_r576204719
> > > 
> 
> 
