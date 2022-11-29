Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C73C563B6D0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbiK2BBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234672AbiK2BBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:01:11 -0500
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C773E0A6;
        Mon, 28 Nov 2022 17:01:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669683671; x=1701219671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TnLUlshqejAasTVyid01sMRX0wFcafdFFs3w3Ws5T8g=;
  b=uqhDYOlmsOFprkhxETfTG5xkWQwdUVxuimeAeusXuxN1GSChNpDo7Gxi
   uktHju+dXzL7k2RnR/a3YcK63hKNnAljaHIs5yXhW+VDUx9fsiB6PsX8T
   Z+7oLpIb+skyfw/QkUp63LpXVEdaYhMtPYUWicVdWmbS0uvPiCeq7uVCE
   8=;
X-IronPort-AV: E=Sophos;i="5.96,201,1665446400"; 
   d="scan'208";a="155736595"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Nov 2022 01:01:09 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-21d8d9f4.us-west-2.amazon.com (Postfix) with ESMTPS id 86F1781BCC;
        Tue, 29 Nov 2022 01:01:08 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 29 Nov 2022 01:01:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.134) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Tue, 29 Nov 2022 01:01:04 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <leitao@debian.org>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <edumazet@google.com>,
        <kuba@kernel.org>, <leit@fb.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <yoshfuji@linux-ipv6.org>, <kuniyu@amazon.com>
Subject: Re: [PATCH RESEND net-next] tcp: socket-specific version of WARN_ON_ONCE()
Date:   Tue, 29 Nov 2022 10:00:55 +0900
Message-ID: <20221129010055.75780-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221124112229.789975-1-leitao@debian.org>
References: <20221124112229.789975-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D24UWB001.ant.amazon.com (10.43.161.93) To
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
Date:   Thu, 24 Nov 2022 03:22:29 -0800
> There are cases where we need information about the socket during a
> warning, so, it could help us to find bugs that happens and do not have
> an easy repro.
> 
> This diff creates a TCP socket-specific version of WARN_ON_ONCE(), which
> dumps more information about the TCP socket.
> 
> This new warning is not only useful to give more insight about kernel bugs, but,
> it is also helpful to expose information that might be coming from buggy
> BPF applications, such as BPF applications that sets invalid
> tcp_sock->snd_cwnd values.

Have you finally found a root cause on BPF or TCP side ?


> Signed-off-by: Breno Leitao <leitao@debian.org>
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
> index 54836a6b81d6..dd682f60c7cb 100644
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
> +
> +	WARN_ON(1);
> +
> +	if (!tp)

Is this needed ?


> +		return;
> +
> +	pr_warn("Socket Info: family=%u state=%d sport=%u dport=%u ccname=%s cwnd=%u",
> +		sk->sk_family, sk->sk_state, ntohs(inet->inet_sport),
> +		ntohs(inet->inet_dport), icsk->icsk_ca_ops->name, tcp_snd_cwnd(tp));
> +
> +	switch (sk->sk_family) {
> +	case AF_INET:
> +		pr_warn("saddr=%pI4 daddr=%pI4", &inet->inet_saddr,
> +			&inet->inet_daddr);

As with tcp_syn_flood_action(), [address]:port format is easy
to read and consistent in kernel ?


> +		break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +	case AF_INET6:
> +		pr_warn("saddr=%pI6 daddr=%pI6", &sk->sk_v6_rcv_saddr,
> +			&sk->sk_v6_daddr);
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
