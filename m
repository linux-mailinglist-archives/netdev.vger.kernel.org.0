Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9D61F7693
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 12:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgFLKPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 06:15:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbgFLKPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 06:15:37 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76160C08C5C2
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 03:15:36 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id n23so10417836ljh.7
        for <netdev@vger.kernel.org>; Fri, 12 Jun 2020 03:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/gbHlr0KqPDkStZANGWcajnn6OdrqVI8OcC2DaXaFRY=;
        b=b9KwvlW4LejDyrkRYv5SvjtOE6OMNofyEWm9A7xUh1tcYnGbI0lRXrPHJQSjFa/zXC
         06OdNtxbEmQS6HkUgkxADSsmxgI0buOOKVSZb6+n8z43YEcJ6nBbnhyRCkAokVq7ha/i
         Afjz5FYNc1SGY1zJXPJhIs5GxkJQtz774QDLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/gbHlr0KqPDkStZANGWcajnn6OdrqVI8OcC2DaXaFRY=;
        b=gczRJnH7wOX3LhNaMjMAi6Ng39KJwDv/F51Xq769fRvSa47M0kYQp5gBbXAQgG/jj+
         Kz0GbL5Z+SzbIuDXMT2xJ0ve5R1/p7rAuCcFYqQDGpMkLjM1nxO/86fLlQxBF/JtXOAt
         ha89imyy3w1DeGo02QDvlUZAwRsWE9bzVw8YRipPylfSZwE+DqMDp4Flvl6X8CMVUzxB
         jm9zKOO2/vnuGebqwY7DInLF5oWRnt8PSCi6n/cvIFJ/jDay8+uRMrFLzMnL2XIfZ2Ha
         t9ang3uoxgkpiaKUdbObv/Mal0vrzlG9lBag2mmEVlzh/OAfkvYG/lxzWWDWkSCZFMKO
         k3Ug==
X-Gm-Message-State: AOAM533rNC7Strl3E9KqSInmF/18V3gHS0nr3G5GE7fcw7hrfH5Bgn36
        vfJkGxP0px8KfO0+GrUdUPFSHNhIbf0=
X-Google-Smtp-Source: ABdhPJwBFZTgyd1+YZ2YR2Zp9TGIIZadEUbsi3pQARgJGt4sMdi7U4PqKKM6y5drMqNORdkgBwb4cA==
X-Received: by 2002:a2e:5c2:: with SMTP id 185mr6083410ljf.260.1591956934738;
        Fri, 12 Jun 2020 03:15:34 -0700 (PDT)
Received: from toad ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id t7sm1659609lfq.64.2020.06.12.03.15.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2020 03:15:34 -0700 (PDT)
Date:   Fri, 12 Jun 2020 12:15:26 +0200
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [PATCH bpf] bpf: tcp: recv() should return 0 when the peer
 socket is closed
Message-ID: <20200612121526.4810a073@toad>
In-Reply-To: <26038a28c21fea5d04d4bd4744c5686d3f2e5504.1591784177.git.sd@queasysnail.net>
References: <26038a28c21fea5d04d4bd4744c5686d3f2e5504.1591784177.git.sd@queasysnail.net>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Jun 2020 12:19:43 +0200
Sabrina Dubroca <sd@queasysnail.net> wrote:

> If the peer is closed, we will never get more data, so
> tcp_bpf_wait_data will get stuck forever. In case we passed
> MSG_DONTWAIT to recv(), we get EAGAIN but we should actually get
> 0.
> 
> From man 2 recv:
> 
>     RETURN VALUE
> 
>     When a stream socket peer has performed an orderly shutdown, the
>     return value will be 0 (the traditional "end-of-file" return).
> 
> This patch makes tcp_bpf_wait_data always return 1 when the peer
> socket has been shutdown. Either we have data available, and it would
> have returned 1 anyway, or there isn't, in which case we'll call
> tcp_recvmsg which does the right thing in this situation.
> 
> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
> ---
>  net/ipv4/tcp_bpf.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 2b915aafda42..7aa68f4aae6c 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -245,6 +245,9 @@ static int tcp_bpf_wait_data(struct sock *sk, struct sk_psock *psock,
>  	DEFINE_WAIT_FUNC(wait, woken_wake_function);
>  	int ret = 0;
>  
> +	if (sk->sk_shutdown & RCV_SHUTDOWN)
> +		return 1;
> +
>  	if (!timeo)
>  		return ret;
>  

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
