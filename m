Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2E834D879
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbhC2Tog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:44:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:42803 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231810AbhC2ToI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 15:44:08 -0400
IronPort-SDR: t2dh6v64E/Rt9sRRGLamUPJmm7bOCxGBpIRLhPAwUqsQTMbjAD9A10pMKBxv15ASxfAj64rJpi
 E7c3Hp5RQWYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="252959738"
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="252959738"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 12:44:07 -0700
IronPort-SDR: fYp04vE2IxFojGiZfxNbXNM9s9BhIdJtIOtEtXGJoa7NgsarmGyLF2E+c/HMM8A5Mv1Iuln6ap
 jF5/hUwZ/5Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,288,1610438400"; 
   d="scan'208";a="393309865"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga002.jf.intel.com with ESMTP; 29 Mar 2021 12:44:05 -0700
Date:   Mon, 29 Mar 2021 21:32:34 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ciara.loftus@intel.com,
        john.fastabend@gmail.com
Subject: Re: [PATCH v4 bpf-next 06/17] libbpf: xsk: use bpf_link
Message-ID: <20210329193234.GA9506@ranger.igk.intel.com>
References: <20210326230938.49998-1-maciej.fijalkowski@intel.com>
 <20210326230938.49998-7-maciej.fijalkowski@intel.com>
 <87o8f2te2f.fsf@toke.dk>
 <20210329131401.GA9069@ranger.igk.intel.com>
 <87zgymrqzm.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87zgymrqzm.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 04:09:33PM +0200, Toke Høiland-Jørgensen wrote:
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> 
> > On Mon, Mar 29, 2021 at 01:05:44PM +0200, Toke Høiland-Jørgensen wrote:
> >> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> >> 
> >> > Currently, if there are multiple xdpsock instances running on a single
> >> > interface and in case one of the instances is terminated, the rest of
> >> > them are left in an inoperable state due to the fact of unloaded XDP
> >> > prog from interface.
> >> >
> >> > Consider the scenario below:
> >> >
> >> > // load xdp prog and xskmap and add entry to xskmap at idx 10
> >> > $ sudo ./xdpsock -i ens801f0 -t -q 10
> >> >
> >> > // add entry to xskmap at idx 11
> >> > $ sudo ./xdpsock -i ens801f0 -t -q 11
> >> >
> >> > terminate one of the processes and another one is unable to work due to
> >> > the fact that the XDP prog was unloaded from interface.
> >> >
> >> > To address that, step away from setting bpf prog in favour of bpf_link.
> >> > This means that refcounting of BPF resources will be done automatically
> >> > by bpf_link itself.
> >> >
> >> > Provide backward compatibility by checking if underlying system is
> >> > bpf_link capable. Do this by looking up/creating bpf_link on loopback
> >> > device. If it failed in any way, stick with netlink-based XDP prog.
> >> > therwise, use bpf_link-based logic.
> >> >
> >> > When setting up BPF resources during xsk socket creation, check whether
> >> > bpf_link for a given ifindex already exists via set of calls to
> >> > bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> >> > and comparing the ifindexes from bpf_link and xsk socket.
> >> >
> >> > For case where resources exist but they are not AF_XDP related, bail out
> >> > and ask user to remove existing prog and then retry.
> >> >
> >> > Lastly, do a bit of refactoring within __xsk_setup_xdp_prog and pull out
> >> > existing code branches based on prog_id value onto separate functions
> >> > that are responsible for resource initialization if prog_id was 0 and
> >> > for lookup existing resources for non-zero prog_id as that implies that
> >> > XDP program is present on the underlying net device. This in turn makes
> >> > it easier to follow, especially the teardown part of both branches.
> >> >
> >> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> >> 
> >> The logic is much improved in this version! A few smallish issues below:
> >
> > Glad to hear that!
> >
> >> 
> >> > ---
> >> >  tools/lib/bpf/xsk.c | 259 ++++++++++++++++++++++++++++++++++++--------
> >> >  1 file changed, 214 insertions(+), 45 deletions(-)
> >> >
> >> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> >> > index 526fc35c0b23..c75067f0035f 100644
> >> > --- a/tools/lib/bpf/xsk.c
> >> > +++ b/tools/lib/bpf/xsk.c
> >> > @@ -28,6 +28,7 @@
> >> >  #include <sys/mman.h>
> >> >  #include <sys/socket.h>
> >> >  #include <sys/types.h>
> >> > +#include <linux/if_link.h>
> >> >  
> >> >  #include "bpf.h"
> >> >  #include "libbpf.h"
> >> > @@ -70,8 +71,10 @@ struct xsk_ctx {
> >> >  	int ifindex;
> >> >  	struct list_head list;
> >> >  	int prog_fd;
> >> > +	int link_fd;
> >> >  	int xsks_map_fd;
> >> >  	char ifname[IFNAMSIZ];
> >> > +	bool has_bpf_link;
> >> >  };
> >> >  
> >> >  struct xsk_socket {
> >> > @@ -409,7 +412,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
> >> >  	static const int log_buf_size = 16 * 1024;
> >> >  	struct xsk_ctx *ctx = xsk->ctx;
> >> >  	char log_buf[log_buf_size];
> >> > -	int err, prog_fd;
> >> > +	int prog_fd;
> >> >  
> >> >  	/* This is the fallback C-program:
> >> >  	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> >> > @@ -499,14 +502,43 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
> >> >  		return prog_fd;
> >> >  	}
> >> >  
> >> > -	err = bpf_set_link_xdp_fd(xsk->ctx->ifindex, prog_fd,
> >> > -				  xsk->config.xdp_flags);
> >> > +	ctx->prog_fd = prog_fd;
> >> > +	return 0;
> >> > +}
> >> > +
> >> > +static int xsk_create_bpf_link(struct xsk_socket *xsk)
> >> > +{
> >> > +	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_flags
> >> > +	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
> >> > +	 */
> >> > +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> >> > +			    .flags = (xsk->config.xdp_flags & XDP_FLAGS_MODES));
> >> 
> >> This will silently suppress any new flags as well; that's not a good
> >> idea. Rather mask out the particular flag (UPDATE_IF_NOEXIST) and pass
> >> everything else through so the kernel can reject invalid ones.
> >
> > I'd say it's fine as it matches the check:
> >
> > 	/* link supports only XDP mode flags */
> > 	if (link && (flags & ~XDP_FLAGS_MODES)) {
> > 		NL_SET_ERR_MSG(extack, "Invalid XDP flags for BPF link attachment");
> > 		return -EINVAL;
> > 	}
> >
> > from dev_xdp_attach() in net/core/dev.c ?
> 
> Yeah, it does today. But what happens when the kernel learns to accept a
> new flag?
> 
> Also, you're masking the error on an invalid flag. If, in the future,
> the kernel learns to handle a new flag, that check in the kernel will
> change to accept that new flag. But if userspace tries to pass that to
> and old kernel, they'll get back an EINVAL. This can be used to detect
> whether the kernel doesn't support the flag, and can if not, userspace
> can fall back and do something different.
> 
> Whereas with your code, you're just silently zeroing out the invalid
> flag, so the caller will have no way to detect whether the flag works
> or not...

I'd rather worry about such feature detection once a new flag is in place
and this code would actually care about :) but that's me.

I feel like stick has two ends in this case - if we introduce a new flag
that would be out of the bpf_link's interest (the kernel part), then we
will have to come back here and explicitly mask it out, just like you
propose to do so with UPDATE_IF_NOEXIST right now.

What I'm saying is that we need to mask out the FLAGS_REPLACE as well.
Current code took care of that. So, to move this forward, I can do:

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index c75067f0035f..95da0e19f4a5 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -508,11 +508,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
 
 static int xsk_create_bpf_link(struct xsk_socket *xsk)
 {
-	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_flags
-	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
-	 */
-	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
-			    .flags = (xsk->config.xdp_flags & XDP_FLAGS_MODES));
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
 	struct xsk_ctx *ctx = xsk->ctx;
 	__u32 prog_id = 0;
 	int link_fd;
@@ -532,6 +528,8 @@ static int xsk_create_bpf_link(struct xsk_socket *xsk)
 		return -EINVAL;
 	}
 
+	opts.flags = xsk->config.xdp_flags & ~(XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_REPLACE);
+
 	link_fd = bpf_link_create(ctx->prog_fd, ctx->ifindex, BPF_XDP, &opts);
 	if (link_fd < 0) {
 		pr_warn("bpf_link_create failed: %s\n", strerror(errno));

> 
> -Toke
> 
