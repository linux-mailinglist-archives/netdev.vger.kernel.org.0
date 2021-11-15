Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CDA5450941
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 17:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbhKOQKs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Nov 2021 11:10:48 -0500
Received: from relay9-d.mail.gandi.net ([217.70.183.199]:52489 "EHLO
        relay9-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236787AbhKOQKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 11:10:33 -0500
X-Greylist: delayed 18334 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Nov 2021 11:10:32 EST
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 727CAFF817;
        Mon, 15 Nov 2021 16:07:28 +0000 (UTC)
Date:   Mon, 15 Nov 2021 17:03:41 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH v2 3/6] net: ocelot: pre-compute injection frame header
 content
Message-ID: <20211115170341.7d48de0d@fixe.home>
In-Reply-To: <20211115143105.tmjviz7z7ckmlquk@skbuf>
References: <20211103091943.3878621-1-clement.leger@bootlin.com>
        <20211103091943.3878621-4-clement.leger@bootlin.com>
        <20211103123811.im5ua7kirogoltm7@skbuf>
        <20211103145351.793538c3@fixe.home>
        <20211115111344.03376026@fixe.home>
        <20211115060800.44493c2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211115150620.057674ae@fixe.home>
        <20211115143105.tmjviz7z7ckmlquk@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, 15 Nov 2021 14:31:06 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a écrit :

> On Mon, Nov 15, 2021 at 03:06:20PM +0100, Clément Léger wrote:
> > Le Mon, 15 Nov 2021 06:08:00 -0800,
> > Jakub Kicinski <kuba@kernel.org> a écrit :
> >  
> > > On Mon, 15 Nov 2021 11:13:44 +0100 Clément Léger wrote:  
> > > > Test on standard packets with UDP (iperf3 -t 100 -l 1460 -u -b 0 -c *)
> > > > - With pre-computed header: UDP TX: 	33Mbit/s
> > > > - Without UDP TX: 			31Mbit/s  
> > > > -> 6.5% improvement  
> > > >
> > > > Test on small packets with UDP (iperf3 -t 100 -l 700 -u -b 0 -c *)
> > > > - With pre-computed header: UDP TX: 	15.8Mbit/s
> > > > - Without UDP TX: 			16.4Mbit/s  
> > > > -> 4.3% improvement  
> > >
> > > Something's wrong with these numbers or I'm missing context.
> > > You say improvement in both cases yet in the latter case the
> > > new number is lower?  
> >
> > You are right Jakub, I swapped the last two results,
> >
> > Test on small packets with UDP (iperf3 -t 100 -l 700 -u -b 0 -c *)
> >  - With pre-computed header: UDP TX: 	16.4Mbit/s
> >  - Without UDP TX: 			15.8Mbit/s  
> >  -> 4.3% improvement  
> 
> Even in reverse, something still seems wrong with the numbers.
> My DSPI controller can transfer at a higher data rate than that.
> Where is the rest of the time spent? Computing checksums?

While adding FDMA support, I was surprised by the low performances I
encountered so I spent some times trying to understand and find where
the time was spent. First, I ran a iperf in loopback (using lo) and it
yielded the following results (of course RX/TX runs on the same CPU in
this case):

TCP (iperf3 -c localhost):
 - RX/TX: 84.0Mbit/s

UDP (iperf3 -u -b 0 -c localhost):
 - RX/TX: 65.0Mbit/s

So even in localhost mode, the CPU is already really slow and can only
sustain a really small "throughput". I then tried to check the
performances using the CPU based injection/extraction, and I obtained
the following results:

TCP: (iperf3 -u -b 0 -c)
 - TX: 11.8MBit/s
 - RX: 21.6Mbit/s

UDP (iperf3 -u -b 0 -c)
 - TX: 13.4Mbit/s
 - RX: Not even possible, CPU never succeed to extract a single packet

I then tried to find where was the time spent with ftrace (I kept only
the relevant functions that consume most of the time), the following
results were recorded when using iperf3 with CPU based
injection/extraction.

In TCP TX, a lot of time is spent doing copy from user:

41.71%  iperf3   [kernel.kallsyms]  [k] __raw_copy_to_user
 6.65%  iperf3   [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
 3.23%  iperf3   [kernel.kallsyms]  [k] do_ade
 2.10%  iperf3   [kernel.kallsyms]  [k] __ocelot_write_ix
 2.10%  iperf3   [kernel.kallsyms]  [k] handle_adel_int
 ...

In TCP RX, numbers are even worse for the time spent in
__raw_copy_to_user:

62.95% iperf3   [kernel.kallsyms]  [k] __raw_copy_to_user
 1.97% iperf3   [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
 1.15% iperf3   [kernel.kallsyms]  [k] __copy_page_start
 1.07% iperf3   [kernel.kallsyms]  [k] __skb_datagram_iter
 ...


In UDP TX, some time is spent handling locking and unaligned copies
as well as pushing packets. Unaligned copies are due to the driver
accessing all directly the bytes of the packets as word whhich might be
bad when there is misalignement.

17.97%  iperf3   [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
11.94%  iperf3   [kernel.kallsyms]  [k] do_ade
 9.07%  iperf3   [kernel.kallsyms]  [k] __ocelot_write_ix
 7.74%  iperf3   [kernel.kallsyms]  [k] handle_adel_int
 5.78%  iperf3   [kernel.kallsyms]  [k] copy_from_kernel_nofault
 4.71%  iperf3   [kernel.kallsyms]  [k] __compute_return_epc_for_insn
 2.51%  iperf3   [kernel.kallsyms]  [k] regmap_write
 2.31%  iperf3   [kernel.kallsyms]  [k] __compute_return_epc
 ...

In UDP RX (iperf3 with -b 5M to ensure packets are received), time is
spent in floating point emulation and other various function.

7.26% iperf3   [kernel.kallsyms]  [k] cop1Emulate
2.84% iperf3   [kernel.kallsyms]  [k] do_select
2.08% iperf3   [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
2.06% iperf3   [kernel.kallsyms]  [k] fpu_emulator_cop1Handler
2.01% iperf3   [kernel.kallsyms]  [k] tcp_poll
2.00% iperf3   [kernel.kallsyms]  [k] __raw_copy_to_user


When using the FDMA, the results are the following:

In TCP TX, copy from user is still present and checksuming takes quite
some time. 

31.31% iperf3   [kernel.kallsyms]  [k] __raw_copy_to_user
10.48% iperf3   [kernel.kallsyms]  [k] __csum_partial_copy_to_user
 3.73% iperf3   [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
 2.08% iperf3   [kernel.kallsyms]  [k] tcp_ack
 1.68% iperf3   [kernel.kallsyms]  [k] ocelot_fdma_napi_poll
 1.63% iperf3   [kernel.kallsyms]  [k] tcp_write_xmit
 1.05% iperf3   [kernel.kallsyms]  [k] finish_task_switch

In TCP RX, the majority of time is still taken by __raw_copy_to_user.

63.95%[[m  iperf3   [kernel.kallsyms]  [k] __raw_copy_to_user
 1.29%[[m  iperf3   [kernel.kallsyms]  [k] _raw_spin_unlock_irqrestore
 1.23%[[m  iperf3   [kernel.kallsyms]  [k] tcp_recvmsg_locked
 1.23%[[m  iperf3   [kernel.kallsyms]  [k] __skb_datagram_iter
 1.07%[[m  iperf3   [kernel.kallsyms]  [k] vfs_read

In UDP TX, time is spent in softirq entry and in checksuming.

9.01% iperf3   [kernel.kallsyms]  [k] __softirqentry_text_start
7.07% iperf3   [kernel.kallsyms]  [k] __csum_partial_copy_to_user
2.28% iperf3   [kernel.kallsyms]  [k] __ip_append_data.isra.0
2.10% iperf3   [kernel.kallsyms]  [k] __dev_queue_xmit
2.08% iperf3   [kernel.kallsyms]  [k] siphash_3u32
2.06% iperf3   [kernel.kallsyms]  [k] udp_sendmsg

And in UDP RX, again, time is spent in floating point emulation and
cheksuming.

10.33% iperf3   [kernel.kallsyms]  [k] cop1Emulate
 7.62% iperf3   [kernel.kallsyms]  [k] csum_partial
 3.32% iperf3   [kernel.kallsyms]  [k] do_select
 2.69% iperf3   [kernel.kallsyms]  [k] ieee754dp_sub
 2.68% iperf3   [kernel.kallsyms]  [k] fpu_emulator_cop1Handler
 2.56% iperf3   [kernel.kallsyms]  [k] ieee754dp_add
 2.33% iperf3   [kernel.kallsyms]  [k] ieee754dp_div

After all these measurements, the CPU appears to be the bottleneck and
simply spend a lot of time in various functions. I did not went further
using perf events since there was no real reason to dig up more in that
way.

-- 
Clément Léger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
