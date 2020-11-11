Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A682AF903
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 20:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727442AbgKKT0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 14:26:21 -0500
Received: from mail-40136.protonmail.ch ([185.70.40.136]:54289 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgKKT0U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 14:26:20 -0500
Date:   Wed, 11 Nov 2020 19:26:14 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1605122778; bh=ZIGJsv6VuvrH6aqhvv1rHsUpskcyiznKXAa1hoxNvCs=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=K5fArzI38ps9TNjIyC/yfuMfwNSbHEkbFN0Swyu9QWnMaAup1vOTuq6ZC9hJZj6j7
         J+IV3NJDbuYZTBkXzBtj4WO0YXOP/o5aNbE9mPk50G3q/uJBzDwEE+UmjJgL5lZunW
         /0t//mBJhR1uweHvHISekwkTdNhGwvHRuL/AvHtdeJnvj+1UuKPnv1dBAC4+KitsKc
         II6PU+Gpm3es4OZPKyEVIZ68Qbj09BX8zZ39Jk9DyUFevvOhXP5VPYNjCNCctYJPLy
         EgugshrdqEuSb2yCUZ5usJfkZW/t/x/Aw7bmPDGU/n5i6mRZj76O8NN426EpME7yuT
         BC0OSJaG+GgLA==
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: Re: [PATCH v4 net] net: udp: fix Fast/frag0 UDP GRO
Message-ID: <95YTSkmAW8hn6cmmEKdJEAGj6Mn5r07PALzHZW4@cp7-web-044.plabs.ch>
In-Reply-To: <CA+FuTSfnRJF4_SoMtJz+B7Y5hePoA1OzA797zkmzJ0cYQ99iVw@mail.gmail.com>
References: <bEm19mEHLokLGc5HrEiEKEUgpZfmDYPoFtoLAAEnIUE@cp3-web-033.plabs.ch> <CA+FuTScriNKLu=q+xmBGjtBB06SbErZK26M+FPiJBRN-c8gVLw@mail.gmail.com> <zlsylwLJr9o9nP9fcmUnMBxSNs5tLc6rw2181IgE@cp7-web-041.plabs.ch> <20201111082658.4cd3bb1d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CA+FuTSfnRJF4_SoMtJz+B7Y5hePoA1OzA797zkmzJ0cYQ99iVw@mail.gmail.com>
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

From: Jakub Kicinski <kuba@kernel.org>

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 11 Nov 2020 12:28:21 -0500

> On Wed, Nov 11, 2020 at 11:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Wed, 11 Nov 2020 11:29:06 +0000 Alexander Lobakin wrote:
>>>>>> +     sk =3D static_branch_unlikely(&udp_encap_needed_key) ?
>>>>>> +          udp4_gro_lookup_skb(skb, uh->source, uh->dest) :
>>>>>> +          NULL;
>>>>
>>>> Does this indentation pass checkpatch?
>>>
>>> Sure, I always check my changes with checkpatch --strict.
>>>
>>>> Else, the line limit is no longer strict,a and this only shortens the
>>>> line, so a single line is fine.
>>>
>>> These single lines is about 120 chars, don't find them eye-pleasant.
>>> But, as with "u32" above, they're pure cosmetics and can be changed.
>>
>> let me chime in on the perhaps least important aspect of the patch :)
>>
>> Is there are reason to use a ternary operator here at all?
>> Isn't this cleaner when written with an if statement?
>>
>>         sk =3D NULL;
>>         if (static_branch_unlikely(&udp_encap_needed_key))
>>                 sk =3D udp4_gro_lookup_skb(skb, uh->source, uh->dest);

This idea came to me right after I submitted the last version
actually. Sure, there's absolutely no need to use a split ternary.

> Ah indeed :)
>
> One other thing I missed before. The socket lookup is actually an
> independent issue, introduced on commit a6024562ffd7 ("udp: Add GRO
> functions to UDP socket"). Should be a separate Fixes tag, perhaps
> even a separate patch.

Seems reasonable. I'll convert v5 to a pair.

Thanks,
Al

