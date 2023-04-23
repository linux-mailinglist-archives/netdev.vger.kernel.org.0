Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DF3D6EBF50
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 14:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjDWMSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 08:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjDWMSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 08:18:01 -0400
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74F61737;
        Sun, 23 Apr 2023 05:17:57 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VgjtUlE_1682252272;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VgjtUlE_1682252272)
          by smtp.aliyun-inc.com;
          Sun, 23 Apr 2023 20:17:54 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v5 0/9] net/smc: Introduce SMC-D-based OS internal communication acceleration
Date:   Sun, 23 Apr 2023 20:17:42 +0800
Message-Id: <1682252271-2544-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, all

# Background

The background and previous discussion can be referred from [1]~[3].

We found SMC-D can be used to accelerate OS internal communication, such as
loopback or between two containers within the same OS instance. So this patch
set provides a kind of SMC-D dummy device (we call it the SMC-D loopback device)
to emulate an ISM device, so that SMC-D can also be used on architectures
other than s390. The SMC-D loopback device are designed as a system global
device, visible to all containers.

# Design

This patch set basically follows the design of the previous version.

Patch #1/9 ~ #3/9 attempt to decouple ISM-related structures from the SMC-D
generalized code and extract some helpers to make SMC-D protocol compatible
with devices other than s390 ISM device.

Patch #4/9 introduces a kind of loopback device, which is defined as SMC-Dv2
device and designed to provide communication between SMC sockets on the same
OS instance.

 +-------------------------------------------+
 |  +--------------+       +--------------+  |
 |  | SMC socket A |       | SMC socket B |  |
 |  +--------------+       +--------------+  |
 |       ^                         ^         |
 |       |    +----------------+   |         |
 |       |    |   SMC stack    |   |         |
 |       +--->| +------------+ |<--|         |
 |            | |   dummy    | |             |
 |            | |   device   | |             |
 |            +-+------------+-+             |
 |                   OS                      |
 +-------------------------------------------+

Patch #5/9 ~ #8/9 expand SMC-D protocol interface (smcd_ops) for scenarios where
SMC-D is used to communicate within VM (loopback here) or between VMs on the same
host (based on virtio-ism device, see [4]). What these scenarios have in common
is that the local sndbuf and peer RMB can be mapped to same physical memory region,
so the data copy between the local sndbuf and peer RMB can be omitted. Performance
improvement brought by this extension can be found in # Benchmark Test.

 +----------+                     +----------+
 | socket A |                     | socket B |
 +----------+                     +----------+
       |                               ^
       |         +---------+           |
  regard as      |         | ----------|
  local sndbuf   |  B's    |     regard as
       |         |  RMB    |     local RMB
       |-------> |         |
                 +---------+

Patch #9/9 realizes the support of loopback device for the above-mentioned expanded
SMC-D protocol interface.

# Benchmark Test

 * Test environments:
      - VM with Intel Xeon Platinum 8 core 2.50GHz, 16 GiB mem.
      - SMC sndbuf/RMB size 1MB.

 * Test object:
      - TCP lo: run on TCP loopback.
      - domain: run on UNIX domain.
      - SMC lo: run on SMC loopback device with patch #1/9 ~ #4/9.
      - SMC lo-nocpy: run on SMC loopback device with patch #1/9 ~ #9/9.

1. ipc-benchmark (see [5])

 - ./<foo> -c 1000000 -s 100

                    TCP-lo              domain              SMC-lo          SMC-lo-nocpy
Message
rate (msg/s)         79025      115736(+46.45%)    146760(+85.71%)       149800(+89.56%)

2. sockperf

 - serv: <smc_run> taskset -c <cpu> sockperf sr --tcp
 - clnt: <smc_run> taskset -c <cpu> sockperf { tp | pp } --tcp --msg-size={ 64000 for tp | 14 for pp } -i 127.0.0.1 -t 30

                    TCP-lo                  SMC-lo             SMC-lo-nocpy
Bandwidth(MBps)   4822.388        4940.918(+2.56%)         8086.67(+67.69%)
Latency(us)          6.298          3.352(-46.78%)            3.35(-46.81%)

3. iperf3

 - serv: <smc_run> taskset -c <cpu> iperf3 -s
 - clnt: <smc_run> taskset -c <cpu> iperf3 -c 127.0.0.1 -t 15

                    TCP-lo                  SMC-lo             SMC-lo-nocpy
Bitrate(Gb/s)         40.7            40.5(-0.49%)            72.4(+77.89%)

4. nginx/wrk

 - serv: <smc_run> nginx
 - clnt: <smc_run> wrk -t 8 -c 500 -d 30 http://127.0.0.1:80

                    TCP-lo                  SMC-lo             SMC-lo-nocpy
Requests/s       155994.57      214544.79(+37.53%)       215538.55(+38.17%)


v5->v4
 1. The loopback device generates SEID in the same way as the ISM devices when coexisting
    with ISM devices and uses a default fixed SEID in other cases.
 2. Ensure each DMB token of the same loopback device is unique.
 3. Fixe a crash caused by setting smcd_ops->signal_event interface to NULL.
 4. Fixe a compilation warning complained by kernel test rebot.

v4->v3
 1. Rebase to the latest net-next;
 2. Introduce SEID helper. SMC-D loopback will return SMCD_DEFAULT_V2_SEID. And if it
    coexist with ISM device, the SEID of ISM device will overwrite SMCD_DEFAULT_V2_SEID
    as smc_ism_v2_system_eid.
 3. Won't remove dmb_node from hashtable until no sndbuf attaching to it.

 Something postponed in this version
 1. Hierarchy perference of SMC-D devices when loopback and ISM devices coexist, which
    will be determinated after comparing the performance of loopback and ISM.

v3->v2
 1. Adapt new generalized interface provided by [2];
 2. Select loopback device through SMC-D v2 protocol;
 3. Split the loopback-related implementation and generic implementation into different
    patches more reasonably.

v1->v2
 1. Fix some build WARNINGs complained by kernel test rebot
    Reported-by: kernel test robot <lkp@intel.com>
 2. Add iperf3 test data.


[1] https://lore.kernel.org/netdev/1671506505-104676-1-git-send-email-guwen@linux.alibaba.com/
[2] https://lore.kernel.org/netdev/1676477905-88043-1-git-send-email-guwen@linux.alibaba.com/
[3] https://lore.kernel.org/netdev/1679887699-54797-1-git-send-email-guwen@linux.alibaba.com/
[4] https://lore.kernel.org/all/20230209033056.96657-1-xuanzhuo@linux.alibaba.com/
[5] https://github.com/goldsborough/ipc-bench



Wen Gu (9):
  net/smc: Decouple ism_dev from SMC-D device dump
  net/smc: Decouple ism_dev from SMC-D DMB registration
  net/smc: Extract v2 check helper from SMC-D device registration
  net/smc: Introduce SMC-D loopback device
  net/smc: Introduce an interface for getting DMB attribute
  net/smc: Introudce interfaces for DMB attach and detach
  net/smc: Avoid data copy from sndbuf to peer RMB in SMC-D
  net/smc: Modify cursor update logic when using mappable DMB
  net/smc: Add interface implementation of loopback device

 drivers/s390/net/ism_drv.c |   5 +-
 include/net/smc.h          |  18 +-
 net/smc/Makefile           |   2 +-
 net/smc/af_smc.c           |  26 ++-
 net/smc/smc_cdc.c          |  59 ++++--
 net/smc/smc_cdc.h          |   1 +
 net/smc/smc_core.c         |  70 ++++++-
 net/smc/smc_core.h         |   1 +
 net/smc/smc_ism.c          |  79 ++++++--
 net/smc/smc_ism.h          |   6 +
 net/smc/smc_loopback.c     | 491 +++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_loopback.h     |  56 ++++++
 12 files changed, 777 insertions(+), 37 deletions(-)
 create mode 100644 net/smc/smc_loopback.c
 create mode 100644 net/smc/smc_loopback.h

-- 
1.8.3.1

