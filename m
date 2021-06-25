Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3857A3B4033
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 11:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhFYJWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 05:22:35 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:11096 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbhFYJWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 05:22:34 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GBBGY2K64zZjCd;
        Fri, 25 Jun 2021 17:17:09 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 17:20:11 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 25 Jun
 2021 17:20:11 +0800
Subject: Re: [PATCH net-next v2 2/2] ptr_ring: make __ptr_ring_empty()
 checking more reliable
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
 <1624591136-6647-3-git-send-email-linyunsheng@huawei.com>
 <20210625023749-mutt-send-email-mst@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <77615160-6f4f-64bf-7de9-b0adaddd5f06@huawei.com>
Date:   Fri, 25 Jun 2021 17:20:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210625023749-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme707-chm.china.huawei.com (10.1.199.103) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/25 14:39, Michael S. Tsirkin wrote:
> On Fri, Jun 25, 2021 at 11:18:56AM +0800, Yunsheng Lin wrote:
>> Currently r->queue[] is cleared after r->consumer_head is moved
>> forward, which makes the __ptr_ring_empty() checking called in
>> page_pool_refill_alloc_cache() unreliable if the checking is done
>> after the r->queue clearing and before the consumer_head moving
>> forward.
>>
>> Move the r->queue[] clearing after consumer_head moving forward
>> to make __ptr_ring_empty() checking more reliable.
>>
>> As a side effect of above change, a consumer_head checking is
>> avoided for the likely case, and it has noticeable performance
>> improvement when it is tested using the ptr_ring_test selftest
>> added in the previous patch.
>>
>> Using "taskset -c 1 ./ptr_ring_test -s 1000 -m 0 -N 100000000"
>> to test the case of single thread doing both the enqueuing and
>> dequeuing:
>>
>>  arch     unpatched           patched       delta
>> arm64      4648 ms            4464 ms       +3.9%
>>  X86       2562 ms            2401 ms       +6.2%
>>
>> Using "taskset -c 1-2 ./ptr_ring_test -s 1000 -m 1 -N 100000000"
>> to test the case of one thread doing enqueuing and another thread
>> doing dequeuing concurrently, also known as single-producer/single-
>> consumer:
>>
>>  arch      unpatched             patched         delta
>> arm64   3624 ms + 3624 ms   3462 ms + 3462 ms    +4.4%
>>  x86    2758 ms + 2758 ms   2547 ms + 2547 ms    +7.6%
> 
> Nice but it's small - could be a fluke.
> How many tests did you run? What is the variance?
> Did you try pinning to different CPUs to observe numa effects?
> Please use perf or some other modern tool for this kind
> of benchmark. Thanks!

The result is quite stable, and retest using perf stat：

---------------unpatched ptr_ring.c begin----------------------------------

perf stat ./ptr_ring_test -s 1000 -m 0 -N 100000000
ptr_ring(size:1000) perf simple test for 100000000 times, took 2385198 us

 Performance counter stats for './ptr_ring_test -s 1000 -m 0 -N 100000000':

           2385.49 msec task-clock                #    1.000 CPUs utilized
                26      context-switches          #    0.011 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                57      page-faults               #    0.024 K/sec
        6202023521      cycles                    #    2.600 GHz
       17424187640      instructions              #    2.81  insn per cycle
   <not supported>      branches
           6506477      branch-misses

       2.385785170 seconds time elapsed

       2.384014000 seconds user
       0.000000000 seconds sys


root@(none):~# perf stat ./ptr_ring_test -s 1000 -m 0 -N 100000000
ptr_ring(size:1000) perf simple test for 100000000 times, took 2383385 us

 Performance counter stats for './ptr_ring_test -s 1000 -m 0 -N 100000000':

           2383.67 msec task-clock                #    1.000 CPUs utilized
                26      context-switches          #    0.011 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                57      page-faults               #    0.024 K/sec
        6197278066      cycles                    #    2.600 GHz
       17424207772      instructions              #    2.81  insn per cycle
   <not supported>      branches
           6495766      branch-misses

       2.383941170 seconds time elapsed

       2.382215000 seconds user
       0.000000000 seconds sys


root@(none):~# perf stat ./ptr_ring_test -s 1000 -m 0 -N 100000000
ptr_ring(size:1000) perf simple test for 100000000 times, took 2390858 us

 Performance counter stats for './ptr_ring_test -s 1000 -m 0 -N 100000000':

           2391.16 msec task-clock                #    1.000 CPUs utilized
                25      context-switches          #    0.010 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                57      page-faults               #    0.024 K/sec
        6216704120      cycles                    #    2.600 GHz
       17424243041      instructions              #    2.80  insn per cycle
   <not supported>      branches
           6483886      branch-misses

       2.391420440 seconds time elapsed

       2.389647000 seconds user
       0.000000000 seconds sys


root@(none):~# perf stat ./ptr_ring_test -s 1000 -m 0 -N 100000000
ptr_ring(size:1000) perf simple test for 100000000 times, took 2389810 us

 Performance counter stats for './ptr_ring_test -s 1000 -m 0 -N 100000000':

           2390.10 msec task-clock                #    1.000 CPUs utilized
                26      context-switches          #    0.011 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                58      page-faults               #    0.024 K/sec
        6213995715      cycles                    #    2.600 GHz
       17424227499      instructions              #    2.80  insn per cycle
   <not supported>      branches
           6474069      branch-misses

       2.390367070 seconds time elapsed

       2.388644000 seconds user
       0.000000000 seconds sys

---------------unpatched ptr_ring.c end----------------------------------



---------------patched ptr_ring.c begin----------------------------------
root@(none):~# perf stat ./ptr_ring_test_opt -s 1000 -m 0 -N 100000000
ptr_ring(size:1000) perf simple test for 100000000 times, took 2198894 us

 Performance counter stats for './ptr_ring_test_opt -s 1000 -m 0 -N 100000000':

           2199.18 msec task-clock                #    1.000 CPUs utilized
                23      context-switches          #    0.010 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                56      page-faults               #    0.025 K/sec
        5717671859      cycles                    #    2.600 GHz
       16124164124      instructions              #    2.82  insn per cycle
   <not supported>      branches
           6564829      branch-misses

       2.199445990 seconds time elapsed

       2.197859000 seconds user
       0.000000000 seconds sys


root@(none):~# perf stat ./ptr_ring_test_opt -s 1000 -m 0 -N 100000000
ptr_ring(size:1000) perf simple test for 100000000 times, took 2222337 us

 Performance counter stats for './ptr_ring_test_opt -s 1000 -m 0 -N 100000000':

           2222.63 msec task-clock                #    1.000 CPUs utilized
                23      context-switches          #    0.010 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                57      page-faults               #    0.026 K/sec
        5778632853      cycles                    #    2.600 GHz
       16124210769      instructions              #    2.79  insn per cycle
   <not supported>      branches
           6603904      branch-misses

       2.222901020 seconds time elapsed

       2.221312000 seconds user
       0.000000000 seconds sys


root@(none):~# perf stat ./ptr_ring_test_opt -s 1000 -m 0 -N 100000000
ptr_ring(size:1000) perf simple test for 100000000 times, took 2251980 us

 Performance counter stats for './ptr_ring_test_opt -s 1000 -m 0 -N 100000000':

           2252.28 msec task-clock                #    1.000 CPUs utilized
                25      context-switches          #    0.011 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                57      page-faults               #    0.025 K/sec
        5855668335      cycles                    #    2.600 GHz
       16124310588      instructions              #    2.75  insn per cycle
   <not supported>      branches
           6777279      branch-misses

       2.252543340 seconds time elapsed

       2.250897000 seconds user
       0.000000000 seconds sys


root@(none):~#
root@(none):~# perf stat ./ptr_ring_test_opt -s 1000 -m 0 -N 100000000
ptr_ring(size:1000) perf simple test for 100000000 times, took 2209415 us

 Performance counter stats for './ptr_ring_test_opt -s 1000 -m 0 -N 100000000':

           2209.70 msec task-clock                #    1.000 CPUs utilized
                24      context-switches          #    0.011 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                58      page-faults               #    0.026 K/sec
        5745003772      cycles                    #    2.600 GHz
       16124198886      instructions              #    2.81  insn per cycle
   <not supported>      branches
           6508414      branch-misses

       2.209973960 seconds time elapsed

       2.208354000 seconds user
       0.000000000 seconds sys


root@(none):~# perf stat ./ptr_ring_test_opt -s 1000 -m 0 -N 100000000
ptr_ring(size:1000) perf simple test for 100000000 times, took 2211409 us

 Performance counter stats for './ptr_ring_test_opt -s 1000 -m 0 -N 100000000':

           2211.70 msec task-clock                #    1.000 CPUs utilized
                24      context-switches          #    0.011 K/sec
                 0      cpu-migrations            #    0.000 K/sec
                57      page-faults               #    0.026 K/sec
        5750136694      cycles                    #    2.600 GHz
       16124176577      instructions              #    2.80  insn per cycle
   <not supported>      branches
           6553023      branch-misses

       2.211968470 seconds time elapsed

       2.210303000 seconds user
       0.000000000 seconds sys

---------------patched ptr_ring.c end----------------------------------

> 
>>


