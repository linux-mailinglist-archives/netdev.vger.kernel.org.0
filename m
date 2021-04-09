Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41110359BF3
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 12:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhDIK0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 06:26:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231638AbhDIK0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 06:26:31 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0DFC061760;
        Fri,  9 Apr 2021 03:26:18 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id s7so4987727wru.6;
        Fri, 09 Apr 2021 03:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LRAyoqSstv9qcrVjPv+B4YXhvLoW8/SLy7wVQjukdx4=;
        b=fT3uh1Tg12CI5KeTSpiwstJvKUIb0Jg5amRuuD4aMieGsELFvBptCFYon3x81ZbqtJ
         BMpXvhAdjwwqzF7CTJmxUaC9Xs0nnMs8ihbg+/zervtql6Vw8pQV0qIy1zgfIBMgrihz
         pYigmfs/Dz7VwE+Vlf/jo4+A+0Yf/a0iKruTLa7IDRbeqJfW7pRi4Pg4YD+czhyy4KfB
         SKri2g8qO7lhgbEef/5y94SfJBZbqUHzh39U1AP9Nu+O3NEwenFgs8AYrEiKUG6JAk7C
         zE8cNulj/4/OO1GjEW1qB9frGfqwEWAkWXvwpr6dQkAV9V2jWXBYtJuku2jVcOfkc0W2
         EiPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LRAyoqSstv9qcrVjPv+B4YXhvLoW8/SLy7wVQjukdx4=;
        b=m4tYAdgi2ZZNmHYdjz0EJBLNHLjNJCDoyy4DlXOl+JeVBrrIczDklbYCSUkoa3+P3h
         Bpfl1I2puAFowfVuFmSUS4+sJbZA7RxL/vW15QjsiVuwFB9NvdkSbFKT5ZDYr8qWz2LZ
         TJU6PM86r1ZqqzEea0/ljIJvmxUymtXTBvaoSMbb2paLRAbzhGm37mqI5uTSlx/TgvDm
         nwV75rj3v/QCn2vu0HLGcd9JrAhrlkZwDjvoXL+4Kk46NjRJNbKrBezU66QKRcFWJDW1
         IJvaxPeS/mT5Sj+FGiGLHirFG3hznQ+yZTjj5UitwFkHpNTEaUl6pvDClvc1A42ke5lc
         woNQ==
X-Gm-Message-State: AOAM532uLyPsCek1YIlKZ8GU76QaM5rItDGwjAVJoS8kh7acePIJDWob
        gEgKOMRTlc/vLNfvwJXg/6iA6kNipv4=
X-Google-Smtp-Source: ABdhPJyRaboQNnb4wffn7NnFkh1UNbm6Nyg27QXBRQRF0/EWjZS4BANfYNnApYnrGB93QtMRPuEhCA==
X-Received: by 2002:a5d:5152:: with SMTP id u18mr16423345wrt.289.1617963977545;
        Fri, 09 Apr 2021 03:26:17 -0700 (PDT)
Received: from [192.168.1.101] ([37.167.116.29])
        by smtp.gmail.com with ESMTPSA id y22sm3785521wmc.18.2021.04.09.03.26.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 03:26:16 -0700 (PDT)
Subject: Re: [PATCH] net/rds: Avoid potential use after free in
 rds_send_remove_from_sock
To:     Aditya Pakki <pakki001@umn.edu>
Cc:     Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
References: <20210407000913.2207831-1-pakki001@umn.edu>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bd3c84bc-6ae0-63e9-61f2-5cf64a976531@gmail.com>
Date:   Fri, 9 Apr 2021 12:26:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210407000913.2207831-1-pakki001@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/7/21 2:09 AM, Aditya Pakki wrote:
> In case of rs failure in rds_send_remove_from_sock(), the 'rm' resource
> is freed and later under spinlock, causing potential use-after-free.
> Set the free pointer to NULL to avoid undefined behavior.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  net/rds/message.c | 1 +
>  net/rds/send.c    | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/rds/message.c b/net/rds/message.c
> index 071a261fdaab..90ebcfe5fe3b 100644
> --- a/net/rds/message.c
> +++ b/net/rds/message.c
> @@ -180,6 +180,7 @@ void rds_message_put(struct rds_message *rm)
>  		rds_message_purge(rm);
>  
>  		kfree(rm);
> +		rm = NULL;

This is a nop really.

This does not clear @rm variable in the caller.



>  	}
>  }
>  EXPORT_SYMBOL_GPL(rds_message_put);
> diff --git a/net/rds/send.c b/net/rds/send.c
> index 985d0b7713ac..fe5264b9d4b3 100644
> --- a/net/rds/send.c
> +++ b/net/rds/send.c
> @@ -665,7 +665,7 @@ static void rds_send_remove_from_sock(struct list_head *messages, int status)
>  unlock_and_drop:
>  		spin_unlock_irqrestore(&rm->m_rs_lock, flags);
>  		rds_message_put(rm);
> -		if (was_on_sock)
> +		if (was_on_sock && rm)
>  			rds_message_put(rm);

Maybe the bug is that the refcount has not be elevated when was_on_sock
has been set.

>  	}
>  
> 
