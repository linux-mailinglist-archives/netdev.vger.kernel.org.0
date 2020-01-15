Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34FC513BA04
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgAOG7Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Jan 2020 01:59:24 -0500
Received: from mail.wangsu.com ([123.103.51.227]:35101 "EHLO wangsu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725999AbgAOG7X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 01:59:23 -0500
Received: from XMCDN1207038 (unknown [59.61.78.137])
        by app2 (Coremail) with SMTP id 4zNnewD3_2c2uB5ehaIJAA--.229S2;
        Wed, 15 Jan 2020 14:59:03 +0800 (CST)
From:   "Pengcheng Yang" <yangpc@wangsu.com>
To:     "'Yuchung Cheng'" <ycheng@google.com>,
        "'Eric Dumazet'" <edumazet@google.com>
Cc:     "'David Miller'" <davem@davemloft.net>,
        "'Alexey Kuznetsov'" <kuznet@ms2.inr.ac.ru>,
        "'Hideaki YOSHIFUJI'" <yoshfuji@linux-ipv6.org>,
        "'Alexei Starovoitov'" <ast@kernel.org>,
        "'Daniel Borkmann'" <daniel@iogearbox.net>,
        "'Martin KaFai Lau'" <kafai@fb.com>,
        "'Song Liu'" <songliubraving@fb.com>,
        "'Yonghong Song'" <yhs@fb.com>, <andriin@fb.com>,
        "'netdev'" <netdev@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
References: <1578993820-2114-1-git-send-email-yangpc@wangsu.com> <CANn89i+nf+cPSxZdRziRa3NaDvdMG+xKYBsy752NX+3vkLba1w@mail.gmail.com> <CAK6E8=d9uRNQuHEx-6xYMvM8Xyshg_FK0AgHGGu3ngT76a45BQ@mail.gmail.com>
In-Reply-To: <CAK6E8=d9uRNQuHEx-6xYMvM8Xyshg_FK0AgHGGu3ngT76a45BQ@mail.gmail.com>
Subject: RE: [PATCH] tcp: fix marked lost packets not being retransmitted
Date:   Wed, 15 Jan 2020 14:58:40 +0800
Message-ID: <019a01d5cb71$38e8edf0$aabac9d0$@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHDr2WaWgeAzMrHi25Ee74mw556twFOsMkmAiFKdhOn9AMwwA==
Content-Language: zh-cn
X-CM-TRANSID: 4zNnewD3_2c2uB5ehaIJAA--.229S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJw17tw1DWw4ruFyDWw48Zwb_yoWrGFWkpa
        1rKFnrtFs8Jr1Fkw1DtrWUXry8tFWSy345W3sYyr9Iyws8tr13uF15t3y3KFy3WF48Aw40
        qF4jyw13Was8AFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkGb7Iv0xC_tr1lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjx
        v20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26rxl6s0DM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6x8ErcxFaVAv8VW8GwAv
        7VCY1x0262k0Y48FwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI4
        8JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxEwVAFwVW8AwCF04k20xvY0x0EwIxGrwCF
        04k20xvE74AGY7Cv6cx26r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
        0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y
        0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
        W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Zr0_Wr1UMIIF0xvEx4A2jsIE14v26r1j6r4U
        MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UhjjgUUU
        UU=
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 2:40 AM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Tue, Jan 14, 2020 at 8:06 AM Eric Dumazet <edumazet@google.com>
> wrote:
> >
> > On Tue, Jan 14, 2020 at 1:24 AM Pengcheng Yang <yangpc@wangsu.com>
> wrote:
> > >
> > > When the packet pointed to by retransmit_skb_hint is unlinked by ACK,
> > > retransmit_skb_hint will be set to NULL in tcp_clean_rtx_queue().
> > > If packet loss is detected at this time, retransmit_skb_hint will be set
> > > to point to the current packet loss in tcp_verify_retransmit_hint(),
> > > then the packets that were previously marked lost but not retransmitted
> > > due to the restriction of cwnd will be skipped and cannot be
> > > retransmitted.
> >
> >
> > "cannot be retransmittted"  sounds quite alarming.
> >
> > You meant they will eventually be retransmitted, or that the flow is
> > completely frozen at this point ?
> He probably means those lost packets will be skipped until a timeout
> that reset hint pointer. nice fix this would save some RTOs.

Yes, I mean those packets will not be retransmitted until RTO.
I'm sorry I didn't describe it clearly.

> 
> >
> > Thanks for the fix and test !
> >
> > (Not sure why you CC all these people having little TCP expertise btw)

Maybe I should CC fewer people :)

> >
> > > To fix this, when retransmit_skb_hint is NULL, retransmit_skb_hint can
> > > be reset only after all marked lost packets are retransmitted
> > > (retrans_out >= lost_out), otherwise we need to traverse from
> > > tcp_rtx_queue_head in tcp_xmit_retransmit_queue().
> > >
> > > Packetdrill to demonstrate:
> > >
> > > // Disable RACK and set max_reordering to keep things simple
> > >     0 `sysctl -q net.ipv4.tcp_recovery=0`
> > >    +0 `sysctl -q net.ipv4.tcp_max_reordering=3`
> > >
> > > // Establish a connection
> > >    +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
> > >    +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
> > >    +0 bind(3, ..., ...) = 0
> > >    +0 listen(3, 1) = 0
> > >
> > >   +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
> > >    +0 > S. 0:0(0) ack 1 <...>
> > >  +.01 < . 1:1(0) ack 1 win 257
> > >    +0 accept(3, ..., ...) = 4
> > >
> > > // Send 8 data segments
> > >    +0 write(4, ..., 8000) = 8000
> > >    +0 > P. 1:8001(8000) ack 1
> > >
> > > // Enter recovery and 1:3001 is marked lost
> > >  +.01 < . 1:1(0) ack 1 win 257 <sack 3001:4001,nop,nop>
> > >    +0 < . 1:1(0) ack 1 win 257 <sack 5001:6001 3001:4001,nop,nop>
> > >    +0 < . 1:1(0) ack 1 win 257 <sack 5001:7001 3001:4001,nop,nop>
> > >
> > > // Retransmit 1:1001, now retransmit_skb_hint points to 1001:2001
> > >    +0 > . 1:1001(1000) ack 1
> > >
> > > // 1001:2001 was ACKed causing retransmit_skb_hint to be set to NULL
> > >  +.01 < . 1:1(0) ack 2001 win 257 <sack 5001:8001 3001:4001,nop,nop>
> > > // Now retransmit_skb_hint points to 4001:5001 which is now marked lost
> > >
> > > // BUG: 2001:3001 was not retransmitted
> > >    +0 > . 2001:3001(1000) ack 1
> > >
> > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > > ---
> > >  net/ipv4/tcp_input.c | 7 ++++---
> > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > > index 0238b55..5347ab2 100644
> > > --- a/net/ipv4/tcp_input.c
> > > +++ b/net/ipv4/tcp_input.c
> > > @@ -915,9 +915,10 @@ static void tcp_check_sack_reordering(struct sock
> *sk, const u32 low_seq,
> > >  /* This must be called before lost_out is incremented */
> > >  static void tcp_verify_retransmit_hint(struct tcp_sock *tp, struct sk_buff
> *skb)
> > >  {
> > > -       if (!tp->retransmit_skb_hint ||
> > > -           before(TCP_SKB_CB(skb)->seq,
> > > -                  TCP_SKB_CB(tp->retransmit_skb_hint)->seq))
> > > +       if ((!tp->retransmit_skb_hint && tp->retrans_out >= tp->lost_out)
> ||
> > > +           (tp->retransmit_skb_hint &&
> > > +            before(TCP_SKB_CB(skb)->seq,
> > > +                   TCP_SKB_CB(tp->retransmit_skb_hint)->seq)))
> > >                 tp->retransmit_skb_hint = skb;
> > >  }
> > >
> > > --
> > > 1.8.3.1
> > >

