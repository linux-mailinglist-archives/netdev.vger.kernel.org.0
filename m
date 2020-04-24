Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8548A1B7D55
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 19:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgDXRzA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 24 Apr 2020 13:55:00 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39538 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbgDXRzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 13:55:00 -0400
Received: by mail-ot1-f67.google.com with SMTP id m13so13856196otf.6;
        Fri, 24 Apr 2020 10:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zuGInC/Mu6yrfyua3ZXVt8I3phxBs6NPOwYz5n5f7xU=;
        b=S/ZFy3fdCvXu14+vEW3CZa+onNWAJggLuRR6SCBMMC7fqH5sOWBWX4O9s6LC4qjV/F
         12Wqjrw5koLIMZDEfs7j8yDkvFalDF/XEiN4IV3nI45FnQhz0gIOZP9a+3M7LEFFW6Y1
         XyttEvxs663yoBGB+7rjESJeNCDg8KolChv92C2r6oWh4qJBlo4hjNByXiGwGEsNrdwa
         N39/mnmAVh32FEHJ2OHobwo55e991ZD4Jt2lrLkb4ELs1dS5BN7Ofyf0hCi224rDprsE
         9lEfLYI3SNKqxwIo9s8YWaKfxPH8K2bCe2xsw2rDgKUwMJyQTU1CLJy91dWsluaXQhS4
         2dOA==
X-Gm-Message-State: AGi0PuZJl90D3A/fpyiq3BTb+VrxyPKc0Nnky65sTiihxQJT6zw2kw++
        l8gPbhH5lXIhK3+if5dBRHWBpYN/JZThML/QRhM=
X-Google-Smtp-Source: APiQypI0Vh2kcbER7bwZJANdbWBlq4ehgarHewAXA6cjBmAMId7cmL3VOu3UZmsGpAscSyGzUDkLt6t3r1jcWTdivOI=
X-Received: by 2002:aca:895:: with SMTP id 143mr7682697oii.153.1587750899078;
 Fri, 24 Apr 2020 10:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200424121051.5056-1-geert@linux-m68k.org> <d2c14a2d-4e7b-d36a-be90-e987b1ea6183@gmail.com>
 <CAMuHMdWVmP04cXEgAkOc9Qdb2Y2xjGd1YEOcMt7ehE70ZwdqjQ@mail.gmail.com> <87ftcs3k90.fsf@toke.dk>
In-Reply-To: <87ftcs3k90.fsf@toke.dk>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 24 Apr 2020 19:54:47 +0200
Message-ID: <CAMuHMdUpQ1h5gapkzoX191hgxSQ814TfwcuPAmm8hOKSwk0RHA@mail.gmail.com>
Subject: Re: [PATCH] net: openvswitch: use do_div() for 64-by-32 divisions:
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        netdev <netdev@vger.kernel.org>, dev@openvswitch.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On Fri, Apr 24, 2020 at 6:45 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
> > On Fri, Apr 24, 2020 at 5:05 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >> On 4/24/20 5:10 AM, Geert Uytterhoeven wrote:
> >> > On 32-bit architectures (e.g. m68k):
> >> >
> >> >     ERROR: modpost: "__udivdi3" [net/openvswitch/openvswitch.ko] undefined!
> >> >     ERROR: modpost: "__divdi3" [net/openvswitch/openvswitch.ko] undefined!
> >> >
> >> > Fixes: e57358873bb5d6ca ("net: openvswitch: use u64 for meter bucket")
> >> > Reported-by: noreply@ellerman.id.au
> >> > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >> > ---
> >> >  net/openvswitch/meter.c | 2 +-
> >> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >> >
> >> > diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> >> > index 915f31123f235c03..3498a5ab092ab2b8 100644
> >> > --- a/net/openvswitch/meter.c
> >> > +++ b/net/openvswitch/meter.c
> >> > @@ -393,7 +393,7 @@ static struct dp_meter *dp_meter_create(struct nlattr **a)
> >> >                * Start with a full bucket.
> >> >                */
> >> >               band->bucket = (band->burst_size + band->rate) * 1000ULL;
> >> > -             band_max_delta_t = band->bucket / band->rate;
> >> > +             band_max_delta_t = do_div(band->bucket, band->rate);
> >> >               if (band_max_delta_t > meter->max_delta_t)
> >> >                       meter->max_delta_t = band_max_delta_t;
> >> >               band++;
> >> >
> >>
> >> This is fascinating... Have you tested this patch ?
> >
> > Sorry, I should have said this is compile-tested only.
> >
> >> Please double check what do_div() return value is supposed to be !
> >
> > I do not have any openvswitch setups, let alone on the poor m68k box.
>
> I think what Eric is referring to is this, from the documentation of
> do_div:
>
>  * do_div - returns 2 values: calculate remainder and update new dividend
>  * @n: uint64_t dividend (will be updated)
>  * @base: uint32_t divisor
>  *
>  * Summary:
>  * ``uint32_t remainder = n % base;``
>  * ``n = n / base;``
>  *
>  * Return: (uint32_t)remainder

Oops, that was a serious brain fart. Sorry for that!

That should have been div_u64() instead of do_div().
Feel free to update my patch while applying, else I'll send a v2 later.

/me hides in a brown paper bag for the whole weekend...

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
