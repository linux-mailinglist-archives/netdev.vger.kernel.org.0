Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1E4377413
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 22:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhEHUsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 16:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhEHUsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 16:48:51 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FECC061574;
        Sat,  8 May 2021 13:47:43 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id p12so15991264ljg.1;
        Sat, 08 May 2021 13:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZqFjcJzwpOTq9GtmlmbZMzkDp6Su/3i4cPc+0PSnWlU=;
        b=cmUr1lOfJQc0OQ/TSE6xJZKM6LHx0PUpIU8QmhASSx1zAOnkbpdOCgQiW9iwyK6Mrs
         UzxXZVPtdhXnrYifjJuslr98k4/wmGHgK+OtCJRbgHYZrzPu1IitgQREtO3YSPVZK44W
         /g5+BNelIICkFpisnLctaQqW4nO3MeG8OcY9B8AbGFDf2ifqoks1+cuLThbU146+XlMr
         daRqIGaFckxMr2xnF3ChWSAY5bLNW5eb1MsXO1VJ555wZsqiBc82qPizeRPhdysMndjO
         tPnOmGP+vzMtngj7kq5zNTOWVYgHgjoFqcnEGmpMbezzvMuU9r89bYUIc3rvgM2LO97K
         g7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZqFjcJzwpOTq9GtmlmbZMzkDp6Su/3i4cPc+0PSnWlU=;
        b=r3z0zwyeCMpIkN5pEkoRfizHDAfPG9DeQY5seXLME6uyV9vTcOvZiYjxLkLPfCU+Qi
         KNGJbrA9MNlfcU0HmQ2c+2JBnXlDX+7l4sHSr8rTaqYnGAxBIy6jSWbPTYr6YQxEAbI8
         jUjaM+FAck+oznl0pugbZfii71d+Sw7MwRclBJgbmGBNGCpyegnXsjSiUtKeyOzvpUR+
         NByz32UVZOR5XZelpaspYVT4sPVfey1DGRL9t5fFBx07F6pJxI63PMGin8zlsmbAGvYd
         cRHZDW3iK9GtTdAf4290EQmNlbrM3ZWlReJvb+z4AxecVcdIgI9FC5LX4oGoBrj2TCXQ
         Fkig==
X-Gm-Message-State: AOAM531wd3oFdES9Ztfp6t7g9daERqff9461CkC82SpFsZWhx3qhfP/G
        i86kG6PaZgX35l8ta1Q0o/zZ7YBh/jc=
X-Google-Smtp-Source: ABdhPJyiz1w+vQYC5qSHYCxHJXVe/+ciNhxyTz6jlOHgcQ2N1d7ee4a9piwACRFnLDoOJJwasqHYYw==
X-Received: by 2002:a2e:a309:: with SMTP id l9mr10405525lje.132.1620506862079;
        Sat, 08 May 2021 13:47:42 -0700 (PDT)
Received: from [192.168.1.102] ([31.173.86.161])
        by smtp.gmail.com with ESMTPSA id h18sm612371ljm.27.2021.05.08.13.47.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 13:47:41 -0700 (PDT)
Subject: Re: [PATCH] net: renesas: ravb: Fix a stuck issue when a lot of
 frames are received
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
References: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <68291557-0af5-de1e-4f4f-b104bb65c6b3@gmail.com>
Date:   Sat, 8 May 2021 23:47:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210421045246.215779-1-yoshihiro.shimoda.uh@renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 4/21/21 7:52 AM, Yoshihiro Shimoda wrote:

   Posting a review of the already commited (over my head) patch. It would have
been appropriate if the patch looked OK but it's not. :-/

> When a lot of frames were received in the short term, the driver
> caused a stuck of receiving until a new frame was received. For example,
> the following command from other device could cause this issue.
> 
>     $ sudo ping -f -l 1000 -c 1000 <this driver's ipaddress>

   -l is essential here, right?
   Have you tried testing sh_eth sriver like that, BTW?

> The previous code always cleared the interrupt flag of RX but checks
> the interrupt flags in ravb_poll(). So, ravb_poll() could not call
> ravb_rx() in the next time until a new RX frame was received if
> ravb_rx() returned true. To fix the issue, always calls ravb_rx()
> regardless the interrupt flags condition.

   That bacially defeats the purpose of IIUC...

> Fixes: c156633f1353 ("Renesas Ethernet AVB driver proper")
> Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 35 ++++++++----------------
>  1 file changed, 12 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index eb0c03bdb12d..cad57d58d764 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -911,31 +911,20 @@ static int ravb_poll(struct napi_struct *napi, int budget)
>  	int q = napi - priv->napi;
>  	int mask = BIT(q);
>  	int quota = budget;
> -	u32 ris0, tis;
>  
> -	for (;;) {
> -		tis = ravb_read(ndev, TIS);
> -		ris0 = ravb_read(ndev, RIS0);
> -		if (!((ris0 & mask) || (tis & mask)))
> -			break;
> +	/* Processing RX Descriptor Ring */
> +	/* Clear RX interrupt */

   I think these 2 coments should've been collapsed...
 
> +	ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
> +	if (ravb_rx(ndev, &quota, q))
> +		goto out;
>  
> -		/* Processing RX Descriptor Ring */
> -		if (ris0 & mask) {
> -			/* Clear RX interrupt */
> -			ravb_write(ndev, ~(mask | RIS0_RESERVED), RIS0);
> -			if (ravb_rx(ndev, &quota, q))
> -				goto out;

   This jumps over the TX NAPI code, not good... Seems like another bug.

> -		}
> -		/* Processing TX Descriptor Ring */
> -		if (tis & mask) {
> -			spin_lock_irqsave(&priv->lock, flags);
> -			/* Clear TX interrupt */
> -			ravb_write(ndev, ~(mask | TIS_RESERVED), TIS);
> -			ravb_tx_free(ndev, q, true);
> -			netif_wake_subqueue(ndev, q);
> -			spin_unlock_irqrestore(&priv->lock, flags);
> -		}
> -	}
> +	/* Processing RX Descriptor Ring */

   TX!

> +	spin_lock_irqsave(&priv->lock, flags);
> +	/* Clear TX interrupt */
> +	ravb_write(ndev, ~(mask | TIS_RESERVED), TIS);
> +	ravb_tx_free(ndev, q, true);
> +	netif_wake_subqueue(ndev, q);
> +	spin_unlock_irqrestore(&priv->lock, flags);
>  
>  	napi_complete(napi);
>  

MBR, Sergei
