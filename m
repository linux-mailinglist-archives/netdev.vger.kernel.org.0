Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20C5E2CD8B7
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:16:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436682AbgLCONi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:13:38 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:34877 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgLCONh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:13:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607004816; x=1638540816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=5f0Fhu2AO04sPld9LC1LXYDFAHfWrn4XzNzhlsTgPH8=;
  b=ZIX/eAPdl8mYcQ2gw8LekgX+zSnojAynIFCS7lUh+jwN80p4kmbU/97S
   Z6ggSqXJRfuW5hE1RWyRsIyp3XGmezL2pGHIy1j6r8GUA/j9rpeOMVwu5
   kZ5Szui+gld9LRX8FW582+YJHSjVmrOm8luiMwWr4ESUTG2Uihuvxd3c9
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,389,1599523200"; 
   d="scan'208";a="68903082"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 03 Dec 2020 14:12:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id 9ACC3A1E42;
        Thu,  3 Dec 2020 14:12:51 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 3 Dec 2020 14:12:50 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.160.139) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 3 Dec 2020 14:12:45 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <kafai@fb.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 05/11] tcp: Migrate TCP_NEW_SYN_RECV requests.
Date:   Thu, 3 Dec 2020 23:12:40 +0900
Message-ID: <20201203141240.52810-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <6b34c251-05af-06c0-8003-858b6ae8d1fd@gmail.com>
References: <6b34c251-05af-06c0-8003-858b6ae8d1fd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.139]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Tue, 1 Dec 2020 16:13:39 +0100
> On 12/1/20 3:44 PM, Kuniyuki Iwashima wrote:
> > This patch renames reuseport_select_sock() to __reuseport_select_sock() and
> > adds two wrapper function of it to pass the migration type defined in the
> > previous commit.
> > 
> >   reuseport_select_sock          : BPF_SK_REUSEPORT_MIGRATE_NO
> >   reuseport_select_migrated_sock : BPF_SK_REUSEPORT_MIGRATE_REQUEST
> > 
> > As mentioned before, we have to select a new listener for TCP_NEW_SYN_RECV
> > requests at receiving the final ACK or sending a SYN+ACK. Therefore, this
> > patch also changes the code to call reuseport_select_migrated_sock() even
> > if the listening socket is TCP_CLOSE. If we can pick out a listening socket
> > from the reuseport group, we rewrite request_sock.rsk_listener and resume
> > processing the request.
> > 
> > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > ---
> >  include/net/inet_connection_sock.h | 12 +++++++++++
> >  include/net/request_sock.h         | 13 ++++++++++++
> >  include/net/sock_reuseport.h       |  8 +++----
> >  net/core/sock_reuseport.c          | 34 ++++++++++++++++++++++++------
> >  net/ipv4/inet_connection_sock.c    | 13 ++++++++++--
> >  net/ipv4/tcp_ipv4.c                |  9 ++++++--
> >  net/ipv6/tcp_ipv6.c                |  9 ++++++--
> >  7 files changed, 81 insertions(+), 17 deletions(-)
> > 
> > diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> > index 2ea2d743f8fc..1e0958f5eb21 100644
> > --- a/include/net/inet_connection_sock.h
> > +++ b/include/net/inet_connection_sock.h
> > @@ -272,6 +272,18 @@ static inline void inet_csk_reqsk_queue_added(struct sock *sk)
> >  	reqsk_queue_added(&inet_csk(sk)->icsk_accept_queue);
> >  }
> >  
> > +static inline void inet_csk_reqsk_queue_migrated(struct sock *sk,
> > +						 struct sock *nsk,
> > +						 struct request_sock *req)
> > +{
> > +	reqsk_queue_migrated(&inet_csk(sk)->icsk_accept_queue,
> > +			     &inet_csk(nsk)->icsk_accept_queue,
> > +			     req);
> > +	sock_put(sk);
> > +	sock_hold(nsk);
> 
> This looks racy to me. nsk refcount might be zero at this point.
> 
> If you think it can _not_ be zero, please add a big comment here,
> because this would mean something has been done before reaching this function,
> and this sock_hold() would be not needed in the first place.
> 
> There is a good reason reqsk_alloc() is using refcount_inc_not_zero().

Exactly, I will fix this in the next spin like below.
Thank you.

---8<---
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 1e0958f5eb21..d8c3be31e987 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -280,7 +280,6 @@ static inline void inet_csk_reqsk_queue_migrated(struct sock *sk,
                             &inet_csk(nsk)->icsk_accept_queue,
                             req);
        sock_put(sk);
-       sock_hold(nsk);
        req->rsk_listener = nsk;
 }
 
diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 6b475897b496..4d07bddcf678 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -386,7 +386,14 @@ EXPORT_SYMBOL(reuseport_select_sock);
 struct sock *reuseport_select_migrated_sock(struct sock *sk, u32 hash,
                                            struct sk_buff *skb)
 {
-       return __reuseport_select_sock(sk, hash, skb, 0, BPF_SK_REUSEPORT_MIGRATE_REQUEST);
+       struct sock *nsk;
+
+       nsk = __reuseport_select_sock(sk, hash, skb, 0, BPF_SK_REUSEPORT_MIGRATE_REQUEST);
+       if (IS_ERR_OR_NULL(nsk) ||
+           unlikely(!refcount_inc_not_zero(&nsk->sk_refcnt)))
+               return NULL;
+
+       return nsk;
 }
 EXPORT_SYMBOL(reuseport_select_migrated_sock);
 
---8<---


> > +	req->rsk_listener = nsk;
> > +}
> > +
> 
> Honestly, this patch series looks quite complex, and finding a bug in the
> very first function I am looking at is not really a good sign...

I also think this issue is quite complex, but it might be easier to fix
than it was disscussed in 2015 [1] thanks to your some refactoring.

https://lore.kernel.org/netdev/1443313848-751-1-git-send-email-tolga.ceylan@gmail.com/
