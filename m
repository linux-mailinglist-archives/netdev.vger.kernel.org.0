Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136806B3374
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 02:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjCJBCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 20:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbjCJBCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 20:02:30 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F306115B73;
        Thu,  9 Mar 2023 17:02:26 -0800 (PST)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PXnks5rRbznVNR;
        Fri, 10 Mar 2023 08:59:33 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Fri, 10 Mar
 2023 09:02:24 +0800
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
To:     Ronak Doshi <doshir@vmware.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20230308222504.25675-1-doshir@vmware.com>
 <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
 <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
Date:   Fri, 10 Mar 2023 09:02:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/10 6:50, Ronak Doshi wrote:
> 
> ﻿> > On 3/8/23, 4:34 PM, "Yunsheng Lin" <linyunsheng@huawei.com <mailto:linyunsheng@huawei.com>> wrote:
>>>
>>> - if (adapter->netdev->features & NETIF_F_LRO)
>>> + /* Use GRO callback if UPT is enabled */
>>> + if ((adapter->netdev->features & NETIF_F_LRO) && !rq->shared->updateRxProd)
>>>
>>>
>> If UPT devicve does not support LRO, why not just clear the NETIF_F_LRO from
>> adapter->netdev->features?
>>
>>
>> With above change, it seems that LRO is supported for user' POV, but the GRO
>> is actually being done.
>>
>>
>> Also, if NETIF_F_LRO is set, do we need to clear the NETIF_F_GRO bit, so that
>> there is no confusion for user?
> 
> We cannot clear LRO bit as the virtual nic can run in either emulation or UPT mode.
> When the vnic switches the mode between UPT and emulation, the guest vm is not
> notified. Hence, we use updateRxProd which is shared in datapath to check what mode
> is being run.

So it is a run time thing? What happens if some LRO'ed packet is put in the rx queue,
and the the vnic switches the mode to UPT, is it ok for those LRO'ed packets to go through
the software GSO processing? If yes, why not just call napi_gro_receive() for LRO case too?

Looking closer, it seems vnic is implementing hw GRO from driver' view, as the driver is
setting skb_shinfo(skb)->gso_* accordingly:

https://elixir.bootlin.com/linux/latest/source/drivers/net/vmxnet3/vmxnet3_drv.c#L1665

In that case, you may call napi_gro_receive() for those GRO'ed skb too, see:

https://lore.kernel.org/netdev/166479721495.20474.5436625882203781290.git-patchwork-notify@kernel.org/T/

> 
> Also, we plan to add an event to notify the guest about this but that is for separate patch
> and may take some time.
> 
> Thanks, 
> Ronak 
> 
