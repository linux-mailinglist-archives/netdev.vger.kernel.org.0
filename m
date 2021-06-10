Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA6B3A34F3
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhFJUjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:39:35 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:44679 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhFJUjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 16:39:35 -0400
Received: by mail-wr1-f48.google.com with SMTP id f2so3666678wri.11;
        Thu, 10 Jun 2021 13:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oh72w4rgMejUZgAEUa3Dv6nTCHIteYQxK1W67TXLoCg=;
        b=W2l/B+dZZ+JKr86Rggvtzo0t+WDdiqjim9cF9sPLy6UlaK9Qs3WBvemPQkmtOGkDb4
         hIWilqUPVgAxu0k0Eiu8jF7TPlz4FNKAc/SAcKrYicR8764mqDikyLsDqNacNXZBWyim
         SLZxZ6o7kNYxSOoML2+vh+iazp72UcLdc9SSj3x5k7Uyo/SSaITA2e/XBqULE815Bf7K
         6pVws8f41IA+t8bW9KvP1Vb37J4dk2xEsLu5PwOgj7eGR3SlSCzT2jArTNb6yBN6MNDI
         zZSbKLohsp9x9fLhqDvthuqWZcx0IGFPRToX+Cu7W/TG9ismJeW+ABwjKUwssIwsv/TC
         3xqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oh72w4rgMejUZgAEUa3Dv6nTCHIteYQxK1W67TXLoCg=;
        b=JTSnZwVOy50zWkyatU5T9RRgEkoAny4nRXkJwHjKWaDsZ/5/fHN+qVd8j9yr8irGpy
         RQ4RIb4Ig3YTTnJtBZqS4eC4NKNzXRXhpFmatap49+juQK8/PG5RguiKXLCcZlGW/qKx
         jRxt6DfqoglXpHiX60U0/+HSeIXppuOEu6COkCLqZo3u0jLE99C2mfhtVN028ZTsXN2J
         /gRdpUftxYLhwtUsOzyYz9WJ6xzfU2+KkHUy2kr4TFjZp5qX5qGmsHQOTaCaj6WtUDUO
         U76T6p/9Y/ZJwArOe7nIQiW+JWyUWIxsPcJU9SEa1m7p8jtLWdIMZCrlrmsScMjW0jKV
         7KQA==
X-Gm-Message-State: AOAM5302kq9UHzVqekIp0e5b+xAsTH1UXRE6wn9mu57iv/IOE4ks+G3C
        hGDV9Pr26GMqpy/mrElHvZHe5gMmMm0yuA==
X-Google-Smtp-Source: ABdhPJwRXWO43ebTzOT2525REo6y22ydpmDshSWjtM4sS3imkCg8xM4V2cgwOpC68JRvy5i3WnbhKw==
X-Received: by 2002:adf:e7d0:: with SMTP id e16mr294706wrn.202.1623357390717;
        Thu, 10 Jun 2021 13:36:30 -0700 (PDT)
Received: from [192.168.181.98] (228.18.23.93.rev.sfr.net. [93.23.18.228])
        by smtp.gmail.com with ESMTPSA id q5sm4842057wrm.15.2021.06.10.13.36.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Jun 2021 13:36:29 -0700 (PDT)
Subject: Re: [PATCH v7 bpf-next 07/11] tcp: Migrate TCP_NEW_SYN_RECV requests
 at receiving the final ACK.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210521182104.18273-1-kuniyu@amazon.co.jp>
 <20210521182104.18273-8-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <89c4ce38-fe2c-1d80-f814-c4b3a5e4781d@gmail.com>
Date:   Thu, 10 Jun 2021 22:36:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210521182104.18273-8-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/21 8:21 PM, Kuniyuki Iwashima wrote:
> This patch also changes the code to call reuseport_migrate_sock() and
> inet_reqsk_clone(), but unlike the other cases, we do not call
> inet_reqsk_clone() right after reuseport_migrate_sock().
> 
> Currently, in the receive path for TCP_NEW_SYN_RECV sockets, its listener
> has three kinds of refcnt:
> 
>   (A) for listener itself
>   (B) carried by reuqest_sock
>   (C) sock_hold() in tcp_v[46]_rcv()
> 
> While processing the req, (A) may disappear by close(listener). Also, (B)
> can disappear by accept(listener) once we put the req into the accept
> queue. So, we have to hold another refcnt (C) for the listener to prevent
> use-after-free.
> 
> For socket migration, we call reuseport_migrate_sock() to select a listener
> with (A) and to increment the new listener's refcnt in tcp_v[46]_rcv().
> This refcnt corresponds to (C) and is cleaned up later in tcp_v[46]_rcv().
> Thus we have to take another refcnt (B) for the newly cloned request_sock.
> 
> In inet_csk_complete_hashdance(), we hold the count (B), clone the req, and
> try to put the new req into the accept queue. By migrating req after
> winning the "own_req" race, we can avoid such a worst situation:
> 
>   CPU 1 looks up req1
>   CPU 2 looks up req1, unhashes it, then CPU 1 loses the race
>   CPU 3 looks up req2, unhashes it, then CPU 2 loses the race
>   ...
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/ipv4/inet_connection_sock.c | 34 ++++++++++++++++++++++++++++++---
>  net/ipv4/tcp_ipv4.c             | 20 +++++++++++++------
>  net/ipv4/tcp_minisocks.c        |  4 ++--
>  net/ipv6/tcp_ipv6.c             | 14 +++++++++++---
>  4 files changed, 58 insertions(+), 14 deletions(-)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index c1f068464363..b795198f919a 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -1113,12 +1113,40 @@ struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
>  					 struct request_sock *req, bool own_req)
>  {
>  	if (own_req) {
> -		inet_csk_reqsk_queue_drop(sk, req);
> -		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
> -		if (inet_csk_reqsk_queue_add(sk, req, child))
> +		inet_csk_reqsk_queue_drop(req->rsk_listener, req);
> +		reqsk_queue_removed(&inet_csk(req->rsk_listener)->icsk_accept_queue, req);
> +
> +		if (sk != req->rsk_listener) {
> +			/* another listening sk has been selected,
> +			 * migrate the req to it.
> +			 */
> +			struct request_sock *nreq;
> +
> +			/* hold a refcnt for the nreq->rsk_listener
> +			 * which is assigned in inet_reqsk_clone()
> +			 */
> +			sock_hold(sk);
> +			nreq = inet_reqsk_clone(req, sk);
> +			if (!nreq) {
> +				inet_child_forget(sk, req, child);

Don't you need a sock_put(sk) here ?

\
> +				goto child_put;
> +			}
> +
> +			refcount_set(&nreq->rsk_refcnt, 1);
> +			if (inet_csk_reqsk_queue_add(sk, nreq, child)) {
> +				reqsk_migrate_reset(req);
> +				reqsk_put(req);
> +				return child;
> +			}
> +
> +			reqsk_migrate_reset(nreq);
> +			__reqsk_free(nreq);
> +		} else if (inet_csk_reqsk_queue_add(sk, req, child)) {
>  			return child;
> +		}
> 
