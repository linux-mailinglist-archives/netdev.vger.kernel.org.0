Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 523D04105FA
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 12:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238559AbhIRKzH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 18 Sep 2021 06:55:07 -0400
Received: from mail-vk1-f182.google.com ([209.85.221.182]:44011 "EHLO
        mail-vk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236901AbhIRKzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Sep 2021 06:55:06 -0400
Received: by mail-vk1-f182.google.com with SMTP id d10so4691472vke.10
        for <netdev@vger.kernel.org>; Sat, 18 Sep 2021 03:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j6SGIPRPvG2STD4eLQd/s3WO7n19mDN54Smns2upm8k=;
        b=rH8/cQ+9YErcExH/vGyxnyzKdteQP1WZjch7D6CxcjJ3d3b1wnoMrXgRtku9R/yMf7
         z363wYzqBeP+/lNDKm2cd9nU+eVhIx+yPvhucrLLBKS0C7c9451u+dtgCZRa7TXQI/9c
         BCrtLglt3FDeggheGNpSJ4mE4xcmgL+EBzosfYG7zw3Pa8lPj+Nj85x54b42XyhRH6hD
         ExqY6yLLaT3nWGlqSOvgC64m2amo6zQCSzysM9NLlQ4s7ND5KAQe9XHTRTElCjIzzc9k
         iGpIOni/bjsxRqDn7NJqahN9JZd6RbKD1N8raEHxgiPZWlXeLIgt9a3LRGsb01ZJ2Tpl
         6TgA==
X-Gm-Message-State: AOAM533A7TZH3y+vCMfShkQc+EZgcapE11B/9bG/K3Jwk1ZMzqiJyuVx
        TAKgYAp39CGlF9SgFa4rZqAPvcfuNE8WL+1koGg=
X-Google-Smtp-Source: ABdhPJyWueoUdgTkpfMcOneHG8RLUafDH5iJM1Lziq2WErWeC59SaJH2E0bFyBqlFgFhNW/9YNJzYJz7HkD5BCjszI0=
X-Received: by 2002:a1f:5e14:: with SMTP id s20mr10927778vkb.7.1631962422446;
 Sat, 18 Sep 2021 03:53:42 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGeaOqxOMwCFKb=3X5EFaXNG+k3N2CfV4YT-8NiY5GW3Tg@mail.gmail.com>
 <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917114924.2a7bda93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 18 Sep 2021 12:53:31 +0200
Message-ID: <CAMuHMdUeoVZSkP24Uu7ni3pUf_9uQHsq2Xm3D6dHnzuQLXeOFA@mail.gmail.com>
Subject: Re: nt: usb: USB_RTL8153_ECM should not default to y
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Maciej Zenczykowski <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Fri, Sep 17, 2021 at 8:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
> On Fri, 17 Sep 2021 19:59:15 +0200 Maciej Żenczykowski wrote:
> > I've been browsing some usb ethernet dongle related stuff in the
> > kernel (trying to figure out which options to enable in Android 13
> > 5.~15 kernels), and I've come across the following patch (see topic,
> > full patch quoted below).
> >
> > Doesn't it entirely defeat the purpose of the patch it claims to fix
> > (and the patch that fixed)?
> > Certainly the reasoning provided (in general device drivers should not
> > be enabled by default) doesn't jive with me.
> > The device driver is CDC_ETHER and AFAICT this is just a compatibility
> > option for it.
> >
> > Shouldn't it be reverted (ie. the 'default y' line be re-added) ?
> >
> > AFAICT the logic should be:
> >   if we have CDC ETHER (aka. ECM), but we don't have R8152 then we
> > need to have R8153_ECM.
> >
> > Alternatively, maybe there shouldn't be a config option for this at all?
> >
> > Instead r8153_ecm should simply be part of cdc_ether.ko iff r8152=n
> >
> > I'm not knowledgeable enough about Kconfig syntax to know how to
> > phrase the logic...
> > Maybe there shouldn't be a Kconfig option at all, and just some Makefile if'ery.
> >
> > Something like:
> >
> > obj-$(CONFIG_USB_RTL8152) += r8152.o
> > obj-$(CONFIG_USB_NET_CDCETHER) += cdc_ether.o obj-
> > ifndef CONFIG_USB_RTL8152
> > obj-$(CONFIG_USB_NET_CDCETHER) += r8153_ecm.o
> > endif
> >
> > Though it certainly would be nice to use 8153 devices with the
> > CDCETHER driver even with the r8152 driver enabled...
>
> Yeah.. more context here:
>
> https://lore.kernel.org/all/7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com/
>
> default !USB_RTL8152 would be my favorite but that probably doesn't
> compute in kconfig land. Or perhaps bring back the 'y' but more clearly
> mark it as a sub-option of CDCETHER? It's hard to blame people for
> expecting drivers to default to n, we should make it clearer that this
> is more of a "make driver X support variation Y", 'cause now it sounds
> like a completely standalone driver from the Kconfig wording. At least
> to a lay person like myself.

If it can be a module (tristate), it must be a separate (sub)driver, right?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
