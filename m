Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47AA572EE5
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231622AbiGMHPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiGMHPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:15:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CAC0448EB0
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657696534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WsD5xi+xBBh9TcyhhvYNeAbIRRwoygViokKDtJ5a4fA=;
        b=B2HMbgh6oJW3+CIwD+lAQVsRSOpErpPEQOuX+KLvNS9eC8EyER5tHgSBwLFek3sG1lcuDb
        SUixzRgSH3G5BA4oLnHnZryS0Tg9xoP5+G7nRoyQggO/FagXZau3fCJUz7kFUX2GZK3+KC
        BQT7cMx2LePnTyQrGnS3tDsOPbE8CkA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-2INIKtElMzqy1PKi-Pn5OA-1; Wed, 13 Jul 2022 03:15:33 -0400
X-MC-Unique: 2INIKtElMzqy1PKi-Pn5OA-1
Received: by mail-wr1-f69.google.com with SMTP id k26-20020adfb35a000000b0021d6c3b9363so1825589wrd.1
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:15:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WsD5xi+xBBh9TcyhhvYNeAbIRRwoygViokKDtJ5a4fA=;
        b=1eHManWygO9u6AQvctPNXzGS+pIoJYkOWJGQuxugC1zUJL/G+TM0tTHVU+HaToigKI
         C9Mt/HZnYQEkQRZR66OyHIxO/NnJwf8KWCeGmaRTVI+6HQqyeRGkFmgxO/U+9SpYzxsq
         MhsMq5WJQ4gZ/uFSw01cN3oXeREB41icRDOwhZOo+b/cGJ30RczLQBEkbkbd980WmySn
         z4J8ohTQAO12x7Xr1snAwbyM4OCohIKBK+uuziRG319g5o2nHi+6RAsjVoZdBc+AQ85W
         6HEKfzv5aQccDUqU/mkfpgS8yE6spXiFXK8Kt2+gr61hFj6USOhw8uNROlbgPESEuxC5
         6Fwg==
X-Gm-Message-State: AJIora9HBqnlkHVNPmyDplxRUuKny+4ZqjCf2RT5j/zjc5EZSYt4GxUs
        gdQ3b+y5HARWOr2UEjx1cPsSTcfXQ5CCiv1BL2QYdXGZA1lk8Lc26II+0docLA22b9S8RjXn0j9
        UG5dhRSnUZ52+Q5Hj
X-Received: by 2002:a5d:4d4e:0:b0:21d:7a79:e04c with SMTP id a14-20020a5d4d4e000000b0021d7a79e04cmr1785812wru.519.1657696532031;
        Wed, 13 Jul 2022 00:15:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tHyxK78gSFgcu/ii3pPAwUILzXg8sDpGkd4E5cLR8nvb+N0BzGfLqhNmtBDxqyW53r164VKA==
X-Received: by 2002:a5d:4d4e:0:b0:21d:7a79:e04c with SMTP id a14-20020a5d4d4e000000b0021d7a79e04cmr1785788wru.519.1657696531711;
        Wed, 13 Jul 2022 00:15:31 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id k28-20020a5d525c000000b0020fcc655e4asm10150032wrc.5.2022.07.13.00.15.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 00:15:31 -0700 (PDT)
Message-ID: <e8e3986ef81121c51ff4543a9432374897542290.camel@redhat.com>
Subject: Re: [PATCH v3 net] tcp/udp: Make early_demux back namespacified.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Date:   Wed, 13 Jul 2022 09:15:30 +0200
In-Reply-To: <20220712185138.43274-1-kuniyu@amazon.com>
References: <20220712185138.43274-1-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2022-07-12 at 11:51 -0700, Kuniyuki Iwashima wrote:
> Commit e21145a9871a ("ipv4: namespacify ip_early_demux sysctl knob") made
> it possible to enable/disable early_demux on a per-netns basis.  Then, we
> introduced two knobs, tcp_early_demux and udp_early_demux, to switch it for
> TCP/UDP in commit dddb64bcb346 ("net: Add sysctl to toggle early demux for
> tcp and udp").  However, the .proc_handler() was wrong and actually
> disabled us from changing the behaviour in each netns.
> 
> We can execute early_demux if net.ipv4.ip_early_demux is on and each proto
> .early_demux() handler is not NULL.  When we toggle (tcp|udp)_early_demux,
> the change itself is saved in each netns variable, but the .early_demux()
> handler is a global variable, so the handler is switched based on the
> init_net's sysctl variable.  Thus, netns (tcp|udp)_early_demux knobs have
> nothing to do with the logic.  Whether we CAN execute proto .early_demux()
> is always decided by init_net's sysctl knob, and whether we DO it or not is
> by each netns ip_early_demux knob.
> 
> This patch namespacifies (tcp|udp)_early_demux again.  For now, the users
> of the .early_demux() handler are TCP and UDP only, and they are called
> directly to avoid retpoline.  So, we can remove the .early_demux() handler
> from inet6?_protos and need not dereference them in ip6?_rcv_finish_core().
> If another proto needs .early_demux(), we can restore it at that time.
> 
> Fixes: dddb64bcb346 ("net: Add sysctl to toggle early demux for tcp and udp")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> v3:
>   - Drop sysctl min/max fixes (Eric Dumazet)
> 
> v2: https://lore.kernel.org/netdev/20220712173801.39550-1-kuniyu@amazon.com/
>   - Drop cleanups in tcp_v4_early_demux() (Eric Dumazet)
> 
> v1: https://lore.kernel.org/netdev/20220712163243.36014-1-kuniyu@amazon.com/
> ---
>  include/net/protocol.h     |  4 ---
>  include/net/tcp.h          |  2 +-
>  include/net/udp.h          |  2 +-
>  net/ipv4/af_inet.c         | 14 ++-------
>  net/ipv4/ip_input.c        | 37 ++++++++++++++----------
>  net/ipv4/sysctl_net_ipv4.c | 59 ++------------------------------------
>  net/ipv6/ip6_input.c       | 23 ++++++++-------
>  net/ipv6/tcp_ipv6.c        |  9 ++----
>  net/ipv6/udp.c             |  9 ++----
>  9 files changed, 45 insertions(+), 114 deletions(-)
> 
> diff --git a/include/net/protocol.h b/include/net/protocol.h
> index f51c06ae365f..6aef8cb11cc8 100644
> --- a/include/net/protocol.h
> +++ b/include/net/protocol.h
> @@ -35,8 +35,6 @@
>  
>  /* This is used to register protocols. */
>  struct net_protocol {
> -	int			(*early_demux)(struct sk_buff *skb);
> -	int			(*early_demux_handler)(struct sk_buff *skb);
>  	int			(*handler)(struct sk_buff *skb);
>  
>  	/* This returns an error if we weren't able to handle the error. */
> @@ -52,8 +50,6 @@ struct net_protocol {
>  
>  #if IS_ENABLED(CONFIG_IPV6)
>  struct inet6_protocol {
> -	void	(*early_demux)(struct sk_buff *skb);
> -	void    (*early_demux_handler)(struct sk_buff *skb);
>  	int	(*handler)(struct sk_buff *skb);
>  
>  	/* This returns an error if we weren't able to handle the error. */
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 1e99f5c61f84..1636c55e798b 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -932,7 +932,7 @@ extern const struct inet_connection_sock_af_ops ipv6_specific;
>  
>  INDIRECT_CALLABLE_DECLARE(void tcp_v6_send_check(struct sock *sk, struct sk_buff *skb));
>  INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *skb));
> -INDIRECT_CALLABLE_DECLARE(void tcp_v6_early_demux(struct sk_buff *skb));
> +void tcp_v6_early_demux(struct sk_buff *skb);
>  
>  #endif
>  
> diff --git a/include/net/udp.h b/include/net/udp.h
> index b83a00330566..bb4c227299cc 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -167,7 +167,7 @@ static inline void udp_csum_pull_header(struct sk_buff *skb)
>  typedef struct sock *(*udp_lookup_t)(const struct sk_buff *skb, __be16 sport,
>  				     __be16 dport);
>  
> -INDIRECT_CALLABLE_DECLARE(void udp_v6_early_demux(struct sk_buff *));
> +void udp_v6_early_demux(struct sk_buff *skb);
>  INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
>  
>  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 93da9f783bec..76e7a7ca6772 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -1710,24 +1710,14 @@ static const struct net_protocol igmp_protocol = {
>  };
>  #endif
>  
> -/* thinking of making this const? Don't.
> - * early_demux can change based on sysctl.
> - */
> -static struct net_protocol tcp_protocol = {
> -	.early_demux	=	tcp_v4_early_demux,
> -	.early_demux_handler =  tcp_v4_early_demux,
> +static const struct net_protocol tcp_protocol = {
>  	.handler	=	tcp_v4_rcv,
>  	.err_handler	=	tcp_v4_err,
>  	.no_policy	=	1,
>  	.icmp_strict_tag_validation = 1,
>  };
>  
> -/* thinking of making this const? Don't.
> - * early_demux can change based on sysctl.
> - */
> -static struct net_protocol udp_protocol = {
> -	.early_demux =	udp_v4_early_demux,
> -	.early_demux_handler =	udp_v4_early_demux,
> +static const struct net_protocol udp_protocol = {
>  	.handler =	udp_rcv,
>  	.err_handler =	udp_err,
>  	.no_policy =	1,
> diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> index b1165f717cd1..455ec0931ad8 100644
> --- a/net/ipv4/ip_input.c
> +++ b/net/ipv4/ip_input.c
> @@ -312,14 +312,13 @@ static bool ip_can_use_hint(const struct sk_buff *skb, const struct iphdr *iph,
>  	       ip_hdr(hint)->tos == iph->tos;
>  }
>  
> -INDIRECT_CALLABLE_DECLARE(int udp_v4_early_demux(struct sk_buff *));
> -INDIRECT_CALLABLE_DECLARE(int tcp_v4_early_demux(struct sk_buff *));
> +int tcp_v4_early_demux(struct sk_buff *skb);
> +int udp_v4_early_demux(struct sk_buff *skb);
>  static int ip_rcv_finish_core(struct net *net, struct sock *sk,
>  			      struct sk_buff *skb, struct net_device *dev,
>  			      const struct sk_buff *hint)
>  {
>  	const struct iphdr *iph = ip_hdr(skb);
> -	int (*edemux)(struct sk_buff *skb);
>  	int err, drop_reason;
>  	struct rtable *rt;
>  
> @@ -332,21 +331,29 @@ static int ip_rcv_finish_core(struct net *net, struct sock *sk,
>  			goto drop_error;
>  	}
>  
> -	if (net->ipv4.sysctl_ip_early_demux &&
> +	if (READ_ONCE(net->ipv4.sysctl_ip_early_demux) &&
>  	    !skb_dst(skb) &&
>  	    !skb->sk &&
>  	    !ip_is_fragment(iph)) {
> -		const struct net_protocol *ipprot;
> -		int protocol = iph->protocol;
> -
> -		ipprot = rcu_dereference(inet_protos[protocol]);
> -		if (ipprot && (edemux = READ_ONCE(ipprot->early_demux))) {
> -			err = INDIRECT_CALL_2(edemux, tcp_v4_early_demux,
> -					      udp_v4_early_demux, skb);
> -			if (unlikely(err))
> -				goto drop_error;
> -			/* must reload iph, skb->head might have changed */
> -			iph = ip_hdr(skb);
> +		switch (iph->protocol) {
> +		case IPPROTO_TCP:
> +			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux)) {
> +				tcp_v4_early_demux(skb);
> +
> +				/* must reload iph, skb->head might have changed */
> +				iph = ip_hdr(skb);
> +			}
> +			break;
> +		case IPPROTO_UDP:
> +			if (READ_ONCE(net->ipv4.sysctl_tcp_early_demux)) {

I'm sorry for the late feedback. The above should be
'sysctl_udp_early_demux'.

The same happens in the ipv6 case.

Thanks!

Paolo

