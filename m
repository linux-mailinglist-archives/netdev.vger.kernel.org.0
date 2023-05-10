Return-Path: <netdev+bounces-1525-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BE716FE1A9
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 17:39:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 726831C20D85
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 15:39:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6713E1643D;
	Wed, 10 May 2023 15:39:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6E314AB4;
	Wed, 10 May 2023 15:39:15 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC80819B4;
	Wed, 10 May 2023 08:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1683733153; x=1715269153;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aCHdTaPlfZuhj06LpdR54+yJtYDg/pyYcnvMEvLdHRY=;
  b=h8QVsq3tRYEneT45+x1r5DQQMrP7OKs3EZL5sOr7v5LNQohqflZfBV46
   77UwHzVgP4XxuFJSwXgz094BWhRio4nfVn/JKH9S2PZVpfG/DmwPWSYru
   3FYbvLTrzb+Tc1Joy0pB2+X7rKWo18qhjHagLT1+Ki6eQlgnTM2aBcvAm
   M=;
X-IronPort-AV: E=Sophos;i="5.99,265,1677542400"; 
   d="scan'208";a="1957895"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 15:39:10 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id 38C7F40D6B;
	Wed, 10 May 2023 15:39:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 15:39:09 +0000
Received: from 88665a182662.ant.amazon.com (10.187.171.39) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 10 May 2023 15:39:06 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <aleksandr.mikhalitsyn@canonical.com>
CC: <ast@kernel.org>, <bpf@vger.kernel.org>, <brauner@kernel.org>,
	<daniel@iogearbox.net>, <davem@davemloft.net>, <edumazet@google.com>,
	<kuba@kernel.org>, <kuniyu@amazon.com>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <sdf@google.com>
Subject: Re: [PATCH net-next] net: core: add SOL_SOCKET filter for bpf getsockopt hook
Date: Wed, 10 May 2023 08:38:58 -0700
Message-ID: <20230510153858.84877-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230510152216.1392682-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230510152216.1392682-1-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.39]
X-ClientProxiedBy: EX19D043UWA002.ant.amazon.com (10.13.139.53) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	SORTED_RECIPS,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Date: Wed, 10 May 2023 17:22:16 +0200
> We have per struct proto ->bpf_bypass_getsockopt callback
> to filter out bpf socket cgroup getsockopt hook from being called.
> 
> It seems worthwhile to add analogical helper for SOL_SOCKET
> level socket options. First user will be SO_PEERPIDFD.

I think this patch should be posted within the series below as
there is no real user of sock_bpf_bypass_getsockopt() for now.

Thanks,
Kuniyuki


> 
> This patch was born as a result of discussion around a new SCM_PIDFD interface:
> https://lore.kernel.org/all/20230413133355.350571-3-aleksandr.mikhalitsyn@canonical.com/
> 
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: bpf@vger.kernel.org
> Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
> ---
>  include/linux/bpf-cgroup.h | 8 +++++---
>  include/net/sock.h         | 1 +
>  net/core/sock.c            | 5 +++++
>  3 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index 57e9e109257e..97d8a49b35bf 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -387,10 +387,12 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
>  	int __ret = retval;						       \
>  	if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT) &&			       \
>  	    cgroup_bpf_sock_enabled(sock, CGROUP_GETSOCKOPT))		       \
> -		if (!(sock)->sk_prot->bpf_bypass_getsockopt ||		       \
> -		    !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_getsockopt, \
> +		if (((level != SOL_SOCKET) ||				       \
> +		     !sock_bpf_bypass_getsockopt(level, optname)) &&	       \
> +		    (!(sock)->sk_prot->bpf_bypass_getsockopt ||		       \
> +		     !INDIRECT_CALL_INET_1((sock)->sk_prot->bpf_bypass_getsockopt, \
>  					tcp_bpf_bypass_getsockopt,	       \
> -					level, optname))		       \
> +					level, optname)))		       \
>  			__ret = __cgroup_bpf_run_filter_getsockopt(	       \
>  				sock, level, optname, optval, optlen,	       \
>  				max_optlen, retval);			       \
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 8b7ed7167243..530d6d22f42d 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1847,6 +1847,7 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
>  		  sockptr_t optval, sockptr_t optlen);
>  int sock_getsockopt(struct socket *sock, int level, int op,
>  		    char __user *optval, int __user *optlen);
> +bool sock_bpf_bypass_getsockopt(int level, int optname);
>  int sock_gettstamp(struct socket *sock, void __user *userstamp,
>  		   bool timeval, bool time32);
>  struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 5440e67bcfe3..194a423eb6e5 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1963,6 +1963,11 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
>  			     USER_SOCKPTR(optlen));
>  }
>  
> +bool sock_bpf_bypass_getsockopt(int level, int optname)
> +{
> +	return false;
> +}
> +
>  /*
>   * Initialize an sk_lock.
>   *
> -- 
> 2.34.1


