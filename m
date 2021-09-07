Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508D3402F02
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 21:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhIGTeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 15:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238011AbhIGTeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 15:34:08 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C64FC06175F
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 12:33:01 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fs6so47809pjb.4
        for <netdev@vger.kernel.org>; Tue, 07 Sep 2021 12:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kM9tVwq7irwTqrJ/Yy0JQrecGes212Y12EN0zEFuULg=;
        b=EbnF+b103gIkqqpqa+fykmOyLRTxyAdNcKeyO2HFiDbsMFAk2ahSsl++vu7qZpG7Cp
         ZC40lS2gVLJTvxEHRkJj7LkQuF8yCLE4csed/ETMsUE3QjeZKU3jd5gtgdYiSs1g3zL5
         J3Fk3wLm5lUn3141B6KqkJu4v8T/5a7nzLHLE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kM9tVwq7irwTqrJ/Yy0JQrecGes212Y12EN0zEFuULg=;
        b=oMaNrpyT8RwTT9SkmYZm1YSTEWTYO6xXhgP+qhQTeSeTryPU59krX4dR6RYAfDMN/T
         8dC4OU7+7HBhnwiBJg4VDWr9V4dWo8ld/Kdmep6XXrkkU/TGfLahngHCN5YI40RmPn6d
         0zMz32G4+ELSvKB+H2eeU1Z7q3SRjx+SHXF6aqDcOKWMdEg2CMBHgzmvSraZIwb6sMfH
         TpaN8qiV5pDgH0CcPz8B5V7ftVjCgyqARCYsLtlY50JedXz1+WwF0iUil7/p9LE1binO
         Ol5LYeC9lmcEGJWg7M+RAr47PB77lTh2sanBupdemiVNqvu2ia9rOAl/acDE+jq2NAlk
         lo0w==
X-Gm-Message-State: AOAM531Vh2GmG6QcdgwB6Hc0fAx+Cpv75gBcoCp59zsNO/V7whp1EDIH
        dmexIeEv5KJHfM1tYZnO0b2RDXWjwuD4xQ==
X-Google-Smtp-Source: ABdhPJynKko1EY7ycMZQk/o77iyI5DtZmQyYOJZGOcArM0hicszPb0UggJr+YQkxxzDjLvwHQvTYzg==
X-Received: by 2002:a17:90a:9b13:: with SMTP id f19mr31127pjp.224.1631043181149;
        Tue, 07 Sep 2021 12:33:01 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:c6b2:7ae:474d:36f6])
        by smtp.gmail.com with UTF8SMTPSA id w11sm11664097pfj.65.2021.09.07.12.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 12:33:00 -0700 (PDT)
Date:   Tue, 7 Sep 2021 12:32:59 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        Youghandhar Chintala <youghand@codeaurora.org>,
        Abhishek Kumar <kuabhs@chromium.org>
Subject: Re: [PATCH] ath10k: Don't always treat modem stop events as crashes
Message-ID: <YTe+a0Gu7O6MEy2d@google.com>
References: <20210905210400.1157870-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210905210400.1157870-1-swboyd@chromium.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 02:04:00PM -0700, Stephen Boyd wrote:
> When rebooting on sc7180 Trogdor devices I see the following crash from
> the wifi driver.
> 
>  ath10k_snoc 18800000.wifi: firmware crashed! (guid 83493570-29a2-4e98-a83e-70048c47669c)
> 
> This is because a modem stop event looks just like a firmware crash to
> the driver, the qmi connection is closed in both cases. Use the qcom ssr
> notifier block to stop treating the qmi connection close event as a
> firmware crash signal when the modem hasn't actually crashed. See
> ath10k_qmi_event_server_exit() for more details.
> 
> This silences the crash message seen during every reboot.
> 
> Fixes: 3f14b73c3843 ("ath10k: Enable MSA region dump support for WCN3990")
> Cc: Govind Singh <govinds@codeaurora.org>
> Cc: Youghandhar Chintala <youghand@codeaurora.org>
> Cc: Abhishek Kumar <kuabhs@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  drivers/net/wireless/ath/ath10k/snoc.c | 75 ++++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/snoc.h |  4 ++
>  2 files changed, 79 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index ea00fbb15601..fc4970e063f8 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -12,6 +12,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/property.h>
>  #include <linux/regulator/consumer.h>
> +#include <linux/remoteproc/qcom_rproc.h>
>  #include <linux/of_address.h>
>  #include <linux/iommu.h>
>  
> @@ -1477,6 +1478,70 @@ void ath10k_snoc_fw_crashed_dump(struct ath10k *ar)
>  	mutex_unlock(&ar->dump_mutex);
>  }
>  
> +static int ath10k_snoc_modem_notify(struct notifier_block *nb, unsigned long action,
> +				    void *data)
> +{
> +	struct ath10k_snoc *ar_snoc = container_of(nb, struct ath10k_snoc, nb);
> +	struct ath10k *ar = ar_snoc->ar;
> +	struct qcom_ssr_notify_data *notify_data = data;
> +
> +	switch (action) {
> +	case QCOM_SSR_BEFORE_POWERUP:
> +		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem starting event\n");
> +		clear_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
> +		break;
> +
> +	case QCOM_SSR_AFTER_POWERUP:
> +		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem running event\n");
> +		break;
> +
> +	case QCOM_SSR_BEFORE_SHUTDOWN:
> +		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem %s event\n",
> +			   notify_data->crashed ? "crashed" : "stopping");
> +		if (!notify_data->crashed)
> +			set_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
> +		else
> +			clear_bit(ATH10K_SNOC_FLAG_UNREGISTERING, &ar_snoc->flags);
> +		break;
> +
> +	case QCOM_SSR_AFTER_SHUTDOWN:
> +		ath10k_dbg(ar, ATH10K_DBG_SNOC, "received modem offline event\n");
> +		break;
> +
> +	default:
> +		ath10k_err(ar, "received unrecognized event %lu\n", action);
> +		break;
> +	}
> +
> +	return NOTIFY_OK;
> +}
> +
> +static int ath10k_modem_init(struct ath10k *ar)
> +{
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> +	void *notifier;
> +
> +	ar_snoc->nb.notifier_call = ath10k_snoc_modem_notify;
> +
> +	notifier = qcom_register_ssr_notifier("mpss", &ar_snoc->nb);
> +	if (IS_ERR(notifier))
> +		return PTR_ERR(notifier);
> +
> +	ar_snoc->notifier = notifier;
> +
> +	return 0;
> +}
> +
> +static void ath10k_modem_deinit(struct ath10k *ar)
> +{
> +	int ret;
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> +
> +	ret = qcom_unregister_ssr_notifier(ar_snoc->notifier, &ar_snoc->nb);
> +	if (ret)
> +		ath10k_err(ar, "error %d unregistering notifier\n", ret);
> +}
> +
>  static int ath10k_setup_msa_resources(struct ath10k *ar, u32 msa_size)
>  {
>  	struct device *dev = ar->dev;
> @@ -1740,10 +1805,19 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
>  		goto err_fw_deinit;
>  	}
>  
> +	ret = ath10k_modem_init(ar);
> +	if (ret) {
> +		ath10k_err(ar, "failed to initialize modem notifier: %d\n", ret);

nit: ath10k_modem_init() encapsulates/hides the setup of the notifier,
the error message should be inside the function, as for _deinit()

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
