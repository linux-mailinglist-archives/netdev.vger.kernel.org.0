Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A7A431287
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 10:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhJRI44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 04:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbhJRI4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 04:56:55 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CFDC061745
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 01:54:44 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 204so7666277ljf.9
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 01:54:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=fwxHCYtOiMXXRgcphb0lrlnoR0SP6t9eqPMjpVE6f6M=;
        b=kbashtIZXWPQ8oUjpqFcfdpaGw+Ny4LRvIDt6rFvzvYM1ld2Qo/xgo19D7HFrb+Wp+
         RX9hZUcldbaXrVDJNYkRXcYKBtpNt5lGFHIfpTMraEfVUTe4uevMbBhe+pYXZL9+1+Dv
         rj2ZSCAUsyLN0dOkjlH617+RkuJcE7qJNt6tM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=fwxHCYtOiMXXRgcphb0lrlnoR0SP6t9eqPMjpVE6f6M=;
        b=iJitJCxVXavl1UB/8oje3juKnlOt5/iLfF/+FUSHhs9dZnuIJ57WkkcxpzCeDhrYii
         bBV+xKZL2sHsLmM4GVL54BBiwDCvof+fkyodE8E3G9stHhVmlN0maFMHZbG6lsXy5lLG
         M0ZvNVHVoYTuxsUMv+FmOhZ0DbmQ6X2SDqgg+5U5Hry2fLhhVgds5Tyi0KLwtqtyLVt+
         Q6hqSoGB7KtmcKotDmBBIVVC63HTzwhPoHktI6jQcr0UNcY8fu3zUpDnDOrx4iD0oqdD
         AX5RHSV5qD1hvlumcR64S4zVCCppjUgm5VemlG0XKVc+fT5/G0Rtp91YDYroCbDOjZNJ
         gmzA==
X-Gm-Message-State: AOAM5306U6CswfH1Yf8RxEuO4cJRvB1GwIczM1Q1dgKx7qWiS9BI/aAA
        5i5fC3TXC4rFQg0dFV7/OxH+Qw==
X-Google-Smtp-Source: ABdhPJyfaE9g6S9kKzUHMA+eo2hQUSfisQ6L6AlLLx89D5aS0HTq+eVkAp0RRn1NvBf4rECuxX1IoQ==
X-Received: by 2002:a2e:8696:: with SMTP id l22mr22840147lji.82.1634547282240;
        Mon, 18 Oct 2021 01:54:42 -0700 (PDT)
Received: from cloudflare.com ([2a01:110f:480d:6f00:ff34:bf12:ef2:5071])
        by smtp.gmail.com with ESMTPSA id t19sm1451928lfl.30.2021.10.18.01.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 01:54:41 -0700 (PDT)
References: <20211015080142.43424-1-liujian56@huawei.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net, lmb@cloudflare.com,
        edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] bpf, sockmap: Do not read sk_receive_queue in
 tcp_bpf_recvmsg if strparser enabled
In-reply-to: <20211015080142.43424-1-liujian56@huawei.com>
Date:   Mon, 18 Oct 2021 10:54:41 +0200
Message-ID: <87v91ug1bi.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 10:01 AM CEST, Liu Jian wrote:
> If the strparser function of sk is turned on, all received data needs to
> be processed by strparser first.
>
> Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---

[...]

>  net/core/skmsg.c      | 5 +++++
>  net/ipv4/tcp_bpf.c    | 9 ++++++---
>  3 files changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 94e2a1f6e58d..25e92dff04aa 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -390,6 +390,7 @@ void sk_psock_stop(struct sk_psock *psock, bool wait);
>  int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock);
>  void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock);
>  void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock);
> +bool sk_psock_strparser_started(struct sock *sk);
>  #else
>  static inline int sk_psock_init_strp(struct sock *sk, struct sk_psock *psock)
>  {
> @@ -403,6 +404,11 @@ static inline void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
>  static inline void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
>  {
>  }
> +
> +static inline bool sk_psock_strparser_started(struct sock *sk)
> +{
> +	return false;
> +}
>  #endif
>  
>  void sk_psock_start_verdict(struct sock *sk, struct sk_psock *psock);
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index e85b7f8491b9..dd64ef854f3e 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -1105,6 +1105,11 @@ void sk_psock_start_strp(struct sock *sk, struct sk_psock *psock)
>  	sk->sk_write_space = sk_psock_write_space;
>  }
>  
> +bool sk_psock_strparser_started(struct sock *sk)
> +{
> +	return sk->sk_data_ready == sk_psock_strp_data_ready;

What if kTLS is configured on the socket? I think this check won't work then.

> +}
> +
>  void sk_psock_stop_strp(struct sock *sk, struct sk_psock *psock)
>  {
>  	if (!psock->saved_data_ready)

[...]
