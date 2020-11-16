Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDEA2B43FB
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 13:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgKPMt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 07:49:28 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:40013 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgKPMt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 07:49:28 -0500
Received: by mail-ot1-f66.google.com with SMTP id 79so15833532otc.7;
        Mon, 16 Nov 2020 04:49:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CXcRpvGMjC9ECOCitHAoHbBvhMsiRSAzg+RNY8NgHng=;
        b=rtybvbu7YTP3P+i3iIjSRebPWvKrP6lMO9NefcgVcCSHGVgwFpwReuquAO20cNh3mI
         077Enz1RGNrV8UMuY2Ulzo2xCeyrhm0ZN+NLyo9enXAwNsWEqfgTjQ24HsQMj8wsGgUv
         ZdOxh82CfSTlDOgmu21EQTCBuEBVgWp/8gA4jDVG3dx6LTrecOjMFjuejACgARXHEoEV
         oqHelvUdWgWMxK+UCEbysYMmQQqYBWyANsP7lo0e1mU8WyEMzdyea3D8SSIxL1C6SOh9
         i3uNEsjQYmz2NpfQvYN5eAYQN0MfTSWinYVgWbjZFPis+siFHiIVLQ6l+Xn9UzSvSQHD
         C8NQ==
X-Gm-Message-State: AOAM532SqE4FefgRvHFCwJq6xRGNn6g0RCTSLQ9st3HB31KjK9CLPUwP
        3W+ydGBjCUU4kN5TDoWXtaENclfWLfY7gOP6TCA=
X-Google-Smtp-Source: ABdhPJxpItKyRsx+HldswW89kjrf1SDWdvLupgfhlW8+FjRTxEdMt0jRYD//HDsmugNkNcVd/MOKL9/k9NNhlWt9Bms=
X-Received: by 2002:a9d:171a:: with SMTP id i26mr10886990ota.260.1605530967368;
 Mon, 16 Nov 2020 04:49:27 -0800 (PST)
MIME-Version: 1.0
References: <20201110092933.3342784-1-zhangqilong3@huawei.com> <20201110092933.3342784-2-zhangqilong3@huawei.com>
In-Reply-To: <20201110092933.3342784-2-zhangqilong3@huawei.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 16 Nov 2020 13:49:10 +0100
Message-ID: <CAJZ5v0hmhT4tg5hAD3jx7Xh=Ot7-jNMO0WtSS6-nz0Nw857+0w@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] PM: runtime: Add pm_runtime_resume_and_get to deal
 with usage counter
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Fugang Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 10:25 AM Zhang Qilong <zhangqilong3@huawei.com> wrote:
>
> In many case, we need to check return value of pm_runtime_get_sync, but
> it brings a trouble to the usage counter processing. Many callers forget
> to decrease the usage counter when it failed, which could resulted in
> reference leak. It has been discussed a lot[0][1]. So we add a function
> to deal with the usage counter for better coding.
>
> [0]https://lkml.org/lkml/2020/6/14/88
> [1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>

Acked-by: Rafael J. Wysocki  <rafael.j.wysocki@intel.com>

> ---
>  include/linux/pm_runtime.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> index 4b708f4e8eed..b492ae00cc90 100644
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
> --
> 2.25.4
>
