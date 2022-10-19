Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0299C6047D5
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiJSNqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233049AbiJSNp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:45:29 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 640914456C
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:31:54 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MslsS2L3Zz1P77l;
        Wed, 19 Oct 2022 17:33:32 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 17:37:42 +0800
Message-ID: <7a64d717-250c-80e5-3384-835a2c72b4bb@huawei.com>
Date:   Wed, 19 Oct 2022 17:37:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 3/4] net: hinic: fix the issue of CMDQ memory leaks
To:     Leon Romanovsky <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <keescook@chromium.org>, <gustavoars@kernel.org>,
        <gregkh@linuxfoundation.org>, <ast@kernel.org>,
        <peter.chen@kernel.org>, <bin.chen@corigine.com>,
        <luobin9@huawei.com>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
References: <20221019024220.376178-1-shaozhengchao@huawei.com>
 <20221019024220.376178-4-shaozhengchao@huawei.com> <Y0+lRITJ1kPNCY0c@unreal>
 <8d79818c-21a3-9a78-7b80-15f5c60875a4@huawei.com> <Y0+3rd/tmB289uPX@unreal>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <Y0+3rd/tmB289uPX@unreal>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/10/19 16:39, Leon Romanovsky wrote:
> On Wed, Oct 19, 2022 at 03:41:06PM +0800, shaozhengchao wrote:
>>
>>
>> On 2022/10/19 15:20, Leon Romanovsky wrote:
>>> On Wed, Oct 19, 2022 at 10:42:19AM +0800, Zhengchao Shao wrote:
>>>> When hinic_set_cmdq_depth() fails in hinic_init_cmdqs(), the cmdq memory is
>>>> not released correctly. Fix it.
>>>>
>>>> Fixes: 72ef908bb3ff ("hinic: add three net_device_ops of vf")
>>>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>>>> ---
>>>>    drivers/net/ethernet/huawei/hinic/hinic_hw_cmdq.c | 5 +++++
>>>>    1 file changed, 5 insertions(+)
>>>
>>> <...>
>>>
>>>> +	cmdq_type = HINIC_CMDQ_SYNC;
>>>> +	for (; cmdq_type < HINIC_MAX_CMDQ_TYPES; cmdq_type++)
>>>
>>> Why do you have this "for loops" in all places? There is only one cmdq_type.
>>>
>>> Thanks
>> Hi Leon:
>> 	Thank you for your review. Now, only the synchronous CMDQ is
>> enabled for the current CMDQs. New type of CMDQ could be added later.
> 
> Single command type was added in 2017, and five years later, new type wasn't added yet.
> 
OK, I will modify in V2, and I will do cleanup in another patch.

Thanks

Zhengchao Shao

>> So looping style is maintained on both the allocation and release paths.
>>
>> Zhengchao Shao
