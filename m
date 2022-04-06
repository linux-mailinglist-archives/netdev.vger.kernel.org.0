Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B21F4F5E46
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbiDFMlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiDFMkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:40:55 -0400
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611F157E270
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 01:45:18 -0700 (PDT)
Received: by mail-ej1-f41.google.com with SMTP id l26so2821843ejx.1
        for <netdev@vger.kernel.org>; Wed, 06 Apr 2022 01:45:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4jwHnOOOunM2p3fB60moZ62Tj5OCoqYJ5ZjN1VA/7ZA=;
        b=z5x7OrDMUcAnLWa3lMVtB1NgwrRXIxtkR5FHGXFt/o3ew2rZ3HJmLvWbGWf/JvtqF/
         VQTBNplvsNdiE99EykW3cQqjSYUQIm4jD/dVDdJQ5uEBz9V7vgU1aC6RTj6YN2nifMYs
         qPVlmwe6k/PTsJ8YF1huhJCi0XkTSFHU45JeP+sfcAzd6Tx0pmj3bxI5py/fOw2xPXAb
         MtaLmwdM1Nhg8JHe0Tp/vhk//qQiwCHQXZK5XwRMSvxmcg4HeJiv+kZQkPzOO0pgtJWj
         EDcta9ecgmPcZFFTi7pcUwimTGxssShCJ/A+2B9sjhJjuJYj4LeWSTzRXE3Tn86bBx2R
         ix3g==
X-Gm-Message-State: AOAM533/d5sUVm/Emeq9WMu80Xe8ptGMpMQRfyuoGIY79vnCpvscW16M
        6PNsUXJJItlSx4ayhZHhqxY=
X-Google-Smtp-Source: ABdhPJzrzi+N6iLOQj7waoK6xvq/IBsqaKcKfrlFDTe/AH7GzRdzSu0JYVxUrdqw2PD4Pp+B8iPskQ==
X-Received: by 2002:a17:907:1c0a:b0:6da:7ac4:5349 with SMTP id nc10-20020a1709071c0a00b006da7ac45349mr7127817ejc.596.1649234707323;
        Wed, 06 Apr 2022 01:45:07 -0700 (PDT)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id y8-20020a50d8c8000000b0041c80bb88c7sm7163652edj.8.2022.04.06.01.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 01:45:06 -0700 (PDT)
Message-ID: <631ac05c-6807-11ff-c940-cd27bcc3a925@kernel.org>
Date:   Wed, 6 Apr 2022 10:45:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] drivers: net: slip: fix NPD bug in sl_tx_timeout()
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, davem@davemloft.net
Cc:     kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.or, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org
References: <20220405132206.55291-1-duoming@zju.edu.cn>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220405132206.55291-1-duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05. 04. 22, 15:22, Duoming Zhou wrote:
> When a slip driver is detaching, the slip_close() will act to
> cleanup necessary resources and sl->tty is set to NULL in
> slip_close(). Meanwhile, the packet we transmit is blocked,
> sl_tx_timeout() will be called. Although slip_close() and
> sl_tx_timeout() use sl->lock to synchronize, we don`t judge
> whether sl->tty equals to NULL in sl_tx_timeout() and the
> null pointer dereference bug will happen.
> 
>     (Thread 1)                 |      (Thread 2)
>                                | slip_close()
>                                |   spin_lock_bh(&sl->lock)
>                                |   ...
> ...                           |   sl->tty = NULL //(1)
> sl_tx_timeout()               |   spin_unlock_bh(&sl->lock)
>    spin_lock(&sl->lock);       |
>    ...                         |   ...
>    tty_chars_in_buffer(sl->tty)|
>      if (tty->ops->..) //(2)   |
>      ...                       |   synchronize_rcu()
> 
> We set NULL to sl->tty in position (1) and dereference sl->tty
> in position (2).
> 
> This patch adds check in sl_tx_timeout(). If sl->tty equals to
> NULL, sl_tx_timeout() will goto out.

It makes sense. unregister_netdev() (to kill the timer) is called only 
later in slip_close().

Reviewed-by: Jiri Slaby <jirislaby@kernel.org>

> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>   drivers/net/slip/slip.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
> index 88396ff99f0..6865d32270e 100644
> --- a/drivers/net/slip/slip.c
> +++ b/drivers/net/slip/slip.c
> @@ -469,7 +469,7 @@ static void sl_tx_timeout(struct net_device *dev, unsigned int txqueue)
>   	spin_lock(&sl->lock);
>   
>   	if (netif_queue_stopped(dev)) {
> -		if (!netif_running(dev))
> +		if (!netif_running(dev) || !sl->tty)
>   			goto out;
>   
>   		/* May be we must check transmitter timeout here ?


-- 
js
suse labs
