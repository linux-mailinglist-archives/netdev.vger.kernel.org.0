Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC41762D47C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 08:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234412AbiKQH6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 02:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiKQH6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 02:58:12 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B683159871
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 23:58:11 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCXMQ4kLbzHw0Z;
        Thu, 17 Nov 2022 15:57:38 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 15:58:09 +0800
Message-ID: <1fe5dc97-f6f6-f204-bbf5-954fe7e9790c@huawei.com>
Date:   Thu, 17 Nov 2022 15:58:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH] 9p: Fix write overflow in p9_read_work
Content-Language: en-US
To:     <asmadeus@codewreck.org>
CC:     <ericvh@gmail.com>, <lucho@ionkov.net>, <linux_oss@crudebyte.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <v9fs-developer@lists.sourceforge.net>,
        <netdev@vger.kernel.org>
References: <20221117061444.27287-1-guozihua@huawei.com>
 <Y3Xi2PmyglEzH5/u@codewreck.org>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <Y3Xi2PmyglEzH5/u@codewreck.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/17 15:29, asmadeus@codewreck.org wrote:
> GUO Zihua wrote on Thu, Nov 17, 2022 at 02:14:44PM +0800:
>> The root cause of this issue is that we check the size of the message
>> received against the msize of the client in p9_read_work. However, this
>> msize could be lager than the capacity of the sdata buffer. Thus,
>> the message size should also be checked against sdata capacity.
> 
> Thanks for the fix!
> 
> I'm picky, so a few remarks below.
> 
>>
>> Reported-by: syzbot+0f89bd13eaceccc0e126@syzkaller.appspotmail.com
>> Fixes: 1b0a763bdd5e ("9p: use the rcall structure passed in the request in trans_fd read_work")
>> Signed-off-by: GUO Zihua <guozihua@huawei.com>
>> ---
>>   net/9p/trans_fd.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
>> index 56a186768750..bc131a21c098 100644
>> --- a/net/9p/trans_fd.c
>> +++ b/net/9p/trans_fd.c
>> @@ -342,6 +342,14 @@ static void p9_read_work(struct work_struct *work)
>>   			goto error;
>>   		}
>>   
>> +		if (m->rc.size > m->rreq->rc.capacity - m->rc.offset) {
> 
> Ah, it took me a while to understand but capacity here is no longer the
> same as msize since commit 60ece0833b6c ("net/9p: allocate appropriate
> reduced message buffers")
> 
> If you have time to test the reproducer, please check with any commit
> before 60ece0833b6c if you can still reproduce. If not please fix your
> Fixes tag to this commit.
> I'd appreciate a word in the commit message saying that message capacity
> is no longer constant here and needs a more subtle check than msize.
> 
> 
> Also:
>   - We can remove the msize check, it's redundant with this; it doesn't
> matter if we don't check for msize before doing the tag lookup as tag
> has already been read
>   - While the `- offset` part of the check is correct (rc.size does
> not include headers, and the current offset must be 7 here) I'd prefer
> if you woud use P9_HDRSZ as that's defined in the protocol and using
> macros will be easier to check if that ever evolves.
>   - (I'd also appreciate if you could update the capacity = 7 next to the
> 'start by reading header' comment above while you're here so we use the
> same macro in both place)
> 
> 
>> +			p9_debug(P9_DEBUG_ERROR,
>> +				 "requested packet size too big: %d\n",
>> +				 m->rc.size);
> 
> Please log m->rc.tag, m->rc.id and m->rreq->rc.capacity as well for
> debugging if that happens.
> 
>> +			err = -EIO;
>> +			goto error;
>> +		}
>> +
>>   		if (!m->rreq->rc.sdata) {
>>   			p9_debug(P9_DEBUG_ERROR,
>> 				 "No recv fcall for tag %d (req %p), disconnecting!\n",
> --
> Dominique

Hi Dominique, Thanks for the comment, will push a v2 right away.
-- 
Best
GUO Zihua

