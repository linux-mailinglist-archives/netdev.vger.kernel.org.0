Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D363E3078CC
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231724AbhA1O4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:56:37 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:3334 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231836AbhA1Oul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 09:50:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1611845441; x=1643381441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=1J+oWCFFLm5nmI0jYaiMUix7ZpaSaKjUbOlvFe4ZQJM=;
  b=OyXWkxyBWYWsCqItKjATmbTAdZHz4JZIp43H/irIZUlYQ2C8lvR0FrDK
   d2bMkJI+1AbDv7rBADs3K9UFHaahtV4gkPgFI/zvSS914M91j5w7YDxO6
   qAC/njQ0X/SnJQQHTHo1Af7dVV5DpGvukRnORw9/2aJ1bXU0erUoG5aol
   c=;
X-IronPort-AV: E=Sophos;i="5.79,382,1602547200"; 
   d="scan'208";a="115397803"
Received: from sea3-co-svc-lb6-vlan2.sea.amazon.com (HELO email-inbound-relay-1a-67b371d8.us-east-1.amazon.com) ([10.47.22.34])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 28 Jan 2021 14:49:58 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-67b371d8.us-east-1.amazon.com (Postfix) with ESMTPS id 1682FA22B8;
        Thu, 28 Jan 2021 14:49:54 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 14:49:53 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.239) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 14:49:44 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <ttoukan.linux@gmail.com>
CC:     <aams@amazon.de>, <borisp@mellanox.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <tariqt@mellanox.com>
Subject: Re: [PATCH v4 net-next] net: Remove redundant calls of sk_tx_queue_clear().
Date:   Thu, 28 Jan 2021 23:49:39 +0900
Message-ID: <20210128144939.4477-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <fad76e94-ca1f-41f6-f1aa-f9853f64d36d@gmail.com>
References: <fad76e94-ca1f-41f6-f1aa-f9853f64d36d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.239]
X-ClientProxiedBy: EX13D04UWB003.ant.amazon.com (10.43.161.231) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Tariq Toukan <ttoukan.linux@gmail.com>
Date:   Thu, 28 Jan 2021 15:09:51 +0200
> On 1/28/2021 2:42 PM, Kuniyuki Iwashima wrote:
> > The commit 41b14fb8724d ("net: Do not clear the sock TX queue in
> > sk_set_socket()") removes sk_tx_queue_clear() from sk_set_socket() and adds
> > it instead in sk_alloc() and sk_clone_lock() to fix an issue introduced in
> > the commit e022f0b4a03f ("net: Introduce sk_tx_queue_mapping"). On the
> > other hand, the original commit had already put sk_tx_queue_clear() in
> > sk_prot_alloc(): the callee of sk_alloc() and sk_clone_lock(). Thus
> > sk_tx_queue_clear() is called twice in each path.
> > 
> > If we remove sk_tx_queue_clear() in sk_alloc() and sk_clone_lock(), it
> > currently works well because (i) sk_tx_queue_mapping is defined between
> > sk_dontcopy_begin and sk_dontcopy_end, and (ii) sock_copy() called after
> > sk_prot_alloc() in sk_clone_lock() does not overwrite sk_tx_queue_mapping.
> > However, if we move sk_tx_queue_mapping out of the no copy area, it
> > introduces a bug unintentionally.
> > 
> > Therefore, this patch adds a compile-time check to take care of the order
> > of sock_copy() and sk_tx_queue_clear() and removes sk_tx_queue_clear() from
> > sk_prot_alloc() so that it does the only allocation and its callers
> > initialize fields.
> > 
> > v4:
> > * Fix typo in the changelog (runtime -> compile-time)
> > 
> > v3: https://lore.kernel.org/netdev/20210128021905.57471-1-kuniyu@amazon.co.jp/
> > * Remove Fixes: tag
> > * Add BUILD_BUG_ON
> > * Remove sk_tx_queue_clear() from sk_prot_alloc()
> >    instead of sk_alloc() and sk_clone_lock()
> > 
> > v2: https://lore.kernel.org/netdev/20210127132215.10842-1-kuniyu@amazon.co.jp/
> > * Remove Reviewed-by: tag
> > 
> > v1: https://lore.kernel.org/netdev/20210127125018.7059-1-kuniyu@amazon.co.jp/
> > 
> 
> Sorry for not pointing this out earlier, but shouldn't the changelog 
> come after the --- separator? Unless you want it to appear as part of 
> the commit message.
> 
> Other than that, I think now I'm fine with the patch.
> 
> Acked-by: Tariq Toukan <tariqt@nvidia.com>
> 
> Thanks,
> Tariq

Oh, I didn't know that useful behaviour, thank you!

I will respin with your Acked-by tag.


> > CC: Tariq Toukan <tariqt@mellanox.com>
> > CC: Boris Pismenny <borisp@mellanox.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >   net/core/sock.c | 11 ++++++++++-
> >   1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index bbcd4b97eddd..cfbd62a5e079 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -1657,6 +1657,16 @@ static void sock_copy(struct sock *nsk, const struct sock *osk)
> >   #ifdef CONFIG_SECURITY_NETWORK
> >   	void *sptr = nsk->sk_security;
> >   #endif
> > +
> > +	/* If we move sk_tx_queue_mapping out of the private section,
> > +	 * we must check if sk_tx_queue_clear() is called after
> > +	 * sock_copy() in sk_clone_lock().
> > +	 */
> > +	BUILD_BUG_ON(offsetof(struct sock, sk_tx_queue_mapping) <
> > +		     offsetof(struct sock, sk_dontcopy_begin) ||
> > +		     offsetof(struct sock, sk_tx_queue_mapping) >=
> > +		     offsetof(struct sock, sk_dontcopy_end));
> > +
> >   	memcpy(nsk, osk, offsetof(struct sock, sk_dontcopy_begin));
> >   
> >   	memcpy(&nsk->sk_dontcopy_end, &osk->sk_dontcopy_end,
> > @@ -1690,7 +1700,6 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
> >   
> >   		if (!try_module_get(prot->owner))
> >   			goto out_free_sec;
> > -		sk_tx_queue_clear(sk);
> >   	}
> >   
> >   	return sk;
> > 
