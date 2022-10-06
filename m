Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94785F637A
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 11:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiJFJUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 05:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiJFJUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 05:20:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F3E1409A
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 02:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665047997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VUnEo3EjbRDMJv+lLUiblmpLO+kFDu16Pv8h+3fxi88=;
        b=TL19xKCZQq9Gj6M09OOhyuw1YABXXdqAKcDYyVSnrHgWTl8RoLk9lEsDKrEz+dxQCtBROA
        KW2sqHDySY9dhxM9cQsEVG9nYkZCK+L/3YqmvTazgqK+P6tlhs81zfL4cfugJKzV7Cqh66
        cML+iDwgEfaKo8w+BaZbqU4pJySM0tg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-67-P_b5M7XyNv6IItOXpMeWNg-1; Thu, 06 Oct 2022 05:19:56 -0400
X-MC-Unique: P_b5M7XyNv6IItOXpMeWNg-1
Received: by mail-wm1-f71.google.com with SMTP id i82-20020a1c3b55000000b003bf635eac31so741116wma.4
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 02:19:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=VUnEo3EjbRDMJv+lLUiblmpLO+kFDu16Pv8h+3fxi88=;
        b=C/yb+SeHnKIofS/j3NDYt7/DeYY3mmfT3cwCZUy5fP+KxczDEUybyYZGwMUixhJx/L
         yePOmj6DxhpeYd5avJesk9/PLMd6OgQftrQr7BIw8U75z3uTv7U3oTnZKi6YEjvIQsjZ
         lSO2DbmIpSjlpysUSml69Z+xOe+fGekXK0oyPjyVdWPeEZeFC83C5mmi111zkGV3yh6Q
         fxb+eFaDDmvXf88udVFwVxbJfWX/aiHzUI4bNWn4R+AS7B6oN8it7Nmrb+tqgJww21Dt
         K2slid+pv35PtS9hxeCZcCB9ENGCuM4cGkii+LgOTvlDs5B8O10Ju15o9VhSYkk90cZO
         ot9g==
X-Gm-Message-State: ACrzQf0KA2GyA+tJ3QnDghqehgBD4GMqVjkO0XFiiS4zHanmQGXL4iSr
        zGNaZX106VVXADq3M9vdO8UWglhaRX8zAUJmLCtOt0R25oSn/FnocvG3qZxH0Y/hu2HNLmOeS3H
        8JDTDOKgSlcCNGtFc
X-Received: by 2002:a5d:5105:0:b0:22e:3ed0:13bf with SMTP id s5-20020a5d5105000000b0022e3ed013bfmr2383948wrt.645.1665047995024;
        Thu, 06 Oct 2022 02:19:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6aJewZ7B+lOd/pwlldt8Y7VsgtAmJ96SrJ3HIWfVEjRWQORDGZByh9+bDyVmTLmeFQVXDmig==
X-Received: by 2002:a5d:5105:0:b0:22e:3ed0:13bf with SMTP id s5-20020a5d5105000000b0022e3ed013bfmr2383931wrt.645.1665047994750;
        Thu, 06 Oct 2022 02:19:54 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id u10-20020adff88a000000b0022e47b57735sm8223489wrp.97.2022.10.06.02.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 02:19:54 -0700 (PDT)
Message-ID: <d669f9a18ae0b18fbecad7efbd2bc2d789f280f3.camel@redhat.com>
Subject: Re: [PATCH v4 net 3/5] tcp/udp: Call inet6_destroy_sock() in IPv6
 sk->sk_destruct().
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        Vladislav Yasevich <vyasevic@redhat.com>
Date:   Thu, 06 Oct 2022 11:19:53 +0200
In-Reply-To: <20221004171802.40968-4-kuniyu@amazon.com>
References: <20221004171802.40968-1-kuniyu@amazon.com>
         <20221004171802.40968-4-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-10-04 at 10:18 -0700, Kuniyuki Iwashima wrote:
> Originally, inet6_sk(sk)->XXX were changed under lock_sock(), so we were
> able to clean them up by calling inet6_destroy_sock() during the IPv6 ->
> IPv4 conversion by IPV6_ADDRFORM.  However, commit 03485f2adcde ("udpv6:
> Add lockless sendmsg() support") added a lockless memory allocation path,
> which could cause a memory leak:
> 
> setsockopt(IPV6_ADDRFORM)                 sendmsg()
> +-----------------------+                 +-------+
> - do_ipv6_setsockopt(sk, ...)             - udpv6_sendmsg(sk, ...)
>   - lock_sock(sk)                           ^._ called via udpv6_prot
>   - WRITE_ONCE(sk->sk_prot, &tcp_prot)          before WRITE_ONCE()
>   - inet6_destroy_sock()
>   - release_sock(sk)                        - ip6_make_skb(sk, ...)
>                                               ^._ lockless fast path for
>                                                   the non-corking case
> 
>                                               - __ip6_append_data(sk, ...)
>                                                 - ipv6_local_rxpmtu(sk, ...)
>                                                   - xchg(&np->rxpmtu, skb)
>                                                     ^._ rxpmtu is never freed.
> 
>                                             - lock_sock(sk)
> 
> For now, rxpmtu is only the case, but not to miss the future change
> and a similar bug fixed in commit e27326009a3d ("net: ping6: Fix
> memleak in ipv6_renew_options()."), let's set a new function to IPv6
> sk->sk_destruct() and call inet6_cleanup_sock() there.  Since the
> conversion does not change sk->sk_destruct(), we can guarantee that
> we can clean up IPv6 resources finally.
> 
> We can now remove all inet6_destroy_sock() calls from IPv6 protocol
> specific ->destroy() functions, but such changes are invasive to
> backport.  So they can be posted as a follow-up later for net-next.
> 
> Fixes: 03485f2adcde ("udpv6: Add lockless sendmsg() support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> Cc: Vladislav Yasevich <vyasevic@redhat.com>
> ---
>  include/net/ipv6.h    |  1 +
>  include/net/udp.h     |  2 +-
>  include/net/udplite.h |  8 --------
>  net/ipv4/udp.c        |  9 ++++++---
>  net/ipv4/udplite.c    |  8 ++++++++
>  net/ipv6/af_inet6.c   |  9 ++++++++-
>  net/ipv6/udp.c        | 15 ++++++++++++++-
>  net/ipv6/udp_impl.h   |  1 +
>  net/ipv6/udplite.c    |  9 ++++++++-
>  9 files changed, 47 insertions(+), 15 deletions(-)
> 
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index dfa70789b771..e7ec3e8cd52e 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -1179,6 +1179,7 @@ void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
>  void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
>  
>  void inet6_cleanup_sock(struct sock *sk);
> +void inet6_sock_destruct(struct sock *sk);
>  int inet6_release(struct socket *sock);
>  int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
>  int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 5ee88ddf79c3..fee053bcd17c 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -247,7 +247,7 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
>  }
>  
>  /* net/ipv4/udp.c */
> -void udp_destruct_sock(struct sock *sk);
> +void udp_destruct_common(struct sock *sk);
>  void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len);
>  int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb);
>  void udp_skb_destructor(struct sock *sk, struct sk_buff *skb);
> diff --git a/include/net/udplite.h b/include/net/udplite.h
> index 0143b373602e..299c14ce2bb9 100644
> --- a/include/net/udplite.h
> +++ b/include/net/udplite.h
> @@ -25,14 +25,6 @@ static __inline__ int udplite_getfrag(void *from, char *to, int  offset,
>  	return copy_from_iter_full(to, len, &msg->msg_iter) ? 0 : -EFAULT;
>  }
>  
> -/* Designate sk as UDP-Lite socket */
> -static inline int udplite_sk_init(struct sock *sk)
> -{
> -	udp_init_sock(sk);
> -	udp_sk(sk)->pcflag = UDPLITE_BIT;
> -	return 0;
> -}
> -
>  /*
>   * 	Checksumming routines
>   */
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 560d9eadeaa5..48adb418e404 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -1598,7 +1598,7 @@ int __udp_enqueue_schedule_skb(struct sock *sk, struct sk_buff *skb)
>  }
>  EXPORT_SYMBOL_GPL(__udp_enqueue_schedule_skb);
>  
> -void udp_destruct_sock(struct sock *sk)
> +void udp_destruct_common(struct sock *sk)
>  {
>  	/* reclaim completely the forward allocated memory */
>  	struct udp_sock *up = udp_sk(sk);
> @@ -1611,10 +1611,14 @@ void udp_destruct_sock(struct sock *sk)
>  		kfree_skb(skb);
>  	}
>  	udp_rmem_release(sk, total, 0, true);
> +}
> +EXPORT_SYMBOL_GPL(udp_destruct_common);
>  
> +static void udp_destruct_sock(struct sock *sk)
> +{
> +	udp_destruct_common(sk);
>  	inet_sock_destruct(sk);
>  }
> -EXPORT_SYMBOL_GPL(udp_destruct_sock);
>  
>  int udp_init_sock(struct sock *sk)
>  {
> @@ -1622,7 +1626,6 @@ int udp_init_sock(struct sock *sk)
>  	sk->sk_destruct = udp_destruct_sock;
>  	return 0;
>  }
> -EXPORT_SYMBOL_GPL(udp_init_sock);
>  
>  void skb_consume_udp(struct sock *sk, struct sk_buff *skb, int len)
>  {
> diff --git a/net/ipv4/udplite.c b/net/ipv4/udplite.c
> index 6e08a76ae1e7..4785ac4a8719 100644
> --- a/net/ipv4/udplite.c
> +++ b/net/ipv4/udplite.c
> @@ -17,6 +17,14 @@
>  struct udp_table 	udplite_table __read_mostly;
>  EXPORT_SYMBOL(udplite_table);
>  
> +/* Designate sk as UDP-Lite socket */
> +static inline int udplite_sk_init(struct sock *sk)

You should avoid the 'inline' specifier in c files.

> +{
> +	udp_init_sock(sk);
> +	udp_sk(sk)->pcflag = UDPLITE_BIT;
> +	return 0;
> +}
> +
>  static int udplite_rcv(struct sk_buff *skb)
>  {
>  	return __udp4_lib_rcv(skb, &udplite_table, IPPROTO_UDPLITE);
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index 83b9e432f3df..ce5378b78ec9 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -109,6 +109,13 @@ static __inline__ struct ipv6_pinfo *inet6_sk_generic(struct sock *sk)
>  	return (struct ipv6_pinfo *)(((u8 *)sk) + offset);
>  }
>  
> +void inet6_sock_destruct(struct sock *sk)
> +{
> +	inet6_cleanup_sock(sk);
> +	inet_sock_destruct(sk);
> +}
> +EXPORT_SYMBOL_GPL(inet6_sock_destruct);

I'm sorry for not noticing this before, but it looks like the above
export is not needed? only used by udp, which is in the same binary
(either kernel of ipv6 module) as af_inet6


Cheers,

Paolo

