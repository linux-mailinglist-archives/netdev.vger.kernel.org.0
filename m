Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9795417FFF1
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 15:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgCJOQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 10:16:47 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34176 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgCJOQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 10:16:46 -0400
Received: by mail-ot1-f66.google.com with SMTP id j16so13286011otl.1;
        Tue, 10 Mar 2020 07:16:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p/R9hkm0Zw7z7yv8pl2WS6JNAIj1jxXZxWTXciFoU7c=;
        b=UsfFOY0jNkUHnio8nrI47GaJmA0lRNVHw2ueoWyUI8B3w+81gbfzH0l4lM2Yye8TW8
         8gxxhSeVB4r2Xbi1tJrBdHnQ2R4uv9OM+4GRhKQX08a7+eJOq6ieVW0v/4n9VZB7JUhJ
         JU6k2eH2tFUV/NyEQk8zXoPVKF1DGwxl55vyhjOk5x4f3uEa2etVcBAPhj2NV2esH8KO
         0IACDIthaPkrdWy5hjmCdHjPvOwqGX8TEzHnLWdSS3iSaAJ/HKlrUC+cuEmUUBSQqKlQ
         yE14/IJg2oa1O4F3KNV9ILBqo056xbTGsmiS8gihlOVcGYbGEl8mhnnXJ5StFadt9Wy0
         0z3A==
X-Gm-Message-State: ANhLgQ2iD0j6QX2Y0qMRoMpV7q/c0c5AiONc7zviWOsv0Zi7PaPkgidu
        u8LeXRGEcqTNGPU/4cAi3M0ctZ9ms+SSWbfc8O4=
X-Google-Smtp-Source: ADFU+vvZTqfdR5CugMRRTAerKcghOgx+guP2EJeK1CA6udD0T6lcZulG/Kqqj5o+tL7B7i7MpR6gacmzSsc9JzHRJjo=
X-Received: by 2002:a9d:5c0c:: with SMTP id o12mr17093578otk.145.1583849805778;
 Tue, 10 Mar 2020 07:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200220233454.31514-1-f.fainelli@gmail.com> <20200223.205911.1667092059432885700.davem@davemloft.net>
In-Reply-To: <20200223.205911.1667092059432885700.davem@davemloft.net>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 10 Mar 2020 15:16:34 +0100
Message-ID: <CAMuHMdWuP1_3vqOpf7KEimLLTKiWpWku9fUAdP3CCR6WbHyQdg@mail.gmail.com>
Subject: Re: [PATCH net] net: phy: Avoid multiple suspends
To:     David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, B38611@freescale.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian, David,

On Mon, Feb 24, 2020 at 5:59 AM David Miller <davem@davemloft.net> wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Thu, 20 Feb 2020 15:34:53 -0800
>
> > It is currently possible for a PHY device to be suspended as part of a
> > network device driver's suspend call while it is still being attached to
> > that net_device, either via phy_suspend() or implicitly via phy_stop().
> >
> > Later on, when the MDIO bus controller get suspended, we would attempt
> > to suspend again the PHY because it is still attached to a network
> > device.
> >
> > This is both a waste of time and creates an opportunity for improper
> > clock/power management bugs to creep in.
> >
> > Fixes: 803dd9c77ac3 ("net: phy: avoid suspending twice a PHY")
> > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>
> Applied, and queued up for -stable, thanks Florian.

This patch causes a regression on r8a73a4/ape6evm and sh73a0/kzm9g.
After resume from s2ram, Ethernet no longer works:

        PM: suspend exit
        nfs: server aaa.bbb.ccc.ddd not responding, still trying
        ...

Reverting commit 503ba7c6961034ff ("net: phy: Avoid multiple suspends")
fixes the issue.

On both boards, an SMSC LAN9220 is connected to a power-managed local
bus.

I added some debug code to check when the clock driving the local bus
is stopped and started, but I see no difference before/after.  Hence I
suspect the Ethernet chip is no longer reinitialized after resume.

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
