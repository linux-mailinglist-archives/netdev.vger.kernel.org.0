Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE686267A4C
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 14:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgILMeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 08:34:14 -0400
Received: from mail-oo1-f68.google.com ([209.85.161.68]:45849 "EHLO
        mail-oo1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgILMeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 08:34:12 -0400
Received: by mail-oo1-f68.google.com with SMTP id h8so2924370ooc.12;
        Sat, 12 Sep 2020 05:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PMaZ+IG/MAdIGBCktihvMwzdamRFz/leNPggdqRYcVU=;
        b=nPMZauhe9ObNVFSMsQM5GdnBT3RFpNS7fmWdNchCW+z5ffJ7kN2pCvgNfH+Jp3HPuo
         2fiwm8l4zITCFdoB7PY8jaJyNLd/Nhh9ewa6EhwBQ3hZVIkCJZlhDMD4sf1VPl5VovAT
         m+rWS1Z6UtYfljtf2DN3fTzZezHz4i3WHCdsgdGrhD+ZOWeg5hq7NkAQoNc7oTjUCuVH
         M1vpe9w302HpRYovXHpxHfWL+dyja12tT0dh/HsjVa3AmZhUA7N+huHgOUKpD5PjsoRr
         xA30vnfM4NFA17TvHquA1lVU7/CQNlTph9EE0PZrGeCFL4W+q/ICJxID/1ZAHUOTdufu
         g1HQ==
X-Gm-Message-State: AOAM53244vG23wenF0XsqeoVrX6P4it1D6N/GmJk3C570WTyYDRhME+6
        qVH22Sj6NkkqvTS0Z+Savip48S3/WC9S4nDvubFJgFjy
X-Google-Smtp-Source: ABdhPJyY3uhUd2u1IHy+W7UyB38+/N8z1KWX42Rq5P92O+CHNhabGO7XIYzRYip1fYThpbY5yR+yx2PVmpjrwu3Kh6E=
X-Received: by 2002:a4a:5403:: with SMTP id t3mr4747089ooa.11.1599914050891;
 Sat, 12 Sep 2020 05:34:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200901150237.15302-1-geert+renesas@glider.be>
 <20200910.122033.2205909020498878557.davem@davemloft.net> <CAMuHMdUd4VtpOGr26KAmF22N32obNqQzq3tbcPxLJ7mxUtSyrg@mail.gmail.com>
 <20200911.174400.306709791543819081.davem@davemloft.net>
In-Reply-To: <20200911.174400.306709791543819081.davem@davemloft.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 12 Sep 2020 14:33:59 +0200
Message-ID: <CAMuHMdW0agywTHr4bDO9f_xbQibCxDykdkcAmuRJQO90=E6-Zw@mail.gmail.com>
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

On Sat, Sep 12, 2020 at 2:44 AM David Miller <davem@davemloft.net> wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Fri, 11 Sep 2020 08:32:55 +0200
>
> > On Thu, Sep 10, 2020 at 9:20 PM David Miller <davem@davemloft.net> wrote:
> >> From: Geert Uytterhoeven <geert+renesas@glider.be>
> >> Date: Tue,  1 Sep 2020 17:02:37 +0200
> >>
> >> > This reverts commit 124eee3f6955f7aa19b9e6ff5c9b6d37cb3d1e2c.
> >> >
> >> > Inami-san reported that this commit breaks bridge support in a Xen
> >> > environment, and that reverting it fixes this.
> >> >
> >> > During system resume, bridge ports are no longer enabled, as that relies
> >> > on the receipt of the NETDEV_CHANGE notification.  This notification is
> >> > not sent, as netdev_state_change() is no longer called.
> >> >
> >> > Note that the condition this commit intended to fix never existed
> >> > upstream, as the patch triggering it and referenced in the commit was
> >> > never applied upstream.  Hence I can confirm s2ram on r8a73a4/ape6evm
> >> > and sh73a0/kzm9g works fine before/after this revert.
> >> >
> >> > Reported-by Gaku Inami <gaku.inami.xh@renesas.com>
> >> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >>
> >> Maybe you cannot reproduce it, but the problem is there and it still
> >> looks very real to me.
> >>
> >> netdev_state_change() does two things:
> >>
> >> 1) Emit the NETDEV_CHANGE notification
> >>
> >> 2) Emit an rtmsg_ifinfo() netlink message, which in turn tries to access
> >>    the device statistics via ->ndo_get_stats*().
> >>
> >> It is absolutely wrong to do #2 when netif_device_present() is false.
> >>
> >> So I cannot apply this patch as-is, sorry.
> >
> > Thanks a lot for looking into this!
> >
> > But doing #1 is still safe?  That is the part that calls into the bridge
> > code.  So would moving the netif_device_present() check from
> > linkwatch_do_dev() to netdev_state_change(), to prevent doing #2, be
> > acceptable?
>
> I have a better question.  Why is a software device like the bridge,
> that wants to effectively exist and still receive netdev event
> notifications, marking itself as not present?
>
> That's seems like the real bug here.

"dev" is not the bridge device, but the physical Ethernet interface, which
may already be suspended during s2ram.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
