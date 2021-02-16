Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F66F31D1D0
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhBPVBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:01:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:60934 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhBPVBQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 16:01:16 -0500
IronPort-SDR: gW2YK0SGRw0EpKHc58tVgqRIcxmrcXI03u22xzV0yZypdFH3qxAefiVlAAXESMt0fMXtgC68/S
 bHV5PyNupd9Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="170147223"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="170147223"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 13:00:18 -0800
IronPort-SDR: muZsDZoAd4qEyKOSu/IiBK0dYT3VV9sOe0GNsSA7H+8yZ4WVOGv9lqPWZMYor0NncycU4HquUU
 bqJHDWlklXog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="384810321"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 16 Feb 2021 13:00:15 -0800
Date:   Tue, 16 Feb 2021 21:50:21 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org,
        magnus.karlsson@intel.com, ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Message-ID: <20210216205021.GC17126@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <602ade57ddb9c_3ed41208a1@john-XPS-13-9370.notmuch>
 <4a52d09a-363b-e69e-41d3-7918f0204901@intel.com>
 <87mtw4b8k3.fsf@toke.dk>
 <602c19dd5b1c2_6b719208e6@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <602c19dd5b1c2_6b719208e6@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 11:15:41AM -0800, John Fastabend wrote:
> Toke Høiland-Jørgensen wrote:
> > Björn Töpel <bjorn.topel@intel.com> writes:
> > 
> > > On 2021-02-15 21:49, John Fastabend wrote:
> > >> Maciej Fijalkowski wrote:
> > >>> Currently, if there are multiple xdpsock instances running on a single
> > >>> interface and in case one of the instances is terminated, the rest of
> > >>> them are left in an inoperable state due to the fact of unloaded XDP
> > >>> prog from interface.
> > >>>
> > >>> To address that, step away from setting bpf prog in favour of bpf_link.
> > >>> This means that refcounting of BPF resources will be done automatically
> > >>> by bpf_link itself.
> > >>>
> > >>> When setting up BPF resources during xsk socket creation, check whether
> > >>> bpf_link for a given ifindex already exists via set of calls to
> > >>> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> > >>> and comparing the ifindexes from bpf_link and xsk socket.
> > >>>
> > >>> If there's no bpf_link yet, create one for a given XDP prog and unload
> > >>> explicitly existing prog if XDP_FLAGS_UPDATE_IF_NOEXIST is not set.
> > >>>
> > >>> If bpf_link is already at a given ifindex and underlying program is not
> > >>> AF-XDP one, bail out or update the bpf_link's prog given the presence of
> > >>> XDP_FLAGS_UPDATE_IF_NOEXIST.
> > >>>
> > >>> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > >>> ---
> 
> [...]
> 
> > >>> -	ctx->prog_fd = prog_fd;
> > >>> +	link_fd = bpf_link_create(ctx->prog_fd, xsk->ctx->ifindex, BPF_XDP, &opts);
> > >>> +	if (link_fd < 0) {
> > >>> +		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
> > >>> +		return link_fd;
> > >>> +	}
> > >>> +
> > >> 
> > >> This can leave the system in a bad state where it unloaded the XDP program
> > >> above, but then failed to create the link. So we should somehow fix that
> > >> if possible or at minimum put a note somewhere so users can't claim they
> > >> shouldn't know this.
> > >> 
> > >> Also related, its not good for real systems to let XDP program go missing
> > >> for some period of time. I didn't check but we should make
> > >> XDP_FLAGS_UPDATE_IF_NOEXIST the default if its not already.
> > >>
> > >
> > > This is the default for XDP sockets library. The
> > > "bpf_set_link_xdp_fd(...-1)" way is only when a user sets it explicitly.
> > > One could maybe argue that the "force remove" would be out of scope for
> > > AF_XDP; Meaning that if an XDP program is running, attached via netlink,
> > > the AF_XDP library simply cannot remove it. The user would need to rely
> > > on some other mechanism.
> > 
> > Yeah, I'd tend to agree with that. In general, I think the proliferation
> > of "just force-remove (or override) the running program" in code and
> > instructions has been a mistake; and application should only really be
> > adding and removing its own program...
> > 
> > -Toke
> > 
> 
> I'll try to consolidate some of my opinions from a couple threads here. It
> looks to me many of these issues are self-inflicted by the API. We built
> the API with out the right abstractions or at least different abstractions
> from the rest of the BPF APIs. Not too surprising seeing the kernel side
> and user side were all being built up at once.
> 
> For example this specific issue where the xsk API also deletes the XDP
> program seems to be due to merging the xsk with the creation of the XDP
> programs.

IMHO the issue I fixed and that is the topic of those discussions is the
fact that handling of XDP program for xsk case was not balanced, IOW
libbpf was creating the prog if it wasn't present whereas app side was
blindly removing the XDP prog, even if it wasn't aware whether it has
loaded the prog among with XSKMAP or only attached the xsk socket to
XSKMAP that already existed.

> 
> I'm not a real user of AF_XDP (yet.), but here is how I would expect it
> to work based on how the sockmap pieces work, which are somewhat similar
> given they also deal with sockets.

Don't want to be picky, but I suppose sockmap won't play with ndo_bpf()
and that's what was bothering us.

> 
> Program 
> (1) load and pin an XDP BPF program
>     - obj = bpf_object__open(prog);
>     - bpf_object__load_xattr(&attr);
>     - bpf_program__pin()
> (2) pin the map, find map_xsk using any of the map APIs
>     - bpf_map__pin(map_xsk, path_to_pin)
> (3) attach to XDP
>     - link = bpf_program__attach_xdp()
>     - bpf_link__pin()
> 
> At this point you have a BPF program loaded, a xsk map, and a link all
> pinned and ready. And we can add socks using the process found in
> `enter_xsks_into_map` in the sample. This can be the same program that
> loaded/pinned the XDP program or some other program it doesn't really
> matter.
> 
>  - create xsk fd
>       . xsk_umem__create()
>       . xsk_socket__create
>  - open map @ pinned path
>  - bpf_map_update_elem(xsks_map, &key, &fd, 0);
> 
> Then it looks like we don't have any conflicts? The XDP program is pinned
> and exists in its normal scope. The xsk elements can be added/deleted
> as normal.

The only difference from what you wrote up is the resource pinning, when
compared to what we currently have + the set I am proposing.

So, if you're saying it looks like we don't have any conflicts and I am
saying that the flow is what we have, then...? :)

You would have to ask Magnus what was behind the decision to avoid API
from tools/lib/bpf/libbpf.c but rather directly call underlying functions
from tools/lib/bpf/bpf.c. Nevertheless, it doesn't really make a big
difference to me.

> If the XDP program is removed and the map referencing (using
> normal ref rules) reaches zero its also deleted. Above is more or less
> the same flow we use for any BPF program so looks good to me.

We have to be a bit more specific around the "XDP program is removed".
Is it removed from the network interface? That's the thing that we want to
avoid when there are other xsk sockets active on a given interface.

With bpf_link, XDP prog is removed only when bpf_link's refcount reaches
zero, via link->ops->release() callback that is invoked from
bpf_link_put().

And the refcount is updated with each process that attaches/detaches from
the bpf_link on interface.

> 
> The trouble seems to pop up when using the higher abstraction APIs
> xsk_setup_xdp_prog and friends I guess? I just see above as already
> fairly easy to use and we have good helpers to create the sockets it looks
> like. Maybe I missed some design considerations. IMO higher level
> abstractions should go in new libxdp and above should stay in libbpf.

xsk_setup_xdp_prog doesn't really feel like higher level abstraction, as I
mentioned, to me it has one layer of abstraction peeled off.

> 
> /rant off ;)
> 
> Thanks,
> John
