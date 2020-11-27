Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37FC42C62E3
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgK0KQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:16:04 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:45855 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgK0KQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:16:03 -0500
Received: by mail-oi1-f193.google.com with SMTP id l206so5283831oif.12;
        Fri, 27 Nov 2020 02:16:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7Wbkg75HHeDH9lzvcEDkrSEopcYuy5X0pfay3lxJT/U=;
        b=Bv59f9ajCyEA27FJsgN85h7Yl4XWGnCtK/GpZS7jB/mqJwmAJszl1r5WJdVVG9qBnH
         NFnT/KcZHBk7NundlJ1xEeVG+70xYLQ9+azwSPJHrSQW73NDwBsydUD2+Orz9v8jfwja
         k0KDXc8AeE0bufLVZN2T56UjQ+3YvkdTki2NgggpRrX2xE0bZILS+jchWqPez4wqlf7i
         WWHOGE+kA8loh6hpiPX45HmZtxsRyQUv5yBokLbQpFuLwTMCKbR3EY/9CuAncXyJgMHi
         8oSkl56g3gNbID6AhtGxAZrJqHaAsLxErWdt9ILrqDUsyjb4LQ8VHx5EsCh7U4Attlhq
         iPgg==
X-Gm-Message-State: AOAM530NQ8U0tCsUJpIwrsrZGLTcAn0SgnSE8Cj19YsLAiPyD0QAJWv2
        rzjhxKvQ9KdjF4eECZRGciPw+TjBTZlHYNgqYIXIbpmwIGEEzg==
X-Google-Smtp-Source: ABdhPJyE2uBSj5OyERlOdhqrQjNTsdc0yaz/R7+b7XC8oZCy6HcXJh+euHvLRPomMIeQLs8xOyN/Cal46ZX63LiHaZE=
X-Received: by 2002:aca:c3c4:: with SMTP id t187mr4672175oif.148.1606472162705;
 Fri, 27 Nov 2020 02:16:02 -0800 (PST)
MIME-Version: 1.0
References: <20201110092933.3342784-1-zhangqilong3@huawei.com> <20201110092933.3342784-2-zhangqilong3@huawei.com>
In-Reply-To: <20201110092933.3342784-2-zhangqilong3@huawei.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 27 Nov 2020 11:15:51 +0100
Message-ID: <CAMuHMdUH3xnAtQmmMqQDUY5O6H89uk12v6hiZXFThw9yuBAqGQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] PM: runtime: Add pm_runtime_resume_and_get to deal
 with usage counter
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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

Hi Zhang,

On Tue, Nov 10, 2020 at 10:29 AM Zhang Qilong <zhangqilong3@huawei.com> wrote:
> In many case, we need to check return value of pm_runtime_get_sync, but
> it brings a trouble to the usage counter processing. Many callers forget
> to decrease the usage counter when it failed, which could resulted in
> reference leak. It has been discussed a lot[0][1]. So we add a function
> to deal with the usage counter for better coding.
>
> [0]https://lkml.org/lkml/2020/6/14/88
> [1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>

Thanks for your patch, which is now commit dd8088d5a8969dc2 ("PM:
runtime: Add pm_runtime_resume_and_get to deal with usage counter") in
v5.10-rc5.

> --- a/include/linux/pm_runtime.h
> +++ b/include/linux/pm_runtime.h
> @@ -386,6 +386,27 @@ static inline int pm_runtime_get_sync(struct device *dev)
>         return __pm_runtime_resume(dev, RPM_GET_PUT);
>  }
>
> +/**
> + * pm_runtime_resume_and_get - Bump up usage counter of a device and resume it.
> + * @dev: Target device.
> + *
> + * Resume @dev synchronously and if that is successful, increment its runtime
> + * PM usage counter. Return 0 if the runtime PM usage counter of @dev has been
> + * incremented or a negative error code otherwise.
> + */
> +static inline int pm_runtime_resume_and_get(struct device *dev)

Perhaps this function should be called pm_runtime_resume_and_get_sync(),
to make it clear it does a synchronous get?

I had to look into the implementation to verify that a change like

-       ret = pm_runtime_get_sync(&pdev->dev);
+       ret = pm_runtime_resume_and_get(&pdev->dev);

in the follow-up patches is actually a valid change, maintaining
synchronous operation. Oh, pm_runtime_resume() is synchronous, too...

While I agree the old pm_runtime_get_sync() had confusing semantics, we
should go to great lengths to avoid making the same mistake while fixing
it.

> +{
> +       int ret;
> +
> +       ret = __pm_runtime_resume(dev, RPM_GET_PUT);
> +       if (ret < 0) {
> +               pm_runtime_put_noidle(dev);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
>  /**
>   * pm_runtime_put - Drop device usage counter and queue up "idle check" if 0.
>   * @dev: Target device.

Gr{oetje,eeting}s,

                        Geert


--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
