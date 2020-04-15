Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFE21A955A
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393740AbgDOH5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 03:57:15 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:47070 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390630AbgDOH5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 03:57:14 -0400
Received: by mail-ot1-f66.google.com with SMTP id w12so2455342otm.13;
        Wed, 15 Apr 2020 00:57:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xXgXhC8bKKq0YWfVxUBiOfk11sjnb4Yq0MYMcyVOwhk=;
        b=uoRzIelpJOTD6ZMbglgalFC1WQ7NtrSv/dpsZvfNxOanIKcMSPGRLm9a01/nBUdJQb
         /TmmaGPZ018SqBsUwqOfz9Jiih/A9k2N/qJsU/3fo5jdX9/1j675K558ZVOd+Utu/Ra2
         BwnY5ZzLTMa6m9ZJ3yCEPeIakUT8ekJDHq8w0kNQdtgg+/QB0/DXGCv5yhpxb7sSYo0V
         777dEvkHEp+EOiMA0cEeGkAJUe6dNvTFn51WRs0I3dc5FvunKRxlLvXhW9DMQsQubUsM
         PzqqUYDVNyuisd9pUR5bH0T20vZNr6O91WpibclaqN3zxKBJlSlvGl/3e6em5I5vXgx0
         Nt9g==
X-Gm-Message-State: AGi0PuYe6Qaj3tLkRTIlPAtmmtA5hBTRUWNfePMMNOXLAOfSbaQuP7eC
        dMRVoQywdpVEjh9/Re5hp9We2capVCZKgaapDc0=
X-Google-Smtp-Source: APiQypKtWgKI9+I/2zP/6rCs2aq7ytVskKsUD6aBuiS8gkRwKYf9/0AjV7QdalaJStUWOljfr92SzqIOyeuZJ1rcCx4=
X-Received: by 2002:a9d:76c7:: with SMTP id p7mr20923391otl.145.1586937432508;
 Wed, 15 Apr 2020 00:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200413204253.84991-1-john.stultz@linaro.org> <20200413204253.84991-3-john.stultz@linaro.org>
In-Reply-To: <20200413204253.84991-3-john.stultz@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Apr 2020 09:57:01 +0200
Message-ID: <CAMuHMdUMB2oMMk3dArA1s-VWWmhv0BKQq0=9k_u7t09tqiRJ-w@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] driver core: Ensure wait_for_device_probe() waits
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

On Mon, Apr 13, 2020 at 10:43 PM John Stultz <john.stultz@linaro.org> wrote:
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
