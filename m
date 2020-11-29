Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBF42C797A
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 14:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgK2N5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 08:57:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbgK2N5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 08:57:23 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFF1C0613CF
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 05:56:43 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id l4so2174607pgu.5
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 05:56:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OV4jnfio7NN4TthWuqqNxFcTE4mQ07fdcufOE2po1eI=;
        b=jhefsbPhVRWe0qhbd8KRD7cEwG8d5vbwI4fYag2lmicQ37mDu6FeUDdnOQCwr2o3ff
         AjQtfLEtA07odf6nBoQ8otkUba5bZIIyxIbOl/tImqtZYvHP0NbC368LIY38TBXfs2Vi
         peJvYLbiHKDrLsoVVZvz0p2h3noVkw8/moMqltEN79HALWgexxycDXj3+fKmyT319P13
         Ouf7rPxkGDZNBKZ8MKy6Brf0wg+W9jM4/19rQot/NlRS09JQqiTB+JNZ7GFF+fQJiZiz
         Km5EuSypwTLzwo21Wwm6diZmSbAWCcBvDjGpjaEJn4XKNZRy0hXYxSGU7wJ0P8F8o4vY
         xhfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OV4jnfio7NN4TthWuqqNxFcTE4mQ07fdcufOE2po1eI=;
        b=MZ97M9p6byh/ugO7OchWsfdPJ3JbyOV8a/Cqr2za8c04QoEpZySVwzA7ztzlYvxc7Y
         o3GpW0xzXvSqoeT9x5WrwQASRswHN3UGwwG7swM1WABVaSZ08G6jqDVxMVwZGzweVdRJ
         c72sVTika8nfMoj6MevlQQuuwAPT9lmu90vMCZArc1UrT1bMzLTiNvvM+I5QgTGg1hzs
         eUcl+3AXHOUM/HdiyTRYFcERqjhbQxVWutEHhO6jUPMsVa0O6BIHORsxZxaNjhU2l6y5
         A11UYlKhiFJAZBR7QlO840p1L974OCvUZ52/iltAAj4RrxAVKRkpSWvA9MXbC86U8Fqe
         VN2w==
X-Gm-Message-State: AOAM532Csl+E7cYkrpgoJ7Tca4FK6OrPv7UV5ALU+cTm0neIBBp/CuGP
        f5LFIYblbeFv1kpM2uOkEbeBNeQ8987wNA==
X-Google-Smtp-Source: ABdhPJyy99PNNdaxRZ85jH9Z1WfpXz6aQNetZdRW0zCybFKmasIJ2mc5BtE80jHii7BHf7n+y/jTsg==
X-Received: by 2002:a63:5963:: with SMTP id j35mr13863197pgm.55.1606658202577;
        Sun, 29 Nov 2020 05:56:42 -0800 (PST)
Received: from [192.168.1.18] (i121-115-229-245.s42.a013.ap.plala.or.jp. [121.115.229.245])
        by smtp.googlemail.com with ESMTPSA id 184sm13546134pfc.28.2020.11.29.05.56.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 05:56:41 -0800 (PST)
Subject: Re: [PATCH net] net: fix memory leak in register_netdevice() on error
 path
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, rkovhaev@gmail.com,
        Netdev <netdev@vger.kernel.org>
References: <20201126132312.3593725-1-yangyingliang@huawei.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <3548dfef-da8f-0247-0af5-e612b540e397@gmail.com>
Date:   Sun, 29 Nov 2020 22:56:38 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201126132312.3593725-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/26 22:23, Yang Yingliang wrote:
...
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   net/core/dev.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 82dc6b48e45f..907204395b64 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -10000,6 +10000,17 @@ int register_netdevice(struct net_device *dev)
>   	ret = notifier_to_errno(ret);
>   	if (ret) {
>   		rollback_registered(dev);
> +		/*
> +		 * In common case, priv_destructor() will be

As per netdev-faq, the comment style should be

/* foobar blah blah blah
  * another line of text
  */

rather than

/*
  * foobar blah blah blah
  * another line of text
  */

> +		 * called in netdev_run_todo() after calling
> +		 * ndo_uninit() in rollback_registered().
> +		 * But in this case, priv_destructor() will
> +		 * never be called, then it causes memory
> +		 * leak, so we should call priv_destructor()
> +		 * here.
> +		 */
> +		if (dev->priv_destructor)
> +			dev->priv_destructor(dev);

To be in line with netdev_run_todo(), I think priv_destructor() should be
called after "dev->reg_state = NETREG_UNREGISTERED".

Toshiaki Makita

>   		rcu_barrier();
>   
>   		dev->reg_state = NETREG_UNREGISTERED;
> 
