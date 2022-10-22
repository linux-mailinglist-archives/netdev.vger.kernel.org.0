Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D9C609044
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 00:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJVWXP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 22 Oct 2022 18:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJVWXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 18:23:14 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9497F135
        for <netdev@vger.kernel.org>; Sat, 22 Oct 2022 15:23:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 18673141221;
        Sun, 23 Oct 2022 00:23:06 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id 5n8815A0Oees; Sun, 23 Oct 2022 00:22:59 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id C939F140E7C;
        Sun, 23 Oct 2022 00:22:59 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 686F96112E; Sun, 23 Oct 2022 00:22:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 60072610FD;
        Sun, 23 Oct 2022 00:22:59 +0200 (CEST)
Date:   Sun, 23 Oct 2022 00:22:59 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     netdev@vger.kernel.org
Subject: Re: qdisc_watchdog_schedule_range_ns granularity
In-Reply-To: <2b195a93-a88b-33c2-661a-85fa8513c063@gmail.com>
Message-ID: <9c1bb95b-3933-2b33-b8c6-ddefc8459afa@tarent.de>
References: <c4a1d4ff-82eb-82c9-619e-37c18b41a017@tarent.de> <44a7e82b-0fe9-d6ba-ee12-02dfa4980966@gmail.com> <a896ad54-297b-c55e-1d34-14ab26949ab6@tarent.de> <2b195a93-a88b-33c2-661a-85fa8513c063@gmail.com>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Oct 2022, Eric Dumazet wrote:

> net/sched/sch_fq.c is not using the skb tstamp which could very well be in the
> past,

For the enqueue timestamp I now save u64 ktime_get_ns() in the per-skb
extra data, so I have a reliable one.

> > > I don't know how you measure this latency, but net/sched/sch_fq.c has

I’ve now added some measurements. I use the qdisc watchdog in two
scenarios:

• extralatency, and the enqueue timestamp is > now (ktime_get_ns())
• independent of extralatency, if the time from the previous package
  (size * ns_per_byte) is not yet elapsed

The latter was not so problematic, because, even if I’m called “too
late” by the qdisc watchdog, I measure the time for the _next_ packet
since the time from the previous packet, not now, unless there was
no previous packet. These are also enqueued with an 1ms tolerance.

The former is problematic as it relies on being called somewhat
precisely once now has reached the enqueue timestamp of the head
of the FIFO.

In my measurement, I report detailled information on whenever my
dequeue function is called (which of the two watchdog causes it
was, if any, and the difference from the time I was supposed to
be called to now), but I also count them into five buckets:

• called too early (perhaps by the regular softirq instead of
  the watchdog)
• called within 50 us of the passed time
• called within 1 ms of the passed time
• called within 4 ms of the passed time (< HZ)
• called at 4 ms or more (>= HZ)

This categorisation is “quick” i.e. first-match.

In an experimental run of about 66 seconds of transmission time,
running iperf at 400kbps on a 512kbps queue, I get:

• 2257 calls too early
•  444 calls within 50 us
• 1702 calls within 1 ms
• 2460 calls within 4 ms
•   62 calls at/above 4 ms

Note that every “too early” call would also result in another
qdisc_watchdog_schedule_range_ns() call.

I used three separate machines on two separate test networks for this
(sender, qdisc, recipient); the test network is otherwise idle save
for background traffic (ARP, neighbour discovery, maybe Avahi).

> > > Under high cpu pressure, it is possible the softirq is delayed,
> > > because ksoftirqd might compete with user threads.

The utilisation of all three CPUs assigned to the VM is minimal,
around 1%, throughout the run, so I didn’t try that.

────────────────────────────────────────────────────────────────────────

See commit 2a61f1ea843dc767d291074eee9b2f1b8d3992a7 in
git@github.com:tarent/sch_jens.git branch master for the
added code and the schedule calls.

────────────────────────────────────────────────────────────────────────

Another run: 60s 15Mbit/s traffic on a 20Mbit/s queue.

Before:
$ cat /proc/softirqs
                    CPU0       CPU1       CPU2
          HI:          3          1          0
       TIMER:    1880381    1871169    2737200
      NET_TX:     498587          4         13
      NET_RX:   16918041  110157910      90553
       BLOCK:      90302      94916     141117
    IRQ_POLL:          0          0          0
     TASKLET:      23122       5419        252
       SCHED:    2707165    2799111    3584005
     HRTIMER:          2         45          2
         RCU:    2225711    2200451    2082194

After:
$ cat /proc/softirqs
                    CPU0       CPU1       CPU2
          HI:          3          1          0
       TIMER:    1880690    1871863    2737354
      NET_TX:     516224          4         15
      NET_RX:   17109410  110178118      90563
       BLOCK:      90314      94918     141118
    IRQ_POLL:          0          0          0
     TASKLET:      31992       9778       1270
       SCHED:    2708137    2800826    3585279
     HRTIMER:          2         45          2
         RCU:    2225787    2200548    2082297

So 17639 more NET_TX (virtually all on CPU0, interestingly enough,
even though irqbalance is running).

The numbers:

• 17264 (or 82800 or 148336… this is an u16) early
• 11101 within 50 us
• 68129 within 1 ms
• 1291 within 4 ms
• 103 at/above 4 ms

I’m “only” seeing delays of 5+ ms though, not 15–20 as my coworker.

That being said, they reconfigure the qdisc quite a high amount of
times per second to simulate changing environment conditions (i.e.
changing rate). Perhaps the sheer amount of tc change commands has
some impact? Let’s retry with changing the rate 50 times a second…

CPU usage about 60% for each core, though my shell script likely
uses more than the real solution. top alone uses 20% of one CPU…

I see 40 ms latency in one packet.

• 871 (possibly plus n*65536) early
• 2366 within 50 us
• 16041 within 1 ms
• 5186 within 4 ms
• 1462 at/above 4 ms

This definitely shifts things.

With reniced ksoftirqd/*:

• 60798 (possibly plus n*65536) early
• 2902 within 50 us
• 21532 within 1 ms
• 1735 within 4 ms
• 1495 at/above 4 ms

So, it… helps, but not too much.

Does the qdisc locking during reconfiguration impact things?

One more thing I noticed is that [rcu_sched] uses a lot of CPU
in the latter runs. Is that also related to the amount of tc(8)
processes created?

With tc -b - and writing to a ksh coprocess, both rcu_sched and
entire system load go down slightly.

• 43564 (possibly plus n*65536) early
• 4908 within 50 us
• 41450 within 1 ms
• 5406 within 4 ms
• 899 at/above 4 ms

It also helps but I still saw a packet with 42 ms queue delay…

Should I look into writing my own reconfiguration channel that
does not use tc, to adjust the runtime parameters frequently?
(Probably only rate; handover is infrequent enough one could
just use tc, and extralatency should be stable across one run.)

What technology would I use for that? Something like relayfs
but the other way round. For the rate, I basically would only
have to atomically swap one 64-bit quantity, or would I need
locking? (The harder part would be to find the address of that
quantity…)

bye,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
