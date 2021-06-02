Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73506398540
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 11:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231880AbhFBJ3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 05:29:11 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2959 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhFBJ3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 05:29:10 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fw3Wb3fwbz68S4;
        Wed,  2 Jun 2021 17:24:27 +0800 (CST)
Received: from [10.174.176.245] (10.174.176.245) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 17:27:24 +0800
Subject: Re: [PATCH net-next] xsk: Return -EINVAL instead of -EBUSY after
 xsk_get_pool_from_qid() fails
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
CC:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210602031001.18656-1-wanghai38@huawei.com>
 <CAJ8uoz2sT9iyqjWcsUDQZqZCVoCfpqgM7TseOTqeCzOuChAwww@mail.gmail.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <73777ee0-bf6e-ccd2-015f-7539a2cd7687@huawei.com>
Date:   Wed, 2 Jun 2021 17:27:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAJ8uoz2sT9iyqjWcsUDQZqZCVoCfpqgM7TseOTqeCzOuChAwww@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, I misunderstood here, this is a faulty patch and no changes are 
needed here. Please ignore this patch

在 2021/6/2 16:29, Magnus Karlsson 写道:
> On Wed, Jun 2, 2021 at 6:02 AM Wang Hai <wanghai38@huawei.com> wrote:
>> xsk_get_pool_from_qid() fails not because the device's queues are busy,
>> but because the queue_id exceeds the current number of queues.
>> So when it fails, it is better to return -EINVAL instead of -EBUSY.
>>
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
>>   net/xdp/xsk_buff_pool.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
>> index 8de01aaac4a0..30ece117117a 100644
>> --- a/net/xdp/xsk_buff_pool.c
>> +++ b/net/xdp/xsk_buff_pool.c
>> @@ -135,7 +135,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool,
>>                  return -EINVAL;
>>
>>          if (xsk_get_pool_from_qid(netdev, queue_id))
>> -               return -EBUSY;
>> +               return -EINVAL;
> I guess your intent here is to return -EINVAL only when the queue_id
> is larger than the number of active queues.

Yes, I just confirmed that this has been implemented in xp_assign_dev().

int xp_assign_dev()

{

...

     err = xsk_reg_pool_at_qid(netdev, pool, queue_id);

     if (err)

         return err;     //return -EINVAL;

...

}

> But this patch also
> changes the return code when the queue id is already in use and in
> that case we should continue to return -EBUSY. As this function is
> used by a number of drivers, the easiest way to accomplish this is to
> introduce a test for queue_id out of bounds before this if-statement
> and return -EINVAL there.
>
>>          pool->netdev = netdev;
>>          pool->queue_id = queue_id;
>> --
>> 2.17.1
>>
> .
>
