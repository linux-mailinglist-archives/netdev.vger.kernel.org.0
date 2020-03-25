Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECFF1921FF
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 08:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727356AbgCYHxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 03:53:01 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:45359 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgCYHxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 03:53:00 -0400
Received: by mail-oi1-f196.google.com with SMTP id l22so1224821oii.12;
        Wed, 25 Mar 2020 00:53:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GES48oHSY1Nd2O0lvCRAE6tTRjmq2R3zWeOpNWZv/6s=;
        b=nx6/3wHdIcOGSHAZyvMI0iFex4JsotJQ8TEghZnOvJ+UiVt8gY7r+VbuCH/Ll7tSuv
         AMgXWuWlyogKY3R5SLGI7HroboqCbBijY/fu65Dq6xI65PNEPZWOvroYo8lnm7TjgH64
         zEcoky3mGu/B9olZbjAa6Zkbh6RysN7VWkNbTO+xyErD2KNQQCpmul3gQqezwVOLpE4t
         IosheBgPLoglSuGiH+rEjhgQgTRvz3Z5lZuei9vJTkWo1sA6tSlysbYlopiWE6VGjWKy
         yAReMv2x7Cj4wo4u0q4weS6gs4him7Xlb62a2AKvT+1NxJlvSpgKbK7AMMA7cUslrjpU
         qKsQ==
X-Gm-Message-State: ANhLgQ0Gn6CoyUPhpa3MvZ+Gp/WcyD10yASdAuQh/hCsEW+hLUiissx6
        IWstWVeN9T3mWPv6di7AiL/LweYiM2qT1nmcmOkiQDG+
X-Google-Smtp-Source: ADFU+vtU+LhtZD1BFjienI4GJGjRNMAYuZdM/gxsuYm095k4wQaysCl8pIhASj79Lt78UKLt/MNSAKlkRQmV+YNNwns=
X-Received: by 2002:aca:4e57:: with SMTP id c84mr1539522oib.148.1585122780154;
 Wed, 25 Mar 2020 00:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200324161539.7538-1-masahiroy@kernel.org> <CAMuHMdWPNFRhUVGb0J27MZg2CrWWm06N9OQjQsGLMZkNXJktAg@mail.gmail.com>
 <CAK7LNAQFbcfK=q4eYW_dQUqe-sqbjpxSpQBeCkp0Vr4P3HJc7A@mail.gmail.com>
In-Reply-To: <CAK7LNAQFbcfK=q4eYW_dQUqe-sqbjpxSpQBeCkp0Vr4P3HJc7A@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 25 Mar 2020 08:52:49 +0100
Message-ID: <CAMuHMdXeOUu_zxKHXnNoLwyExy1GTp6N5UP2Neqyc8M3w2B8KQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: wan: wanxl: use $(CC68K) instead of $(AS68K) for
 rebuilding firmware
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild <linux-kbuild@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yamada-san,

On Wed, Mar 25, 2020 at 4:50 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
> On Wed, Mar 25, 2020 at 2:47 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, Mar 24, 2020 at 5:17 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> > > As far as I understood from the Kconfig help text, this build rule is
> > > used to rebuild the driver firmware, which runs on the QUICC, m68k-based
> > > Motorola 68360.
> > >
> > > The firmware source, wanxlfw.S, is currently compiled by the combo of
> > > $(CPP) and $(AS68K). This is not what we usually do for compiling *.S
> > > files. In fact, this is the only user of $(AS) in the kernel build.
> > >
> > > Moreover, $(CPP) is not likely to be a m68k tool because wanxl.c is a
> > > PCI driver, but CONFIG_M68K does not select CONFIG_HAVE_PCI.
> > > Instead of combining $(CPP) and (AS) from different tool sets, using
> > > single $(CC68K) seems simpler, and saner.
> > >
> > > After this commit, the firmware rebuild will require cc68k instead of
> > > as68k. I do not know how many people care about this, though.
> > >
> > > I do not have cc68k/ld68k in hand, but I was able to build it by using
> > > the kernel.org m68k toolchain. [1]
> >
> > Would this work with a "standard" m68k-linux-gnu-gcc toolchain, like
> > provided by Debian/Ubuntu, too?
> >
>
> Yes, I did 'sudo apt install gcc-8-m68k-linux-gnu'
> It successfully compiled this firmware.

Thanks for checking!

> In my understanding, the difference is that
> the kernel.org ones lack libc,
> so cannot link userspace programs.
>
> They do not make much difference for this case.

Indeed.

So perhaps it makes sense to replace cc68k and ld68k in the Makefile by
m68k-linux-gnu-gcc and m68k-linux-gnu-ld, as these are easier to get hold
of on a modern system?

What do you think?
Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
