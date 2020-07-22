Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 482C022A068
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 22:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732666AbgGVUBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 16:01:07 -0400
Received: from mga03.intel.com ([134.134.136.65]:63143 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbgGVUBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 16:01:07 -0400
IronPort-SDR: qhbFdFVDvUTcSfOHn12ZfcA/Ah9lBTLFGI3kggBg/oxXmQbAIfVFTz3/byr8zKbhSIuR9Qm/4V
 6gb5dRIZidrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9690"; a="150389518"
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="150389518"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2020 13:01:05 -0700
IronPort-SDR: /BvLGJMSc5Yh8+TaMEU0l3tT0YmcPSZTqcxdkH35vlgcWlc1STe0WrUYdW0DG0JXLeL5gnIEon
 PFsG1q8Y+5Vg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,383,1589266800"; 
   d="scan'208";a="270846628"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 22 Jul 2020 13:01:01 -0700
Date:   Wed, 22 Jul 2020 21:56:04 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/9] bpf, xdp: maintain info on attached XDP
 BPF programs in net_device
Message-ID: <20200722195604.GD8874@ranger.igk.intel.com>
References: <20200722064603.3350758-1-andriin@fb.com>
 <20200722064603.3350758-3-andriin@fb.com>
 <20200722152604.GA8874@ranger.igk.intel.com>
 <CAEf4BzYTpxioRtuDM93JXxtn_K0F2y7hTnjs7EODp8_W7Phkwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYTpxioRtuDM93JXxtn_K0F2y7hTnjs7EODp8_W7Phkwg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 12:35:36PM -0700, Andrii Nakryiko wrote:
> On Wed, Jul 22, 2020 at 8:31 AM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Tue, Jul 21, 2020 at 11:45:55PM -0700, Andrii Nakryiko wrote:
> > > Instead of delegating to drivers, maintain information about which BPF
> > > programs are attached in which XDP modes (generic/skb, driver, or hardware)
> > > locally in net_device. This effectively obsoletes XDP_QUERY_PROG command.
> > >
> > > Such re-organization simplifies existing code already. But it also allows to
> > > further add bpf_link-based XDP attachments without drivers having to know
> > > about any of this at all, which seems like a good setup.
> > > XDP_SETUP_PROG/XDP_SETUP_PROG_HW are just low-level commands to driver to
> > > install/uninstall active BPF program. All the higher-level concerns about
> > > prog/link interaction will be contained within generic driver-agnostic logic.
> > >
> > > All the XDP_QUERY_PROG calls to driver in dev_xdp_uninstall() were removed.
> > > It's not clear for me why dev_xdp_uninstall() were passing previous prog_flags
> > > when resetting installed programs. That seems unnecessary, plus most drivers
> > > don't populate prog_flags anyways. Having XDP_SETUP_PROG vs XDP_SETUP_PROG_HW
> > > should be enough of an indicator of what is required of driver to correctly
> > > reset active BPF program. dev_xdp_uninstall() is also generalized as an
> > > iteration over all three supported mode.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  include/linux/netdevice.h |  17 +++-
> > >  net/core/dev.c            | 158 +++++++++++++++++++++-----------------
> > >  net/core/rtnetlink.c      |   5 +-
> > >  3 files changed, 105 insertions(+), 75 deletions(-)
> > >
> > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > index ac2cd3f49aba..cad44b40c776 100644
> > > --- a/include/linux/netdevice.h
> > > +++ b/include/linux/netdevice.h
> > > @@ -889,6 +889,17 @@ struct netlink_ext_ack;
> > >  struct xdp_umem;
> > >  struct xdp_dev_bulk_queue;
> > >
> > > +enum bpf_xdp_mode {
> > > +     XDP_MODE_SKB = 0,
> > > +     XDP_MODE_DRV = 1,
> > > +     XDP_MODE_HW = 2,
> > > +     __MAX_XDP_MODE
> > > +};
> > > +
> > > +struct bpf_xdp_entity {
> > > +     struct bpf_prog *prog;
> > > +};
> > > +
> 
> [...]
> 
> > >
> > > -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
> > > -                 enum bpf_netdev_command cmd)
> > > +static enum bpf_xdp_mode dev_xdp_mode(u32 flags)
> > >  {
> > > -     struct netdev_bpf xdp;
> > > +     if (flags & XDP_FLAGS_HW_MODE)
> > > +             return XDP_MODE_HW;
> > > +     if (flags & XDP_FLAGS_DRV_MODE)
> > > +             return XDP_MODE_DRV;
> > > +     return XDP_MODE_SKB;
> > > +}
> > >
> > > -     if (!bpf_op)
> > > -             return 0;
> > > +static bpf_op_t dev_xdp_bpf_op(struct net_device *dev, enum bpf_xdp_mode mode)
> > > +{
> > > +     switch (mode) {
> > > +     case XDP_MODE_SKB:
> > > +             return generic_xdp_install;
> > > +     case XDP_MODE_DRV:
> > > +     case XDP_MODE_HW:
> > > +             return dev->netdev_ops->ndo_bpf;
> > > +     default:
> > > +             return NULL;
> > > +     };
> > > +}
> > >
> 
> [...]
> 
> > >
> > >  static void dev_xdp_uninstall(struct net_device *dev)
> > >  {
> > > -     struct netdev_bpf xdp;
> > > -     bpf_op_t ndo_bpf;
> > > +     struct bpf_prog *prog;
> > > +     enum bpf_xdp_mode mode;
> > > +     bpf_op_t bpf_op;
> > >
> > > -     /* Remove generic XDP */
> > > -     WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
> > > +     ASSERT_RTNL();
> > >
> > > -     /* Remove from the driver */
> > > -     ndo_bpf = dev->netdev_ops->ndo_bpf;
> > > -     if (!ndo_bpf)
> > > -             return;
> > > +     for (mode = XDP_MODE_SKB; mode < __MAX_XDP_MODE; mode++) {
> > > +             prog = dev_xdp_prog(dev, mode);
> > > +             if (!prog)
> > > +                     continue;
> > >
> > > -     memset(&xdp, 0, sizeof(xdp));
> > > -     xdp.command = XDP_QUERY_PROG;
> > > -     WARN_ON(ndo_bpf(dev, &xdp));
> > > -     if (xdp.prog_id)
> > > -             WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
> > > -                                     NULL));
> > > +             bpf_op = dev_xdp_bpf_op(dev, mode);
> > > +             if (!bpf_op)
> > > +                     continue;
> >
> > could we assume that we are iterating over the defined XDP modes so bpf_op
> > will always be a valid function pointer so that we could use directly
> > dev_xdp_bpf_op() in dev_xdp_install() ?
> >
> > Just a nit, however current state is probably less error-prone when in
> > future we might be introducing new XDP mode.
> 
> No we can't because for DRV and HW modes, dev->netdev_ops->ndo_bpf can
> be NULL. So even though there are 3 possible XDP modes, only one (SKB,
> using generic_xdp_install handler) might be supported for a given
> net_device.

Thanks, I missed the fact about ndo_bpf being NULL. Comments below can be
ignored.

> 
> >
> > >
> > > -     /* Remove HW offload */
> > > -     memset(&xdp, 0, sizeof(xdp));
> > > -     xdp.command = XDP_QUERY_PROG_HW;
> > > -     if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
> > > -             WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
> > > -                                     NULL));
> > > +             WARN_ON(dev_xdp_install(dev, mode, bpf_op, NULL, 0, NULL));
> > > +
> > > +             bpf_prog_put(prog);
> > > +             dev_xdp_set_prog(dev, mode, NULL);
> > > +     }
> > >  }
> > >
> > >  /**
> > > @@ -8810,29 +8829,22 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
> > >                     int fd, int expected_fd, u32 flags)
> > >  {
> > >       const struct net_device_ops *ops = dev->netdev_ops;
> > > -     enum bpf_netdev_command query;
> > > +     enum bpf_xdp_mode mode = dev_xdp_mode(flags);
> > > +     bool offload = mode == XDP_MODE_HW;
> > >       u32 prog_id, expected_id = 0;
> > > -     bpf_op_t bpf_op, bpf_chk;
> > >       struct bpf_prog *prog;
> > > -     bool offload;
> > > +     bpf_op_t bpf_op;
> > >       int err;
> > >
> > >       ASSERT_RTNL();
> > >
> > > -     offload = flags & XDP_FLAGS_HW_MODE;
> > > -     query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
> > > -
> > > -     bpf_op = bpf_chk = ops->ndo_bpf;
> > > -     if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
> > > +     bpf_op = dev_xdp_bpf_op(dev, mode);
> > > +     if (!bpf_op) {
> > >               NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in native mode");
> > >               return -EOPNOTSUPP;
> > >       }
> >
> > Seems that we won't ever hit this case with this patch?
> > If flags are not drv/hw, then dev_xdp_mode() will always spit out the
> > XDP_MODE_SKB which then passed to dev_xdp_bpf_op() will in turn give the
> > generic_xdp_install().
> >
> 
> But flags can be drv/hw, in which case dev_xdp_bpf_op() will return
> dev->netdev_ops->ndo_bpf, which is NULL, so at that time we should
> emit error that driver doesn't support native mode.
> 
> > I think this check was against the situation where user wanted to go with
> > native mode but underlying HW was not supporting it, right?
> 
> right, and it's still the case.
> 
> >
> > So right now we will always be silently going with generic XDP?
> 
> No, please check dev_xdp_bpf_op() implementation again, it returns
> generic_xdp_install for SKB mode only.
> 
> >
> > I haven't followed previous revisions so I might be missing something.
> >
> > > -     if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
> > > -             bpf_op = generic_xdp_install;
> > > -     if (bpf_op == bpf_chk)
> > > -             bpf_chk = generic_xdp_install;
> > >
> > > -     prog_id = __dev_xdp_query(dev, bpf_op, query);
> > > +     prog_id = dev_xdp_prog_id(dev, mode);
> > >       if (flags & XDP_FLAGS_REPLACE) {
> > >               if (expected_fd >= 0) {
> > >                       prog = bpf_prog_get_type_dev(expected_fd,
> 
> [...]
