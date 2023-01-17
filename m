Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C29166D69C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 08:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbjAQHE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 02:04:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235795AbjAQHEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 02:04:21 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C342324104
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 23:04:19 -0800 (PST)
Received: from kwepemm600017.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Nx0B41C4JzqVHJ;
        Tue, 17 Jan 2023 14:59:24 +0800 (CST)
Received: from [10.67.101.149] (10.67.101.149) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Tue, 17 Jan 2023 15:04:16 +0800
Subject: Re: [PATCH net-next 2/2] net: hns3: add vf fault process in hns3 ras
To:     Leon Romanovsky <leon@kernel.org>, Hao Lan <lanhao@huawei.com>
References: <20230113020829.48451-1-lanhao@huawei.com>
 <20230113020829.48451-3-lanhao@huawei.com> <Y8D/dXTBxrLOwmgc@unreal>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>, <shenjian15@huawei.com>,
        <netdev@vger.kernel.org>
From:   "wangjie (L)" <wangjie125@huawei.com>
Message-ID: <a5a603bb-ae04-f274-5d68-f8d63a4bf13b@huawei.com>
Date:   Tue, 17 Jan 2023 15:04:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <Y8D/dXTBxrLOwmgc@unreal>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.149]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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



On 2023/1/13 14:51, Leon Romanovsky wrote:
> On Fri, Jan 13, 2023 at 10:08:29AM +0800, Hao Lan wrote:
>> From: Jie Wang <wangjie125@huawei.com>
>>
>> Currently hns3 driver supports vf fault detect feature. Several ras caused
>> by VF resources don't need to do PF function reset for recovery. The driver
>> only needs to reset the specified VF.
>>
>> So this patch adds process in ras module. New process will get detailed
>> information about ras and do the most correct measures based on these
>> accurate information.
>>
>> Signed-off-by: Jie Wang <wangjie125@huawei.com>
>> Signed-off-by: Hao Lan <lanhao@huawei.com>
>> ---
>>  drivers/net/ethernet/hisilicon/hns3/hnae3.h   |   1 +
>>  .../hns3/hns3_common/hclge_comm_cmd.h         |   1 +
>>  .../hisilicon/hns3/hns3pf/hclge_err.c         | 113 +++++++++++++++++-
>>  .../hisilicon/hns3/hns3pf/hclge_err.h         |   2 +
>>  .../hisilicon/hns3/hns3pf/hclge_main.c        |   3 +-
>>  .../hisilicon/hns3/hns3pf/hclge_main.h        |   1 +
>>  6 files changed, 115 insertions(+), 6 deletions(-)
>
> Why is it good idea to reset VF from PF?
> What will happen with driver bound to this VF?
> Shouldn't PCI recovery handle it?
>
> Thanks
> .
PF doesn't reset VF directly. These VF faults are detected by hardware,
and only reported to PF. PF get the VF id from firmware, then notify the 
VF that it needs reset. VF will do reset after receive the request.

These hardware faults are not standard PCI ras event, so we prefer to 
use MSIx path.
>
