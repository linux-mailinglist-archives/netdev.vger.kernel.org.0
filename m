Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A344F3ECB
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 22:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234405AbiDEOTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 10:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353907AbiDENHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 09:07:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C5732167FD
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 05:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649160547;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wTHcEPqS4WZU3twPg6xFE08lBamScSNylvPFU0OFzg4=;
        b=B22yoDcAQRw1Vts9MS32ITUwy6/UdIQ7uF0jPjzo2fFQaRHzVqGAn71l4WMdwI/YPiS89+
        VvY3SfUBiwMAyAjYMm6S9kxg4PAoSF9c6EwSkPoSPbjowUITMpZVVChSxOzPRFTcT2QVh4
        YSPIN3GXs0jObkOHHKj5boFHVd/tEDA=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-216-PuAotWW_OnO5xFBJwyEr3Q-1; Tue, 05 Apr 2022 08:09:06 -0400
X-MC-Unique: PuAotWW_OnO5xFBJwyEr3Q-1
Received: by mail-qv1-f72.google.com with SMTP id m15-20020a0562141bcf00b00443ddcd8a0fso4072941qvc.12
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 05:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=wTHcEPqS4WZU3twPg6xFE08lBamScSNylvPFU0OFzg4=;
        b=iHRd0mnZMDfrtSZ8n6D5XJmEy4byvVj2iKCXuC2E6TRbEsIAt0/8fVEtb+N4NdMI2V
         IfLKd/hWbzypEY0/vlPA4JUrWJc0TsucAVWANGJxiIWsjTE3aKWIQ04qBWE3ZNV4lBDz
         30cG3YT5O3jnNmtFPHSBzjIPKdjSz53V9o87vvRhjVJPgozBjJ/ZNfyyQG90iETQtmf/
         rqII8InJKUBqDhZXOLWoPdPgOtggoKbjkV6XkU1zJEE3K2IHkvDNH7KHvP3nQboTg6ka
         dRJ7H2knDz4KoQUfv8zgPWguO1bDePgLIb2Oj3Pjh6KuK5W+d+jUHfQdRGdRlDXacoyT
         30zw==
X-Gm-Message-State: AOAM530BGis0aYtSc8Y6wrlYAEcjQn+2cueZ3aZ7CxKYm7w/K9AWWU3a
        wl1O2b5HUskdVUF3Z0+DZJJRzq9eM4pvgGD+bgeqBctZhC096/Wlrx8a1U2hof3rTXJEgl5Fmcl
        C/4AGHVcXHF5sA/vt
X-Received: by 2002:ac8:4e8b:0:b0:2e2:129b:35f1 with SMTP id 11-20020ac84e8b000000b002e2129b35f1mr2557104qtp.387.1649160546387;
        Tue, 05 Apr 2022 05:09:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwX7HhPj5mEGcuqhZHuJX+RbnyZLGTfgVtl7WdedWYWbPlNoy2uZL3YMCqfNCIwWRAhYtFenA==
X-Received: by 2002:ac8:4e8b:0:b0:2e2:129b:35f1 with SMTP id 11-20020ac84e8b000000b002e2129b35f1mr2557071qtp.387.1649160546126;
        Tue, 05 Apr 2022 05:09:06 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id c20-20020a05622a059400b002e1d59e68f3sm10850768qtb.48.2022.04.05.05.09.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Apr 2022 05:09:05 -0700 (PDT)
Subject: Re: [PATCH v4 2/2] hwmon: intel-m10-bmc-hwmon: use
 devm_hwmon_sanitize_name()
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
        netdev@vger.kernel.org, David Laight <David.Laight@ACULAB.COM>
References: <20220405092452.4033674-1-michael@walle.cc>
 <20220405092452.4033674-3-michael@walle.cc>
From:   Tom Rix <trix@redhat.com>
Message-ID: <155156e6-e258-78dd-441a-7faad4afde3c@redhat.com>
Date:   Tue, 5 Apr 2022 05:09:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220405092452.4033674-3-michael@walle.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/5/22 2:24 AM, Michael Walle wrote:
> Instead of open-coding the bad characters replacement in the hwmon name,
> use the new devm_hwmon_sanitize_name().
>
> Signed-off-by: Michael Walle <michael@walle.cc>
> Acked-by: Xu Yilun <yilun.xu@intel.com>
> ---
>   drivers/hwmon/intel-m10-bmc-hwmon.c | 11 +++--------
>   1 file changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/hwmon/intel-m10-bmc-hwmon.c b/drivers/hwmon/intel-m10-bmc-hwmon.c
> index 7a08e4c44a4b..6e82f7200d1c 100644
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
> @@ -528,13 +527,9 @@ static int m10bmc_hwmon_probe(struct platform_device *pdev)
>   	hw->chip.info = hw->bdata->hinfo;
>   	hw->chip.ops = &m10bmc_hwmon_ops;
>   
> -	hw->hw_name = devm_kstrdup(dev, id->name, GFP_KERNEL);
> -	if (!hw->hw_name)
> -		return -ENOMEM;
> -
> -	for (i = 0; hw->hw_name[i]; i++)
> -		if (hwmon_is_bad_char(hw->hw_name[i]))
> -			hw->hw_name[i] = '_';
> +	hw->hw_name = devm_hwmon_sanitize_name(dev, id->name);
> +	if (IS_ERR(hw->hw_name))
> +		return PTR_ERR(hw->hw_name);
Reviewed-by: Tom Rix <trix@redhat.com>
>   
>   	hwmon_dev = devm_hwmon_device_register_with_info(dev, hw->hw_name,
>   							 hw, &hw->chip, NULL);

