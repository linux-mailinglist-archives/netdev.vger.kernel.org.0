Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6081C151F52
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 18:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbgBDRXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 12:23:00 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:33733 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727501AbgBDRW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 12:22:59 -0500
Received: by mail-pj1-f68.google.com with SMTP id m7so1040878pjs.0;
        Tue, 04 Feb 2020 09:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hc2O/DJa+SbVtGN5pJ7qoYwZMHQBm+KpbKV1j82QsLo=;
        b=FZOSE1cm6cxg7GDUk43uErcYeL8r98b5mATYq32pk+E3rMY8r8481VSvVde93h+ecs
         F7AjkBeWOgCvsMqzLtqKDne8hSkYuHYMHGLw7nLM/OyTQo6+C9Dp1iIIsUWiCw5lSMWf
         NqjpLv1eVHUItpOI4iDdt6FdRkv6oRjDEfLTU4jXtPI9syWATjHcuqmuriWeGZCI8Y8y
         4vkjtJqJvjGPQv+J9Rf+wuuxHGVBmwkYGHpuCA9XMXWZRWDZKE/dk1M6ceO/5Rv9YUOV
         fBp+p6mVUk4C1W3qPpncp+Olr+9M3PecXxO9a8vpIni0DXSiHx/j9UgnqzfShLJq6+ch
         ER1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hc2O/DJa+SbVtGN5pJ7qoYwZMHQBm+KpbKV1j82QsLo=;
        b=E6tPQrQwvy5w0VtE9maaUL/b1iUVbZXbkS/va36D+Iihqlx4O1sNqQJqFeXdBZyna7
         FYg3PVmYB23Cne/IKUtTegOOKTt9jrJo5HYJez/G/CTGzqYT44HhJwo/PWjl76lAUaCi
         2LuOjzOE6zCrZlJp4NT7K4ICZnxHlMbgc3BrppQO7xsPEZR+s8HmCpwgnJYAB73WzgN2
         vHtGZ3NrSJDsfUKjTQ4BpwMqC/zPSqfZE/DMOqoxo26otua/fGKnb/5ELZkA8koAhPRk
         L4RVEqGTVVs1WCuKqyecxQbShZ8a656ETJ4aNj9647TSGEBH3U9CCJ07QSFSlpxFmgy6
         udow==
X-Gm-Message-State: APjAAAVFprYoIcFLF6nVVW6+O8fSBycHcOIlgbxelK99qFP+X/WEvlom
        pQ9jffGbYfMDrhPjWZHxUFJJAXDJ
X-Google-Smtp-Source: APXvYqy7iG09y8o63IJ5RQklu8YJLenNB0Eekk87qymcm7jhpREh6oKFybD5WWWWusHykXWedpWD/w==
X-Received: by 2002:a17:902:7e4b:: with SMTP id a11mr30483505pln.61.1580836978921;
        Tue, 04 Feb 2020 09:22:58 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id s7sm4515747pjk.22.2020.02.04.09.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 09:22:58 -0800 (PST)
Subject: Re: [PATCH v2] skbuff: fix a data race in skb_queue_len()
To:     Qian Cai <cai@lca.pw>, davem@davemloft.net
Cc:     kuba@kernel.org, elver@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1580832945-28331-1-git-send-email-cai@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d73b3f08-a01e-95db-8beb-a11b33d834e8@gmail.com>
Date:   Tue, 4 Feb 2020 09:22:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1580832945-28331-1-git-send-email-cai@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/20 8:15 AM, Qian Cai wrote:
> sk_buff.qlen can be accessed concurrently as noticed by KCSAN,
> 
> 
> Since only the read is operating as lockless, it could introduce a logic
> bug in unix_recvq_full() due to the load tearing. Fix it by adding
> a lockless variant of skb_queue_len() and unix_recvq_full() where
> READ_ONCE() is on the read while WRITE_ONCE() is on the write similar to
> the commit d7d16a89350a ("net: add skb_queue_empty_lockless()").
> 
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
> 
> v2: add lockless variant helpers and WRITE_ONCE().
> 
>  include/linux/skbuff.h | 14 +++++++++++++-
>  net/unix/af_unix.c     |  9 ++++++++-
>  2 files changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 3d13a4b717e9..de5eade20e52 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1822,6 +1822,18 @@ static inline __u32 skb_queue_len(const struct sk_buff_head *list_)
>  }
>  
>  /**
> + *	skb_queue_len	- get queue length

Please fix to use the exact name.

> + *	@list_: list to measure
> + *
> + *	Return the length of an &sk_buff queue.
> + *	This variant can be used in lockless contexts.
> + */
> +static inline __u32 skb_queue_len_lockless(const struct sk_buff_head *list_)
> +{
> +	return READ_ONCE(list_->qlen);
> +}
> +
> +/**
>   *	__skb_queue_head_init - initialize non-spinlock portions of sk_buff_head
>   *	@list: queue to initialize
>   *
> @@ -2026,7 +2038,7 @@ static inline void __skb_unlink(struct sk_buff *skb, struct sk_buff_head *list)
>  {
>  	struct sk_buff *next, *prev;
>  
> -	list->qlen--;
> +	WRITE_ONCE(list->qlen, list->qlen - 1);
>  	next	   = skb->next;
>  	prev	   = skb->prev;
>  	skb->next  = skb->prev = NULL;
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index 321af97c7bbe..349e7fbfbc67 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -194,6 +194,12 @@ static inline int unix_recvq_full(struct sock const *sk)
>  	return skb_queue_len(&sk->sk_receive_queue) > sk->sk_max_ack_backlog;
>  }
>  
> +static inline int unix_recvq_full_lockless(struct sock const *sk)

The const attribute is misplaced. It should be :

static inline bool unix_recvq_full_lockless(const struct sock *sk)

> +{
> +	return skb_queue_len_lockless(&sk->sk_receive_queue) >
> +		sk->sk_max_ack_backlog;

You probably also need a READ_ONCE() for sk->sk_max_ack_backlog

It is a matter of time before syzbot finds how to trigger the race.

Since you added a nice unix_recvq_full_lockless() helper, lets make it right.

Thanks.
