Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC4C865F6E
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 20:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbfGKS07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 14:26:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:37784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728451AbfGKS07 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jul 2019 14:26:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D5EE7AE91;
        Thu, 11 Jul 2019 18:26:56 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 96CB5E0183; Thu, 11 Jul 2019 20:26:54 +0200 (CEST)
Date:   Thu, 11 Jul 2019 20:26:54 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        "Prout, Andrew - LLSC - MITLL" <aprout@ll.mit.edu>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Looney <jtl@netflix.com>,
        Neal Cardwell <ncardwell@google.com>,
        Tyler Hicks <tyhicks@canonical.com>,
        Yuchung Cheng <ycheng@google.com>,
        Bruce Curtis <brucec@netflix.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Dustin Marquess <dmarquess@apple.com>
Subject: Re: [PATCH net 2/4] tcp: tcp_fragment() should apply sane memory
 limits
Message-ID: <20190711182654.GG5700@unicorn.suse.cz>
References: <20190617170354.37770-3-edumazet@google.com>
 <CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com>
 <03cbcfdf-58a4-dbca-45b1-8b17f229fa1d@gmail.com>
 <CALMXkpZ4isoXpFp_5=nVUcWrt5TofYVhpdAjv7LkCH7RFW1tYw@mail.gmail.com>
 <63cd99ed3d0c440185ebec3ad12327fc@ll.mit.edu>
 <96791fd5-8d36-2e00-3fef-60b23bea05e5@gmail.com>
 <e471350b70e244daa10043f06fbb3ebe@ll.mit.edu>
 <b1dfd327-a784-6609-3c83-dab42c3c7eda@gmail.com>
 <B600B3AB-559E-44C1-869C-7309DB28850E@gmail.com>
 <eb6121ea-b02d-672e-25c9-2ad054d49fc7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eb6121ea-b02d-672e-25c9-2ad054d49fc7@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 11:19:45AM +0200, Eric Dumazet wrote:
> 
> 
> On 7/11/19 9:28 AM, Christoph Paasch wrote:
> > 
> > 
> >> On Jul 10, 2019, at 9:26 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >>
> >>
> >> On 7/10/19 8:53 PM, Prout, Andrew - LLSC - MITLL wrote:
> >>>
> >>> Our initial rollout was v4.14.130, but I reproduced it with v4.14.132 as well, reliably for the samba test and once (not reliably) with synthetic test I was trying. A patched v4.14.132 with this patch partially reverted (just the four lines from tcp_fragment deleted) passed the samba test.
> >>>
> >>> The synthetic test was a pair of simple send/recv test programs under the following conditions:
> >>> -The send socket was non-blocking
> >>> -SO_SNDBUF set to 128KiB
> >>> -The receiver NIC was being flooded with traffic from multiple hosts (to induce packet loss/retransmits)
> >>> -Load was on both systems: a while(1) program spinning on each CPU core
> >>> -The receiver was on an older unaffected kernel
> >>>
> >>
> >> SO_SNDBUF to 128KB does not permit to recover from heavy losses,
> >> since skbs needs to be allocated for retransmits.
> > 
> > Would it make sense to always allow the alloc in tcp_fragment when coming from __tcp_retransmit_skb() through the retransmit-timer ?
> 
> 4.15+ kernels have :
> 
> if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf &&
>     tcp_queue != TCP_FRAG_IN_WRITE_QUEUE)) {
> 
> 
> Meaning that things like TLP will succeed.

I get

          <idle>-0     [010] ..s. 301696.143296: p_tcp_fragment_0: (tcp_fragment+0x0/0x310) sndbuf=30000 wmemq=65600
          <idle>-0     [010] d.s. 301696.143301: r_tcp_fragment_0: (tcp_send_loss_probe+0x13d/0x1f0 <- tcp_fragment) ret=-12
          <idle>-0     [010] ..s. 301696.267644: p_tcp_fragment_0: (tcp_fragment+0x0/0x310) sndbuf=30000 wmemq=65600
          <idle>-0     [010] d.s. 301696.267650: r_tcp_fragment_0: (__tcp_retransmit_skb+0xf9/0x800 <- tcp_fragment) ret=-12
          <idle>-0     [010] ..s. 301696.875289: p_tcp_fragment_0: (tcp_fragment+0x0/0x310) sndbuf=30000 wmemq=65600
          <idle>-0     [010] d.s. 301696.875293: r_tcp_fragment_0: (__tcp_retransmit_skb+0xf9/0x800 <- tcp_fragment) ret=-12
          <idle>-0     [010] ..s. 301698.059267: p_tcp_fragment_0: (tcp_fragment+0x0/0x310) sndbuf=30000 wmemq=65600
          <idle>-0     [010] d.s. 301698.059271: r_tcp_fragment_0: (__tcp_retransmit_skb+0xf9/0x800 <- tcp_fragment) ret=-12
          <idle>-0     [010] ..s. 301700.427225: p_tcp_fragment_0: (tcp_fragment+0x0/0x310) sndbuf=30000 wmemq=65600
          <idle>-0     [010] d.s. 301700.427230: r_tcp_fragment_0: (__tcp_retransmit_skb+0xf9/0x800 <- tcp_fragment) ret=-12
          <idle>-0     [010] ..s. 301705.291144: p_tcp_fragment_0: (tcp_fragment+0x0/0x310) sndbuf=30000 wmemq=65600
          <idle>-0     [010] d.s. 301705.291151: r_tcp_fragment_0: (__tcp_retransmit_skb+0xf9/0x800 <- tcp_fragment) ret=-12
          <idle>-0     [010] ..s. 301714.762961: p_tcp_fragment_0: (tcp_fragment+0x0/0x310) sndbuf=30000 wmemq=65600
          <idle>-0     [010] d.s. 301714.762966: r_tcp_fragment_0: (__tcp_retransmit_skb+0xf9/0x800 <- tcp_fragment) ret=-12

on 5.2 kernel with this packetdrill script:

------------------------------------------------------------------------
--tolerance_usecs=10000

// flush cached TCP metrics
0.000  `ip tcp_metrics flush all`

// establish a connection
+0.000 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
+0.000 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
+0.000 setsockopt(3, SOL_SOCKET, SO_SNDBUF, [15000], 4) = 0
+0.000 bind(3, ..., ...) = 0
+0.000 listen(3, 1) = 0

+0.100 < S 0:0(0) win 60000 <mss 1000,nop,nop,sackOK,nop,wscale 7>
+0.000 > S. 0:0(0) ack 1 <mss 1460,nop,nop,sackOK,nop,wscale 7>
+0.100 < . 1:1(0) ack 1 win 2000
+0.000 accept(3, ..., ...) = 4
+0.100 write(4, ..., 30000) = 30000

+0.000 > . 1:2001(2000) ack 1
+0.000 > . 2001:4001(2000) ack 1
+0.000 > . 4001:6001(2000) ack 1
+0.000 > . 6001:8001(2000) ack 1
+0.000 > . 8001:10001(2000) ack 1
+0.010 < . 1:1(0) ack 10001 win 2000
+0.000 > . 10001:12001(2000) ack 1
+0.000 > . 12001:14001(2000) ack 1
+0.000 > . 14001:16001(2000) ack 1
+0.000 > . 16001:18001(2000) ack 1
+0.000 > . 18001:20001(2000) ack 1
+0.000 > . 20001:22001(2000) ack 1
+0.000 > . 22001:24001(2000) ack 1
+0.000 > . 24001:26001(2000) ack 1
+0.000 > . 26001:28001(2000) ack 1
+0.000 > P. 28001:30001(2000) ack 1
+0.010 < . 1:1(0) ack 30001 win 2000
+0.000 write(4, ..., 40000) = 40000
+0.000 > . 30001:32001(2000) ack 1
+0.000 > . 32001:34001(2000) ack 1
+0.000 > . 34001:36001(2000) ack 1
+0.000 > . 36001:38001(2000) ack 1
+0.000 > . 38001:40001(2000) ack 1
+0.000 > . 40001:42001(2000) ack 1
+0.000 > . 42001:44001(2000) ack 1
+0.000 > . 44001:46001(2000) ack 1
+0.000 > . 46001:48001(2000) ack 1
+0.000 > . 48001:50001(2000) ack 1
+0.000 > . 50001:52001(2000) ack 1
+0.000 > . 52001:54001(2000) ack 1
+0.000 > . 54001:56001(2000) ack 1
+0.000 > . 56001:58001(2000) ack 1
+0.000 > . 58001:60001(2000) ack 1
+0.000 > . 60001:62001(2000) ack 1
+0.000 > . 62001:64001(2000) ack 1
+0.000 > . 64001:66001(2000) ack 1
+0.000 > . 66001:68001(2000) ack 1
+0.000 > P. 68001:70001(2000) ack 1

+0.000 `ss -nteim state established sport == :8080`

+0.120~+0.200 > P. 69001:70001(1000) ack 1
------------------------------------------------------------------------

I'm aware it's not a realistic test. It was written as quick and simple
check of the pre-4.19 patch, but it shows that even TLP may not get
through.

Michal
