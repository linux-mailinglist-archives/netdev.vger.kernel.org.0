Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206A432DB96
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238972AbhCDVJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:09:46 -0500
Received: from smtp4.emailarray.com ([65.39.216.22]:33182 "EHLO
        smtp4.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbhCDVJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 16:09:19 -0500
Received: (qmail 48731 invoked by uid 89); 4 Mar 2021 21:08:38 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuNw==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 4 Mar 2021 21:08:38 -0000
Date:   Thu, 4 Mar 2021 13:08:36 -0800
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
Message-ID: <20210304210836.bkpqwbvfpkd5fagg@bsd-mbp.dhcp.thefacebook.com>
References: <20210302060753.953931-1-kuba@kernel.org>
 <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
 <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
 <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
 <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com>
 <20210304110626.1575f7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+cXQXP-7ioizFy90Dj-1SfjA0MQfwvDChxVXQ3wbTjFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+cXQXP-7ioizFy90Dj-1SfjA0MQfwvDChxVXQ3wbTjFA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 04, 2021 at 08:41:45PM +0100, Eric Dumazet wrote:
> On Thu, Mar 4, 2021 at 8:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 4 Mar 2021 13:51:15 +0100 Eric Dumazet wrote:
> > > I think we are over thinking this really (especially if the fix needs
> > > a change in core networking or drivers)
> > >
> > > We can reuse TSQ logic to have a chance to recover when the clone is
> > > eventually freed.
> > > This will be more generic, not only for the SYN+data of FastOpen.
> > >
> > > Can you please test the following patch ?
> >
> > #7 - Eric comes up with something much better :)
> >
> >
> > But so far doesn't seem to quite do it, I'm looking but maybe you'll
> > know right away (FWIW testing a v5.6 backport but I don't think TSQ
> > changed?):
> >
> > On __tcp_retransmit_skb kretprobe:
> >
> > ==> Hit TFO case ret:-16 ca_state:0 skb:ffff888fdb4bac00!
> >
> > First hit:
> >         __tcp_retransmit_skb+1
> >         tcp_rcv_state_process+2488
> >         tcp_v6_do_rcv+405
> >         tcp_v6_rcv+2984
> >         ip6_protocol_deliver_rcu+180
> >         ip6_input_finish+17
> >
> > Successful hit:
> >         __tcp_retransmit_skb+1
> >         tcp_retransmit_skb+18
> >         tcp_retransmit_timer+716
> >         tcp_write_timer_handler+136
> >         tcp_write_timer+141
> >         call_timer_fn+43
> >
> >  skb:ffff888fdb4bac00 --- delay:51642us bytes_acked:1
> 
> 
> Humm maybe one of the conditions used in tcp_tsq_write() does not hold...
> 
> if (tp->lost_out > tp->retrans_out &&
>     tp->snd_cwnd > tcp_packets_in_flight(tp)) {
>     tcp_mstamp_refresh(tp);
>     tcp_xmit_retransmit_queue(sk);
> }
> 
> Maybe FastOpen case is 'special' and tp->lost_out is wrong.


Something like this?  (completely untested)
-- 
Jonathan

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 69a545db80d2..92bc9b0f4955 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5995,8 +5995,10 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
                else
                        tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
                skb_rbtree_walk_from(data) {
+                       tcp_mark_skb_lost(sk, data);
                        if (__tcp_retransmit_skb(sk, data, 1))
                                break;
+                       tp->retrans_out += tcp_skb_pcount(data);
                }
                tcp_rearm_rto(sk);
                NET_INC_STATS(sock_net(sk),

