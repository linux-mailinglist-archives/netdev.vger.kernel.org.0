Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698903815B4
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 06:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhEOEUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 00:20:00 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:4508 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhEOET7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 00:19:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621052327; x=1652588327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mzpXCfQcHSPEy32cQY3BR9AivtqvnparTIG4WZ7VIYA=;
  b=IoqLctWaYsfCPBwn5PO41OQ2yzEA0G+t2CUPH7ICGXCLQ8M2YbSP5xva
   zHEPVnxA5Dk50sniAb72PchABwl8dNT1Jw9wBNUStJsmaE4yVMZ5gRrdZ
   bhTkX+SnZvtDplHv4KURHXrwH9dVxrHxNajRDpLKNoKJHJy8LUyJmpJ7j
   o=;
X-IronPort-AV: E=Sophos;i="5.82,300,1613433600"; 
   d="scan'208";a="112350359"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 15 May 2021 04:18:46 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2a-538b0bfb.us-west-2.amazon.com (Postfix) with ESMTPS id D7FC3A07D6;
        Sat, 15 May 2021 04:18:42 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:18:42 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.216) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Sat, 15 May 2021 04:18:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <kafai@fb.com>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <benh@amazon.com>,
        <bpf@vger.kernel.org>, <daniel@iogearbox.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 bpf-next 07/11] tcp: Migrate TCP_NEW_SYN_RECV requests at receiving the final ACK.
Date:   Sat, 15 May 2021 13:18:34 +0900
Message-ID: <20210515041834.81591-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210515011305.eeblnqnov4xlcjfy@kafai-mbp>
References: <20210515011305.eeblnqnov4xlcjfy@kafai-mbp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.216]
X-ClientProxiedBy: EX13D21UWB004.ant.amazon.com (10.43.161.221) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Martin KaFai Lau <kafai@fb.com>
Date:   Fri, 14 May 2021 18:13:05 -0700
> On Mon, May 10, 2021 at 12:44:29PM +0900, Kuniyuki Iwashima wrote:
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index e690d1cff36e..fe666dc5c621 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -1075,10 +1075,38 @@ struct sock *inet_csk_complete_hashdance(struct sock *sk, struct sock *child,
> >  	if (own_req) {
> >  		inet_csk_reqsk_queue_drop(sk, req);
> >  		reqsk_queue_removed(&inet_csk(sk)->icsk_accept_queue, req);
> In the migration case 'sk != req->rsk_listener', is sk the right
> one to pass in the above two functions?

Good catch, 'sk' should be 'req->rsk_listener' here.
Thank you!


> 
> > -		if (inet_csk_reqsk_queue_add(sk, req, child))
> > +
> > +		if (sk != req->rsk_listener) {
> > +			/* another listening sk has been selected,
> > +			 * migrate the req to it.
> > +			 */
> > +			struct request_sock *nreq;
> > +
> > +			/* hold a refcnt for the nreq->rsk_listener
> > +			 * which is assigned in reqsk_clone()
> > +			 */
> > +			sock_hold(sk);
> > +			nreq = reqsk_clone(req, sk);
> > +			if (!nreq) {
> > +				inet_child_forget(sk, req, child);
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
> >  	}
> >  	/* Too bad, another child took ownership of the request, undo. */
> > +child_put:
> >  	bh_unlock_sock(child);
> >  	sock_put(child);
> >  	return NULL;
