Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D158963BE4
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfGIT1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:27:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:39152 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727787AbfGIT1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:27:20 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 91B0CBC005A;
        Tue,  9 Jul 2019 19:27:18 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 9 Jul
 2019 12:27:14 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH net-next 0/3] net: batched receive in GRO path
To:     David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7920e85c-439e-0622-46f8-0602cf37e306@solarflare.com>
Date:   Tue, 9 Jul 2019 20:27:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24748.005
X-TM-AS-Result: No-6.722000-4.000000-10
X-TMASE-MatchedRID: 80sgmbgkAKBjJRYrYz9aZmgws6g0ewz2fo0lncdGFFP22R14ijZDjBZe
        oMn8xA+cxhbqMAz+sH6VijEpnyRMhw82vHIf00E6DOL14/DRHdDpVMb1xnESMlT4wXE1Q3+tKHp
        SM6RPsvLmHS3ctwnBBnY+rAPR3hdU0nl1nsNjR7hSFqtD2wqeMfngX/aL8PCNmJBe2bRXwlNhn7
        T+c//Exr47XfUUpkezn6XhnzyfSWTloCs7pAMiM4ph1hAtvKZNoiY7auV7G1IOUs4CTUgKy9ZsI
        s+VoXI0hUmZaeQpcty9/GoS6fS5VoIP10bKeQJ00Az+qa2CoAqWGk93C/VnSgvrbFcH4G2ryiOy
        wU4g9ARFf/YQed81Ou/EvlDYfLg2dWceIpiTVHBkQov1aWjE1wD4keG7QhHme+xt+hmLFRO2jjo
        uEtOSP23tkWYJo9ZLoY/D5DVvh5Bn+YRG/wReVQXGi/7cli9jAQVng8XtStA52X8YwVUEW5HsEP
        QHz+ssBSVPXlTYuFRtTJUyGYorCkLkU2wqeSg+R/j040fRFpL4h+uI7dxXxEzECFBbaHiH3b+XW
        gntZKduGrqrISdqmxHLO/iWX+eSUYR3k5IGZuaeAiCmPx4NwFkMvWAuahr8LzP5snaeb1Qqtq5d
        3cxkNa6KQIvxVddMsr7mnRcLNETleucGbXnQcYYrIzH9m2wKhI6trXakOcVnIxZyJs78kg==
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.722000-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24748.005
X-MDID: 1562700439-b8DE75_J0kOX
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
Unlike my previous design ([1]), this does not require changes in drivers,
 and also does not prevent the re-use of napi->skb after GRO_MERGED_FREE or
 GRO_DROP.

Performance figures with this series, collected on a back-to-back pair of
 Solarflare sfn8522-r2 NICs with 120-second NetPerf tests.  In the stats,
 sample size n for old and new code is 6 runs each; p is from a Welch t-test.
Tests were run both with GRO enabled and disabled, the latter simulating
 uncoalesceable packets (e.g. due to IP or TCP options).  The receive side
 (which was the device under test) had the NetPerf process pinned to one CPU,
 and the device interrupts pinned to a second CPU.  CPU utilisation figures
 (used in cases of line-rate performance) are summed across all CPUs.
Where not specified (as batch=), net.core.gro_normal_batch was set to 8.
The net-next baseline used for these tests was commit 7d30a7f6424e.
TCP 4 streams, GRO on: all results line rate (9.415Gbps)
net-next: 210.3% cpu
after #1: 181.5% cpu (-13.7%, p=0.031 vs net-next)
after #3: 191.7% cpu (- 8.9%, p=0.102 vs net-next)
TCP 4 streams, GRO off:
after #1: 7.785 Gbps
after #3: 8.387 Gbps (+ 7.7%, p=0.215 vs #1, but note *)
TCP 1 stream, GRO on: all results line rate & ~200% cpu.
TCP 1 stream, GRO off:
after #1: 6.444 Gbps
after #3: 7.363 Gbps (+14.3%, p=0.003 vs #1)
batch=16: 7.199 Gbps
batch= 4: 7.354 Gbps
batch= 0: 5.899 Gbps
TCP 100 RR, GRO off:
net-next: 995.083 us
after #1: 969.167 us (- 2.6%, p=0.204 vs net-next)
after #3: 976.433 us (- 1.9%, p=0.254 vs net-next)

(*) These tests produced a mixture of line-rate and below-line-rate results,
 meaning that statistically speaking the results were 'censored' by the
 upper bound, and were thus not normally distributed, making a Welch t-test
 mathematically invalid.  I therefore also calculated estimators according
 to [2], which gave the following:
after #1: 8.155 Gbps
after #3: 8.716 Gbps (+ 6.9%, p=0.291 vs #1)
(though my procedure for determining ν wasn't mathematically well-founded
 either, so take that p-value with a grain of salt).

Conclusion:
* Patch #1 is a fairly unambiguous improvement.
* Patch #3 has no statistically significant effect when GRO is active.
* Any effect of patch #3 on latency is within statistical noise.
* When GRO is inactive, patch #3 improves bandwidth, though for multiple
  streams the effect is smaller (possibly owing to the line-rate limit).
* The optimal batch size for this setup appears to be around 8.
* Setting the batch size to zero gives worse performance than before the
  patch; perhaps a static key is needed?
* Drivers which, unlike sfc, pass UDP traffic to GRO would expect to see a
  benefit from gaining access to batching.

Notes for future thought: in principle if we passed the napi pointer to
 napi_gro_complete(), it could add its superframe skb to napi->rx_list,
 rather than immediately netif_receive_skb_internal()ing it.  Without that
 I'm not sure if there's a possibility of OoO between normal and GROed SKBs
 on the same flow.

[1]: http://patchwork.ozlabs.org/cover/997844/
[2]: Cohen 1959, doi: 10.1080/00401706.1959.10489859

Edward Cree (3):
  sfc: don't score irq moderation points for GRO
  sfc: falcon: don't score irq moderation points for GRO
  net: use listified RX for handling GRO_NORMAL skbs

 drivers/net/ethernet/sfc/falcon/rx.c |  5 +----
 drivers/net/ethernet/sfc/rx.c        |  5 +----
 include/linux/netdevice.h            |  3 +++
 net/core/dev.c                       | 32 ++++++++++++++++++++++++++--
 net/core/sysctl_net_core.c           |  8 +++++++
 5 files changed, 43 insertions(+), 10 deletions(-)

