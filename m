Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76325116799
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfLIHkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:40:18 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39602 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbfLIHkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 02:40:18 -0500
Received: by mail-ot1-f65.google.com with SMTP id 77so11368031oty.6;
        Sun, 08 Dec 2019 23:40:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FPK1maUM55Gi6p6kYw8RySJ9yGFpidLuP0EhKQwUZt0=;
        b=J88Wsea6C+k3NFQo5u00pV0uy5W9NhKezfpc3NsPLQUM61WGjHo8QhbT9n/CnSxp/B
         0Mwd+6HFLfN55xRHIQUPa0H0nX1bWyWalY4AicHuYCip339jYB7pNiysMEjV7ZYhsDw7
         8PZKGzzO0xAMFAJS0xqeITWT/Rg9CVuPmfD7rVTUtUfx68eKYunXLCq6TNFiaeKoSRWi
         0xRBY6fpHgZP7ZZmEDPvR0AF4GlBsO/tMuDBfqQEeIgFrPLeUUxmoZhsBHwxRrtgpBVj
         e72LREqdK8Ir0jRiW3WKznZdX6IrWAlr2P6A/Gyd0sD1P3iF5NXqvJpPv/4uxtlIAoNd
         IqwA==
X-Gm-Message-State: APjAAAX9TH34d5gxmqiio9qLZheqe413WXil1Az9fA0hGaOjP4pvbSjh
        0fNCIiYSGoAS1VDYquWN4fDaj7LkhcF6c31WoH351CDH
X-Google-Smtp-Source: APXvYqxnnTSYYLFHYr/PZKJtreFRDO2OI11O4NLAJMeK4zbXArJ/fD3O2OflqrT+cACovE3JpEFWmclImrX5h6naz84=
X-Received: by 2002:a05:6830:91:: with SMTP id a17mr19172583oto.107.1575877217104;
 Sun, 08 Dec 2019 23:40:17 -0800 (PST)
MIME-Version: 1.0
References: <20191203201804.662066-1-mst@redhat.com> <20191203201804.662066-2-mst@redhat.com>
In-Reply-To: <20191203201804.662066-2-mst@redhat.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 9 Dec 2019 08:40:06 +0100
Message-ID: <CAMuHMdXDm0NiCk1pD_-wS9c-ErmRKkrqnPc_pGKzG=QB35mj9A@mail.gmail.com>
Subject: Re: [PATCH RFC net-next v8 1/3] netdev: pass the stuck queue to the
 timeout handler
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julio Faracco <jcfaracco@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Shannon Nelson <snelson@pensando.io>,
        Martin Habets <mhabets@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Tue, Dec 3, 2019 at 9:21 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> This allows incrementing the correct timeout statistic without any mess.
> Down the road, devices can learn to reset just the specific queue.
>
> The patch was generated with the following script:

[...]

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

> --- a/drivers/net/ethernet/8390/8390p.c
> +++ b/drivers/net/ethernet/8390/8390p.c
> @@ -41,9 +41,9 @@ void eip_set_multicast_list(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(eip_set_multicast_list);
>
> -void eip_tx_timeout(struct net_device *dev)
> +void eip_tx_timeout(struct net_device *dev, unsigned int txqueue)
>  {
> -       __ei_tx_timeout(dev);
> +       __ei_tx_timeout(dev, txqueue);
>  }
>  EXPORT_SYMBOL(eip_tx_timeout);

On Mon, Dec 9, 2019 at 6:37 AM <noreply@ellerman.id.au> wrote:
> FAILED linux-next/m68k-defconfig/m68k Mon Dec 09, 16:34
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/14060060/
>
> Commit:   Add linux-next specific files for 20191209
>           6cf8298daad041cd15dc514d8a4f93ca3636c84e
> Compiler: m68k-linux-gcc (GCC) 4.6.3 / GNU ld (GNU Binutils) 2.22
>
> Possible errors
> ---------------
>
> drivers/net/ethernet/8390/8390p.c:44:6: error: conflicting types for 'eip_tx_timeout'
> drivers/net/ethernet/8390/8390p.c:48:1: error: conflicting types for 'eip_tx_timeout'
> make[5]: *** [scripts/Makefile.build:266: drivers/net/ethernet/8390/8390p.o] Error 1
> make[4]: *** [scripts/Makefile.build:503: drivers/net/ethernet/8390] Error 2
> make[3]: *** [scripts/Makefile.build:503: drivers/net/ethernet] Error 2
> make[2]: *** [scripts/Makefile.build:503: drivers/net] Error 2
> make[1]: *** [Makefile:1693: drivers] Error 2
> make: *** [Makefile:179: sub-make] Error 2

Looks like you forgot to update the forward declaration in
drivers/net/ethernet/8390/8390.h

There may be others...
http://kisskb.ellerman.id.au/kisskb/head/6cf8298daad041cd15dc514d8a4f93ca3636c84e/

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
