Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4CE32EB6
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 13:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbfFCLeK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 3 Jun 2019 07:34:10 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39966 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727746AbfFCLeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 07:34:10 -0400
Received: by mail-ed1-f65.google.com with SMTP id r18so25431609edo.7
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 04:34:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=QfftXsSxGUjNS1CUTQP+MzBIOwUkvebSHjlv4bruNN4=;
        b=pchUDXUkA8Y3xGNCIAlraWmNps8xJMBdU0eRHhEyDj6Hg82jA4MjSky/9qRFz//IE0
         vFPtpo6QGjqQM1vpEV/UuYv0ve2L09nOQcYjQQHsSJn1r9Xd+KU/MTC7wKw2Ynms0ZF3
         6U9+X2dbWYQ6/NswpduHOmD154FrvV2VsXQGQ77HRcXhsENVaALZDYR7QiKZPh/96mlx
         rzfVIBadbozDJKlaYbgRatsH4h2MmFQfH43s85pEWOKGG3+H04rkK+eMtT3mKynQCk8O
         C4h0d5QQVN+OsIbcFKdblD9Dr81UAI92ba7T+5UpX1R8RBfmRAknm1pUB6sLc3FsSzi2
         W6+w==
X-Gm-Message-State: APjAAAVqMLQ+DHSjq9gaK4uWvz6tvjIs2rvdStaVh7g1X2642zOrvMKN
        T74qsJXBaD+ZJk2idromwu7oHA==
X-Google-Smtp-Source: APXvYqzmWgd1fWRNjszC3sd2BvbHI7BhrOQKhumlQesV0ZjaLyL7E+u39H5eN+7AHkVNoMUUUmSvVQ==
X-Received: by 2002:a05:6402:1717:: with SMTP id y23mr28621334edu.304.1559561648045;
        Mon, 03 Jun 2019 04:34:08 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id w20sm2548135eja.74.2019.06.03.04.34.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 04:34:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DEE3D1800F7; Mon,  3 Jun 2019 12:56:49 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        =?utf-8?B?Qmo=?= =?utf-8?B?w7ZybiBUw7ZwZWw=?= 
        <bjorn.topel@intel.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH bpf-next v2 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW} to netdev
In-Reply-To: <CAJ+HfNh-ifUqJHL61e7nQysZRCrKhNeX_mZ6Vn2D786-XEfm3g@mail.gmail.com>
References: <20190531094215.3729-1-bjorn.topel@gmail.com> <20190531094215.3729-2-bjorn.topel@gmail.com> <20190601130223.5ef947fa@cakuba.netronome.com> <CAJ+HfNh-ifUqJHL61e7nQysZRCrKhNeX_mZ6Vn2D786-XEfm3g@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 03 Jun 2019 12:56:49 +0200
Message-ID: <87muizgcni.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Björn Töpel <bjorn.topel@gmail.com> writes:

> On Sat, 1 Jun 2019 at 22:02, Jakub Kicinski
> <jakub.kicinski@netronome.com> wrote:
>>
>> On Fri, 31 May 2019 11:42:14 +0200, Björn Töpel wrote:
>> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
>> > index 44b47e9df94a..f3a875a52c6c 100644
>> > --- a/include/linux/netdevice.h
>> > +++ b/include/linux/netdevice.h
>> > @@ -1940,6 +1940,9 @@ struct net_device {
>> >  #endif
>> >       struct hlist_node       index_hlist;
>> >
>> > +     struct bpf_prog         *xdp_prog_hw;
>>
>> IDK if we should pay the cost of this pointer for every netdev on the
>> system just for the single production driver out there that implements
>> HW offload :(  I'm on the fence about this..
>>
>
> Hmm. Adding a config option? Keep the QUERY_PROG_HW?
>
>> > +     u32                     xdp_flags;
>> > +
>> >  /*
>> >   * Cache lines mostly used on transmit path
>> >   */
>>
>> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
>> > index adcc045952c2..5e396fd01d8b 100644
>> > --- a/net/core/rtnetlink.c
>> > +++ b/net/core/rtnetlink.c
>> > @@ -1360,42 +1360,44 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
>> >       return 0;
>> >  }
>> >
>> > -static u32 rtnl_xdp_prog_skb(struct net_device *dev)
>> > +static unsigned int rtnl_xdp_mode_to_flag(u8 tgt_mode)
>> >  {
>> > -     const struct bpf_prog *generic_xdp_prog;
>> > -
>> > -     ASSERT_RTNL();
>> > -
>> > -     generic_xdp_prog = rtnl_dereference(dev->xdp_prog);
>> > -     if (!generic_xdp_prog)
>> > -             return 0;
>> > -     return generic_xdp_prog->aux->id;
>> > -}
>> > -
>> > -static u32 rtnl_xdp_prog_drv(struct net_device *dev)
>> > -{
>> > -     return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf, XDP_QUERY_PROG);
>> > +     switch (tgt_mode) {
>> > +     case XDP_ATTACHED_DRV:
>> > +             return XDP_FLAGS_DRV_MODE;
>> > +     case XDP_ATTACHED_SKB:
>> > +             return XDP_FLAGS_SKB_MODE;
>> > +     case XDP_ATTACHED_HW:
>> > +             return XDP_FLAGS_HW_MODE;
>> > +     }
>> > +     return 0;
>> >  }
>> >
>> > -static u32 rtnl_xdp_prog_hw(struct net_device *dev)
>> > +static u32 rtnl_xdp_mode_to_attr(u8 tgt_mode)
>> >  {
>> > -     return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
>> > -                            XDP_QUERY_PROG_HW);
>> > +     switch (tgt_mode) {
>> > +     case XDP_ATTACHED_DRV:
>> > +             return IFLA_XDP_DRV_PROG_ID;
>> > +     case XDP_ATTACHED_SKB:
>> > +             return IFLA_XDP_SKB_PROG_ID;
>> > +     case XDP_ATTACHED_HW:
>> > +             return IFLA_XDP_HW_PROG_ID;
>> > +     }
>> > +     return 0;
>> >  }
>> >
>> >  static int rtnl_xdp_report_one(struct sk_buff *skb, struct net_device *dev,
>> > -                            u32 *prog_id, u8 *mode, u8 tgt_mode, u32 attr,
>> > -                            u32 (*get_prog_id)(struct net_device *dev))
>> > +                            u32 *prog_id, u8 *mode, u8 tgt_mode)
>> >  {
>> >       u32 curr_id;
>> >       int err;
>> >
>> > -     curr_id = get_prog_id(dev);
>> > +     curr_id = dev_xdp_query(dev, rtnl_xdp_mode_to_flag(tgt_mode));
>> >       if (!curr_id)
>> >               return 0;
>> >
>> >       *prog_id = curr_id;
>> > -     err = nla_put_u32(skb, attr, curr_id);
>> > +     err = nla_put_u32(skb, rtnl_xdp_mode_to_attr(tgt_mode), curr_id);
>> >       if (err)
>> >               return err;
>> >
>> > @@ -1420,16 +1422,13 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
>> >
>> >       prog_id = 0;
>> >       mode = XDP_ATTACHED_NONE;
>> > -     err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_SKB,
>> > -                               IFLA_XDP_SKB_PROG_ID, rtnl_xdp_prog_skb);
>> > +     err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_SKB);
>> >       if (err)
>> >               goto err_cancel;
>> > -     err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_DRV,
>> > -                               IFLA_XDP_DRV_PROG_ID, rtnl_xdp_prog_drv);
>> > +     err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_DRV);
>> >       if (err)
>> >               goto err_cancel;
>> > -     err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_HW,
>> > -                               IFLA_XDP_HW_PROG_ID, rtnl_xdp_prog_hw);
>> > +     err = rtnl_xdp_report_one(skb, dev, &prog_id, &mode, XDP_ATTACHED_HW);
>> >       if (err)
>> >               goto err_cancel;
>> >
>>
>> So you remove all the attr and flag params just to add a conversion
>> helpers to get them based on mode?  Why?  Seems like unnecessary churn,
>> and questionable change :S
>>
>
> Fair enough. I'll address this!

I think this was actually my idea, wasn't it? :)

My thought being that if you just do the minimal change here, we'll end
up with three empty wrapper functions, which we might as well just fold
into the caller...

-Toke
