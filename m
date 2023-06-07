Return-Path: <netdev+bounces-8934-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11AEB726571
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FC551C20B78
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10A79370F5;
	Wed,  7 Jun 2023 16:05:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B9D370EF
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:05:54 +0000 (UTC)
Received: from smtp-fw-80008.amazon.com (smtp-fw-80008.amazon.com [99.78.197.219])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220741BE8;
	Wed,  7 Jun 2023 09:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1686153948; x=1717689948;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=afQPSzc3yF2P6Gyj9XEF07/hZuyAqwb1MSfDPmaFlck=;
  b=B0cd0RHJVRt5IIou1ic8NNkoZWiEZrbZwTs69y4ZdUxxPqcR/Re4sQ+P
   tR820YIH8WtixqEytbq2ybieZQ7Or61GClwN4QGdWcQyAcrjsPbxiR6Rf
   EfSNPjRhNbPHogt+o6I6PbMbiEUvbvhoKVlA7m42A58ctm6ggRL+x6ABl
   4=;
X-IronPort-AV: E=Sophos;i="6.00,224,1681171200"; 
   d="scan'208";a="8765929"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80008.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 16:05:45 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
	by email-inbound-relay-pdx-2b-m6i4x-7fa2de02.us-west-2.amazon.com (Postfix) with ESMTPS id 5BF1D413CA;
	Wed,  7 Jun 2023 16:05:42 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 7 Jun 2023 16:05:40 +0000
Received: from 88665a182662.ant.amazon.com (10.119.185.127) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 7 Jun 2023 16:05:36 +0000
From: Kuniyuki Iwashima <kuniyu@amazon.com>
To: <dhowells@redhat.com>
CC: <axboe@kernel.dk>, <borisp@nvidia.com>, <chuck.lever@oracle.com>,
	<cong.wang@bytedance.com>, <davem@davemloft.net>, <dsahern@kernel.org>,
	<edumazet@google.com>, <john.fastabend@gmail.com>, <kuba@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <tom@herbertland.com>,
	<tom@quantonium.net>, <torvalds@linux-foundation.org>,
	<willemdebruijn.kernel@gmail.com>, <willy@infradead.org>, <kuniyu@amazon.com>
Subject: Re: [PATCH net-next v5 09/14] kcm: Use splice_eof() to flush
Date: Wed, 7 Jun 2023 09:05:28 -0700
Message-ID: <20230607160528.20078-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230607140559.2263470-10-dhowells@redhat.com>
References: <20230607140559.2263470-10-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.185.127]
X-ClientProxiedBy: EX19D038UWB003.ant.amazon.com (10.13.139.157) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
Precedence: Bulk
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: David Howells <dhowells@redhat.com>
Date: Wed,  7 Jun 2023 15:05:54 +0100
> Allow splice to undo the effects of MSG_MORE after prematurely ending a
> splice/sendfile due to getting an EOF condition (->splice_read() returned
> 0) after splice had called sendmsg() with MSG_MORE set when the user didn't
> set MSG_MORE.
> 
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Link: https://lore.kernel.org/r/CAHk-=wh=V579PDYvkpnTobCLGczbgxpMgGmmhqiTyE34Cpi5Gg@mail.gmail.com/
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Tom Herbert <tom@herbertland.com>
> cc: Tom Herbert <tom@quantonium.net>
> cc: Cong Wang <cong.wang@bytedance.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Eric Dumazet <edumazet@google.com>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netdev@vger.kernel.org
> ---
>  net/kcm/kcmsock.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
> index ba22af16b96d..d0d8c54562d6 100644
> --- a/net/kcm/kcmsock.c
> +++ b/net/kcm/kcmsock.c
> @@ -968,6 +968,19 @@ static int kcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>  	return err;
>  }
>  
> +static void kcm_splice_eof(struct socket *sock)
> +{
> +	struct sock *sk = sock->sk;
> +	struct kcm_sock *kcm = kcm_sk(sk);
> +
> +	if (skb_queue_empty(&sk->sk_write_queue))

nit: would be better to use skb_queue_empty_lockless().


> +		return;
> +
> +	lock_sock(sk);
> +	kcm_write_msgs(kcm);
> +	release_sock(sk);
> +}
> +
>  static ssize_t kcm_sendpage(struct socket *sock, struct page *page,
>  			    int offset, size_t size, int flags)
>  
> @@ -1773,6 +1786,7 @@ static const struct proto_ops kcm_dgram_ops = {
>  	.sendmsg =	kcm_sendmsg,
>  	.recvmsg =	kcm_recvmsg,
>  	.mmap =		sock_no_mmap,
> +	.splice_eof =	kcm_splice_eof,
>  	.sendpage =	kcm_sendpage,
>  };
>  
> @@ -1794,6 +1808,7 @@ static const struct proto_ops kcm_seqpacket_ops = {
>  	.sendmsg =	kcm_sendmsg,
>  	.recvmsg =	kcm_recvmsg,
>  	.mmap =		sock_no_mmap,
> +	.splice_eof =	kcm_splice_eof,
>  	.sendpage =	kcm_sendpage,
>  	.splice_read =	kcm_splice_read,
>  };

