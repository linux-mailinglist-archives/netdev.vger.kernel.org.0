Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA962C89B2
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 17:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgK3Qiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 11:38:51 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37075 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgK3Qiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 11:38:50 -0500
Received: by mail-ot1-f66.google.com with SMTP id l36so11889009ota.4;
        Mon, 30 Nov 2020 08:38:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j1tOA2QFb861fJIhjPhICzbVGAPhE/EoBqZiri0QzCg=;
        b=E5ycOzYp4Pr8szTAEiY9nbLXnJWBXMgfRlQNOoD3ZQf/WFZ1OIR9X7h6+uQLreBf9B
         rQRp+Rh71fVaffF66R4uHfJshsZBPNgM0bjhxZS1lhoQJdlTojw+UBxXrKaNgmJbjsvv
         dGSpY8X+Xha4zLbNGo2Plv7oQ/n3wMIV9kRHN6sWODSDEZ0pkSt+ep9hDZjH1mlo5bIn
         HKzN8ELooraUw48gw00+H08RHHgqeDHksfW+PZHHeYFgGdLiFs0uFuw4Mp5O50/idTTJ
         4LTA/cSv350QEKIYDshz8PfMBSxoBtsWG5KeI2OLT0DJ+Kt325rECKlwT7lFhaGekTd4
         6dnA==
X-Gm-Message-State: AOAM5331O44IH+Os8hWS7EGP2Ce4e8BbzisZsVyvR3VivZr9elyGDJQx
        1D4E16mF665QqSTCb0hVpDTuKuKYhdi+ec7bHtQ=
X-Google-Smtp-Source: ABdhPJznLsbs+YsdRJTngNu4A/VigxgyG8IVgL6HbhqIGKuRCbfCRNuXZkBgpyedGvmqROJLGv6AfG+tViE+/nXNE2k=
X-Received: by 2002:a05:6830:2385:: with SMTP id l5mr17132783ots.321.1606754283665;
 Mon, 30 Nov 2020 08:38:03 -0800 (PST)
MIME-Version: 1.0
References: <20201110092933.3342784-1-zhangqilong3@huawei.com>
 <20201110092933.3342784-2-zhangqilong3@huawei.com> <CAMuHMdUH3xnAtQmmMqQDUY5O6H89uk12v6hiZXFThw9yuBAqGQ@mail.gmail.com>
In-Reply-To: <CAMuHMdUH3xnAtQmmMqQDUY5O6H89uk12v6hiZXFThw9yuBAqGQ@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 30 Nov 2020 17:37:52 +0100
Message-ID: <CAJZ5v0hVXSgUm877iv3i=1vs1t2QFpGW=-4qTFf2WedTJBU8Zg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] PM: runtime: Add pm_runtime_resume_and_get to deal
 with usage counter
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 11:16 AM Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
>
> Hi Zhang,
>
> On Tue, Nov 10, 2020 at 10:29 AM Zhang Qilong <zhangqilong3@huawei.com> wrote:
> > In many case, we need to check return value of pm_runtime_get_sync, but
> > it brings a trouble to the usage counter processing. Many callers forget
> > to decrease the usage counter when it failed, which could resulted in
> > reference leak. It has been discussed a lot[0][1]. So we add a function
> > to deal with the usage counter for better coding.
> >
> > [0]https://lkml.org/lkml/2020/6/14/88
> > [1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139
> > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
>
> Thanks for your patch, which is now commit dd8088d5a8969dc2 ("PM:
> runtime: Add pm_runtime_resume_and_get to deal with usage counter") in
> v5.10-rc5.
>
> > --- a/include/linux/pm_runtime.h
> > +++ b/include/linux/pm_runtime.h
> > @@ -386,6 +386,27 @@ static inline int pm_runtime_get_sync(struct device *dev)
> >         return __pm_runtime_resume(dev, RPM_GET_PUT);
> >  }
> >
> > +/**
> > + * pm_runtime_resume_and_get - Bump up usage counter of a device and resume it.
> > + * @dev: Target device.
> > + *
> > + * Resume @dev synchronously and if that is successful, increment its runtime
> > + * PM usage counter. Return 0 if the runtime PM usage counter of @dev has been
> > + * incremented or a negative error code otherwise.
> > + */
> > +static inline int pm_runtime_resume_and_get(struct device *dev)
>
> Perhaps this function should be called pm_runtime_resume_and_get_sync(),

No, really.

I might consider calling it pm_runtime_acquire(), and adding a
matching _release() as a pm_runtime_get() synonym for that matter, but
not the above.

> to make it clear it does a synchronous get?
>
> I had to look into the implementation to verify that a change like

I'm not sure why, because the kerneldoc is unambiguous AFAICS.

>
> -       ret = pm_runtime_get_sync(&pdev->dev);
> +       ret = pm_runtime_resume_and_get(&pdev->dev);
>
> in the follow-up patches is actually a valid change, maintaining
> synchronous operation. Oh, pm_runtime_resume() is synchronous, too...

Yes, it is.
