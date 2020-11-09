Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFC42AC045
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbgKIPyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:54:11 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37736 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729302AbgKIPyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:54:11 -0500
Received: by mail-ot1-f65.google.com with SMTP id l36so9381062ota.4;
        Mon, 09 Nov 2020 07:54:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lKVvLVZefOAL5DWeQTQm2qn558EoCC4J5KNFm0S/6hs=;
        b=pMX4qjy6Y3mjzXZ89XpC4w/aXC3CuMebDWW7HyZKskwkfX7AMRs3If03voO4wRrMRa
         RJlEOhXsjHWD+rgjWHmKKfCCCjs0Tm2yDUYoO5IMCzav4uWFjDbm1H01xmLxRm7tAGcq
         uiUwrXy8bz/C+VNhIMEXs1TYHCHdsLn8frROlfj7C2Hcvd6b+jkJTXEjmAbQjIGuvMYX
         7GEioFoMmjzl8YDuv+EFOaTHUcLwLDpFJ8PxLM78w6gGeoRm0nbP6DKNJsWf6zil161I
         XMB/HBKiqfpAxcMKuKLt7s8Vn5CFH5W9NE5nktDkX+z5vhNMj6gHp+Eh5NJ6ZAdKj+zy
         b6yw==
X-Gm-Message-State: AOAM531Az/xRCU6wUV3SYfF3iqPpagd0icyhDR8V3wkqh1jjjQOeVZ+h
        AXkYHAlVtZ6T88NmXzqkP3fK70GRkX4/YNfcCpc=
X-Google-Smtp-Source: ABdhPJzQBwdiGIpAMFtpH9CrblAwwoEPOFUQj9qJW2BETLPwj7y5RqhvN4Fbk/Q0zr5+AGvwBfiDIOhzX8LMVHkFoEY=
X-Received: by 2002:a9d:171a:: with SMTP id i26mr11356995ota.260.1604937249238;
 Mon, 09 Nov 2020 07:54:09 -0800 (PST)
MIME-Version: 1.0
References: <20201109150416.1877878-1-zhangqilong3@huawei.com>
 <20201109150416.1877878-2-zhangqilong3@huawei.com> <CAJZ5v0gGG4FeVfrFOYe1+axv78yh9vA4FAOsbLughbsQosP9-w@mail.gmail.com>
 <CAPDyKFr-XCAWKQiN29s-=XusqqPSqumK9wZVePT+5C7J43BKqA@mail.gmail.com>
In-Reply-To: <CAPDyKFr-XCAWKQiN29s-=XusqqPSqumK9wZVePT+5C7J43BKqA@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 9 Nov 2020 16:53:57 +0100
Message-ID: <CAJZ5v0gZo=kvWWSOTzNaYohr1Yk0iiZnj3+WZbq+jK3HXLu16g@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] PM: runtime: Add a general runtime get sync
 operation to deal with usage counter
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Zhang Qilong <zhangqilong3@huawei.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Fugang Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 4:50 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Mon, 9 Nov 2020 at 16:20, Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Mon, Nov 9, 2020 at 4:00 PM Zhang Qilong <zhangqilong3@huawei.com> wrote:
> > >
> > > In many case, we need to check return value of pm_runtime_get_sync, but
> > > it brings a trouble to the usage counter processing. Many callers forget
> > > to decrease the usage counter when it failed. It has been discussed a
> > > lot[0][1]. So we add a function to deal with the usage counter for better
> > > coding.
> > >
> > > [0]https://lkml.org/lkml/2020/6/14/88
> > > [1]https://patchwork.ozlabs.org/project/linux-tegra/patch/20200520095148.10995-1-dinghao.liu@zju.edu.cn/
> > > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > > ---
> > >  include/linux/pm_runtime.h | 30 ++++++++++++++++++++++++++++++
> > >  1 file changed, 30 insertions(+)
> > >
> > > diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> > > index 4b708f4e8eed..6549ce764400 100644
> > > --- a/include/linux/pm_runtime.h
> > > +++ b/include/linux/pm_runtime.h
> > > @@ -386,6 +386,36 @@ static inline int pm_runtime_get_sync(struct device *dev)
> > >         return __pm_runtime_resume(dev, RPM_GET_PUT);
> > >  }
> > >
> > > +/**
> > > + * pm_runtime_general_get - Bump up usage counter of a device and resume it.
> > > + * @dev: Target device.
> > > + *
> > > + * Increase runtime PM usage counter of @dev first, and carry out runtime-resume
> > > + * of it synchronously. If __pm_runtime_resume return negative value(device is in
> > > + * error state), we to need decrease the usage counter before it return. If
> > > + * __pm_runtime_resume return positive value, it means the runtime of device has
> > > + * already been in active state, and we let the new wrapper return zero instead.
> > > + *
> > > + * The possible return values of this function is zero or negative value.
> > > + * zero:
> > > + *    - it means resume succeeed or runtime of device has already been active, the
> > > + *      runtime PM usage counter of @dev remains incremented.
> > > + * negative:
> > > + *    - it means failure and the runtime PM usage counter of @dev has been balanced.
> >
> > The kerneldoc above is kind of noisy and it is hard to figure out what
> > the helper really does from it.
> >
> > You could basically say something like "Resume @dev synchronously and
> > if that is successful, increment its runtime PM usage counter.  Return
> > 0 if the runtime PM usage counter of @dev has been incremented or a
> > negative error code otherwise."
> >
> > > + */
> > > +static inline int pm_runtime_general_get(struct device *dev)
> >
> > What about pm_runtime_resume_and_get()?
>
> We already have pm_runtime_get_if_active() - so perhaps
> pm_runtime_get_if_suspended() could be an option as well?

It doesn't work this way, though.

The "get" happens even if the device has not been suspended.
