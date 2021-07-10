Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60093C3388
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 09:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbhGJHpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 03:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbhGJHpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 03:45:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1EFC0613DD;
        Sat, 10 Jul 2021 00:43:04 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v1so17533847edt.6;
        Sat, 10 Jul 2021 00:43:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GLa2V1U3q2i9jpHdzAxeaVhFKNGz4qErbg6tMTCuQlM=;
        b=hwvFLjO9V6jPRq14OnSgIr9aXQEoJ4HjB/r9g6DsmRglDzWV9jV9GNnQEOi8FFVq5B
         MV4kmR3aymr0uO2clYMd/mGN84jUZDD9NUSq3LGEcGDO9ZjC/ktuxcVn8GpU0K4iP800
         cICL9nbrsr2pq4Fln2HsvQO4dEc/zCIViUmDlRbLtcMUJrWnmMihs8wHpGV295AFR011
         T489ybhXy84QlHiXIlEg3Au/vKB+PVxR+eZGWquVDJzNK4Bv9BdUy2gZ4GRMh+lLF8ea
         r4IdmDlnDTw5ba0xCjcGC42nAIQ2uURgqAVdns/DpSyXXXgPNudUO0LbtwXRX2dFiuq6
         fsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GLa2V1U3q2i9jpHdzAxeaVhFKNGz4qErbg6tMTCuQlM=;
        b=BTtGeRLKtYab5TVd4FdLVR1KSL7d+QJK1r+gVT3GI4pDDLgHz6nDmVeRVGKk1h8tJq
         mblj9kP5PKGIiOrDeR/hECtcaP/KCrWY5udlrEHEC8SdGYZjnfSmAbhT3x2qARYM5ziU
         apZYA2pxXnIPkxlwuz9BCx+ryMltjaZ22vWUIkIGCfiTYCJ9MjSt1dtc0Yf9JeDsirvp
         uN6FptWKuwInOuH1PLbtj1ftgCFVLYmeRfnpH8v5t1VZCjC8EAiwFcwT8K9jJF/vujtf
         ZROGu24SHnVVNNlRTlwZJZVnsSarseyeJGEIlFyv+syFsvXTAJPCd334tKXpW70Mcar/
         9AhQ==
X-Gm-Message-State: AOAM531PyjAzboItyd9K0tL7tYD87Yi5WN3TjKThqZkX9G/gbEJfXmPL
        4SlZCW5mmwSOU5nnVYejN3dWxtaKc+z+yj3o51Y=
X-Google-Smtp-Source: ABdhPJygaPGM9QWRedQ0bZ2d8ENVvW6bQGinYW42KC4LvMgczsy6JZyjCe6e4FElghqeW+39SAFz5AHJr1zOeJlKGhg=
X-Received: by 2002:a05:6402:5114:: with SMTP id m20mr52997180edd.174.1625902983424;
 Sat, 10 Jul 2021 00:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1625900431.git.paskripkin@gmail.com> <cec894625531da243df3a9f05466b83e107e50d7.1625900431.git.paskripkin@gmail.com>
 <CAD-N9QWcOv0s4uzPW0kGk70tpkCjorQCKpa3RrtbxyMmSW5b=Q@mail.gmail.com> <20210710104052.1469c94a@gmail.com>
In-Reply-To: <20210710104052.1469c94a@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Sat, 10 Jul 2021 15:42:37 +0800
Message-ID: <CAD-N9QURhZ-YpspgbJ+BcPPZ6fYoba7-dQ+yHu7LH74ttm6uSw@mail.gmail.com>
Subject: Re: [PATCH 2/2] net: cipso: fix memory leak in cipso_v4_doi_free
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        "David S. Miller" <davem@davemloft.net>, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 3:41 PM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> On Sat, 10 Jul 2021 15:29:19 +0800
> Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>
> > On Sat, Jul 10, 2021 at 3:10 PM Pavel Skripkin <paskripkin@gmail.com>
> > wrote:
> > >
> > > When doi_def->type == CIPSO_V4_MAP_TRANS doi_def->map.std should
> > > be freed to avoid memory leak.
> > >
> > > Fail log:
> > >
> > > BUG: memory leak
> > > unreferenced object 0xffff88801b936d00 (size 64):
> > > comm "a.out", pid 8478, jiffies 4295042353 (age 15.260s)
> > > hex dump (first 32 bytes):
> > > 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> > > 00 00 00 00 15 b8 12 26 00 00 00 00 00 00 00 00  .......&........
> > > backtrace:
> > > netlbl_cipsov4_add (net/netlabel/netlabel_cipso_v4.c:145
> > > net/netlabel/netlabel_cipso_v4.c:416) genl_family_rcv_msg_doit
> > > (net/netlink/genetlink.c:741) genl_rcv_msg
> > > (net/netlink/genetlink.c:783 net/netlink/genetlink.c:800)
> > > netlink_rcv_skb (net/netlink/af_netlink.c:2505) genl_rcv
> > > (net/netlink/genetlink.c:813)
> > >
> > > Fixes: b1edeb102397 ("netlabel: Replace protocol/NetLabel linking
> > > with refrerence counts")
> > > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > > ---
> > >  net/ipv4/cipso_ipv4.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
> > > index bfaf327e9d12..e0480c6cebaa 100644
> > > --- a/net/ipv4/cipso_ipv4.c
> > > +++ b/net/ipv4/cipso_ipv4.c
> > > @@ -472,6 +472,7 @@ void cipso_v4_doi_free(struct cipso_v4_doi
> > > *doi_def) kfree(doi_def->map.std->lvl.local);
> > >                 kfree(doi_def->map.std->cat.cipso);
> > >                 kfree(doi_def->map.std->cat.local);
> > > +               kfree(doi_def->map.std);
> > >                 break;
> > >         }
> > >         kfree(doi_def);
> > > --
> >
> > Hi Paval,
> >
> > this patch is already merged by Paul. See [1] for more details.
> >
> > [1]
> > https://lore.kernel.org/netdev/CAHC9VhQZVOmy7n14nTSRGHzwN-y=E_JTUP+NpRCgD8rJN5sOGA@mail.gmail.com/T/
> >
>
>
> Hi, Dongliang!
>
> Thank you for the information. I'm wondering, can maintainer pick only 1
> patch from series, or I should send v2?

I don't know. Maybe you can wait for the reply of the maintainers.

>
>
>
> With regards,
> Pavel Skripkin
