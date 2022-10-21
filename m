Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFD77607D45
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 19:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiJURRH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 13:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbiJURRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 13:17:06 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CEA186D52;
        Fri, 21 Oct 2022 10:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666372622; x=1697908622;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CV+NY/BAd5lnPCpeR2rWITvTgvey4xp2CjuPYqhTAMA=;
  b=HvW1ElULsN9qc1gdQwdWPH+0GRnvh8I5n97iZhVC+lRwmQfYxOQf9+bl
   Y8fKgkvvlGT5laMWsn7rWjAVu2QtZ8stGl/XHgfjT7jVG1qy5at9EPyPc
   eQGWN7eP4HxMLjT5dLKSVyRbssHe5IR59+pVNh/D+X/ar3YA/Xjteta6M
   c=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-8c5b1df3.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2022 17:16:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-8c5b1df3.us-west-2.amazon.com (Postfix) with ESMTPS id 60E80416F7;
        Fri, 21 Oct 2022 17:16:56 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Fri, 21 Oct 2022 17:16:55 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.179) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Fri, 21 Oct 2022 17:16:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <luwei32@huawei.com>
CC:     <asml.silence@gmail.com>, <ast@kernel.org>, <davem@davemloft.net>,
        <dsahern@kernel.org>, <edumazet@google.com>,
        <imagedong@tencent.com>, <kuba@kernel.org>, <kuniyu@amazon.com>,
        <linux-kernel@vger.kernel.org>, <martin.lau@kernel.org>,
        <ncardwell@google.com>, <netdev@vger.kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net,v3] tcp: fix a signed-integer-overflow bug in tcp_add_backlog()
Date:   Fri, 21 Oct 2022 10:16:42 -0700
Message-ID: <20221021171642.89090-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221021040622.815143-1-luwei32@huawei.com>
References: <20221021040622.815143-1-luwei32@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.179]
X-ClientProxiedBy: EX13D37UWA003.ant.amazon.com (10.43.160.25) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Lu Wei <luwei32@huawei.com>
Date:   Fri, 21 Oct 2022 12:06:22 +0800
> The type of sk_rcvbuf and sk_sndbuf in struct sock is int, and
> in tcp_add_backlog(), the variable limit is caculated by adding
> sk_rcvbuf, sk_sndbuf and 64 * 1024, it may exceed the max value
> of int and overflow. This patch reduces the limit budget by
> halving the sndbuf to solve this issue since ACK packets are much
> smaller than the payload.
> 
> Fixes: c9c3321257e1 ("tcp: add tcp_add_backlog()")
> Signed-off-by: Lu Wei <luwei32@huawei.com>

Acked-by: Kuniyuki Iwashima <kuniyu@amazon.com>


> ---
>  net/ipv4/tcp_ipv4.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index 7a250ef9d1b7..87d440f47a70 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -1874,11 +1874,13 @@ bool tcp_add_backlog(struct sock *sk, struct sk_buff *skb,
>  	__skb_push(skb, hdrlen);
>  
>  no_coalesce:
> +	limit = (u32)READ_ONCE(sk->sk_rcvbuf) + (u32)(READ_ONCE(sk->sk_sndbuf) >> 1);
> +
>  	/* Only socket owner can try to collapse/prune rx queues
>  	 * to reduce memory overhead, so add a little headroom here.
>  	 * Few sockets backlog are possibly concurrently non empty.
>  	 */
> -	limit = READ_ONCE(sk->sk_rcvbuf) + READ_ONCE(sk->sk_sndbuf) + 64*1024;
> +	limit += 64 * 1024;
>  
>  	if (unlikely(sk_add_backlog(sk, skb, limit))) {
>  		bh_unlock_sock(sk);
> -- 
> 2.31.1
