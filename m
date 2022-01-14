Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8279848E3F2
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 06:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbiANFs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 00:48:56 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:47024 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231322AbiANFs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 00:48:56 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V1nD.LV_1642139333;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V1nD.LV_1642139333)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Jan 2022 13:48:54 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [RFC PATCH net-next 0/6] net/smc: Spread workload over multiple cores
Date:   Fri, 14 Jan 2022 13:48:46 +0800
Message-Id: <20220114054852.38058-1-tonylu@linux.alibaba.com>
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
ibdev's ability (num_comp_vectors). In the scenen of multiple linkgroups,
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

Here is the benchmark with this patch (prototype of new model):

Test environment:
- CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4.
- nginx + wrk HTTP benchmark.
- nginx: disable access_log, increase keepalive_timeout and
  keepalive_requests, long-live connection.
- wrk: 8 threads and 100, 200, 400 connections.

Benchmark result:

Conns/QPS         100        200        400
w/o patch   338502.49  359216.66  398167.16
w/  patch   677247.40  694193.70  812502.69
Ratio        +100.07%    +93.25%   +104.06%

This prototype patches show nealy 1x increasement of QPS.

The benchmarkes of 100, 200, 400 connections use 1, 1, 2 link groups.
When link group is one, it spreads send/recv to two cores. Once more
than one link groups, it would spread to more cores.

If the application's connections is no more than link group's limitation
(SMC_RMBS_PER_LGR_MAX, 255), and CPU resources is restricted. This patch
introduces a tunable way to reduce the hard limitation of link group
connections number. It reduces the restriction of less CQs (cores) and
less competition, such as link-level CDC slots. It depends on the scenes
of applications, so this patch provides a userspace knob, users can
choose to share link groups for saving resources, or create more link
groups for less limitation.

Patch 1-4 introduce multiple CQs support.
- Patch 1 spreads CQ to two cores, it works for less connections.
- Patch 2, 3, 4 introduce multiple CQs support, involves a new medium
  to tie link and ibdev, and load balancing between different completion
  vectors and CQs.
- the policy of spreading CQs is still thinking and testing to get
  highest performance, such as splitting recv/send CQs, or joining them
  together, or bind recv/recv (send/send) CQ to same vector and so on.
  Glad to hear your advice.

Patch 5 is a medium for userspace control knob.
- mainly provide two knobs to adjust the buffer size of smc socket. We
  found that too little buffers would let smc wait for buffer for a long
  time, and limit the performance.
- introduce a sysctl framework, just for tuning, netlink also does work.
  Because sysctl is easy to compose as patch and no need userspace example.
  I am glad to wait for your advice about the control panel for
  userspace.

Patch 6 introduces a tunable knob to decrease the per link group
connections' number, which would increase parallel performance as
mentioned previous.

These patches are still improving, I am very glad to hear your advice.

Thank you.

Tony Lu (6):
  net/smc: Spread CQs to differents completion vectors
  net/smc: Prepare for multiple CQs per IB devices
  net/smc: Introduce smc_ib_cq to bind link and cq
  net/smc: Multiple CQs per IB devices
  net/smc: Unbind buffer size from clcsock and make it tunable
  net/smc: Introduce tunable linkgroup max connections

 Documentation/networking/smc-sysctl.rst |  20 +++
 include/net/netns/smc.h                 |   6 +
 net/smc/Makefile                        |   2 +-
 net/smc/af_smc.c                        |  18 ++-
 net/smc/smc_core.c                      |   2 +-
 net/smc/smc_core.h                      |   2 +
 net/smc/smc_ib.c                        | 178 ++++++++++++++++++++----
 net/smc/smc_ib.h                        |  17 ++-
 net/smc/smc_sysctl.c                    |  92 ++++++++++++
 net/smc/smc_sysctl.h                    |  22 +++
 net/smc/smc_wr.c                        |  42 +++---
 11 files changed, 350 insertions(+), 51 deletions(-)
 create mode 100644 Documentation/networking/smc-sysctl.rst
 create mode 100644 net/smc/smc_sysctl.c
 create mode 100644 net/smc/smc_sysctl.h

-- 
2.32.0.3.g01195cf9f

