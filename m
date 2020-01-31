Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B51314F10D
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 18:06:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgAaRFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 12:05:42 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:17033 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbgAaRFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 12:05:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580490342; x=1612026342;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=Lp308P1N7kGC/rh/RrKm6hjiPc5fQG13jwWaLGsBMuc=;
  b=unrLJr1JaaaLLLMi1EOr1ONSP3AOW+h/uiP6aNpw/gArQtveVMyGhLWR
   JK9bu2XnbuHWeFK0MvqC8V8Kl/cTztoz8kkpYq4e2jkJ+TFIAmY/wHdOR
   iXcSN2arLrtp5JuDz82281z75OY6oDIDGNtEet0Co0uaAm1/LGI3Z6A1+
   s=;
IronPort-SDR: hJOb1UZ9E4WP7nS7CRBi6GSs6l46cEbFUcWmYWKn1QHr4cDgWAU08NBVz4WIvmLvdoGz6yIOZ8
 0coMk6GYblHA==
X-IronPort-AV: E=Sophos;i="5.70,386,1574121600"; 
   d="scan'208";a="23645832"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 31 Jan 2020 17:05:30 +0000
Received: from EX13MTAUEA002.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-7d76a15f.us-east-1.amazon.com (Postfix) with ESMTPS id BA1D7A060B;
        Fri, 31 Jan 2020 17:05:26 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 17:05:26 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.50) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 17:05:21 +0000
From:   <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     <sjpark@amazon.com>, David Miller <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <sj38.park@gmail.com>,
        <aams@amazon.com>, SeongJae Park <sjpark@amazon.de>
Subject: Re: Re: Re: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is received
Date:   Fri, 31 Jan 2020 18:05:08 +0100
Message-ID: <20200131170508.21323-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89iJjZdoTKnnHNAByp7euDWo0aW9bL8ngw78vx4z7pwBJiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.50]
X-ClientProxiedBy: EX13D35UWC002.ant.amazon.com (10.43.162.218) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On   Fri, 31 Jan 2020 08:55:08 -0800   Eric Dumazet <edumazet@google.com> wrote:

> On Fri, Jan 31, 2020 at 8:12 AM <sjpark@amazon.com> wrote:
> >
> > On Fri, 31 Jan 2020 07:01:21 -0800 Eric Dumazet <edumazet@google.com> wrote:
> >
> > > On Fri, Jan 31, 2020 at 4:25 AM <sjpark@amazon.com> wrote:
> > >
> > > > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > > > ---
> > > >  net/ipv4/tcp_input.c | 6 +++++-
> > > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > > index 2a976f57f7e7..b168e29e1ad1 100644
> > > > --- a/net/ipv4/tcp_input.c
> > > > +++ b/net/ipv4/tcp_input.c
> > > > @@ -5893,8 +5893,12 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
> > > >                  *        the segment and return)"
> > > >                  */
> > > >                 if (!after(TCP_SKB_CB(skb)->ack_seq, tp->snd_una) ||
> > > > -                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
> > > > +                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
> > > > +                       /* Previous FIN/ACK or RST/ACK might be ignore. */
> > > > +                       inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
> > > > +                                                 TCP_ATO_MIN, TCP_RTO_MAX);
> > >
> > > This is not what I suggested.
> > >
> > > I suggested implementing a strategy where only the _first_ retransmit
> > > would be done earlier.
> > >
> > > So you need to look at the current counter of retransmit attempts,
> > > then reset the timer if this SYN_SENT
> > > socket never resent a SYN.
> > >
> > > We do not want to trigger packet storms, if for some reason the remote
> > > peer constantly sends
> > > us the same packet.
> >
> > You're right, I missed the important point, thank you for pointing it.  Among
> > retransmission related fields of 'tcp_sock', I think '->total_retrans' would
> > fit for this check.  How about below change?
> >
> > ```
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 2a976f57f7e7..29fc0e4da931 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5893,8 +5893,14 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
> >                  *        the segment and return)"
> >                  */
> >                 if (!after(TCP_SKB_CB(skb)->ack_seq, tp->snd_una) ||
> > -                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
> > +                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
> > +                       /* Previous FIN/ACK or RST/ACK might be ignored. */
> > +                       if (tp->total_retrans == 0)
> 
> canonical fied would be icsk->icsk_retransmits (look in net/ipv4/tcp_timer.c )
> 
> AFAIK, it seems we forget to clear tp->total_retrans in tcp_disconnect()
> I will send a patch for this tp->total_retrans thing.

Oh, then I will use 'tcsk->icsk_retransmits' instead of 'tp->total_retrans', in
next spin.  May I also ask you to Cc me for your 'tp->total_retrans' fix patch?


Thanks,
SeongJae Park

> 
> > +                               inet_csk_reset_xmit_timer(sk,
> > +                                               ICSK_TIME_RETRANS, TCP_ATO_MIN,
> > +                                               TCP_RTO_MAX);
> >                         goto reset_and_undo;
> > +               }
> >
> >                 if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
> >                     !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
> > ```
> >
> > Thanks,
> > SeongJae Park
> >
> > >
> > > Thanks.
> > >
> > > >                         goto reset_and_undo;
> > > > +               }
> > > >
> > > >                 if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
> > > >                     !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
> > > > --
> > > > 2.17.1
> > > >
> > >
> 
