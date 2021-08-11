Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509253E8B34
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 09:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235701AbhHKHpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 03:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbhHKHpM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 03:45:12 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DFDC061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 00:44:48 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h13so1759018wrp.1
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 00:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zaBsxBQ5BELN++izmX2i8k+1VdLUPtmFKDmfWeEsYNw=;
        b=RG01cEUiJLFKO6Vo1OXzaaYysLuYpdF0+NVUdIhGzBGJ31npXIgOBJGZHmpVz4jUgv
         UwE6NBXzBTARigtNDF+gBZ60UJ9oy34H1E3tXk6qEZEGGvTxe6Y/qG31Qdle0uw98me1
         WQTIuNhEgIQp471Zy4qjr2QPOulrT5vBTCOLNyoQ8DLl8E+6j95EpIqxNywQB/Nt81+t
         YdfvEV/fBT8/FXnvqqSCsl6ffzVa3hOD//+RoWHvzoLNLx+GS1TBOKhhMai+XhwG8dOB
         bBon1BaYhMWCGK2DjKX97yUbmM1xHISX9SJMVCwH6y9Uig5YzGhCIsNb3Gthv1bwfNb7
         ndBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zaBsxBQ5BELN++izmX2i8k+1VdLUPtmFKDmfWeEsYNw=;
        b=ihK7Z1wANsIkqkf1hpo2vQm3xkw8NJ+KJ2pAkFTgc4yULlahLg5kbPrgrbIjk7my7H
         p5z4Yvqrx/7PXYQzaKTqdKzdvjQP4uZzQVHCazq9Gz/7x+YgYYrCQ0n0IAd5LAp9FPRY
         o2vpgg6VMR6kRf9btM2cVzSVGgBVDHv5FSYk+We3m2AH24pqOaKAahhDReJMhs6zYGVc
         gAY/cAqb+2CUtD6XLDd0xN00Ke7/cQd6ipnxmZDa0HIROUG/iDP7ng0w5R7LrPT3T0pJ
         UiFFRdwz+XJJZEkngrN4nDNtYTw0Dqre8+6ZYfgH/kkASWXmfPffQ+4YAtJOVaGHyvI9
         yMCQ==
X-Gm-Message-State: AOAM5336u4eQybjQM30be1i+pMZIFsSJF8nK5l8Wanrngexy6kNexnBR
        V+whyf7SmzZdCAdDdO+nJ8o=
X-Google-Smtp-Source: ABdhPJxG1B2L4Ttid0Dqh/IW2zOUhQ9qw8BOGMh7tE8t8vX32DyIXLYcpOxbY9uwXfDfnCN6kYjqjg==
X-Received: by 2002:a5d:6186:: with SMTP id j6mr36323880wru.115.1628667887266;
        Wed, 11 Aug 2021 00:44:47 -0700 (PDT)
Received: from [10.0.0.18] ([37.165.193.81])
        by smtp.gmail.com with ESMTPSA id z17sm26445240wrt.47.2021.08.11.00.44.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 00:44:46 -0700 (PDT)
Subject: Re: [PATCH] net:sched fix array-index-out-of-bounds in taprio_change
To:     tcs.kernel@gmail.com, vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
References: <1628658609-1208-1-git-send-email-tcs_kernel@tencent.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <303b095e-3342-9461-16ae-86d0923b7dc7@gmail.com>
Date:   Wed, 11 Aug 2021 09:44:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628658609-1208-1-git-send-email-tcs_kernel@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/11/21 7:10 AM, tcs.kernel@gmail.com wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
> 
> syzbot report an array-index-out-of-bounds in taprio_change
> index 16 is out of range for type '__u16 [16]'
> that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
> the return value of netdev_set_num_tc.
> 
> Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com
> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
> ---
>  net/sched/sch_taprio.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 9c79374..1ab2fc9 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -1513,7 +1513,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>  	taprio_set_picos_per_byte(dev, q);
>  
>  	if (mqprio) {
> -		netdev_set_num_tc(dev, mqprio->num_tc);
> +		err = netdev_set_num_tc(dev, mqprio->num_tc);
> +		if (err)
> +			goto free_sched;
>  		for (i = 0; i < mqprio->num_tc; i++)
>  			netdev_set_tc_queue(dev, i,
>  					    mqprio->count[i],
> 

When was the bug added ?

Hint: Please provide a Fixes: tag

taprio_parse_mqprio_opt() already checks :

/* Verify num_tc is not out of max range */
if (qopt->num_tc > TC_MAX_QUEUE) {
    NL_SET_ERR_MSG(extack, "Number of traffic classes is outside valid range");
    return -EINVAL;
}

So what is happening exactly ?




