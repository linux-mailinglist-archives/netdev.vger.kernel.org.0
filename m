Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5F914E967C
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 14:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242417AbiC1M1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 08:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240631AbiC1M1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 08:27:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C83C44D247
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648470336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GvJCNB2Cnl/nlDULpdtsfyTRfdka37fX/FHgNiQs3CE=;
        b=UWVFKoElXqvWCLqfPsIxURQmLn2qvubUV/RVRGM7DORv0FOGigXsUcqqK9AqWHveY5Kjfk
        eXV1iu8We8fr2MwjDA7KoDoNzdBFcUctxNB7+WpIbP/oeTnew9secspMqkSFMUI26D6rVi
        pNxm83e5nbDqyavahy2BqpO5SAWogIc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-4_f9BnpAPxW4KSCT57xY1g-1; Mon, 28 Mar 2022 08:25:35 -0400
X-MC-Unique: 4_f9BnpAPxW4KSCT57xY1g-1
Received: by mail-qk1-f198.google.com with SMTP id bj2-20020a05620a190200b005084968bb24so8241958qkb.23
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 05:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GvJCNB2Cnl/nlDULpdtsfyTRfdka37fX/FHgNiQs3CE=;
        b=S4IYqHasngiOgVR3fAECpcArxX9I7kspJx36dHc40Ek5oQJHR0DxrS9hKvFWHxnBel
         EVcWbA0OETyvFMj3NV6trrHnQV6UQ3BoLfXU5xdJkpMyitSyYfwlyJ39ZNdS2iMEiFxe
         GJ3ln6W/bdarfxydVPla8lfOfCMpM1hCNBwtBFkX/JSX77z1qCMNk+knqzo6gaHAXsJI
         nA1TihsoO/mU4/tX7AUzEw5FIXslpO7eJamX/DcMLnuopzHqPveiklKxicc8KkIiOSLq
         k7eAAGCz/NyA5wOxPM+6t+WLxNFTbT1wvqon12bVeyD2hvf/4YfiBTtLa4m0mM80Udup
         47Zg==
X-Gm-Message-State: AOAM531kwspf3DKaIDJ3Rg5R14xhmHFNlp33jROvxG33Lk1QOTgh63OU
        7P/ETmHBiT6WGQ+XESPSYZdP74ZW8PIGRNuch5cyuCIzPpV+J7TDJgJ2HbageG9MfhNnmJPF8F/
        Z0Jf/HnZhrkrROEoc1B04luvCtIzLIAFn920HkXMoGibPHKoJysEFD1Nq8y+TyeI=
X-Received: by 2002:a05:622a:107:b0:2e1:d655:cc4c with SMTP id u7-20020a05622a010700b002e1d655cc4cmr21566432qtw.669.1648470334888;
        Mon, 28 Mar 2022 05:25:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAQwqAdu+kg9mfWp0pBO/UFlRsaaQCJ2OhGI1xR4a2IZwQG3pphqjbnU8jqdybbi/S9OtTEw==
X-Received: by 2002:a05:622a:107:b0:2e1:d655:cc4c with SMTP id u7-20020a05622a010700b002e1d655cc4cmr21566381qtw.669.1648470334415;
        Mon, 28 Mar 2022 05:25:34 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id y17-20020a05622a121100b002e0702457b2sm12282866qtx.20.2022.03.28.05.25.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 05:25:34 -0700 (PDT)
Subject: Re: [PATCH v1 1/2] hwmon: introduce hwmon_sanitize_name()
To:     Michael Walle <michael@walle.cc>, Xu Yilun <yilun.xu@intel.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220328115226.3042322-1-michael@walle.cc>
 <20220328115226.3042322-2-michael@walle.cc>
From:   Tom Rix <trix@redhat.com>
Message-ID: <a1f71681-0eb0-c67f-53e0-dfce9d2fdea9@redhat.com>
Date:   Mon, 28 Mar 2022 05:25:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220328115226.3042322-2-michael@walle.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/28/22 4:52 AM, Michael Walle wrote:
> More and more drivers will check for bad characters in the hwmon name
> and all are using the same code snippet. Consolidate that code by adding
> a new hwmon_sanitize_name() function.
>
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>   drivers/hwmon/intel-m10-bmc-hwmon.c |  5 +----
>   include/linux/hwmon.h               | 16 ++++++++++++++++
>   2 files changed, 17 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/hwmon/intel-m10-bmc-hwmon.c b/drivers/hwmon/intel-m10-bmc-hwmon.c
> index 7a08e4c44a4b..e6e55fc30153 100644
> --- a/drivers/hwmon/intel-m10-bmc-hwmon.c
> +++ b/drivers/hwmon/intel-m10-bmc-hwmon.c
> @@ -515,7 +515,6 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
>   	struct intel_m10bmc *m10bmc = dev_get_drvdata(pdev->dev.parent);
>   	struct device *hwmon_dev, *dev = &pdev->dev;
>   	struct m10bmc_hwmon *hw;
> -	int i;
>   
>   	hw = devm_kzalloc(dev, sizeof(*hw), GFP_KERNEL);
>   	if (!hw)
> @@ -532,9 +531,7 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
>   	if (!hw->hw_name)
>   		return -ENOMEM;
>   
> -	for (i = 0; hw->hw_name[i]; i++)
> -		if (hwmon_is_bad_char(hw->hw_name[i]))
> -			hw->hw_name[i] = '_';
> +	hwmon_sanitize_name(hw->hw_name);
>   
>   	hwmon_dev = devm_hwmon_device_register_with_info(dev, hw->hw_name,
>   							 hw, &hw->chip, NULL);
> diff --git a/include/linux/hwmon.h b/include/linux/hwmon.h
> index eba380b76d15..210b8c0b2827 100644
> --- a/include/linux/hwmon.h
> +++ b/include/linux/hwmon.h
> @@ -484,4 +484,20 @@ static inline bool hwmon_is_bad_char(const char ch)
>   	}
>   }

hwmon_is_bad_char is now only used by hwmon_sanitize_name.

as patch 3, consolidate into only hwmon_sanitize_name.

Tom

>   
> +/**
> + * hwmon_sanitize_name - Replaces invalid characters in a hwmon name
> + * @name: NUL-terminated name
> + *
> + * Invalid characters in the name will be overwritten in-place by an
> + * underscore.
> + */
> +static inline void hwmon_sanitize_name(char *name)
> +{
> +	while (*name) {
> +		if (hwmon_is_bad_char(*name))
> +			*name = '_';
> +		name++;
> +	};
> +}
> +
>   #endif

