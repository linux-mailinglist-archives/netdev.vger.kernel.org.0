Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7EB48ADEA
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 13:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240019AbiAKMvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 07:51:50 -0500
Received: from mail-vk1-f178.google.com ([209.85.221.178]:40449 "EHLO
        mail-vk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239653AbiAKMvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 07:51:49 -0500
Received: by mail-vk1-f178.google.com with SMTP id 78so10253519vkz.7;
        Tue, 11 Jan 2022 04:51:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ooKGf7RGEfbJN/l+F17gfotu+sbZFbeMAX/JFJAo0EQ=;
        b=Lxdh9w0vleGQs/U4UYbeubaM4+WE8Yn3kK+FyxmRFP6uO8w1GyyzKrujrdflEOIvX3
         2ofEwSJiz0P4eiuezh/dUD58xm6m293MHzytmsDbCQcRfRMQaTYwpRhT8fAtV2cECbVM
         KzuIwQftBvi7y6H+HPpNiyT7jFx2VKk8ipe0OwEZgwyS3V8MMmAQU9pJzURjyL2vHr3R
         fe8rJFZg3L8ROmAh8vk6dIfawG1iTVqEQZiQyz6RiXiyyKoIXpIxs/kJtzoMooW1X3mk
         9AHNxaduMEarlBwAZM2kdQvCGPETQwme4OT1fysFAivRDTVKp5+tMIswUH8Et89O2+WG
         oUGA==
X-Gm-Message-State: AOAM530xsxbr/0VzNGN72iuCDV8gMBNRVi/SGXuHbTXChDTe40Gvn8ZJ
        e+mOj6nEeTwFc5/Vhedg5bJDFpq0r5FdCw==
X-Google-Smtp-Source: ABdhPJyR8U904KSrfsEa9jdjW9fTngvw5YpkTC9y/+eMa4iL4va6bRxrbN1d1JDwAOE9UWyiCc68Kw==
X-Received: by 2002:a1f:3213:: with SMTP id y19mr1940708vky.7.1641905508697;
        Tue, 11 Jan 2022 04:51:48 -0800 (PST)
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com. [209.85.222.52])
        by smtp.gmail.com with ESMTPSA id q11sm5823031uaj.4.2022.01.11.04.51.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 04:51:48 -0800 (PST)
Received: by mail-ua1-f52.google.com with SMTP id v12so29447222uar.7;
        Tue, 11 Jan 2022 04:51:48 -0800 (PST)
X-Received: by 2002:a05:6102:21dc:: with SMTP id r28mr1805314vsg.57.1641905507900;
 Tue, 11 Jan 2022 04:51:47 -0800 (PST)
MIME-Version: 1.0
References: <20211223141113.1240679-1-Jason@zx2c4.com> <20211223141113.1240679-2-Jason@zx2c4.com>
 <CAMuHMdU0spv9X_wErkBBWQ9kV9f1zE_YNcu5nPbTG_64Lh_h0w@mail.gmail.com> <CAHmME9pZu-UvCK=uP-sxXL127BmbjmrD2=M7cNd9vHdJEsverw@mail.gmail.com>
In-Reply-To: <CAHmME9pZu-UvCK=uP-sxXL127BmbjmrD2=M7cNd9vHdJEsverw@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 11 Jan 2022 13:51:36 +0100
X-Gmail-Original-Message-ID: <CAMuHMdW+Od70XTNbnNxL3qXgetZ9QDLeett6u5vg9Wr6atxD=w@mail.gmail.com>
Message-ID: <CAMuHMdW+Od70XTNbnNxL3qXgetZ9QDLeett6u5vg9Wr6atxD=w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] random: use BLAKE2s instead of SHA1 in extraction
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Theodore Tso <tytso@mit.edu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

CC bpf, netdev

On Tue, Jan 11, 2022 at 1:28 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> On Tue, Jan 11, 2022 at 12:38 PM Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > Unfortunately we cannot get rid of the sha1 code yet (lib/sha1.o is
> > built-in unconditionally), as there are other users...

kernel/bpf/core.c and net/ipv6/addrconf.c
Could they be switched to blake2s, too?

> I think that's just how things go and a price for progress. We're not
> going to stick with sha1, and blake2s has some nice properties that we
> certainly want. In the future hopefully this can decrease in other
> ways based on other future improvements. But that's where we are now.
>
> If you're really quite concerned about m68k code size, I can probably
> do some things to reduce that. For example, blake2s256_hmac is only
> used by wireguard and it could probably be made local there. And with
> some trivial loop re-rolling, I can shave off another 2300 bytes. And
> I bet I can find a few other things too. The question is: how
> important is this to you?

No problem, I just try to report all measurable impact on kernel size,
so there is some record of it.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
