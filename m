Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B132AC05C
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbgKIQAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:00:32 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:39184 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729451AbgKIQAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:00:31 -0500
Received: by mail-ot1-f67.google.com with SMTP id z16so9384612otq.6;
        Mon, 09 Nov 2020 08:00:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dm9RkQCY4JyF3iafyTQ9SSJQRIaiZzcvN4W59n+LBDc=;
        b=TrTdXmoa/btnvM7CVDch+3NibKFrMlfSLS73hZsmEjDLp5R/cuMT9LXEqf8vXm7PH4
         4bLIiiBni9iKUJqLZyoAcz2W9d83X9FjHl7EegUqEDC2Den54/rvDTEsbj/p8ULSZ7nT
         1Q0wkTMHKW/fnlZCi92+FUhz5HW3oC+8/ftjzc+T4qf9JRssTd7TvYNBRIi5xgpwrip3
         IKmXVMYqcJCQ32V0iMaUezJpLDU/RhzvMR76w47hkeX+gHDKcr44q+5/A6PI+EyTZNSE
         ZsQ30kEUeqEscmM2Q3s8wktLtdmfCqBq8ynQJP9n4p3E+grafM0Anf1+7f1ECFBjDrhq
         di+w==
X-Gm-Message-State: AOAM532uuOAZ9TuPHC0GeX2Jklcy3QgkXao4ROvkmkKb7uMCjUtwpVDw
        ox0VlQg5CVlkUSVxbkmuN0w+Tkp+r3gtlZ6DCZ8=
X-Google-Smtp-Source: ABdhPJyHNdFK4akmWbS3+P3KNFuAWo6BUpb3+ZzC89PO++9rJqwWS4CaEVByXO4hgHuVNe2QV2rcwclvZGyosMLmENo=
X-Received: by 2002:a9d:222f:: with SMTP id o44mr11103499ota.321.1604937629188;
 Mon, 09 Nov 2020 08:00:29 -0800 (PST)
MIME-Version: 1.0
References: <20201109150416.1877878-1-zhangqilong3@huawei.com>
 <20201109150416.1877878-2-zhangqilong3@huawei.com> <CAJZ5v0gGG4FeVfrFOYe1+axv78yh9vA4FAOsbLughbsQosP9-w@mail.gmail.com>
 <5acb71f82f144a35b2a5c6bcd73af5a8@huawei.com>
In-Reply-To: <5acb71f82f144a35b2a5c6bcd73af5a8@huawei.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 9 Nov 2020 17:00:17 +0100
Message-ID: <CAJZ5v0g1uzLEUA7uC8QwfFK6TU2=Ngcwcp35bfUwVg-WoTXprg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] PM: runtime: Add a general runtime get sync
 operation to deal with usage counter
To:     zhangqilong <zhangqilong3@huawei.com>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 4:50 PM zhangqilong <zhangqilong3@huawei.com> wrote:
>
> > operation to deal with usage counter
> >
> > On Mon, Nov 9, 2020 at 4:00 PM Zhang Qilong <zhangqilong3@huawei.com>
> > wrote:
> > >
> > > In many case, we need to check return value of pm_runtime_get_sync,
> > > but it brings a trouble to the usage counter processing. Many callers
> > > forget to decrease the usage counter when it failed. It has been
> > > discussed a lot[0][1]. So we add a function to deal with the usage
> > > counter for better coding.
> > >
> > > [0]https://lkml.org/lkml/2020/6/14/88
> > > [1]https://patchwork.ozlabs.org/project/linux-tegra/patch/202005200951
> > > 48.10995-1-dinghao.liu@zju.edu.cn/
> > > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > > ---
> > >  include/linux/pm_runtime.h | 30 ++++++++++++++++++++++++++++++
> > >  1 file changed, 30 insertions(+)
> > >
> > > diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> > > index 4b708f4e8eed..6549ce764400 100644
> > > --- a/include/linux/pm_runtime.h
> > > +++ b/include/linux/pm_runtime.h
> > > @@ -386,6 +386,36 @@ static inline int pm_runtime_get_sync(struct device
> > *dev)
> > >         return __pm_runtime_resume(dev, RPM_GET_PUT);  }
> > >
> > > +/**
> > > + * pm_runtime_general_get - Bump up usage counter of a device and
> > resume it.
> > > + * @dev: Target device.
> > > + *
> > > + * Increase runtime PM usage counter of @dev first, and carry out
> > > +runtime-resume
> > > + * of it synchronously. If __pm_runtime_resume return negative
> > > +value(device is in
> > > + * error state), we to need decrease the usage counter before it
> > > +return. If
> > > + * __pm_runtime_resume return positive value, it means the runtime of
> > > +device has
> > > + * already been in active state, and we let the new wrapper return zero
> > instead.
> > > + *
> > > + * The possible return values of this function is zero or negative value.
> > > + * zero:
> > > + *    - it means resume succeeed or runtime of device has already been
> > active, the
> > > + *      runtime PM usage counter of @dev remains incremented.
> > > + * negative:
> > > + *    - it means failure and the runtime PM usage counter of @dev has
> > been balanced.
> >
> > The kerneldoc above is kind of noisy and it is hard to figure out what the helper
> > really does from it.
> >
> > You could basically say something like "Resume @dev synchronously and if that
> > is successful, increment its runtime PM usage counter.  Return
> > 0 if the runtime PM usage counter of @dev has been incremented or a negative
> > error code otherwise."
> >
>
> How about the following description.
> /**
> 390  * pm_runtime_general_get - Bump up usage counter of a device and resume it.
> 391  * @dev: Target device.
> 392  *
> 393  * Increase runtime PM usage counter of @dev first, and carry out runtime-resume
> 394  * of it synchronously. If __pm_runtime_resume return negative value(device is in
> 395  * error state), we to need decrease the usage counter before it return. If
> 396  * __pm_runtime_resume return positive value, it means the runtime of device has
> 397  * already been in active state, and we let the new wrapper return zero instead.
> 398  *

If you add the paragraph below, the one above becomes redundant IMV.

> 399  * Resume @dev synchronously and if that is successful, and increment its runtime

"Resume @dev synchronously and if that is successful, increment its runtime"

(drop the extra "and").

> 400  * PM usage counter if it turn out to equal to 0. The runtime PM usage counter of

The "if it turn out to equal to 0" phrase is redundant (and the
grammar in it is incorrect).

> 401  * @dev has been incremented or a negative error code otherwise.
> 402  */

Why don't you use what I said verbatim?
