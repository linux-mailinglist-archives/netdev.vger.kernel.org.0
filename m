Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EB1439C1E
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 18:54:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbhJYQ4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 12:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbhJYQ4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 12:56:37 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2238FC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:54:15 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r28so7199495pga.0
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 09:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TFVsAN1+ttICAzT7l1hD+fIyIN511K1vHJ0qijTXspk=;
        b=Y10fMWoGuvJ06WpfiSGnfPJYoCsA3k5jmFjw2ZU7vuxd0c6YrKzikAfTdZ0fwTdY8w
         Rxp+ETv8rMHIbC0duiLbLQUPu7h+QBrV5GgX9muZ3kL1cYV5n5DI6wgKPwWs20DMraGJ
         +DmgB53LLJnH9hJBnn7shbIoZFkF9RTnNeTzmUnKq0xa7qCxzP0gxeT86k3MdblEehfi
         ZnhQLaLnwT9pcMuLQH9899uzEWoIfTE59ijt9rOlF24KMOMXBFs3h68/Y5HuP++Vl5II
         TFS+xRN02HZeyuLdYkFzJFfNogZG3nlW74HMWyGI51ktOqyJFChNFhtK5sfQp6NqFmhu
         gG1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TFVsAN1+ttICAzT7l1hD+fIyIN511K1vHJ0qijTXspk=;
        b=ys2B+vTEqq79pBL8/N7PQyElwnll261uRwmRHs9iqKgSfS0z0zFW6Tynig0Hpgng9F
         TIUSrDC3h+On4404GHWiulVBGHtAl2b1H6fZp5rc4qrVGS5k2ogVc6cWjyPfDAHmaDXC
         IjqavrGujeQA7THTagj7NyOrQ6Tc1heiNrMWiIW2yAKwzl6bUYIGvNM7OAZe4I15VHWP
         GefOsEVrbsauPjTT6GsTu9lLAMhLUzQSh/6LpKhJCPQElZEbbVtAz2GgJJmUjDUm2ZuI
         HU90FGSulXDWET6dg06U64q1A/ddtAFde3XbqeZGRo1cG1PQ22l5Uc9Vifw6nE/hvngv
         4e8Q==
X-Gm-Message-State: AOAM531EF2XXir4n+Nm5hnTYgv5k4MD0k6FgfFprL2mLApwU+zErxYOL
        u7l0KcFnAf4hUm++BmZgEuei47U4lqU=
X-Google-Smtp-Source: ABdhPJyXVJctjSaCMdqXwvovUicD46xWvz23872x+JWf2hpFB2NcMQVqejdUMoVGXSQZd1CbJxIJZg==
X-Received: by 2002:a63:36cb:: with SMTP id d194mr14386131pga.401.1635180854640;
        Mon, 25 Oct 2021 09:54:14 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:9cf1:268c:881a:90c3? ([2620:15c:2c1:200:9cf1:268c:881a:90c3])
        by smtp.gmail.com with ESMTPSA id i7sm11571700pgk.85.2021.10.25.09.54.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 09:54:14 -0700 (PDT)
Subject: Re: [PATCH] tcp: Use BPF timeout setting for SYN ACK RTO
To:     Akhmat Karakotov <hmukos@yandex-team.ru>, netdev@vger.kernel.org,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Lawrence Brakmo <brakmo@fb.com>
Cc:     mitradir@yandex-team.ru, zeil@yandex-team.ru, brakmo@fb.com
References: <20211025121253.8643-1-hmukos@yandex-team.ru>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b8700d59-d533-71ee-f8c3-b7f0906debc5@gmail.com>
Date:   Mon, 25 Oct 2021 09:54:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211025121253.8643-1-hmukos@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/25/21 5:12 AM, Akhmat Karakotov wrote:
> When setting RTO through BPF program, SYN ACK packets were unaffected and
> continued to use TCP_TIMEOUT_INIT constant. This patch makes SYN ACK
> retransmits use tcp_timeout_init() function instead.
> 

I do not think we want this, this will break existing BPF programs
that did not expect this risky change of behavior.

Please next time you send controversial TCP patches, add TCP experts/maintainers
in CC.

> Signed-off-by: Akhmat Karakotov <hmukos@yandex-team.ru>
> ---
>  net/ipv4/inet_connection_sock.c | 2 +-
>  net/ipv4/tcp_minisocks.c        | 4 ++--
>  net/ipv4/tcp_timer.c            | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 0d477c816309..41663d1ffd0a 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -870,7 +870,7 @@ static void reqsk_timer_handler(struct timer_list *t)
>  
>  		if (req->num_timeout++ == 0)
>  			atomic_dec(&queue->young);
> -		timeo = min(TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
> +		timeo = min(tcp_timeout_init((struct sock *)req) << req->num_timeout, TCP_RTO_MAX);
>  		mod_timer(&req->rsk_timer, jiffies + timeo);
>  
>  		if (!nreq)
> diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
> index 0a4f3f16140a..8ddc3aa9e3a6 100644
> --- a/net/ipv4/tcp_minisocks.c
> +++ b/net/ipv4/tcp_minisocks.c
> @@ -590,7 +590,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
>  			 * it can be estimated (approximately)
>  			 * from another data.
>  			 */
> -			tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((TCP_TIMEOUT_INIT/HZ)<<req->num_timeout);
> +			tmp_opt.ts_recent_stamp = ktime_get_seconds() - ((tcp_timeout_init((struct sock *)req)/HZ)<<req->num_timeout);
>  			paws_reject = tcp_paws_reject(&tmp_opt, th->rst);
>  		}
>  	}
> @@ -629,7 +629,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
>  		    !inet_rtx_syn_ack(sk, req)) {
>  			unsigned long expires = jiffies;
>  
> -			expires += min(TCP_TIMEOUT_INIT << req->num_timeout,
> +			expires += min(tcp_timeout_init((struct sock *)req) << req->num_timeout,
>  				       TCP_RTO_MAX);
>  			if (!fastopen)
>  				mod_timer_pending(&req->rsk_timer, expires);
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index 20cf4a98c69d..0954e3685ad2 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -430,7 +430,7 @@ static void tcp_fastopen_synack_timer(struct sock *sk, struct request_sock *req)
>  	if (!tp->retrans_stamp)
>  		tp->retrans_stamp = tcp_time_stamp(tp);
>  	inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
> -			  TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
> +			  tcp_timeout_init((struct sock *)req) << req->num_timeout, TCP_RTO_MAX);
>  }
>  
>  
> 
