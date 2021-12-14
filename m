Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C64C473C2B
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 05:46:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhLNEqo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 23:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbhLNEqn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 23:46:43 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B228AC06173F
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:46:42 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a18so30387265wrn.6
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 20:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=3YA6TDDtH4E8mf22GofMh5BciiLc/YBBiH4JDP77HY8=;
        b=SHjJ9R7lMi6vR/sSOxFVfKamyFykK236jgTxlem5rSNc8VdlFmz5G3xhBBT9Yfn7rf
         G1YmCkgBJd5YCFsyHDZEob05DhKAb+y3YheACkaqhH3DDjxep+tAtOW2/EoB1KzEEyqw
         tcbXZyFE/hNreZOqUS1Or6ODRFET+9QphJhZLpDXTl9jEQPIB0117eimUojkQLT9X/Do
         99fKV4VrW3AnOtxab6BYGoH906fIkfGScKdxcBrKevdSKbz+/2sFjPKrgO34VT8u1PSB
         OQnyIWbqlRbI3ByE+YWWpD1/wMhkPe+A0wMn2ewLjiRmhMNc2sJRIwGErlRUvX1sT+8q
         +vQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=3YA6TDDtH4E8mf22GofMh5BciiLc/YBBiH4JDP77HY8=;
        b=xFerrPrZIofv399q7FYaNtjRJva52NG3dzbxBaELprjXVZg0evBSTlKE9hQ9sAq5mR
         nBH2+DTtLGvGKvaE6DQMjd23QM+TB8PZNATzq75pblHWcKG+UF9Drp+LWc65wL4kydxz
         IzvqQHBap6xSsT+Iu8c/05/vsqfKTCo8rrNYR8VrGVfOoAq3dEgRRuRo7Ct39tGXLbZ0
         fLkBRzud7oWgmGk4h0UnbcimB4DQHJJStbH3XKXqehjelZ9XJbgG5Vy2i72AiQWVf+x7
         3Yg0cVrcYOi6c6NPY1Vsf7Nrgcv41JTjMw+bSQbonBU+flUL/E1erpHIqicP+xDOdHoe
         Cg4Q==
X-Gm-Message-State: AOAM530kflNEFu75VdvsosTqbgWg/0UwJwf7rOOxscnXzoSKJQ7tHnWN
        4c450IKuc5hcplXmdxg+U5AUFYI1sMkwtQ==
X-Google-Smtp-Source: ABdhPJylSJIwY9BcwAqIjyzCEkykEkCeLyy2TSJetplNk62gsKfNRR2A+qYwRTmTtkqZrp8JA/AFtQ==
X-Received: by 2002:adf:dc44:: with SMTP id m4mr3152474wrj.550.1639457201123;
        Mon, 13 Dec 2021 20:46:41 -0800 (PST)
Received: from [10.0.0.11] ([37.165.163.199])
        by smtp.gmail.com with ESMTPSA id q24sm883359wmj.21.2021.12.13.20.46.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 20:46:40 -0800 (PST)
Subject: Re: [PATCH net-next] ethtool: fix null-ptr-deref on ref tracker
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20211214013902.386186-1-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <37b65a59-b7f0-2863-5903-d806673a18b5@gmail.com>
Date:   Mon, 13 Dec 2021 20:46:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211214013902.386186-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/13/21 5:39 PM, Jakub Kicinski wrote:
> dev can be a NULL here, not all requests set require_dev.
>
> Fixes: e4b8954074f6 ("netlink: add net device refcount tracker to struct ethnl_req_info")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   net/ethtool/netlink.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
> index 23f32a995099..767fb3f17267 100644
> --- a/net/ethtool/netlink.c
> +++ b/net/ethtool/netlink.c
> @@ -141,8 +141,10 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
>   		return -EINVAL;
>   	}
>   


Oh I am reading your patch after I sent mine.


Please use edumazet@google.com next time, because eric.dumazet@gmail.com has

huge lag (typical vger -> accounts@gmail.com issues)


Reviewed-by: Eric Dumazet <edumazet@google.com>


Thanks !




> -	req_info->dev = dev;
> -	netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
> +	if (dev) {
> +		req_info->dev = dev;
> +		netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
> +	}
>   	req_info->flags = flags;
>   	return 0;
>   }
