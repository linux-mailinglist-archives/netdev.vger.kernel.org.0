Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E81D3E93F4
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhHKOvS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 11 Aug 2021 10:51:18 -0400
Received: from mail-vs1-f53.google.com ([209.85.217.53]:46652 "EHLO
        mail-vs1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbhHKOvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 10:51:15 -0400
Received: by mail-vs1-f53.google.com with SMTP id h7so1659699vso.13;
        Wed, 11 Aug 2021 07:50:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cIjkkhxIDfcNNlnHybuIBwZKLNxXMpZQOWOrYH4uD+E=;
        b=U2i7WTkbGtmet9RiSPXlni7nQJulS0nx4kp39lDjeNkKE9KdcuN2cRITk461im3a1Y
         WpBrAj3thtAjYYcbH1ej3lDeVN9oZbD98TDIvvp2r0TVXNFb2uYdJrNIaJ2XIVFitbsS
         us6fIIanc7r4pQUhG+nEwsCUv2tITo5XDUguy+27NBMi4KHu/CtJpJk0CnC4yP6tDOfh
         W85h62XpXzCg1Ex/qaxE10auxV1EbC5MLWzAg4ENlNRvIZIRteyy2I2PJA/FggVEKh/Z
         iz5LZx9Oa8jMYYVvsu/LGERzdjuidl0sVK1ENG5FsLNKPDi02Xs3L+9oKhz8qFeFOzkk
         /5+g==
X-Gm-Message-State: AOAM531VNrFBYICHzfHZD8+z68IKOrYTxownulbjFRHNwVtmCeTHoci8
        a+9N9aYJccIrGQ4KBSst9j9SguzMJ+rrQwPtP9M=
X-Google-Smtp-Source: ABdhPJyCKGDxNdZxL1InzZOuebscdelRrflgN7wgfQcLAxNeXbBK11NZVzyFk5Zc6ixhsCh4yORvoZGZjBul5tJ7ZZM=
X-Received: by 2002:a67:e2c7:: with SMTP id i7mr26153722vsm.3.1628693450818;
 Wed, 11 Aug 2021 07:50:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210803114051.2112986-1-arnd@kernel.org> <20210803114051.2112986-11-arnd@kernel.org>
In-Reply-To: <20210803114051.2112986-11-arnd@kernel.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 11 Aug 2021 16:50:39 +0200
Message-ID: <CAMuHMdVvBL=qZkWF5DXdKjFMKgT-3X-OUBnLYrqawQijoLG4Xw@mail.gmail.com>
Subject: Re: [PATCH v2 10/14] [net-next] make legacy ISA probe optional
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Tue, Aug 3, 2021 at 1:41 PM Arnd Bergmann <arnd@kernel.org> wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> There are very few ISA drivers left that rely on the static probing from
> drivers/net/Space.o. Make them all select a new CONFIG_NETDEV_LEGACY_INIT
> symbol, and drop the entire probe logic when that is disabled.
>
> The 9 drivers that are called from Space.c are the same set that
> calls netdev_boot_setup_check().
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

> --- a/drivers/net/ethernet/8390/ne.c
> +++ b/drivers/net/ethernet/8390/ne.c
> @@ -951,6 +951,7 @@ static int __init ne_init(void)
>  }
>  module_init(ne_init);
>
> +#ifdef CONFIG_NETDEV_LEGACY_INIT
>  struct net_device * __init ne_probe(int unit)
>  {
>         int this_dev;
> @@ -991,6 +992,7 @@ struct net_device * __init ne_probe(int unit)
>
>         return ERR_PTR(-ENODEV);
>  }
> +#endif
>  #endif /* MODULE */

My rbtx4927 build log says:

drivers/net/ethernet/8390/ne.c:909:20: warning: ‘ne_add_devices’
defined but not used [-Wunused-function]

The network still works fine (nfsroot).

CONFIG_MACH_TX49XX=y
CONFIG_NE2000=y
CONFIG_NETDEV_LEGACY_INIT is not set

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
