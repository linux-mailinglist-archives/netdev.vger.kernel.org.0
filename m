Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79715171421
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 10:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgB0J1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 04:27:25 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44648 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728635AbgB0J1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 04:27:25 -0500
Received: by mail-lj1-f196.google.com with SMTP id q8so2508416ljj.11
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 01:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=gA7jC+VtXF5ZMHzX1wtdezrvx2kx7A/gYXun71lfm2I=;
        b=X1n8gFH+Lu/uM3cNhppmiMmCQBa7cLRJcaW9F+mn4uBc0p1DoQLAUW+G4HtNjNVqGy
         cBMBAKcGuaujoTXx2r8Y/WGt19ndnzsmnwT4XAnGruWdd2LPN5JJQ/i+KDswef8n0xk+
         I48GKrsVNTBBvVxxnhOWphJPtCaXGJQhq8HGM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=gA7jC+VtXF5ZMHzX1wtdezrvx2kx7A/gYXun71lfm2I=;
        b=tN1izAG/dfvWwyYpKCKjCkux+14c8HByAw5LFNCxsksz2uJAEbALaH028SdaRG0oTV
         k9NXPBfRv4NzeJ/RdgCDFPMzaqm5FMurW+KezyOQU7ytN1qf2qvFALmAjkJAk23Hf3wX
         3bY+RjSA4bLOFOACnozWKXnp/bUi7Ru4G4amTl1qz3+YAm9MGRoqtTbIhLLHazvYssx/
         NRaZoMks7heZk+voZP2vajlzIBFhTWdZ+7Ea5ihOTj2kAup2THOamCI4MAwmK7LTlZtd
         pouO2WtbjK6K8Q/k+yv1ou1XST0D6/JZLJ1FT8yGFeeIGfNT2nSZKhXTSZTWsE17yj8v
         CIMA==
X-Gm-Message-State: ANhLgQ1jHZAUG+d92RxiIIrGkgpE6P+6MTAGoC3t8yY1WDtSbbIxyXXt
        Lb8w8VzW7Zc8lJ8uXgKCLQamqg==
X-Google-Smtp-Source: ADFU+vtwwclvy2P5yg7STJ4PpLHz/6SYqS+c1a3bcwo7Te/XJa7bhCMQh9DhKMR2gDZFVsjJyplf5A==
X-Received: by 2002:a2e:e12:: with SMTP id 18mr2266298ljo.123.1582795643499;
        Thu, 27 Feb 2020 01:27:23 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q10sm2801993ljj.60.2020.02.27.01.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 01:27:22 -0800 (PST)
References: <20200225135636.5768-1-lmb@cloudflare.com> <20200225135636.5768-4-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com
Subject: Re: [PATCH bpf-next 3/7] skmsg: introduce sk_psock_hooks
In-reply-to: <20200225135636.5768-4-lmb@cloudflare.com>
Date:   Thu, 27 Feb 2020 10:27:22 +0100
Message-ID: <87a754crd1.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 25, 2020 at 02:56 PM CET, Lorenz Bauer wrote:
> The sockmap works by overriding some of the callbacks in sk->sk_prot, while
> leaving others untouched. This means that we need access to the struct proto
> for any protocol we want to support. For IPv4 this is trivial, since both
> TCP and UDP are always compiled in. IPv6 may be disabled or compiled as a
> module, so the existing TCP sockmap hooks use some trickery to lazily
> initialize the modified struct proto for TCPv6.
>
> Pull this logic into a standalone struct sk_psock_hooks, so that it can be
> re-used by UDP sockmap.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---
>  include/linux/skmsg.h |  36 ++++++++-----
>  include/net/tcp.h     |   1 -
>  net/core/skmsg.c      |  52 +++++++++++++++++++
>  net/core/sock_map.c   |  24 ++++-----
>  net/ipv4/tcp_bpf.c    | 114 ++++++++++++------------------------------
>  5 files changed, 116 insertions(+), 111 deletions(-)
>

[...]

> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 90955c96a9a8..81c0431a8dbd 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c

[...]

> @@ -650,9 +599,10 @@ int tcp_bpf_init(struct sock *sk)
>   */
>  void tcp_bpf_clone(const struct sock *sk, struct sock *newsk)
>  {
> -	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
> -	struct proto *prot = newsk->sk_prot;
> +	struct proto *prot = READ_ONCE(sk->sk_prot);

For the sake of keeping the review open - we've identified a regression
here. sk->sk_prot can change by the time we get here, since the moment
we copied the listener sock. We need to stick to checking newsk->sk_prot
here.

>
> -	if (prot == &tcp_bpf_prots[family][TCP_BPF_BASE])
> +	/* TCP_LISTEN can only use TCP_BPF_BASE, so this is safe */
> +	if (unlikely(prot == &tcp_bpf_ipv4[TCP_BPF_BASE] ||
> +	             prot == &tcp_bpf_ipv6[TCP_BPF_BASE]))
>  		newsk->sk_prot = sk->sk_prot_creator;
>  }
