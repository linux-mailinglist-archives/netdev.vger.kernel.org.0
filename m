Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907963A3772
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 00:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFJW6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 18:58:20 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:20612 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFJW6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 18:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1623365784; x=1654901784;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R82nyUuxGqSGusSBGbWrIsDlie+YRw4RwNrKAYgaLA0=;
  b=FWoQxbE2blo3rhrySiLg6d8NX7s4W0qjshojTmPuPmua+YZuMEXK6VI8
   CDW4jYhDd6UiW0ukxIw9KkUvHGrcNulnRo+fiA1+8hr4CQjDN7rAcpUgU
   J8+qLeZg8u1nm2wV7NcDLDsTlga0I8iLvnih8EUjo8+finrD3r7Fc/aWp
   o=;
X-IronPort-AV: E=Sophos;i="5.83,264,1616457600"; 
   d="scan'208";a="6079187"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 10 Jun 2021 22:56:23 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-5dd976cd.us-east-1.amazon.com (Postfix) with ESMTPS id A33C8A25B2;
        Thu, 10 Jun 2021 22:56:18 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:56:18 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.41) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Thu, 10 Jun 2021 22:56:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <eric.dumazet@gmail.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kafai@fb.com>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v7 bpf-next 07/11] tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.
Date:   Fri, 11 Jun 2021 07:56:04 +0900
Message-ID: <20210610225604.618-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <89c4ce38-fe2c-1d80-f814-c4b3a5e4781d@gmail.com>
References: <89c4ce38-fe2c-1d80-f814-c4b3a5e4781d@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.41]
X-ClientProxiedBy: EX13D04UWA002.ant.amazon.com (10.43.160.31) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <eric.dumazet@gmail.com>
Date:   Thu, 10 Jun 2021 22:36:27 +0200
> On 5/21/21 8:21 PM, Kuniyuki Iwashima wrote:
> > This patch also changes the code to call reuseport_migrate_sock() and
> > inet_reqsk_clone(), but unlike the other cases, we do not call
> > inet_reqsk_clone() right after reuseport_migrate_sock().
> > 
> > Currently, in the receive path for TCP_NEW_SYN_RECV sockets, its listener
> > has three kinds of refcnt:
> > 
> >   (A) for listener itself
> >   (B) carried by reuqest_sock
> >   (C) sock_hold() in tcp_v[46]_rcv()
> > 
> > While processing the req, (A) may disappear by close(listener). Also, (B)
> > can disappear by accept(listener) once we put the req into the accept
> > queue. So, we have to hold another refcnt (C) for the listener to prevent
> > use-after-free.
> > 
> > For socket migration, we call reuseport_migrate_sock() to select a listener
> > with (A) and to increment the new listener's refcnt in tcp_v[46]_rcv().
> > This refcnt corresponds to (C) and is cleaned up later in tcp_v[46]_rcv().
> > Thus we have to take another refcnt (B) for the newly cloned request_sock.
> > 
> > In inet_csk_complete_hashdance(), we hold the count (B), clone the req, and
> > try to put the new req into the accept queue. By migrating req after
> > winning the "own_req" race, we can avoid such a worst situation:
> > 
> >   CPU 1 looks up req1
> >   CPU 2 looks up req1, unhashes it, then CPU 1 loses the race
> >   CPU 3 looks up req2, unhashes it, then CPU 2 loses the race
> >   ...
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Acked-by: Martin KaFai Lau <kafai@fb.com>
> > ---
> >  net/ipv4/inet_connection_sock.c | 34 ++++++++++++++++++++++++++++++---
> >  net/ipv4/tcp_ipv4.c             | 20 +++++++++++++------
> >  net/ipv4/tcp_minisocks.c        |  4 ++--
> >  net/ipv6/tcp_ipv6.c             | 14 +++++++++++---
> >  4 files changed, 58 insertions(+), 14 deletions(-)
> > 
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index c1f068464363..b795198f919a 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -1113,12 +1113,40 @@ struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> >  					 struct request_sock *req, bool own_req)
> >  {
> >  	if (own_req) {
> > -		inet_csk_reqsk_queue_drop(sk, req);
> > -		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
> > -		if (inet_csk_reqsk_queue_add(sk, req, child))
> > +		inet_csk_reqsk_queue_drop(req->rsk_listener, req);
> > +		reqsk_queue_removed(&inet_csk(req->rsk_listener)->icsk_accept_queue, req);
> > +
> > +		if (sk != req->rsk_listener) {
> > +			/* another listening sk has been selected,
> > +			 * migrate the req to it.
> > +			 */
> > +			struct request_sock *nreq;
> > +
> > +			/* hold a refcnt for the nreq->rsk_listener
> > +			 * which is assigned in inet_reqsk_clone()
> > +			 */
> > +			sock_hold(sk);
> > +			nreq = inet_reqsk_clone(req, sk);
> > +			if (!nreq) {
> > +				inet_child_forget(sk, req, child);
> 
> Don't you need a sock_put(sk) here ?

Yes.
If nreq == NULL, inet_reqsk_clone() calls sock_put().


> 
> \
> > +				goto child_put;
> > +			}
> > +
> > +			refcount_set(&nreq->rsk_refcnt, 1);
> > +			if (inet_csk_reqsk_queue_add(sk, nreq, child)) {
> > +				reqsk_migrate_reset(req);
> > +				reqsk_put(req);
> > +				return child;
> > +			}
> > +
> > +			reqsk_migrate_reset(nreq);
> > +			__reqsk_free(nreq);
> > +		} else if (inet_csk_reqsk_queue_add(sk, req, child)) {
> >  			return child;
> > +		}
> > 
