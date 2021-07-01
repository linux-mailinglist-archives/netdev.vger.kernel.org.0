Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9D43B91A2
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 14:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbhGAM35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 08:29:57 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:9333 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbhGAM3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 08:29:52 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GFy6F1zwPz74K4;
        Thu,  1 Jul 2021 20:23:01 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 20:27:14 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 20:27:14 +0800
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <mst@redhat.com>
CC:     <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [PATCH net-next v3 0/3] add benchmark selftest and optimization for ptr_ring
Date:   Thu, 1 Jul 2021 20:26:39 +0800
Message-ID: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1: add a selftest app to benchmark the performance
         of ptr_ring.
Patch 2: move r->queue[] clearing after r->consumer_head
         updating.
Patch 3: add barrier to ensure the visiblity of r->queue[].

V3: add patch 3 and address most of Michael's comment.
V2: add patch 1 and add performance data for patch 2.

---
Performance raw data using "perf stat -r" cmd, comparison
is also done in patch 2/3.
ptr_ring_test_org: patch 1
ptr_ring_test_opt1: patch 1 + patch 2
ptr_ring_test_opt2: patch 1 + patch 2 + patch 3


x86_64(as there is other workload in the x86_64 system, so
run 1000 times to get more accurate result):

Performance counter stats for './ptr_ring_test_org -s 1000 -m 1 -N 100000000' (1000 runs):

          5,291.83 msec task-clock                #    1.994 CPUs utilized            ( +-  0.41% )
               690      context-switches          #    0.130 K/sec                    ( +-  3.65% )
                 8      cpu-migrations            #    0.002 K/sec                    ( +-  5.70% )
               291      page-faults               #    0.055 K/sec                    ( +-  0.05% )
    12,660,040,758      cycles                    #    2.392 GHz                      ( +-  0.41% )
    24,202,160,722      instructions              #    1.91  insn per cycle           ( +-  0.06% )
     3,559,123,597      branches                  #  672.569 M/sec                    ( +-  0.07% )
         8,009,010      branch-misses             #    0.23% of all branches          ( +-  0.11% )

            2.6538 +- 0.0109 seconds time elapsed  ( +-  0.41% )

 Performance counter stats for './ptr_ring_test_opt1 -s 1000 -m 1 -N 100000000' (1000 runs):

          5,064.95 msec task-clock                #    1.992 CPUs utilized            ( +-  0.55% )
               668      context-switches          #    0.132 K/sec                    ( +-  4.20% )
                 9      cpu-migrations            #    0.002 K/sec                    ( +-  4.45% )
               291      page-faults               #    0.057 K/sec                    ( +-  0.06% )
    12,117,262,182      cycles                    #    2.392 GHz                      ( +-  0.55% )
    22,586,035,716      instructions              #    1.86  insn per cycle           ( +-  0.08% )
     3,404,652,345      branches                  #  672.199 M/sec                    ( +-  0.10% )
         7,864,190      branch-misses             #    0.23% of all branches          ( +-  0.16% )

            2.5422 +- 0.0142 seconds time elapsed  ( +-  0.56% )

 Performance counter stats for './ptr_ring_test_opt2 -s 1000 -m 1 -N 100000000' (1000 runs):

          5,105.33 msec task-clock                #    1.995 CPUs utilized            ( +-  0.47% )
               589      context-switches          #    0.115 K/sec                    ( +-  4.24% )
                11      cpu-migrations            #    0.002 K/sec                    ( +-  4.24% )
               292      page-faults               #    0.057 K/sec                    ( +-  0.04% )
    12,214,160,307      cycles                    #    2.392 GHz                      ( +-  0.47% )
    22,756,292,370      instructions              #    1.86  insn per cycle           ( +-  0.10% )
     3,429,218,233      branches                  #  671.694 M/sec                    ( +-  0.12% )
         7,921,984      branch-misses             #    0.23% of all branches          ( +-  0.15% )

            2.5587 +- 0.0122 seconds time elapsed  ( +-  0.47% )


-------------------------------------------------------------------------------------------------
arm64(using taskset to avoid the numa effects):

Performance counter stats for 'taskset -c 0-1 ./ptr_ring_test_org -s 1000 -m 1 -N 100000000' (100 runs):

           4172.83 msec task-clock                #    1.999 CPUs utilized            ( +-  0.01% )
                54      context-switches          #    0.013 K/sec                    ( +-  0.29% )
                 1      cpu-migrations            #    0.000 K/sec
               115      page-faults               #    0.028 K/sec                    ( +-  0.16% )
       10848085945      cycles                    #    2.600 GHz                      ( +-  0.01% )
       25808501369      instructions              #    2.38  insn per cycle           ( +-  0.00% )
   <not supported>      branches
          11190266      branch-misses                                                 ( +-  0.02% )

          2.087205 +- 0.000130 seconds time elapsed  ( +-  0.01% )


 Performance counter stats for 'taskset -c 0-1 ./ptr_ring_test_opt1 -s 1000 -m 1 -N 100000000' (100 runs):

           3774.91 msec task-clock                #    1.999 CPUs utilized            ( +-  0.03% )
                50      context-switches          #    0.013 K/sec                    ( +-  0.36% )
                 1      cpu-migrations            #    0.000 K/sec
               114      page-faults               #    0.030 K/sec                    ( +-  0.15% )
        9813658996      cycles                    #    2.600 GHz                      ( +-  0.03% )
       23920189000      instructions              #    2.44  insn per cycle           ( +-  0.01% )
   <not supported>      branches
          10018927      branch-misses                                                 ( +-  0.04% )

          1.888224 +- 0.000541 seconds time elapsed  ( +-  0.03% )

 Performance counter stats for 'taskset -c 0-1 ./ptr_ring_test_opt2 -s 1000 -m 1 -N 100000000' (100 runs):

           3785.79 msec task-clock                #    1.999 CPUs utilized            ( +-  0.03% )
                49      context-switches          #    0.013 K/sec                    ( +-  0.32% )
                 1      cpu-migrations            #    0.000 K/sec
               114      page-faults               #    0.030 K/sec                    ( +-  0.15% )
        9842067534      cycles                    #    2.600 GHz                      ( +-  0.03% )
       24074397270      instructions              #    2.45  insn per cycle           ( +-  0.01% )
   <not supported>      branches
          10091918      branch-misses                                                 ( +-  0.04% )

          1.893673 +- 0.000508 seconds time elapsed  ( +-  0.03% )

Yunsheng Lin (3):
  selftests/ptr_ring: add benchmark application for ptr_ring
  ptr_ring: move r->queue[] clearing after r->consumer_head updating
  ptr_ring: add barrier to ensure the visiblity of r->queue[]

 MAINTAINERS                                      |   5 +
 include/linux/ptr_ring.h                         |  52 ++++--
 tools/testing/selftests/ptr_ring/Makefile        |   6 +
 tools/testing/selftests/ptr_ring/ptr_ring_test.c | 224 +++++++++++++++++++++++
 tools/testing/selftests/ptr_ring/ptr_ring_test.h | 130 +++++++++++++
 5 files changed, 399 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/ptr_ring/Makefile
 create mode 100644 tools/testing/selftests/ptr_ring/ptr_ring_test.c
 create mode 100644 tools/testing/selftests/ptr_ring/ptr_ring_test.h

-- 
2.7.4

