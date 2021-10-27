Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5BA43D689
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 00:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhJ0W2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 18:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbhJ0W2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 18:28:00 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF89C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 15:25:33 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e65so4380357pgc.5
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 15:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g5Aj8OwFEoaWmvumaibRdluKV/1aiNC4qq0s8gJRc+E=;
        b=YNECCC1bl3QB36jnQe7lyee7C5q1BfiLe75S3FB+e7jt8lo3L0zx5LFaPtrTYeaSAf
         qNRHW8R5xdWdGfReppqi2sCrpqQArCHbsa4JHeXSHGTjvcjPEIBoYNBKzf4mdHu4Qb8p
         pZcRxm2M1aNu/c+5Ow2olP5qjVWFKkgQoX+/N8wYhAVQn7RSXU4DXbbWJYRqukioZ6Zk
         xnXHE9wuG7JNfxc5AgRvZV3zGiNumqRoas3rRZRIz6Ia6UPrSXikGNgWfqqsYfCb1LKY
         3tzQg7aeapscKTqXdOLqaw39i+F4bGbto8+4vUS6lrbHeOVmxLp/F8iY2XqWIOKrwlLc
         X7YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g5Aj8OwFEoaWmvumaibRdluKV/1aiNC4qq0s8gJRc+E=;
        b=ay9E7AzbgnQBfCZSajLkzwhYtoY7ZBvYOMaaqzdOfhgZvuwl4ornki2hnmIkLhFQwt
         YOFq0i++ThuzXlMlM/Zv9QsMLtXQXwwW9rnx7N5Tus4zjqq+GSjEG8KbiCTfsDq94OQe
         VSxafgeHIxb7RK/rGJNa9QzGEyb4BwjuwVRXVXjevN5cpbBmgIrR6YrlZi2e7QGODkSE
         NsisllTxGU/gJDQyVSTY4+qhyzsEsSMax+YBlsyAsfsEC4AN3m2ioTPjUE5BloyaSLcw
         fnEQSbyV+2XJH4a7Yxfgv+Aa7klNnZACkmGTg0PMOUAS43mmesZeTv+rPNEksPBjxcHX
         5ILA==
X-Gm-Message-State: AOAM530N2urhb8aZsVFh5rAOw0DQbGP/0J2OO7p6T19R6ztA+bh2sXmv
        P5SFQGbAfBfdCt8YfwMgltM=
X-Google-Smtp-Source: ABdhPJy8TnwliauE6y0rAgnJp7d/3dQMCwlhkX6uAr6v4nY+JgjUdl49FO1/NHVQdDmhv0hTrnzsdA==
X-Received: by 2002:a63:9554:: with SMTP id t20mr349141pgn.255.1635373532541;
        Wed, 27 Oct 2021 15:25:32 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id mt16sm683327pjb.22.2021.10.27.15.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 15:25:31 -0700 (PDT)
Subject: Re: [PATCH] qed: avoid spin loops in _qed_mcp_cmd_and_union()
To:     Caleb Sander <csander@purestorage.com>, netdev@vger.kernel.org
Cc:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        Joern Engel <joern@purestorage.com>
References: <20211027214519.606096-1-csander@purestorage.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d9d4b6d1-d64d-4bfb-17d9-b28153e02b9e@gmail.com>
Date:   Wed, 27 Oct 2021 15:25:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211027214519.606096-1-csander@purestorage.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/27/21 2:45 PM, Caleb Sander wrote:
> By default, qed_mcp_cmd_and_union() sets max_retries to 500K and
> usecs to 10, so these loops can together delay up to 5s.
> We observed thread scheduling delays of over 700ms in production,
> with stacktraces pointing to this code as the culprit.
> 
> Add calls to cond_resched() in both loops to yield the CPU if necessary.
> 
> Signed-off-by: Caleb Sander <csander@purestorage.com>
> Reviewed-by: Joern Engel <joern@purestorage.com>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_mcp.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> index 24cd41567..d6944f020 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> @@ -485,10 +485,12 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
>  
>  		spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
>  
> -		if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP))
> +		if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP)) {

I do not know this driver, but apparently, there is this CAN_SLEEP test
hinting about being able to sleep.

>  			msleep(msecs);
> -		else
> +		} else {
> +			cond_resched();

Here you might sleep/schedule, while CAN_SLEEP was not set ?

>  			udelay(usecs);


I would suggest using usleep_range() instead, because cond_resched()
can be a NOP under some circumstances.

> +		}
>  	} while (++cnt < max_retries);

Then perhaps not count against max_retries, but based on total elapsed time ?

>  
>  	if (cnt >= max_retries) {
> @@ -517,10 +519,12 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
>  		 * The spinlock stays locked until the list element is removed.
>  		 */
>  
> -		if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP))
> +		if (QED_MB_FLAGS_IS_SET(p_mb_params, CAN_SLEEP)) {
>  			msleep(msecs);
> -		else
> +		} else {
> +			cond_resched();
>  			udelay(usecs);
> +		}
>  
>  		spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
>  
> 
