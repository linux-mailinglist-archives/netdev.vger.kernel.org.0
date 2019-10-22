Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6995EDFEEA
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 10:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388073AbfJVIDt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Oct 2019 04:03:49 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:42277 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387614AbfJVIDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 04:03:48 -0400
Received: by mail-oi1-f194.google.com with SMTP id i185so13383934oif.9;
        Tue, 22 Oct 2019 01:03:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FZ5NqMFCYGmllIJPScGfDyvZnsZelaNfZGPfOky3arY=;
        b=FyqW0a+oMbfO8s/MDh8ItoobSvBN53PhOlFwLpBkjkvQ1k4uAm1CmcCv/JmkZYTzHg
         Pb+pF0T3z5yVtBlBIz3cyH5SYKngxJITyXcU+anW9r3RbJXwpIJEsnuVpjAACYerTiF6
         uKIqSfVJZPuDRvIO8wb2TUPupf1enV/YA5IgnDFGppDAOdkaMXYXdIcD2G+h7r2zheSl
         rx+H9KWjRUS3XxhEa+u/JHhXF3mpms8iLOtndzdff8XaEwYX3xRFBHCshC2UYmuWWZ9f
         DZLBN9IcZgsmXbhFVxgsTkI65e+lxsVglUXR/EXTQwOBWPBb40cPwiIlMc1NQJ0f+dKI
         V5LQ==
X-Gm-Message-State: APjAAAUjXmC5zkRkk94Y9VWAeJZ/JP/zJQK7tNSt5yjzDB2DAGej8xH/
        pvWYSPmEMLuAqfZLW4ZmV8xHnG0bfKCfA+x0mRc=
X-Google-Smtp-Source: APXvYqzUG4qN2828x+balZ7XQHkCN61tn83nKFfVm4V+67gV79RTLeG4Xc/VY2KvLVqNFsT/NQt7RB7hJSVhMG7O6So=
X-Received: by 2002:a05:6808:3b4:: with SMTP id n20mr1733802oie.131.1571731427705;
 Tue, 22 Oct 2019 01:03:47 -0700 (PDT)
MIME-Version: 1.0
References: <20191021143742.14487-1-geert+renesas@glider.be>
 <20191021143742.14487-2-geert+renesas@glider.be> <0f91839d858fcb03435ebc85e61ee4e75371ff37.camel@perches.com>
In-Reply-To: <0f91839d858fcb03435ebc85e61ee4e75371ff37.camel@perches.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 22 Oct 2019 10:03:36 +0200
Message-ID: <CAMuHMdU4OhsK6Jvy406ZCM+OeGcfVB0b7ccsne9KdMZFLf=JqQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] debugfs: Add debugfs_create_xul() for hexadecimal
 unsigned long
To:     Joe Perches <joe@perches.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

On Mon, Oct 21, 2019 at 5:37 PM Joe Perches <joe@perches.com> wrote:
> On Mon, 2019-10-21 at 16:37 +0200, Geert Uytterhoeven wrote:
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
> []
> > diff --git a/include/linux/debugfs.h b/include/linux/debugfs.h
> []
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
>
> trivia: the casts are unnecessary.

They are necessary, in both calls (so using #ifdef as suggested below
won't help):

    include/linux/debugfs.h:375:42: error: passing argument 4 of
‘debugfs_create_x32’ from incompatible pointer type
[-Werror=incompatible-pointer-types]
       debugfs_create_x32(name, mode, parent, value);
                                              ^~~~~
    include/linux/debugfs.h:114:6: note: expected ‘u32 * {aka unsigned
int *}’ but argument is of type ‘long unsigned int *’
     void debugfs_create_x32(const char *name, umode_t mode, struct
dentry *parent,
          ^~~~~~~~~~~~~~~~~~
    include/linux/debugfs.h:377:42: error: passing argument 4 of
‘debugfs_create_x64’ from incompatible pointer type
[-Werror=incompatible-pointer-types]
       debugfs_create_x64(name, mode, parent, value);
                                              ^~~~~
    include/linux/debugfs.h:116:6: note: expected ‘u64 * {aka long
long unsigned int *}’ but argument is of type ‘long unsigned int *’
     void debugfs_create_x64(const char *name, umode_t mode, struct
dentry *parent,
          ^~~~~~~~~~~~~~~~~~

> This might be more sensible using #ifdef
>
> static inline void debugfs_create_xul(const char *name, umode_t mode,
>                                       struct dentry *parent,
>                                       unsigned long *value)
> {
> #if BITS_PER_LONG == 64
>         debugfs_create_x64(name, mode, parent, value);
> #else
>         debugfs_create_x32(name, mode, parent, value);
> #endif
> }

... at the expense of the compiler checking only one branch.

Just like "if (IS_ENABLED(CONFIG_<foo>)" (when possible) is preferred
over "#ifdef CONFIG_<foo>" because of compile-coverage, I think using
"if" here is better than using "#if".

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
