Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6813B3B58
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 05:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233094AbhFYDy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 23:54:56 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5076 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233023AbhFYDyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 23:54:55 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GB2y00n5jzXktQ;
        Fri, 25 Jun 2021 11:47:20 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 25 Jun 2021 11:52:17 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 25 Jun
 2021 11:52:16 +0800
Subject: Re: [PATCH net-next v2 1/2] selftests/ptr_ring: add benchmark
 application for ptr_ring
To:     Jason Wang <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <mst@redhat.com>
CC:     <brouer@redhat.com>, <paulmck@kernel.org>, <peterz@infradead.org>,
        <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
 <1624591136-6647-2-git-send-email-linyunsheng@huawei.com>
 <ff47ed0b-332d-2772-d6e1-8277ac602c8c@redhat.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <3ba4a6f1-2e1e-8c1a-6f47-5d182f05d1cd@huawei.com>
Date:   Fri, 25 Jun 2021 11:52:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <ff47ed0b-332d-2772-d6e1-8277ac602c8c@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme710-chm.china.huawei.com (10.1.199.106) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/25 11:36, Jason Wang wrote:
> 
> ÔÚ 2021/6/25 ÉÏÎç11:18, Yunsheng Lin Ð´µÀ:
>> Currently ptr_ring selftest is embedded within the virtio
>> selftest, which involves some specific virtio operation,
>> such as notifying and kicking.
>>
>> As ptr_ring has been used by various subsystems, it deserves
>> it's owner's selftest in order to benchmark different usecase
>> of ptr_ring, such as page pool and pfifo_fast qdisc.
>>
>> So add a simple application to benchmark ptr_ring performance.
>> Currently two test mode is supported:
>> Mode 0: Both enqueuing and dequeuing is done in a single thread,
>>          it is called simple test mode in the test app.
>> Mode 1: Enqueuing and dequeuing is done in different thread
>>          concurrently, also known as SPSC(single-producer/
>>          single-consumer) test.
>>
>> The multi-producer/single-consumer test for pfifo_fast case is
>> not added yet, which can be added if using CAS atomic operation
>> to enable lockless multi-producer is proved to be better than
>> using r->producer_lock.
>>
>> Only supported on x86 and arm64 for now.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>> ---
>>   MAINTAINERS                                      |   5 +
>>   tools/testing/selftests/ptr_ring/Makefile        |   6 +
>>   tools/testing/selftests/ptr_ring/ptr_ring_test.c | 249 +++++++++++++++++++++++
>>   tools/testing/selftests/ptr_ring/ptr_ring_test.h | 150 ++++++++++++++
>>   4 files changed, 410 insertions(+)
> 
> 
> Why can't you simply reuse tools/virtio/ringtest?

The main reason is stated in the commit log:
"Currently ptr_ring selftest is embedded within the virtio
selftest, which involves some specific virtio operation,
such as notifying and kicking.

As ptr_ring has been used by various subsystems, it deserves
it's owner's selftest in order to benchmark different usecase
of ptr_ring, such as page pool and pfifo_fast qdisc."

More specificly in tools/virtio/ringtest/main.c and
tools/virtio/ringtest/ptr_ring.c, there are a lot of operation
related to virtio usecase, such as start_guest(), start_host(),
poll_used(), notify() or kick() ....., so it makes more sense
to add a generic selftest for ptr ring as it is not only used
by virtio now.


> 
> Thanks
> 
> 
> .
> 

