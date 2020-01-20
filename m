Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4FB0142594
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 09:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbgATI31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 03:29:27 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:39110 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgATI31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 03:29:27 -0500
Received: by mail-oi1-f195.google.com with SMTP id z2so3823581oih.6;
        Mon, 20 Jan 2020 00:29:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tFqMTtRLSSI+O8N4QG8hNcWnZ16xdlM9eDNxrV6706I=;
        b=Ni4dqih2pHK5KtdSs6JX2cEdrng5NUqRigPBK2qTfDPInRjY+Pa2vNpG00Bc4YqtBJ
         DouV4ilzczYR1wzNowVJgxnrUNi7WW9lCyyojQt6XSQ+zjozamhz7qIKc11EzVbZamqr
         D34sH477iWtAOcrkFL/0BOFe9YSkLOVZVzEErIqGiMCdGZkDwG4ZTcFyrcmfoicwt6GL
         0x42vnhdHF9S+/vBFOQef9/BmVtCBPuZqh6S9SI9ChbhDoTobHBH24nKEYfuVQMZYigG
         wLy15C1pupCq+E/GL2px5UXGxCHkHd4+w393m6TB3KHwbRxSI6AMETCrS4NtNsB12UPZ
         pw3Q==
X-Gm-Message-State: APjAAAU9wT6rKPLQTIhIUQ96CaX2E9QMz4kcQRRAbLGjrqw1q570Sm0F
        4kg1oVuiZddhXhBRVFfXh38Lv/WuMXaAxXnhN/j1Tw==
X-Google-Smtp-Source: APXvYqwVtDCTbfv44Zscj3VBgtNuG+yGRutOTjquJ+HIEAaRmbCFgSCQTDGmGD10uzPKuyM0U7PMWaKUkATjSMvJbxc=
X-Received: by 2002:aca:1a06:: with SMTP id a6mr11555422oia.148.1579508966488;
 Mon, 20 Jan 2020 00:29:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1579474569.git.fthain@telegraphics.com.au> <b47662493a776811d4d457e5a75e18a7169aed23.1579474569.git.fthain@telegraphics.com.au>
In-Reply-To: <b47662493a776811d4d457e5a75e18a7169aed23.1579474569.git.fthain@telegraphics.com.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 20 Jan 2020 09:29:14 +0100
Message-ID: <CAMuHMdWvJ975X7zz1C=1Sq=Yuf9nYY1zxWaJ=XCXJukfP=nygg@mail.gmail.com>
Subject: Re: [PATCH net 04/19] net/sonic: Add mutual exclusion for accessing
 shared state
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Laurent Vivier <laurent@vivier.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Finn,

On Mon, Jan 20, 2020 at 12:19 AM Finn Thain <fthain@telegraphics.com.au> wrote:
> The netif_stop_queue() call in sonic_send_packet() races with the
> netif_wake_queue() call in sonic_interrupt(). This causes issues
> like "NETDEV WATCHDOG: eth0 (macsonic): transmit queue 0 timed out".
> Fix this by disabling interrupts when accessing tx_skb[] and next_tx.
> Update a comment to clarify the synchronization properties.
>
> Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
> Tested-by: Stan Johnson <userm57@yahoo.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Thanks for your patch!

> --- a/drivers/net/ethernet/natsemi/sonic.c
> +++ b/drivers/net/ethernet/natsemi/sonic.c
> @@ -242,7 +242,7 @@ static void sonic_tx_timeout(struct net_device *dev)
>   *   wake the tx queue
>   * Concurrently with all of this, the SONIC is potentially writing to
>   * the status flags of the TDs.
> - * Until some mutual exclusion is added, this code will not work with SMP. However,
> + * A spin lock is needed to make this work on SMP platforms. However,
>   * MIPS Jazz machines and m68k Macs were all uni-processor machines.
>   */
>
> @@ -252,6 +252,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
>         dma_addr_t laddr;
>         int length;
>         int entry;
> +       unsigned long flags;
>
>         netif_dbg(lp, tx_queued, dev, "%s: skb=%p\n", __func__, skb);
>
> @@ -273,6 +274,8 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
>                 return NETDEV_TX_OK;
>         }
>
> +       local_irq_save(flags);
> +

Wouldn't it be better to use a spinlock instead?
It looks like all currently supported platforms (Mac, Jazz, and XT2000)
do no support SMP, but I'm not 100% sure about the latter.
And this generic sonic.c core may end up being used on other platforms
that do support SMP.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
