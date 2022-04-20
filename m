Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5DF507E73
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 03:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358801AbiDTBv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 21:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348404AbiDTBv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 21:51:59 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 3392B369FA
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 18:49:09 -0700 (PDT)
Received: from XMCDN1207038 (unknown [117.28.111.162])
        by app1 (Coremail) with SMTP id xjNnewBHTgpoZl9iTnsAAA--.73S2;
        Wed, 20 Apr 2022 09:48:26 +0800 (CST)
From:   "Pengcheng Yang" <yangpc@wangsu.com>
To:     "'Paolo Abeni'" <pabeni@redhat.com>,
        "'Neal Cardwell'" <ncardwell@google.com>
Cc:     "'Eric Dumazet'" <edumazet@google.com>,
        "'Yuchung Cheng'" <ycheng@google.com>, <netdev@vger.kernel.org>,
        "'David S. Miller'" <davem@davemloft.net>,
        "'Jakub Kicinski'" <kuba@kernel.org>
References: <1650100749-10072-1-git-send-email-yangpc@wangsu.com>        <1650100749-10072-2-git-send-email-yangpc@wangsu.com>   <CADVnQymGad1=tvLocBCrGK5vtVDKv8m-dYP83VsZfmE-WFcL3w@mail.gmail.com> <862fb2570c4350f0fd3bb3ad153d37b528564ed1.camel@redhat.com>
In-Reply-To: <862fb2570c4350f0fd3bb3ad153d37b528564ed1.camel@redhat.com>
Subject: Re: [PATCH net-next v2 1/2] tcp: ensure to use the most recently sent skb when filling the rate sample
Date:   Wed, 20 Apr 2022 09:48:29 +0800
Message-ID: <005c01d85458$bd0ef940$372cebc0$@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQGQjSKjTrD2nSRUR8/Yp+dt2l8ljAGt59B3Af78GwQCh7uL/a1V7zjQ
X-CM-TRANSID: xjNnewBHTgpoZl9iTnsAAA--.73S2
X-Coremail-Antispam: 1UD129KBjvJXoW3XF4UAr4rJw4fGr4xKF1fCrg_yoW7XF1xpF
        Wvka4DWr1kJrWrKrn2qw4vqF4Svws5Gr13WF4DG343twsxKr1fWF1vqrWj9ayUWrs7Cr4S
        vw1j9Fy3W3Z8ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUklb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
        AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
        6F4UJVW0owA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
        W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
        1j6r4UM4x0Y48IcxkI7VAKI48JMxkIecxEwVAFwVWkMxAIw28IcxkI7VAKI48JMxAIw28I
        cVCjz48v1sIEY20_Xr1UJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
        c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
        0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU5DwIPUUUU
        U==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 10:00 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Sun, 2022-04-17 at 14:51 -0400, Neal Cardwell wrote:
> > On Sat, Apr 16, 2022 at 5:20 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > >
> > > If an ACK (s)acks multiple skbs, we favor the information
> > > from the most recently sent skb by choosing the skb with
> > > the highest prior_delivered count. But in the interval
> > > between receiving ACKs, we send multiple skbs with the same
> > > prior_delivered, because the tp->delivered only changes
> > > when we receive an ACK.
> > >
> > > We used RACK's solution, copying tcp_rack_sent_after() as
> > > tcp_skb_sent_after() helper to determine "which packet was
> > > sent last?". Later, we will use tcp_skb_sent_after() instead
> > > in RACK.
> > >
> > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > > Cc: Neal Cardwell <ncardwell@google.com>
> > > ---
> > >  include/net/tcp.h   |  6 ++++++
> > >  net/ipv4/tcp_rate.c | 11 ++++++++---
> > >  2 files changed, 14 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/net/tcp.h b/include/net/tcp.h
> > > index 6d50a66..fcd69fc 100644
> > > --- a/include/net/tcp.h
> > > +++ b/include/net/tcp.h
> > > @@ -1042,6 +1042,7 @@ struct rate_sample {
> > >         int  losses;            /* number of packets marked lost upon ACK */
> > >         u32  acked_sacked;      /* number of packets newly (S)ACKed upon ACK */
> > >         u32  prior_in_flight;   /* in flight before this ACK */
> > > +       u32  last_end_seq;      /* end_seq of most recently ACKed packet */
> > >         bool is_app_limited;    /* is sample from packet with bubble in pipe? */
> > >         bool is_retrans;        /* is sample from retransmission? */
> > >         bool is_ack_delayed;    /* is this (likely) a delayed ACK? */
> > > @@ -1158,6 +1159,11 @@ void tcp_rate_gen(struct sock *sk, u32 delivered, u32 lost,
> > >                   bool is_sack_reneg, struct rate_sample *rs);
> > >  void tcp_rate_check_app_limited(struct sock *sk);
> > >
> > > +static inline bool tcp_skb_sent_after(u64 t1, u64 t2, u32 seq1, u32 seq2)
> > > +{
> > > +       return t1 > t2 || (t1 == t2 && after(seq1, seq2));
> > > +}
> > > +
> > >  /* These functions determine how the current flow behaves in respect of SACK
> > >   * handling. SACK is negotiated with the peer, and therefore it can vary
> > >   * between different flows.
> > > diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
> > > index 617b818..a8f6d9d 100644
> > > --- a/net/ipv4/tcp_rate.c
> > > +++ b/net/ipv4/tcp_rate.c
> > > @@ -74,27 +74,32 @@ void tcp_rate_skb_sent(struct sock *sk, struct sk_buff *skb)
> > >   *
> > >   * If an ACK (s)acks multiple skbs (e.g., stretched-acks), this function is
> > >   * called multiple times. We favor the information from the most recently
> > > - * sent skb, i.e., the skb with the highest prior_delivered count.
> > > + * sent skb, i.e., the skb with the most recently sent time and the highest
> > > + * sequence.
> > >   */
> > >  void tcp_rate_skb_delivered(struct sock *sk, struct sk_buff *skb,
> > >                             struct rate_sample *rs)
> > >  {
> > >         struct tcp_sock *tp = tcp_sk(sk);
> > >         struct tcp_skb_cb *scb = TCP_SKB_CB(skb);
> > > +       u64 tx_tstamp;
> > >
> > >         if (!scb->tx.delivered_mstamp)
> > >                 return;
> > >
> > > +       tx_tstamp = tcp_skb_timestamp_us(skb);
> > >         if (!rs->prior_delivered ||
> > > -           after(scb->tx.delivered, rs->prior_delivered)) {
> > > +           tcp_skb_sent_after(tx_tstamp, tp->first_tx_mstamp,
> > > +                              scb->end_seq, rs->last_end_seq)) {
> > >                 rs->prior_delivered_ce  = scb->tx.delivered_ce;
> > >                 rs->prior_delivered  = scb->tx.delivered;
> > >                 rs->prior_mstamp     = scb->tx.delivered_mstamp;
> > >                 rs->is_app_limited   = scb->tx.is_app_limited;
> > >                 rs->is_retrans       = scb->sacked & TCPCB_RETRANS;
> > > +               rs->last_end_seq     = scb->end_seq;
> > >
> > >                 /* Record send time of most recently ACKed packet: */
> > > -               tp->first_tx_mstamp  = tcp_skb_timestamp_us(skb);
> > > +               tp->first_tx_mstamp  = tx_tstamp;
> > >                 /* Find the duration of the "send phase" of this window: */
> > >                 rs->interval_us = tcp_stamp_us_delta(tp->first_tx_mstamp,
> > >                                                      scb->tx.first_tx_mstamp);
> > > --
> >
> > Thanks for the patch! The change looks good to me, and it passes our
> > team's packetdrill tests.
> >
> > One suggestion: currently this patch seems to be targeted to the
> > net-next branch. However, since it's a bug fix my sense is that it
> > would be best to target this to the net branch, so that it gets
> > backported to stable releases.
> >
> > One complication is that the follow-on patch in this series ("tcp: use
> > tcp_skb_sent_after() instead in RACK") is a pure re-factor/cleanup,
> > which is more appropriate for net-next. So the plan I was trying to
> > describe in the previous thread was that this series could be
> > implemented as:
> >
> > (1) first, submit "tcp: ensure to use the most recently sent skb when
> > filling the rate sample" to the net branch
> > (2) wait for the fix in the net branch to be merged into the net-next branch
> > (3) second, submit "tcp: use tcp_skb_sent_after() instead in RACK" to
> > the net-next branch
> >
> > What do folks think?
> 
> +1 for the above.
> 
> @Pengcheng: please additionally provide a suitable 'fixes' tag for
> patch 1/2.

Fixes: b9f64820fb22 ("tcp: track data delivery rate for a TCP connection")

> 
> Thanks!
> 
> Paolo

