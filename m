Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6D05FB006
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 12:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiJKKCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 06:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiJKKBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 06:01:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289008D0D0
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 03:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665482447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XiLYSpf3q8G+5FzkO8Bm2R5lAQ9B/J9Zd9PiR+9O0jg=;
        b=bHcZKrL3YhMArKJF6CRagcN8YUbVbp68FktfNhQWwXY1nwlopg0w0s8skH7Rby3AYyL9Yu
        oXxzscOqlxetGTAt9p3UEHjp7uhxsKHcs2i7WOLVjxrJw3Pg/n0WRYPGtkEZbgBR+E+YBk
        zRI/5v1HZn8Ua4rMT3eJVdkOmGrMOOI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-643-Bju-eQtIPzyDJiP83q3eFA-1; Tue, 11 Oct 2022 06:00:46 -0400
X-MC-Unique: Bju-eQtIPzyDJiP83q3eFA-1
Received: by mail-qk1-f198.google.com with SMTP id x22-20020a05620a259600b006b552a69231so11171933qko.18
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 03:00:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XiLYSpf3q8G+5FzkO8Bm2R5lAQ9B/J9Zd9PiR+9O0jg=;
        b=g3NeuTHT480/8zRLAS4nwr/xlMUptrdQo+uZ0z0fFBDMzuSOYJHjJ1Lz0MMp7ssc8D
         63IaxE2Slt3jI0xBbCzKBNEe4+9MrF+3XZtLDrGuLVKR4Wni+eURgzxk8wo4PNXGO2NA
         Yz3S32om1lCLkKAbAcqeCcjw1/TOTvne1jn7VBw1vmGDz6P3zBh7alqgszLcIUr1CUR6
         j8Wh2btcT4DqtbUBQ5pAmXAcZFEbebF4Oj57pyZ+oK0LG98rRbyt45Y1fKGbhDcLIyoT
         g1Zo5Bw2x0td4nyrdl/MHJulAL3qR3bYlBfJNRkbQEGdmD/R2EPMZRrgv4DfbnbajJK/
         WeAA==
X-Gm-Message-State: ACrzQf0IMUgZ97lu8IALHIwozZ7Q1RWaa2KaFmatVARqA9DVv8JHUcMl
        EGWWwrtxGhwuD5f3vr8X8imSiqTOPTXrRw9IkL/lUhwwY2F2S+NRI+72AjPinIRqEtjMGXE4YGm
        OXTH0Y2hF22ke39Dq
X-Received: by 2002:a05:6214:e4a:b0:4b1:d684:f72f with SMTP id o10-20020a0562140e4a00b004b1d684f72fmr18137827qvc.3.1665482445896;
        Tue, 11 Oct 2022 03:00:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM46LtoOcZJkf6fvzisrAoFpYMrZZXADXvKBzX+6HkVjzkGsU1en8r8UKznB++bG6ML+lsgiCA==
X-Received: by 2002:a05:6214:e4a:b0:4b1:d684:f72f with SMTP id o10-20020a0562140e4a00b004b1d684f72fmr18137803qvc.3.1665482445628;
        Tue, 11 Oct 2022 03:00:45 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id u5-20020a05620a454500b006b640efe6dasm12168464qkp.132.2022.10.11.03.00.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 03:00:45 -0700 (PDT)
Message-ID: <0ded6ccc2cd76b030fbe374b8cdd9aa2e54a9d04.camel@redhat.com>
Subject: Re: [PATCH v5 net 2/5] udp: Call inet6_destroy_sock() in
 setsockopt(IPV6_ADDRFORM).
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        Brian Haley <brian.haley@hp.com>
Date:   Tue, 11 Oct 2022 12:00:41 +0200
In-Reply-To: <20221006185349.74777-3-kuniyu@amazon.com>
References: <20221006185349.74777-1-kuniyu@amazon.com>
         <20221006185349.74777-3-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-10-06 at 11:53 -0700, Kuniyuki Iwashima wrote:
> Commit 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support") forgot
> to add a change to free inet6_sk(sk)->rxpmtu while converting an IPv6
> socket into IPv4 with IPV6_ADDRFORM.  After conversion, sk_prot is
> changed to udp_prot and ->destroy() never cleans it up, resulting in
> a memory leak.
> 
> This is due to the discrepancy between inet6_destroy_sock() and
> IPV6_ADDRFORM, so let's call inet6_destroy_sock() from IPV6_ADDRFORM
> to remove the difference.
> 
> However, this is not enough for now because rxpmtu can be changed
> without lock_sock() after commit 03485f2adcde ("udpv6: Add lockless
> sendmsg() support").  We will fix this case in the following patch.
> 
> Note we will rename inet6_destroy_sock() to inet6_cleanup_sock() and
> remove unnecessary inet6_destroy_sock() calls in sk_prot->destroy()
> in the future.
> 
> Fixes: 4b340ae20d0e ("IPv6: Complete IPV6_DONTFRAG support")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> Cc: Brian Haley <brian.haley@hp.com>
> ---
>  include/net/ipv6.h       |  1 +
>  net/ipv6/af_inet6.c      |  6 ++++++
>  net/ipv6/ipv6_sockglue.c | 20 ++++++++------------
>  3 files changed, 15 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index d664ba5812d8..335a49ecd8a0 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -1182,6 +1182,7 @@ void ipv6_icmp_error(struct sock *sk, struct sk_buff *skb, int err, __be16 port,
>  void ipv6_local_error(struct sock *sk, int err, struct flowi6 *fl6, u32 info);
>  void ipv6_local_rxpmtu(struct sock *sk, struct flowi6 *fl6, u32 mtu);
>  
> +void inet6_cleanup_sock(struct sock *sk);
>  int inet6_release(struct socket *sock);
>  int inet6_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len);
>  int inet6_getname(struct socket *sock, struct sockaddr *uaddr,
> diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
> index d40b7d60e00e..ded827944fa6 100644
> --- a/net/ipv6/af_inet6.c
> +++ b/net/ipv6/af_inet6.c
> @@ -510,6 +510,12 @@ void inet6_destroy_sock(struct sock *sk)
>  }
>  EXPORT_SYMBOL_GPL(inet6_destroy_sock);
>  
> +void inet6_cleanup_sock(struct sock *sk)
> +{
> +	inet6_destroy_sock(sk);
> +}
> +EXPORT_SYMBOL_GPL(inet6_cleanup_sock);
> +
>  /*
>   *	This does both peername and sockname.
>   */
> diff --git a/net/ipv6/ipv6_sockglue.c b/net/ipv6/ipv6_sockglue.c
> index 408345fc4c5c..a20edae868fd 100644
> --- a/net/ipv6/ipv6_sockglue.c
> +++ b/net/ipv6/ipv6_sockglue.c
> @@ -431,9 +431,6 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>  		if (optlen < sizeof(int))
>  			goto e_inval;
>  		if (val == PF_INET) {
> -			struct ipv6_txoptions *opt;
> -			struct sk_buff *pktopt;
> -
>  			if (sk->sk_type == SOCK_RAW)
>  				break;
>  
> @@ -464,7 +461,6 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>  				break;
>  			}
>  
> -			fl6_free_socklist(sk);
>  			__ipv6_sock_mc_close(sk);
>  			__ipv6_sock_ac_close(sk);
>  
> @@ -501,14 +497,14 @@ int do_ipv6_setsockopt(struct sock *sk, int level, int optname,
>  				sk->sk_socket->ops = &inet_dgram_ops;
>  				sk->sk_family = PF_INET;
>  			}
> -			opt = xchg((__force struct ipv6_txoptions **)&np->opt,
> -				   NULL);
> -			if (opt) {
> -				atomic_sub(opt->tot_len, &sk->sk_omem_alloc);
> -				txopt_put(opt);
> -			}
> -			pktopt = xchg(&np->pktoptions, NULL);
> -			kfree_skb(pktopt);
> +
> +			/* Disable all options not to allocate memory anymore,
> +			 * but there is still a race.  See the lockless path
> +			 * in udpv6_sendmsg() and ipv6_local_rxpmtu().
> +			 */
> +			np->rxopt.all = 0;
> +
> +			inet6_cleanup_sock(sk);

I think there still a pending point raised from Eric here. 

"""
Once the v6 socket has been transformed to IPv4 one,
inet6_sock_destruct() is not going to be called.
"""

AFAICS the series is safe Kuniyuki noted:

"""
inet6_sock_destruct() is set to sk->sk_destruct(), which is not changed
by the transformation and will be called from __sk_destruct().
"""
[with the next patch]

@Eric are you fine with the above?

Thanks!

Paolo


>  
>  			/*
>  			 * ... and add it to the refcnt debug socks count

