Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501F04E845C
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 22:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiCZVUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 17:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbiCZVUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 17:20:45 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C7AB2BE6
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 14:19:08 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id bt26so18798143lfb.3
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 14:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:date:in-reply-to
         :message-id:mime-version;
        bh=jYnIUq9ahQrg6tELpL/+aQc4JbkozBSCs3ZWIZ4phZM=;
        b=pQMPpQ4JJIxULXyMEc5E7rE1UQ3OGFyL58OaGINL/1zZkjDbElNpiycFtkbZUjLYh2
         kvZNC4y7enbUbhWodFLQqulrvZdQheTihLtuQLx2xVGMO5LZKkiemrHLbVIkjb9Mee9Y
         x59DpqAgJMeJngX3hqCj9NxYlAXn52Q2wsNVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject:date
         :in-reply-to:message-id:mime-version;
        bh=jYnIUq9ahQrg6tELpL/+aQc4JbkozBSCs3ZWIZ4phZM=;
        b=2R697Fv5AL/xKqpoebz173fryUpYrzjTVTApFeqo775ZUXPVSD4CDBzQBvKgbA4DIA
         IOthyFK65g3WgXAgB3fC3UtT+4fw5wnYqsojpU8rJFcdNOgkZOxsri0qZtYMX4MjWpXH
         FV8QUdot8ndEceYoBaQvCaJ7fjqQAkF7hlskXO/ISIzK3XBCTZGoSl7i6c7mci6jxKU1
         DlS0C2NU6Tk00/h9lEK+Gf/0vnLGgpMgcJoJJ7EBzuW9oKHafEPgO8Ae4+nOSzWgxhNv
         E9ylTzBjUY4h9x0A82bYWNDPaCCnE++T+5prNEPM2owf9cWoE8RTLJ1fC38RCJu5vh/J
         2FCA==
X-Gm-Message-State: AOAM530W4OLoH1vpRW1eftZFiik+o38SAhGc8lyqH6MmND2ZmRWxwwWI
        QEtZYL6P/EPdjoryq4skUdVfNg==
X-Google-Smtp-Source: ABdhPJynkaP6EdcRLvdYn8I+PUen/5TCAvu9jp/3DwJE1OvfJ2SzJ8RZ9PDcakW0f7gTcZf7177uQQ==
X-Received: by 2002:a05:6512:68b:b0:44a:6522:f998 with SMTP id t11-20020a056512068b00b0044a6522f998mr11179265lfe.650.1648329546624;
        Sat, 26 Mar 2022 14:19:06 -0700 (PDT)
Received: from cloudflare.com ([2a01:110f:4809:d800::f9c])
        by smtp.gmail.com with ESMTPSA id j11-20020a056512108b00b0044a23c1e679sm1173314lfg.18.2022.03.26.14.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 14:19:06 -0700 (PDT)
References: <20220318104222.1410625-1-wangyufen@huawei.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Wang Yufen <wangyufen@huawei.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        daniel@iogearbox.net, lmb@cloudflare.com, davem@davemloft.net,
        kafai@fb.com, dsahern@kernel.org, kuba@kernel.org,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next] bpf, sockmap: Add sk_rmem_alloc check for
 tcp_bpf_ingress()
Date:   Sat, 26 Mar 2022 21:37:18 +0100
In-reply-to: <20220318104222.1410625-1-wangyufen@huawei.com>
Message-ID: <87ee2oxvhy.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Mar 18, 2022 at 06:42 PM +08, Wang Yufen wrote:
> We use sk_msg to redirect with sock hash, like this:
>
>   skA   redirect    skB
>   Tx <----------->  Rx
>
> And construct a scenario where the packet sending speed is high, the
> packet receiving speed is slow, so the packets are stacked in the ingress
> queue on the receiving side. After a period of time, the memory is
> exhausted and the system ooms.
>
> To fix, we add sk_rmem_alloc while sk_msg queued in the ingress queue
> and subtract sk_rmem_alloc while sk_msg dequeued from the ingress queue
> and check sk_rmem_alloc at the beginning of bpf_tcp_ingress().
>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  include/linux/skmsg.h | 9 ++++++---
>  net/core/skmsg.c      | 2 ++
>  net/ipv4/tcp_bpf.c    | 6 ++++++
>  3 files changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index c5a2d6f50f25..d2cfd5fa2274 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -308,9 +308,10 @@ static inline void sk_psock_queue_msg(struct sk_psock *psock,
>  				      struct sk_msg *msg)
>  {
>  	spin_lock_bh(&psock->ingress_lock);
> -	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
> +	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED)) {
>  		list_add_tail(&msg->list, &psock->ingress_msg);
> -	else {
> +		atomic_add(msg->sg.size, &psock->sk->sk_rmem_alloc);
> +	} else {
>  		sk_msg_free(psock->sk, msg);
>  		kfree(msg);
>  	}
> @@ -323,8 +324,10 @@ static inline struct sk_msg *sk_psock_dequeue_msg(struct sk_psock *psock)
>  
>  	spin_lock_bh(&psock->ingress_lock);
>  	msg = list_first_entry_or_null(&psock->ingress_msg, struct sk_msg, list);
> -	if (msg)
> +	if (msg) {
>  		list_del(&msg->list);
> +		atomic_sub(msg->sg.size, &psock->sk->sk_rmem_alloc);
> +	}
>  	spin_unlock_bh(&psock->ingress_lock);
>  	return msg;
>  }
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index cc381165ea08..b19a3c49564f 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -445,6 +445,7 @@ int sk_msg_recvmsg(struct sock *sk, struct sk_psock *psock, struct msghdr *msg,
>  				if (!msg_rx->skb)
>  					sk_mem_uncharge(sk, copy);
>  				msg_rx->sg.size -= copy;
> +				atomic_sub(copy, &sk->sk_rmem_alloc);
>  
>  				if (!sge->length) {
>  					sk_msg_iter_var_next(i);
> @@ -754,6 +755,7 @@ static void __sk_psock_purge_ingress_msg(struct sk_psock *psock)
>  
>  	list_for_each_entry_safe(msg, tmp, &psock->ingress_msg, list) {
>  		list_del(&msg->list);
> +		atomic_sub(msg->sg.size, &psock->sk->sk_rmem_alloc);
>  		sk_msg_free(psock->sk, msg);
>  		kfree(msg);
>  	}
> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
> index 1cdcb4df0eb7..dd099875414c 100644
> --- a/net/ipv4/tcp_bpf.c
> +++ b/net/ipv4/tcp_bpf.c
> @@ -24,6 +24,12 @@ static int bpf_tcp_ingress(struct sock *sk, struct sk_psock *psock,
>  		return -ENOMEM;
>  
>  	lock_sock(sk);
> +	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf) {
> +		release_sock(sk);
> +		kfree(tmp);
> +		return -EAGAIN;
> +	}
> +
>  	tmp->sg.start = msg->sg.start;
>  	i = msg->sg.start;
>  	do {

Thanks for the patch and sorry for the delay.

I have to dig deeper to understand what you are experiencing.

1/ We can't charge rmem in sk_psock_queue_msg(). This path is shared by
redirect from sendmsg and redirect from ingress. When redirecting
psock->ingress_skb, we already charge sk_rmem_alloc in
sk_psock_skb_ingress() by transferring the skb ownership. See
sk_set_owner_r().

2/ The psock->ingress_msg build up for a slow reader should not lead to
be unbounded if memcg limits are in place. We charge
sk->sk_forward_alloc for received bytes in bpf_tcp_ingress(). I'd expect
the receiver process to get killed due to OOM, if it's running under a
dedicated cgroup. Is it the so in your case?

I'm pretty sure, though, that we have an accounting bug in
bpf_tcp_ingress(), because we are asking there for more write buffers
call - sk_wmem_schedule() - instead of read buffers
(sk_rmem_schedule()).

3/ I'm a bit surprised that you are not getting -ENOMEM from
bpf_tcp_ingress() already today, when the receive side allocates more
than what the net.ipv4.tcp_wmem hard limit is. (_wmem instead of _rmem
because of the bug I've mentioned above.) I'd expect we would be failing
in __sk_mem_raise_allocated().

Could you please check if you are not hitting the sock_exceed_buf_limit
tracepoint to confirm?

$ sudo bpftrace -lv 'tracepoint:sock:sock_exceed_buf_limit'
tracepoint:sock:sock_exceed_buf_limit
    char name[32]
    long * sysctl_mem
    long allocated
    int sysctl_rmem
    int rmem_alloc
    int sysctl_wmem
    int wmem_alloc
    int wmem_queued
    int kind

Thanks,
Jakub
