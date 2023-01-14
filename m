Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C01FE66AAD4
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 10:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjANJ7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 04:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbjANJ7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 04:59:35 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89EBE76A8
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 01:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673690375; x=1705226375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KoKqqr/xaSc0Ots9I1VWcYo4dvskV8ONfB/+YlpbEyU=;
  b=CU87b4rbFwXl7xTGe0+7lDhfq5/jS0NdU7smHQyk8HfpFQO0RY/aEZ+h
   a+tCaCmSvFylYADfEwMw0tmEvQgfy8lVaJytwtUmSLSAkfClENpNuY3k9
   YmeduIhmgx5qHSV4ji1vnq9oIfGtnRHPWAdcw7xqceCBifAIC/0TMUyVC
   s=;
X-IronPort-AV: E=Sophos;i="5.97,216,1669075200"; 
   d="scan'208";a="255121958"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2023 09:59:29 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-d40ec5a9.us-west-2.amazon.com (Postfix) with ESMTPS id CD30541EFA;
        Sat, 14 Jan 2023 09:59:27 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Sat, 14 Jan 2023 09:59:25 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Sat, 14 Jan 2023 09:59:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <tkhai@ya.ru>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2] unix: Improve locking scheme in unix_show_fdinfo()
Date:   Sat, 14 Jan 2023 18:59:11 +0900
Message-ID: <20230114095911.5039-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <c6c7084c-56c7-cd37-befe-df718e080597@ya.ru>
References: <c6c7084c-56c7-cd37-befe-df718e080597@ya.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D38UWC001.ant.amazon.com (10.43.162.170) To
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

From:   Kirill Tkhai <tkhai@ya.ru>
Date:   Sat, 14 Jan 2023 12:35:02 +0300
> After switching to TCP_ESTABLISHED or TCP_LISTEN sk_state, alive SOCK_STREAM
> and SOCK_SEQPACKET sockets can't change it anymore (since commit 3ff8bff704f4
> "unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()").
> 
> Thus, we do not need to take lock here.
> 
> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
> ---
> v2: Initialize "nr_fds = 0".

Yes, this is necessary because the new if-else does not cover
(SOCK_STREAM, TCP_CLOSE), and in such a case, nr_fds is
uninitialised val with the v1 patch.

This version looks good.

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>


> 
>  net/unix/af_unix.c |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index f0c2293f1d3b..009616fa0256 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -807,23 +807,23 @@ static int unix_count_nr_fds(struct sock *sk)
>  static void unix_show_fdinfo(struct seq_file *m, struct socket *sock)
>  {
>  	struct sock *sk = sock->sk;
> +	unsigned char s_state;
>  	struct unix_sock *u;
> -	int nr_fds;
> +	int nr_fds = 0;
>  
>  	if (sk) {
> +		s_state = READ_ONCE(sk->sk_state);
>  		u = unix_sk(sk);
> -		if (sock->type == SOCK_DGRAM) {
> -			nr_fds = atomic_read(&u->scm_stat.nr_fds);
> -			goto out_print;
> -		}
>  
> -		unix_state_lock(sk);
> -		if (sk->sk_state != TCP_LISTEN)
> +		/* SOCK_STREAM and SOCK_SEQPACKET sockets never change their
> +		 * sk_state after switching to TCP_ESTABLISHED or TCP_LISTEN.
> +		 * SOCK_DGRAM is ordinary. So, no lock is needed.
> +		 */
> +		if (sock->type == SOCK_DGRAM || s_state == TCP_ESTABLISHED)
>  			nr_fds = atomic_read(&u->scm_stat.nr_fds);
> -		else
> +		else if (s_state == TCP_LISTEN)
>  			nr_fds = unix_count_nr_fds(sk);
> -		unix_state_unlock(sk);
> -out_print:
> +
>  		seq_printf(m, "scm_fds: %u\n", nr_fds);
>  	}
>  }
