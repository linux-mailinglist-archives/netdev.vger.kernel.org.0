Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3DB61B5599
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbgDWHZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:25:27 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45379 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWHZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 03:25:27 -0400
Received: by mail-oi1-f193.google.com with SMTP id k133so4416554oih.12;
        Thu, 23 Apr 2020 00:25:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hR8qXCUrS03VnRh/6R/411wkkwogCDGoXvXRhMjvIwM=;
        b=WSlXXB0JyekDvRAWPxa01m01YVvu17Ufdn8reO7r4B8Y/ppystzAk0z3IwAEq77aNy
         Q/3d0osO44oOxyTtPC9TodZw46sin87oMWdk+BIt120fN3xJMpmFHbKjn4kwhwH/g7q8
         2yNx/HJUk85YelSeM69j/BA0iuipcC8bq4Y9RcyMUKR7qBXY0J16vpg70Dwd10Lr2m/j
         mgi2Bcv3segf7+xrlQ+EbIS5OWVRb235vfYNEr/THEXh70Mh8Fzg15MWvVGSbjbC+du6
         hLFLF0jbuLtp5dvizb2APDD3+gqHtnqGWzEwOdo5ajT9CXUkods7zmoRmLsS1Zja1t6x
         j5TA==
X-Gm-Message-State: AGi0PuYL3ZctprqIs2TbqOdS0zR30qngHiTUGXIlU/Q1Lj4jzK6nV33I
        4VzwORcS+YEZi2rx/HWCt3thLTeyVP+43PeMdvy2dQHQ
X-Google-Smtp-Source: APiQypKh7H/YNpXfPgiXQOgxdDmnUkhaWZXUcmIZXImqIwH7n2cEj4gwvhMus6vmVezYCn0DcuNCnXRJfr/eRTGFoe0=
X-Received: by 2002:aca:f541:: with SMTP id t62mr1960515oih.148.1587626726069;
 Thu, 23 Apr 2020 00:25:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200422203245.83244-1-john.stultz@linaro.org> <20200422203245.83244-4-john.stultz@linaro.org>
In-Reply-To: <20200422203245.83244-4-john.stultz@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 23 Apr 2020 09:25:15 +0200
Message-ID: <CAMuHMdUFzukkCheNjydt7K1sO1q9y5DQBKEusX+xMeAMY6xqAQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] driver core: Ensure wait_for_device_probe() waits
 until the deferred_probe_timeout fires
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

On Wed, Apr 22, 2020 at 10:33 PM John Stultz <john.stultz@linaro.org> wrote:
> In commit c8c43cee29f6 ("driver core: Fix
> driver_deferred_probe_check_state() logic"), we set the default
> driver_deferred_probe_timeout value to 30 seconds to allow for
> drivers that are missing dependencies to have some time so that
> the dependency may be loaded from userland after initcalls_done
> is set.
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
> This patch tries to fix the issue by creating a waitqueue
> for the driver_deferred_probe_timeout, and calling wait_event()
> to make sure driver_deferred_probe_timeout is zero in
> wait_for_device_probe() to make sure all the probing is
> finished.
>
> The downside to this solution is that kernel functionality that
> uses wait_for_device_probe(), will block until the
> driver_deferred_probe_timeout fires, regardless of if there is
> any missing dependencies.
>
> However, the previous patch reverts the default timeout value to
> zero, so this side-effect will only affect users who specify a
> driver_deferred_probe_timeout= value as a boot argument, where
> the additional delay would be beneficial to allow modules to
> load later during boot.
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

Let's add my
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
for v2.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
