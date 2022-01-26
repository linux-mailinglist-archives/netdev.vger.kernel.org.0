Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB8C49CA40
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 14:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbiAZNC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 08:02:26 -0500
Received: from out199-4.us.a.mail.aliyun.com ([47.90.199.4]:59131 "EHLO
        out199-4.us.a.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229928AbiAZNC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 08:02:26 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V2vapeq_1643202141;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V2vapeq_1643202141)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 21:02:22 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH net-next 0/2] net/smc: Spread workload over multiple cores
Date:   Wed, 26 Jan 2022 21:01:39 +0800
Message-Id: <20220126130140.66316-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, SMC creates one CQ per IB device, and shares this cq among
all the QPs of links. Meanwhile, this CQ is always binded to the first
completion vector, the IRQ affinity of this vector binds to some CPU
core. 

┌────────┐    ┌──────────────┐   ┌──────────────┐
│ SMC IB │    ├────┐         │   │              │
│ DEVICE │ ┌─▶│ QP │ SMC LINK├──▶│SMC Link Group│
│   ┌────┤ │  ├────┘         │   │              │
│   │ CQ ├─┘  └──────────────┘   └──────────────┘
│   │    ├─┐  ┌──────────────┐   ┌──────────────┐
│   └────┤ │  ├────┐         │   │              │
│        │ └─▶│ QP │ SMC LINK├──▶│SMC Link Group│
│        │    ├────┘         │   │              │
└────────┘    └──────────────┘   └──────────────┘

In this model, when connections execeeds SMC_RMBS_PER_LGR_MAX, it will
create multiple link groups and corresponding QPs. All the connections
share limited QPs and one CQ (both recv and send sides). Generally, one
completion vector binds to a fixed CPU core, it will limit the
performance by single core, and large-scale scenes, such as multiple
threads and lots of connections.

Running nginx and wrk test with 8 threads and 800 connections on 8 cores
host, the softirq of CPU 0 is limited the scalability:

04:18:54 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
04:18:55 PM  all    5.81    0.00   19.42    0.00    2.94   10.21    0.00    0.00    0.00   61.63
04:18:55 PM    0    0.00    0.00    0.00    0.00   16.80   82.78    0.00    0.00    0.00    0.41
<snip>

Nowadays, RDMA devices have more than one completion vectors, such as
mlx5 has 8, eRDMA has 4 completion vector by default. This unlocks the
limitation of single vector and single CPU core.

To enhance scalability and take advantage of multi-core resources, we
can spread CQs to different CPU cores, and introduce more flexible
mapping. Here comes up a new model, the main different is that creating
multiple CQs per IB device, which the max number of CQs is limited by
ibdev's ability (num_comp_vectors). In the scene of multiple linkgroups,
the link group's QP can bind to the least used CQ, and CQs are binded
to different completion vector and CPU cores. So that we can spread
the softirq (tasklet of wr tx/rx) handler to different cores.

                        ┌──────────────┐   ┌──────────────┐
┌────────┐  ┌───────┐   ├────┐         │   │              │
│        ├─▶│ CQ 0  ├──▶│ QP │ SMC LINK├──▶│SMC Link Group│
│        │  └───────┘   ├────┘         │   │              │
│ SMC IB │  ┌───────┐   └──────────────┘   └──────────────┘
│ DEVICE ├─▶│ CQ 1  │─┐                                    
│        │  └───────┘ │ ┌──────────────┐   ┌──────────────┐
│        │  ┌───────┐ │ ├────┐         │   │              │
│        ├─▶│ CQ n  │ └▶│ QP │ SMC LINK├──▶│SMC Link Group│
└────────┘  └───────┘   ├────┘         │   │              │
                        └──────────────┘   └──────────────┘

After sperad one CQ (4 linkgroups) to four CPU cores, the softirq load
spreads to different cores:

04:26:25 PM  CPU    %usr   %nice    %sys %iowait    %irq   %soft  %steal  %guest  %gnice   %idle
04:26:26 PM  all   10.70    0.00   35.80    0.00    7.64   26.62    0.00    0.00    0.00   19.24
04:26:26 PM    0    0.00    0.00    0.00    0.00   16.33   50.00    0.00    0.00    0.00   33.67
04:26:26 PM    1    0.00    0.00    0.00    0.00   15.46   69.07    0.00    0.00    0.00   15.46
04:26:26 PM    2    0.00    0.00    0.00    0.00   13.13   39.39    0.00    0.00    0.00   47.47
04:26:26 PM    3    0.00    0.00    0.00    0.00   13.27   55.10    0.00    0.00    0.00   31.63
<snip>

Here is the benchmark with this patch set:

Test environment:
- CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4.
- nginx + wrk HTTP benchmark.
- nginx: disable access_log, increase keepalive_timeout and
  keepalive_requests, long-live connection, return 200 directly.
- wrk: 8 threads and 100, 200, 400 connections.

Benchmark result:

Conns/QPS         100        200        400
w/o patch   338502.49  359216.66  398167.16
w/  patch   677247.40  694193.70  812502.69
Ratio        +100.07%    +93.25%   +104.06%

This patch set shows nearly 1x increasement of QPS.

The benchmarks of 100, 200, 400 connections use 1, 1, 2 link groups.
When link group is one, it spreads send/recv to two cores. Once more
than one link groups, it would spread to more cores.

RFC Link: https://lore.kernel.org/netdev/YeRaSdg8TcNJsGBB@TonyMac-Alibaba/T/

These two patches split from previous RFC, and move netlink related patch
to the next patch set.

Tony Lu (2):
  net/smc: Introduce smc_ib_cq to bind link and cq
  net/smc: Multiple CQs per IB devices

 net/smc/smc_core.h |   2 +
 net/smc/smc_ib.c   | 132 ++++++++++++++++++++++++++++++++++++---------
 net/smc/smc_ib.h   |  15 ++++--
 net/smc/smc_wr.c   |  44 +++++++++------
 4 files changed, 148 insertions(+), 45 deletions(-)

-- 
2.32.0.3.g01195cf9f

