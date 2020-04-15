Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8F491A9540
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 09:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2635385AbgDOHzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 03:55:09 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46926 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2635370AbgDOHzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 03:55:06 -0400
Received: by mail-ot1-f65.google.com with SMTP id w12so2450918otm.13;
        Wed, 15 Apr 2020 00:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EMLxdzTx4bRDoBqt8TK6cHLOd2YxLMbrAy/qWm41Cl0=;
        b=SA5cKDRzqkyo22EuXiXiRemfT3mZlJ9Ozp28BvCgzY6ZmC4gPu+U4ZCgkTXrV0hFLD
         PfjZPke1LTmv21X4IIv019c5PMW5FAsu7KdSz/QuUphse7BtRTdW7do86bpnMt0EYicR
         7X9THZcElIRG98SIPn2VUd3za/Ja8qe2U48ZAZB85yEWj4LuER0DFCxz9NVVRaKu5EIx
         YMrteIYCSSikuqx5xUiikMWDqHg+6pV1ljhWwbTbKB0XlqEXyLd5HSHxl19IqaTXXmOf
         c786VYraFkr03U0ZUzIrNj0SWwHGWopmrivgWXDXx5OXIG3Bz1oyNDZn5UVJgPP/r/LF
         1JuQ==
X-Gm-Message-State: AGi0PuaDS4eMOgXrUe4axsSK8yPHmYjoOlg/wj2oSFFctiJcivDqmgyj
        6sFHrEkuooab6qlCvapTGK8NPTEzoA3Y0tI8GyQ=
X-Google-Smtp-Source: APiQypJCQC4vZmDp8HzpEnQV0Odjn6XbUTubPM5oPHqW8cUfm+GJnNE6af5AI7VlbMmOJhYXOVlsJME3FaAvpGnybj0=
X-Received: by 2002:a4a:95a9:: with SMTP id o38mr21663399ooi.76.1586937305074;
 Wed, 15 Apr 2020 00:55:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200408072650.1731-1-john.stultz@linaro.org>
In-Reply-To: <20200408072650.1731-1-john.stultz@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Apr 2020 09:54:53 +0200
Message-ID: <CAMuHMdWvG+0Wxbj9AdGb1Nwsy+xyoOCWd9xyry54HDSZDzu+HA@mail.gmail.com>
Subject: Re: [RFC][PATCH v2 1/2] driver core: Revert default
 driver_deferred_probe_timeout value to 0
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

On Wed, Apr 8, 2020 at 9:26 AM John Stultz <john.stultz@linaro.org> wrote:
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
