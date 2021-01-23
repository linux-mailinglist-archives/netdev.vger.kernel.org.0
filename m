Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3BB301567
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 14:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbhAWN0F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 08:26:05 -0500
Received: from mail.wangsu.com ([123.103.51.227]:42121 "EHLO wangsu.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725268AbhAWN0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 Jan 2021 08:26:03 -0500
Received: from 137.localdomain (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id 4zNnewAHD699IwxgkocCAA--.486S2;
        Sat, 23 Jan 2021 21:24:13 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     ycheng@google.com
Cc:     davem@davemloft.net, edumazet@google.com, ncardwell@google.com,
        netdev@vger.kernel.org, yangpc@wangsu.com
Subject: Re: [PATCH net] tcp: fix TLP timer not set when CA_STATE changes from DISORDER to OPEN
Date:   Sat, 23 Jan 2021 21:58:58 +0800
Message-Id: <1611410338-12911-1-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <CAK6E8=dAyf+ajSFZ1eoA_BbVRDnLQRJwCL=t6vDBvEkCiquwxw@mail.gmail.com>
References: <CAK6E8=dAyf+ajSFZ1eoA_BbVRDnLQRJwCL=t6vDBvEkCiquwxw@mail.gmail.com>
X-CM-TRANSID: 4zNnewAHD699IwxgkocCAA--.486S2
X-Coremail-Antispam: 1UD129KBjvJXoWxXr47XFW7uF1kCFW7Gw15Arb_yoW5tryrpF
        45Aa97trs5GFy8Cws2y3Z5Z34UKrsxZF13W348Kry29as0vr1SvF48t3yUWFWagr1kGa12
        yry8trZIvFZ8AaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUyK1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l8cAvFVAK
        0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4
        x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2
        z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4
        xG64xvF2IEw4CE5I8CrVC2j2WlYx0E74AGY7Cv6cx26r48McIj6xkF7I0En7xvr7AKxVWU
        JVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5c
        I20VAGYxC7MxkIecxEwVAFwVW5GwCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx2
        6r48MxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
        xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
        jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
        0EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
        1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfU418BUUUUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 23, 2021 at 5:02 AM "Yuchung Cheng" <ycheng@google.com> wrote:
>
> On Fri, Jan 22, 2021 at 6:37 AM Neal Cardwell <ncardwell@google.com> wrote:
> >
> > On Fri, Jan 22, 2021 at 5:53 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Fri, Jan 22, 2021 at 11:28 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> > > >
> > > > When CA_STATE is in DISORDER, the TLP timer is not set when receiving
> > > > an ACK (a cumulative ACK covered out-of-order data) causes CA_STATE to
> > > > change from DISORDER to OPEN. If the sender is app-limited, it can only
> 
> Could you point which line of code causes the state to flip
> incorrectly due to the TLP timer setting?
> 

I mean TLP timer is not set due to receiving an ACK that changes CA_STATE 
from DISORDER to OPEN.

Receive an ACK covered out-of-order data in disorder state:

tcp_ack()
|-tcp_set_xmit_timer()	// RTO timer is set instead of TLP timer
|  ...
|-tcp_fastretrans_alert() // change from disorder to open

> > > > wait for the RTO timer to expire and retransmit.
> > > >
> > > > The reason for this is that the TLP timer is set before CA_STATE changes
> > > > in tcp_ack(), so we delay the time point of calling tcp_set_xmit_timer()
> > > > until after tcp_fastretrans_alert() returns and remove the
> > > > FLAG_SET_XMIT_TIMER from ack_flag when the RACK reorder timer is set.
> > > >
> > > > This commit has two additional benefits:
> > > > 1) Make sure to reset RTO according to RFC6298 when receiving ACK, to
> > > > avoid spurious RTO caused by RTO timer early expires.
> > > > 2) Reduce the xmit timer reschedule once per ACK when the RACK reorder
> > > > timer is set.
> > > >
> > > > Link: https://lore.kernel.org/netdev/1611139794-11254-1-git-send-email-yangpc@wangsu.com
> > > > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> > > > Cc: Neal Cardwell <ncardwell@google.com>
> > > > ---
> > >
> > > This looks like a very nice patch, let me run packetdrill tests on it.
> > >
> > > By any chance, have you cooked a packetdrill test showing the issue
> > > (failing on unpatched kernel) ?
> >
> > Thanks, Pengcheng. This patch looks good to me as well, assuming it
> > passes our packetdrill tests. I agree with Eric that it would be good
> > to have an explicit packetdrill test for this case.
> >
> > neal

Here is a packetdrill test case:

// Enable TLP
    0 `sysctl -q net.ipv4.tcp_early_retrans=3`

// Establish a connection
   +0 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
   +0 bind(3, ..., ...) = 0
   +0 listen(3, 1) = 0

// RTT 100ms, RTO 300ms
  +.1 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 7>
   +0 > S. 0:0(0) ack 1 <...>
  +.1 < . 1:1(0) ack 1 win 257
   +0 accept(3, ..., ...) = 4

// Send 4 data segments
   +0 write(4, ..., 4000) = 4000
   +0 > P. 1:4001(4000) ack 1

// out-of-order: ca_state turns to disorder
  +.1 < . 1:1(0) ack 1 win 257 <sack 1001:2001,nop,nop>

// ACK covered out-of-order data: ca_state turns to open,
// but RTO timer is set instead of TLP timer and the RTO 
// timer will expire at rtx_head_time+RTO (in 200ms).
   +0 < . 1:1(0) ack 2001 win 257

// Expect to send TLP packet in 2*rtt (200ms)
+.2~+.25 > P. 3001:4001(1000) ack 1


I ran this packetdrill test case on the kernel without 
the patch applied:

tlp_timer_unset.pkt:31: error handling packet: live packet 
field tcp_seq: expected: 3001 (0xbb9) vs actual: 2001 (0x7d1)
script packet:  0.644587 P. 3001:4001(1000) ack 1 
actual packet:  0.646197 . 2001:3001(1000) ack 1 win 502 

