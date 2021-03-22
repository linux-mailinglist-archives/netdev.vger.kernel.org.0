Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D630E34509B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhCVUUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:20:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:4761 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230060AbhCVUUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:20:01 -0400
IronPort-SDR: 7mCkypICdB3/D2YlGIdcOi7ECVwXnKD3dy3HSDKwsVHzvmzDR7PGXeRQ7pxwbBajNtGtYb8Hl4
 GTPAXZVJFh8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190436830"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190436830"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:20:00 -0700
IronPort-SDR: GVsMUUNyTj+ywIKD76aCAAQC5/wg7DZeE48ajz4FS9StYu/gPgGWR+zD3AYO6qJFqSRfJv9e+R
 abNe7yyuWjdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="414632242"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 22 Mar 2021 13:19:57 -0700
Date:   Mon, 22 Mar 2021 21:09:22 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        ciara.loftus@intel.com, john fastabend <john.fastabend@gmail.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v2 bpf-next 06/17] libbpf: xsk: use bpf_link
Message-ID: <20210322200922.GA56104@ranger.igk.intel.com>
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
 <20210311152910.56760-7-maciej.fijalkowski@intel.com>
 <CAEf4Bza-pGTS+vmE5SvuMtEptGxS5wSbW2d0K34nvt9StG3C8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4Bza-pGTS+vmE5SvuMtEptGxS5wSbW2d0K34nvt9StG3C8A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 10:34:11PM -0700, Andrii Nakryiko wrote:
> On Thu, Mar 11, 2021 at 7:42 AM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > Currently, if there are multiple xdpsock instances running on a single
> > interface and in case one of the instances is terminated, the rest of
> > them are left in an inoperable state due to the fact of unloaded XDP
> > prog from interface.
> >
> > Consider the scenario below:
> >
> > // load xdp prog and xskmap and add entry to xskmap at idx 10
> > $ sudo ./xdpsock -i ens801f0 -t -q 10
> >
> > // add entry to xskmap at idx 11
> > $ sudo ./xdpsock -i ens801f0 -t -q 11
> >
> > terminate one of the processes and another one is unable to work due to
> > the fact that the XDP prog was unloaded from interface.
> >
> > To address that, step away from setting bpf prog in favour of bpf_link.
> > This means that refcounting of BPF resources will be done automatically
> > by bpf_link itself.
> >
> > When setting up BPF resources during xsk socket creation, check whether
> > bpf_link for a given ifindex already exists via set of calls to
> > bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> > and comparing the ifindexes from bpf_link and xsk socket.
> >
> > If there's no bpf_link yet, create one for a given XDP prog. If bpf_link
> > is already at a given ifindex and underlying program is not AF-XDP one,
> > bail out or update the bpf_link's prog given the presence of
> > XDP_FLAGS_UPDATE_IF_NOEXIST.
> >
> > If there's netlink-based XDP prog running on a interface, bail out and
> > ask user to do removal by himself.
> >
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >  tools/lib/bpf/xsk.c | 139 ++++++++++++++++++++++++++++++++++++++------
> >  1 file changed, 120 insertions(+), 19 deletions(-)
> >
> 
> [...]
> 
> > +static int xsk_link_lookup(struct xsk_ctx *ctx, __u32 *prog_id)
> > +{
> > +       struct bpf_link_info link_info;
> > +       __u32 link_len;
> > +       __u32 id = 0;
> > +       int err;
> > +       int fd;
> > +
> > +       while (true) {
> > +               err = bpf_link_get_next_id(id, &id);
> > +               if (err) {
> > +                       if (errno == ENOENT) {
> > +                               err = 0;
> > +                               break;
> > +                       }
> > +                       pr_warn("can't get next link: %s\n", strerror(errno));
> > +                       break;
> > +               }
> > +
> > +               fd = bpf_link_get_fd_by_id(id);
> > +               if (fd < 0) {
> > +                       if (errno == ENOENT)
> > +                               continue;
> > +                       pr_warn("can't get link by id (%u): %s\n", id, strerror(errno));
> > +                       err = -errno;
> > +                       break;
> > +               }
> > +
> > +               link_len = sizeof(struct bpf_link_info);
> > +               memset(&link_info, 0, link_len);
> > +               err = bpf_obj_get_info_by_fd(fd, &link_info, &link_len);
> > +               if (err) {
> > +                       pr_warn("can't get link info: %s\n", strerror(errno));
> > +                       close(fd);
> > +                       break;
> > +               }
> > +               if (link_info.xdp.ifindex == ctx->ifindex) {
> 
> how do you know you are looking at XDP bpf_link? link_info.xdp.ifindex
> might as well be attach_type for tracing bpf_linke, netns_ino for
> netns bpf_link, and so on. Do check link_info.type before check other
> per-link type properties.

My mistake, good that you brought that up. I'll fix it.

> 
> > +                       ctx->link_fd = fd;
> > +                       *prog_id = link_info.prog_id;
> > +                       break;
> > +               }
> > +               close(fd);
> > +       }
> > +
> > +       return err;
> > +}
> > +
> >  static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
> >                                 int *xsks_map_fd)
> >  {
> > @@ -675,8 +777,7 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
> >         __u32 prog_id = 0;
> >         int err;
> >
> > -       err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id,
> > -                                 xsk->config.xdp_flags);
> > +       err = xsk_link_lookup(ctx, &prog_id);
> >         if (err)
> >                 return err;
> >
> > @@ -686,9 +787,12 @@ static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
> >                         return err;
> >
> >                 err = xsk_load_xdp_prog(xsk);
> > -               if (err) {
> > +               if (err)
> >                         goto err_load_xdp_prog;
> > -               }
> > +
> > +               err = xsk_create_bpf_link(xsk);
> > +               if (err)
> > +                       goto err_create_bpf_link;
> 
> what about the backwards compatibility with kernels that don't yet
> support bpf_link?

For that I'll be trying to create or lookup bpf_link on loopback device.
If it failed in any way, then use netlink based logic as the underlying
system doesn't support bpf_link.

Once again, thanks for catching it!

> 
> >         } else {
> >                 ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
> >                 if (ctx->prog_fd < 0)
> 
> [...]
