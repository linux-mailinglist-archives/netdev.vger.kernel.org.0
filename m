Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6149D57E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiAZWe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiAZWe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:34:26 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F60C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:34:26 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id g12so967674qto.13
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mcJsU+mcnMj0CQM+nQOjCDKwAKTgftdyWNuTKT5dTKk=;
        b=RoZfoBJmftE5X8DKyLC21xZ8mrCoWSt/mdqKy66qw+SjUmhqvSLDumJNk96Lfw17B2
         7XuPY4g0t7YqGchmjkvybt67T2wkzTSC3CZtLbrjXNuJrLxjXFupAS7wmhcg3cSyBkPV
         8BlS9y0ihTTTP5YSF58BGJJBR/9OJlvLD/sTfEHmdebPJMbZjt7dvFCFOE3dsCGiWDIA
         gITdNtOGZ8yPeWPW6aE4iCH4JjxeoqlSRdSy8oc5gk/KJHxi4I98AvHFADLhR9HJkpop
         HpkyOoHvd+lUngdn+3Uj2rR2y9JrVMnUUuV1WoxK2nverbo4kcXMOpWPIIH+8A1tdg8Y
         ALZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mcJsU+mcnMj0CQM+nQOjCDKwAKTgftdyWNuTKT5dTKk=;
        b=LEiw4WnD7ISGyKZnWjbRZZIozOAeTy89XWFAAzflFVUGgdE7wSEHH+zaAp16aOjs7t
         RKNiqYf3FP6Cag8W6GcNbc96CrsizVPKFezwQXqO8PiaIoRACQcpPcIdeDFmqkA5i4zK
         AAB6YGMO5FXsUSGIu6ugN1RC2pZaWnwKq5WWdAktKfGWuswmnM4dC1vYt4uU7mqrRQwi
         LD95qA6tBPAOfWLfuXjJsk4lCUYic4FQAFAog3jbHq5wqrR33ZefCqdmce0XbeqKu9i6
         cWERq4ZgSLd513bRrwB3uhAxMpfI3NP3jms/Gtxr7SRXzBrRwxtl057fR7RZVHf5up/a
         LW8Q==
X-Gm-Message-State: AOAM533lSuPLj206CiHWbDiUIPVXQoLQfQQFjfJmGV1lWm2AnKGXWURW
        eLLu7ZcQ6nPqTGOjWEqCQ/DMsgZoNPWz4ZlvBcRkfg==
X-Google-Smtp-Source: ABdhPJxJ8Zjl0gp3QnHympeZ2Cyc3Xrk/IHKMjilG6AEsAPvf63zjnC8YXQp4P9y153jxss2Is7ukjvpCtqjOGdlSEY=
X-Received: by 2002:ac8:6897:: with SMTP id m23mr734842qtq.370.1643236465779;
 Wed, 26 Jan 2022 14:34:25 -0800 (PST)
MIME-Version: 1.0
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org> <20220126221725.710167-8-bhupesh.sharma@linaro.org>
In-Reply-To: <20220126221725.710167-8-bhupesh.sharma@linaro.org>
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Date:   Thu, 27 Jan 2022 01:34:14 +0300
Message-ID: <CAA8EJpqVP=E8GkO_BYBdPD6k84SDDD7cWduSf4yhG3M9VmbBLw@mail.gmail.com>
Subject: Re: [PATCH 7/8] clk: qcom: gcc-sm8150: use runtime PM for the clock controller
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, sboyd@kernel.org,
        tdas@codeaurora.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, bjorn.andersson@linaro.org,
        davem@davemloft.net, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jan 2022 at 01:19, Bhupesh Sharma <bhupesh.sharma@linaro.org> wrote:
>
> On sm8150 emac clk registers are powered up by the GDSC power
> domain. Use runtime PM calls to make sure that required power domain is
> powered on while we access clock controller's registers.
>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  drivers/clk/qcom/gcc-sm8150.c | 27 +++++++++++++++++++++++++--
>  1 file changed, 25 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/clk/qcom/gcc-sm8150.c b/drivers/clk/qcom/gcc-sm8150.c
> index ada755ad55f7..2e71afed81fd 100644
> --- a/drivers/clk/qcom/gcc-sm8150.c
> +++ b/drivers/clk/qcom/gcc-sm8150.c
> @@ -5,6 +5,7 @@
>  #include <linux/bitops.h>
>  #include <linux/err.h>
>  #include <linux/platform_device.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/of_device.h>
> @@ -3792,19 +3793,41 @@ static const struct of_device_id gcc_sm8150_match_table[] = {
>  };
>  MODULE_DEVICE_TABLE(of, gcc_sm8150_match_table);
>
> +static void gcc_sm8150_pm_runtime_disable(void *data)
> +{
> +       pm_runtime_disable(data);
> +}
> +
>  static int gcc_sm8150_probe(struct platform_device *pdev)
>  {
>         struct regmap *regmap;
> +       int ret;
> +
> +       pm_runtime_enable(&pdev->dev);
> +
> +       ret = devm_add_action_or_reset(&pdev->dev, gcc_sm8150_pm_runtime_disable, &pdev->dev);
> +       if (ret)
> +               return ret;

Please use devm_pm_runtime_enable() instead.

> +
> +       ret = pm_runtime_resume_and_get(&pdev->dev);
> +       if (ret)
> +               return ret;
>
>         regmap = qcom_cc_map(pdev, &gcc_sm8150_desc);
> -       if (IS_ERR(regmap))
> +       if (IS_ERR(regmap)) {
> +               pm_runtime_put(&pdev->dev);
>                 return PTR_ERR(regmap);
> +       }
>
>         /* Disable the GPLL0 active input to NPU and GPU via MISC registers */
>         regmap_update_bits(regmap, 0x4d110, 0x3, 0x3);
>         regmap_update_bits(regmap, 0x71028, 0x3, 0x3);
>
> -       return qcom_cc_really_probe(pdev, &gcc_sm8150_desc, regmap);
> +       ret = qcom_cc_really_probe(pdev, &gcc_sm8150_desc, regmap);
> +
> +       pm_runtime_put(&pdev->dev);
> +
> +       return ret;
>  }
>
>  static struct platform_driver gcc_sm8150_driver = {
> --
> 2.34.1
>


-- 
With best wishes
Dmitry
