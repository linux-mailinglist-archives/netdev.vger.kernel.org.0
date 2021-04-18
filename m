Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEACC363773
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 22:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhDRUE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 16:04:26 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:40470 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhDRUE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 16:04:26 -0400
Received: by mail-pl1-f177.google.com with SMTP id 20so12648056pll.7;
        Sun, 18 Apr 2021 13:03:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ocpvHH0OfSXrZ6ZZMO0Iq2R7HY+eWtpOHZ6cffg0O+U=;
        b=nzbrwGdsiOVYoKUwqIJA/Dsk4TB0S7h1ScWbM557BYuJAdubV+VH/lm/MZ9ItOmKfO
         cBk/d0LoBFwwetoMb5+Z8c1I/M3SLzROqJ8IiwqpL6ujwgKcijzwnOcaUb4S9dw8pot+
         vTuqNAmn5YZnZ7pmC1WFWpwtrEXmt785W7UqfT+olAnztz6QICSdlT7zbtFUNLlXIY8X
         zmzpW1Sh+GxhIzyXzdBnAcDGhhBIQpYB5cgMo1gg9AUDi5o8DjVNHo6ur8zjwndW6xkH
         OyXsiIo4G7ROBca8DML5khdbKusCeA8DQcsSE+g5HPISPP3apTnq1nqCTZtv6za6fqXz
         WdYQ==
X-Gm-Message-State: AOAM531d9VPZzKW6O5PYuoT87wnum1eHxKQGuvyosDH1pQQFPyU8ccuy
        1giidAAEI3NXd/NZGVc9CobnoWvy1WI=
X-Google-Smtp-Source: ABdhPJwVMeZX60Cq/LEZaC2MurSw6/8c7B9QK4fEJcoFPFcW7/3smnviEnjy7bNu7xBPskHuzhoDOw==
X-Received: by 2002:a17:90a:fb4c:: with SMTP id iq12mr20945436pjb.121.1618776235751;
        Sun, 18 Apr 2021 13:03:55 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:93db:a33:19a8:2126? ([2601:647:4000:d7:93db:a33:19a8:2126])
        by smtp.gmail.com with ESMTPSA id k13sm12472311pji.14.2021.04.18.13.03.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Apr 2021 13:03:54 -0700 (PDT)
Subject: Re: [PATCH] net/mlx5: Use kasprintf instead of hand-writing it
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        saeedm@nvidia.com, leon@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <46235ec010551d2788483ce636686a61345e40ba.1618643703.git.christophe.jaillet@wanadoo.fr>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <131988e1-2327-99f8-95e1-778d653c36ec@acm.org>
Date:   Sun, 18 Apr 2021 13:03:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <46235ec010551d2788483ce636686a61345e40ba.1618643703.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/17/21 12:16 AM, Christophe JAILLET wrote:
> 'kasprintf()' can replace a kmalloc/strcpy/strcat sequence.
> It is less verbose and avoid the use of a magic number (64).
> 
> Anyway, the underlying 'alloc_workqueue()' would only keep the 24 first
> chars (i.e. sizeof(struct workqueue_struct->name) = WQ_NAME_LEN).
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/health.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> index 9ff163c5bcde..a5383e701b4b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
> @@ -802,12 +802,10 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
>  	mlx5_fw_reporters_create(dev);
>  
>  	health = &dev->priv.health;
> -	name = kmalloc(64, GFP_KERNEL);
> +	name = kasprintf(GFP_KERNEL, "mlx5_health%s", dev_name(dev->device));
>  	if (!name)
>  		goto out_err;
>  
> -	strcpy(name, "mlx5_health");
> -	strcat(name, dev_name(dev->device));
>  	health->wq = create_singlethread_workqueue(name);
>  	kfree(name);
>  	if (!health->wq)

Instead of modifying the mlx5 driver, please change the definition of
the create_singlethread_workqueue() such that it accept a format
specifier and a variable number of arguments.

Thanks,

Bart.


