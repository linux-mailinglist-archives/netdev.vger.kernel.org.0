Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E53835A9B7
	for <lists+netdev@lfdr.de>; Sat, 10 Apr 2021 02:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbhDJAyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 20:54:21 -0400
Received: from linux.microsoft.com ([13.77.154.182]:54460 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbhDJAyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 20:54:21 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by linux.microsoft.com (Postfix) with ESMTPSA id 3B89220B5686;
        Fri,  9 Apr 2021 17:54:07 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3B89220B5686
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618016047;
        bh=YIaUw8GsTkxvUHjwO9lRGpgu/KJQ54gZnBxZ+TdSfJw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CZKtxvUxFqSkkNr5qQsPn8Lpl4LzkuPzt9EmVVsEgG/38BkTSY05J0hbWGUYePo77
         QwrhHtjeyVgd1u60CY2Y1X1LWHuibNIfLC9AqLhdh/W1u5QQ9lgxzNjXNzH9Y2FZtp
         zgQ0HQUnbi7jKMtok6+EpsPYMePQHrRRWGV+dPbg=
Received: by mail-pj1-f43.google.com with SMTP id i4so3711170pjk.1;
        Fri, 09 Apr 2021 17:54:07 -0700 (PDT)
X-Gm-Message-State: AOAM533TDzv8Jire/hENrnEB4S3POQIvDbhpC2nvJgeAvIubVe9+MhXQ
        TAiTr3/X4UrXbuRyhtgyTcG26MJVdNXwEGQKQ5s=
X-Google-Smtp-Source: ABdhPJyKpaLpEOW0xQyVxvg5vLcqf11OLWvpeYvjIs+iW/wFSUHMJtf0GeRgcFGAAZZzJzGThfW0qXpoMH6XoWB/B7U=
X-Received: by 2002:a17:90a:5306:: with SMTP id x6mr11585905pjh.39.1618016046824;
 Fri, 09 Apr 2021 17:54:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210409180605.78599-1-mcroce@linux.microsoft.com>
 <20210409180605.78599-3-mcroce@linux.microsoft.com> <20210409115455.49e24450@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFnufp0fGEBHnuerrMVLaGUgAP3NYpiEMyW3R-AwDeG=R0sgHQ@mail.gmail.com> <20210409142808.11b479ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210409142808.11b479ea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Matteo Croce <mcroce@linux.microsoft.com>
Date:   Sat, 10 Apr 2021 02:53:30 +0200
X-Gmail-Original-Message-ID: <CAFnufp3tmRTDWXmMKqfDVEBAXHF4uenUoo-=gK4g+h1dj9HbKQ@mail.gmail.com>
Message-ID: <CAFnufp3tmRTDWXmMKqfDVEBAXHF4uenUoo-=gK4g+h1dj9HbKQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/3] net: use skb_for_each_frag() helper where possible
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 11:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 9 Apr 2021 22:44:50 +0200 Matteo Croce wrote:
> > > What pops to mind (although quite nit picky) is the question if the
> > > assembly changes much between driver which used to cache nr_frags and
> > > now always going skb_shinfo(skb)->nr_frags? It's a relatively common
> > > pattern.
> >
> > Since skb_shinfo() is a macro and skb_end_pointer() a static inline,
> > it should be the same, but I was curious to check so, this is a diff
> > between the following snippet before and afer the macro:
> >
> > int frags = skb_shinfo(skb)->nr_frags;
> > int i;
> > for (i = 0; i < frags; i++)
> >     kfree(skb->frags[i]);
> >
> >  1 file changed, 8 insertions(+), 7 deletions(-)
> >
> > --- ins1.s 2021-04-09 22:35:59.384523865 +0200
> > +++ ins2.s 2021-04-09 22:36:08.132594737 +0200
> > @@ -1,26 +1,27 @@
> >  iter:
> >          movsx   rax, DWORD PTR [rdi+16]
> >          mov     rdx, QWORD PTR [rdi+8]
> >          mov     eax, DWORD PTR [rdx+rax]
> >          test    eax, eax
> >          jle     .L6
> >          push    rbp
> > -        sub     eax, 1
> > +        mov     rbp, rdi
> >          push    rbx
> > -        lea     rbp, [rdi+32+rax*8]
> > -        lea     rbx, [rdi+24]
> > +        xor     ebx, ebx
> >          sub     rsp, 8
> >  .L3:
> > -        mov     rdi, QWORD PTR [rbx]
> > -        add     rbx, 8
> > +        mov     rdi, QWORD PTR [rbp+24+rbx*8]
> > +        add     rbx, 1
> >          call    kfree
> > -        cmp     rbx, rbp
> > -        jne     .L3
> > +        movsx   rax, DWORD PTR [rbp+16]
> > +        mov     rdx, QWORD PTR [rbp+8]
> > +        cmp     DWORD PTR [rdx+rax], ebx
> > +        jg      .L3
> >          add     rsp, 8
> >          xor     eax, eax
> >          pop     rbx
> >          pop     rbp
> >          ret
> >  .L6:
> >          xor     eax, eax
> >      for (i = 0; i < frags; i++)    ret
> >
>
> So looks like before compiler generated:
>
>         end = &frags[nfrags]
>         for (ptr = &frag[0]; ptr < end; ptr++)
>
> and now it has to use the actual value of i, read nfrags in the loop
> each time and compare it to i.
>
> That makes sense, since it can't prove kfree() doesn't change nr_frags.
>
> IDK if we care, but at least commit message should mention this.

Anyway, the chunks using a local nr_frags are too few and not worth it.
I think you're right and that's better to use the cached value, I see
the instructions here being ligther.
Drop the series, I will make a new one which only acts where
skb_shinfo(skb) is accessed.

Thanks,
-- 
per aspera ad upstream
