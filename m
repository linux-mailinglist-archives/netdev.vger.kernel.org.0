Return-Path: <netdev+bounces-5757-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC2CD712A8A
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:23:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6518F1C210A5
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4DD2772C;
	Fri, 26 May 2023 16:23:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BEE2770A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:23:43 +0000 (UTC)
Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA8D1BC
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1685118218; x=1716654218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wqre3bxxTbDd5AE2xCdQtiYMSqdjU5WnIDUeEmEF/eU=;
  b=TCPvZykFXt4umwXJeYseCUCPb5DixmrecWrzbWj/aaXqTpZudn5RSn66
   vc6vuPngNu49z4tqZp2P+j22bpKp4SMJVo6AuEKfx3y6xvMkG3v2a4siE
   /KfhHslFdMoOlKM+ZdufLNLgB0sqR0jbYB3BACdr0SyQPOqWXXSrN4SNI
   I=;
X-IronPort-AV: E=Sophos;i="6.00,194,1681171200"; 
   d="scan'208";a="585615736"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 16:23:35 +0000
Received: from EX19MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-32fb4f1a.us-west-2.amazon.com (Postfix) with ESMTPS id ED49CC1642;
	Fri, 26 May 2023 16:23:33 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 26 May 2023 16:23:33 +0000
Received: from 88665a182662.ant.amazon.com (10.88.130.94) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Fri, 26 May 2023 16:23:31 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
	<kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>,
	<willemb@google.com>
Subject: [PATCH net] af_packet: do not use READ_ONCE() in packet_bind()
Date: Fri, 26 May 2023 09:23:20 -0700
Message-ID: <20230526162320.5816-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230526154342.2533026-1-edumazet@google.com>
References: <20230526154342.2533026-1-edumazet@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.88.130.94]
X-ClientProxiedBy: EX19D046UWB001.ant.amazon.com (10.13.139.187) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 15:43:42 +0000
> A recent patch added READ_ONCE() in packet_bind() and packet_bind_spkt()
> 
> This is better handled by reading pkt_sk(sk)->num later
> in packet_do_bind() while appropriate lock is held.
> 
> READ_ONCE() in writers are often an evidence of something being wrong.
> 
> Fixes: 822b5a1c17df ("af_packet: Fix data-races of pkt_sk(sk)->num.")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> Cc: Willem de Bruijn <willemb@google.com>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thanks!


> ---
>  net/packet/af_packet.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
> index a1f9a0e9f3c8a72e5a95f96473b7b6c63f893935..a2dbeb264f260e5b8923ece9aac99fe19ddfeb62 100644
> --- a/net/packet/af_packet.c
> +++ b/net/packet/af_packet.c
> @@ -3201,6 +3201,9 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
>  
>  	lock_sock(sk);
>  	spin_lock(&po->bind_lock);
> +	if (!proto)
> +		proto = po->num;
> +
>  	rcu_read_lock();
>  
>  	if (po->fanout) {
> @@ -3299,7 +3302,7 @@ static int packet_bind_spkt(struct socket *sock, struct sockaddr *uaddr,
>  	memcpy(name, uaddr->sa_data, sizeof(uaddr->sa_data_min));
>  	name[sizeof(uaddr->sa_data_min)] = 0;
>  
> -	return packet_do_bind(sk, name, 0, READ_ONCE(pkt_sk(sk)->num));
> +	return packet_do_bind(sk, name, 0, 0);
>  }
>  
>  static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
> @@ -3316,8 +3319,7 @@ static int packet_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len
>  	if (sll->sll_family != AF_PACKET)
>  		return -EINVAL;
>  
> -	return packet_do_bind(sk, NULL, sll->sll_ifindex,
> -			      sll->sll_protocol ? : READ_ONCE(pkt_sk(sk)->num));
> +	return packet_do_bind(sk, NULL, sll->sll_ifindex, sll->sll_protocol);
>  }
>  
>  static struct proto packet_proto = {
> -- 
> 2.41.0.rc0.172.g3f132b7071-goog

