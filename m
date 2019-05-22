Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0ED2713B
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbfEVUy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:54:58 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42480 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729862AbfEVUy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:54:58 -0400
Received: by mail-qk1-f195.google.com with SMTP id f126so2434550qkc.9;
        Wed, 22 May 2019 13:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=K8EQ6RGt5l7qbnh3pvY2wn48usjI3/EEYd3xOjmQi7E=;
        b=S1hYdw+NfJW43Fu6YztG/4u3se3/GQUuFDgOEmCyworNUUJHHFvKtbLnKKu+H5OyG0
         YlYRv4z8xkmlbQbFOmOREe1wDJpZKiKhi4BPkihSvt0ID+0LUb0w4rR3nf4t3quJVX3+
         u41fpJrKqLkLnK9kAA3Ahqzx1yeJ2D82gw1a5M65VSCNrlyLfDVu4arWbKe5vi7RJ60H
         0V6QCmBSNis/MuLZq/TRYi6SFaSxTmSm2XmKA9L6w8ngIEQwzkxD4obpcX27XN4O5bzD
         74rP86Iz7vbf+FCetLH5EtIbe13/jSOo/FxQAkSFrS0W4LAcNGCDZzO/6UHgfVL0eyyt
         rZ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=K8EQ6RGt5l7qbnh3pvY2wn48usjI3/EEYd3xOjmQi7E=;
        b=sBCkmqgx+ULcDV+OwgLrFMklD4c7Wic5BHf0fKCxGwJfzpzxyjb25HBRtxCbLK0ZB6
         FHUnd81GiBbxzZVJ8ETg1AKKdLN/JHLSQb101iX04ZnI2W5cBYG2prbaJwmUMoKitZ83
         ozmcCrF6nSghvdDfNjK6hdpJgvMij3NFouVldZBSaQOTuqzoHFDzU3wsZA3ArG5peq5c
         ZKitDwqc5KLDIaOc/jPOjXE2cuu1TPZcA+uaQCT+nablLyMR+lvpAW7a0ypQe+vEhQip
         7mMgHnr0LSYHxLZLNYXretoMMyLVlz6nYHJ1+7By6eyHoVqIV6JB9KKQav2uGfRl7gue
         FMYA==
X-Gm-Message-State: APjAAAWjQUAAf4FxRpIeSSY/VobhTeLycFyR/bUXb/kEFur6jkV3NVRx
        atytftMLDRLO1c+JYYJ8GVsx9me3s4Hx07/mXEqNWrM2DSnQIQ==
X-Google-Smtp-Source: APXvYqwexldL3lu7foBSBRlSIzd/bFOEDHIwsypHTA7U0LSF1Emtpap+ymwd6FFMLaJB5cJ9hixuEMNrd7M0kFixR6w=
X-Received: by 2002:a05:620a:12c4:: with SMTP id e4mr58005343qkl.81.1558558495873;
 Wed, 22 May 2019 13:54:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190522125353.6106-1-bjorn.topel@gmail.com> <20190522125353.6106-2-bjorn.topel@gmail.com>
 <20190522113212.68aea474@cakuba.netronome.com>
In-Reply-To: <20190522113212.68aea474@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 22 May 2019 22:54:44 +0200
Message-ID: <CAJ+HfNiz5xbhxshWbLXyiLKDEz3ksU5jg54xxurN17=nVPetyg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 at 20:32, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Wed, 22 May 2019 14:53:51 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > All XDP capable drivers need to implement the XDP_QUERY_PROG{,_HW}
> > command of ndo_bpf. The query code is fairly generic. This commit
> > refactors the query code up from the drivers to the netdev level.
> >
> > The struct net_device has gained four new members tracking the XDP
> > program, the corresponding program flags, and which programs
> > (SKB_MODE, DRV_MODE or HW_MODE) that are activated.
> >
> > The xdp_prog member, previously only used for SKB_MODE, is shared with
> > DRV_MODE, since they are mutually exclusive.
> >
> > The program query operations is all done under the rtnl lock. However,
> > the xdp_prog member is __rcu annotated, and used in a lock-less manner
> > for the SKB_MODE. This is because the xdp_prog member is shared from a
> > query program perspective (again, SKB and DRV are mutual exclusive),
> > RCU read and assignments functions are still used when altering
> > xdp_prog, even when only for queries in DRV_MODE. This is for
> > sparse/lockdep correctness.
> >
> > A minor behavioral change was done during this refactorization; When
> > passing a negative file descriptor to a netdev to disable XDP, the
> > same program flag as the running program is required. An example.
> >
> > The eth0 is DRV_DRV capable. Previously, this was OK, but confusing:
> >
> >   # ip link set dev eth0 xdp obj foo.o sec main
> >   # ip link set dev eth0 xdpgeneric off
> >
> > Now, the same commands give:
> >
> >   # ip link set dev eth0 xdp obj foo.o sec main
> >   # ip link set dev eth0 xdpgeneric off
> >   Error: native and generic XDP can't be active at the same time.
>
> I'm not clear why this change is necessary? It is a change in
> behaviour, and if anything returning ENOENT would seem cleaner
> in this case.
>

To me, the existing behavior was non-intuitive. If most people *don't*
agree, I'll remove this change. So, what do people think about this?
:-)

ENOENT does make more sense.

> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
> >  include/linux/netdevice.h |  13 +++--
> >  net/core/dev.c            | 120 ++++++++++++++++++++------------------
> >  net/core/rtnetlink.c      |  33 ++---------
> >  3 files changed, 76 insertions(+), 90 deletions(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 44b47e9df94a..bdcb20a3946c 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1940,6 +1940,11 @@ struct net_device {
> >  #endif
> >       struct hlist_node       index_hlist;
> >
> > +     struct bpf_prog         *xdp_prog_hw;
> > +     unsigned int            xdp_flags;
> > +     u32                     xdp_prog_flags;
> > +     u32                     xdp_prog_hw_flags;
>
> Do we really need 3 xdp flags variables?  Offloaded programs
> realistically must have only the HW mode flag set (not sure if
> netdevsim still pretends we can do offload of code after rewrites,
> but if it does it can be changed :)).  Non-offloaded programs need
> flags, but we don't need the "all ORed" flags either, AFAICT.  No?
>

Good point, I'll try to reduce the netdev bloat.

> > +
> >  /*
> >   * Cache lines mostly used on transmit path
> >   */
> > @@ -2045,9 +2050,8 @@ struct net_device {
> >
> >  static inline bool netif_elide_gro(const struct net_device *dev)
> >  {
> > -     if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
> > -             return true;
> > -     return false;
> > +     return !(dev->features & NETIF_F_GRO) ||
> > +             dev->xdp_flags & XDP_FLAGS_SKB_MODE;
> >  }
> >
> >  #define      NETDEV_ALIGN            32
> > @@ -3684,8 +3688,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buf=
f *skb, struct net_device *dev,
> >  typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf=
);
> >  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *=
extack,
> >                     int fd, u32 flags);
> > -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
> > -                 enum bpf_netdev_command cmd);
> > +u32 dev_xdp_query(struct net_device *dev, unsigned int flags);
> >  int xdp_umem_query(struct net_device *dev, u16 queue_id);
> >
> >  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> > diff --git a/net/core/dev.c b/net/core/dev.c
> > index b6b8505cfb3e..ead16c3f955c 100644
> > --- a/net/core/dev.c
> > +++ b/net/core/dev.c
> > @@ -8005,31 +8005,31 @@ int dev_change_proto_down_generic(struct net_de=
vice *dev, bool proto_down)
> >  }
> >  EXPORT_SYMBOL(dev_change_proto_down_generic);
> >
> > -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
> > -                 enum bpf_netdev_command cmd)
> > +u32 dev_xdp_query(struct net_device *dev, unsigned int flags)
>
> You only pass the mode here, so perhaps rename the flags argument to
> mode?
>
> >  {
> > -     struct netdev_bpf xdp;
> > +     struct bpf_prog *prog =3D NULL;
> >
> > -     if (!bpf_op)
> > +     if (hweight32(flags) !=3D 1)
> >               return 0;
>
> This looks superfluous, given callers will always pass mode, right?
>
> > -     memset(&xdp, 0, sizeof(xdp));
> > -     xdp.command =3D cmd;
> > -
> > -     /* Query must always succeed. */
> > -     WARN_ON(bpf_op(dev, &xdp) < 0 && cmd =3D=3D XDP_QUERY_PROG);
> > +     if (flags & (XDP_FLAGS_SKB_MODE | XDP_FLAGS_DRV_MODE))
> > +             prog =3D rtnl_dereference(dev->xdp_prog);
> > +     else if (flags & XDP_FLAGS_HW_MODE)
> > +             prog =3D dev->xdp_prog_hw;
>
> Perhaps use a switch statement here?
>
> > -     return xdp.prog_id;
> > +     return prog ? prog->aux->id : 0;
> >  }
> >
> > -static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
> > +static int dev_xdp_install(struct net_device *dev, unsigned int target=
,
>
> Could you say mode instead of target everywhere?
>
> >                          struct netlink_ext_ack *extack, u32 flags,
> >                          struct bpf_prog *prog)
> >  {
> > +     bpf_op_t bpf_op =3D dev->netdev_ops->ndo_bpf;
>
> The point of passing bpf_op around is to have the right one (generic or
> driver) this is lost with the ternary statement below :S
>
> >       struct netdev_bpf xdp;
> > +     int err;
> >
> >       memset(&xdp, 0, sizeof(xdp));
> > -     if (flags & XDP_FLAGS_HW_MODE)
> > +     if (target =3D=3D XDP_FLAGS_HW_MODE)
>
> Is this change necessary?
>
> >               xdp.command =3D XDP_SETUP_PROG_HW;
> >       else
> >               xdp.command =3D XDP_SETUP_PROG;
> > @@ -8037,35 +8037,41 @@ static int dev_xdp_install(struct net_device *d=
ev, bpf_op_t bpf_op,
> >       xdp.flags =3D flags;
> >       xdp.prog =3D prog;
> >
> > -     return bpf_op(dev, &xdp);
> > +     err =3D (target =3D=3D XDP_FLAGS_SKB_MODE) ?
>
> Brackets unnecessary.
>
> > +           generic_xdp_install(dev, &xdp) :
> > +           bpf_op(dev, &xdp);
> > +     if (!err) {
>
> Keep success path unindented, save indentation.
>
>         if (err)
>                 return err;
>
>         bla bla
>
>         return 0;
>
> > +             if (prog)
> > +                     dev->xdp_flags |=3D target;
> > +             else
> > +                     dev->xdp_flags &=3D ~target;
>
> These "all ORed" flags are not needed, AFAICT, as mentioned above.
>
> > +             if (target =3D=3D XDP_FLAGS_HW_MODE) {
> > +                     dev->xdp_prog_hw =3D prog;
> > +                     dev->xdp_prog_hw_flags =3D flags;
> > +             } else if (target =3D=3D XDP_FLAGS_DRV_MODE) {
> > +                     rcu_assign_pointer(dev->xdp_prog, prog);
> > +                     dev->xdp_prog_flags =3D flags;
> > +             }
> > +     }
> > +
> > +     return err;
> >  }
> >
> >  static void dev_xdp_uninstall(struct net_device *dev)
> >  {
> > -     struct netdev_bpf xdp;
> > -     bpf_op_t ndo_bpf;
> > -
> > -     /* Remove generic XDP */
> > -     WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL))=
;
> > -
> > -     /* Remove from the driver */
> > -     ndo_bpf =3D dev->netdev_ops->ndo_bpf;
> > -     if (!ndo_bpf)
> > -             return;
> > -
> > -     memset(&xdp, 0, sizeof(xdp));
> > -     xdp.command =3D XDP_QUERY_PROG;
> > -     WARN_ON(ndo_bpf(dev, &xdp));
> > -     if (xdp.prog_id)
> > -             WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flag=
s,
> > -                                     NULL));
> > -
> > -     /* Remove HW offload */
> > -     memset(&xdp, 0, sizeof(xdp));
> > -     xdp.command =3D XDP_QUERY_PROG_HW;
> > -     if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
> > -             WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flag=
s,
> > -                                     NULL));
> > +     if (dev->xdp_flags & XDP_FLAGS_SKB_MODE) {
> > +             WARN_ON(dev_xdp_install(dev, XDP_FLAGS_SKB_MODE,
> > +                                     NULL, 0, NULL));
> > +     }
>
> Brackets unnecessary.
>
> > +     if (dev->xdp_flags & XDP_FLAGS_DRV_MODE) {
> > +             WARN_ON(dev_xdp_install(dev, XDP_FLAGS_DRV_MODE,
> > +                                     NULL, dev->xdp_prog_flags, NULL))=
;
> > +     }
>
> You should be able to just call install with the original flags, and
> install handler should do the right maths again to direct it either to
> drv or generic, no?
>
> > +     if (dev->xdp_flags & XDP_FLAGS_HW_MODE) {
> > +             WARN_ON(dev_xdp_install(dev, XDP_FLAGS_HW_MODE,
> > +                                     NULL, dev->xdp_prog_hw_flags, NUL=
L));
> > +     }
> >  }
> >
> >  /**
> > @@ -8080,41 +8086,41 @@ static void dev_xdp_uninstall(struct net_device=
 *dev)
> >  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *=
extack,
> >                     int fd, u32 flags)
> >  {
> > -     const struct net_device_ops *ops =3D dev->netdev_ops;
> > -     enum bpf_netdev_command query;
> > +     bool offload, drv_supp =3D !!dev->netdev_ops->ndo_bpf;
>
> Please avoid calculations in init.  If the function gets complicated
> this just ends up as a weirdly indented code, which is hard to read.
>
> >       struct bpf_prog *prog =3D NULL;
> > -     bpf_op_t bpf_op, bpf_chk;
> > -     bool offload;
> > +     unsigned int target;
> >       int err;
> >
> >       ASSERT_RTNL();
> >
> >       offload =3D flags & XDP_FLAGS_HW_MODE;
> > -     query =3D offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
> > +     target =3D offload ? XDP_FLAGS_HW_MODE : XDP_FLAGS_DRV_MODE;
> >
> > -     bpf_op =3D bpf_chk =3D ops->ndo_bpf;
> > -     if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))=
) {
> > +     if (!drv_supp && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE=
))) {
>
> Here you have a bracket for & inside an &&..
>
> >               NL_SET_ERR_MSG(extack, "underlying driver does not suppor=
t XDP in native mode");
> >               return -EOPNOTSUPP;
> >       }
> > -     if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
> > -             bpf_op =3D generic_xdp_install;
> > -     if (bpf_op =3D=3D bpf_chk)
> > -             bpf_chk =3D generic_xdp_install;
> > +
> > +     if (!drv_supp || (flags & XDP_FLAGS_SKB_MODE))
> > +             target =3D XDP_FLAGS_SKB_MODE;
> > +
> > +     if ((mode =3D=3D XDP_FLAGS_SKB_MODE &&
> > +          dev->xdp_flags & XDP_FLAGS_DRV_MODE) ||
>
> .. and here you don't :)
>
> > +         (target =3D=3D XDP_FLAGS_DRV_MODE &&
> > +          dev->xdp_flags & XDP_FLAGS_SKB_MODE)) {
>
> I think this condition can be shortened.  You can't get a conflict if
> the driver has no support.  So the only conflicting case is:
>
>         rcu_access_pointer(dev->xdp_prog) && drv_supp &&
>         (flags ^ dev->xdp_flags) & XDP_FLAGS_SKB_MODE
>
> > +             NL_SET_ERR_MSG(extack, "native and generic XDP can't be a=
ctive at the same time");
> > +             return -EEXIST;
> > +     }
> >
> >       if (fd >=3D 0) {
> > -             if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_P=
ROG)) {
> > -                     NL_SET_ERR_MSG(extack, "native and generic XDP ca=
n't be active at the same time");
> > -                     return -EEXIST;
> > -             }
> > -             if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) &&
> > -                 __dev_xdp_query(dev, bpf_op, query)) {
> > +             if (flags & XDP_FLAGS_UPDATE_IF_NOEXIST &&
> > +                 dev_xdp_query(dev, target)) {
> >                       NL_SET_ERR_MSG(extack, "XDP program already attac=
hed");
> >                       return -EBUSY;
> >               }
> >
> > -             prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
> > -                                          bpf_op =3D=3D ops->ndo_bpf);
> > +             prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP, drv=
_supp);
> > +
>
> Extra new line.
>
> >               if (IS_ERR(prog))
> >                       return PTR_ERR(prog);
> >
> > @@ -8125,7 +8131,7 @@ int dev_change_xdp_fd(struct net_device *dev, str=
uct netlink_ext_ack *extack,
> >               }
> >       }
> >
> > -     err =3D dev_xdp_install(dev, bpf_op, extack, flags, prog);
> > +     err =3D dev_xdp_install(dev, target, extack, flags, prog);
> >       if (err < 0 && prog)
> >               bpf_prog_put(prog);
> >
>
> I think apart from returning the new error it looks functionally
> correct :)

Thanks for the review, Jakub. Very valuable. I'll address all your
comments in the v3!


Cheers,
Bj=C3=B6rn
