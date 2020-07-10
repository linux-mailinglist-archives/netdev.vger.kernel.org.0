Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB8421B9D1
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 17:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728049AbgGJPrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 11:47:24 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:14836 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgGJPrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 11:47:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1594396042; x=1625932042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=X62DW2Ha1XlXs8KtW1XmLJlcsgZJdMHE4UdVxcuIwMQ=;
  b=TMqtL6VkA4ECeMJmhsL8J0kXcw2I5ft7Nvc4fjHXe+kS2wkKMWzcIuW/
   AbmrFSZ/ERp9syj470zxLTYdv/26HUfM5OMI3tH/EM2oEb/W1yUkINfv2
   alWR4SRNosxxDR4hb6fWBgvic3W30TlvLUB40H4/87XSZtnOHRr9J78FM
   4=;
IronPort-SDR: 75JYLA2iuiseXTJ6E0MBJDGTUK0u+RG7wPRDp5aOP7pkqbFDXPJ9zr3iEqTVXU6awcDAQ8REYF
 aZJZWnqjeLag==
X-IronPort-AV: E=Sophos;i="5.75,336,1589241600"; 
   d="scan'208";a="58877940"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 10 Jul 2020 15:47:15 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-37fd6b3d.us-east-1.amazon.com (Postfix) with ESMTPS id E774E28227D;
        Fri, 10 Jul 2020 15:47:12 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 15:47:11 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.140) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 10 Jul 2020 15:47:07 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <edumazet@google.com>
CC:     <benh@amazon.com>, <davem@davemloft.net>, <ja@ssi.bg>,
        <kuba@kernel.org>, <kuni1840@gmail.com>, <kuniyu@amazon.co.jp>,
        <kuznet@ms2.inr.ac.ru>, <netdev@vger.kernel.org>,
        <osa-contribution-log@amazon.com>, <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH v3 net-next] inet: Remove an unnecessary argument of syn_ack_recalc().
Date:   Sat, 11 Jul 2020 00:47:01 +0900
Message-ID: <20200710154701.84658-1-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <CANn89iJsC73o9hJ_RUd9qfv50ebt2H5VZx0-xgrPXFAZVWeGgQ@mail.gmail.com>
References: <CANn89iJsC73o9hJ_RUd9qfv50ebt2H5VZx0-xgrPXFAZVWeGgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.140]
X-ClientProxiedBy: EX13D03UWC001.ant.amazon.com (10.43.162.136) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Jul 2020 08:20:03 -0700
> On Fri, Jul 10, 2020 at 7:11 AM Kuniyuki Iwashima <kuniyu@amazon.co.jp> wrote:
> >
> > Commit 0c3d79bce48034018e840468ac5a642894a521a3 ("tcp: reduce SYN-ACK
> > retrans for TCP_DEFER_ACCEPT") introduces syn_ack_recalc() which decides
> > if a minisock is held and a SYN+ACK is retransmitted or not.
> >
> > If rskq_defer_accept is not zero in syn_ack_recalc(), max_retries always
> > has the same value because max_retries is overwritten by rskq_defer_accept
> > in reqsk_timer_handler().
> >
> > This commit adds three changes:
> > - remove redundant non-zero check for rskq_defer_accept in
> >    reqsk_timer_handler().
> > - remove max_retries from the arguments of syn_ack_recalc() and use
> >    rskq_defer_accept instead.
> > - rename thresh to max_syn_ack_retries for readability.
> >
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
> > Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
> > CC: Julian Anastasov <ja@ssi.bg>
> > ---
> >  net/ipv4/inet_connection_sock.c | 33 +++++++++++++++------------------
> >  1 file changed, 15 insertions(+), 18 deletions(-)
> >
> > diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> > index afaf582a5aa9..21bc80a3c7cf 100644
> > --- a/net/ipv4/inet_connection_sock.c
> > +++ b/net/ipv4/inet_connection_sock.c
> > @@ -648,20 +648,23 @@ struct dst_entry *inet_csk_route_child_sock(const struct sock *sk,
> >  EXPORT_SYMBOL_GPL(inet_csk_route_child_sock);
> >
> >  /* Decide when to expire the request and when to resend SYN-ACK */
> > -static inline void syn_ack_recalc(struct request_sock *req, const int thresh,
> > -                                 const int max_retries,
> > +static inline void syn_ack_recalc(struct request_sock *req,
> 
> While we are at it, please remove the inline keyword.

I will remove 'inline' in next spin.


> > +                                 const int max_syn_ack_retries,
> >                                   const u8 rskq_defer_accept,
> >                                   int *expire, int *resend)
> >  {
> >         if (!rskq_defer_accept) {
> > -               *expire = req->num_timeout >= thresh;
> > +               *expire = req->num_timeout >= max_syn_ack_retries;
> >                 *resend = 1;
> >                 return;
> >         }
> > -       *expire = req->num_timeout >= thresh &&
> > -                 (!inet_rsk(req)->acked || req->num_timeout >= max_retries);
> > -       /*
> > -        * Do not resend while waiting for data after ACK,
> > +       /* If a bare ACK has already been dropped, the client is alive, so
> > +        * do not free the request_sock to drop a bare ACK at most
> > +        * rskq_defer_accept times and wait for data.
> > +        */
> 
> I honestly do not believe this comment is needed.
> The bare ack has not been 'dropped' since it had the effect of
> validating the 3WHS.
> I find it confusing, and not describing the order of the conditions
> expressed in the C code.

Exactly, thank you for correcting my misunderstanding.
I will remove the comment.

Best Regards,
Kuniyuki
