Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8A534AB97
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 16:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhCZPeu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 11:34:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:63158 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhCZPe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 11:34:26 -0400
IronPort-SDR: b5eb3OeI3/oduOWojKXJTzYm5rY9uMF/MKC3WV3Mk3KB4mjTnxGeB2P6KUVHZSYfk6aqANytlb
 YNsMCDcOQUlQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="276311450"
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="276311450"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 08:34:25 -0700
IronPort-SDR: 9FuX4P+ozhHWe8juokGZpwJapgIN14l+RlN3nLklMjFmd3OayWlhDyNtcBPA9LNQQLo9fSi77n
 d2DTSTpTLRdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,280,1610438400"; 
   d="scan'208";a="526074930"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2021 08:34:23 -0700
Date:   Fri, 26 Mar 2021 16:23:18 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com
Subject: Re: [PATCH v3 bpf-next 06/17] libbpf: xsk: use bpf_link
Message-ID: <20210326152318.GA43356@ranger.igk.intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
 <20210322205816.65159-7-maciej.fijalkowski@intel.com>
 <87wnty7teq.fsf@toke.dk>
 <20210324130918.GA6932@ranger.igk.intel.com>
 <87a6qsf7hc.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87a6qsf7hc.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 12:38:07AM +0100, Toke Høiland-Jørgensen wrote:
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:
> 
> > On Mon, Mar 22, 2021 at 10:47:09PM +0100, Toke Høiland-Jørgensen wrote:
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
> >> > Otherwise, use bpf_link-based logic.
> >> 
> >> So how is the caller supposed to know which of the cases happened?
> >> Presumably they need to do their own cleanup in that case? AFAICT you're
> >> changing the code to always clobber the existing XDP program on detach
> >> in the fallback case, which seems like a bit of an aggressive change? :)
> >
> > Sorry Toke, I was offline yesterday.
> > Yeah once again I went too far and we shouldn't do:
> >
> > bpf_set_link_xdp_fd(xsk->ctx->ifindex, -1, 0);
> >
> > if xsk_lookup_bpf_maps(xsk) returned non-zero value which implies that the
> > underlying prog is not AF_XDP related.
> >
> > closing prog_fd (and link_fd under the condition that system is bpf_link
> > capable) is enough for that case.
> 
> I think the same thing goes for further down? With your patch, if the
> code takes the else branch (after checking prog_id), and then ends up
> going to err_set_bpf_maps, it'll now also do an unconditional
> bpf_set_link_xdp_fd(), where before it was checking prog_id again and
> only unloading if it previously loaded the program...

Hmm it's messy, I think we need a bit of refactoring here. Note that old
code was missing a close on ctx->xsks_map_fd if there was an error on
xsk_set_bpf_maps(xsk) and prog_id != 0 - given that
xsk_lookup_bpf_maps(xsk) succeeded, we therefore have a valid map fd that
we need to take care of on error path, for !prog_id case it was taken care
of within xsk_delete_bpf_maps(xsk).

So how about a diff below (on top of this patch), where we separate paths
based on prog_id value retrieved earlier? xsk_set_bpf_maps(xsk) is
repeated but this way I feel like it's more clear with cleanup/error
paths.

Wdyt?


diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 15812e4b93ca..c75067f0035f 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -790,71 +790,103 @@ static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
 	return 0;
 }
 
-static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
-				int *xsks_map_fd)
+static int xsk_init_xdp_res(struct xsk_socket *xsk,
+			    int *xsks_map_fd)
 {
-	struct xsk_socket *xsk = _xdp;
 	struct xsk_ctx *ctx = xsk->ctx;
-	__u32 prog_id = 0;
 	int err;
 
-	if (ctx->has_bpf_link)
-		err = xsk_link_lookup(ctx->ifindex, &prog_id, &ctx->link_fd);
-	else
-		err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_flags);
+	err = xsk_create_bpf_maps(xsk);
 	if (err)
 		return err;
 
-	if (!prog_id) {
-		err = xsk_create_bpf_maps(xsk);
-		if (err)
-			return err;
+	err = xsk_load_xdp_prog(xsk);
+	if (err)
+		goto err_load_xdp_prog;
 
-		err = xsk_load_xdp_prog(xsk);
-		if (err)
-			goto err_load_xdp_prog;
+	if (ctx->has_bpf_link)
+		err = xsk_create_bpf_link(xsk);
+	else
+		err = bpf_set_link_xdp_fd(xsk->ctx->ifindex, ctx->prog_fd,
+					  xsk->config.xdp_flags);
 
-		if (ctx->has_bpf_link)
-			err = xsk_create_bpf_link(xsk);
-		else
-			err = bpf_set_link_xdp_fd(xsk->ctx->ifindex, ctx->prog_fd,
-						  xsk->config.xdp_flags);
-		if (err)
-			goto err_attach_prog;
-	} else {
-		ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
-		if (ctx->prog_fd < 0)
-			return -errno;
-		err = xsk_lookup_bpf_maps(xsk);
-		if (err) {
-			close(ctx->prog_fd);
-			if (ctx->has_bpf_link)
-				close(ctx->link_fd);
-			else
-				bpf_set_link_xdp_fd(xsk->ctx->ifindex, -1, 0);
-			return err;
-		}
-	}
+	if (err)
+		goto err_atach_xdp_prog;
 
-	if (xsk->rx) {
-		err = xsk_set_bpf_maps(xsk);
-		if (err)
-			goto err_set_bpf_maps;
-	}
-	if (xsks_map_fd)
-		*xsks_map_fd = ctx->xsks_map_fd;
+	if (!xsk->rx)
+		return err;
 
-	return 0;
+	err = xsk_set_bpf_maps(xsk);
+	if (err)
+		goto err_set_bpf_maps;
+
+	return err;
 
 err_set_bpf_maps:
 	if (ctx->has_bpf_link)
 		close(ctx->link_fd);
 	else
-		bpf_set_link_xdp_fd(xsk->ctx->ifindex, -1, 0);
-err_attach_prog:
+		bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
+err_atach_xdp_prog:
 	close(ctx->prog_fd);
 err_load_xdp_prog:
 	xsk_delete_bpf_maps(xsk);
+	return err;
+}
+
+static int xsk_lookup_xdp_res(struct xsk_socket *xsk, int *xsks_map_fd, int prog_id)
+{
+	struct xsk_ctx *ctx = xsk->ctx;
+	int err;
+
+	ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
+	if (ctx->prog_fd < 0) {
+		err = -errno;
+		goto err_prog_fd;
+	}
+	err = xsk_lookup_bpf_maps(xsk);
+	if (err)
+		goto err_lookup_maps;
+
+	if (!xsk->rx)
+		return err;
+
+	err = xsk_set_bpf_maps(xsk);
+	if (err)
+		goto err_set_maps;
+
+	return err;
+
+err_set_maps:
+	close(ctx->xsks_map_fd);
+err_lookup_maps:
+	close(ctx->prog_fd);
+err_prog_fd:
+	if (ctx->has_bpf_link)
+		close(ctx->link_fd);
+	return err;
+}
+
+static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp, int *xsks_map_fd)
+{
+	struct xsk_socket *xsk = _xdp;
+	struct xsk_ctx *ctx = xsk->ctx;
+	__u32 prog_id = 0;
+	int err;
+
+	if (ctx->has_bpf_link)
+		err = xsk_link_lookup(ctx->ifindex, &prog_id, &ctx->link_fd);
+	else
+		err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_flags);
+
+	if (err)
+		return err;
+
+	err = !prog_id ? xsk_init_xdp_res(xsk, xsks_map_fd) :
+			 xsk_lookup_xdp_res(xsk, xsks_map_fd, prog_id);
+
+	if (!err && xsks_map_fd)
+		*xsks_map_fd = ctx->xsks_map_fd;
 
 	return err;
 }
> 
> > If we agree on that and there's nothing else that I missed, I'll send
> > a v4.
> 
> Apart from the above, sure!
> 
> -Toke
> 
