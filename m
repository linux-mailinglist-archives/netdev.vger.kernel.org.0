Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6C26C9A1B
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 05:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjC0D23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Mar 2023 23:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjC0D21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Mar 2023 23:28:27 -0400
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4840340E8;
        Sun, 26 Mar 2023 20:28:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0Vef7WO6_1679887699;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vef7WO6_1679887699)
          by smtp.aliyun-inc.com;
          Mon, 27 Mar 2023 11:28:21 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        wintera@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 0/9] net/smc: Introduce SMC-D-based OS internal communication acceleration
Date:   Mon, 27 Mar 2023 11:28:10 +0800
Message-Id: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NUMERIC_HTTP_ADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, all

# Background

The background and previous discussion can be referred from [1],[6].

We found SMC-D can be used to accelerate OS internal communication, such as
loopback or between two containers within the same OS instance. So this patch
set provides a kind of SMC-D dummy device (we call it the SMC-D loopback device)
to emulate an ISM device, so that SMC-D can also be used on architectures
other than s390. The SMC-D loopback device are designed as a system global
device, visible to all containers.

This version is implemented based on the generalized interface provided by [2].
And there is an open issue, which will be mentioned later.

# Design

This patch set basically follows the design of the previous version.

Patch #1/9 ~ #3/9 attempt to decouple ISM-related structures from the SMC-D
generalized code and extract some helpers to make SMC-D protocol compatible
with devices other than s390 ISM device.

Patch #4/9 introduces a kind of loopback device, which is defined as SMC-D v2
device and designed to provide communication between SMC sockets in the same OS
instance.

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
host (based on virtio-ism device, see [3]). What these scenarios have in common
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

1. ipc-benchmark (see [4])

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


# Open issue

The open issue is about how to detect that the source and target of CLC proposal
are within the same OS instance and can communicate through the SMC-D loopback device.
Similar issue also exists when using virtio-ism devices (the background and details
of virtio-ism device can be referred from [3]). In previous discussions, multiple
options were proposed (see [5]). Thanks again for the help of the community. :)

But as we discussed, these solutions have some imperfection. So this version of RFC
continues to use previous workaround, that is, a 64-bit random GID is generated for
SMC-D loopback device. If the GIDs of the devices found by two peers are the same,
then they are considered to be in the same OS instance and can communicate with each
other by the loopback device.

This approach needs that the loopback device GID is globally unique. But theoretically
there is a possibility of a collision. Assume the following situations:

(1) Assume that the SMC-D loopback devices of the two different OS instances happen
    to generate the same 64-bit GID.

    For the convenience of description, we refer to the sockets on these two
    different OS instance as server A and client B.

    A will misjudge that the two are on the same OS instance because the same GID
    in CLC proposal message. Then A creates its RMB and sends 64-bit token-A to B
    in CLC accept message.

    B receives the CLC accept message. And according to patch #7/9, B tries to
    attach its sndbuf to A's RMB by token-A.

(2) And assume that the OS instance where B is located happens to have an unattached
    RMB whose 64-bit token is same as token-A.

    Then B successfully attaches its sndbuf to the wrong RMB, and creates its RMB,
    sends token-B to A in CLC confirm message.

    Similarly, A receives the message and tries to attach its sndbuf to B's RMB by
    token-B.

(3) Similar to (2), assume that the OS instance where A is located happens to have
    an unattached RMB whose 64-bit token is same as token-B.

    Then A successfully attach its sndbuf to the wrong RMB. Both sides mistakenly
    believe that an SMC-D connection based on the loopback device is established
    between them.

If the above 3 coincidences all happen, that is, 64-bit random number conflicts occur
3 times, then an unreachable SMC-D connection will be established, which is nasty.
But if one of above is not satisfied, it will safely fallback to TCP.

Since the chances of these happening are very small, I wonder if this risk of 1/2^(64*3)
probability is acceptable? Can we just use 64-bits random generated number as GID in
loopback device?

Some other ways that may be able to make loopback GID unique are
 1) Using a 128-bit UUID to identify SMC-D loopback device or virtio-ism device, because
    the probability of a 128-bit UUID collision is considered negligible. But it needs
    to extend the CLC message to carry a longer GID.
 2) Using MAC address of netdev in the OS as part of SMC-D loopback device GID, provided
    that the MAC addresses are unique. But the MAC address could theoretically also be
    incorrectly set to be the same.

Hope to hear opinions from the community. Any ideas are welcome.

Thanks!
Wen Gu

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
[2] https://lore.kernel.org/netdev/20230123181752.1068-1-jaka@linux.ibm.com/
[3] https://lists.oasis-open.org/archives/virtio-comment/202302/msg00148.html
[4] https://github.com/goldsborough/ipc-bench
[5] https://lore.kernel.org/netdev/b9867c7d-bb2b-16fc-feda-b79579aa833d@linux.ibm.com/
[6] https://lore.kernel.org/netdev/1676477905-88043-1-git-send-email-guwen@linux.alibaba.com/


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
 net/smc/smc_ism.c          |  99 ++++++++--
 net/smc/smc_ism.h          |   5 +
 net/smc/smc_loopback.c     | 445 +++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_loopback.h     |  56 ++++++
 12 files changed, 750 insertions(+), 37 deletions(-)
 create mode 100644 net/smc/smc_loopback.c
 create mode 100644 net/smc/smc_loopback.h

-- 
1.8.3.1

