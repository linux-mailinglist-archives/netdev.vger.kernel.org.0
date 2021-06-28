Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6FA3B572A
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 04:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhF1CTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 22:19:41 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8471 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbhF1CTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 22:19:40 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GCrl51BgNzZmJj;
        Mon, 28 Jun 2021 10:14:09 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 28 Jun 2021 10:17:13 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 28 Jun
 2021 10:17:13 +0800
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
 <20210625022128-mutt-send-email-mst@kernel.org>
 <c6975b2d-2b4a-5b3f-418c-1a59607b9864@huawei.com>
 <20210625032508-mutt-send-email-mst@kernel.org>
 <4ced872f-da7a-95a3-2ef1-c281dfb84425@huawei.com>
 <20210627020132-mutt-send-email-mst@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9519986f-165c-1afe-8d1d-dbea11908f00@huawei.com>
Date:   Mon, 28 Jun 2021 10:17:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210627020132-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/27 14:03, Michael S. Tsirkin wrote:
>>>>>
>>>>>
>>>>> So if now we need this to be reliable then
>>>>> we also need smp_wmb before writing r->queue[consumer_head],
>>>>> there could be other gotchas.
>>>>
>>>> Yes, This patch does not make it strictly reliable.
>>>> T think I could mention that in the commit log?
>>>
>>> OK so it's not that it makes it more reliable - this patch simply makes
>>> a possible false positive less likely while making  a false negative
>>> more likely. Our assumption is that a false negative is cheaper then?
>>>
>>> How do we know that it is?
>>>
>>> And even if we prove the ptr_ring itself is faster now,
>>> how do we know what affects callers in a better way a
>>> false positive or a false negative?
>>>
>>> I would rather we worked on actually making it reliable
>>> e.g. if we can guarantee no false positives, that would be
>>> a net win.
>> I thought deeper about the case you mentioned above, it
>> seems for the above to happen, the consumer_head need to
>> be rolled back to zero and incremented to the point when
>> caller of __ptr_ring_empty() is still *not* able to see the
>> r->queue[] which has been set to NULL in __ptr_ring_discard_one().
>>
>> It seems smp_wmb() only need to be done once when consumer_head
>> is rolled back to zero, and maybe that is enough to make sure the
>> case you mentioned is fixed too?
>>
>> And the smp_wmb() is only done once in a round of producing/
>> consuming, so the performance impact should be minimized?(of
>> course we need to test it too).
> 
> 
> Sorry I don't really understand the question here.
> I think I agree it's enough to do one smp_wmb between
> the write of r->queue and write of consumer_head
> to help guarantee no false positives.
> What other code changes are necessary I can't yet say
> without more a deeper code review.
> 

Ok, thanks for the reviewing.
Will add handling the case you mentioned above in V3 if there
is no noticable performanc impact for handling the above case.

