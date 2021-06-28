Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB0E13B5724
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 04:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhF1CNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 22:13:53 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:5907 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231781AbhF1CNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 22:13:51 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GCrc42FHYz74mX;
        Mon, 28 Jun 2021 10:08:04 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 10:11:23 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 10:11:23 +0800
Subject: Re: [Linuxarm] Re: [PATCH net-next v2 2/2] ptr_ring: make
 __ptr_ring_empty() checking more reliable
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
 <1624591136-6647-3-git-send-email-linyunsheng@huawei.com>
 <20210625023749-mutt-send-email-mst@kernel.org>
 <77615160-6f4f-64bf-7de9-b0adaddd5f06@huawei.com>
 <20210627020440-mutt-send-email-mst@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <0372e117-71fc-5696-783d-43a58a013c8a@huawei.com>
Date:   Mon, 28 Jun 2021 10:11:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210627020440-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/27 14:07, Michael S. Tsirkin wrote:
> On Fri, Jun 25, 2021 at 05:20:10PM +0800, Yunsheng Lin wrote:
>> On 2021/6/25 14:39, Michael S. Tsirkin wrote:
>>> On Fri, Jun 25, 2021 at 11:18:56AM +0800, Yunsheng Lin wrote:
>>>> Currently r->queue[] is cleared after r->consumer_head is moved
>>>> forward, which makes the __ptr_ring_empty() checking called in
>>>> page_pool_refill_alloc_cache() unreliable if the checking is done
>>>> after the r->queue clearing and before the consumer_head moving
>>>> forward.
>>>>
>>>> Move the r->queue[] clearing after consumer_head moving forward
>>>> to make __ptr_ring_empty() checking more reliable.
>>>>
>>>> As a side effect of above change, a consumer_head checking is
>>>> avoided for the likely case, and it has noticeable performance
>>>> improvement when it is tested using the ptr_ring_test selftest
>>>> added in the previous patch.
>>>>
>>>> Using "taskset -c 1 ./ptr_ring_test -s 1000 -m 0 -N 100000000"
>>>> to test the case of single thread doing both the enqueuing and
>>>> dequeuing:
>>>>
>>>>  arch     unpatched           patched       delta
>>>> arm64      4648 ms            4464 ms       +3.9%
>>>>  X86       2562 ms            2401 ms       +6.2%
>>>>
>>>> Using "taskset -c 1-2 ./ptr_ring_test -s 1000 -m 1 -N 100000000"
>>>> to test the case of one thread doing enqueuing and another thread
>>>> doing dequeuing concurrently, also known as single-producer/single-
>>>> consumer:
>>>>
>>>>  arch      unpatched             patched         delta
>>>> arm64   3624 ms + 3624 ms   3462 ms + 3462 ms    +4.4%
>>>>  x86    2758 ms + 2758 ms   2547 ms + 2547 ms    +7.6%
>>>
>>> Nice but it's small - could be a fluke.
>>> How many tests did you run? What is the variance?
>>> Did you try pinning to different CPUs to observe numa effects?
>>> Please use perf or some other modern tool for this kind
>>> of benchmark. Thanks!
>>
>> The result is quite stable, and retest using perf stat：
> 
> How stable exactly?  Try with -r so we can find out.

Retest with "perf stat -r":

For unpatched one:
Performance counter stats for './ptr_ring_test -s 1000 -m 1 -N 100000000' (100 runs):

           6780.97 msec task-clock                #    2.000 CPUs utilized            ( +-  5.36% )
                73      context-switches          #    0.011 K/sec                    ( +-  5.07% )
                 0      cpu-migrations            #    0.000 K/sec                    ( +-100.00% )
                81      page-faults               #    0.012 K/sec                    ( +-  0.76% )
       17629544748      cycles                    #    2.600 GHz                      ( +-  5.36% )
       25496488950      instructions              #    1.45  insn per cycle           ( +-  0.26% )
   <not supported>      branches
          11489031      branch-misses                                                 ( +-  1.69% )

             3.391 +- 0.182 seconds time elapsed  ( +-  5.35% )

For patched one:
Performance counter stats for './ptr_ring_test_opt -s 1000 -m 1 -N 100000000' (100 runs):

           6567.83 msec task-clock                #    2.000 CPUs utilized            ( +-  5.53% )
                71      context-switches          #    0.011 K/sec                    ( +-  5.26% )
                 0      cpu-migrations            #    0.000 K/sec
                82      page-faults               #    0.012 K/sec                    ( +-  0.85% )
       17075489298      cycles                    #    2.600 GHz                      ( +-  5.53% )
       23861051578      instructions              #    1.40  insn per cycle           ( +-  0.07% )
   <not supported>      branches
          10473776      branch-misses                                                 ( +-  0.60% )

             3.284 +- 0.182 seconds time elapsed  ( +-  5.53% )


The result is more stable when using taskset to limit the running cpu, but I suppose
the above data is stable enough to justify the performance improvement?










