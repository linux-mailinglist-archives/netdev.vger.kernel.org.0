Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A536561F5
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 11:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiLZKqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 05:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiLZKqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 05:46:15 -0500
Received: from out30-7.freemail.mail.aliyun.com (out30-7.freemail.mail.aliyun.com [115.124.30.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CBCD53;
        Mon, 26 Dec 2022 02:46:12 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VY8Jq1L_1672051568;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0VY8Jq1L_1672051568)
          by smtp.aliyun-inc.com;
          Mon, 26 Dec 2022 18:46:09 +0800
Date:   Mon, 26 Dec 2022 18:46:08 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Wen Gu <guwen@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v2 0/5] net/smc:Introduce SMC-D based
 loopback acceleration
Message-ID: <20221226104608.GD40720@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <1671506505-104676-1-git-send-email-guwen@linux.alibaba.com>
 <42f2972f1dfe45a2741482f36fbbda5b5a56d8f1.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42f2972f1dfe45a2741482f36fbbda5b5a56d8f1.camel@linux.ibm.com>
X-Spam-Status: No, score=-8.7 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NUMERIC_HTTP_ADDR,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 03:02:45PM +0100, Niklas Schnelle wrote:
>On Tue, 2022-12-20 at 11:21 +0800, Wen Gu wrote:
>> Hi, all
>> 
>> # Background
>> 
>> As previously mentioned in [1], we (Alibaba Cloud) are trying to use SMC
>> to accelerate TCP applications in cloud environment, improving inter-host
>> or inter-VM communication.
>> 
>> In addition of these, we also found the value of SMC-D in scenario of local
>> inter-process communication, such as accelerate communication between containers
>> within the same host. So this RFC tries to provide a SMC-D loopback solution
>> in such scenario, to bring a significant improvement in latency and throughput
>> compared to TCP loopback.
>> 
>> # Design
>> 
>> This patch set provides a kind of SMC-D loopback solution.
>> 
>> Patch #1/5 and #2/5 provide an SMC-D based dummy device, preparing for the
>> inter-process communication acceleration. Except for loopback acceleration,
>> the dummy device can also meet the requirements mentioned in [2], which is
>> providing a way to test SMC-D logic for broad community without ISM device.
>> 
>>  +------------------------------------------+
>>  |  +-----------+           +-----------+   |
>>  |  | process A |           | process B |   |
>>  |  +-----------+           +-----------+   |
>>  |       ^                        ^         |
>>  |       |    +---------------+   |         |
>>  |       |    |   SMC stack   |   |         |
>>  |       +--->| +-----------+ |<--|         |
>>  |            | |   dummy   | |             |
>>  |            | |   device  | |             |
>>  |            +-+-----------+-+             |
>>  |                   VM                     |
>>  +------------------------------------------+
>> 
>> Patch #3/5, #4/5, #5/5 provides a way to avoid data copy from sndbuf to RMB
>> and improve SMC-D loopback performance. Through extending smcd_ops with two
>> new semantic: attach_dmb and detach_dmb, sender's sndbuf shares the same
>> physical memory region with receiver's RMB. The data copied from userspace
>> to sender's sndbuf directly reaches the receiver's RMB without unnecessary
>> memory copy in the same kernel.
>> 
>>  +----------+                     +----------+
>>  | socket A |                     | socket B |
>>  +----------+                     +----------+
>>        |                               ^
>>        |         +---------+           |
>>   regard as      |         | ----------|
>>   local sndbuf   |  B's    |     regard as
>>        |         |  RMB    |     local RMB
>>        |-------> |         |
>>                  +---------+
>
>Hi Wen Gu,
>
>I maintain the s390 specific PCI support in Linux and would like to
>provide a bit of background on this. You're surely wondering why we
>even have a copy in there for our ISM virtual PCI device. To understand
>why this copy operation exists and why we need to keep it working, one
>needs a bit of s390 aka mainframe background.
>
>On s390 all (currently supported) native machines have a mandatory
>machine level hypervisor. All OSs whether z/OS or Linux run either on
>this machine level hypervisor as so called Logical Partitions (LPARs)
>or as second/third/… level guests on e.g. a KVM or z/VM hypervisor that
>in turn runs in an LPAR. Now, in terms of memory this machine level
>hypervisor sometimes called PR/SM unlike KVM, z/VM, or VMWare is a
>partitioning hypervisor without paging. This is one of the main reasons
>for the very-near-native performance of the machine hypervisor as the
>memory of its guests acts just like native RAM on other systems. It is
>never paged out and always accessible to IOMMU translated DMA from
>devices without the need for pinning pages and besides a trivial
>offset/limit adjustment an LPAR's MMU does the same amount of work as
>an MMU on a bare metal x86_64/ARM64 box.
>
>It also means however that when SMC-D is used to communicate between
>LPARs via an ISM device there is  no way of mapping the DMBs to the
>same physical memory as there exists no MMU-like layer spanning
>partitions that could do such a mapping. Meanwhile for machine level
>firmware including the ISM virtual PCI device it is still possible to
>_copy_ memory between different memory partitions. So yeah while I do
>see the appeal of skipping the memcpy() for loopback or even between
>guests of a paging hypervisor such as KVM, which can map the DMBs on
>the same physical memory, we must keep in mind this original use case
>requiring a copy operation.
>
>Thanks,
>Niklas
>
>> 
>> # Benchmark Test
>> 
>>  * Test environments:
>>       - VM with Intel Xeon Platinum 8 core 2.50GHz, 16 GiB mem.
>>       - SMC sndbuf/RMB size 1MB.
>> 
>>  * Test object:
>>       - TCP: run on TCP loopback.
>>       - domain: run on UNIX domain.
>>       - SMC lo: run on SMC loopback device with patch #1/5 ~ #2/5.
>>       - SMC lo-nocpy: run on SMC loopback device with patch #1/5 ~ #5/5.
>> 
>> 1. ipc-benchmark (see [3])
>> 
>>  - ./<foo> -c 1000000 -s 100
>> 
>>                        TCP              domain              SMC-lo             SMC-lo-nocpy
>> Message
>> rate (msg/s)         75140      129548(+72.41)    152266(+102.64%)         151914(+102.17%)
>
>Interesting that it does beat UNIX domain sockets. Also, see my below
>comment for nginx/wrk as this seems very similar.
>
>> 
>> 2. sockperf
>> 
>>  - serv: <smc_run> taskset -c <cpu> sockperf sr --tcp
>>  - clnt: <smc_run> taskset -c <cpu> sockperf { tp | pp } --tcp --msg-size={ 64000 for tp | 14 for pp } -i 127.0.0.1 -t 30
>> 
>>                        TCP                  SMC-lo             SMC-lo-nocpy
>> Bandwidth(MBps)   4943.359        4936.096(-0.15%)        8239.624(+66.68%)
>> Latency(us)          6.372          3.359(-47.28%)            3.25(-49.00%)
>> 
>> 3. iperf3
>> 
>>  - serv: <smc_run> taskset -c <cpu> iperf3 -s
>>  - clnt: <smc_run> taskset -c <cpu> iperf3 -c 127.0.0.1 -t 15
>> 
>>                        TCP                  SMC-lo             SMC-lo-nocpy
>> Bitrate(Gb/s)         40.5            41.4(+2.22%)            76.4(+88.64%)
>> 
>> 4. nginx/wrk
>> 
>>  - serv: <smc_run> nginx
>>  - clnt: <smc_run> wrk -t 8 -c 500 -d 30 http://127.0.0.1:80
>> 
>>                        TCP                  SMC-lo             SMC-lo-nocpy
>> Requests/s       154643.22      220894.03(+42.84%)        226754.3(+46.63%)
>
>
>This result is very interesting indeed. So with the much more realistic
>nginx/wrk workload it seems to copy hurts much less than the
>iperf3/sockperf would suggest while SMC-D itself seems to help more.
>I'd hope that this translates to actual applications as well. Maybe
>this makes SMC-D based loopback interesting even while keeping the
>copy, at least until we can come up with a sane way to work a no-copy
>variant into SMC-D?

Yes, SMC-D based loopback shows great advantages over TCP loopback, with
or without copy.

The advantage of zero-copy should be observed when we need to transfer
a large mount of data. But here in this wrk/nginx case, the test file
transferred from server to client is a small file. So we didn't see much gain.
If we use a large file(e.g >=1MB file), I think we should observe a much
different result.

Thinks!


