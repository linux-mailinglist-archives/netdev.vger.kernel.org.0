Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE9A1B558F
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgDWHXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:23:21 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43477 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWHXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 03:23:21 -0400
Received: by mail-ot1-f66.google.com with SMTP id g14so4480404otg.10;
        Thu, 23 Apr 2020 00:23:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=808ik/GIj3p05dzRzFuD5hpfWtTHwfQKpMCMgwgCEYo=;
        b=QGW8xU5TuWPE14Gjbiw7TxzmHnv5PAIypUvimdvq0xLxzhuzZFVdLsunI8EWsmvcLU
         vVzFmQLDjrN5ukw2fyBlmj+wT1Do8IhHM7UgnJUiGY3P+rCcUXFNnfAIhLEuiKBTpqGv
         H6XrlGOUi5UAMsZoJn3Hk6yhjqymJ4l35cCsDZQzGec/LRVkNzN0NMwvjggwOTjbrCn6
         YXIkhjlAP0axsPtO4pXQdBPJAuExixET8gSN4q5M5Zo2YsT4C9K678ONUI60o4J7vCt2
         23Tc+faPN4pL9Ab0/7xRi6Bj9DGr0Es2vWhz9Cm5UuEGwYGWIilrJh305GoEU2QHEeTY
         t5Sg==
X-Gm-Message-State: AGi0Puaxh/La8QXdiF46MS3yTZ3QySfKW0mXZNp3PQRVkMZL11wVbAaM
        BhMcyo3lexPM2daUrDmwlssLiibBAeHCKiXx2kk=
X-Google-Smtp-Source: APiQypJU8q+H5FfzrBfn/jbknAjDFz4kg6OL+i3iAJ3x8onamLE4aUt/EW2eYvtJc+72svSnN9eBfJmZTnouRQeJIww=
X-Received: by 2002:a9d:564:: with SMTP id 91mr2390779otw.250.1587626600653;
 Thu, 23 Apr 2020 00:23:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200422203245.83244-1-john.stultz@linaro.org> <20200422203245.83244-2-john.stultz@linaro.org>
In-Reply-To: <20200422203245.83244-2-john.stultz@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 23 Apr 2020 09:23:09 +0200
Message-ID: <CAMuHMdX1J=zj4HQOmu8G1GZand=tcXVnWb8bZejtOVyZGvJamA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] driver core: Revert default driver_deferred_probe_timeout
 value to 0
To:     John Stultz <john.stultz@linaro.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Rob Herring <robh@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Basil Eljuse <Basil.Eljuse@arm.com>,
        Ferry Toth <fntoth@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        netdev <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On Wed, Apr 22, 2020 at 10:33 PM John Stultz <john.stultz@linaro.org> wrote:
> This patch addresses a regression in 5.7-rc1+
>
> In commit c8c43cee29f6 ("driver core: Fix
> driver_deferred_probe_check_state() logic"), we both cleaned up
> the logic and also set the default driver_deferred_probe_timeout
> value to 30 seconds to allow for drivers that are missing
> dependencies to have some time so that the dependency may be
> loaded from userland after initcalls_done is set.
>
> However, Yoshihiro Shimoda reported that on his device that
> expects to have unmet dependencies (due to "optional links" in
> its devicetree), was failing to mount the NFS root.
>
> In digging further, it seemed the problem was that while the
> device properly probes after waiting 30 seconds for any missing
> modules to load, the ip_auto_config() had already failed,
> resulting in NFS to fail. This was due to ip_auto_config()
> calling wait_for_device_probe() which doesn't wait for the
> driver_deferred_probe_timeout to fire.
>
> Fixing that issue is possible, but could also introduce 30
> second delays in bootups for users who don't have any
> missing dependencies, which is not ideal.
>
> So I think the best solution to avoid any regressions is to
> revert back to a default timeout value of zero, and allow
> systems that need to utilize the timeout in order for userland
> to load any modules that supply misisng dependencies in the dts
> to specify the timeout length via the exiting documented boot
> argument.
>
> Thanks to Geert for chasing down that ip_auto_config was why NFS
> was failing in this case!
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Cc: Robin Murphy <robin.murphy@arm.com>
> Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
> Cc: Sudeep Holla <sudeep.holla@arm.com>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> Cc: Basil Eljuse <Basil.Eljuse@arm.com>
> Cc: Ferry Toth <fntoth@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Anders Roxell <anders.roxell@linaro.org>
> Cc: netdev <netdev@vger.kernel.org>
> Cc: linux-pm@vger.kernel.org
> Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic")
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Looks like you lost my
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
on v2.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
