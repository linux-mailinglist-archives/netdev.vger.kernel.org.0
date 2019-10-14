Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0322D6BF6
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 01:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfJNXNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 19:13:50 -0400
Received: from mga06.intel.com ([134.134.136.31]:31406 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbfJNXNu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Oct 2019 19:13:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Oct 2019 16:13:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,296,1566889200"; 
   d="scan'208";a="396624945"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.82])
  by fmsmga006.fm.intel.com with ESMTP; 14 Oct 2019 16:13:48 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Murali Karicheri <m-karicheri2@ti.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: taprio testing - Any help?
In-Reply-To: <CA+h21hon+QzS7tRytM2duVUvveSRY5BOGXkHtHOdTEwOSBcVAg@mail.gmail.com>
References: <a69550fc-b545-b5de-edd9-25d1e3be5f6b@ti.com> <87v9sv3uuf.fsf@linux.intel.com> <7fc6c4fd-56ed-246f-86b7-8435a1e58163@ti.com> <87r23j3rds.fsf@linux.intel.com> <CA+h21hon+QzS7tRytM2duVUvveSRY5BOGXkHtHOdTEwOSBcVAg@mail.gmail.com>
Date:   Mon, 14 Oct 2019 16:14:48 -0700
Message-ID: <87a7a25387.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

>
> What do you mean taprio doesn't support tc filter blocks? What do you
> think there is to do in taprio to support that?
> I don't think Murali is asking for filter offloading, but merely for a
> way to direct frames to a certain traffic class on xmit from Linux.
> Something like this works perfectly fine:
>
> sudo tc qdisc add dev swp2 root handle 1: taprio num_tc 2 map 0 1
> queues 1@0 1@1 base-time 1000 sched-entry S 03 300000 flags 2
> # Add the qdisc holding the classifiers
> sudo tc qdisc add dev swp2 clsact
> # Steer L2 PTP to TC 1 (see with "tc filter show dev swp2 egress")
> sudo tc filter add dev swp2 egress prio 1 u32 match u16 0x88f7 0xffff
> at -2 action skbedit priority 1
>

That's cool. Everyday I'm learning something new :-)

> However, the clsact qdisc and tc u32 egress filter can be replaced
> with proper use of the SO_PRIORITY API, which is preferable for new
> applications IMO.
>
> I'm trying to send a demo application to tools/testing/selftests/
> which sends cyclic traffic through a raw L2 socket at a configurable
> base-time and cycle-time, along with the accompanying scripts to set
> up the receiver and bandwidth reservation on an in-between switch. But
> I have some trouble getting the sender application to work reliably at
> 100 us cycle-time, so it may take a while until I figure out with
> kernelshark what's going on.

Yeah, 100us cycle-time for software mode is kind of hard to make it work
reliably. i.e. without any offloading, I can only get something close to
that to work with a PREEMPT_RT kernel and disabling all kinds of power
saving features.


Cheers,
--
Vinicius
