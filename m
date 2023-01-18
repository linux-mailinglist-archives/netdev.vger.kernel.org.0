Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446B2671D2C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 14:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjARNKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 08:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbjARNKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 08:10:07 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853112411A
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 04:34:09 -0800 (PST)
Received: from kwepemm600017.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4NxlSs5xdhzJqDH;
        Wed, 18 Jan 2023 20:29:49 +0800 (CST)
Received: from [10.67.101.149] (10.67.101.149) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 18 Jan 2023 20:34:04 +0800
Subject: Re: [PATCH net-next 2/2] net: hns3: add vf fault process in hns3 ras
To:     Leon Romanovsky <leon@kernel.org>
References: <20230113020829.48451-1-lanhao@huawei.com>
 <20230113020829.48451-3-lanhao@huawei.com> <Y8D/dXTBxrLOwmgc@unreal>
 <a5a603bb-ae04-f274-5d68-f8d63a4bf13b@huawei.com> <Y8aEymyUf+WB8T8g@unreal>
CC:     Hao Lan <lanhao@huawei.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <yisen.zhuang@huawei.com>,
        <salil.mehta@huawei.com>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <shenjian15@huawei.com>, <netdev@vger.kernel.org>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <3ce018d9-e005-f988-37ed-016c559973ec@huawei.com>
Date:   Wed, 18 Jan 2023 20:34:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <Y8aEymyUf+WB8T8g@unreal>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/17 19:21, Leon Romanovsky wrote:
> On Tue, Jan 17, 2023 at 03:04:15PM +0800, wangjie (L) wrote:
>>
>>
>> On 2023/1/13 14:51, Leon Romanovsky wrote:
>>> On Fri, Jan 13, 2023 at 10:08:29AM +0800, Hao Lan wrote:
>>>> From: Jie Wang <wangjie125@huawei.com>
>>>>
>>>> Currently hns3 driver supports vf fault detect feature. Several ras caused
>>>> by VF resources don't need to do PF function reset for recovery. The driver
>>>> only needs to reset the specified VF.
>>>>
>>>> So this patch adds process in ras module. New process will get detailed
>>>> information about ras and do the most correct measures based on these
>>>> accurate information.
>>>>
>>>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
>>>> Signed-off-by: Hao Lan <lanhao@huawei.com>
>>>> ---
>>>>  drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 +
>>>>  .../hns3/hns3_common/hclge_comm_cmd.h         |   1 +
>>>>  .../hisilicon/hns3/hns3pf/hclge_err.c         | 113 +++++++++++++++++-
>>>>  .../hisilicon/hns3/hns3pf/hclge_err.h         |   2 +
>>>>  .../hisilicon/hns3/hns3pf/hclge_main.c        |   3 +-
>>>>  .../hisilicon/hns3/hns3pf/hclge_main.h        |   1 +
>>>>  6 files changed, 115 insertions(+), 6 deletions(-)
>>>
>>> Why is it good idea to reset VF from PF?
>>> What will happen with driver bound to this VF?
>>> Shouldn't PCI recovery handle it?
>>>
>>> Thanks
>>> .
>> PF doesn't reset VF directly. These VF faults are detected by hardware,
>> and only reported to PF. PF get the VF id from firmware, then notify the VF
>> that it needs reset. VF will do reset after receive the request.
>
> This description isn't aligned with the code. You are issuing
> hclge_func_reset_cmd() command which will reset VF, while notification
> are handled by hclge_func_reset_notify_vf().
>
> It also doesn't make any sense to send notification event to VF through
> FW while the goal is to recover from stuck FW in that VF.
>
Yes, I misunderstand the hclge_func_reset_notify_vf and
hclge_func_reset_cmd. It should use hclge_func_reset_notify_vf to inform
the VF for recovery. I will fix and retest it in V2.

This patch is used to recover specific vf hardware errors, for example the
tx queue configuration exceptions. It make sense in these cases for the
firmware is still working properly and can do the recovery rightly.
>>
>> These hardware faults are not standard PCI ras event, so we prefer to use
>> MSIx path.
>
> What is different here?
>
These hardware faults are reported by MSIx interrupts instead of PCI ras
path.

Thanks!
>>>
> .
>
