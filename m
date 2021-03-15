Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10B5F33B00B
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 11:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhCOKeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 06:34:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhCOKdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 06:33:47 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FFFC061574
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 03:33:47 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id l12so8396947wry.2
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 03:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wZW1q+cuVKnjhrwk1RsMFijU7ZVuxkftesyYfz6bto0=;
        b=tLJj0zVsjtws5RJn+9Z3O13cVXPoxH+2j7BKH3hiqT+2yxsYvT7aHu21euGjWpt9w/
         0yML4872siKy5Fn0bvmsYkrd3X79+maKaEHINZph83+5UgsKerHO+uOuGAP6W1it2sIv
         DtzdlQh+kSYZImwITudw0nFQ9Tq0bEXmOEb/waelw2TCDhgwEtCZ/RWwENxEhrZzytru
         Pzb0FYTAbe1d5A7z9NE33iwcM+1+F4DLqELhJLVPfrtbXhNu+ssq8xWqS6AbRO62xHrX
         cFyzXqyYejfklzbQUtgo9jJYB5p3UCrkuM57eM1dYfQ3fAytBeor+fzcJyQLEDSmBhag
         sYiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wZW1q+cuVKnjhrwk1RsMFijU7ZVuxkftesyYfz6bto0=;
        b=UtrPeCVhQRBg8S9uyGa6q7XkqQqvJ+2e1qvh7RaWqTQx2qXUwMUERoIQaj8G4e18Kj
         gd/KtTa6keVyHh+Z86wcamXiLnHM78UVaLBopUqwp3PIy4W1bzRoUG7pFKLIKZEvMG5f
         6Lla2ZYOGBTtBHDJ13xAAWNvyYxef+0dDiNh/a0AucOfycgiZwefYUPO6FqFVyOciZEe
         +4nV/aDivyFRVWMr9AX5HP7b31tfcumBXmBwkeYIOizDoRJbqjHv65ab1bz6OEZLM9OS
         RoFhbLnXNrkU+P2cVTBsWN86S4gE1FtXRREKPp1KXfwz5p1lMXwMrzU+pPOVCSf1OQ9b
         WCUQ==
X-Gm-Message-State: AOAM531z4eE+wuZUQTZJSqLAj18SIftgZZ1ZU+JV+GmQjL0rQCzmL/nq
        8dmP3IjJKJoLLj1GflHpkHE=
X-Google-Smtp-Source: ABdhPJzmI2JHEKAokfe7IcDKROcLvtD6PKvw1lR4SMziLOJSWk/juyst8lSLx38303/8bKR8qqpCxg==
X-Received: by 2002:a5d:4903:: with SMTP id x3mr26667937wrq.143.1615804425786;
        Mon, 15 Mar 2021 03:33:45 -0700 (PDT)
Received: from [192.168.1.101] ([37.168.70.72])
        by smtp.gmail.com with ESMTPSA id h22sm14069773wmb.36.2021.03.15.03.33.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 03:33:45 -0700 (PDT)
Subject: Re: [PATCH] tcp: relookup sock for RST+ACK packets handled by
 obsolete req sock
To:     Alexander Ovechkin <ovov@yandex-team.ru>, netdev@vger.kernel.org
Cc:     zeil@yandex-team.ru, dmtrmonakhov@yandex-team.ru
References: <20210311230756.971993-1-ovov@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7c6d50ad-e09e-fb86-3ee4-c84b76d63417@gmail.com>
Date:   Mon, 15 Mar 2021 11:33:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210311230756.971993-1-ovov@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/12/21 12:07 AM, Alexander Ovechkin wrote:
> Currently tcp_check_req can be called with obsolete req socket for which big
> socket have been already created (because of CPU race or early demux
> assigning req socket to multiple packets in gro batch).
> 
> Commit e0f9759f530bf789e984 (\"tcp: try to keep packet if SYN_RCV race
> is lost\") added retry in case when tcp_check_req is called for PSH|ACK packet.
> But if client sends RST+ACK immediatly after connection being
> established (it is performing healthcheck, for example) retry does not
> occur. In that case tcp_check_req tries to close req socket,
> leaving big socket active.
> 

Please insert the following tag, right before your SOB
Fixes: e0f9759f530 ("tcp: try to keep packet if SYN_RCV race is lost")
> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
> Reported-by: Oleg Senin <olegsenin@yandex-team.ru>

Please CC TCP maintainer for your TCP patches, I almost missed it.


> ---
>  include/net/inet_connection_sock.h | 2 +-
>  net/ipv4/inet_connection_sock.c    | 6 ++++--
>  net/ipv4/tcp_minisocks.c           | 6 ++++--
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 10a625760de9..3c8c59471bc1 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -282,7 +282,7 @@ static inline int inet_csk_reqsk_queue_is_full(const struct sock *sk)
>  	return inet_csk_reqsk_queue_len(sk) >= sk->sk_max_ack_backlog;
>  }
>  
> -void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
> +bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req);
>  void inet_csk_reqsk_queue_drop_and_put(struct sock *sk, struct request_sock *req);
>  
>  static inline void inet_csk_prepare_for_destroy_sock(struct sock *sk)
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 6bd7ca09af03..08ca9de2a708 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -705,12 +705,14 @@ static bool reqsk_queue_unlink(struct request_sock *req)
>  	return found;
>  }
>  
> -void inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
> +bool inet_csk_reqsk_queue_drop(struct sock *sk, struct request_sock *req)
>  {
> -	if (reqsk_queue_unlink(req)) {
> +	bool unlinked = reqsk_queue_unlink(req);

Add an empty line.

> +	if (unlinked) {
>  		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
>  		reqsk_put(req);
>  	}
> +	return unlinked;
>  }
>  EXPORT_SYMBOL(inet_csk_reqsk_queue_drop);
>  
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 0055ae0a3bf8..31ed3423503d 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -804,8 +804,10 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
>  		tcp_reset(sk, skb);
>  	}
>  	if (!fastopen) {
> -		inet_csk_reqsk_queue_drop(sk, req);
> -		__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
> +		bool unlinked = inet_csk_reqsk_queue_drop(sk, req);

Same here.

> +		if (unlinked)
> +			__NET_INC_STATS(sock_net(sk), LINUX_MIB_EMBRYONICRSTS);
> +		*req_stolen = !unlinked;
>  	}
>  	return NULL;
>  }
> 

Other than that, your patch looks fine to me, thanks.
