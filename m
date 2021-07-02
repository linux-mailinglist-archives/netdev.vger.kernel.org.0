Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8493B9D6F
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 10:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhGBITy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 04:19:54 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:10237 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbhGBITx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 04:19:53 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GGSV43NdSz1BPTq;
        Fri,  2 Jul 2021 16:11:56 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 16:17:18 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 2 Jul 2021
 16:17:18 +0800
Subject: Re: [PATCH net-next v3 1/3] selftests/ptr_ring: add benchmark
 application for ptr_ring
To:     Jason Wang <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <mst@redhat.com>
CC:     <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
 <1625142402-64945-2-git-send-email-linyunsheng@huawei.com>
 <e1ec4577-a48f-ff56-b766-1445c2501b9f@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <91bcade8-f034-4bc7-f329-d5e1849867e7@huawei.com>
Date:   Fri, 2 Jul 2021 16:17:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <e1ec4577-a48f-ff56-b766-1445c2501b9f@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/2 14:43, Jason Wang wrote:
> 
> ÔÚ 2021/7/1 ÏÂÎç8:26, Yunsheng Lin Ð´µÀ:
>> Currently ptr_ring selftest is embedded within the virtio
>> selftest, which involves some specific virtio operation,
>> such as notifying and kicking.
>>
>> As ptr_ring has been used by various subsystems, it deserves
>> it's owner selftest in order to benchmark different usecase
>> of ptr_ring, such as page pool and pfifo_fast qdisc.
>>
>> So add a simple application to benchmark ptr_ring performance.
>> Currently two test mode is supported:
>> Mode 0: Both producing and consuming is done in a single thread,
>>          it is called simple test mode in the test app.
>> Mode 1: Producing and consuming is done in different thread
>>          concurrently, also known as SPSC(single-producer/
>>          single-consumer) test.
>>
>> The multi-producer/single-consumer test for pfifo_fast case is
>> not added yet, which can be added if using CAS atomic operation
>> to enable lockless multi-producer is proved to be better than
>> using r->producer_lock.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>> V3: Remove timestamp sampling, use standard C library as much
>>      as possible.

[...]

>> +static void *produce_worker(void *arg)
>> +{
>> +    struct worker_info *info = arg;
>> +    unsigned long i = 0;
>> +    int ret;
>> +
>> +    while (++i <= info->test_count) {
>> +        while (__ptr_ring_full(&ring))
>> +            cpu_relax();
>> +
>> +        ret = __ptr_ring_produce(&ring, (void *)i);
>> +        if (ret) {
>> +            fprintf(stderr, "produce failed: %d\n", ret);
>> +            info->error = true;
>> +            return NULL;
>> +        }
>> +    }
>> +
>> +    info->error = false;
>> +
>> +    return NULL;
>> +}
>> +
>> +static void *consume_worker(void *arg)
>> +{
>> +    struct worker_info *info = arg;
>> +    unsigned long i = 0;
>> +    int *ptr;
>> +
>> +    while (++i <= info->test_count) {
>> +        while (__ptr_ring_empty(&ring))
>> +            cpu_relax();
> 
> 
> Any reason for not simply use __ptr_ring_consume() here?

No particular reason, just to make sure the ring is
non-empty before doing the enqueuing, we could check
if the __ptr_ring_consume() return NULL to decide
the if the ring is empty. Using __ptr_ring_consume()
here enable testing the correctness and performance of
__ptr_ring_consume() too.

> 
> 
>> +
>> +        ptr = __ptr_ring_consume(&ring);
>> +        if ((unsigned long)ptr != i) {
>> +            fprintf(stderr, "consumer failed, ptr: %lu, i: %lu\n",
>> +                (unsigned long)ptr, i);
>> +            info->error = true;
>> +            return NULL;
>> +        }
>> +    }
>> +
>> +    if (!__ptr_ring_empty(&ring)) {
>> +        fprintf(stderr, "ring should be empty, test failed\n");
>> +        info->error = true;
>> +        return NULL;
>> +    }
>> +
>> +    info->error = false;
>> +    return NULL;
>> +}
>> +

[...]

>> +
>> +    return 0;
>> +}
>> diff --git a/tools/testing/selftests/ptr_ring/ptr_ring_test.h b/tools/testing/selftests/ptr_ring/ptr_ring_test.h
>> new file mode 100644
>> index 0000000..32bfefb
>> --- /dev/null
>> +++ b/tools/testing/selftests/ptr_ring/ptr_ring_test.h
> 
> 
> Let's reuse ptr_ring.c in tools/virtio/ringtest. Nothing virt specific there.

It *does* have some virtio specific at the end of ptr_ring.c.
It can be argued that the ptr_ring.c in tools/virtio/ringtest
could be refactored to remove the function related to virtio.

But as mentioned in the previous disscusion [1], the tools/virtio/
seems to have compile error in the latest kernel, it does not seems
right to reuse that. And most of testcase in tools/virtio/ seems
better be in tools/virtio/ringtest instead£¬so until the testcase
in tools/virtio/ is compile-error-free and moved to tools/testing/
selftests/, it seems better not to reuse it for now.

1. https://patchwork.kernel.org/project/netdevbpf/patch/1624591136-6647-2-git-send-email-linyunsheng@huawei.com/#24278945

> 
> Thanks
> 

[...]

> 
> .
> 
