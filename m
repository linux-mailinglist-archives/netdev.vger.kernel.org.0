Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD765AF961
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 03:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiIGBZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 21:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIGBZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 21:25:04 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A99167C6;
        Tue,  6 Sep 2022 18:25:02 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MMkx12v2FzmWQh;
        Wed,  7 Sep 2022 09:21:25 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 7 Sep 2022 09:24:59 +0800
Message-ID: <0adec8a4-8cbc-d14e-f6a5-c6c288100a1e@huawei.com>
Date:   Wed, 7 Sep 2022 09:24:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net,v2] net: sched: tbf: don't call qdisc_put() while
 holding tree lock
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <vladbu@mellanox.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20220826013930.340121-1-shaozhengchao@huawei.com>
 <YxY8ToCVWFSV6VqQ@pop-os.localdomain>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <YxY8ToCVWFSV6VqQ@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/6 2:13, Cong Wang wrote:
> On Fri, Aug 26, 2022 at 09:39:30AM +0800, Zhengchao Shao wrote:
>> The issue is the same to commit c2999f7fb05b ("net: sched: multiq: don't
>> call qdisc_put() while holding tree lock"). Qdiscs call qdisc_put() while
>> holding sch tree spinlock, which results sleeping-while-atomic BUG.
>>
> 
> Hm, did you see an actual warning here??
> 
> The commit you mentioned above is a classful Qdisc which accepts
> user-specified child Qdisc, but TBF technically does not, I don't think
> you can change its default fifo.
> 
> Thanks.

Hi Wang:
	Thank you for your reply. My apologise. I don't see the
warning here. Yes, TBF is classless qdisc, its default fifo is
bfifo and reset or destroy process will not sleep. So, it's not
a issue. Should I revert it, or keep it in this format(qdisc_put
out of holding sch tree spinlock).


Zhengchao Shao
