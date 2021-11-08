Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA99A4480EF
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 15:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbhKHOKL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Nov 2021 09:10:11 -0500
Received: from mail-ua1-f54.google.com ([209.85.222.54]:34507 "EHLO
        mail-ua1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240246AbhKHOKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 09:10:02 -0500
Received: by mail-ua1-f54.google.com with SMTP id b3so31739471uam.1;
        Mon, 08 Nov 2021 06:07:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=srssYsTsVb5ivMDmTAt6Y7lXgP/lHHGiJX97jzZpFII=;
        b=lT7Q627YXwAYYti9TyWmhNrAwxF37ER+DnnHvi8ZOaxozyOw/rwlQ66wlApkNuyNN0
         l/36WyzNYJX7UwsJU1aMV3bW5Sz7j/IP33Z/kZbh3aJA6GtHX+o7tNp9p+l7GF4QkKIB
         sjbbINID3WCsCkZrFWfMUwfrp9PjYh6onoNzXUnoEQ/95F5HYU5n5UHmTstBfe0urn4h
         1SE5gPNj3Pc2mvjTTyE8StQTFs4/Z7quYn3ZeZl33bFkXJAPxUlQqv23fQ05cU4PyTMU
         am1ot2b90FgHRA4kFfiBdu8fFSdh6YxyoBpITiqz4ORJJJdFb9hLqYTU1fxm5MWEErbR
         0b5Q==
X-Gm-Message-State: AOAM531VcfMwSWKNLwI/Nir0vc2ScGiGBGnffpEeKxm2KOJGi6tJeJ4f
        ZdyVgO2KwEjymrO3gMZbXCXik2FZgi7ZJAl7
X-Google-Smtp-Source: ABdhPJx9G54VGw4oc23XJRelgp9dkMEtXydk+uvqLajllgER83nLii76Q7zBboH+kgBjAPFdw36B5A==
X-Received: by 2002:ab0:3e3:: with SMTP id 90mr185644uau.102.1636380435783;
        Mon, 08 Nov 2021 06:07:15 -0800 (PST)
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com. [209.85.221.171])
        by smtp.gmail.com with ESMTPSA id c11sm3226781vsh.22.2021.11.08.06.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 06:07:14 -0800 (PST)
Received: by mail-vk1-f171.google.com with SMTP id a129so8254621vkb.8;
        Mon, 08 Nov 2021 06:07:14 -0800 (PST)
X-Received: by 2002:a05:6122:1350:: with SMTP id f16mr21288847vkp.26.1636380434409;
 Mon, 08 Nov 2021 06:07:14 -0800 (PST)
MIME-Version: 1.0
References: <20211108101157.15189-1-bp@alien8.de> <20211108101157.15189-43-bp@alien8.de>
In-Reply-To: <20211108101157.15189-43-bp@alien8.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 8 Nov 2021 15:07:03 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWH+txiSP_d7Jc4f_bU8Lf9iWpT4E3o5o7BJr-YdA6-VA@mail.gmail.com>
Message-ID: <CAMuHMdWH+txiSP_d7Jc4f_bU8Lf9iWpT4E3o5o7BJr-YdA6-VA@mail.gmail.com>
Subject: Re: [PATCH v0 42/42] notifier: Return an error when callback is
 already registered
To:     Borislav Petkov <bp@alien8.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        intel-gvt-dev@lists.freedesktop.org,
        alpha <linux-alpha@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-clk <linux-clk@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-edac@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        linux-hyperv@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-leds <linux-leds@vger.kernel.org>,
        "open list:BROADCOM NVRAM DRIVER" <linux-mips@vger.kernel.org>,
        Parisc List <linux-parisc@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        "open list:REMOTE PROCESSOR (REMOTEPROC) SUBSYSTEM" 
        <linux-remoteproc@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        linux-staging@lists.linux.dev,
        linux-tegra <linux-tegra@vger.kernel.org>,
        linux-um <linux-um@lists.infradead.org>,
        USB list <linux-usb@vger.kernel.org>,
        "open list:TENSILICA XTENSA PORT (xtensa)" 
        <linux-xtensa@linux-xtensa.org>, netdev <netdev@vger.kernel.org>,
        openipmi-developer@lists.sourceforge.net, rcu@vger.kernel.org,
        sparclinux <sparclinux@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Borislav,

On Mon, Nov 8, 2021 at 11:13 AM Borislav Petkov <bp@alien8.de> wrote:
> From: Borislav Petkov <bp@suse.de>
>
> The notifier registration routine doesn't return a proper error value
> when a callback has already been registered, leading people to track
> whether that registration has happened at the call site:
>
>   https://lore.kernel.org/amd-gfx/20210512013058.6827-1-mukul.joshi@amd.com/
>
> Which is unnecessary.
>
> Return -EEXIST to signal that case so that callers can act accordingly.
> Enforce callers to check the return value, leading to loud screaming
> during build:
>
>   arch/x86/kernel/cpu/mce/core.c: In function ‘mce_register_decode_chain’:
>   arch/x86/kernel/cpu/mce/core.c:167:2: error: ignoring return value of \
>    ‘blocking_notifier_chain_register’, declared with attribute warn_unused_result [-Werror=unused-result]
>     blocking_notifier_chain_register(&x86_mce_decoder_chain, nb);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Drop the WARN too, while at it.
>
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Borislav Petkov <bp@suse.de>

Thanks for your patch!

> --- a/include/linux/notifier.h
> +++ b/include/linux/notifier.h
> @@ -141,13 +141,13 @@ extern void srcu_init_notifier_head(struct srcu_notifier_head *nh);
>
>  #ifdef __KERNEL__
>
> -extern int atomic_notifier_chain_register(struct atomic_notifier_head *nh,
> +extern int __must_check atomic_notifier_chain_register(struct atomic_notifier_head *nh,
>                 struct notifier_block *nb);
> -extern int blocking_notifier_chain_register(struct blocking_notifier_head *nh,
> +extern int __must_check blocking_notifier_chain_register(struct blocking_notifier_head *nh,
>                 struct notifier_block *nb);
> -extern int raw_notifier_chain_register(struct raw_notifier_head *nh,
> +extern int __must_check raw_notifier_chain_register(struct raw_notifier_head *nh,
>                 struct notifier_block *nb);
> -extern int srcu_notifier_chain_register(struct srcu_notifier_head *nh,
> +extern int __must_check srcu_notifier_chain_register(struct srcu_notifier_head *nh,
>                 struct notifier_block *nb);

I think the addition of __must_check is overkill, leading to the
addition of useless error checks and message printing.  Many callers
call this where it cannot fail, and where nothing can be done in the
very unlikely event that the call would ever start to fail.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
