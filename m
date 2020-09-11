Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49726265965
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 08:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgIKGdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 02:33:09 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38523 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbgIKGdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 02:33:08 -0400
Received: by mail-ot1-f67.google.com with SMTP id y5so7482118otg.5;
        Thu, 10 Sep 2020 23:33:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ndHZtUig8ulrxjgOeUro9f64fpE4pGFrMYQ9ez5zwFQ=;
        b=uDG2mh81U21qPOKyiCzeRDeSkqmms65goCMMH+MXHmRUKDHGZ/vxudO3aG6nU3Y5Lx
         GKzdEXs1nG08VORRHFAlQQlfoVy+5SEjcn3HJxmW3ciK+G70MYNK3FOfK1prui+sindV
         gLd81nIMKlbRU4NrALrOCWPOpy50YTvmCzW98HubaVZRy3R3RXPTGUQ8ku9hagWEkOLB
         xdbketmDxO8T+pHldyLl5+yLJLQfgMUucdIA35+/vr1pFkM2KWexeNSD+V1Ikhj9BZWv
         sMVeP9XiF6l9o7BIMOlyQria0s6McaQpnegBnt4BSLE16xTFlQ04+5Tzop4Bmb4E9xvy
         0HNQ==
X-Gm-Message-State: AOAM533lHedLKEJybjBbC8L08p8PF+imiXWfR+44Nc6SCwiyL8CEh0v7
        32Is0w/W297UifA4y4ZGCxnZNUgRibsUa3kestU=
X-Google-Smtp-Source: ABdhPJwghuBHHEAEWXlncSr8HbCkHqF7bKQqn9MVNGr3uUay9GA+br1Kd2Nj/NlgO8YM52xavFWlurhfN1+q1qU65hg=
X-Received: by 2002:a9d:5a92:: with SMTP id w18mr294713oth.145.1599805987300;
 Thu, 10 Sep 2020 23:33:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200901150237.15302-1-geert+renesas@glider.be> <20200910.122033.2205909020498878557.davem@davemloft.net>
In-Reply-To: <20200910.122033.2205909020498878557.davem@davemloft.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 11 Sep 2020 08:32:55 +0200
Message-ID: <CAMuHMdUd4VtpOGr26KAmF22N32obNqQzq3tbcPxLJ7mxUtSyrg@mail.gmail.com>
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
To:     David Miller <davem@davemloft.net>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Gaku Inami <gaku.inami.xh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Thu, Sep 10, 2020 at 9:20 PM David Miller <davem@davemloft.net> wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> Date: Tue,  1 Sep 2020 17:02:37 +0200
>
> > This reverts commit 124eee3f6955f7aa19b9e6ff5c9b6d37cb3d1e2c.
> >
> > Inami-san reported that this commit breaks bridge support in a Xen
> > environment, and that reverting it fixes this.
> >
> > During system resume, bridge ports are no longer enabled, as that relies
> > on the receipt of the NETDEV_CHANGE notification.  This notification is
> > not sent, as netdev_state_change() is no longer called.
> >
> > Note that the condition this commit intended to fix never existed
> > upstream, as the patch triggering it and referenced in the commit was
> > never applied upstream.  Hence I can confirm s2ram on r8a73a4/ape6evm
> > and sh73a0/kzm9g works fine before/after this revert.
> >
> > Reported-by Gaku Inami <gaku.inami.xh@renesas.com>
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Maybe you cannot reproduce it, but the problem is there and it still
> looks very real to me.
>
> netdev_state_change() does two things:
>
> 1) Emit the NETDEV_CHANGE notification
>
> 2) Emit an rtmsg_ifinfo() netlink message, which in turn tries to access
>    the device statistics via ->ndo_get_stats*().
>
> It is absolutely wrong to do #2 when netif_device_present() is false.
>
> So I cannot apply this patch as-is, sorry.

Thanks a lot for looking into this!

But doing #1 is still safe?  That is the part that calls into the bridge
code.  So would moving the netif_device_present() check from
linkwatch_do_dev() to netdev_state_change(), to prevent doing #2, be
acceptable?

Thanks again!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
