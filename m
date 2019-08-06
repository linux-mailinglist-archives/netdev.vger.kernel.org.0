Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB3C83352
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 15:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfHFNwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 09:52:13 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:44426 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbfHFNwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 09:52:13 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B831614008D;
        Tue,  6 Aug 2019 13:52:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 6 Aug
 2019 06:52:07 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v3 net-next 0/3] net: batched receive in GRO path
To:     David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        <linux-net-drivers@solarflare.com>
Message-ID: <c6e2474e-2c8a-5881-86bf-59c66bdfc34f@solarflare.com>
Date:   Tue, 6 Aug 2019 14:52:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24824.005
X-TM-AS-Result: No-2.095900-4.000000-10
X-TMASE-MatchedRID: 80sgmbgkAKBjJRYrYz9aZmgws6g0ewz2fo0lncdGFFP22R14ijZDjBZe
        oMn8xA+cxhbqMAz+sH6VijEpnyRMhw82vHIf00E6DOL14/DRHdDpVMb1xnESMlT4wXE1Q3+tsvO
        Ufe+3re0bwAKQ5596XrR/4ZyrTbfcvQZhTFmx+8jylEfNwb6iLfX71s7cIJuTsS0sZEB7c8bDbM
        epoGwB56ai9oNKk5/0an1kBFEaVX+6qJkiP4WhMyqwx8x+s5lFO4NrJdLQuoHWXfwzppZ8SExT9
        a2g8S09XVb1YVt9DnuCf3gIpHM8T7MxctdgEdwy52cbj4/WmPtDfut2Lc1Yhwo0WrqzcfeOliNc
        JScWqB5U4ZgYBGHa9EpQdH2+JITlrFMDyJP7G26FXk+vEfaJJczzMs2dyeyVe+xt+hmLFRNRLTE
        RhRg1g1YVEmmceHTqpqd12oG3Y4fjtwtQtmXE5ZyebS/i2xjjE9jZI/dKaABUjspoiX02F0DcCr
        lcXWXIXnxHdapXvcz+Mru+sXzdYHXZ29PKwetshL9NX2TqmkAlWygvtTclwA+XMlIFkG/VA+FKi
        +KNuiLTvdrN4+rgfZxWmvt/7ojS+nZRZZD696n27WtDgGBc8k16N0DD9tffmyiLZetSf8mZMPCn
        TMzfOiq2rl3dzGQ1/tQArNcrq34e5Qi72hj5FBFn02NWO/wq0oSuGrtBTJsh2t3AVG+vWNfE5lk
        FPKYH8w52f2RWypLzFOa3wTBeYvFimqAyUm86OGucnPxU5fhDgw2OfwbhLKMa5OkNpiHkifsL+6
        CY4RnJZmo0UvMlsUMMprcbiest
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.095900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24824.005
X-MDID: 1565099532-1vxpgRdmoQT6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series listifies part of GRO processing, in a manner which allows those
 packets which are not GROed (i.e. for which dev_gro_receive returns
 GRO_NORMAL) to be passed on to the listified regular receive path.
dev_gro_receive() itself is not listified, nor the per-protocol GRO
 callback, since GRO's need to hold packets on lists under napi->gro_hash
 makes keeping the packets on other lists awkward, and since the GRO control
 block state of held skbs can refer only to one 'new' skb at a time.
Instead, when napi_frags_finish() handles a GRO_NORMAL result, stash the skb
 onto a list in the napi struct, which is received at the end of the napi
 poll or when its length exceeds the (new) sysctl net.core.gro_normal_batch.

Performance figures with this series, collected on a back-to-back pair of
 Solarflare sfn8522-r2 NICs with 120-second NetPerf tests.  In the stats,
 sample size n for old and new code is 6 runs each; p is from a Welch t-test.
Tests were run both with GRO enabled and disabled, the latter simulating
 uncoalesceable packets (e.g. due to IP or TCP options).  The receive side
 (which was the device under test) had the NetPerf process pinned to one CPU,
 and the device interrupts pinned to a second CPU.  CPU utilisation figures
 (used in cases of line-rate performance) are summed across all CPUs.
net.core.gro_normal_batch was left at its default value of 8.

TCP 4 streams, GRO on: all results line rate (9.415Gbps)
net-next: 210.3% cpu
after #1: 181.5% cpu (-13.7%, p=0.031 vs net-next)
after #3: 196.7% cpu (- 8.4%, p=0.136 vs net-next)
TCP 4 streams, GRO off:
net-next: 8.017 Gbps
after #1: 7.785 Gbps (- 2.9%, p=0.385 vs net-next)
after #3: 7.604 Gbps (- 5.1%, p=0.282 vs net-next.  But note *)
TCP 1 stream, GRO off:
net-next: 6.553 Gbps
after #1: 6.444 Gbps (- 1.7%, p=0.302 vs net-next)
after #3: 6.790 Gbps (+ 3.6%, p=0.169 vs net-next)
TCP 1 stream, GRO on, busy_read = 50: all results line rate
net-next: 156.0% cpu
after #1: 174.5% cpu (+11.9%, p=0.015 vs net-next)
after #3: 165.0% cpu (+ 5.8%, p=0.147 vs net-next)
TCP 1 stream, GRO off, busy_read = 50:
net-next: 6.488 Gbps
after #1: 6.625 Gbps (+ 2.1%, p=0.059 vs net-next)
after #3: 7.351 Gbps (+13.3%, p=0.026 vs net-next)
TCP_RR 100 streams, GRO off, 8000 byte payload
net-next: 995.083 us
after #1: 969.167 us (- 2.6%, p=0.204 vs net-next)
after #3: 976.433 us (- 1.9%, p=0.254 vs net-next)
TCP_RR 100 streams, GRO off, 8000 byte payload, busy_read = 50:
net-next:   2.851 ms
after #1:   2.871 ms (+ 0.7%, p=0.134 vs net-next)
after #3:   2.937 ms (+ 3.0%, p<0.001 vs net-next)
TCP_RR 100 streams, GRO off, 1 byte payload, busy_read = 50:
net-next: 867.317 us
after #1: 865.717 us (- 0.2%, p=0.334 vs net-next)
after #3: 868.517 us (+ 0.1%, p=0.414 vs net-next)

(*) These tests produced a mixture of line-rate and below-line-rate results,
 meaning that statistically speaking the results were 'censored' by the
 upper bound, and were thus not normally distributed, making a Welch t-test
 mathematically invalid.  I therefore also calculated estimators according
 to [1], which gave the following:
net-next: 8.133 Gbps
after #1: 8.130 Gbps (- 0.0%, p=0.499 vs net-next)
after #3: 7.680 Gbps (- 5.6%, p=0.285 vs net-next)
(though my procedure for determining ν wasn't mathematically well-founded
 either, so take that p-value with a grain of salt).
A further check came from dividing the bandwidth figure by the CPU usage for
 each test run, giving:
net-next: 3.461
after #1: 3.198 (- 7.6%, p=0.145 vs net-next)
after #3: 3.641 (+ 5.2%, p=0.280 vs net-next)

The above results are fairly mixed, and in most cases not statistically
 significant.  But I think we can roughly conclude that the series
 marginally improves non-GROable throughput, without hurting latency
 (except in the large-payload busy-polling case, which in any case yields
 horrid performance even on net-next (almost triple the latency without
 busy-poll).  Also, drivers which, unlike sfc, pass UDP traffic to GRO
 would expect to see a benefit from gaining access to batching.

Changed in v3:
 * gro_normal_batch sysctl now uses SYSCTL_ONE instead of &one
 * removed RFC tags (no comments after a week means no-one objects, right?)

Changed in v2:
 * During busy poll, call gro_normal_list() to receive batched packets
   after each cycle of the napi busy loop.  See comments in Patch #3 for
   complications of doing the same in busy_poll_stop().

[1]: Cohen 1959, doi: 10.1080/00401706.1959.10489859

Edward Cree (3):
  sfc: don't score irq moderation points for GRO
  sfc: falcon: don't score irq moderation points for GRO
  net: use listified RX for handling GRO_NORMAL skbs

 drivers/net/ethernet/sfc/falcon/rx.c |  5 +---
 drivers/net/ethernet/sfc/rx.c        |  5 +---
 include/linux/netdevice.h            |  3 ++
 net/core/dev.c                       | 44 ++++++++++++++++++++++++++--
 net/core/sysctl_net_core.c           |  8 +++++
 5 files changed, 54 insertions(+), 11 deletions(-)

