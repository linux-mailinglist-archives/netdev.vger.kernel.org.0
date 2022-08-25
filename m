Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894FF5A0B9B
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 10:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234467AbiHYIem (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 04:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237442AbiHYIeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 04:34:23 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00DEA74E5
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:34:14 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id w22so3762229ljg.7
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 01:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc;
        bh=4E9OE5xkZCSyvaztlbnRJyjo6ZHyRxnArAaXm5Zm93I=;
        b=hQoPUU9LvmehKSiYbrEkiKxKYx87A4D++hLTGFkH3jInITevGmm4ItqPqb8XoZudo+
         6h3wQc6cN0JX9GGekZ+prZLGMJXE/qAq7yv8ny7E4whaClMM5YxeJDrBT7TGApZjSUGJ
         MQwMtZuyjqZ0p6ZpyBayuFbjLieMQymDsvJbA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc;
        bh=4E9OE5xkZCSyvaztlbnRJyjo6ZHyRxnArAaXm5Zm93I=;
        b=oeQotFbq36KbkF/7QHQnolDJARkuAIFeNBdRf+oYOLalsE9QdxB3mi+ADftsqLYo6i
         Ze+6E/c73maVxAS8zisoDrNtw6xYUNgJ5UqclG0gLD0BelhlGq6DZPQKCOWmdMKCaX8f
         1ycP++Ne/vePXJIYPORVgeFu3fKNvjd5P4fFFj6I+98+KrYW0lAqP74wGs42RoaFsbqq
         ICfOcZ6l86DJedNbCSLJOv4aMlImSmEGf0c+RXog/RLRzadAzLOcK4yoOdju+6i+5Pya
         /s/934Ra3qELIUZs6O5NZPdGD5wKdG5gWyWtUd1FqrumJ4U8L2mb/vQTwjLrHOpnlJlM
         Z23g==
X-Gm-Message-State: ACgBeo2ByDGUU+Ot32v7J59j4znKVWlmARtj50fTX/FpOBLnjPUya9jT
        htTusryxpSXV/3wVjUEb1O4bng==
X-Google-Smtp-Source: AA6agR6b3WHctJZtMe/tEhHo/n51uSuZr/gaUI79YROJjeVrekS3U3m/0w/xvWwQqDwTFw2ubXvuYQ==
X-Received: by 2002:a05:651c:b29:b0:261:d351:9dc4 with SMTP id b41-20020a05651c0b2900b00261d3519dc4mr801036ljr.409.1661416453064;
        Thu, 25 Aug 2022 01:34:13 -0700 (PDT)
Received: from cloudflare.com (79.191.57.8.ipv4.supernova.orange.pl. [79.191.57.8])
        by smtp.gmail.com with ESMTPSA id m18-20020a056512359200b0048abf3a550asm367562lfr.224.2022.08.25.01.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 01:34:12 -0700 (PDT)
References: <20220817195445.151609-1-xiyou.wangcong@gmail.com>
 <20220817195445.151609-3-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch net v3 2/4] tcp: fix tcp_cleanup_rbuf() for tcp_read_skb()
Date:   Thu, 25 Aug 2022 10:31:15 +0200
In-reply-to: <20220817195445.151609-3-xiyou.wangcong@gmail.com>
Message-ID: <87mtbsafi4.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 12:54 PM -07, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> tcp_cleanup_rbuf() retrieves the skb from sk_receive_queue, it
> assumes the skb is not yet dequeued. This is no longer true for
> tcp_read_skb() case where we dequeue the skb first.
>
> Fix this by introducing a helper __tcp_cleanup_rbuf() which does
> not require any skb and calling it in tcp_read_skb().
>
> Fixes: 04919bed948d ("tcp: Introduce tcp_read_skb()")
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  net/ipv4/tcp.c | 24 ++++++++++++++----------
>  1 file changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 05da5cac080b..181a0d350123 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -1567,17 +1567,11 @@ static int tcp_peek_sndq(struct sock *sk, struct msghdr *msg, int len)
>   * calculation of whether or not we must ACK for the sake of
>   * a window update.
>   */
> -void tcp_cleanup_rbuf(struct sock *sk, int copied)
> +static void __tcp_cleanup_rbuf(struct sock *sk, int copied)
>  {
>  	struct tcp_sock *tp = tcp_sk(sk);
>  	bool time_to_ack = false;
>  
> -	struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
> -
> -	WARN(skb && !before(tp->copied_seq, TCP_SKB_CB(skb)->end_seq),
> -	     "cleanup rbuf bug: copied %X seq %X rcvnxt %X\n",
> -	     tp->copied_seq, TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt);
> -
>  	if (inet_csk_ack_scheduled(sk)) {
>  		const struct inet_connection_sock *icsk = inet_csk(sk);
>  
> @@ -1623,6 +1617,17 @@ void tcp_cleanup_rbuf(struct sock *sk, int copied)
>  		tcp_send_ack(sk);
>  }
>  
> +void tcp_cleanup_rbuf(struct sock *sk, int copied)
> +{
> +	struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
> +	struct tcp_sock *tp = tcp_sk(sk);
> +
> +	WARN(skb && !before(tp->copied_seq, TCP_SKB_CB(skb)->end_seq),
> +	     "cleanup rbuf bug: copied %X seq %X rcvnxt %X\n",
> +	     tp->copied_seq, TCP_SKB_CB(skb)->end_seq, tp->rcv_nxt);
> +	__tcp_cleanup_rbuf(sk, copied);
> +}
> +
>  static void tcp_eat_recv_skb(struct sock *sk, struct sk_buff *skb)
>  {
>  	__skb_unlink(skb, &sk->sk_receive_queue);
> @@ -1771,20 +1776,19 @@ int tcp_read_skb(struct sock *sk, skb_read_actor_t recv_actor)
>  		copied += used;
>  
>  		if (TCP_SKB_CB(skb)->tcp_flags & TCPHDR_FIN) {
> -			consume_skb(skb);
>  			++seq;
>  			break;
>  		}
> -		consume_skb(skb);
>  		break;
>  	}
> +	consume_skb(skb);
>  	WRITE_ONCE(tp->copied_seq, seq);
>  
>  	tcp_rcv_space_adjust(sk);
>  
>  	/* Clean up data we have read: This will do ACK frames. */
>  	if (copied > 0)
> -		tcp_cleanup_rbuf(sk, copied);
> +		__tcp_cleanup_rbuf(sk, copied);
>  
>  	return copied;
>  }

This seems to be fixing 2 different problems, but the commit description
mentions just one.

consume_skb() got pulled out of the `while' body. And thanks to that we
are not leaving a dangling skb ref if recv_actor, sk_psock_verdict_recv
in this case, returns 0.
