Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AB42CA715
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 16:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgLAPay (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 10:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726402AbgLAPay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 10:30:54 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1238C0613CF;
        Tue,  1 Dec 2020 07:30:13 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id k10so3764875wmi.3;
        Tue, 01 Dec 2020 07:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zya8zNGwc0JOgR3BNhTJLeqnKysXmnYYm6ovJAlSB1I=;
        b=ePgxNCrjTOyRbDbE41NFEEBc18d3NhIYODNwu9pgHGtpC9foa7XCVxaV8lHmyfpeoO
         mtcGqUvLHQFZGjs/yhp9D1w/AL2VFPDDnj/qoC86tCxHxI+MLQV6eN+EiLj/sHwvMnr7
         RvCuxOa757jHFO8bysZApk0OLYdvhMuHaQb2pMPZuL2T5rruRCLqmPD99T6MLn1jFFgp
         dthFvEvhZU4W0mtNDem6ho/bukr/9qS7zt5arB7AlHohYqGgL6suO6OfLml5/FWQ832/
         bhun/8BaYBoK0wtP0lBGwntyRXVvCnImyKK+rYBs/ae0zfRyZOHqS+AlVz1OidzMmAyv
         FOgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zya8zNGwc0JOgR3BNhTJLeqnKysXmnYYm6ovJAlSB1I=;
        b=VU4Nh5T4aRkKK1/IraYmzo8yQ2KZSfRSXAsQDMSjiMN6EJG1sckjSdCTbr3asI18GB
         W+q01rb+zQ0TwL+r4hM4xF1tqsMC2vHn93aBZOs3+ui9z/Ojdj4wRELZOn02gEIEpG0z
         Q1vxL55XvYO51ItScyYjtVUZ1iup8CuH7EVYkmNFWIoMLaTesb5NqFBTPsffHf5gTqIR
         y6Fqu00i7ZZfJ+GXAwLclnfG7w+2AkqpBUQOQ1TzfqG1qnSOt2lGePJKtl621RUQWjC7
         bD78QT2EOBbzUxCRja0NuASzNMNG5edzT3AnY5BqCclkwFIY2FGNUy9+PXDoU4BFg+tL
         yk8w==
X-Gm-Message-State: AOAM532DNnDcqoWnOPYVG/bMs0ndLV/Sb16cawrqNwBKuTgayCVtabgL
        x5CkU3ZN7QIB9Kq1GFvK+6xaUEzgiPE=
X-Google-Smtp-Source: ABdhPJy3Da9v6esC6liiN7iilFLmDfN5EqOJHZeF4OMfzIlkI031R53Xyz/8yOawvikH/JC/653mog==
X-Received: by 2002:a1c:4604:: with SMTP id t4mr3164924wma.17.1606836611903;
        Tue, 01 Dec 2020 07:30:11 -0800 (PST)
Received: from [192.168.8.116] ([37.165.175.127])
        by smtp.gmail.com with ESMTPSA id x4sm4084522wrv.81.2020.12.01.07.30.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Dec 2020 07:30:11 -0800 (PST)
Subject: Re: [PATCH v1 bpf-next 04/11] tcp: Migrate TFO requests causing RST
 during TCP_SYN_RECV.
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
 <20201201144418.35045-5-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9d290a57-49e1-04cd-2487-262b0d7c5844@gmail.com>
Date:   Tue, 1 Dec 2020 16:30:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201201144418.35045-5-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/1/20 3:44 PM, Kuniyuki Iwashima wrote:
> A TFO request socket is only freed after BOTH 3WHS has completed (or
> aborted) and the child socket has been accepted (or its listener has been
> closed). Hence, depending on the order, there can be two kinds of request
> sockets in the accept queue.
> 
>   3WHS -> accept : TCP_ESTABLISHED
>   accept -> 3WHS : TCP_SYN_RECV
> 
> Unlike TCP_ESTABLISHED socket, accept() does not free the request socket
> for TCP_SYN_RECV socket. It is freed later at reqsk_fastopen_remove().
> Also, it accesses request_sock.rsk_listener. So, in order to complete TFO
> socket migration, we have to set the current listener to it at accept()
> before reqsk_fastopen_remove().
> 
> Moreover, if TFO request caused RST before 3WHS has completed, it is held
> in the listener's TFO queue to prevent DDoS attack. Thus, we also have to
> migrate the requests in TFO queue.
> 
> Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> ---
>  net/ipv4/inet_connection_sock.c | 35 ++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index b27241ea96bd..361efe55b1ad 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -500,6 +500,16 @@ struct sock *inet_csk_accept(struct sock *sk, int flags, int *err, bool kern)
>  	    tcp_rsk(req)->tfo_listener) {
>  		spin_lock_bh(&queue->fastopenq.lock);
>  		if (tcp_rsk(req)->tfo_listener) {
> +			if (req->rsk_listener != sk) {
> +				/* TFO request was migrated to another listener so
> +				 * the new listener must be used in reqsk_fastopen_remove()
> +				 * to hold requests which cause RST.
> +				 */
> +				sock_put(req->rsk_listener);
> +				sock_hold(sk);
> +				req->rsk_listener = sk;
> +			}
> +
>  			/* We are still waiting for the final ACK from 3WHS
>  			 * so can't free req now. Instead, we set req->sk to
>  			 * NULL to signify that the child socket is taken
> @@ -954,7 +964,6 @@ static void inet_child_forget(struct sock *sk, struct request_sock *req,
>  
>  	if (sk->sk_protocol == IPPROTO_TCP && tcp_rsk(req)->tfo_listener) {
>  		BUG_ON(rcu_access_pointer(tcp_sk(child)->fastopen_rsk) != req);
> -		BUG_ON(sk != req->rsk_listener);

>  
>  		/* Paranoid, to prevent race condition if
>  		 * an inbound pkt destined for child is
> @@ -995,6 +1004,7 @@ EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
>  void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
>  {
>  	struct request_sock_queue *old_accept_queue, *new_accept_queue;
> +	struct fastopen_queue *old_fastopenq, *new_fastopenq;
>  
>  	old_accept_queue = &inet_csk(sk)->icsk_accept_queue;
>  	new_accept_queue = &inet_csk(nsk)->icsk_accept_queue;
> @@ -1019,6 +1029,29 @@ void inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk)
>  
>  	spin_unlock(&new_accept_queue->rskq_lock);
>  	spin_unlock(&old_accept_queue->rskq_lock);
> +
> +	old_fastopenq = &old_accept_queue->fastopenq;
> +	new_fastopenq = &new_accept_queue->fastopenq;
> +
> +	spin_lock_bh(&old_fastopenq->lock);
> +	spin_lock_bh(&new_fastopenq->lock);


Same remark about lockdep being not happy with this (I guess)

> +
> +	new_fastopenq->qlen += old_fastopenq->qlen;
> +	old_fastopenq->qlen = 0;
> +
> +	if (old_fastopenq->rskq_rst_head) {
> +		if (new_fastopenq->rskq_rst_head)
> +			old_fastopenq->rskq_rst_tail->dl_next = new_fastopenq->rskq_rst_head;
> +		else
> +			old_fastopenq->rskq_rst_tail = new_fastopenq->rskq_rst_tail;
> +
> +		new_fastopenq->rskq_rst_head = old_fastopenq->rskq_rst_head;
> +		old_fastopenq->rskq_rst_head = NULL;
> +		old_fastopenq->rskq_rst_tail = NULL;
> +	}
> +
> +	spin_unlock_bh(&new_fastopenq->lock);
> +	spin_unlock_bh(&old_fastopenq->lock);
>  }
>  EXPORT_SYMBOL(inet_csk_reqsk_queue_migrate);
>  
> 
