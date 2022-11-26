Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85CE96398F0
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 00:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiKZXgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 18:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiKZXgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 18:36:20 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C33E0BB
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 15:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1669505779; x=1701041779;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=99vsZ679A2Zq3mEmyTVRLSSRWrDd7DGiUIs4xKOMrMs=;
  b=BmJD/ASZXLvEZCZtQDcHuT9ALXb4P6e324KjXCBT5ybnQQoO5B8p0VuR
   vUNBHhTOomgRfCxn+FaFeWMwAzF6KVfdK7eC5+yyncXJIMkQy4+hjL763
   MFTkgfIA37/tN0AtnV2rCStnLaYlt1dXF67PwszHBw0uUYGhJiRXhy2DK
   s=;
X-IronPort-AV: E=Sophos;i="5.96,197,1665446400"; 
   d="scan'208";a="271084951"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2022 23:36:16 +0000
Received: from EX13MTAUWC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-e7094f15.us-west-2.amazon.com (Postfix) with ESMTPS id 44EE741874;
        Sat, 26 Nov 2022 23:36:15 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Sat, 26 Nov 2022 23:36:14 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.134) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Sat, 26 Nov 2022 23:36:11 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <tkhai@ya.ru>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuniyu@amazon.com>, <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH net v2] unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()
Date:   Sun, 27 Nov 2022 08:35:59 +0900
Message-ID: <20221126233559.31979-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <bd4d533b-15d2-6c0a-7667-70fd95dbea20@ya.ru>
References: <bd4d533b-15d2-6c0a-7667-70fd95dbea20@ya.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D37UWA001.ant.amazon.com (10.43.160.61) To
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
Date:   Sun, 27 Nov 2022 01:46:51 +0300
> There is a race resulting in alive SOCK_SEQPACKET socket
> may change its state from TCP_ESTABLISHED to TCP_CLOSE:
> 
> unix_release_sock(peer)                  unix_dgram_sendmsg(sk)
>   sock_orphan(peer)
>     sock_set_flag(peer, SOCK_DEAD)
>                                            sock_alloc_send_pskb()
>                                              if !(sk->sk_shutdown & SEND_SHUTDOWN)
>                                                OK
>                                            if sock_flag(peer, SOCK_DEAD)
>                                              sk->sk_state = TCP_CLOSE
>   sk->sk_shutdown = SHUTDOWN_MASK
> 
> 
> After that socket sk remains almost normal: it is able to connect, listen, accept
> and recvmsg, while it can't sendmsg.
> 
> Since this is the only possibility for alive SOCK_SEQPACKET to change
> the state in such way, we should better fix this strange and potentially
> danger corner case.
> 
> Also, move TCP_CLOSE assignment for SOCK_DGRAM sockets under state lock
> to fix race with unix_dgram_connect():
> 
> unix_dgram_connect(other)            unix_dgram_sendmsg(sk)
>                                        unix_peer(sk) = NULL
>                                        unix_state_unlock(sk)
>   unix_state_double_lock(sk, other)
>   sk->sk_state  = TCP_ESTABLISHED
>   unix_peer(sk) = other
>   unix_state_double_unlock(sk, other)
>                                        sk->sk_state  = TCP_CLOSED
> 
> This patch fixes both of these races.
> 
> Fixes: 83301b5367a9 ("af_unix: Set TCP_ESTABLISHED for datagram sockets too")
> Suggested-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> Signed-off-by: Kirill Tkhai <tkhai@ya.ru>

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Thank you, Kirill.


> ---
> v2: Disconnect from peer right there.
> 
>  net/unix/af_unix.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
> index b3545fc68097..be40023a61fb 100644
> --- a/net/unix/af_unix.c
> +++ b/net/unix/af_unix.c
> @@ -2001,11 +2001,14 @@ static int unix_dgram_sendmsg(struct socket *sock, struct msghdr *msg,
>  		err = 0;
>  		if (unix_peer(sk) == other) {
>  			unix_peer(sk) = NULL;
> -			unix_dgram_peer_wake_disconnect_wakeup(sk, other);
> +
> +			if (sk->sk_type == SOCK_DGRAM) {
> +				unix_dgram_peer_wake_disconnect_wakeup(sk, other);
> +				sk->sk_state = TCP_CLOSE;
> +			}
>  
>  			unix_state_unlock(sk);
>  
> -			sk->sk_state = TCP_CLOSE;
>  			unix_dgram_disconnected(sk, other);
>  			sock_put(other);
>  			err = -ECONNREFUSED;

