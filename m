Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5706234B5CD
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 10:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhC0Jxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 05:53:41 -0400
Received: from mail-vk1-f177.google.com ([209.85.221.177]:38596 "EHLO
        mail-vk1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhC0Jxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Mar 2021 05:53:36 -0400
Received: by mail-vk1-f177.google.com with SMTP id d2so1738484vke.5;
        Sat, 27 Mar 2021 02:53:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ei4Zq2qQr5wPT1q7tW3R31IHQU2GQmJWy+Z1ULLx9Gg=;
        b=OkLeY0cPw8mDKwazvUX0w6b+iWhu1urtVNqJZOVYXwdr2dPj72hOz3d37xbfRIozVt
         rVEleMCPDw9hZTI/5kC/e8H4pprbTEJBu2gMUcVVf0ejC2un5Ob5LHrkESxsQ41KWzXl
         7HHoIq9z27U7X3jex9IjFmvAqq99BT81C0o1ze2iOklX/DFh4SDBVCL5eKne+csWYU4s
         gI4b9sFssbFuCT4f9kZ/PuFFTzWCPNmN0Gj6D8CNfvHhrVq3w6OQ91UtGenJlbVw79Kj
         cdjTrx48MKpi9HlIsBHPS/jAcPOZMLrHlnYK85EKt2dKtIS72Pbh0654B9eV5BPaBtLK
         uIxg==
X-Gm-Message-State: AOAM532pxuYKGaHXH8mBTRWGddo/600+9xjxIzn51Nji8cN4kp+xqL3Z
        l4ledvo6+LB7yhBuS9xR60M3f4cmBUlKee3gCEA=
X-Google-Smtp-Source: ABdhPJxMfRB9EQgbKTONIXI//NI1LJ+DDWdqsdomH9lWt8UmO3P7zTUYXoBpzwInwF0XUfc2xwK13k0b6GJnIk8K9qY=
X-Received: by 2002:a1f:b689:: with SMTP id g131mr10365672vkf.6.1616838815501;
 Sat, 27 Mar 2021 02:53:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210325223119.3991796-1-anthony.l.nguyen@intel.com>
 <20210325223119.3991796-2-anthony.l.nguyen@intel.com> <CAMuHMdXo_UOf_QLKSxtgm5ByvSAo_Uy_h2RTpy8B=xqdUGaBNQ@mail.gmail.com>
 <ce03118c-d368-def0-8a1f-8c3a770901d6@intel.com>
In-Reply-To: <ce03118c-d368-def0-8a1f-8c3a770901d6@intel.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 27 Mar 2021 10:53:23 +0100
Message-ID: <CAMuHMdW3BSkJXjSL5R4xuYv6Yb765U5zwBCLcsSW+zr_K7898g@mail.gmail.com>
Subject: Re: [PATCH net 1/4] virtchnl: Fix layout of RSS structures
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     anthony.l.nguyen@intel.com,
        Norbert Ciosek <norbertx.ciosek@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, sassmann@redhat.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Samudrala,

On Fri, Mar 26, 2021 at 11:45 PM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
> On 3/26/2021 1:06 AM, Geert Uytterhoeven wrote:
> > On Thu, Mar 25, 2021 at 11:29 PM Tony Nguyen <anthony.l.nguyen@intel.com> wrote:
> > From: Norbert Ciosek <norbertx.ciosek@intel.com>
> >
> > Remove padding from RSS structures. Previous layout
> > could lead to unwanted compiler optimizations
> > in loops when iterating over key and lut arrays.
> >
> > From an earlier private conversation with Mateusz, I understand the real
> > explanation is that key[] and lut[] must be at the end of the
> > structures, because they are used as flexible array members?
> >
> > Fixes: 65ece6de0114 ("virtchnl: Add missing explicit padding to structures")
> > Signed-off-by: Norbert Ciosek <norbertx.ciosek@intel.com>
> > Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> >
> > --- a/include/linux/avf/virtchnl.h
> > +++ b/include/linux/avf/virtchnl.h
> > @@ -476,7 +476,6 @@ struct virtchnl_rss_key {
> >         u16 vsi_id;
> >         u16 key_len;
> >         u8 key[1];         /* RSS hash key, packed bytes */
> > -       u8 pad[1];
> >  };
> >
> >  VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_rss_key);
> > @@ -485,7 +484,6 @@ struct virtchnl_rss_lut {
> >         u16 vsi_id;
> >         u16 lut_entries;
> >         u8 lut[1];        /* RSS lookup table */
> > -       u8 pad[1];
> >  };
> >
> > If you use a flexible array member, it should be declared without a size,
> > i.e.
> >
> >     u8 key[];
> >
> > Everything else is (trying to) fool the compiler, and leading to undefined
> > behavior, and people (re)adding explicit padding.
>
> This header file is shared across other OSes that use C++ that doesn't support
> flexible arrays. So the structures in this file use an array of size 1 as a last
> element to enable variable sized arrays.

I don't think it is accepted practice to have non-Linux-isms in
include/*linux*/avf/virtchnl.h header files.  Moreover, using a size
of 1 is counter-intuitive for people used to Linux kernel development,
and may lead to off-by-one errors in calculation of sizes.

If you insist on ignoring the above, this definitely deserves a
comment next to the member's declaration.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
