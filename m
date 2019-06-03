Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4189632B78
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 11:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfFCJHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 05:07:22 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:39765 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbfFCJHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 05:07:21 -0400
Received: by mail-qk1-f193.google.com with SMTP id i125so10526087qkd.6;
        Mon, 03 Jun 2019 02:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TpN2IMkaqZR9JKC9Uw62Y/KnnrdZrzAYmMYX7zmcIbc=;
        b=VysH4d4SAUcfNj2ytxIUYdeSwZ0IwsW7oC0vFwGlQOvoXQsm/dQsaEpbZb5NpPeV+6
         JOTTCiy3RGg1frpd7cwefni7kSKZQiYovnaxkqfnCrxzx9RCPSi9mADveUzeYF67zlol
         8ewxHRGiM8MKx3IJCCGJub1TlCqAESe4LNE+Of9MiB1JDHzkwH9H8PN415lUkeh4Sefx
         u3Zj1s1jqH3Q7YK/imHvwlDSJeItwV0qxUdFh7IAXLv9CAewQxKrwHVaXMvVFY1rOE4T
         qwd9xFBTE7QbJHxWAqRlhtvE5MWdVY6LY6VkT0dSZ2QtGUlcPx93rGnPlBnJ7QX+BtsD
         eWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TpN2IMkaqZR9JKC9Uw62Y/KnnrdZrzAYmMYX7zmcIbc=;
        b=mbKxzXOdhFhLm20sxj69mPRMM9DWEEaDa0MnpuaZwTIUem819tAGDpwBqDnW+dDV+2
         Zqviib4lIgUbQQ+HLst7gHXDTO5WLBXN6/9P39SzdxKec79PZm1STnpoapUwaeDBlWY8
         /4elieZhjFFXaC8UbfluvJFo1yqI+Kl4ykMLQJZutKx4Dn8u27vVugbirz5bQGsnq+T6
         DoBai3jUpn9A4Sw+IZPNQbAReCk+H016cD14uglZCizSTYS0XCNTlKEEnSSVMDaQD0Rj
         dyaQ+pr87Sit35bsfMZeJ8h+j3ETcrTPR5gCRC1MqiN8b7zVZ9CJvkQwui7z26jcO6r0
         jhog==
X-Gm-Message-State: APjAAAVwFFc1UJlK3KadkgDxPytymPRLJD33CinNYHhpV0HvBL+j9p8+
        x8x+27nxfkXb+kPRcY/OlZW3vJOZMDJDm3naTeU=
X-Google-Smtp-Source: APXvYqwc8UnM4fScFzwkIZE1QxWpFivJUZLMCevLBjAF8GPbSxtpxHRB0roy0Pn6hOYa9XzS1j+gMPmLKSfvLMMgpEg=
X-Received: by 2002:a05:620a:158c:: with SMTP id d12mr20151538qkk.33.1559552840487;
 Mon, 03 Jun 2019 02:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190531094215.3729-1-bjorn.topel@gmail.com> <20190531094215.3729-2-bjorn.topel@gmail.com>
 <20190601130223.5ef947fa@cakuba.netronome.com>
In-Reply-To: <20190601130223.5ef947fa@cakuba.netronome.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 3 Jun 2019 11:07:08 +0200
Message-ID: <CAJ+HfNh-ifUqJHL61e7nQysZRCrKhNeX_mZ6Vn2D786-XEfm3g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW}
 to netdev
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Jun 2019 at 22:02, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 31 May 2019 11:42:14 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 44b47e9df94a..f3a875a52c6c 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1940,6 +1940,9 @@ struct net_device {
> >  #endif
> >       struct hlist_node       index_hlist;
> >
> > +     struct bpf_prog         *xdp_prog_hw;
>
> IDK if we should pay the cost of this pointer for every netdev on the
> system just for the single production driver out there that implements
> HW offload :(  I'm on the fence about this..
>

Hmm. Adding a config option? Keep the QUERY_PROG_HW?

> > +     u32                     xdp_flags;
> > +
> >  /*
> >   * Cache lines mostly used on transmit path
> >   */
>
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index adcc045952c2..5e396fd01d8b 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1360,42 +1360,44 @@ static int rtnl_fill_link_ifmap(struct sk_buff =
*skb, struct net_device *dev)
> >       return 0;
> >  }
> >
> > -static u32 rtnl_xdp_prog_skb(struct net_device *dev)
> > +static unsigned int rtnl_xdp_mode_to_flag(u8 tgt_mode)
> >  {
> > -     const struct bpf_prog *generic_xdp_prog;
> > -
> > -     ASSERT_RTNL();
> > -
> > -     generic_xdp_prog =3D rtnl_dereference(dev->xdp_prog);
> > -     if (!generic_xdp_prog)
> > -             return 0;
> > -     return generic_xdp_prog->aux->id;
> > -}
> > -
> > -static u32 rtnl_xdp_prog_drv(struct net_device *dev)
> > -{
> > -     return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf, XDP_QUERY_P=
ROG);
> > +     switch (tgt_mode) {
> > +     case XDP_ATTACHED_DRV:
> > +             return XDP_FLAGS_DRV_MODE;
> > +     case XDP_ATTACHED_SKB:
> > +             return XDP_FLAGS_SKB_MODE;
> > +     case XDP_ATTACHED_HW:
> > +             return XDP_FLAGS_HW_MODE;
> > +     }
> > +     return 0;
> >  }
> >
> > -static u32 rtnl_xdp_prog_hw(struct net_device *dev)
> > +static u32 rtnl_xdp_mode_to_attr(u8 tgt_mode)
> >  {
> > -     return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
> > -                            XDP_QUERY_PROG_HW);
> > +     switch (tgt_mode) {
> > +     case XDP_ATTACHED_DRV:
> > +             return IFLA_XDP_DRV_PROG_ID;
> > +     case XDP_ATTACHED_SKB:
> > +             return IFLA_XDP_SKB_PROG_ID;
> > +     case XDP_ATTACHED_HW:
> > +             return IFLA_XDP_HW_PROG_ID;
> > +     }
> > +     return 0;
> >  }
> >
> >  static int rtnl_xdp_report_one(struct sk_buff *skb, struct net_device =
*dev,
> > -                            u32 *prog_id, u8 *mode, u8 tgt_mode, u32 a=
ttr,
> > -                            u32 (*get_prog_id)(struct net_device *dev)=
)
> > +                            u32 *prog_id, u8 *mode, u8 tgt_mode)
> >  {
> >       u32 curr_id;
> >       int err;
> >
> > -     curr_id =3D get_prog_id(dev);
> > +     curr_id =3D dev_xdp_query(dev, rtnl_xdp_mode_to_flag(tgt_mode));
> >       if (!curr_id)
> >               return 0;
> >
> >       *prog_id =3D curr_id;
> > -     err =3D nla_put_u32(skb, attr, curr_id);
> > +     err =3D nla_put_u32(skb, rtnl_xdp_mode_to_attr(tgt_mode), curr_id=
);
> >       if (err)
> >               return err;
> >
> > @@ -1420,16 +1422,13 @@ static int rtnl_xdp_fill(struct sk_buff *skb, s=
truct net_device *dev)
> >
> >       prog_id =3D 0;
> >       mode =3D XDP_ATTACHED_NONE;
> > -     err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACH=
ED_SKB,
> > -                               IFLA_XDP_SKB_PROG_ID, rtnl_xdp_prog_skb=
);
> > +     err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACH=
ED_SKB);
> >       if (err)
> >               goto err_cancel;
> > -     err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACH=
ED_DRV,
> > -                               IFLA_XDP_DRV_PROG_ID, rtnl_xdp_prog_drv=
);
> > +     err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACH=
ED_DRV);
> >       if (err)
> >               goto err_cancel;
> > -     err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACH=
ED_HW,
> > -                               IFLA_XDP_HW_PROG_ID, rtnl_xdp_prog_hw);
> > +     err =3D rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACH=
ED_HW);
> >       if (err)
> >               goto err_cancel;
> >
>
> So you remove all the attr and flag params just to add a conversion
> helpers to get them based on mode?  Why?  Seems like unnecessary churn,
> and questionable change :S
>

Fair enough. I'll address this!

> Otherwise looks good to me!
