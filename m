Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE293150D2
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbhBINvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhBINtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 08:49:50 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20D3C061797;
        Tue,  9 Feb 2021 05:49:08 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a9so31540402ejr.2;
        Tue, 09 Feb 2021 05:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EFHWJqOuZ5oCfySHPR3lGIAEM6/c2S56gFx0hAWTits=;
        b=Ppv7Q7ejOG9vxA58OJEbZVdzNl7aX/qp2kwYiGA43KDSoKyQ/O+Xuo1h5pbXDi7Ihv
         m+nOm1oG/rMqw5wq7RA/qdEqVjoIzBBzxVOVhZbbSNNzSm59kmnQ8CrSYf4VHuABfoRz
         q7z+ZLHD5lB0VJIEvIG4s4hjEUscbocpcQ092Ui9Pqivm98hvHh+ji9xVq66RSU7/MIi
         iokQyZCNIaUO1P+vfSBagS6Mwol9B3pNSpFjPvzeq8LCtMnyJz1VgrLbQ1XpDeuRIbVj
         +asGO79iHe9LOxGKRC1ZCR8SMd6BhhNjnWuJFBbAV57WADu3Pxp1B+snMkjhRRPbILce
         GmtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EFHWJqOuZ5oCfySHPR3lGIAEM6/c2S56gFx0hAWTits=;
        b=fGfNVFWp464zCeDR6SJnDU8j1rXJO74woAm7MQfk5GjVP/xjI/T51eoCXKCYju700B
         /3okztziAcz1vAGKl6NBm77Vy87CNQnMcJKH8ol5GWqbE0lkzvQgR58SGWulX9renn+a
         3TtdysE9kvMQkI7DTnUUJN2corgsneM/Nu2nms7bQroz0CRPpqQoLvPwmpjRXuXle0dg
         3f/la18uNzRfD1XOMdM46TV1IgrX7Nx9U7HdbeCEYotoRkQWb7Qa5+No67blfT/vwBCb
         joWusy75c6MjFcSNaL9QJ3nEKRb77h2ADjsAklbOUp2K5LisOz/l/KGp5gRbstpr/1gn
         T55Q==
X-Gm-Message-State: AOAM5319f1A5g4H1PpaURxi/fXopv2wCqb8eqZmFFMUFdxdJklRaLgcz
        nwIl7EvPmZsHBTHFKP23/SpvVccPCT+OrfkxSDI=
X-Google-Smtp-Source: ABdhPJzW3Fvi8O1I3RdTpgDrVo+V4N7HeT6KVKLgNNjdyfYAbynwehos99I2n2hC2EeG6e4aVy/1iB1HAvNbc6zHnDs=
X-Received: by 2002:a17:906:158c:: with SMTP id k12mr22774572ejd.119.1612878542051;
 Tue, 09 Feb 2021 05:49:02 -0800 (PST)
MIME-Version: 1.0
References: <20210208113810.11118-1-hxseverything@gmail.com>
 <CA+FuTScScC2o6uDjua0T3Eucbjt8-YPf65h3xgxMpTtWvgjWmg@mail.gmail.com> <8552C5F8-8410-4E81-8AF4-7018878AFCDC@gmail.com>
In-Reply-To: <8552C5F8-8410-4E81-8AF4-7018878AFCDC@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 9 Feb 2021 08:48:26 -0500
Message-ID: <CAF=yD-LBLmGF5aZjTS_GJOY_CRKDeVShffsxqu00uy_tNYpL9w@mail.gmail.com>
Subject: Re: [PATCH] bpf: in bpf_skb_adjust_room correct inner protocol for vxlan
To:     =?UTF-8?B?6buE5a2m5qOu?= <hxseverything@gmail.com>
Cc:     David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        chengzhiyong <chengzhiyong@kuaishou.com>,
        wangli <wangli09@kuaishou.com>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 9, 2021 at 5:41 AM =E9=BB=84=E5=AD=A6=E6=A3=AE <hxseverything@g=
mail.com> wrote:
>
> Appreciate for your reply Willem!
>
> The original intention of this commit is that when we use bpf_skb_adjust_=
room  to encapsulate
> Vxlan packets, we find some powerful device features disabled.
>
> Setting the inner_protocol directly as skb->protocol is the root cause.
>
> I understand that it=E2=80=99s not easy to handle all tunnel protocol in =
one bpf helper function. But for my
> immature idea, when pushing Ethernet header, setting the inner_protocol a=
s ETH_P_TEB may
> be better.
>
> Now the flag BPF_F_ADJ_ROOM_ENCAP_L4_UDP includes many udp tunnel types( =
e.g.
> udp+mpls, geneve, vxlan). Adding an independent flag to represents Vxlan =
looks a little
> reduplicative. What=E2=80=99s your suggestion?

Agreed. I don't mean to add a vxlan specific flag.

Instead, a way to identify that the encapsulation includes a mac
header. To a certain extent, that already exists as of commit
58dfc900faff ("bpf: add layer 2 encap support to
bpf_skb_adjust_room"). That computes an inner_maclen. It makes sense
that inner_protocol needs to be updated if inner_maclen indicates a
mac header.

I would only not infer it based on some imprecise measure, such as
inner_maclen being 14. But add a new explicit flag
BPF_F_ADJ_ROOM_ENCAP_L2_ETH. Update inner protocol if the flag is
passed and inner_maclen >=3D ETH_HLEN. Fail the operation if the flag is
passed and inner_maclen is too short.

> Thanks again for your reply!
>
>
>
> > 2021=E5=B9=B42=E6=9C=888=E6=97=A5 =E4=B8=8B=E5=8D=889:06=EF=BC=8CWillem=
 de Bruijn <willemdebruijn.kernel@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Mon, Feb 8, 2021 at 7:16 AM huangxuesen <hxseverything@gmail.com> wr=
ote:
> >>
> >> From: huangxuesen <huangxuesen@kuaishou.com>
> >>
> >> When pushing vxlan tunnel header, set inner protocol as ETH_P_TEB in s=
kb
> >> to avoid HW device disabling udp tunnel segmentation offload, just lik=
e
> >> vxlan_build_skb does.
> >>
> >> Drivers for NIC may invoke vxlan_features_check to check the
> >> inner_protocol in skb for vxlan packets to decide whether to disable
> >> NETIF_F_GSO_MASK. Currently it sets inner_protocol as the original
> >> skb->protocol, that will make mlx5_core disable TSO and lead to huge
> >> performance degradation.
> >>
> >> Signed-off-by: huangxuesen <huangxuesen@kuaishou.com>
> >> Signed-off-by: chengzhiyong <chengzhiyong@kuaishou.com>
> >> Signed-off-by: wangli <wangli09@kuaishou.com>
> >> ---
> >> net/core/filter.c | 7 ++++++-
> >> 1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/net/core/filter.c b/net/core/filter.c
> >> index 255aeee72402..f8d3ba3fe10f 100644
> >> --- a/net/core/filter.c
> >> +++ b/net/core/filter.c
> >> @@ -3466,7 +3466,12 @@ static int bpf_skb_net_grow(struct sk_buff *skb=
, u32 off, u32 len_diff,
> >>                skb->inner_mac_header =3D inner_net - inner_mac_len;
> >>                skb->inner_network_header =3D inner_net;
> >>                skb->inner_transport_header =3D inner_trans;
> >> -               skb_set_inner_protocol(skb, skb->protocol);
> >> +
> >> +               if (flags & BPF_F_ADJ_ROOM_ENCAP_L4_UDP &&
> >> +                   inner_mac_len =3D=3D ETH_HLEN)
> >> +                       skb_set_inner_protocol(skb, htons(ETH_P_TEB));
> >
> > This may be used by vxlan, but it does not imply it.
> >
> > Adding ETH_HLEN bytes likely means pushing an Ethernet header, but same=
 point.
> >
> > Conversely, pushing an Ethernet header is not limited to UDP encap.
> >
> > This probably needs a new explicit BPF_F_ADJ_ROOM_.. flag, rather than
> > trying to infer from imprecise heuristics.
>
