Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF315D6C23
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 01:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbfJNXjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 19:39:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:30077 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfJNXjA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 19:39:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 16:38:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="396629805"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 14 Oct 2019 16:38:59 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: taprio testing - Any help?
In-Reply-To: <45d3e5ed-7ddf-3d1d-9e4e-f555437b06f9@ti.com>
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com> <87v9sv3uuf.fsf@linux.intel.com> <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com> <87r23j3rds.fsf@linux.intel.com> <CA+h21hon+QzS7tRytM2duVUvveSRY5BOGXkHtHOdTEwOSBcVAg@mail.gmail.com> <45d3e5ed-7ddf-3d1d-9e4e-f555437b06f9@ti.com>
Date:   Mon, 14 Oct 2019 16:39:58 -0700
Message-ID: <871rve5229.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Murali Karicheri <m-karicheri2@ti.com> writes:
>
> My expectation is as follows
>
> AAAAAABBBBBCCCCCDDDDDEEEEE
>
> Where AAAAA is traffic from TC0, BBBBB is udp stream for port 10000
> CCCCC is stream for port 20000, DDDDD for 30000 and EEEEE for 40000.
> Each can be max of 4 msec. Is the expection correct? At least that
> is my understanding.

Your expectation is correct.

>
> But what I see is alternating packets with port 10000/20000/30000/40000
> at the wireshark capture and it doesn't make sense to me. If you
> look at the timestamp, there is nothing showing the Gate is honored
> for Tx. Am I missing something?

Remember that taprio (in software mode) has no control after the packet
is delivered to the driver. So, even if taprio obeys your traffic
schedule perfectly, the driver/controller may decide to send packets
according to some other logic.

>
> The tc stats shows packets are going through specific TC/Gate
>
> root@am57xx-evm:~# tc -d -p -s qdisc show dev eth0
> qdisc taprio 100: root refcnt 9 tc 5 map 0 1 2 3 4 4 4 4 4 4 4 4 4 4 4 4
> queues offset 0 count 1 offset 1 count 1 offset 2 count 1 offset 3 count 
> 1 offset 4 count 1
> clockid TAI offload 0   base-time 0 cycle-time 0 cycle-time-extension 0 
> base-time 1564768921123459533 cycle-time 20000000 cycle-
> time-extension 0
>          index 0 cmd S gatemask 0x1 interval 4000000
>          index 1 cmd S gatemask 0x2 interval 4000000
>          index 2 cmd S gatemask 0x4 interval 4000000
>          index 3 cmd S gatemask 0x8 interval 4000000
>          index 4 cmd S gatemask 0x10 interval 4000000
>
>   Sent 80948029 bytes 53630 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> qdisc pfifo 0: parent 100:5 limit 1000p
>   Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> qdisc pfifo 0: parent 100:4 limit 1000p
>   Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> qdisc pfifo 0: parent 100:3 limit 1000p
>   Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> qdisc pfifo 0: parent 100:2 limit 1000p
>   Sent 16184448 bytes 10704 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
> qdisc pfifo 0: parent 100:1 limit 1000p
>   Sent 16210237 bytes 10814 pkt (dropped 0, overlimits 0 requeues 0)
>   backlog 0b 0p requeues 0
>
> Also my hardware queue stats shows frames going through correct queues.
> Am I missing something?
>

What I usually see in these cases, are that the borders (from A to B,
for example) are usually messy, the middle of each entry are more well
behaved.

But there are things that could improve the behavior: reducing TX DMA
coalescing, reducing the number of packet buffers in use in the
controller, disabling power saving features, that kind of thing.

If you are already doing something like this, then I would like to know
more, that could indicate a problem.

[...]

> I am on a 4.19.y kernel with patches specific to taprio
> backported. Am I missing anything related to taprio. I will
> try on the latest master branch as well. But if you can point out
> anything that will be helpful.
>

[...]

> lcpd/ti-linux-4.19.y) Merged TI feature connectivity into
> ti-linux-4.19.y

I can't think of anything else.

>
>> 
>> Regards,
>> -Vladimir
>> 

Cheers,
--
Vinicius
