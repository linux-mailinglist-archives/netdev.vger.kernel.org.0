Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321A53B9DA2
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 10:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhGBIn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 04:43:27 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9444 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhGBIn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 04:43:26 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GGT3r3MkHzZpPK;
        Fri,  2 Jul 2021 16:37:44 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 2 Jul 2021 16:40:48 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 2 Jul 2021
 16:40:48 +0800
Subject: Re: [Linuxarm] Re: [PATCH net-next v3 2/3] ptr_ring: move r->queue[]
 clearing after r->consumer_head updating
To:     Jason Wang <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <mst@redhat.com>
CC:     <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
 <1625142402-64945-3-git-send-email-linyunsheng@huawei.com>
 <230f0b91-fe92-c53f-4df0-ec36c7c6e223@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <00b5d5d6-a5ee-94c3-1c9b-81fd32e5d9e2@huawei.com>
Date:   Fri, 2 Jul 2021 16:40:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <230f0b91-fe92-c53f-4df0-ec36c7c6e223@redhat.com>
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

On 2021/7/2 14:45, Jason Wang wrote:
> 
> 在 2021/7/1 下午8:26, Yunsheng Lin 写道:
>> Currently r->queue[] clearing is done before r->consumer_head
>> updating, which makes the __ptr_ring_empty() returning false
>> positive result(the ring is non-empty, but __ptr_ring_empty()
>> suggest that it is empty) if the checking is done after the
>> r->queue clearing and before the consumer_head moving forward.
>>
>> Move the r->queue[] clearing after consumer_head moving forward
>> to avoid the above case.
>>
>> As a side effect of above change, a consumer_head checking is
>> avoided for the likely case, and it has noticeable performance
>> improvement when it is tested using the ptr_ring_test selftest
>> added in the previous patch.
>>
>> Tested using the "perf stat -r 1000 ./ptr_ring_test -s 1000 -m 1
>> -N 100000000", comparing the elapsed time:
>>
>>   arch     unpatched           patched       improvement
>> arm64    2.087205 sec       1.888224 sec      +9.5%
>>   X86      2.6538 sec         2.5422 sec       +4.2%
> 
> 
> I think we need the number of real workloads here.

As it is a low optimization, and overhead of enqueuing
and dequeuing is small for any real workloads, so the
performance improvement could be buried in deviation.
And that is why the ptr_ring_test is added, the about
10% improvement for arm64 seems big, but note that it
is tested using the taskset to avoid the numa effects
for arm64.

Anyway, here is the performance data for pktgen in
queue_xmit mode + dummy netdev with pfifo_fast(which
uses ptr_ring too), which is not obvious to the above
data:

 threads    unpatched        unpatched        delta
    1       3.21Mpps         3.23Mpps         +0.6%
    2       5.56Mpps         3.59Mpps         +0.5%
    4       5.58Mpps         5.61Mpps         +0.5%
    8       2.76Mpps         2.75Mpps         -0.3%
   16       2.23Mpps         2.22Mpps         -0.4%

> 
> Thanks
> 
> 
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>

