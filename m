Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31EBE1A11FD
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 18:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgDGQqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 12:46:14 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:42989 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgDGQqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 12:46:14 -0400
Received: by mail-ot1-f68.google.com with SMTP id z5so3791385oth.9;
        Tue, 07 Apr 2020 09:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xdgq/m7wdEH2dNnMYJSAVng7ahhHHb6G51Gt5KF/eIE=;
        b=s4Lo3YTd/0taYIpS/hvoRk2OPALB6aVfQbAzrtaBMDyyOWxo8unOLTX1mfFXkh+Rsr
         VvImF9fLGZQJtSzd/BD4SZ6ywE1JwWl8BtX+odVNtnXhVD/kh2l64EZYxUeDq+Mxg3mH
         K96189OihepaUS8GSBYwwEzijhXyty2os9fFw+ua9cGJ/lahPaEWryoInNEQQzBh2JWF
         Fu0p5DhxmsIXyPI1r96X5RpbXxqYfl6HwEtgD6wdja2E5dtDchGulg14FMkyVzNprLOJ
         q9HWUbFjqJgt+90T2htK7jvVbbpOnoznW2nswZ9Fd83SUTdr7LHyfY15KpnTFGL7pCuW
         +Urw==
X-Gm-Message-State: AGi0PuZAEKxB+aDnr6+HjDwYmlYAETqoJTrTZA6PS/Sy2b3NqN2wFa8J
        OV/wXMIEzzPu892pnUsD+7mPLyu5TNdA5GQCvWhO7w==
X-Google-Smtp-Source: APiQypLogSYV3HvxMl0VRU89DMEYJGXNCu+UCkIvB4GBviiOYEGYq/g1ev39Gp3mREmZ4fVibatgIevbBQUdtEI/q6I=
X-Received: by 2002:a4a:a442:: with SMTP id w2mr2604642ool.90.1586277973542;
 Tue, 07 Apr 2020 09:46:13 -0700 (PDT)
MIME-Version: 1.0
References: <TYAPR01MB45443FA43152C0091D6EBF9AD8C20@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <20200407070609.42865-1-john.stultz@linaro.org> <CAMuHMdWSXvHN5zEh7A+CygxEHP42qFrum+ntiL=m+ATwYOOB0Q@mail.gmail.com>
In-Reply-To: <CAMuHMdWSXvHN5zEh7A+CygxEHP42qFrum+ntiL=m+ATwYOOB0Q@mail.gmail.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 7 Apr 2020 18:46:02 +0200
Message-ID: <CAMuHMdXuv1jcuDZLh9TfBQH5Oyf9S8qhVfFbui0a5OpbwUzT8Q@mail.gmail.com>
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

On Tue, Apr 7, 2020 at 9:50 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Apr 7, 2020 at 9:06 AM John Stultz <john.stultz@linaro.org> wrote:
> > In commit c8c43cee29f6 ("driver core: Fix
> > driver_deferred_probe_check_state() logic"), we set the default
> > driver_deferred_probe_timeout value to 30 seconds to allow for
> > drivers that are missing dependencies to have some time so that
> > the dependency may be loaded from userland after initcalls_done
> > is set.
> >
> > However, Yoshihiro Shimoda reported that on his device that
> > expects to have unmet dependencies (due to "optional links" in
> > its devicetree), was failing to mount the NFS root.
> >
> > In digging further, it seemed the problem was that while the
> > device properly probes after waiting 30 seconds for any missing
> > modules to load, the ip_auto_config() had already failed,
> > resulting in NFS to fail. This was due to ip_auto_config()
> > calling wait_for_device_probe() which doesn't wait for the
> > driver_deferred_probe_timeout to fire.
> >
> > This patch tries to fix the issue by creating a waitqueue
> > for the driver_deferred_probe_timeout, and calling wait_event()
> > to make sure driver_deferred_probe_timeout is zero in
> > wait_for_device_probe() to make sure all the probing is
> > finished.
> >
> > NOTE: I'm not 100% sure this won't have other unwanted side
> > effects (I don't have failing hardware myself to validate),
> > so I'd apprecate testing and close review.
> >
> > If this approach doesn't work, I'll simply set the default
> > driver_deferred_probe_timeout value back to zero, to avoid any
> > behavioral change from before.
> >
> > Thanks to Geert for chasing down that ip_auto_config was why NFS
> > was failing in this case!
> >
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > Cc: Jakub Kicinski <kuba@kernel.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > Cc: Rob Herring <robh@kernel.org>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > Cc: netdev <netdev@vger.kernel.org>
> > Cc: linux-pm@vger.kernel.org
> > Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic")
> > Signed-off-by: John Stultz <john.stultz@linaro.org>
>
> Thanks, this fixes the issue for me!
>
> Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Unfortunately this adds another delay of ca. 30 s to mounting NFS root
when using a kernel config that does include IOMMU and MODULES
support.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
