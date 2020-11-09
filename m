Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFDE2ABD1D
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 14:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387652AbgKINnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 08:43:25 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:42306 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730419AbgKINAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 08:00:08 -0500
Received: by mail-ot1-f65.google.com with SMTP id 30so3045673otx.9;
        Mon, 09 Nov 2020 05:00:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6uF1/nDxnfFpcdHInj7K0Ga/zyedpjeBwPAvCl11lWs=;
        b=rGnTnX/XRm17U+NHySh0bC4A/ANZ5Iw+9czhRprsQhNCBTe2uuDCXPvyBCOXR/lkX6
         Xln9ALyi4bxaO7DCrVe2MTwPr/QOzZWVO/QL7ryAjhjcy2NF1qJgzK8+Oa5Xscn22tQi
         afRkuqcWN1MzhzTIMGQ04Ap+uoFh0hvdUx2rXzvq4wFQbx5QyYbH2dohJyJHxP24DZ7R
         07m+pTvPxwobL0bRVFIhmWLwPgKKL755S+dm8l3vxnVQBHBXvtEjOIgcK7GrCSesuAab
         nzABeWf/VGedkRiqErtkwPNJ9yI3yV3PCvt0gMz5cbc7vQF4mAkk+WdS70XMBDQCzQND
         w7Kw==
X-Gm-Message-State: AOAM531bj6q+f3S8fq4ld12hrUiX6CL0Cppc6v0esUDfzBREXkDDZV5C
        FqKiMo8EGxLnlqJ4vr09BlE7AO74LFar635YeUk=
X-Google-Smtp-Source: ABdhPJzVCmqe6uLmG54/OBrNeVgEnEjNiX+fLdvVeDQDQJkEnMU7MkjatPJt1QynqYrfHn13969AAC+Imo+3vMm7hMY=
X-Received: by 2002:a9d:16f:: with SMTP id 102mr10900397otu.206.1604926807447;
 Mon, 09 Nov 2020 05:00:07 -0800 (PST)
MIME-Version: 1.0
References: <20201109080938.4174745-1-zhangqilong3@huawei.com> <20201109080938.4174745-2-zhangqilong3@huawei.com>
In-Reply-To: <20201109080938.4174745-2-zhangqilong3@huawei.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 9 Nov 2020 13:59:51 +0100
Message-ID: <CAJZ5v0gZp_R60FN+ZrKmEn+m0F4yjt_MB+N8uGG=fxKUnZdknQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] PM: runtime: Add a general runtime get sync operation
 to deal with usage counter
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>, fugang.duan@nxp.com,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 9:05 AM Zhang Qilong <zhangqilong3@huawei.com> wrote:
>
> In many case, we need to check return value of pm_runtime_get_sync, but
> it brings a trouble to the usage counter processing. Many callers forget
> to decrease the usage counter when it failed. It has been discussed a
> lot[0][1]. So we add a function to deal with the usage counter for better
> coding.
>
> [0]https://lkml.org/lkml/2020/6/14/88
> [1]https://patchwork.ozlabs.org/project/linux-tegra/patch/20200520095148.10995-1-dinghao.liu@zju.edu.cn/
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>  include/linux/pm_runtime.h | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
> index 4b708f4e8eed..2b0af5b1dffd 100644
> --- a/include/linux/pm_runtime.h
> +++ b/include/linux/pm_runtime.h
> @@ -386,6 +386,38 @@ static inline int pm_runtime_get_sync(struct device *dev)
>         return __pm_runtime_resume(dev, RPM_GET_PUT);
>  }
>
> +/**
> + * gene_pm_runtime_get_sync - Bump up usage counter of a device and resume it.
> + * @dev: Target device.

The force argument is not documented.

> + *
> + * Increase runtime PM usage counter of @dev first, and carry out runtime-resume
> + * of it synchronously. If __pm_runtime_resume return negative value(device is in
> + * error state) or return positive value(the runtime of device is already active)
> + * with force is true, it need decrease the usage counter of the device when
> + * return.
> + *
> + * The possible return values of this function is zero or negative value.
> + * zero:
> + *    - it means success and the status will store the resume operation status
> + *      if needed, the runtime PM usage counter of @dev remains incremented.
> + * negative:
> + *    - it means failure and the runtime PM usage counter of @dev has been
> + *      decreased.
> + * positive:
> + *    - it means the runtime of the device is already active before that. If
> + *      caller set force to true, we still need to decrease the usage counter.

Why is this needed?

> + */
> +static inline int gene_pm_runtime_get_sync(struct device *dev, bool force)

The name is not really a good one and note that pm_runtime_get() has
the same problem as _get_sync() (ie. the usage counter is incremented
regardless of the return value).

> +{
> +       int ret = 0;
> +
> +       ret = __pm_runtime_resume(dev, RPM_GET_PUT);
> +       if (ret < 0 || (ret > 0 && force))
> +               pm_runtime_put_noidle(dev);
> +
> +       return ret;
> +}
> +
>  /**
>   * pm_runtime_put - Drop device usage counter and queue up "idle check" if 0.
>   * @dev: Target device.
> --

Thanks!
