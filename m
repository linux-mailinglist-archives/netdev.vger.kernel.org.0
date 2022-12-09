Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22447647ED4
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 08:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiLIH4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 02:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbiLIH4P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 02:56:15 -0500
Received: from smtp-fw-9102.amazon.com (smtp-fw-9102.amazon.com [207.171.184.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF3852146;
        Thu,  8 Dec 2022 23:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1670572569; x=1702108569;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CaMoi5NrXcmji+IIbLWKccOOUw+50Cx6EGVCxdT/MAQ=;
  b=WKfZmXjcforYu+6MVH+QnAYlzB+rikDhUHAvayssFTqrgLRB5CpYlZ8d
   rk83VfJKTxgHVlteFnO4uH57SWZJ3wzV933D4C+7+IFy2U8ARoTZlSLxo
   tpNgImYkaR2yxtxPf04bEiUC1SP/AYs2XlG3VCAHS6ZvF2aC300RqI86C
   A=;
X-IronPort-AV: E=Sophos;i="5.96,230,1665446400"; 
   d="scan'208";a="288754438"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-fa5fe5fb.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 07:56:03 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-fa5fe5fb.us-west-2.amazon.com (Postfix) with ESMTPS id 7514941999;
        Fri,  9 Dec 2022 07:56:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 9 Dec 2022 07:55:59 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.83) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Fri, 9 Dec 2022 07:55:55 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <leitao@debian.org>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <kuniyu@amazon.com>, <leit@fb.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v2 net-next] tcp: socket-specific version of WARN_ON_ONCE()
Date:   Fri, 9 Dec 2022 16:55:44 +0900
Message-ID: <20221209075544.34778-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221208154656.60623-1-leitao@debian.org>
References: <20221208154656.60623-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.83]
X-ClientProxiedBy: EX13D44UWC003.ant.amazon.com (10.43.162.138) To
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

From:   Breno Leitao <leitao@debian.org>
Date:   Thu,  8 Dec 2022 07:46:56 -0800
> There are cases where we need relevant information about the socket
> during a warning, so, it could help us to find bugs that happens and do
> not have an easy repro.
> 
> This patch creates a TCP-socket specific version of WARN_ON_ONCE(), which
> dumps revelant information about the TCP socket when it hits rare
> warnings, which is super useful for debugging purposes.
> 
> Hooking this warning tcp_snd_cwnd_set() for now, but, the intent is to
> convert more TCP warnings to this helper later.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Looks good to me, thank you.

A minor comment below.


> ---
>  include/net/tcp.h       |  3 ++-
>  include/net/tcp_debug.h | 10 ++++++++++
>  net/ipv4/tcp.c          | 30 ++++++++++++++++++++++++++++++
>  3 files changed, 42 insertions(+), 1 deletion(-)
>  create mode 100644 include/net/tcp_debug.h
> 
> diff --git a/include/net/tcp.h b/include/net/tcp.h
> index 14d45661a84d..e490af8e6fdc 100644
> --- a/include/net/tcp.h
> +++ b/include/net/tcp.h
> @@ -40,6 +40,7 @@
>  #include <net/inet_ecn.h>
>  #include <net/dst.h>
>  #include <net/mptcp.h>
> +#include <net/tcp_debug.h>
>  
>  #include <linux/seq_file.h>
>  #include <linux/memcontrol.h>
> @@ -1229,7 +1230,7 @@ static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
>  
>  static inline void tcp_snd_cwnd_set(struct tcp_sock *tp, u32 val)
>  {
> -	WARN_ON_ONCE((int)val <= 0);
> +	TCP_SOCK_WARN_ON_ONCE(tp, (int)val <= 0);
>  	tp->snd_cwnd = val;
>  }
>  
> diff --git a/include/net/tcp_debug.h b/include/net/tcp_debug.h
> new file mode 100644
> index 000000000000..50e96d87d335
> --- /dev/null
> +++ b/include/net/tcp_debug.h
> @@ -0,0 +1,10 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_TCP_DEBUG_H
> +#define _LINUX_TCP_DEBUG_H
> +
> +void tcp_sock_warn(const struct tcp_sock *tp);
> +
> +#define TCP_SOCK_WARN_ON_ONCE(tcp_sock, condition) \
> +		DO_ONCE_LITE_IF(condition, tcp_sock_warn, tcp_sock)
> +
> +#endif  /* _LINUX_TCP_DEBUG_H */
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 54836a6b81d6..5985ba9c4231 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -4705,6 +4705,36 @@ int tcp_abort(struct sock *sk, int err)
>  }
>  EXPORT_SYMBOL_GPL(tcp_abort);
>  
> +void tcp_sock_warn(const struct tcp_sock *tp)
> +{
> +	const struct sock *sk = (const struct sock *)tp;
> +	struct inet_sock *inet = inet_sk(sk);
> +	struct inet_connection_sock *icsk = inet_csk(sk);

Let's keep the reverse christmas tree order.

$ cat -n Documentation/process/maintainer-netdev.rst | grep xmas -C 30


> +
> +	WARN_ON(1);
> +
> +	pr_warn("Socket Info: family=%u state=%d ccname=%s cwnd=%u",
> +		sk->sk_family, sk->sk_state, icsk->icsk_ca_ops->name,
> +		tcp_snd_cwnd(tp));
> +
> +	switch (sk->sk_family) {
> +	case AF_INET:
> +		pr_warn("saddr=%pI4:%u daddr=%pI4:%u", &inet->inet_saddr,
> +			ntohs(inet->inet_sport), &inet->inet_daddr,
> +			ntohs(inet->inet_dport));
> +
> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:
> +		pr_warn("saddr=[%pI6]:%u daddr=[%pI6]:%u", &sk->sk_v6_rcv_saddr,
> +			ntohs(inet->inet_sport), &sk->sk_v6_daddr,
> +			ntohs(inet->inet_dport));
> +		break;
> +#endif
> +	}
> +}
> +EXPORT_SYMBOL_GPL(tcp_sock_warn);
> +
>  extern struct tcp_congestion_ops tcp_reno;
>  
>  static __initdata unsigned long thash_entries;
> -- 
> 2.30.2
