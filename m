Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E093075F6
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 13:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhA1M0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 07:26:24 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:22687 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbhA1MYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 07:24:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1611836681; x=1643372681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=DymNgAN7fANbzQT7lS3cFouNRshO2mbPQxpOadj7G5A=;
  b=qR+wKT825ctVAyGO/9DqFvSN9uAugvvyWDKvH0L8ayCfA9RAXvYEUbv+
   Af6BFrhSGtmRty/m/mGf3hml2S+UvUl1xNLFXzKvEZ03fGVugoEHz9umE
   CBiMG7A49Z+NYSPoJ+Esj/sdwV7t80lFjMp/h/tIHLxOkE0oRCO0aQwIO
   g=;
X-IronPort-AV: E=Sophos;i="5.79,382,1602547200"; 
   d="scan'208";a="82172617"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 28 Jan 2021 12:24:00 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 724C7A19B1;
        Thu, 28 Jan 2021 12:23:57 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 12:23:56 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.94) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 28 Jan 2021 12:23:52 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <ttoukan.linux@gmail.com>
CC:     <aams@amazon.de>, <borisp@mellanox.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <kuni1840@gmail.com>,
        <kuniyu@amazon.co.jp>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <tariqt@mellanox.com>
Subject: Re: [PATCH v3 net-next] net: Remove redundant calls of sk_tx_queue_clear().
Date:   Thu, 28 Jan 2021 21:23:47 +0900
Message-ID: <20210128122347.74746-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <6f77d50f-b658-b751-5ac4-caaf9876f287@gmail.com>
References: <6f77d50f-b658-b751-5ac4-caaf9876f287@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.94]
X-ClientProxiedBy: EX13D27UWB002.ant.amazon.com (10.43.161.167) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Tariq Toukan <ttoukan.linux@gmail.com>
Date:   Thu, 28 Jan 2021 13:07:26 +0200
> On 1/28/2021 4:19 AM, Kuniyuki Iwashima wrote:
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
> > Therefore, this patch adds a runtime 
> 
> compile-time

Oh, shame on me...
I'll fix it in the next spin.

Thank you,
Kuniyuki


> > check to take care of the order of
> > sock_copy() and sk_tx_queue_clear() and removes sk_tx_queue_clear() from
> > sk_prot_alloc() so that it does the only allocation and its callers
> > initialize fields.
> > 
> > v3:
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
