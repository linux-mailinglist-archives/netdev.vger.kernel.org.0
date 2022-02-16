Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3604E4B8CA1
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235552AbiBPPjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:39:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbiBPPjU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:39:20 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA97C290591;
        Wed, 16 Feb 2022 07:39:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V4e2f3I_1645025943;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V4e2f3I_1645025943)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 23:39:03 +0800
Date:   Wed, 16 Feb 2022 23:39:02 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2] net/smc: Add autocork support
Message-ID: <20220216153902.GC39286@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220216120009.63747-1-dust.li@linux.alibaba.com>
 <c113554f9d3cdfbf3e148cc3400e106ba7bdb3c4.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c113554f9d3cdfbf3e148cc3400e106ba7bdb3c4.camel@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 16, 2022 at 04:20:27PM +0100, Niklas Schnelle wrote:
>On Wed, 2022-02-16 at 20:00 +0800, Dust Li wrote:
>> This patch adds autocork support for SMC which could improve
>> throughput for small message by x2 ~ x4.
>> 
>> The main idea is borrowed from TCP autocork with some RDMA
>> specific modification:
>> 1. The first message should never cork to make sure we won't
>>    bring extra latency
>> 2. If we have posted any Tx WRs to the NIC that have not
>>    completed, cork the new messages until:
>>    a) Receive CQE for the last Tx WR
>>    b) We have corked enough message on the connection
>> 3. Try to push the corked data out when we receive CQE of
>>    the last Tx WR to prevent the corked messages hang in
>>    the send queue.
>> 
>> Both SMC autocork and TCP autocork check the TX completion
>> to decide whether we should cork or not. The difference is
>> when we got a SMC Tx WR completion, the data have been confirmed
>> by the RNIC while TCP TX completion just tells us the data
>> have been sent out by the local NIC.
>> 
>> Add an atomic variable tx_pushing in smc_connection to make
>> sure only one can send to let it cork more and save CDC slot.
>> 
>> SMC autocork should not bring extra latency since the first
>> message will always been sent out immediately.
>> 
>> The qperf tcp_bw test shows more than x4 increase under small
>> message size with Mellanox connectX4-Lx, same result with other
>> throughput benchmarks like sockperf/netperf.
>> The qperf tcp_lat test shows SMC autocork has not increase any
>> ping-pong latency.
>> 
>> BW test:
>>  client: smc_run taskset -c 1 qperf smc-server -oo msg_size:1:64K:*2 \
>> 			-t 30 -vu tcp_bw
>>  server: smc_run taskset -c 1 qperf
>> 
>> MsgSize(Bytes)        TCP         SMC-NoCork           SMC-AutoCork
>>       1         2.57 MB/s     698 KB/s(-73.5%)     2.98 MB/s(16.0% )
>>       2          5.1 MB/s    1.41 MB/s(-72.4%)     5.82 MB/s(14.1% )
>>       4         10.2 MB/s    2.83 MB/s(-72.3%)     11.7 MB/s(14.7% )
>>       8         20.8 MB/s    5.62 MB/s(-73.0%)     22.9 MB/s(10.1% )
>>      16         42.5 MB/s    11.5 MB/s(-72.9%)     45.5 MB/s(7.1%  )
>>      32         80.7 MB/s    22.3 MB/s(-72.4%)     86.7 MB/s(7.4%  )
>>      64          155 MB/s    45.6 MB/s(-70.6%)      160 MB/s(3.2%  )
>>     128          295 MB/s    90.1 MB/s(-69.5%)      273 MB/s(-7.5% )
>>     256          539 MB/s     179 MB/s(-66.8%)      610 MB/s(13.2% )
>>     512          943 MB/s     360 MB/s(-61.8%)     1.02 GB/s(10.8% )
>>    1024         1.58 GB/s     710 MB/s(-56.1%)     1.91 GB/s(20.9% )
>>    2048         2.47 GB/s    1.34 GB/s(-45.7%)     2.92 GB/s(18.2% )
>>    4096         2.86 GB/s     2.5 GB/s(-12.6%)      2.4 GB/s(-16.1%)
>>    8192         3.89 GB/s    3.14 GB/s(-19.3%)     4.05 GB/s(4.1%  )
>>   16384         3.29 GB/s    4.67 GB/s(41.9% )     5.09 GB/s(54.7% )
>>   32768         2.73 GB/s    5.48 GB/s(100.7%)     5.49 GB/s(101.1%)
>>   65536            3 GB/s    4.85 GB/s(61.7% )     5.24 GB/s(74.7% )
>> 
>> Latency test:
>>  client: smc_run taskset -c 1 qperf smc-server -oo msg_size:1:64K:*2 \
>> 			-t 30 -vu tcp_lat
>>  server: smc_run taskset -c 1 qperf
>> 
>>  MsgSize              SMC-NoCork           SMC-AutoCork
>>        1               9.7 us               9.6 us( -1.03%)
>>        2              9.43 us              9.39 us( -0.42%)
>>        4               9.6 us              9.35 us( -2.60%)
>>        8              9.42 us               9.2 us( -2.34%)
>>       16              9.13 us              9.43 us(  3.29%)
>>       32              9.19 us               9.5 us(  3.37%)
>>       64              9.38 us               9.5 us(  1.28%)
>>      128               9.9 us              9.29 us( -6.16%)
>>      256              9.42 us              9.26 us( -1.70%)
>>      512                10 us              9.45 us( -5.50%)
>>     1024              10.4 us               9.6 us( -7.69%)
>>     2048              10.4 us              10.2 us( -1.92%)
>>     4096                11 us              10.5 us( -4.55%)
>>     8192              11.7 us              11.8 us(  0.85%)
>>    16384              14.5 us              14.2 us( -2.07%)
>>    32768              19.4 us              19.3 us( -0.52%)
>>    65536              28.1 us              28.8 us(  2.49%)
>
>This is quite an impressive improvement! Thanks for your effort!
>
>Could you share a bit more about how you performed these tests to give
>a bit more context and allow us to reproduce them on s390. I'm assuming
>the ConnectX-4 Lx card you're using is a 50 Gb/s model? Are you doing
>these tests on two bare metal hosts, one host with client/server
>namespaces, or between VMs? If it's namespaces or VMs are you using VFs
>from the same card/port or different cards. If it is two cards/ports do
>you have a switch or a cross cable between them?

Sure

I did the test in the VM environment. 2 VMs within a single physical host,
using 2 VFs from the same single ConnectX-4 Lx card, passthrough to each VM.
the card is dual-25Gbps so the internal chip should support 50Gbps.
A rough graph of the test setup is like this:

-------------------------------------
|  ---------           ---------    |
|  |       |           |       |    |
|  |  VM1  |           |  VM2  |    |
|  |       |           |       |    |
|  ---VF1---           ---VF2---    |
|      ^                   ^        |
|      |                   |        |
|      |----- CX-4 Lx -----|        |
|                             Host  |
|------------------------------------

