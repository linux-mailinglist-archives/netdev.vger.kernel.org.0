Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69EFA1A95A0
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635470AbgDOIEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635459AbgDOIEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:04:47 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C65C061A0C;
        Wed, 15 Apr 2020 00:56:16 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id l21so2490770otd.9;
        Wed, 15 Apr 2020 00:56:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6qhEV4eqPDnKIu34Gai8AQEIGT47pXx8QxN7ktiAXKQ=;
        b=Nd3F5t4wrHhf0Wkwgv880kLFsUkCJsvY+c0w6VrUGb+XYT/fAm3dt6O7vtn3G1D4fG
         pxP2qvlPgvq2yD/VPFJRB5oF+JrSaDzE7WaPf1JcmNL+WEJCx9aFekeZzRhN8bxK0G3f
         XjQBqw1WINqjIBUfQ5EsWb/TGJp+yzi5v+y/kwaoNGn/PaeWxQDS6ImlC7BijlBkHoUT
         9KoE9rFTmRtuvjicppcpzpd+0d0ISgU4MhZIEMNjD6qBm1REAr0k1Gyy4gI9TGLnQraI
         hvGb56eSXUCu5+NNOrVPYM9uMz8179uFumz8X/ww86wtXvtwdelvtq8D6obRlpC8G01t
         kxqA==
X-Gm-Message-State: AGi0Pubrwv9AbP6AgP2HPTKjGBE5xrsJB+BFy2uMyZtgCdHexKBGjm5w
        2F3PQDq7dYW6XZ7Rk1UlPWIuO6Eo75K9QkCgb50=
X-Google-Smtp-Source: APiQypLtBJDUnnZPjJTN7ovRvwZVePgbjaHZvRdaI+KHQH7TZ3/ZvzMzSdZoDHE2XeuJ/k6BT7ZEas4NquvjvmAykGA=
X-Received: by 2002:a9d:7590:: with SMTP id s16mr21548855otk.250.1586937376197;
 Wed, 15 Apr 2020 00:56:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200413204253.84991-1-john.stultz@linaro.org> <20200413204253.84991-2-john.stultz@linaro.org>
In-Reply-To: <20200413204253.84991-2-john.stultz@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Apr 2020 09:56:05 +0200
Message-ID: <CAMuHMdUqQ45=G29rJNa=FC42wdK_hvYA60FskqW496RbFOZMGw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] driver core: Revert default driver_deferred_probe_timeout
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
        netdev <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 10:43 PM John Stultz <john.stultz@linaro.org> wrote:
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
> Cc: netdev <netdev@vger.kernel.org>
> Cc: linux-pm@vger.kernel.org
> Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic")
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Works fine with all four combinations (CONFIG_IPMMU_VMSA=y/n and
CONFIG_MODULES=y/n)  on Renesas Salvator-X(S) with R-Car Gen3.

Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
