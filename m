Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD4053786E
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 12:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234863AbiE3Jpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 05:45:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234799AbiE3Jpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 05:45:45 -0400
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6F02AF6;
        Mon, 30 May 2022 02:45:44 -0700 (PDT)
Received: by mail-qk1-f176.google.com with SMTP id v11so11009530qkf.1;
        Mon, 30 May 2022 02:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2eXMq1aM/7odJFSrV6FBn6WXqmOgMduOgC14zR4eCz0=;
        b=HEDckpgfihaMhPPc0kWhN8MTfRPa+77OZbrV8jR2Se284rXFhGvwb7PpXpDFkpDW2m
         qCGl3FCPlODyNVFjfrqVaO06cHzB9eznxBb/XTEc5V81WepmrISXfv5DlPmp5xm1FZVd
         NyL6QW5coYGAS18/H/rFaBguH5b/PWIcSi4lY8Zb++k4Vm3xahwypHxUWeO1/47TczNL
         AgE+yLdniL6iGPMgYzVLk2H+49qABpH6FDckHRje/VKY8PsepiirtvVQNKX+58aSGzeT
         w/c7v98Sim5Lc0YNCtHis3Q32R136QpbL4ZwsBSeQOBeojmNNgwU9swJ0BsG84cO9WuK
         OuHQ==
X-Gm-Message-State: AOAM5332x7t0oG/h5oZrttmokwWORYbGRwb7W44/6qgul/QzJ6YHOAdn
        +zdUsPSdCxpyIquqwfRWg5bHz4Y3oqch5w==
X-Google-Smtp-Source: ABdhPJx1ReHal4K3RKQ/nxfS6vNNPgewAiUTZPLPXyfuc+SxDdcqS59lQCrkzRpEKpGODMI+fkVwHA==
X-Received: by 2002:a05:620a:408e:b0:6a5:7a3f:471b with SMTP id f14-20020a05620a408e00b006a57a3f471bmr20845094qko.323.1653903943359;
        Mon, 30 May 2022 02:45:43 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id e5-20020a37ac05000000b006a353b7bf78sm6815744qkm.122.2022.05.30.02.45.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 May 2022 02:45:42 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id e184so8651926ybf.8;
        Mon, 30 May 2022 02:45:42 -0700 (PDT)
X-Received: by 2002:a81:2143:0:b0:2fb:1274:247e with SMTP id
 h64-20020a812143000000b002fb1274247emr56723516ywh.384.1653903497533; Mon, 30
 May 2022 02:38:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220526081550.1089805-1-saravanak@google.com>
In-Reply-To: <20220526081550.1089805-1-saravanak@google.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 30 May 2022 11:38:04 +0200
X-Gmail-Original-Message-ID: <CAMuHMdW+Dmi9g=Cw9g5vOa9iYRA+L_ujU9C1-j0eKE7u3EmcFQ@mail.gmail.com>
Message-ID: <CAMuHMdW+Dmi9g=Cw9g5vOa9iYRA+L_ujU9C1-j0eKE7u3EmcFQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/9] deferred_probe_timeout logic clean up
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        John Stultz <jstultz@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Android Kernel Team <kernel-team@android.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saravana,

On Thu, May 26, 2022 at 10:15 AM Saravana Kannan <saravanak@google.com> wrote:
> This series is based on linux-next + these 2 small patches applies on top:
> https://lore.kernel.org/lkml/20220526034609.480766-1-saravanak@google.com/
>
> A lot of the deferred_probe_timeout logic is redundant with
> fw_devlink=on.  Also, enabling deferred_probe_timeout by default breaks
> a few cases.
>
> This series tries to delete the redundant logic, simplify the frameworks
> that use driver_deferred_probe_check_state(), enable
> deferred_probe_timeout=10 by default, and fixes the nfsroot failure
> case.
>
> Patches 1 to 3 are fairly straightforward and can probably be applied
> right away.
>
> Patches 4 to 9 are related and are the complicated bits of this series.
>
> Patch 8 is where someone with more knowledge of the IP auto config code
> can help rewrite the patch to limit the scope of the workaround by
> running the work around only if IP auto config fails the first time
> around. But it's also something that can be optimized in the future
> because it's already limited to the case where IP auto config is enabled
> using the kernel commandline.

Thanks for your series!

> Yoshihiro/Geert,
>
> If you can test this patch series and confirm that the NFS root case
> works, I'd really appreciate that.

On Salvator-XS, Micrel KSZ9031 Gigabit PHY probe is no longer delayed
by 9s after applying the two earlier patches, and the same is true
after applying this series on top.
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

I will do testing on more boards, but that may take a while, as we're
in the middle of the merge window.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
