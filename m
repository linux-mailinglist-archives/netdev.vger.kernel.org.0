Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 510A616A36A
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 11:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgBXKBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 05:01:22 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:37244 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgBXKBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 05:01:22 -0500
Received: by mail-oi1-f196.google.com with SMTP id q84so8405608oic.4;
        Mon, 24 Feb 2020 02:01:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xH/4bfRiAQSsYGbm2WsnrGFLe85wgXomw2HN69oKdU4=;
        b=E7SfETV+bcvhUeBbnhT8sFa1bzi7tfwWxqE5ckEcPbZPtYRVLZj/jGcVf0M4kBvSes
         rWQidJkhSjPL0WpiQ6ABGMRhrPQ8tk3tVTHcnT6iPHtYI/0gnIvgmu64zBJOXOReJuyJ
         d7exmLg+Kbr1qbFawEk+/i7tGWzPZj8TH0J7eTp5HwTEWbRMlFa0BvXmXyRvdcKoGtxV
         oalOhofklmUVOVIMejt2+gMznd9bFv+nUVNF0z1wtg10VqJ43VZmscdFe2aNSRXEIhVi
         wMxFEbiCKPBeiivpLH9DcsBcJ82/LtzSNw6I4SHaHzVyj1UpQk14ASakwb3+QDDojoMJ
         Dp4w==
X-Gm-Message-State: APjAAAUsHxKedjXK5PLVux4itqt5tqxh0mhmHDBo9vGpL7jmNtNqQNZM
        9xE44S899wNEaw7y4XBsc34j36WXL41q8SXjxFo=
X-Google-Smtp-Source: APXvYqwzMAEzBbDwvEqcefvZHvI9wJCBcHykUrsFr202mAK37+smqg1qZ4iQBAyEcB94K+mwTpTkZ9WVT1H6qjxXqeU=
X-Received: by 2002:aca:b4c3:: with SMTP id d186mr11610969oif.131.1582538480986;
 Mon, 24 Feb 2020 02:01:20 -0800 (PST)
MIME-Version: 1.0
References: <20150624.063911.1220157256743743341.davem@davemloft.net> <CA+55aFybr6Fjti5WSm=FQpfwdwgH1Pcfg6L81M-Hd9MzuSHktg@mail.gmail.com>
In-Reply-To: <CA+55aFybr6Fjti5WSm=FQpfwdwgH1Pcfg6L81M-Hd9MzuSHktg@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Feb 2020 11:01:09 +0100
Message-ID: <CAMuHMdViacgi1W8acma7GhWaaVj92z6pg-g7ByvYOQL-DToacA@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Thu, Jun 25, 2015 at 1:38 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jun 24, 2015 at 6:39 AM, David Miller <davem@davemloft.net> wrote:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
>
> On the *other* side of the same conflict, I find an even more
> offensive commit, namely commit 4cd7c9479aff ("IB/mad: Add support for
> additional MAD info to/from drivers") which adds a BUG_ON() for a
> sanity check, rather than just returning -EINVAL or something sane
> like that.
>
> I'm getting *real* tired of that BUG_ON() shit. I realize that
> infiniband is a niche market, and those "commercial grade" niche
> markets are more-than-used-to crap code and horrible hacks, but this
> is still the kernel. We don't add random machine-killing debug checks
> when it is *so* simple to just do
>
>         if (WARN_ON_ONCE(..))
>                 return -EINVAL;
>
> instead.

And if we follow that advice, friendly Greg will respond with:
"We really do not want WARN_ON() anywhere, as that causes systems with
 panic-on-warn to reboot."
https://lore.kernel.org/lkml/20191121135743.GA552517@kroah.com/

> Killing the machine for idiotic things like that is truly offensive,
> and truly horrible horrible code. Why do I keep on having to tell
> people off for doing these things? Why do people keep thinking that
> debugging-by-killing-the-machine is a good idea?
>
> Either that BUG_ON() cannot possibly happen, in which case it should
> damn well not exist in the first place. Or it's a valuable debug aid,
> in which case it should damn well not be a BUG_ON. You can't have it
> both ways.

Agreed.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
