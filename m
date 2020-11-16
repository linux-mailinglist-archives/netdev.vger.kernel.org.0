Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1859E2B45E6
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730200AbgKPObg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730196AbgKPObg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 09:31:36 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3D2C0613D1
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 06:31:35 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id h2so23942574wmm.0
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 06:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=qMjDR0Ym+nhpvOJ6zJJnl+LYMN6YDDREpuIxO7AtctE=;
        b=maIsAJsZ9C5ds72BdFMn8SZrZag4sqWfO/sawEbHeTLRHGOCxsrX7qrwfnuNG1YA1j
         QZtGTqZB+Or9el/yGKjjvrccoBtEOZOyFIj2uWR0DabDfm6HTvCTdRnSue5wP33Spa0P
         i9O51hwM6xuwY4SCPNtQ+frLZ/lUKwXYB+8XA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=qMjDR0Ym+nhpvOJ6zJJnl+LYMN6YDDREpuIxO7AtctE=;
        b=g03vqHdtZ9hJ8+enAYPpTLX+i05FrZmVX7+leie++ds1AYEKDVVk3IrUFuQLB5H0z5
         RJnOeO3n8m1N+RtcaupVZu161CQFKBz/9FySoEeStZvq+0SGv9fy4ugDkv0gs4IFdMev
         JyT8qvFUW3MulOBQHp/jm+uLFU3bNRjUbeaPT1ewBZ2HejsJ1rZgSwnLYuvYKOb1ZgAa
         bEM1sZnjnNciFVfED+jvSW3gXAA1lHoSv0Zc2Iha4I232sP30CCXCy/+TwQtGsZMaKSK
         a3IP8ZiOaMYiWGw0d7VZFaBxhnYBLHrZX2PfOVmYyDEuZdhCKX28EFj9NEDL69EV1T58
         23AA==
X-Gm-Message-State: AOAM5326Ls9snnFdl8k7IaZFJrLwWdJH+EdPtOFMl+jsyCAUVcG/svPk
        uXl7UAvm7CukLt+9W4M3jP1Gbg==
X-Google-Smtp-Source: ABdhPJwH2qVsIs/Q09LWrmiCrFI7JYrstrUAmtDXK2/+Vjjo5XitU8+h0y5abnzV1eFvxC7rtTQtig==
X-Received: by 2002:a7b:c845:: with SMTP id c5mr15528327wml.135.1605537094497;
        Mon, 16 Nov 2020 06:31:34 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u16sm22809008wrn.55.2020.11.16.06.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 06:31:33 -0800 (PST)
References: <160522352433.135009.15329422887113794062.stgit@john-XPS-13-9370> <160522367856.135009.17304729578208922913.stgit@john-XPS-13-9370>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [bpf PATCH v2 5/6] bpf, sockmap: Handle memory acct if skb_verdict prog redirects to self
In-reply-to: <160522367856.135009.17304729578208922913.stgit@john-XPS-13-9370>
Date:   Mon, 16 Nov 2020 15:31:32 +0100
Message-ID: <87blfxweyj.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 12:27 AM CET, John Fastabend wrote:
> If the skb_verdict_prog redirects an skb knowingly to itself, fix your
> BPF program this is not optimal and an abuse of the API please use
> SK_PASS. That said there may be cases, such as socket load balancing,
> where picking the socket is hashed based or otherwise picks the same
> socket it was received on in some rare cases. If this happens we don't
> want to confuse userspace giving them an EAGAIN error if we can avoid
> it.
>
> To avoid double accounting in these cases. At the moment even if the
> skb has already been charged against the sockets rcvbuf and forward
> alloc we check it again and do set_owner_r() causing it to be orphaned
> and recharged. For one this is useless work, but more importantly we
> can have a case where the skb could be put on the ingress queue, but
> because we are under memory pressure we return EAGAIN. The trouble
> here is the skb has already been accounted for so any rcvbuf checks
> include the memory associated with the packet already. This rolls
> up and can result in unecessary EAGAIN errors in userspace read()
> calls.
>
> Fix by doing an unlikely check and skipping checks if skb->sk == sk.
>
> Fixes: 51199405f9672 ("bpf: skb_verdict, support SK_PASS on RX BPF path")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  net/core/skmsg.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index 9aed5a2c7c5b..f747ee341fe8 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -404,11 +404,13 @@ static struct sk_msg *sk_psock_create_ingress_msg(struct sock *sk,
>  {
>  	struct sk_msg *msg;
>  
> -	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
> -		return NULL;
> +	if (likely(skb->sk != sk)) {
> +		if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf)
> +			return NULL;
>  
> -	if (!sk_rmem_schedule(sk, skb, skb->truesize))
> -		return NULL;
> +		if (!sk_rmem_schedule(sk, skb, skb->truesize))
> +			return NULL;
> +	}
>  
>  	msg = kzalloc(sizeof(*msg), __GFP_NOWARN | GFP_ATOMIC);
>  	if (unlikely(!msg))
> @@ -455,9 +457,12 @@ static int sk_psock_skb_ingress(struct sk_psock *psock, struct sk_buff *skb)
>  	 * the BPF program was run initiating the redirect to the socket
>  	 * we will eventually receive this data on. The data will be released
>  	 * from skb_consume found in __tcp_bpf_recvmsg() after its been copied
> -	 * into user buffers.
> +	 * into user buffers. If we are receiving on the same sock skb->sk is
> +	 * already assigned, skip memory accounting and owner transition seeing
> +	 * it already set correctly.
>  	 */
> -	skb_set_owner_r(skb, sk);
> +	if (likely(skb->sk != sk))
> +		skb_set_owner_r(skb, sk);
>  	return sk_psock_skb_ingress_enqueue(skb, psock, sk, msg);
>  }
>  

I think all the added checks boil down to having:

	struct sock *sk = psock->sk;

        if (unlikely(skb->sk == sk))
                return sk_psock_skb_ingress_self(psock, skb);

... on entry to sk_psock_skb_ingress().
