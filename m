Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03629657542
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 11:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiL1K0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 05:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiL1K0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 05:26:18 -0500
Received: from out30-1.freemail.mail.aliyun.com (out30-1.freemail.mail.aliyun.com [115.124.30.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EA4B4C;
        Wed, 28 Dec 2022 02:26:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VYHHvkd_1672223171;
Received: from 30.221.128.170(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VYHHvkd_1672223171)
          by smtp.aliyun-inc.com;
          Wed, 28 Dec 2022 18:26:12 +0800
Message-ID: <732a4b17-f774-aad9-1803-16cc8c7b43c7@linux.alibaba.com>
Date:   Wed, 28 Dec 2022 18:26:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [RFC PATCH net-next v2 0/5] net/smc:Introduce SMC-D based
 loopback acceleration
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.8 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,NUMERIC_HTTP_ADDR,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/20 11:21, Wen Gu wrote:
> Hi, all
> 
> # Background
> 
> As previously mentioned in [1], we (Alibaba Cloud) are trying to use SMC
> to accelerate TCP applications in cloud environment, improving inter-host
> or inter-VM communication.
> 
> In addition of these, we also found the value of SMC-D in scenario of local
> inter-process communication, such as accelerate communication between containers
> within the same host. So this RFC tries to provide a SMC-D loopback solution
> in such scenario, to bring a significant improvement in latency and throughput
> compared to TCP loopback.
> 
> # Design
> 
> This patch set provides a kind of SMC-D loopback solution.
> 
> Patch #1/5 and #2/5 provide an SMC-D based dummy device, preparing for the
> inter-process communication acceleration. Except for loopback acceleration,
> the dummy device can also meet the requirements mentioned in [2], which is
> providing a way to test SMC-D logic for broad community without ISM device.
> 
>   +------------------------------------------+
>   |  +-----------+           +-----------+   |
>   |  | process A |           | process B |   |
>   |  +-----------+           +-----------+   |
>   |       ^                        ^         |
>   |       |    +---------------+   |         |
>   |       |    |   SMC stack   |   |         |
>   |       +--->| +-----------+ |<--|         |
>   |            | |   dummy   | |             |
>   |            | |   device  | |             |
>   |            +-+-----------+-+             |
>   |                   VM                     |
>   +------------------------------------------+
> 
> Patch #3/5, #4/5, #5/5 provides a way to avoid data copy from sndbuf to RMB
> and improve SMC-D loopback performance. Through extending smcd_ops with two
> new semantic: attach_dmb and detach_dmb, sender's sndbuf shares the same
> physical memory region with receiver's RMB. The data copied from userspace
> to sender's sndbuf directly reaches the receiver's RMB without unnecessary
> memory copy in the same kernel.
> 
>   +----------+                     +----------+
>   | socket A |                     | socket B |
>   +----------+                     +----------+
>         |                               ^
>         |         +---------+           |
>    regard as      |         | ----------|
>    local sndbuf   |  B's    |     regard as
>         |         |  RMB    |     local RMB
>         |-------> |         |
>                   +---------+
> 
> # Benchmark Test
> 
>   * Test environments:
>        - VM with Intel Xeon Platinum 8 core 2.50GHz, 16 GiB mem.
>        - SMC sndbuf/RMB size 1MB.
> 
>   * Test object:
>        - TCP: run on TCP loopback.
>        - domain: run on UNIX domain.
>        - SMC lo: run on SMC loopback device with patch #1/5 ~ #2/5.
>        - SMC lo-nocpy: run on SMC loopback device with patch #1/5 ~ #5/5.
> 
> 1. ipc-benchmark (see [3])
> 
>   - ./<foo> -c 1000000 -s 100
> 
>                         TCP              domain              SMC-lo             SMC-lo-nocpy
> Message
> rate (msg/s)         75140      129548(+72.41)    152266(+102.64%)         151914(+102.17%)
> 
> 2. sockperf
> 
>   - serv: <smc_run> taskset -c <cpu> sockperf sr --tcp
>   - clnt: <smc_run> taskset -c <cpu> sockperf { tp | pp } --tcp --msg-size={ 64000 for tp | 14 for pp } -i 127.0.0.1 -t 30
> 
>                         TCP                  SMC-lo             SMC-lo-nocpy
> Bandwidth(MBps)   4943.359        4936.096(-0.15%)        8239.624(+66.68%)
> Latency(us)          6.372          3.359(-47.28%)            3.25(-49.00%)
> 
> 3. iperf3
> 
>   - serv: <smc_run> taskset -c <cpu> iperf3 -s
>   - clnt: <smc_run> taskset -c <cpu> iperf3 -c 127.0.0.1 -t 15
> 
>                         TCP                  SMC-lo             SMC-lo-nocpy
> Bitrate(Gb/s)         40.5            41.4(+2.22%)            76.4(+88.64%)
> 
> 4. nginx/wrk
> 
>   - serv: <smc_run> nginx
>   - clnt: <smc_run> wrk -t 8 -c 500 -d 30 http://127.0.0.1:80
> 
>                         TCP                  SMC-lo             SMC-lo-nocpy
> Requests/s       154643.22      220894.03(+42.84%)        226754.3(+46.63%)
> 
> 
> # Discussion
> 
> 1. API between SMC-D and ISM device
> 
> As Jan mentioned in [2], IBM are working on placing an API between SMC-D
> and the ISM device for easier use of different "devices" for SMC-D.
> 
> So, considering that the introduction of attach_dmb or detach_dmb can
> effectively avoid data copying from sndbuf to RMB and brings obvious
> throughput advantages in inter-VM or inter-process scenarios, can the
> attach/detach semantics be taken into consideration when designing the
> API to make it a standard ISM device behavior?
> 
> Maybe our RFC of SMC-D based inter-process acceleration (this one) and
> inter-VM acceleration (will coming soon, which is the update of [1])


The patch of SMC-D + virtio-ism device is now discussed in virtio community:

https://lists.oasis-open.org/archives/virtio-comment/202212/msg00030.html


> can provide some examples for new API design. And we are very glad to
> discuss this on the mail list.
> 
> 2. Way to select different ISM-like devices
> 
> With the proposal of SMC-D loopback 'device' (this RFC) and incoming
> device used for inter-VM acceleration as update of [1], SMC-D has more
> options to choose from. So we need to consider that how to indicate
> supported devices, how to determine which one to use, and their priority...
> 
> IMHO, this may require an update of CLC message and negotiation mechanism.
> Again, we are very glad to discuss this with you on the mailing list.
> 
> [1] https://lore.kernel.org/netdev/20220720170048.20806-1-tonylu@linux.alibaba.com/
> [2] https://lore.kernel.org/netdev/35d14144-28f7-6129-d6d3-ba16dae7a646@linux.ibm.com/
> [3] https://github.com/goldsborough/ipc-bench
> 
> v1->v2
>   1. Fix some build WARNINGs complained by kernel test rebot
>      Reported-by: kernel test robot <lkp@intel.com>
>   2. Add iperf3 test data.
> 
> Wen Gu (5):
>    net/smc: introduce SMC-D loopback device
>    net/smc: choose loopback device in SMC-D communication
>    net/smc: add dmb attach and detach interface
>    net/smc: avoid data copy from sndbuf to peer RMB in SMC-D loopback
>    net/smc: logic of cursors update in SMC-D loopback connections
> 
>   include/net/smc.h      |   3 +
>   net/smc/Makefile       |   2 +-
>   net/smc/af_smc.c       |  88 +++++++++++-
>   net/smc/smc_cdc.c      |  59 ++++++--
>   net/smc/smc_cdc.h      |   1 +
>   net/smc/smc_clc.c      |   4 +-
>   net/smc/smc_core.c     |  62 +++++++++
>   net/smc/smc_core.h     |   2 +
>   net/smc/smc_ism.c      |  39 +++++-
>   net/smc/smc_ism.h      |   2 +
>   net/smc/smc_loopback.c | 358 +++++++++++++++++++++++++++++++++++++++++++++++++
>   net/smc/smc_loopback.h |  63 +++++++++
>   12 files changed, 662 insertions(+), 21 deletions(-)
>   create mode 100644 net/smc/smc_loopback.c
>   create mode 100644 net/smc/smc_loopback.h
> 
