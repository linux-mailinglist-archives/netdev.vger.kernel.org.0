Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC01F14F078
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 17:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgAaQMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 11:12:23 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:54212 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbgAaQMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 11:12:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1580487143; x=1612023143;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   mime-version;
  bh=haMvOsyZc78AVx3AOqC58ELvTFvW3Ug/nhb6F0XmDZ8=;
  b=OBjuH0leZzo9+07WS9tfrKtYa+MIC3IXoToIKQCG27laXRAnSXndDSeJ
   JZhZJ/fYkuTEE5339sHr5rwLbuPMGb6YSQnsXMcmMLgrqByVwWOyKmqbc
   LqFBDpuVjLdU5AHI/xqpvQQCnmSdD+Vnh8guZUEyqlMEHBSdS3S5mocic
   w=;
IronPort-SDR: vyo7DKfoJqzBftCArd4OozalyrQLXy5tcIabPnObduFsX93IRKN3fwCGMyGMiYp2as5jzCLpZc
 NfqLafiDGrIA==
X-IronPort-AV: E=Sophos;i="5.70,386,1574121600"; 
   d="scan'208";a="14203199"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 31 Jan 2020 16:12:20 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id BB43AA2303;
        Fri, 31 Jan 2020 16:12:19 +0000 (UTC)
Received: from EX13D31EUA001.ant.amazon.com (10.43.165.15) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Fri, 31 Jan 2020 16:12:19 +0000
Received: from u886c93fd17d25d.ant.amazon.com (10.43.162.249) by
 EX13D31EUA001.ant.amazon.com (10.43.165.15) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Fri, 31 Jan 2020 16:12:14 +0000
From:   <sjpark@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     <sjpark@amazon.com>, David Miller <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>, netdev <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <sj38.park@gmail.com>,
        <aams@amazon.com>, SeongJae Park <sjpark@amazon.de>
Subject: Re: Re: [PATCH 2/3] tcp: Reduce SYN resend delay if a suspicous ACK is received
Date:   Fri, 31 Jan 2020 17:12:00 +0100
Message-ID: <20200131161200.8852-1-sjpark@amazon.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CANn89i+rKfAhUjYLoEhyYj8OsRBtHC+ukPcE6CuTAJjb183GRQ@mail.gmail.com> (raw)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.249]
X-ClientProxiedBy: EX13D03UWC003.ant.amazon.com (10.43.162.79) To
 EX13D31EUA001.ant.amazon.com (10.43.165.15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 07:01:21 -0800 Eric Dumazet <edumazet@google.com> wrote:

> On Fri, Jan 31, 2020 at 4:25 AM <sjpark@amazon.com> wrote:
> 
> > Signed-off-by: SeongJae Park <sjpark@amazon.de>
> > ---
> >  net/ipv4/tcp_input.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 2a976f57f7e7..b168e29e1ad1 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5893,8 +5893,12 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
> >                  *        the segment and return)"
> >                  */
> >                 if (!after(TCP_SKB_CB(skb)->ack_seq, tp->snd_una) ||
> > -                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
> > +                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
> > +                       /* Previous FIN/ACK or RST/ACK might be ignore. */
> > +                       inet_csk_reset_xmit_timer(sk, ICSK_TIME_RETRANS,
> > +                                                 TCP_ATO_MIN, TCP_RTO_MAX);
> 
> This is not what I suggested.
> 
> I suggested implementing a strategy where only the _first_ retransmit
> would be done earlier.
> 
> So you need to look at the current counter of retransmit attempts,
> then reset the timer if this SYN_SENT
> socket never resent a SYN.
> 
> We do not want to trigger packet storms, if for some reason the remote
> peer constantly sends
> us the same packet.

You're right, I missed the important point, thank you for pointing it.  Among
retransmission related fields of 'tcp_sock', I think '->total_retrans' would
fit for this check.  How about below change?

```
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 2a976f57f7e7..29fc0e4da931 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5893,8 +5893,14 @@ static int tcp_rcv_synsent_state_process(struct sock *sk, struct sk_buff *skb,
                 *        the segment and return)"
                 */
                if (!after(TCP_SKB_CB(skb)->ack_seq, tp->snd_una) ||
-                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt))
+                   after(TCP_SKB_CB(skb)->ack_seq, tp->snd_nxt)) {
+                       /* Previous FIN/ACK or RST/ACK might be ignored. */
+                       if (tp->total_retrans == 0)
+                               inet_csk_reset_xmit_timer(sk,
+                                               ICSK_TIME_RETRANS, TCP_ATO_MIN,
+                                               TCP_RTO_MAX);
                        goto reset_and_undo;
+               }

                if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
                    !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
```

Thanks,
SeongJae Park

> 
> Thanks.
> 
> >                         goto reset_and_undo;
> > +               }
> >
> >                 if (tp->rx_opt.saw_tstamp && tp->rx_opt.rcv_tsecr &&
> >                     !between(tp->rx_opt.rcv_tsecr, tp->retrans_stamp,
> > --
> > 2.17.1
> >
> 
