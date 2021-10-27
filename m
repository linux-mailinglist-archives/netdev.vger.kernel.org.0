Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE1F43D18A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240714AbhJ0TWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232939AbhJ0TWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 15:22:32 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89789C061570;
        Wed, 27 Oct 2021 12:20:06 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b4so528520plg.13;
        Wed, 27 Oct 2021 12:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lamt7wUkPTKdaqCHkren9ZWjMjcvTJYr9lIMgEW7TmU=;
        b=BJqeF9vFLoLHqQqJ3zbonBdnFs+qlgbrNY2cQZ25KhjvuWPtXS1S+181gyYzg0X5YK
         26vrbsw1dboTy/KljayAV4ZK45ReGmh2IrUqbRCvGeWHPhfpQychYrXCnr2moeppqTN7
         0pGN4+T8lF4u/+FZy8IAsC+X1ZR9QUuirTK100SiliVSf+B2DHzXy4X+troFE9zGvVJD
         WgWu7VXuonyxDF0+MzbVOr8K3W/9RM/9FXdMjDJB1QXxPdA/MGTghDPGQANTK0LcMrYd
         YRQtPMr0mejuwiRNHV4WoYy9hxiijXHrU5UgUajPEaGZvAE1D++MPVU2P/KlS9L0ZpuH
         eHsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lamt7wUkPTKdaqCHkren9ZWjMjcvTJYr9lIMgEW7TmU=;
        b=pyLsjYTkVt2TEodeqJIB9ldSQrBBMKCJv3aq+zYtWEEqf51KX/CvqIk0yUJ0J8fHgT
         YTobJCqPpKyjSYXslr52it0wUeRIf78FKNT6eZ4XYhGMar8pB6+4OA6IAgZmjqNRyIUP
         be6dXPhe/SQwabLeA4s8LHGakXW8X5gg59QpVLZDvD8e4gubB1w6OlFsKRZMI6IQcHgB
         q8ttLvmZDqIw05XgVjTMfKMguqSPLGZNUVm+dd+wIBnQQ4gF6IFbq852XbC5JOdyyes0
         uK4CFfimVUoHXqapPDBWloYlvaMllw/lBb6cjYIGkd3lMkbqcH9UURryyknlkH90Do9X
         cvkQ==
X-Gm-Message-State: AOAM531CAwJT1gETehKVpaoJrC/f/sI6Nu9sAWia/DlZIfibjyxIqC6o
        1ch1QTAS2Xw06Co7mW1l9hLNaqsdmeA=
X-Google-Smtp-Source: ABdhPJyAFtO0cS47gquTRUbwKao74WeeguktQUO8O084Mqv8pmcX9QoAtl1a/sAi+iRiqDl8WlvFiA==
X-Received: by 2002:a17:902:d718:b0:13d:e2ec:1741 with SMTP id w24-20020a170902d71800b0013de2ec1741mr29977108ply.38.1635362406094;
        Wed, 27 Oct 2021 12:20:06 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id s33sm803136pfg.18.2021.10.27.12.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Oct 2021 12:20:05 -0700 (PDT)
Subject: Re: [PATCH net] net: gro: set the last skb->next to NULL when it get
 merged
To:     kerneljasonxing@gmail.com, davem@davemloft.net, kuba@kernel.org,
        alobakin@pm.me, jonathan.lemon@gmail.com, willemb@google.com,
        pabeni@redhat.com, vvs@virtuozzo.com, cong.wang@bytedance.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Xing <xingwanli@kuaishou.com>
References: <20211026131859.59114-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2b839087-ed6a-d498-e1ab-c6bcea2f2965@gmail.com>
Date:   Wed, 27 Oct 2021 12:20:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211026131859.59114-1-kerneljasonxing@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/26/21 6:18 AM, kerneljasonxing@gmail.com wrote:
> From: Jason Xing <xingwanli@kuaishou.com>
> 
> Setting the @next of the last skb to NULL to prevent the panic in future
> when someone does something to the last of the gro list but its @next is
> invalid.
> 
> For example, without the fix (commit: ece23711dd95), a panic could happen
> with the clsact loaded when skb is redirected and then validated in
> validate_xmit_skb_list() which could access the error addr of the @next
> of the last skb. Thus, "general protection fault" would appear after that.
> 

If this a bug, please provide a Fixes: tag

> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> ---
>  net/core/skbuff.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 2170bea..7b248f1 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4396,6 +4396,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
>  		skb_shinfo(p)->frag_list = skb;
>  	else
>  		NAPI_GRO_CB(p)->last->next = skb;
> +	skb->next = NULL;

Really at this point skb->next must be already NULL.

Please provide a stack trace so that we fix the caller instead
of adding more code in GRO layer.


>  	NAPI_GRO_CB(p)->last = skb;
>  	__skb_header_release(skb);
>  	lp = p;
> 
