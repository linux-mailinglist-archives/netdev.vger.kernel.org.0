Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC7E22A141
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 23:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGVVSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 17:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgGVVSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 17:18:49 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F758C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 14:18:49 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b9so1603205plx.6
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 14:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=/NCA8bXI3zfZYAohLjznoM/f/0f70sPbB/+ypwTdYwc=;
        b=SHf1JmGTnB3dAO02ZCUI+6CakGm0Ef6Boq9u7eNpki+17Ha09xS2ZLBYWpY3VMzFT3
         u+7lxgl5oNVZvC0wFhSwysOqeqyKoI7jJIip6qgnkiWglcOa6GlBXxdWE+BMgA/PMGTq
         wx4TzANPIFUFMO5iOGVq9/MJNTNzyYw/GTftAaKhd0iydIvRpoEwwhWXlf8cLPHp30TB
         sbaXemgDpu1SkwiwBU1Hl2v003Sf6nVysUcoJnIFqYlKFi8qkRvHDdhsNFJMAW93yETa
         5yNBOnrao3i9q6rZ63DqUtfWqx/DFAtRhx0/1ifYorhLdjAcBsfiLIraRTpmbF2fQj8y
         1kQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=/NCA8bXI3zfZYAohLjznoM/f/0f70sPbB/+ypwTdYwc=;
        b=EoICNj665RferoKv+/rlTs7NSf12t76kp2HOAr0bAV8HqCLUMtfzKQSS/6wPwTRHfI
         fyq+4Oa+Aw/52/QQFG6qYcpFhKxZQa61nuoHvp810r8AtM05phy9lttMRo3UwsOxuUG3
         PThnYZ9rSJCOM6TNrLvK+0qUnCN3BE7vSpcz70sB/lZxU6KrfPi82qpD5OeyAiOHC5Sn
         ZYpg+7EJdGosnzu+GpOnMEVcXWOndDElYC2kizgeASaNZAVL3woB90IxgWeKEFusUzD9
         45aAytz2LIc1yk2TeKceqCKci/6+kymLesF/qAEFKKUsmemdDBZv4eGuRgQAgQyQ7YH0
         WmmQ==
X-Gm-Message-State: AOAM530NGxDXWcXnc5jU40s8i5T3FSA4mta/7l77eVPNAomrgNQX/A17
        u0RgczZCy84QqwEj3U+W5sQZFg==
X-Google-Smtp-Source: ABdhPJzosbYETKUk0ThWbWyDitsjMwfz7haDDCSEljXg5g94MYNfHgTQ89Bodw/QHDKiLlW78A78Gw==
X-Received: by 2002:a17:90a:c592:: with SMTP id l18mr1236663pjt.119.1595452728690;
        Wed, 22 Jul 2020 14:18:48 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id 207sm566591pfa.100.2020.07.22.14.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 14:18:47 -0700 (PDT)
Subject: Re: [PATCH][next] ionic: fix memory leak of object 'lid'
To:     Colin King <colin.king@canonical.com>,
        Pensando Drivers <drivers@pensando.io>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200722174003.962374-1-colin.king@canonical.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <e0e428cf-3bef-9b57-2a7f-5a2381587085@pensando.io>
Date:   Wed, 22 Jul 2020 14:18:46 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200722174003.962374-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/20 10:40 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Currently when netdev fails to allocate the error return path
> fails to free the allocated object 'lid'.  Fix this by setting
> err to the return error code and jumping to a new label that
> performs the kfree of lid before returning.
>
> Addresses-Coverity: ("Resource leak")
> Fixes: 4b03b27349c0 ("ionic: get MTU from lif identity")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> index 7ad338a4653c..728dd6429d80 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
> @@ -2034,7 +2034,8 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
>   				    ionic->ntxqs_per_lif, ionic->ntxqs_per_lif);
>   	if (!netdev) {
>   		dev_err(dev, "Cannot allocate netdev, aborting\n");
> -		return ERR_PTR(-ENOMEM);
> +		err = -ENOMEM;
> +		goto err_out_free_lid;
>   	}
>   
>   	SET_NETDEV_DEV(netdev, dev);
> @@ -2120,6 +2121,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
>   err_out_free_netdev:
>   	free_netdev(lif->netdev);
>   	lif = NULL;
> +err_out_free_lid:
>   	kfree(lid);
>   
>   	return ERR_PTR(err);

Thanks!

Acked-by: Shannon Nelson <snelson@pensando.io>


