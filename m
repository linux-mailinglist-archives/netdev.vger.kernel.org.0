Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C08F531D17B
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 21:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbhBPUVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 15:21:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:57679 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhBPUVV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 15:21:21 -0500
IronPort-SDR: My4Kolgkyb8IQGCrLWbA2Ch9FRSNKczAimsE5NZyJzlxqnKi0C5Yfezz6w5hZzTo0EmbD49OAY
 B5ICTD+vs6JA==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="202205839"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="202205839"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2021 12:20:41 -0800
IronPort-SDR: WVa9ZRLa46PV2vonBQvhT5efQ+ggcXJoIesTh6Ljca4shXK/VWM+GLKK+W+2S2TdAObTTOOuWc
 2coFjACl+kFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="439074218"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga001.jf.intel.com with ESMTP; 16 Feb 2021 12:20:38 -0800
Date:   Tue, 16 Feb 2021 21:10:44 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii@kernel.org, toke@redhat.com,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com
Subject: Re: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Message-ID: <20210216201044.GA17126@ranger.igk.intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
 <602ade57ddb9c_3ed41208a1@john-XPS-13-9370.notmuch>
 <20210216023833.GD9572@ranger.igk.intel.com>
 <602c0ca5dc2d6_6b71920830@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <602c0ca5dc2d6_6b71920830@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 10:19:17AM -0800, John Fastabend wrote:
> Maciej Fijalkowski wrote:
> > On Mon, Feb 15, 2021 at 12:49:27PM -0800, John Fastabend wrote:
> > > Maciej Fijalkowski wrote:
> > > > Currently, if there are multiple xdpsock instances running on a single
> > > > interface and in case one of the instances is terminated, the rest of
> > > > them are left in an inoperable state due to the fact of unloaded XDP
> > > > prog from interface.
> > > > 
> > > > To address that, step away from setting bpf prog in favour of bpf_link.
> > > > This means that refcounting of BPF resources will be done automatically
> > > > by bpf_link itself.
> > > > 
> > > > When setting up BPF resources during xsk socket creation, check whether
> > > > bpf_link for a given ifindex already exists via set of calls to
> > > > bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> > > > and comparing the ifindexes from bpf_link and xsk socket.
> > > > 
> > > > If there's no bpf_link yet, create one for a given XDP prog and unload
> > > > explicitly existing prog if XDP_FLAGS_UPDATE_IF_NOEXIST is not set.
> > > > 
> > > > If bpf_link is already at a given ifindex and underlying program is not
> > > > AF-XDP one, bail out or update the bpf_link's prog given the presence of
> > > > XDP_FLAGS_UPDATE_IF_NOEXIST.
> > > > 
> > > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > > ---
> > > >  tools/lib/bpf/xsk.c | 143 +++++++++++++++++++++++++++++++++++++-------
> > > >  1 file changed, 122 insertions(+), 21 deletions(-)
> > > 
> > > [...]
> > > 
> > > > +static int xsk_create_bpf_link(struct xsk_socket *xsk)
> > > > +{
> > > > +	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_flags
> > > > +	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
> > > > +	 */
> > > > +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> > > > +			    .flags = (xsk->config.xdp_flags & XDP_FLAGS_MODES));
> > > > +	struct xsk_ctx *ctx = xsk->ctx;
> > > > +	__u32 prog_id;
> > > > +	int link_fd;
> > > > +	int err;
> > > > +
> > > > +	/* for !XDP_FLAGS_UPDATE_IF_NOEXIST, unload the program first, if any,
> > > > +	 * so that bpf_link can be attached
> > > > +	 */
> > > > +	if (!(xsk->config.xdp_flags & XDP_FLAGS_UPDATE_IF_NOEXIST)) {
> > > > +		err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_flags);
> > > > +		if (err) {
> > > > +			pr_warn("getting XDP prog id failed\n");
> > > > +			return err;
> > > > +		}
> > > > +		if (prog_id) {
> > > > +			err = bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
> > > > +			if (err < 0) {
> > > > +				pr_warn("detaching XDP prog failed\n");
> > > > +				return err;
> > > > +			}
> > > > +		}
> > > >  	}
> > > >  
> > > > -	ctx->prog_fd = prog_fd;
> > > > +	link_fd = bpf_link_create(ctx->prog_fd, xsk->ctx->ifindex, BPF_XDP, &opts);
> > > > +	if (link_fd < 0) {
> > > > +		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
> > > > +		return link_fd;
> > > > +	}
> > > > +
> > > 
> > > This can leave the system in a bad state where it unloaded the XDP program
> > > above, but then failed to create the link. So we should somehow fix that
> > > if possible or at minimum put a note somewhere so users can't claim they
> > > shouldn't know this.
> > > 
> > > Also related, its not good for real systems to let XDP program go missing
> > > for some period of time. I didn't check but we should make
> > > XDP_FLAGS_UPDATE_IF_NOEXIST the default if its not already.
> > 
> > Old way of attaching prog is mutual exclusive with bpf_link, right?
> > What I'm saying is in order to use one of the two, you need to wipe out
> > the current one in favour of the second that you would like to load.
> 
> Personally, if I were using above I want the operation to error
> if a XDP program is already attached. Then user is forced to remove the
> XDP program directly if thats even safe to do.
> 
> Reusing UPDATE_IF_NOEXIST flag above seems like an abuse of that flag.
> The kernel side does an atomic program swap (or at least it should imo) 
> of the programs when it is set. Atomic here is not exactly right though
> because driver might reset or do other things, but the point is no
> packets are missed without policy. In above some N packets will pass
> through the device without policy being applied. This is going to be
> subtle and buggy if used in real production systems.
> 
> The API needs to do a replace operation not a delete/create and if it
> can't do that it needs to error out so the user can figure out what
> to do about it.
> 
> Do you really need this automatic behavior for something? It clutters
> up the API with more flags and I can't see how its useful. If it
> errors out just delete the prog using the existing interfaces from the
> API user side.

Fair argument, I went too far with --force flag. Given what you said, I'll
drop that wipe out of netlink-based XDP prog, but I think we can keep the
logic around updating the bpf_link if it already exists (in case --force
flag was set). This provides the atomic xchg and we won't expose systems
to a time frame without XDP policy as you point out.

> 
> > 
> > > 
> > > > +	ctx->link_fd = link_fd;
> > > >  	return 0;
> > > >  }
> > > >  
> > > 
> > > [...]
> > > 
> > > > +static int xsk_link_lookup(struct xsk_ctx *ctx, __u32 *prog_id)
> > > > +{
> > > > +	__u32 link_len = sizeof(struct bpf_link_info);
> > > > +	struct bpf_link_info link_info;
> > > > +	__u32 id = 0;
> > > > +	int err;
> > > > +	int fd;
> > > > +
> > > > +	while (true) {
> > > > +		err = bpf_link_get_next_id(id, &id);
> > > > +		if (err) {
> > > > +			if (errno == ENOENT)
> > > > +				break;
> > > > +			pr_warn("can't get next link: %s\n", strerror(errno));
> > > > +			break;
> > > > +		}
> > > > +
> > > > +		fd = bpf_link_get_fd_by_id(id);
> > > > +		if (fd < 0) {
> > > > +			if (errno == ENOENT)
> > > > +				continue;
> > > > +			pr_warn("can't get link by id (%u): %s\n", id, strerror(errno));
> > > > +			break;
> > > > +		}
> > > > +
> > > > +		memset(&link_info, 0, link_len);
> > > > +		err = bpf_obj_get_info_by_fd(fd, &link_info, &link_len);
> > > > +		if (err) {
> > > > +			pr_warn("can't get link info: %s\n", strerror(errno));
> > > > +			close(fd);
> > > > +			break;
> > > > +		}
> > > > +		if (link_info.xdp.ifindex == ctx->ifindex) {
> > > > +			ctx->link_fd = fd;
> > > > +			*prog_id = link_info.prog_id;
> > > > +			break;
> > > > +		}
> > > > +		close(fd);
> > > > +	}
> > > > +
> > > > +	return errno == ENOENT ? 0 : err;
> > > 
> > > But, err wont be set in fd < 0 case? I guess we don't want to return 0 if
> > > bpf_link_get_fd_by_id fails.
> > 
> > Good catch!
> > 
> > > Although I really don't like the construct
> > > here that much. I think just `return err` and ensuring err is set correctly
> > > would be more clear. At least the fd error case needs to be handled
> > > though.
> > 
> > FWIW, this was inspired by tools/bpf/bpftool/link.c:do_show()
> 
> Sure its not my preference, but as long as the bug is resolved I
> wont complain. If I hadn't seen the bug I wouldn't have said
> anything.
> 
> > 
> > > 
> > > > +}
> > > > +
> 
> 
