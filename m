Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F1B324B3F
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 08:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhBYH3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 02:29:17 -0500
Received: from mail-oi1-f179.google.com ([209.85.167.179]:46404 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbhBYH3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 02:29:08 -0500
Received: by mail-oi1-f179.google.com with SMTP id f3so5171358oiw.13;
        Wed, 24 Feb 2021 23:28:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3l1PKqMmtHsqelzh4HyKblC2FIVDbPFrPkrWcmQSfDE=;
        b=p6WCtXuObl4PWW6GxFG7eze62pAo+3KdGMr2vEzFcxVtyY8wTiADRi1YP+mHY/D8Zg
         e18w52BbppBRAgT+UVdoetTdqD2cCvEAUskTmaI6xFtDuDvEVgRuCKXO9wFQCaSeyQTW
         XTSqfDSa8X40QU0RIpd5P+0wEQgns9b8UGuWuRFpQ34LN3h8VOc4wOosrW0e7aXFSDZw
         PcCRtjGsc2eKVbxfo56BvQSszKLrTBn+6T/INNSIVx6R3eraoYGuDCH43JevnkMZAEws
         KOKcPn2xudrjkgDPH//EuES8X97ic6UpcJWvqTG8pamhjuHDHFcXkqbc6afyU+JLU6VB
         LD0Q==
X-Gm-Message-State: AOAM530K+Uuewz2gTj2XHIrmKu8WgpcdBQ4EOIS6VeUiOamKB6T5qWkn
        0CuPQKAXGpLR/psZxMjUIhkXTC1KTHpF/aeUydyv/jeHG+Q=
X-Google-Smtp-Source: ABdhPJxNmXEWS1bOFcz7Hp1UMcI4WMpgzN51MajctlPkUB8YxsFjwSIEOnTR6vBxTHQ71FHj8pnWRSkqzF3M22QyYiY=
X-Received: by 2002:aca:d8c6:: with SMTP id p189mr1118446oig.54.1614238107520;
 Wed, 24 Feb 2021 23:28:27 -0800 (PST)
MIME-Version: 1.0
References: <20210223112003.2223332-1-geert+renesas@glider.be> <20210224224358.pysql5pu23zt7mtb@skbuf>
In-Reply-To: <20210224224358.pysql5pu23zt7mtb@skbuf>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 25 Feb 2021 08:28:15 +0100
Message-ID: <CAMuHMdVeAoPK_iB=Y73X_7zTEJnS6bFKkzCe8QyH8oyZA9OZ5A@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: sja1105: Remove unneeded cast in sja1105_crc32()
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Wed, Feb 24, 2021 at 11:44 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Feb 23, 2021 at 12:20:03PM +0100, Geert Uytterhoeven wrote:
> > sja1105_unpack() takes a "const void *buf" as its first parameter, so
> > there is no need to cast away the "const" of the "buf" variable before
> > calling it.
> >
> > Drop the cast, as it prevents the compiler performing some checks.
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Thanks!

> By the way, your email went straight to my spam box, I just found the
> patch by mistake on patchwork.
>
>     Why is this message in spam?
>     It is in violation of Google's recommended email sender guidelines.

Yeah, sometimes Gmail can be annoying.  I recommend adding a filter
to never send emails with "PATCH" in the subject to spam.

> > Compile-tested only.
> >
> > BTW, sja1105_packing() and packing() are really bad APIs, as the input
> > pointer parameters cannot be const due to the direction depending on
> > "op".  This means the compiler cannot do const checks.  Worse, callers
> > are required to cast away constness to prevent the compiler from
> > issueing warnings.  Please don't do this!
> > ---
>
> What const checks can the compiler not do?

If you have a const and a non-const buffer, and accidentally call
packing() with the two buffer pointers exchanged (this is a common
mistake), you won't get a compiler warning.
So having separate pack() and unpack() functions would be safer.
You can rename packing() to __packing() to make it clear this function
is not to be called directly without deep consideration, and have
pack() and unpack() as wrappers just calling __packing().
Of course that means callers that do need a separate "op" parameter
still need to call __packing(), but they can provide their own safer
wrappers, too.

> Also, if you know of an existing kernel API which can replace packing(),
> I'm all ears.

No idea.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
