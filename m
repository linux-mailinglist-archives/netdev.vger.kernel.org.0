Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB6B341D5A
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 13:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCSMuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 08:50:19 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:22745 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhCSMt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 08:49:59 -0400
Date:   Fri, 19 Mar 2021 12:49:48 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616158197; bh=c8MK4wemP9LsmYATwXJkPDvV2Nqmt21hm9TQxyvidIQ=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=T7ygbLdJIU0GyN/vltBR2CSoEBqJ3+ptrs2jShxPnh8ZrGNOkfyLcq8pxH5OQZDNR
         nrIiZbFEhqnWqwJ/Fcj2/rGGOsmHHpK/hB7njmGTWP1XhMaflcyBTxb83+d5nFzIYe
         FMF7OHufJXFXK9EP+pjw3GEQIXOdjrEfUY1sBhOaT0VE80XLgPakc1kIIuejo3qlBa
         wPdTl8XuaklSm6Ra+8Q5NZGa9AzsX6r0vqTuTmIv7XKMCONBr9V8rZaKA9b4/Agx4V
         DDb0DoFNA/U16Ph+yVyBvY5lvMJij64Wp3mAd1P72gK9agGBpCYTouBfZmb81oauM2
         nWpSPPtXbE+2w==
To:     Paolo Abeni <pabeni@redhat.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Leon Romanovsky <leon@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH net-next 2/4] gro: add combined call_gro_receive() + INDIRECT_CALL_INET() helper
Message-ID: <20210319124940.111546-1-alobakin@pm.me>
In-Reply-To: <5c1fce37033e98e483728ea9879c3cf4ae83aa28.camel@redhat.com>
References: <20210318184157.700604-1-alobakin@pm.me> <20210318184157.700604-3-alobakin@pm.me> <1ebd301832ff86cc414dd17eee0b3dfc91ff3c08.camel@redhat.com> <20210319111315.3069-1-alobakin@pm.me> <20210319114300.108808-1-alobakin@pm.me> <5c1fce37033e98e483728ea9879c3cf4ae83aa28.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 19 Mar 2021 13:35:41 +0100

> On Fri, 2021-03-19 at 11:43 +0000, Alexander Lobakin wrote:
> > I'm not sure if you did it on purpose in commit aaa5d90b395a7
> > ("net: use indirect call wrappers at GRO network layer").
> > Was that intentional
>
> I must admit that 2y+ later my own intentions are not so clear to me
> too;)

Heh, know that feel (=3D

> > for the sake of more optimized path for the
> > kernels with moduled IPv6,
>
> Uhm... no I guess that was more an underlook on my side.
>
> > or I can replace INDIRECT_CALL_INET()
> > with INDIRECT_CALL_2() here too?
>
> If that build with IPV6=3Dnmy, I would say yes.

I think you used INDIRECT_CALL_INET() to protect from CONFIG_INET=3Dn.
But this also hurts with retpoline when CONFIG_IPV6=3Dm. Not so common
case, but still.

Plain INDIRECT_CALL_2() won't build without CONFIG_INET, so we either
introduce a new one (e.g. _INET_2() similarly to _INET_1()), or leave
it as it is for now (Dave's already picked this series to net-next).

> > I want to keep GRO callbacks that
> > make use of indirect call wrappers unified.
>
> L4 will still need some special handling as ipv6 udp gro callbacks are
> not builtin with CONFIG_IPV6=3Dm :(

Yep, I remember. I meant {inet,ipv6}_gro_{complete,receive}()
callers, but didn't mention that for some reason.

> Cheers,
>
> Paolo

Thanks,
Al

