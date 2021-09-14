Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC6740A5DF
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 07:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239505AbhINFTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 01:19:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbhINFTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 01:19:32 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924E1C061574;
        Mon, 13 Sep 2021 22:18:15 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id h3so11634996pgb.7;
        Mon, 13 Sep 2021 22:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=C028bT0FNMQ2VNhaDmAaFRTruEoGmAjnB6fsgimBiLY=;
        b=b7+GDmi/tHbh9KnK3K3vX+jeQksjovD1asvvG5VUqlzcX1HE4fKaLX1VolzVQJ/TDx
         PHn4c4oYmnSejBkf4lR+InMlsNnz+KQnAQvZgarCEE3ijsOcP1RjahZ79gezpZeP5CGw
         3WC1mAtJ2z4rfarwoCZRqz+iLn6un4h6dxIT6g2JUB4IZQAFlDPk9FOmFIQ+OzoslDhW
         jj1ux0+hFTTSoF7RONxRn/V9S7OtrhYKmW7eNVgLyCtAnoteQB9P3PSWY+dxv+5DaPt8
         eCgMa6wYYvbHWmARhzVSQzJq+Mfc0te0iu1jhdJ7eAn6uGLigzz4xDEEd5OZBHRLm6oK
         y9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C028bT0FNMQ2VNhaDmAaFRTruEoGmAjnB6fsgimBiLY=;
        b=Ash1vvnhxeS4O1H2Z9v9ZGapJ+R6RhADiPF+dchqXBA+28OA99lCSbQTYrlgNcf5XK
         fxl49Ggyr5o5uRMELMG8iZokaBJtoCzfazGJ92un1ZNwBEM7q6/RCAcN9w7X/SAaXjop
         UUHo3tf/eWoVfhC5YVITsN4pIM054JpU/aOqk/G6L992SnCmWa5s326hC90j7cD/XD7v
         qf3LiMrwJFQs87VkbImnagzGG4iXwQFxrAiXSp8pmGSoihWCQvsEfGoqHgBQC3CDz3kK
         /FU8VswGj9FrOD1frQc6Km11p7TXdiwEwriV58P6YvldIXaw3XyBqzDx8YlYitjrfTdk
         /CEA==
X-Gm-Message-State: AOAM533OZwuCoNr8RnrYlejtxMrLpobVHZf61zbjv0ym+uzVse6Fuopq
        33YJkRhpkutfdb2/lZeE+8IKo8S7GA4=
X-Google-Smtp-Source: ABdhPJzee7e3XdPCshLwbxsW/qraVLPMCYb0p3LmZR15wIP93lJBZle/OWyNsGipvlxcGAIsYJdovg==
X-Received: by 2002:a62:ee11:0:b029:3e0:88dc:193f with SMTP id e17-20020a62ee110000b02903e088dc193fmr2924525pfi.78.1631596694878;
        Mon, 13 Sep 2021 22:18:14 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id i7sm10006289pgd.56.2021.09.13.22.18.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 22:18:14 -0700 (PDT)
Subject: Re: [PATCH net-next] net: core: fix the order in dev_put() and
 rtnl_lock()
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org
Cc:     nikolay@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210914030150.5838-1-yajun.deng@linux.dev>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <903c5bed-5958-8888-b55d-9c175664b2a1@gmail.com>
Date:   Mon, 13 Sep 2021 22:18:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210914030150.5838-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/13/21 8:01 PM, Yajun Deng wrote:
> The dev_put() should be after rtnl_lock() in case for race.
> 
> Fixes: 893b19587534 ("net: bridge: fix ioctl locking")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/core/dev_ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> index 0e87237fd871..9796fa35fe88 100644
> --- a/net/core/dev_ioctl.c
> +++ b/net/core/dev_ioctl.c
> @@ -384,8 +384,8 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
>  		dev_hold(dev);
>  		rtnl_unlock();
>  		err = br_ioctl_call(net, netdev_priv(dev), cmd, ifr, NULL);
> -		dev_put(dev);
>  		rtnl_lock();
> +		dev_put(dev);
>  		return err;
>  
>  	case SIOCSHWTSTAMP:
> 

What race exactly are you trying to avoid ?

This patch does not look needed to me.
