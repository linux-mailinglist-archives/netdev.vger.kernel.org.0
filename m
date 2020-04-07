Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94871A145B
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 20:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgDGSij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 14:38:39 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35616 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgDGSii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 14:38:38 -0400
Received: by mail-ot1-f65.google.com with SMTP id v2so4227102oto.2
        for <netdev@vger.kernel.org>; Tue, 07 Apr 2020 11:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DfU5H29fCXE3UgX+4sVCKl7laMGWi7iSdKnWzwJAqFc=;
        b=r3Amgov5t5gHc1Vo6J48zl+Kwo3vO8poNSiulyIrPrwzvvmc+vbExumlXUUezgp2e0
         ahmpdd62XIm162m5mZX27P7RzSvQAjLc8hopGL9glBIVZT4cxLnIkZiayMsUpTYERFhE
         kCIkAEBhIgZXyoUB9Nzt5UtNj7sEwP0fWY129L/TacgRefrZ7gOkLBCoRLwlUnT7xk+w
         cuEjeefzyNNNQWc8hThFdp1JqyLnAoEimChKY9ubvSA0d+CN8nCpBFy6VQfHNkEuMF2N
         Ahk4ha84IJF27fgAaDOlQV1GuDyNZISxoWXaTkz7i4u+BfZKS8a3wvroUIExmQcz7E1v
         5h3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DfU5H29fCXE3UgX+4sVCKl7laMGWi7iSdKnWzwJAqFc=;
        b=L9QRY7oFNmTgPswTNl7edHrq2NzWlUAwQOtydpbY9XLa0hpU5yZM2XVqt8lIvExXcf
         mC+HnQeYv/YfIeZ0etNoUrvBr9UCz3ksqMceu+IaMpwc5zMV/z1FP7gI9WFXzwOHbXEv
         S02k2OZ+r+Lbr4LFZAnbFjC+C90rx43IcO2ImnRN39wJs6VlqnhoEihZuCrztKjTtffV
         3FlP/vnUCc4sCXyv9Y99IznTdErfPg3Q6kxlr6nQsN3ZcnRkUmk6bb0+xbnvZDjjyi5V
         pzmmiglTpwjpF7G2yLi2bv5C432RxJ7uKfNzmHpNStiEPg07meSqtohtKf8+ZLJ8PZlw
         2kZg==
X-Gm-Message-State: AGi0PuaPRRJpa1Xb7IdatioZ/apznWxo4coBpD2KITLFBVaNOblP+W18
        nVGr5uWWCXfn5lHU7F5UsSfeNaDKavH4sgZ5lkfscw==
X-Google-Smtp-Source: APiQypKvRIslouspebvmyiyTT8xoA5MiR6UfoN24Yzn6dDPf3VJZJrZVbdZ4mwOwB4jJHmwtHVaBzLtq5nJkixnQyVY=
X-Received: by 2002:a9d:7349:: with SMTP id l9mr601660otk.221.1586284717081;
 Tue, 07 Apr 2020 11:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <TYAPR01MB45443FA43152C0091D6EBF9AD8C20@TYAPR01MB4544.jpnprd01.prod.outlook.com>
 <20200407070609.42865-1-john.stultz@linaro.org> <CAMuHMdWSXvHN5zEh7A+CygxEHP42qFrum+ntiL=m+ATwYOOB0Q@mail.gmail.com>
 <CAMuHMdXuv1jcuDZLh9TfBQH5Oyf9S8qhVfFbui0a5OpbwUzT8Q@mail.gmail.com>
In-Reply-To: <CAMuHMdXuv1jcuDZLh9TfBQH5Oyf9S8qhVfFbui0a5OpbwUzT8Q@mail.gmail.com>
From:   John Stultz <john.stultz@linaro.org>
Date:   Tue, 7 Apr 2020 11:38:25 -0700
Message-ID: <CALAqxLVCMbHO33P1wF-4bXZ5r7T9Xgw569eVp8e7oM7QSQtjzA@mail.gmail.com>
Subject: Re: [RFC][PATCH] driver core: Ensure wait_for_device_probe() waits
 until the deferred_probe_timeout fires
To:     Geert Uytterhoeven <geert@linux-m68k.org>
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

On Tue, Apr 7, 2020 at 9:46 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> Hi John,
>
> On Tue, Apr 7, 2020 at 9:50 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, Apr 7, 2020 at 9:06 AM John Stultz <john.stultz@linaro.org> wrote:
> > > In commit c8c43cee29f6 ("driver core: Fix
> > > driver_deferred_probe_check_state() logic"), we set the default
> > > driver_deferred_probe_timeout value to 30 seconds to allow for
> > > drivers that are missing dependencies to have some time so that
> > > the dependency may be loaded from userland after initcalls_done
> > > is set.
> > >
> > > However, Yoshihiro Shimoda reported that on his device that
> > > expects to have unmet dependencies (due to "optional links" in
> > > its devicetree), was failing to mount the NFS root.
> > >
> > > In digging further, it seemed the problem was that while the
> > > device properly probes after waiting 30 seconds for any missing
> > > modules to load, the ip_auto_config() had already failed,
> > > resulting in NFS to fail. This was due to ip_auto_config()
> > > calling wait_for_device_probe() which doesn't wait for the
> > > driver_deferred_probe_timeout to fire.
> > >
> > > This patch tries to fix the issue by creating a waitqueue
> > > for the driver_deferred_probe_timeout, and calling wait_event()
> > > to make sure driver_deferred_probe_timeout is zero in
> > > wait_for_device_probe() to make sure all the probing is
> > > finished.
> > >
> > > NOTE: I'm not 100% sure this won't have other unwanted side
> > > effects (I don't have failing hardware myself to validate),
> > > so I'd apprecate testing and close review.
> > >
> > > If this approach doesn't work, I'll simply set the default
> > > driver_deferred_probe_timeout value back to zero, to avoid any
> > > behavioral change from before.
> > >
> > > Thanks to Geert for chasing down that ip_auto_config was why NFS
> > > was failing in this case!
> > >
> > > Cc: "David S. Miller" <davem@davemloft.net>
> > > Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
> > > Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
> > > Cc: Jakub Kicinski <kuba@kernel.org>
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > > Cc: Rob Herring <robh@kernel.org>
> > > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > > Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > Cc: netdev <netdev@vger.kernel.org>
> > > Cc: linux-pm@vger.kernel.org
> > > Reported-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > Fixes: c8c43cee29f6 ("driver core: Fix driver_deferred_probe_check_state() logic")
> > > Signed-off-by: John Stultz <john.stultz@linaro.org>
> >
> > Thanks, this fixes the issue for me!
> >
> > Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Unfortunately this adds another delay of ca. 30 s to mounting NFS root
> when using a kernel config that does include IOMMU and MODULES
> support.

Yea. I worry the other downside is that systems with no missing
dependencies will also see the stall here since we're waiting for the
timeout regardless of if there's any drivers missing.

So in the light of morning (well, just barely), I think just setting
the probe timeout to zero by default is the best approach. The series
then doesn't change behavior but just cleans things up.

Though, I guess one could argue this fix should go along with setting
the value to zero, so at least if folks specify a delay on the boot
cmd, things don't fail because they didn't wait.

thanks
-john
