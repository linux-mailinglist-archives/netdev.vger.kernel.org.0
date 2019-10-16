Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0E6BD9BD9
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 22:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437193AbfJPUb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 16:31:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:23710 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728881AbfJPUb4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 16:31:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 13:31:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="397290759"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 16 Oct 2019 13:31:55 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: taprio testing - Any help?
In-Reply-To: <f6fb6448-35f0-3071-bda1-7ca5f4e3e11e@ti.com>
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com> <87v9sv3uuf.fsf@linux.intel.com> <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com> <87r23j3rds.fsf@linux.intel.com> <CA+h21hon+QzS7tRytM2duVUvveSRY5BOGXkHtHOdTEwOSBcVAg@mail.gmail.com> <45d3e5ed-7ddf-3d1d-9e4e-f555437b06f9@ti.com> <871rve5229.fsf@linux.intel.com> <f6fb6448-35f0-3071-bda1-7ca5f4e3e11e@ti.com>
Date:   Wed, 16 Oct 2019 13:32:57 -0700
Message-ID: <87zhi01ldy.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Murali Karicheri <m-karicheri2@ti.com> writes:

> Hi Vinicius,
>
> On 10/14/2019 07:39 PM, Vinicius Costa Gomes wrote:
>> Murali Karicheri <m-karicheri2@ti.com> writes:
>>>
>>> My expectation is as follows
>>>
>>> AAAAAABBBBBCCCCCDDDDDEEEEE
>>>
>>> Where AAAAA is traffic from TC0, BBBBB is udp stream for port 10000
>>> CCCCC is stream for port 20000, DDDDD for 30000 and EEEEE for 40000.
>>> Each can be max of 4 msec. Is the expection correct? At least that
>>> is my understanding.
>> 
>> Your expectation is correct.
>> 
>>>
>>> But what I see is alternating packets with port 10000/20000/30000/40000
>>> at the wireshark capture and it doesn't make sense to me. If you
>>> look at the timestamp, there is nothing showing the Gate is honored
>>> for Tx. Am I missing something?
>> 
>> Remember that taprio (in software mode) has no control after the packet
>> is delivered to the driver. So, even if taprio obeys your traffic
>> schedule perfectly, the driver/controller may decide to send packets
>> according to some other logic.
>> 
> That is true.
>
> I think I get why it can't work without ETF offload which is missing in
> our hardware. Here is what my understanding. Please correct it if
> wrong.

For taprio, to get good results, you have to have some kind of
offloading, so right now, there are two alternatives for offloading: (1)
full offloading, something similar to what Vladimir added for the
SJA1105; (2) txtime-assisted mode, what Vedang added to support running
Qbv-like schedules in controllers that only support controlling the
transmission time of individual packets (the LaunchTime feature of the
i210 controller, for example).

If your hardware doesn't have any of those capabilities, then you are
basically stuck with the software mode, or you can come up with some
other "assisted mode" that might work for your hardware. 

>
> Our hardware has priority queues implemented. So if there are no
> packets in the higher priority queue, it would send from the lower
> priority ones. Assuming packets gets dequeue-ed correctly by
> taprio and that packets are only in one of the lower priority TC.
> i.e in the above example, BBBBBB are present when TC1 Gate is open.
> Assuming there are more packets than actually sent out during TC1
> window, and assuming no packets in the TC0 queue (AAAAA is absent)
> then hardware will continue to send from TC1 queue. So that might
> be what is happening, right?
>
> So it is required to deliver frames to driver only when the Gate for
> the specific traffic class is open. Is that what is done by ETF qdisc?
>  From ETF description at
> http://man7.org/linux/man-pages/man8/tc-etf.8.html
> 'The ETF (Earliest TxTime First) qdisc allows applications to control
> the instant when a packet should be dequeued from the traffic control
> layer into the netdevice'. So I assume, when I use iperf (there is
> no txtime information in the packet), I still can use ETF and
> packet time will be modified to match with schedule and then get
> dequeue-ed at correct time to arrive at the driver during the Gate
> open of taprio. Is this correct?
>

taprio in the txtime-assisted mode does exactly that: "packet time will
be modified to match with schedule", but it needs ETF offloading to be
supported to get good results, ETF has the same "problem" as taprio when
running in the software mode (no offloading), it has no control after
the packet is delivered to the driver.

> If ETF can schedule packet to arrive at the driver just during th
> Gate open and work in sync with taprio scheduler, that would do the
> work.I understand the border may be difficult to manage. However if we
> add a guard band by adding an extra entry with all Gates closed
> between schedules for guard band duration, it should allow hardware to
> flush out any remaining frames from the queue outside its Gate duration.
> If my understanding is correct, can I use software ETF qdisc in this
> case? If so how do I configure it? Any example?

Without any offloading, I think you are better off running taprio
standalone (i.e. without ETF, so you don't have yet another layer of
packet scheduling based solely on hrtimers), and just adding the
guard-bands, something like this:

$ tc qdisc replace dev $IFACE parent root handle 100 taprio \\
      num_tc 3 \
      map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@1 2@2 \
      base-time $BASE_TIME \
      sched-entry S 01 2000000 \
      sched-entry S 02 3000000 \
      sched-entry S 04 4000000 \
      sched-entry S 00 1000000 \
      clockid CLOCK_TAI

Thinking a bit more, taprio in txtime-assisted mode and ETF with no
offloading, *might* be better, if its limitation of only being able to
use a single TX queue isn't a blocker.

Something like this:

$ tc qdisc replace dev $IFACE parent root handle 100 taprio \
      num_tc 4 \
      map 2 3 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
      queues 1@0 1@0 1@0 1@0 \
      base-time $BASE_TIME \
      sched-entry S 0xC 250000 \
      sched-entry S 0x1 250000 \
      sched-entry S 0x2 250000 \
      sched-entry S 0x4 250000 \
      txtime-delay 300000 \
      flags 0x1 \
      clockid CLOCK_TAI

$ tc qdisc replace dev $IFACE parent 100:1 etf \
      delta 200000 clockid CLOCK_TAI skip_sock_check

Cheers,
--
Vinicius
