Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54A43D144B
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbhGUP4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231958AbhGUP4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 11:56:13 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD26C0613CF
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:36:26 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id d2so2912003wrn.0
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 09:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=a/8wsJPBRqAulA2iRoXKuzBtfwc73W3ZHr3+SO18Ut0=;
        b=wYY6sILB8mYYkpUGomqhF2bjViMJPOcNLXhKQK9TR66cpkpaPFArdeIT5QvZXRz38N
         iS/R54a1BFDBTgqLNSN5yv47I03r8MhSqeRzgcvEC5BmgkDqr4IXPGRm6W5YhLrJjAc/
         Q6OGIxZjVeJtO0rdOb+cYc9jb5fTn9wS/gbJI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=a/8wsJPBRqAulA2iRoXKuzBtfwc73W3ZHr3+SO18Ut0=;
        b=IcrKaf2enyRa7HeDuSaJDGsloeOUkLREncCGfGrLjkUhJU6f/Y0PPf5qhs7scNmzJY
         L4WmTyju9UqlCBr7ZEm61202mxEWvE/vczrUYDwYj9MwrKQ9apBJmZ9HfhZ6Rft7+QI1
         vPGKL26YZk+pTN4pYPPFi//VMc995iMQpk8xUWEhDYN8rk4hOCQvwDAcVG/UIvtaU6Gt
         OUO2V8tvgsmXUhadKUre5plpyojRg7SCUesklL5BlHiV1ikk50gOkEqaFAjWJqs9xdLk
         PfZVhxbPdhmRFPEKOnUJ0Yu2aVwk6kJhHXO/ESfLXeoCwDJYPiOWjDKIQ6ZLpyBmu3Jw
         nxKg==
X-Gm-Message-State: AOAM530qzs9nWTiCMXk2y8YEydky/ky23AJE5jLDDQlexiqAnObH2cBi
        Da/YtMeWo2JHnGD0+P+pflzusQ==
X-Google-Smtp-Source: ABdhPJykU8ykJheOdpZKzbx1L2Yg/kZEOrPqBfizdvy2xXQGnIx+UU+BsXcLYJ5Kqxihghz9wJxwXw==
X-Received: by 2002:adf:fe0d:: with SMTP id n13mr43226426wrr.73.1626885384870;
        Wed, 21 Jul 2021 09:36:24 -0700 (PDT)
Received: from cloudflare.com (79.191.186.228.ipv4.supernova.orange.pl. [79.191.186.228])
        by smtp.gmail.com with ESMTPSA id n23sm22905586wmc.38.2021.07.21.09.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 09:36:24 -0700 (PDT)
References: <20210719214834.125484-1-john.fastabend@gmail.com>
 <20210719214834.125484-4-john.fastabend@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     daniel@iogearbox.net, xiyou.wangcong@gmail.com,
        alexei.starovoitov@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf 3/3] bpf, sockmap: fix memleak on ingress msg enqueue
In-reply-to: <20210719214834.125484-4-john.fastabend@gmail.com>
Date:   Wed, 21 Jul 2021 18:36:23 +0200
Message-ID: <87sg07r5dk.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 19, 2021 at 11:48 PM CEST, John Fastabend wrote:
> If backlog handler is running during a tear down operation we may enqueue
> data on the ingress msg queue while tear down is trying to free it.
>
>  sk_psock_backlog()
>    sk_psock_handle_skb()
>      skb_psock_skb_ingress()
>        sk_psock_skb_ingress_enqueue()
>          sk_psock_queue_msg(psock,msg)
>                                            spin_lock(ingress_lock)
>                                             sk_psock_zap_ingress()
>                                              _sk_psock_purge_ingerss_msg()
>                                               _sk_psock_purge_ingress_msg()
>                                             -- free ingress_msg list --
>                                            spin_unlock(ingress_lock)
>            spin_lock(ingress_lock)
>            list_add_tail(msg,ingress_msg) <- entry on list with no on
>                                              left to free it.
>            spin_unlock(ingress_lock)
>
> To fix we only enqueue from backlog if the ENABLED bit is set. The tear
> down logic clears the bit with ingress_lock set so we wont enqueue the
> msg in the last step.
>
> Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  include/linux/skmsg.h | 54 ++++++++++++++++++++++++++++---------------
>  net/core/skmsg.c      |  6 -----
>  2 files changed, 35 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 96f319099744..883638888f93 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -285,11 +285,45 @@ static inline struct sk_psock *sk_psock(const struct sock *sk)
>  	return rcu_dereference_sk_user_data(sk);
>  }
>  
> +static inline void sk_psock_set_state(struct sk_psock *psock,
> +				      enum sk_psock_state_bits bit)
> +{
> +	set_bit(bit, &psock->state);
> +}
> +
> +static inline void sk_psock_clear_state(struct sk_psock *psock,
> +					enum sk_psock_state_bits bit)
> +{
> +	clear_bit(bit, &psock->state);
> +}
> +
> +static inline bool sk_psock_test_state(const struct sk_psock *psock,
> +				       enum sk_psock_state_bits bit)
> +{
> +	return test_bit(bit, &psock->state);
> +}
> +
> +static void sock_drop(struct sock *sk, struct sk_buff *skb)
> +{
> +	sk_drops_add(sk, skb);
> +	kfree_skb(skb);
> +}
> +
> +static inline void drop_sk_msg(struct sk_psock *psock, struct sk_msg *msg)
> +{
> +	if (msg->skb)
> +		sock_drop(psock->sk, msg->skb);
> +	kfree(msg);
> +}
> +
>  static inline void sk_psock_queue_msg(struct sk_psock *psock,
>  				      struct sk_msg *msg)
>  {
>  	spin_lock_bh(&psock->ingress_lock);
> -	list_add_tail(&msg->list, &psock->ingress_msg);
> +        if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))


Whitespace issue ^. Otherwise LGTM.

> +		list_add_tail(&msg->list, &psock->ingress_msg);
> +	else
> +		drop_sk_msg(psock, msg);
>  	spin_unlock_bh(&psock->ingress_lock);
>  }
>  

[...]
