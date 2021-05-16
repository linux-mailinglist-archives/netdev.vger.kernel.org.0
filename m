Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299A9381D83
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 11:04:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbhEPJFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 05:05:44 -0400
Received: from mail-ua1-f50.google.com ([209.85.222.50]:38882 "EHLO
        mail-ua1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhEPJFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 05:05:43 -0400
Received: by mail-ua1-f50.google.com with SMTP id k45so1141726uag.5;
        Sun, 16 May 2021 02:04:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PtdmExuunL6I47GcuCl9lENSjo5yazFWO+xZYZLpNig=;
        b=L/0IGamP5Ugf/Fcuob7CjzBixnjiGZe1aa1cPh6Zp3y05ZIZh23SS/vqIIhvmK+DCd
         W7HhtmSExT83+f2qWsJ+WeA/PShrbIUqlYYQ2bzSPATaMX0/CdTjU+kcuCvsJ5mWgnsU
         EBHfv5/uc6+SfixPQJbriV6QL2X9qVTFjXTytHEGZoKuYbSnY3nA+UpAg4Mdse39ad/S
         nrYT/ALfXLT95awkIAIVZGUe7eufemG7AvyyK3KcLafPD+OitVm/JnhoWoDbEJNoNc9T
         F9R8SAQjU1xZ5szdkCxOUYhLne56gEgeXw61CX2gDneokqFBT2+BOCkPQF9cAt9HBEkx
         R79A==
X-Gm-Message-State: AOAM530fPXWATlQo4RiawGS3g0YFnHxrvBQhWORTpiLu05yELPWqXSZR
        ur3hYRaUtw4nu/uPVKGrTPRkaTy9E6t2/Kn+F1U=
X-Google-Smtp-Source: ABdhPJxK3DYeQePlVbgeO7XqyfC5AFgcTM5ME/HtjYcIrDn+/XqI6pl1zvwgxXwih7+7VjttcAar2n0DEz3jwq/QyUE=
X-Received: by 2002:ab0:7705:: with SMTP id z5mr8869408uaq.2.1621155867307;
 Sun, 16 May 2021 02:04:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210515221320.1255291-1-arnd@kernel.org> <20210515221320.1255291-14-arnd@kernel.org>
 <d4e42d3-9920-8fe0-1a71-6c6de8585f4c@nippy.intranet>
In-Reply-To: <d4e42d3-9920-8fe0-1a71-6c6de8585f4c@nippy.intranet>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sun, 16 May 2021 11:04:15 +0200
Message-ID: <CAMuHMdUJGxyL0kcj06Uxsxmf6bDj4UO_YKZPsZfxtTxCBXf=xg@mail.gmail.com>
Subject: Re: [RFC 13/13] [net-next] 8390: xsurf100: avoid including lib8390.c
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Arnd Bergmann <arnd@kernel.org>, netdev <netdev@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Michael Schmitz <schmitzmic@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 16, 2021 at 6:24 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> On Sun, 16 May 2021, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > This driver always warns about unused functions because it includes
> > an file that it doesn't actually need:
>
> I don't think you can omit #include "lib8390.c" here without changing
> driver behaviour, because of the macros in effect.
>
> I think this change would need some actual testing unless you can show
> that the module binary does not change.

Michael posted a similar but different patch a while ago, involving
calling ax_NS8390_reinit():
https://lore.kernel.org/linux-m68k/1528604559-972-3-git-send-email-schmitzmic@gmail.com/

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
