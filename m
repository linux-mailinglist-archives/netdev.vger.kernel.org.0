Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 256D7694DF8
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 18:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjBMRaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 12:30:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjBMRaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 12:30:02 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7812D54;
        Mon, 13 Feb 2023 09:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1676309402; x=1707845402;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OXlmuN9Z7tYjafYF+DUI69ISpL+HB5AknBHBtTrE5z8=;
  b=CEq+kSC7tFU0Uwbum7tKFO6UXQPiLVZsEe0lUWR0ijunEswaqIJDzi3c
   dCyoynzhaBO7xuv7hmYeHRgK53qR2RjKQ1jDhTDVhWPDSvjB+l5ReXQlz
   0T3Gq3nPjPFDkIxMN8PCSpYKKkEAS1mcgrWyhYetCCH+xHMXhqO7YP/dn
   Q=;
X-IronPort-AV: E=Sophos;i="5.97,294,1669075200"; 
   d="scan'208";a="310451287"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 17:29:55 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-m6i4x-d8e96288.us-east-1.amazon.com (Postfix) with ESMTPS id 222238234D;
        Mon, 13 Feb 2023 17:29:50 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 13 Feb 2023 17:29:50 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.198) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.24;
 Mon, 13 Feb 2023 17:29:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <kerneljasonxing@gmail.com>
CC:     <bpf@vger.kernel.org>, <davem@davemloft.net>, <dsahern@kernel.org>,
        <edumazet@google.com>, <kernelxing@tencent.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <kuniyu@amazon.com>
Subject: Re: [PATCH net-next] net: Kconfig.debug: wrap socket refcnt debug into an option
Date:   Mon, 13 Feb 2023 09:29:39 -0800
Message-ID: <20230213172939.39449-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230211065153.54116-1-kerneljasonxing@gmail.com>
References: <20230211065153.54116-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D40UWA001.ant.amazon.com (10.43.160.53) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sat, 11 Feb 2023 14:51:53 +0800
> From: Jason Xing <kernelxing@tencent.com>
> 
> Since commit 463c84b97f24 ("[NET]: Introduce inet_connection_sock")
> commented out the definition of SOCK_REFCNT_DEBUG and later another
> patch deleted it,

e48c414ee61f ("[INET]: Generalise the TCP sock ID lookup routines")
is the commit which commented out SOCK_REFCNT_DEBUG, and 463c84b97f24
removed it.


> we need to enable it through defining it manually
> somewhere. Wrapping it into an option in Kconfig.debug could make
> it much clearer and easier for some developers to do things based
> on this change.

Considering SOCK_REFCNT_DEBUG is removed in 2005, how about removing
the whole feature?  I think we can track the same info easily with
bpftrace + kprobe.


> 
> Signed-off-by: Jason Xing <kernelxing@tencent.com>
> ---
>  include/net/sock.h            | 8 ++++----
>  net/Kconfig.debug             | 8 ++++++++
>  net/ipv4/inet_timewait_sock.c | 2 +-
>  3 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/sock.h b/include/net/sock.h
> index dcd72e6285b2..1b001efeb9b5 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1349,7 +1349,7 @@ struct proto {
>  	char			name[32];
>  
>  	struct list_head	node;
> -#ifdef SOCK_REFCNT_DEBUG
> +#ifdef CONFIG_SOCK_REFCNT_DEBUG
>  	atomic_t		socks;
>  #endif
>  	int			(*diag_destroy)(struct sock *sk, int err);
> @@ -1359,7 +1359,7 @@ int proto_register(struct proto *prot, int alloc_slab);
>  void proto_unregister(struct proto *prot);
>  int sock_load_diag_module(int family, int protocol);
>  
> -#ifdef SOCK_REFCNT_DEBUG
> +#ifdef CONFIG_SOCK_REFCNT_DEBUG
>  static inline void sk_refcnt_debug_inc(struct sock *sk)
>  {
>  	atomic_inc(&sk->sk_prot->socks);
> @@ -1378,11 +1378,11 @@ static inline void sk_refcnt_debug_release(const struct sock *sk)
>  		printk(KERN_DEBUG "Destruction of the %s socket %p delayed, refcnt=%d\n",
>  		       sk->sk_prot->name, sk, refcount_read(&sk->sk_refcnt));
>  }
> -#else /* SOCK_REFCNT_DEBUG */
> +#else /* CONFIG_SOCK_REFCNT_DEBUG */
>  #define sk_refcnt_debug_inc(sk) do { } while (0)
>  #define sk_refcnt_debug_dec(sk) do { } while (0)
>  #define sk_refcnt_debug_release(sk) do { } while (0)
> -#endif /* SOCK_REFCNT_DEBUG */
> +#endif /* CONFIG_SOCK_REFCNT_DEBUG */
>  
>  INDIRECT_CALLABLE_DECLARE(bool tcp_stream_memory_free(const struct sock *sk, int wake));
>  
> diff --git a/net/Kconfig.debug b/net/Kconfig.debug
> index 5e3fffe707dd..667396d70e10 100644
> --- a/net/Kconfig.debug
> +++ b/net/Kconfig.debug
> @@ -18,6 +18,14 @@ config NET_NS_REFCNT_TRACKER
>  	  Enable debugging feature to track netns references.
>  	  This adds memory and cpu costs.
>  
> +config SOCK_REFCNT_DEBUG
> +	bool "Enable socket refcount debug"
> +	depends on DEBUG_KERNEL && NET
> +	default n
> +	help
> +	  Enable debugging feature to track socket references.
> +	  This adds memory and cpu costs.
> +
>  config DEBUG_NET
>  	bool "Add generic networking debug"
>  	depends on DEBUG_KERNEL && NET
> diff --git a/net/ipv4/inet_timewait_sock.c b/net/ipv4/inet_timewait_sock.c
> index beed32fff484..e313516b64ce 100644
> --- a/net/ipv4/inet_timewait_sock.c
> +++ b/net/ipv4/inet_timewait_sock.c
> @@ -77,7 +77,7 @@ void inet_twsk_free(struct inet_timewait_sock *tw)
>  {
>  	struct module *owner = tw->tw_prot->owner;
>  	twsk_destructor((struct sock *)tw);
> -#ifdef SOCK_REFCNT_DEBUG
> +#ifdef CONFIG_SOCK_REFCNT_DEBUG
>  	pr_debug("%s timewait_sock %p released\n", tw->tw_prot->name, tw);
>  #endif
>  	kmem_cache_free(tw->tw_prot->twsk_prot->twsk_slab, tw);
> -- 
> 2.37.3
