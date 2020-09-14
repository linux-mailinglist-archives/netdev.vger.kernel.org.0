Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43AE6268643
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726109AbgINHkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:40:42 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38538 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgINHkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:40:25 -0400
Received: by mail-oi1-f196.google.com with SMTP id y6so16893245oie.5;
        Mon, 14 Sep 2020 00:40:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9OcnKlqgAuX3lmvtPjQSY28ozZnq3T65wzBJcbrmz6o=;
        b=ZLQ8zYfHQJNoKuG+aRZ1H9nnh9a4xDHfqXoJD6QYkDtGc6C8hdiq5hfp0fGNJwzMw+
         H1jQzpooQU23mgfHnzcnCcvQZvf3dbmlI5SfBjbLFIhFXh+WBqbUopKYRAwahnrQPvzy
         VvBfdP4Sc91YRnuIdb4UYpeJy1lmVIcIghG4fhO3yA32SEqMB4PwRzoZvonwHr/3Oegb
         cAczL01U9gCOabRrv4EPKDNu5LQJuRwn0remRHdtJOK2hrT5+lKbQsXi61s3zt4oHoCC
         G8Baniz9N6djPruhuaTAWACHKI5IVNZAlzUObe3yt+qLhDG7zswAw/UmOCBVkuIutzzJ
         ySSw==
X-Gm-Message-State: AOAM531x/T1J2g5du09T9lt+RnSSN3fKqCCksE3xypXltREwvPJV99Nc
        Uzk/MIoXsGPY0moM76cRBYFuNbq3T3kAtCplCpE=
X-Google-Smtp-Source: ABdhPJxXogF7NIvZqnQWeKTAcrQdTHdknQa9lnRLmhrjpxySJACyegBgSKyjuAW6Zz1mxStR+JFEXOpyVLi/baGaT9s=
X-Received: by 2002:aca:52d6:: with SMTP id g205mr8014808oib.54.1600069223913;
 Mon, 14 Sep 2020 00:40:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAMuHMdUd4VtpOGr26KAmF22N32obNqQzq3tbcPxLJ7mxUtSyrg@mail.gmail.com>
 <20200911.174400.306709791543819081.davem@davemloft.net> <CAMuHMdW0agywTHr4bDO9f_xbQibCxDykdkcAmuRJQO90=E6-Zw@mail.gmail.com>
 <20200912.183437.1205152743307947529.davem@davemloft.net>
In-Reply-To: <20200912.183437.1205152743307947529.davem@davemloft.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 14 Sep 2020 09:40:12 +0200
Message-ID: <CAMuHMdXGmKYKWtkFCV0WmYnY4Gn--Bbz-iSX76oc-UNNrzCMuw@mail.gmail.com>
Subject: Re: [PATCH] Revert "net: linkwatch: add check for netdevice being
 present to linkwatch_do_dev"
To:     David Miller <davem@davemloft.net>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Gaku Inami <gaku.inami.xh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

CC bridge

On Sun, Sep 13, 2020 at 3:34 AM David Miller <davem@davemloft.net> wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Sat, 12 Sep 2020 14:33:59 +0200
>
> > "dev" is not the bridge device, but the physical Ethernet interface, which
> > may already be suspended during s2ram.
>
> Hmmm, ok.
>
> Looking more deeply NETDEV_CHANGE causes br_port_carrier_check() to run which
> exits early if netif_running() is false, which is going to be true if
> netif_device_present() is false:
>
>         *notified = false;
>         if (!netif_running(br->dev))
>                 return;
>
> The only other work the bridge notifier does is:
>
>         if (event != NETDEV_UNREGISTER)
>                 br_vlan_port_event(p, event);
>
> and:
>
>         /* Events that may cause spanning tree to refresh */
>         if (!notified && (event == NETDEV_CHANGEADDR || event == NETDEV_UP ||
>                           event == NETDEV_CHANGE || event == NETDEV_DOWN))
>                 br_ifinfo_notify(RTM_NEWLINK, NULL, p);
>
> So some vlan stuff, and emitting a netlink message to any available
> listeners.
>
> Should we really do all of this for a device which is not even
> present?
>
> This whole situation seems completely illogical.  The device is
> useless, it logically has no link or other state that can be managed
> or used, while it is not present.
>
> So all of these bridge operations should only happen when the device
> transitions back to present again.

Thanks for your analysis!
I'd like to defer this to the bridge people (CC).

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
