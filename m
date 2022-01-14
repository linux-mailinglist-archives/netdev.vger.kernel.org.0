Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD93D48EDA6
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243092AbiANQIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:08:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53226 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235975AbiANQIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:08:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2034AB8295B;
        Fri, 14 Jan 2022 16:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85631C36AE5;
        Fri, 14 Jan 2022 16:08:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="hDSUo+JS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642176489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XoNUXMlaRqSo24jNIM6x457GTTkIBsbsy3/xGdNoalA=;
        b=hDSUo+JSm4fTUnqQuKoBzcj4s5AQotzneqf9qiUme6TdpQHHx1K5IUI6AMnHRsdYqtK0KI
        nt9CEVmGTx5D2MKkx00+x++Wfzdo7EPVyP8PuskmZ1isyip1Tf1lMUU01+21X409M+8BJ/
        2iwR//63+rOWaVYTVOwpcoe1hwOYVy4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7e8d5275 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 14 Jan 2022 16:08:09 +0000 (UTC)
Received: by mail-yb1-f177.google.com with SMTP id v186so25183225ybg.1;
        Fri, 14 Jan 2022 08:08:08 -0800 (PST)
X-Gm-Message-State: AOAM531ibQ2WEeWXeJ2tTjKwBN4xV2wJkzFCAI9GCRLc4jgVhu76zled
        yXgY9U6tFoXanky2Pt5xofldSeoXZT/IGKLSp3k=
X-Google-Smtp-Source: ABdhPJwGHZubbMwimiyTKVZS5c/4gn9gtnOaoqmNV1fWQS9PD37kKZRkuLqJFdbKfzhQARBKDrL8wWD0WBXScsUTNCs=
X-Received: by 2002:a25:aae2:: with SMTP id t89mr13844397ybi.638.1642176487356;
 Fri, 14 Jan 2022 08:08:07 -0800 (PST)
MIME-Version: 1.0
References: <20220112131204.800307-1-Jason@zx2c4.com> <20220112131204.800307-3-Jason@zx2c4.com>
 <87r19cftbr.fsf@toke.dk> <CAHmME9pieaBBhKc1uKABjTmeKAL_t-CZa_WjCVnUr_Y1_D7A0g@mail.gmail.com>
 <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
In-Reply-To: <55d185a8-31ea-51d0-d9be-debd490cd204@stressinduktion.org>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Jan 2022 17:07:56 +0100
X-Gmail-Original-Message-ID: <CAHmME9pR+qTn72vyANq8Nxx0BtGy7a_+dRvZS_F7RCag8Rvxng@mail.gmail.com>
Message-ID: <CAHmME9pR+qTn72vyANq8Nxx0BtGy7a_+dRvZS_F7RCag8Rvxng@mail.gmail.com>
Subject: Re: [PATCH RFC v1 2/3] ipv6: move from sha1 to blake2s in address calculation
To:     Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Erik Kline <ek@google.com>,
        Fernando Gont <fgont@si6networks.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        YOSHIFUJI Hideaki <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hannes,

On Thu, Jan 13, 2022 at 12:15 PM Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> > I'm not even so sure that's true. That was my worry at first, but
> > actually, looking at this more closely, DAD means that the address can
> > be changed anyway - a byte counter is hashed in - so there's no
> > guarantee there.
>
> The duplicate address detection counter is a way to merely provide basic
> network connectivity in case of duplicate addresses on the network
> (maybe some kind misconfiguration or L2 attack). Such detected addresses
> would show up in the kernel log and an administrator should investigate
> and clean up the situation.

I don't mean to belabor a point where I'm likely wrong anyway, but
this DAD business has kept me thinking...

Attacker is hanging out on the network sending DAD responses, forcing
those counters to increment, and thus making SHA1(stuff || counter)
result in a different IPv6 address than usual. Outcomes:
1) The administrator cannot handle this, did not understand the
semantics of this address generation feature, and will now have a
broken network;
2) The administrator knows what he's doing, and will be able to handle
a different IPv6 address coming up.

Do we really care about case (1)? That sounds like emacs spacebar
heating https://xkcd.com/1172/. And case (2) seems like something that
would tolerate us changing the hash function.

> Afterwards bringing the interface down and
> up again should revert the interface to its initial (dad_counter == 0)
> address.

Except the attacker is still on the network, and the administrator
can't figure it out because the mac addresses keep changing and it's
arriving from seemingly random switches! Plot twist: the attack is
being conducted from an implant in the switch firmware. There are a
lot of creative different takes on the same basic scenario. The point
is - the administrator really _can't_ rely on the address always being
the same, because it's simply out of his control.

Given that the admin already *must* be prepared for the address to
change, doesn't that give us some leeway to change the algorithm used
between kernels?

Or to put it differently, are there _actually_ braindead deployments
out there that truly rely on the address never ever changing, and
should we be going out of our way to support what is arguably a
misreading and misdeployment of the feature?

(Feel free to smack this line of argumentation down if you disagree. I
just thought it should be a bit more thoroughly explored.)

Jason
