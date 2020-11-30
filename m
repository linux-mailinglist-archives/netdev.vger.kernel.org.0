Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665472C8BE1
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbgK3R4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:56:55 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41576 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387628AbgK3R4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 12:56:54 -0500
Received: by mail-ot1-f68.google.com with SMTP id f48so3644568otf.8;
        Mon, 30 Nov 2020 09:56:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3J9vHGgX384Mv59V8Yzoh8YJaanP/qpq9AKqTPGTkyA=;
        b=aDWo7N0GbQYSqOgk9WlA7BgJcQP68VU9AixqIDrMshOwt+Tp1gubMeoTK2F8uYnm9n
         OSc2pHzQVVz/2j5npP/WaoZ3aCsrAFyMw68iNr5Xy/LnWEUDYUZJSGcEKmfszXkTU3HW
         mSCpAvkaz5tCmVccZvaflUaYoYSvpavRN4a4wt8Hum2l1xfO/Yd+iKb9hXLtv++/Q433
         PGRU5kAzVGo5WGC66kubnkUzzw2LBZSLrWCmSc2LhGnMvXbVvVLe0FTjvpJNXWPhP+wo
         Bo3D9BDu5E+OpdnYmhjMb1IDpkhcm27jHr+8XBAyoVpgBV3d92Erjeb+OiJvB22Oj3cx
         Gamw==
X-Gm-Message-State: AOAM533Si0vl+uRe6N+VHMfPRfQjFM3DAZehXCygqMr0XKSjoRujVerC
        eWeoU/8Cv+ibOxDSfIut7x2/8yzVmW/dZjLnwcc=
X-Google-Smtp-Source: ABdhPJyOyzOv7g3UO+bB7NRPSNYwVM12W/SgLVj0YLuv0g6SlhIFesOsvOsdT+NKlP8wVbRMo1MfIKNpLbtQqHfV3Cw=
X-Received: by 2002:a9d:171a:: with SMTP id i26mr17809015ota.260.1606758968058;
 Mon, 30 Nov 2020 09:56:08 -0800 (PST)
MIME-Version: 1.0
References: <20201110092933.3342784-1-zhangqilong3@huawei.com>
 <20201110092933.3342784-2-zhangqilong3@huawei.com> <CAMuHMdUH3xnAtQmmMqQDUY5O6H89uk12v6hiZXFThw9yuBAqGQ@mail.gmail.com>
 <CAJZ5v0hVXSgUm877iv3i=1vs1t2QFpGW=-4qTFf2WedTJBU8Zg@mail.gmail.com> <20201130173523.GT14465@pendragon.ideasonboard.com>
In-Reply-To: <20201130173523.GT14465@pendragon.ideasonboard.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 30 Nov 2020 18:55:57 +0100
Message-ID: <CAJZ5v0gx08RY+RjU90y222fLUq7YiO4x6PW3d9GNk4wYadzv_w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] PM: runtime: Add pm_runtime_resume_and_get to deal
 with usage counter
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Zhang Qilong <zhangqilong3@huawei.com>,
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

On Mon, Nov 30, 2020 at 6:35 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> On Mon, Nov 30, 2020 at 05:37:52PM +0100, Rafael J. Wysocki wrote:
> > On Fri, Nov 27, 2020 at 11:16 AM Geert Uytterhoeven wrote:
> > > On Tue, Nov 10, 2020 at 10:29 AM Zhang Qilong <zhangqilong3@huawei.com> wrote:
> > > > In many case, we need to check return value of pm_runtime_get_sync, but
> > > > it brings a trouble to the usage counter processing. Many callers forget
> > > > to decrease the usage counter when it failed, which could resulted in
> > > > reference leak. It has been discussed a lot[0][1]. So we add a function
> > > > to deal with the usage counter for better coding.
> > > >
> > > > [0]https://lkml.org/lkml/2020/6/14/88
> > > > [1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139
> > > > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > >
> > > Thanks for your patch, which is now commit dd8088d5a8969dc2 ("PM:
> > > runtime: Add pm_runtime_resume_and_get to deal with usage counter") in
> > > v5.10-rc5.
> > >
> > > > --- a/include/linux/pm_runtime.h
> > > > +++ b/include/linux/pm_runtime.h
> > > > @@ -386,6 +386,27 @@ static inline int pm_runtime_get_sync(struct device *dev)
> > > >         return __pm_runtime_resume(dev, RPM_GET_PUT);
> > > >  }
> > > >
> > > > +/**
> > > > + * pm_runtime_resume_and_get - Bump up usage counter of a device and resume it.
> > > > + * @dev: Target device.
> > > > + *
> > > > + * Resume @dev synchronously and if that is successful, increment its runtime
> > > > + * PM usage counter. Return 0 if the runtime PM usage counter of @dev has been
> > > > + * incremented or a negative error code otherwise.
> > > > + */
> > > > +static inline int pm_runtime_resume_and_get(struct device *dev)
> > >
> > > Perhaps this function should be called pm_runtime_resume_and_get_sync(),
> >
> > No, really.
> >
> > I might consider calling it pm_runtime_acquire(), and adding a
> > matching _release() as a pm_runtime_get() synonym for that matter, but
> > not the above.
>
> pm_runtime_acquire() seems better to me too. Would pm_runtime_release()
> would be an alias for pm_runtime_put() ?

Yes.  This covers all of the use cases relevant for drivers AFAICS.

> We would also likely need a pm_runtime_release_autosuspend() too then.

Why would we?

> But on that topic, I was wondering, is there a reason we can't select
> autosuspend behaviour automatically when autosuspend is enabled ?

That is the case already.

pm_runtime_put() will autosuspend if enabled and the usage counter is
0, as long as ->runtime_idle() returns 0 (or is absent).

pm_runtime_put_autosuspend() is an optimization allowing
->runtime_idle() to be skipped entirely, but I'm wondering how many
users really need that.
