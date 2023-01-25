Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 487AE67A896
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjAYCIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYCIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:08:30 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8BF12F3C;
        Tue, 24 Jan 2023 18:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1674612510; x=1706148510;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=StO2B3+SkxPnmUUphJaMyWwiTNn/O245LfaGTUv7oaM=;
  b=NEseewRkxYiwM6st66qNo2WNhU+mgYHeEt0ge1C9QmQHd9qLTVCxR1aj
   RJmAUaktWBjRE0H9hfWXp6XdZsDDrEuknvb7u7JejyaA2q6heHhyS/8s8
   AuEISzuI6rd69XZTuTvyj8dSuXD0lGXkyhxxA86Ote5GTuhzjW11Pj3U/
   w=;
X-IronPort-AV: E=Sophos;i="5.97,244,1669075200"; 
   d="scan'208";a="291893849"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2023 02:08:28 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-m6i4x-366646a6.us-east-1.amazon.com (Postfix) with ESMTPS id 0C939ABE83;
        Wed, 25 Jan 2023 02:08:25 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Wed, 25 Jan 2023 02:08:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.120) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.7;
 Wed, 25 Jan 2023 02:08:21 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     <v4bel@theori.io>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <imv4bel@gmail.com>,
        <kuba@kernel.org>, <linux-hams@vger.kernel.org>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <ralf@linux-mips.org>, <kuniyu@amazon.com>
Subject: Re: [PATCH v2] net/rose: Fix to not accept on connected socket
Date:   Tue, 24 Jan 2023 18:08:09 -0800
Message-ID: <20230125020809.67989-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230123194020.GA115501@ubuntu>
References: <20230123194020.GA115501@ubuntu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D38UWC003.ant.amazon.com (10.43.162.23) To
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

From:   Hyunwoo Kim <v4bel@theori.io>
Date:   Mon, 23 Jan 2023 11:40:20 -0800
> If listen() and accept() are called on a rose socket
> that connect() is successful, accept() succeeds immediately.
> This is because rose_connect() queues the skb to
> sk->sk_receive_queue, and rose_accept() dequeues it.
> 
> This creates a child socket with the sk of the parent
> rose socket, which can cause confusion.
> 
> Fix rose_listen() to return -EINVAL if the socket has
> already been successfully connected, and add lock_sock
> to prevent this issue.
> 
> Signed-off-by: Hyunwoo Kim <v4bel@theori.io>

Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>


> ---
>  net/rose/af_rose.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
> index 36fefc3957d7..ca2b17f32670 100644
> --- a/net/rose/af_rose.c
> +++ b/net/rose/af_rose.c
> @@ -488,6 +488,12 @@ static int rose_listen(struct socket *sock, int backlog)
>  {
>  	struct sock *sk = sock->sk;
>  
> +	lock_sock(sk);
> +	if (sock->state != SS_UNCONNECTED) {
> +		release_sock(sk);
> +		return -EINVAL;
> +	}
> +
>  	if (sk->sk_state != TCP_LISTEN) {
>  		struct rose_sock *rose = rose_sk(sk);
>  
> @@ -497,8 +503,10 @@ static int rose_listen(struct socket *sock, int backlog)
>  		memset(rose->dest_digis, 0, AX25_ADDR_LEN * ROSE_MAX_DIGIS);
>  		sk->sk_max_ack_backlog = backlog;
>  		sk->sk_state           = TCP_LISTEN;
> +		release_sock(sk);
>  		return 0;
>  	}
> +	release_sock(sk);
>  
>  	return -EOPNOTSUPP;
>  }
> -- 
> 2.25.1

