Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4ED2D9D72
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 18:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408449AbgLNRRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 12:17:25 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:44445 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408437AbgLNRRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 12:17:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607966243; x=1639502243;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=CQGamH5EYsnyVqy9qJ/OP61I+HLUicTHXTVqOFab65M=;
  b=NlHDFh7sfZed7QMgOrOeI9gW503fgeL3R6HBmt0gz/msPZ2GBwmkN6fl
   Vkg9/xuu9A7gT7dmVSLm6Fuocb2S+m2EChOkrWx8k45KZiwEU1JITSbni
   eEjLznBchHVki1JjLnlL0afCGmNsWzBZ1WPMCkoTX99WylGsm/NuoIuEE
   4=;
X-IronPort-AV: E=Sophos;i="5.78,420,1599523200"; 
   d="scan'208";a="72514614"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 14 Dec 2020 17:16:42 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 7F641A198E;
        Mon, 14 Dec 2020 17:16:39 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 17:16:38 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.223) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Dec 2020 17:16:34 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <ast@kernel.org>, <benh@amazon.com>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>,
        <edumazet@google.com>, <eric.dumazet@gmail.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 bpf-next 03/11] tcp: Migrate TCP_ESTABLISHED/TCP_SYN_RECV sockets in accept queues.
Date:   Tue, 15 Dec 2020 02:16:30 +0900
Message-ID: <20201214171630.62542-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201210193340.x6qdykdalhdebxv3@kafai-mbp.dhcp.thefacebook.com>
References: <20201210193340.x6qdykdalhdebxv3@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.223]
X-ClientProxiedBy: EX13D45UWA003.ant.amazon.com (10.43.160.92) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Thu, 10 Dec 2020 11:33:40 -0800
> On Thu, Dec 10, 2020 at 02:58:10PM +0900, Kuniyuki Iwashima wrote:
> 
> [ ... ]
> 
> > > > I've implemented one-by-one migration only for the accept queue for now.
> > > > In addition to the concern about TFO queue,
> > > You meant this queue:  queue->fastopenq.rskq_rst_head?
> > 
> > Yes.
> > 
> > 
> > > Can "req" be passed?
> > > I did not look up the lock/race in details for that though.
> > 
> > I think if we rewrite freeing TFO requests part like one of accept queue
> > using reqsk_queue_remove(), we can also migrate them.
> > 
> > In this patchset, selecting a listener for accept queue, the TFO queue of
> > the same listener is also migrated to another listener in order to prevent
> > TFO spoofing attack.
> > 
> > If the request in the accept queue is migrated one by one, I am wondering
> > which should the request in TFO queue be migrated to prevent attack or
> > freed.
> > 
> > I think user need not know about keeping such requests in kernel to prevent
> > attacks, so passing them to eBPF prog is confusing. But, redistributing
> > them randomly without user's intention can make some irrelevant listeners
> > unnecessarily drop new TFO requests, so this is also bad. Moreover, freeing
> > such requests seems not so good in the point of security.
> The current behavior (during process restart) is also not carrying this
> security queue.  Not carrying them in this patch will make it
> less secure than the current behavior during process restart?

No, I thought I could make it more secure.


> Do you need it now or it is something that can be considered for later
> without changing uapi bpf.h?

No, I do not need it for any other reason, so I will simply free the
requests in TFO queue.
Thank you.


> > > > ---8<---
> > > > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > > > index a82fd4c912be..d0ddd3cb988b 100644
> > > > --- a/net/ipv4/inet_connection_sock.c
> > > > +++ b/net/ipv4/inet_connection_sock.c
> > > > @@ -1001,6 +1001,29 @@ struct sock *inet_csk_reqsk_queue_add(struct sock *sk,
> > > >  }
> > > >  EXPORT_SYMBOL(inet_csk_reqsk_queue_add);
> > > >  
> > > > +static bool inet_csk_reqsk_queue_migrate(struct sock *sk, struct sock *nsk, struct request_sock *req)
> > > > +{
> > > > +       struct request_sock_queue *queue = &inet_csk(nsk)->icsk_accept_queue;
> > > > +       bool migrated = false;
> > > > +
> > > > +       spin_lock(&queue->rskq_lock);
> > > > +       if (likely(nsk->sk_state == TCP_LISTEN)) {
> > > > +               migrated = true;
> > > > +
> > > > +               req->dl_next = NULL;
> > > > +               if (queue->rskq_accept_head == NULL)
> > > > +                       WRITE_ONCE(queue->rskq_accept_head, req);
> > > > +               else
> > > > +                       queue->rskq_accept_tail->dl_next = req;
> > > > +               queue->rskq_accept_tail = req;
> > > > +               sk_acceptq_added(nsk);
> > > > +               inet_csk_reqsk_queue_migrated(sk, nsk, req);
> > > need to first resolve the question raised in patch 5 regarding
> > > to the update on req->rsk_listener though.
> > 
> > In the unhash path, it is also safe to call sock_put() for the old listner.
> > 
> > In inet_csk_listen_stop(), the sk_refcnt of the listener >= 1. If the
> > listener does not have immature requests, sk_refcnt is 1 and freed in
> > __tcp_close().
> > 
> >   sock_hold(sk) in __tcp_close()
> >   sock_put(sk) in inet_csk_destroy_sock()
> >   sock_put(sk) in __tcp_clsoe()
> I don't see how it is different here than in patch 5.
> I could be missing something.
> 
> Lets contd the discussion on the other thread (patch 5) first.

The listening socket has two kinds of refcounts for itself(1) and
requests(n). I think the listener has its own refcount at least in
inet_csk_listen_stop(), so sock_put() here never free the listener.
