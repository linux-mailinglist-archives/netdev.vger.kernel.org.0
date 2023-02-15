Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD83698094
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 17:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjBOQSn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 11:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBOQSm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 11:18:42 -0500
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF772BEF5;
        Wed, 15 Feb 2023 08:18:39 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vbl04ts_1676477905;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0Vbl04ts_1676477905)
          by smtp.aliyun-inc.com;
          Thu, 16 Feb 2023 00:18:35 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v3 0/9] net/smc: Introduce SMC-D-based OS internal communication acceleration
Date:   Thu, 16 Feb 2023 00:18:16 +0800
Message-Id: <1676477905-88043-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, all

# Background

The background and previous discussion can be referred from [1].

We found SMC-D can be used to accelerate OS internal communication, such as
loopback or between two containers within the same OS instance. So this patch
set provides a kind of SMC-D dummy device (we call it the SMC-D loopback device)
to emulate an ISM device, so that SMC-D can also be used on architectures
other than s390. The SMC-D loopback device are designed as a system global
device, visible to all containers.

This version is implemented based on the generalized interface provided by [2].
And there is an open issue of this version, which will be mentioned later.

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

The open issue has not been resolved now is about how to detect that the source
and target of CLC proposal are within the same OS instance and can communicate
through the SMC-D loopback device. Similar issue also exists when using virtio-ism
devices (the background and details of virtio-ism device can be referred from [3]).
In previous discussions, multiple options were proposed (see [5]). Thanks again for
the help of the community. cc Alexandra Winter :)

But as we discussed, these solutions have some imperfection. So this version of RFC
continues to use previous workaround, that is, a 64-bit random GID is generated for
SMC-D loopback device. If the GIDs of the devices found by two peers are the same,
then they are considered to be in the same OS instance and can communicate with each
other by the loopback device.

This approach has very small risk. Assume the following situations:

(1) Assume that the SMC-D loopback devices of the two OS instances happen to
    generate the same 64-bit GID.

    For the convenience of description, we refer to the sockets on these two
    different OS instance as server A and client B.

    A will misjudge that the two are on the same OS instance because the same GID
    in CLC proposal message. Then A creates its RMB and sends 64-bit token-A to B
    in CLC accept message.

    B receives the CLC accept message. And according to patch #7/9, B tries to
    attach its sndbuf to A's RMB by token-A.

(2) Assume that the OS instance where B is located happens to have an unattached
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
If one of above is not satisfied, it will safely fallback to TCP.

Since the chances of these happening are very small, I wonder if this risk of 1/2^(64*3)
probability can be tolerated ?

Another way to solve this open issue is using a 128-bit UUID to identify SMC-D loopback
device or virtio-ism device, because the probability of a 128-bit UUID collision is
considered negligible. But it may need to extend the CLC message to carry a longer GID,
which is the last option.

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
 net/smc/smc_ism.h          |   4 +
 net/smc/smc_loopback.c     | 442 +++++++++++++++++++++++++++++++++++++++++++++
 net/smc/smc_loopback.h     |  55 ++++++
 12 files changed, 725 insertions(+), 37 deletions(-)
 create mode 100644 net/smc/smc_loopback.c
 create mode 100644 net/smc/smc_loopback.h

-- 
1.8.3.1

