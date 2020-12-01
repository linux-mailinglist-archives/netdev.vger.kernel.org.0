Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B6E2CA6BE
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 16:14:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391751AbgLAPOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 10:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391675AbgLAPOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 10:14:30 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E4AC0613CF;
        Tue,  1 Dec 2020 07:13:43 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id 3so5839240wmg.4;
        Tue, 01 Dec 2020 07:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tlhIYoIq9e3CaEPaXdMjL7drXTusDUU9rzK4hAthGZ0=;
        b=cyP4KlWpFNGCcb0/elouH0+cdYKwDMbUoRTZRROjot83CUc0Qw6t4is1RAGHb2jO/C
         ldT0w1qqy7nQuu4D0YRvJgUQdRcdCSim9t9+Du6EFo9SozWyGExfmCqIBeOAaxXYAhwt
         +ykQF358mEGMfCml/NR8oYqTIVT3zk9HLFcukSLHf9qzzskuA8SvNqk2d1iDWiw57IEe
         ETps2UWTvNQExjqHMZUNBTYAAELSuuKNtLucp0HxF11Q5lsmwZa/dIEI68+OwORLycrj
         Up37B+3gkTzNylT20KpbJHQo/obZ/VBhU/m1kPmqNflOuHRL2l0IiFlKDOcXj9TNCch6
         5lCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tlhIYoIq9e3CaEPaXdMjL7drXTusDUU9rzK4hAthGZ0=;
        b=F7psFLotJ7USXe8wzHq9yWPDud8veRTaDzgj7vkrqeHFfanFD1oS8OayXBoz/QaT1L
         PqFWGVX8o7JHF9hDLP0x0kqyy0TLAiyxMmnNUyOzY7vZ5Qx0QDYYqPpUJ9f0iBfpXTzz
         XqugSO7zhfu2Fa8EDZTpVsxPcgmmL1ApMUwBmyUKycgv/UTvfujZHrbZYDAB7uPAALl4
         8Opd3rPBZXri+7MfgdSyUfvQt8HJLC6+uwi+kRvFTV+hLkcT2444ZGNhUD71W6K8fQ4N
         gsXLLg8RDce9ZjXKWUwhom4OKpMwrueF00Jq6ZwyKw07pnUSSmVutCo8jbtmFp/XxOnS
         yMYA==
X-Gm-Message-State: AOAM532JC6lfSvWfbn95Fz+o4vsy8McYltfl2pa+b90UR9dNODApay0c
        Bv86A3rxg4nJuimv00W+SetTlG/RGTM=
X-Google-Smtp-Source: ABdhPJxVZacII63n6CKeMEZxzuIpwNpMB2NqST95mdNmS5GWshD7PxuwqBJOIAwPTEoiTtwGYRqSGQ==
X-Received: by 2002:a7b:c8da:: with SMTP id f26mr3186808wml.50.1606835622180;
        Tue, 01 Dec 2020 07:13:42 -0800 (PST)
Received: from [192.168.8.116] ([37.165.175.127])
        by smtp.gmail.com with ESMTPSA id n14sm3897039wrx.79.2020.12.01.07.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 07:13:41 -0800 (PST)
Subject: Re: [PATCH v1 bpf-next 05/11] tcp: Migrate TCP_NEW_SYN_RECV requests.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        osa-contribution-log@amazon.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
 <20201201144418.35045-6-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6b34c251-05af-06c0-8003-858b6ae8d1fd@gmail.com>
Date:   Tue, 1 Dec 2020 16:13:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201201144418.35045-6-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/1/20 3:44 PM, Kuniyuki Iwashima wrote:
> This patch renames reuseport_select_sock() to __reuseport_select_sock() and
> adds two wrapper function of it to pass the migration type defined in the
> previous commit.
> 
>   reuseport_select_sock          : BPF_SK_REUSEPORT_MIGRATE_NO
>   reuseport_select_migrated_sock : BPF_SK_REUSEPORT_MIGRATE_REQUEST
> 
> As mentioned before, we have to select a new listener for TCP_NEW_SYN_RECV
> requests at receiving the final ACK or sending a SYN+ACK. Therefore, this
> patch also changes the code to call reuseport_select_migrated_sock() even
> if the listening socket is TCP_CLOSE. If we can pick out a listening socket
> from the reuseport group, we rewrite request_sock.rsk_listener and resume
> processing the request.
> 
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  include/net/inet_connection_sock.h | 12 +++++++++++
>  include/net/request_sock.h         | 13 ++++++++++++
>  include/net/sock_reuseport.h       |  8 +++----
>  net/core/sock_reuseport.c          | 34 ++++++++++++++++++++++++------
>  net/ipv4/inet_connection_sock.c    | 13 ++++++++++--
>  net/ipv4/tcp_ipv4.c                |  9 ++++++--
>  net/ipv6/tcp_ipv6.c                |  9 ++++++--
>  7 files changed, 81 insertions(+), 17 deletions(-)
> 
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 2ea2d743f8fc..1e0958f5eb21 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -272,6 +272,18 @@ static inline void inet_csk_reqsk_queue_added(struct sock *sk)
>  	reqsk_queue_added(&inet_csk(sk)->icsk_accept_queue);
>  }
>  
> +static inline void inet_csk_reqsk_queue_migrated(struct sock *sk,
> +						 struct sock *nsk,
> +						 struct request_sock *req)
> +{
> +	reqsk_queue_migrated(&inet_csk(sk)->icsk_accept_queue,
> +			     &inet_csk(nsk)->icsk_accept_queue,
> +			     req);
> +	sock_put(sk);
> +	sock_hold(nsk);

This looks racy to me. nsk refcount might be zero at this point.

If you think it can _not_ be zero, please add a big comment here,
because this would mean something has been done before reaching this function,
and this sock_hold() would be not needed in the first place.

There is a good reason reqsk_alloc() is using refcount_inc_not_zero().

> +	req->rsk_listener = nsk;
> +}
> +

Honestly, this patch series looks quite complex, and finding a bug in the
very first function I am looking at is not really a good sign...



