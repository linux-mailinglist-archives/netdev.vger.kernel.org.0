Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE40DF0AE
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbfJUO7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:59:50 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43667 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfJUO7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:59:50 -0400
Received: by mail-ot1-f65.google.com with SMTP id o44so11243198ota.10;
        Mon, 21 Oct 2019 07:59:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oQ9Hhq6j199wCYON733LhiZ9S9XG9VAo1ttmANYkXWA=;
        b=Le7yBPNn1HgcUk+NAnqBovP0IoRX++4CPA5QWcJiDyafjbBnc8CEb+RC9Lqmv4fqYm
         lkVHLsGCE+yfTwxruJ+mwQ66HjhkOnMHY0b3Kyx9iDFSDO0x/J8l1vgHTHWK/9Iq7Uqd
         /ey5RkiZb72THV6okeTKY0b6cedrRHmJpMy/KDptNEvQXOl4mVZq2bLH8/WKWC0mhHOn
         EEiChek5wGaRxtCZe2lffHdQlo/+2ir7/klarYNptRRCoGMPec18nFK5JIZxIX9EwSzY
         eRusUiRyJ2aTMuoNE72DpUdeXpo9teV/U+qUdeQxL/Mq9JL6d05NA0QeWrYQg6W1ukn/
         S06Q==
X-Gm-Message-State: APjAAAWVc1srt9fMz3TsLbcofwZsP8X13c+GB/MlLJlx0mb1wnrEiZnV
        3G6I/GNp40GdLth5GevdE1PzximVY7TN/9wAnXg=
X-Google-Smtp-Source: APXvYqzCov0X1UPjRitvXQeN6gJblYG138w3wiV1o43RbRbpx0942OOlVOzwt/sTEVsk+ESIGxOVEJBjKOJtFYVhrqo=
X-Received: by 2002:a05:6830:1544:: with SMTP id l4mr19010917otp.297.1571669989079;
 Mon, 21 Oct 2019 07:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20191021143742.14487-1-geert+renesas@glider.be>
 <20191021143742.14487-2-geert+renesas@glider.be> <20191021144548.GA41107@kroah.com>
In-Reply-To: <20191021144548.GA41107@kroah.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 21 Oct 2019 16:59:37 +0200
Message-ID: <CAMuHMdXdd87FwcHs0iQrjmLaAJPRC7P7ZByUhw+DkzZ6J+eGqw@mail.gmail.com>
Subject: Re: [PATCH 1/7] debugfs: Add debugfs_create_xul() for hexadecimal
 unsigned long
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Mon, Oct 21, 2019 at 4:45 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Oct 21, 2019 at 04:37:36PM +0200, Geert Uytterhoeven wrote:
> > The existing debugfs_create_ulong() function supports objects of
> > type "unsigned long", which are 32-bit or 64-bit depending on the
> > platform, in decimal form.  To format objects in hexadecimal, various
> > debugfs_create_x*() functions exist, but all of them take fixed-size
> > types.
> >
> > Add a debugfs helper for "unsigned long" objects in hexadecimal format.
> > This avoids the need for users to open-code the same, or introduce
> > bugs when casting the value pointer to "u32 *" or "u64 *" to call
> > debugfs_create_x{32,64}().
> >
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> >  include/linux/debugfs.h | 10 ++++++++++
> >  1 file changed, 10 insertions(+)
> >
> > diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
> > index 33690949b45d6904..d7b2aebcc277d65e 100644
> > --- a/include/linux/debugfs.h
> > +++ b/include/linux/debugfs.h
> > @@ -356,4 +356,14 @@ static inline ssize_t debugfs_write_file_bool(struct file *file,
> >
> >  #endif
> >
> > +static inline void debugfs_create_xul(const char *name, umode_t mode,
> > +                                   struct dentry *parent,
> > +                                   unsigned long *value)
> > +{
> > +     if (sizeof(*value) == sizeof(u32))
> > +             debugfs_create_x32(name, mode, parent, (u32 *)value);
> > +     else
> > +             debugfs_create_x64(name, mode, parent, (u64 *)value);
> > +}
>
> Looks sane, but can you add some kernel-doc comments here so that we can
> pull it into the debugfs documentation?  Also there is debugfs

Sure, will do.

> documentation in Documentation/filesystems/ so maybe also add this
> there?  I am going to be overhauling the debugfs documentation "soon"
> but it's at the lower part of my todo list, so it will take a while,
> might as well keep it up to date with new stuff added like this so that
> people don't get lost.

Right. Currently it already lacks debugfs_create_ulong(). Will add both
debugfs_create_ulong() and debugfs_create_xul().

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
