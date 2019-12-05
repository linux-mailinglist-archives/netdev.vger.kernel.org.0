Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC95E113A36
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 04:08:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728539AbfLEDIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 22:08:52 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41008 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbfLEDIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 22:08:51 -0500
Received: by mail-pf1-f194.google.com with SMTP id s18so861451pfd.8
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 19:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bChhO4OU147A4lNiHygrOQOHfsld5u+2i6MQ4feNf3w=;
        b=KbQaeKWKsSbMI2OWmxT35SPKmhoJCVR7Dox22tFW1QmmzbEIbPCbIFt+0WM+bC7pLl
         QbZNonL1DgSo/sa5gy7gDoTA7TicUpE5a+z696sI+Ay4NxtE6O3KIEK37IX+Qpkqivmt
         RN1CSrd0tkiTP+D0qYDWs3Sd0UaekCpuUMbj/HzNjjzvDffkz7PRZpUEIqHQopfFh4a+
         MzHTHgPQjPsVmgEaAQvFRHUqFTmjqsm0cNwSf/QMt0Shj7wCIl8Z3bgGwFFeerBISuXI
         yu20NtvNH0VeeEXApGBdJBHa3JPwmZhXjVNLM+ZK5JsFHuf7MASjHH8Hbo5jbpzSamKd
         Tsgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bChhO4OU147A4lNiHygrOQOHfsld5u+2i6MQ4feNf3w=;
        b=SdGRMgOlMHGiqlHpWrAke1w01NrYZ5kYevkqtLtP0FuL7SCbRH8V5/q5dtFLPSZupr
         booQJsIY2l7ZlU/rVqkbgn+axcal7Wh5tH8eqp+2nXlYA080pgoMmtNT3UT12s9uByGR
         bBhCREMZ4TFqn7vDNHwjmzSyG983Shidkr1MZn+E0fQqqIR8Fn71JsCxUEjcv/IIh8qC
         toPUWHQ3Z1RvzOdd0Swf4IIrXUyYhQL3NsB1oBIygThY4UrKBGuPY42YxtkIunxp4nvu
         A7biEnkIG6w8ramCRHBpJukXTE3LYnH4Z9q0gP0NBHKKehBvugVPFORZN0LWvZnqu8zn
         SLkQ==
X-Gm-Message-State: APjAAAWmjH8Bl5ZbwZqme8BHeGygR0SR6wJ70eMcoxjUiTnK01owym+C
        5X6NOnH5nJ6U0Oq2XNeiSYg=
X-Google-Smtp-Source: APXvYqwzCxnF2yPATe30TeRSgX18WekMXwGomMJWqwH8zofZH6HGj5ecC6yokeEfrrYVi6LzXTxfsQ==
X-Received: by 2002:a63:d551:: with SMTP id v17mr7178680pgi.365.1575515331062;
        Wed, 04 Dec 2019 19:08:51 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o23sm9099605pgj.90.2019.12.04.19.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2019 19:08:50 -0800 (PST)
Subject: Re: [PATCH net v2 2/2] tcp: tighten acceptance of ACKs not matching a
 child socket
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>
References: <cover.1575503545.git.gnault@redhat.com>
 <1d7e9bc77fb68706d955e4089a801ace0df5d771.1575503545.git.gnault@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <80ffa7b6-bbaf-ce52-606f-d10e45644bcd@gmail.com>
Date:   Wed, 4 Dec 2019 19:08:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1d7e9bc77fb68706d955e4089a801ace0df5d771.1575503545.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/4/19 4:59 PM, Guillaume Nault wrote:
> When no synflood occurs, the synflood timestamp isn't updated.
> Therefore it can be so old that time_after32() can consider it to be
> in the future.
> 
> That's a problem for tcp_synq_no_recent_overflow() as it may report
> that a recent overflow occurred while, in fact, it's just that jiffies
> has grown past 'last_overflow' + TCP_SYNCOOKIE_VALID + 2^31.
> 
> Spurious detection of recent overflows lead to extra syncookie
> verification in cookie_v[46]_check(). At that point, the verification
> should fail and the packet dropped. But we should have dropped the
> packet earlier as we didn't even send a syncookie.
> 
> Let's refine tcp_synq_no_recent_overflow() to report a recent overflow
> only if jiffies is within the
> [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval. This
> way, no spurious recent overflow is reported when jiffies wraps and
> 'last_overflow' becomes in the future from the point of view of
> time_after32().
> 
> However, if jiffies wraps and enters the
> [last_overflow, last_overflow + TCP_SYNCOOKIE_VALID] interval (with
> 'last_overflow' being a stale synflood timestamp), then
> tcp_synq_no_recent_overflow() still erroneously reports an
> overflow. In such cases, we have to rely on syncookie verification
> to drop the packet. We unfortunately have no way to differentiate
> between a fresh and a stale syncookie timestamp.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  include/net/tcp.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index f0eae83ee555..005d4c691543 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -520,12 +520,14 @@ static inline bool tcp_synq_no_recent_overflow(const struct sock *sk)
>  		if (likely(reuse)) {
>  			last_overflow = READ_ONCE(reuse->synq_overflow_ts);
>  			return time_after32(now, last_overflow +
> -					    TCP_SYNCOOKIE_VALID);
> +					    TCP_SYNCOOKIE_VALID) ||
> +				time_before32(now, last_overflow);
>  		}
>  	}
>  
>  	last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
> -	return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID);
> +	return time_after32(now, last_overflow + TCP_SYNCOOKIE_VALID) ||
> +		time_before32(now, last_overflow);
>  }


There is a race I believe here.

CPU1                                 CPU2
 
now = jiffies.
    ...
                                     jiffies++
                                     ...
                                     SYN received, last_overflow is updated to the new jiffies.


CPU1 
 timer_before32(now, last_overflow) is true, because last_overflow was set to now+1


I suggest some cushion here.

Also we TCP uses between() macro, we might add a time_between32(a, b, c) macro
to ease code review.

->
  return !time_between32(last_overflow - HZ, now, last_overflow + TCP_SYNCOOKIE_VALID);


