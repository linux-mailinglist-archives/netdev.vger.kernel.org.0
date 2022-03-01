Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9704C884B
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 10:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiCAJov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 04:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232969AbiCAJot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 04:44:49 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506543A188;
        Tue,  1 Mar 2022 01:44:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V5wm1JI_1646127843;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V5wm1JI_1646127843)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Mar 2022 17:44:03 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH net-next 0/7] net/smc: some datapath performance optimizations
Date:   Tue,  1 Mar 2022 17:43:55 +0800
Message-Id: <20220301094402.14992-1-dust.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi:

This series tries to improve the performance of SMC in datapath.

- patch #1, add sysctl interface to support tuning the behaviour of
  SMC in container environment.

- patch #2/#3, add autocorking support which is very efficient for small
  messages without trade-off for latency.

- patch #4, send directly on setting TCP_NODELAY, without wake up the
  TX worker, this make it consistent with clearing TCP_CORK.

- patch #5, this correct the setting of RMB window update limit, so
  we don't send CDC messages to update peer's RMB window too frequently
  in some cases.

- patch #6, implemented something like NAPI in SMC, decrease the number
  of hardirq when busy.

- patch #7, this moves TX work doing in the BH to the user context when
  sock_lock is hold by user.


With this patchset applied, we can get a good performance gain:
- qperf tcp_bw test has shown a great improvement. Other benchmarks like
  'netperf TCP_STREAM' or 'sockperf throughput' has similar result.
- In my testing environment, running qperf tcp_bw and tcp_lat, SMC behaves
  better then TCP in most all message size.

Here are some test results with the following testing command:
client: smc_run taskset -c 1 qperf smc-server -oo msg_size:1:64K:*2 \
		-t 30 -vu tcp_{bw|lat}
server: smc_run taskset -c 1 qperf

==== Bandwidth ====
 MsgSize        Origin SMC              TCP                SMC with patches
       1         0.578 MB/s      2.392 MB/s(313.57%)      2.561 MB/s(342.83%)
       2         1.159 MB/s      4.780 MB/s(312.53%)      5.162 MB/s(345.46%)
       4         2.283 MB/s     10.266 MB/s(349.77%)     10.122 MB/s(343.46%)
       8         4.668 MB/s     19.040 MB/s(307.86%)     20.521 MB/s(339.59%)
      16         9.147 MB/s     38.904 MB/s(325.31%)     40.823 MB/s(346.29%)
      32        18.369 MB/s     79.587 MB/s(333.25%)     80.535 MB/s(338.42%)
      64        36.562 MB/s    148.668 MB/s(306.61%)    158.170 MB/s(332.60%)
     128        72.961 MB/s    274.913 MB/s(276.80%)    316.217 MB/s(333.41%)
     256       144.705 MB/s    512.059 MB/s(253.86%)    626.019 MB/s(332.62%)
     512       288.873 MB/s    884.977 MB/s(206.35%)   1221.596 MB/s(322.88%)
    1024       574.180 MB/s   1337.736 MB/s(132.98%)   2203.156 MB/s(283.70%)
    2048      1095.192 MB/s   1865.952 MB/s( 70.38%)   3036.448 MB/s(177.25%)
    4096      2066.157 MB/s   2380.337 MB/s( 15.21%)   3834.271 MB/s( 85.58%)
    8192      3717.198 MB/s   2733.073 MB/s(-26.47%)   4904.910 MB/s( 31.95%)
   16384      4742.221 MB/s   2958.693 MB/s(-37.61%)   5220.272 MB/s( 10.08%)
   32768      5349.550 MB/s   3061.285 MB/s(-42.77%)   5321.865 MB/s( -0.52%)
   65536      5162.919 MB/s   3731.408 MB/s(-27.73%)   5245.021 MB/s(  1.59%)
==== Latency ====
 MsgSize        Origin SMC              TCP                SMC with patches
       1        10.540 us     11.938 us( 13.26%)         10.356 us( -1.75%)
       2        10.996 us     11.992 us(  9.06%)         10.073 us( -8.39%)
       4        10.229 us     11.687 us( 14.25%)          9.996 us( -2.28%)
       8        10.203 us     11.653 us( 14.21%)         10.063 us( -1.37%)
      16        10.530 us     11.313 us(  7.44%)         10.013 us( -4.91%)
      32        10.241 us     11.586 us( 13.13%)         10.081 us( -1.56%)
      64        10.693 us     11.652 us(  8.97%)          9.986 us( -6.61%)
     128        10.597 us     11.579 us(  9.27%)         10.262 us( -3.16%)
     256        10.409 us     11.957 us( 14.87%)         10.148 us( -2.51%)
     512        11.088 us     12.505 us( 12.78%)         10.206 us( -7.95%)
    1024        11.240 us     12.255 us(  9.03%)         10.631 us( -5.42%)
    2048        11.485 us     16.970 us( 47.76%)         10.981 us( -4.39%)
    4096        12.077 us     13.948 us( 15.49%)         11.847 us( -1.90%)
    8192        13.683 us     16.693 us( 22.00%)         13.336 us( -2.54%)
   16384        16.470 us     23.615 us( 43.38%)         16.519 us(  0.30%)
   32768        22.540 us     40.966 us( 81.75%)         22.452 us( -0.39%)
   65536        34.192 us     73.003 us(113.51%)         33.916 us( -0.81%)

------------
Test environment notes:
1. Testing is run on 2 VMs within the same physical host
2. The NIC is ConnectX-4Lx, using SRIOV, and passing through 2 VFs to the
   2 VMs respectively.
3. To decrease jitter, VM's vCPU are binded to each physical CPU, and those
   physical CPUs are all isolated using boot parameter `isolcpus=xxx`
4. The queue number are set to 1, and interrupt from the queue is binded to
   CPU0 in the guest


Dust Li (7):
  net/smc: add sysctl interface for SMC
  net/smc: add autocorking support
  net/smc: add sysctl for autocorking
  net/smc: send directly on setting TCP_NODELAY
  net/smc: correct settings of RMB window update limit
  net/smc: don't req_notify until all CQEs drained
  net/smc: don't send in the BH context if sock_owned_by_user

 Documentation/networking/smc-sysctl.rst |  23 +++++
 include/net/netns/smc.h                 |   4 +
 net/smc/Makefile                        |   2 +-
 net/smc/af_smc.c                        |  30 ++++++-
 net/smc/smc.h                           |   6 ++
 net/smc/smc_cdc.c                       |  24 ++++--
 net/smc/smc_core.c                      |   2 +-
 net/smc/smc_sysctl.c                    |  80 ++++++++++++++++++
 net/smc/smc_sysctl.h                    |  32 +++++++
 net/smc/smc_tx.c                        | 107 +++++++++++++++++++++---
 net/smc/smc_wr.c                        |  49 ++++++-----
 11 files changed, 317 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/networking/smc-sysctl.rst
 create mode 100644 net/smc/smc_sysctl.c
 create mode 100644 net/smc/smc_sysctl.h

-- 
2.19.1.3.ge56e4f7

