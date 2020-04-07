Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2D771A08A5
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 09:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgDGHu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 03:50:57 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:37861 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgDGHu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 03:50:56 -0400
Received: by mail-oi1-f193.google.com with SMTP id u20so704036oic.4;
        Tue, 07 Apr 2020 00:50:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0xy6duWOZRsuHgXNoNpThMEK6ifcrseX8Tb2v5L0t3w=;
        b=GjmjozCa9XABCQsxu8udzhj+4g0cFo/678VvU34pINIJ8YH8Kji7kPBBFpOI0n47LI
         kgDmxgHmsgUcrQtxFBCPHmB1sTfdzCQQytFnlcL84+rnVc99mBS2FAJSpcZzRWBUdrHq
         jtgtMMx+FV+KN1J0e/ppLVeV/I/vaOcbQQgk0S6rkkVN4l+ZBRFU8RZXWSE0wGglg2Ob
         oDgy7RVN5YwIyoeI2IE3lk8AEtEF5e/wAHZkUGzg1rGmo7SvM5HUZyEZRfUrKgMwkBn9
         ewNBSQhbpMEx5TXUm5mjElvabw7m2HHiLRaIKgJeu1eDyFnQBHztb0jkqO0XPYOns61d
         Bw1w==
X-Gm-Message-State: AGi0Puasw42vU11wl0+z1T4pdTwV4oS+tQ/G98zWBLrUaatDZvuP2E8J
        A+5HJoUpOVO9j6kM9fle04EjIPZw7EK5pbMUXvgnYg==
X-Google-Smtp-Source: APiQypKCWFOch3oAwMdPxUdedE4Y/iCDOJ6IAetbFPjyMJpK27zl1aQSrHJKlOtCDvanLpz5/kdr8tkFj2evA3On/xc=
X-Received: by 2002:aca:cdd1:: with SMTP id d200mr671758oig.153.1586245855947;
 Tue, 07 Apr 2020 00:50:55 -0700 (PDT)
MIME-Version: 1.0
References: <TYAPR01MB45443FA43152C0091D6EBF9AD8C20@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <20200407070609.42865-1-john.stultz@linaro.org>
In-Reply-To: <20200407070609.42865-1-john.stultz@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 7 Apr 2020 09:50:44 +0200
Message-ID: <CAMuHMdWSXvHN5zEh7A+CygxEHP42qFrum+ntiL=m+ATwYOOB0Q@mail.gmail.com>
Subject: Re: [RFC][PATCH] driver core: Ensure wait_for_device_probe() waits
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
        netdev <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi John,

On Tue, Apr 7, 2020 at 9:06 AM John Stultz <john.stultz@linaro.org> wrote:
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
> NOTE: I'm not 100% sure this won't have other unwanted side
> effects (I don't have failing hardware myself to validate),
> so I'd apprecate testing and close review.
>
> If this approach doesn't work, I'll simply set the default
> driver_deferred_probe_timeout value back to zero, to avoid any
> behavioral change from before.
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
> Cc: netdev <netdev@vger.kernel.org>
> Cc: linux-pm@vger.kernel.org
> Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic")
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Thanks, this fixes the issue for me!

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
