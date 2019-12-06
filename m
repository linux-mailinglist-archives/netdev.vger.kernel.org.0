Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35671114B76
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 04:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbfLFDlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 22:41:37 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:42611 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726198AbfLFDlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 22:41:37 -0500
Received: by mail-pj1-f65.google.com with SMTP id o11so2139194pjp.9
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 19:41:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yLRsR5stIRLEoTVo2xyn4rt2VLNG6SVxgBmlY9WxK7M=;
        b=dJ8KyLAHnm2dBfDzvMZ/gVBQJ8hXvhSjbTyJOKIY4cJGwEiYgK5vdy+NV8cuqMg7f2
         TqdhAN+rsSYHKegipqcVLU7NiYCnG6M4plJZsA4SVHFF9xtYjHwnIc5pFdcdvdEF1zn3
         UCIW0c+/A1cl/DuyGOJ4EHnAPe7nQK73fJCXoRhAu+Jg3dX1imYFVrs/NelSWE9m1oht
         Scde2T7w1PwFhngPOEWfBPThJdumAUP1b9R4pVxShoirwlmSUE2YXqwDBqbSDOXQI2ei
         1vU34GwB/WetDhfYuP9NLbSpm1GgwZSTTgGduVaxlWxnIafdlMjhK16Ce/sZWqUmeeM6
         Mq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yLRsR5stIRLEoTVo2xyn4rt2VLNG6SVxgBmlY9WxK7M=;
        b=N/8OdIrAusDZFroxyLUeVzMfp/bhbpYqFaVN9e7Tn8x/bc7NIKLpnvuf5Jb+hDZn3Z
         POA74OpWGka/pVhAqXUFsyC5ZEY3O9FU2MoWtMi0sSN9TY+8bjBK+UNtNw+RLEAj+E3b
         S7rD9NUoyIo5hENx9vC8gF3wepidikN64a2YL3LeZvklUz9eSxK66I6tG8XSbxsVMn29
         HO7Wq6/EmihZ9jmoURqRy/pPFhJ50Mi+bGqyogP5Qu6LXlaULv/bkbdOWW/mO2LUvpj+
         0TfmSpwm55ZdktsWLxK7Cko7ukSayz+kjiVY+fVZ4x4qVpIhU+ImjkCzNhjJ75cw+n3f
         0hoQ==
X-Gm-Message-State: APjAAAWE5pZHsqlOfKvpZZlyZoA4uiO7XXQKDa0dgyYsDe6t3zWSOa53
        k5btWXPr1MEOMNpgLGXw8dJzn3rE
X-Google-Smtp-Source: APXvYqywsvdagf/a7rMwGfm7PQnkzXLUBjBtWnTidFXiZjOGQPW/t37Mrc7PRFhYVY0nMzf53Vuw6Q==
X-Received: by 2002:a17:902:8309:: with SMTP id bd9mr12267339plb.113.1575603696315;
        Thu, 05 Dec 2019 19:41:36 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id p5sm12379376pgs.28.2019.12.05.19.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 19:41:35 -0800 (PST)
Subject: Re: [PATCH net v3 1/3] tcp: fix rejected syncookies due to stale
 timestamps
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
References: <cover.1575595670.git.gnault@redhat.com>
 <3f38a305b3a07fe7b1c275d299f003f290009e13.1575595670.git.gnault@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <db49bc30-9909-b15c-2b36-d805a4487e07@gmail.com>
Date:   Thu, 5 Dec 2019 19:41:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <3f38a305b3a07fe7b1c275d299f003f290009e13.1575595670.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/5/19 5:49 PM, Guillaume Nault wrote:
> If no synflood happens for a long enough period of time, then the
> synflood timestamp isn't refreshed and jiffies can advance so much
> that time_after32() can't accurately compare them any more.
> 
> Therefore, we can end up in a situation where time_after32(now,
> last_overflow + HZ) returns false, just because these two values are
> too far apart. In that case, the synflood timestamp isn't updated as
> it should be, which can trick tcp_synq_no_recent_overflow() into
> rejecting valid syncookies.
> 
> For example, let's consider the following scenario on a system
> with HZ=1000:
> 
>   * The synflood timestamp is 0, either because that's the timestamp
>     of the last synflood or, more commonly, because we're working with
>     a freshly created socket.
> 
>   * We receive a new SYN, which triggers synflood protection. Let's say
>     that this happens when jiffies == 2147484649 (that is,
>     'synflood timestamp' + HZ + 2^31 + 1).
> 
>   * Then tcp_synq_overflow() doesn't update the synflood timestamp,
>     because time_after32(2147484649, 1000) returns false.
>     With:
>       - 2147484649: the value of jiffies, aka. 'now'.
>       - 1000: the value of 'last_overflow' + HZ.
> 
>   * A bit later, we receive the ACK completing the 3WHS. But
>     cookie_v[46]_check() rejects it because tcp_synq_no_recent_overflow()
>     says that we're not under synflood. That's because
>     time_after32(2147484649, 120000) returns false.
>     With:
>       - 2147484649: the value of jiffies, aka. 'now'.
>       - 120000: the value of 'last_overflow' + TCP_SYNCOOKIE_VALID.
> 
>     Of course, in reality jiffies would have increased a bit, but this
>     condition will last for the next 119 seconds, which is far enough
>     to accommodate for jiffie's growth.
> 
> Fix this by updating the overflow timestamp whenever jiffies isn't
> within the [last_overflow, last_overflow + HZ] range. That shouldn't
> have any performance impact since the update still happens at most once
> per second.
> 
> Now we're guaranteed to have fresh timestamps while under synflood, so
> tcp_synq_no_recent_overflow() can safely use it with time_after32() in
> such situations.
> 
> Stale timestamps can still make tcp_synq_no_recent_overflow() return
> the wrong verdict when not under synflood. This will be handled in the
> next patch.
> 
> For 64 bits architectures, the problem was introduced with the
> conversion of ->tw_ts_recent_stamp to 32 bits integer by commit
> cca9bab1b72c ("tcp: use monotonic timestamps for PAWS").
> The problem has always been there on 32 bits architectures.
> 
> Fixes: cca9bab1b72c ("tcp: use monotonic timestamps for PAWS")
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  include/linux/time.h | 13 +++++++++++++
>  include/net/tcp.h    |  5 +++--
>  2 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 0760a4f5a15c..30efc1f0f67d 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -97,4 +97,17 @@ static inline bool itimerspec64_valid(const struct itimerspec64 *its)
>   */
>  #define time_after32(a, b)	((s32)((u32)(b) - (u32)(a)) < 0)
>  #define time_before32(b, a)	time_after32(a, b)
> +
> +/**
> + * time_before32 - check if a 32-bit timestamp is within a given time range

Wrong name ? This should be time_between32

> + * @t:	the time which may be within [l,h]
> + * @l:	the lower bound of the range
> + * @h:	the higher bound of the range
> + *
> + * time_before32(t, l, h) returns true if @l <= @t <= @h. All operands are
> + * treated as 32-bit integers.
> + *
> + * Equivalent to !(time_before32(@t, @l) || time_after32(@t, @h)).
> + */
> +#define time_between32(t, l, h) ((u32)(h) - (u32)(l) >= (u32)(t) - (u32)(l))
>  #endif
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 36f195fb576a..7d734ba391fc 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -494,14 +494,15 @@ static inline void tcp_synq_overflow(const struct sock *sk)
>  		reuse = rcu_dereference(sk->sk_reuseport_cb);
>  		if (likely(reuse)) {
>  			last_overflow = READ_ONCE(reuse->synq_overflow_ts);
> -			if (time_after32(now, last_overflow + HZ))
> +			if (!time_between32(now, last_overflow,
> +					    last_overflow + HZ))
>  				WRITE_ONCE(reuse->synq_overflow_ts, now);
>  			return;
>  		}
>  	}
>  
>  	last_overflow = tcp_sk(sk)->rx_opt.ts_recent_stamp;
> -	if (time_after32(now, last_overflow + HZ))
> +	if (!time_between32(now, last_overflow, last_overflow + HZ))
>  		tcp_sk(sk)->rx_opt.ts_recent_stamp = now;
>  }
>  
> 
