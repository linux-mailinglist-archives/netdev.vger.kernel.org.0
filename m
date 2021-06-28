Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0D93B56D8
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 03:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbhF1Boe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 21:44:34 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5802 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhF1Boe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 21:44:34 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GCqw246HfzXk6j;
        Mon, 28 Jun 2021 09:36:50 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 09:42:07 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 09:42:06 +0800
Subject: Re: [PATCH net-next v2 1/2] selftests/ptr_ring: add benchmark
 application for ptr_ring
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <brouer@redhat.com>, <paulmck@kernel.org>,
        <peterz@infradead.org>, <will@kernel.org>, <shuah@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linuxarm@openeuler.org>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
 <1624591136-6647-2-git-send-email-linyunsheng@huawei.com>
 <ff47ed0b-332d-2772-d6e1-8277ac602c8c@redhat.com>
 <3ba4a6f1-2e1e-8c1a-6f47-5d182f05d1cd@huawei.com>
 <20210627020746-mutt-send-email-mst@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <684b4448-6102-dd62-d3e5-97170468683d@huawei.com>
Date:   Mon, 28 Jun 2021 09:42:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210627020746-mutt-send-email-mst@kernel.org>
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

On 2021/6/27 14:09, Michael S. Tsirkin wrote:
> On Fri, Jun 25, 2021 at 11:52:16AM +0800, Yunsheng Lin wrote:
>> On 2021/6/25 11:36, Jason Wang wrote:
>>>
>>> 在 2021/6/25 上午11:18, Yunsheng Lin 写道:
>>>> Currently ptr_ring selftest is embedded within the virtio
>>>> selftest, which involves some specific virtio operation,
>>>> such as notifying and kicking.
>>>>
>>>> As ptr_ring has been used by various subsystems, it deserves
>>>> it's owner's selftest in order to benchmark different usecase
>>>> of ptr_ring, such as page pool and pfifo_fast qdisc.
>>>>
>>>> So add a simple application to benchmark ptr_ring performance.
>>>> Currently two test mode is supported:
>>>> Mode 0: Both enqueuing and dequeuing is done in a single thread,
>>>>          it is called simple test mode in the test app.
>>>> Mode 1: Enqueuing and dequeuing is done in different thread
>>>>          concurrently, also known as SPSC(single-producer/
>>>>          single-consumer) test.
>>>>
>>>> The multi-producer/single-consumer test for pfifo_fast case is
>>>> not added yet, which can be added if using CAS atomic operation
>>>> to enable lockless multi-producer is proved to be better than
>>>> using r->producer_lock.
>>>>
>>>> Only supported on x86 and arm64 for now.
>>>>
>>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>>> ---
>>>>   MAINTAINERS                                      |   5 +
>>>>   tools/testing/selftests/ptr_ring/Makefile        |   6 +
>>>>   tools/testing/selftests/ptr_ring/ptr_ring_test.c | 249 +++++++++++++++++++++++
>>>>   tools/testing/selftests/ptr_ring/ptr_ring_test.h | 150 ++++++++++++++
>>>>   4 files changed, 410 insertions(+)
>>>
>>>
>>> Why can't you simply reuse tools/virtio/ringtest?
>>
>> The main reason is stated in the commit log:
>> "Currently ptr_ring selftest is embedded within the virtio
>> selftest, which involves some specific virtio operation,
>> such as notifying and kicking.
>>
>> As ptr_ring has been used by various subsystems, it deserves
>> it's owner's selftest in order to benchmark different usecase
>> of ptr_ring, such as page pool and pfifo_fast qdisc."
>>
>> More specificly in tools/virtio/ringtest/main.c and
>> tools/virtio/ringtest/ptr_ring.c, there are a lot of operation
>> related to virtio usecase, such as start_guest(), start_host(),
>> poll_used(), notify() or kick() ....., so it makes more sense
>> to add a generic selftest for ptr ring as it is not only used
>> by virtio now.
> 
> 
> Okay that answers why you didn't just run main.c
> but why not add a new test under tools/virtio/ringtest/
> reusing the rest of infrastructure that you currently copied?

Actually, my first attempt was to reuse the infrastructure in
tools/virtio/ or tools/virtio/ringtest/, and neither of them
was able to be compiled in the latest kernel.

And then I read through the code to try fixing the compile error,
I found that the testcase under tools/virtio/ is coupled deeply
to virtio as explained above, which was difficult to read for
someone who is not fimiliar with virtio.

So I searched for how testing is supposed to be added in the kernel,
it seems it is more common to add the testing in tools/testing or
tools/testing/selftest, and ptr ring is not only used by virtio now,
so it seems more appropriate to add a sperate testing for virtio by
instinct.

Most of tools/virtio/ is to do testing related to virtio testing, IMHO,
most of them are better to be in tools/testing/selftest. Even if most of
virtio testing is moved to tools/testing/selftest, I think it makes more
sense to decouple the virtio testing to ptr_ring testing too if we can
find some mechanism to share the abstract infrastructure in ptr_ring_test.h
for both virtio and ptr_ring testing.


> 
>>
>>>
>>> Thanks
>>>
>>>
>>> .
>>>
> 
> 
> .
> 

