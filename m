Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD5461A8E6B
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 00:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387494AbgDNWO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 18:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732989AbgDNWOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 18:14:55 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CB4C061A0F
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 15:14:54 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a25so16459114wrd.0
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 15:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tFNbkDDuu+xJJGMOQnSsTSZToEf+DrCp0hBRrSm4NEc=;
        b=qabW9Cwsrm5flCJViset/DUU4XAV92iY6uYTR6CKgMWINRrDE/p0FdK2jJYOTZGz+/
         s7esIJSyksYapk5/fn6o0kQ6QRp0KX+QMW66qQvkBQ321UC34lorcDk1XNHw9XKLl4sn
         Van8EM9t8zDbWrbFSGieU/bvQFG4SG7dKeGOGtTc4P1ZhF99ggZrLcsQm+hS+o5GYs7y
         HaRMSFJD3RGWsF683rGYkcbQOUo4/wYjoAOfk4jrsHcsH8OZOojhBUoAvY1OlwRaXLoL
         P5tjnf86p6ZwIpdaDB7apkv1IHWCqfM8M8CYXECtoj4tIYqk6jV/clruQ0aO0t1jf6qX
         yELg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tFNbkDDuu+xJJGMOQnSsTSZToEf+DrCp0hBRrSm4NEc=;
        b=rvrIn80Ge3dOM6xrQhEio9Q8dclFBIsR/teG5ROR42fOwb90eC2gs7NNjyC6s+X3/b
         oleOx8/8V7WTd5hSCliLyFpWLq7W3vx9vxuUOjdzSnWbE1bxniaxiRW8GtqrGOWpdOp5
         q6uON1yGJW3IcSww9QyJfPdsVezv6iJBy941nnDFRdqcjXJMR0XfjIay+568ijDMTu3G
         VVVeGtvWntBbVrvPTz7DGv0RttRQANVcB8qG+oSfag5G89ifkmWXVHJ/qzTmFAwCQMQb
         EuISTa4asIiM3sEcBIMqBJBLMG8bDtWGHPwx6K9KKUA8sLPytJYFrXSjt02fbxM89qB8
         wKVg==
X-Gm-Message-State: AGi0PubpeGGPEfUpuKemDQQ1ovwejw0TAu7EMtuCjFAnLXXmTE25UPUa
        o6O09acNe8J0hKTIWgCv2HNm4Q==
X-Google-Smtp-Source: APiQypJCM7RZYbnn05d5p3O23E+0h2bnGY34lOEUBW3XV9QKLjxerTTj5VEgsJydss45wo2Ye1GFqg==
X-Received: by 2002:adf:fc4c:: with SMTP id e12mr25646050wrs.265.1586902493086;
        Tue, 14 Apr 2020 15:14:53 -0700 (PDT)
Received: from [192.168.0.41] (lns-bzn-59-82-252-135-148.adsl.proxad.net. [82.252.135.148])
        by smtp.googlemail.com with ESMTPSA id k184sm20036949wmf.9.2020.04.14.15.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 15:14:52 -0700 (PDT)
Subject: Re: [RFC v2 3/9] thermal: Properly handle mode values in .set_mode()
To:     Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        linux-pm@vger.kernel.org
Cc:     Zhang Rui <rui.zhang@intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Len Brown <lenb@kernel.org>, Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Peter Kaestle <peter@piie.net>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Support Opensource <support.opensource@diasemi.com>,
        Amit Kucheria <amit.kucheria@verdurent.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Allison Randal <allison@lohutok.net>,
        Enrico Weigelt <info@metux.net>,
        Gayatri Kammela <gayatri.kammela@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <2bc5a902-acde-526a-11a5-2357d899916c@linaro.org>
 <20200414180105.20042-1-andrzej.p@collabora.com>
 <20200414180105.20042-4-andrzej.p@collabora.com>
From:   Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <e7ed4bcf-8605-c6ad-4412-acb33251a0b3@linaro.org>
Date:   Wed, 15 Apr 2020 00:14:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200414180105.20042-4-andrzej.p@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Andrzej,

you can drop this patch. It is not useful as the caller checks the
correctness of the values in the patch 4/9.

Moreover the patch is bogus because it returns before releasing the lock.

On 14/04/2020 20:00, Andrzej Pietrasiewicz wrote:
> Allow only THERMAL_DEVICE_ENABLED and THERMAL_DEVICE_DISABLED as valid
> states to transition to.




> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
> ---
>  drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 8 ++++++--
>  drivers/platform/x86/acerhdf.c                     | 4 ++++
>  drivers/thermal/imx_thermal.c                      | 4 +++-
>  drivers/thermal/intel/intel_quark_dts_thermal.c    | 5 ++++-
>  drivers/thermal/of-thermal.c                       | 4 +++-
>  5 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index ce0a6837daa3..cd435ca7adbe 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -296,8 +296,10 @@ static int mlxsw_thermal_set_mode(struct thermal_zone_device *tzdev,
>  
>  	if (mode == THERMAL_DEVICE_ENABLED)
>  		tzdev->polling_delay = thermal->polling_delay;
> -	else
> +	else if (mode == THERMAL_DEVICE_DISABLED)
>  		tzdev->polling_delay = 0;
> +	else
> +		return -EINVAL;
>  
>  	mutex_unlock(&tzdev->lock);
>  
> @@ -486,8 +488,10 @@ static int mlxsw_thermal_module_mode_set(struct thermal_zone_device *tzdev,
>  
>  	if (mode == THERMAL_DEVICE_ENABLED)
>  		tzdev->polling_delay = thermal->polling_delay;
> -	else
> +	else if (mode == THERMAL_DEVICE_DISABLED)
>  		tzdev->polling_delay = 0;
> +	else
> +		return -EINVAL;
>  
>  	mutex_unlock(&tzdev->lock);
>  
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 8cc86f4e3ac1..d5188c1d688b 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -431,6 +431,10 @@ static int acerhdf_get_mode(struct thermal_zone_device *thermal,
>  static int acerhdf_set_mode(struct thermal_zone_device *thermal,
>  			    enum thermal_device_mode mode)
>  {
> +	if (mode != THERMAL_DEVICE_DISABLED &&
> +	    mode != THERMAL_DEVICE_ENABLED)
> +		return -EINVAL;
> +
>  	if (mode == THERMAL_DEVICE_DISABLED && kernelmode)
>  		acerhdf_revert_to_bios_mode();
>  	else if (mode == THERMAL_DEVICE_ENABLED && !kernelmode)
> diff --git a/drivers/thermal/imx_thermal.c b/drivers/thermal/imx_thermal.c
> index e761c9b42217..36b1924f1938 100644
> --- a/drivers/thermal/imx_thermal.c
> +++ b/drivers/thermal/imx_thermal.c
> @@ -361,7 +361,7 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>  			data->irq_enabled = true;
>  			enable_irq(data->irq);
>  		}
> -	} else {
> +	} else if (mode == THERMAL_DEVICE_DISABLED) {
>  		regmap_write(map, soc_data->sensor_ctrl + REG_CLR,
>  			     soc_data->measure_temp_mask);
>  		regmap_write(map, soc_data->sensor_ctrl + REG_SET,
> @@ -374,6 +374,8 @@ static int imx_set_mode(struct thermal_zone_device *tz,
>  			disable_irq(data->irq);
>  			data->irq_enabled = false;
>  		}
> +	} else {
> +		return -EINVAL;
>  	}
>  
>  	data->mode = mode;
> diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
> index d704fc104cfd..11d7db895125 100644
> --- a/drivers/thermal/intel/intel_quark_dts_thermal.c
> +++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
> @@ -325,8 +325,11 @@ static int sys_set_mode(struct thermal_zone_device *tzd,
>  	mutex_lock(&dts_update_mutex);
>  	if (mode == THERMAL_DEVICE_ENABLED)
>  		ret = soc_dts_enable(tzd);
> -	else
> +	else if (mode == THERMAL_DEVICE_DISABLED)
>  		ret = soc_dts_disable(tzd);
> +	else
> +		return -EINVAL;
> +
>  	mutex_unlock(&dts_update_mutex);
>  
>  	return ret;
> diff --git a/drivers/thermal/of-thermal.c b/drivers/thermal/of-thermal.c
> index 874a47d6923f..36bebf623980 100644
> --- a/drivers/thermal/of-thermal.c
> +++ b/drivers/thermal/of-thermal.c
> @@ -289,9 +289,11 @@ static int of_thermal_set_mode(struct thermal_zone_device *tz,
>  	if (mode == THERMAL_DEVICE_ENABLED) {
>  		tz->polling_delay = data->polling_delay;
>  		tz->passive_delay = data->passive_delay;
> -	} else {
> +	} else if (mode == THERMAL_DEVICE_DISABLED) {
>  		tz->polling_delay = 0;
>  		tz->passive_delay = 0;
> +	} else {
> +		return -EINVAL;
>  	}
>  
>  	mutex_unlock(&tz->lock);
> 


-- 
<http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog
