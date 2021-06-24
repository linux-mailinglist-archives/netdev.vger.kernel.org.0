Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3D23B3480
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 19:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhFXRQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 13:16:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhFXRQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 13:16:24 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30EEBC06175F
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 10:14:04 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id b64so327241yba.0
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 10:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZynrjufPb0jSWBmiQDCYm43xoHIOr1Pcd0UPmEqiYzs=;
        b=X7ifNAK588PIwlSrWSueFNohwkE/RahaPvp5zsMk8nDfCI+ZmmWrtVvjww17a62s7i
         bELR3CaTVaiAZhzIBsNjCtaPUObEs/xGCshsskxENPwbe12hydcuewXYuBLfkvUrTgnO
         2DyYcjxVl5bx9mYw1yYqKop2GkfVYCAtqsUP+MCoBIocDyMmADYmuhc3+M6RbSIZldU/
         aYHw4FmqJVaBexfuY+C587UbUvInHnK6jrXls+0FX0+qlWQHbk4snPIKWiazZrKXsD49
         sM+qXQ3n+1+4JP0RzwDjmg+jxOmNx1EN7g2RYelZI7d/QlyOVoKLk9u20RS+RktFyGYP
         rcJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZynrjufPb0jSWBmiQDCYm43xoHIOr1Pcd0UPmEqiYzs=;
        b=L13pQpClOdAzmrbblc5pmiyfwPvHt9VeH5HCy1z65legI515Afay85T7rCEWVi8Bkk
         bGBRNswAnx2Gt4Xy3Yrb37aySbhEYcfBj61gSiT2r0iZS/VEEDBGwINdNznhNZm+eiFO
         +W14JnkcyyLzm8tOc8pWvDl39MCwHuwcn387+30YrpJl7EMKk0DXCqHn51bFhsjS+kyo
         u6eZiM1JOy/xGwB8qAJdF0lIC594jNjHJydwrDCJE7D3gW6J46ZLe8l05OsMOUrfxhj+
         09TMG9RbHoMcHgNWHGBLjYnVlNlOKieoQayPOyT0adPzfLLZT6wqnLURcGfhxkNkHmlu
         wKHg==
X-Gm-Message-State: AOAM5307fauJ4mnRK1gqPJMS+lp6yqZEdo1Y9YXAceJgpJezDrkIXvyr
        ZiyLt8oWOm/Drk87WDNCSe9vuXLsEaI3+bVgLCwAUg==
X-Google-Smtp-Source: ABdhPJzi2xvOq/OdI/SIdW1SJcu8Slb0GfDddX7BFYare1xlGrbMSRuY416Wa734VhHGQ1aBjducvKcuLsQRzlX0V2k=
X-Received: by 2002:a25:9a45:: with SMTP id r5mr6313848ybo.450.1624554842953;
 Thu, 24 Jun 2021 10:14:02 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGfjLikQ6dg=YpBU0OeHvyv7JOki7CyOUS9modaXAi-9vQ@mail.gmail.com>
 <20210617000953.2787453-1-zenczykowski@gmail.com> <20210617000953.2787453-4-zenczykowski@gmail.com>
 <919e8f26-4b82-9d4c-8973-b2ab2b4bc5bf@iogearbox.net>
In-Reply-To: <919e8f26-4b82-9d4c-8973-b2ab2b4bc5bf@iogearbox.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Thu, 24 Jun 2021 10:13:50 -0700
Message-ID: <CANP3RGeLUCQKTiu-tK8WuUO6LyLaP5hJmgbD8Km2J-XU5RMfZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] bpf: more lenient bpf_skb_net_shrink()
 with BPF_F_ADJ_ROOM_FIXED_GSO
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 7:05 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 6/17/21 2:09 AM, Maciej =C5=BBenczykowski wrote:
> > From: Maciej =C5=BBenczykowski <maze@google.com>
> >
> > This is to more closely match behaviour of bpf_skb_change_proto()
> > which now does not adjust gso_size, and thus thoretically supports
> > all gso types, and does not need to set SKB_GSO_DODGY nor reset
> > gso_segs to zero.
> >
> > Something similar should probably be done with bpf_skb_net_grow(),
> > but that code scares me.
>
> Took in all except this one, would be good to have a complete solution fo=
r
> both bpf_skb_net_{shrink,grow}(). If you don't have the cycles, I'll look
> into it.
>
> Thanks,
> Daniel

I very much don't understand all the complexities of all the different
encap/tunneling
stuff that is handled in ..._grow().  In principle I think changing
the gso_size is
probably a bad idea in general, but I'm not at all sure that's a
change we can make now,
without breaking backward compatibility with some userspace somewhere
(not Android
though, we don't currently use either of these helpers yet) or causing
other trouble.

I'd love it if there was some truly good documentation of how all the
fields/offloads
in an skb interact, as I find myself constantly having to figure this
out via code examination,
and never feel like I really truly understand things (or perhaps some
helper function that would
'validate' an skb as well formed, ideally in debug mode we could call
it both before and after
a bpf program mucks with things and check it still passes).
I'm not sure who would be the expert here... you? Willem? Tom? someone else=
?
As such I'll leave this up to one of you.

I sent the patch for ..._shrink() because that one seemed simple enough.
(I don't really understand why shrink is so much simpler than grow...)

What I will try to send you is an extension to 4<->6 protocol
conversion to deal with the extra
8 bytes of overhead in an ipv6 fragment (48 instead of 40 byte header
converted to/from 20 byte ipv4 frag header).
Though this isn't something I even have ready atm, it's just on a todo
list as a relatively unimportant thing.

- Maciej
