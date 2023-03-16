Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013DC6BC373
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCPBrV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPBrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:47:20 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3BFABAD3;
        Wed, 15 Mar 2023 18:47:18 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4PcVVr38VrzKnFn;
        Thu, 16 Mar 2023 09:47:00 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Thu, 16 Mar
 2023 09:47:15 +0800
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
 <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
 <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
 <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
 <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
 <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
 <AA320ADE-E149-4C0D-80D5-338B19AD31A2@vmware.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <77c30632-849f-8b7b-42ef-be8b32981c15@huawei.com>
Date:   Thu, 16 Mar 2023 09:47:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <AA320ADE-E149-4C0D-80D5-338B19AD31A2@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023/3/16 7:44, Ronak Doshi wrote:
> 
>> ﻿On 3/14/23, 8:05 PM, "Yunsheng Lin" <linyunsheng@huawei.com <mailto:linyunsheng@huawei.com>> wrote:
>>
>> I am not sure how we can handle the runtime hw capability changing thing yet, that is why
>> I suggested setting the hw capability during the driver init process, then user can enable
>> or disable GRO if need to.
>>
> It is not about enabling or disabling the LRO/GRO. It is about which callback to be used to
> deliver the packets to the stack.

That's the piont I am trying to make.
If I understand it correctly, you can not change callback from napi_gro_receive() to
netif_receive_skb() when netdev->features has the NETIF_F_GRO bit set.

NETIF_F_GRO bit in netdev->features is to tell user that netstack will perform the
software GRO processing if the packet can be GRO'ed.

Calling netif_receive_skb() with NETIF_F_GRO bit set in netdev->features will cause
confusion for user, IMHO.

> 
> During init, the vnic will always come up in emulation (non-UPT) mode and user can request 
> whichever feature they want (lro or gro or both). If it is in UPT mode, as we know UPT device
> does not support LRO, we use gro API to deliver. If GRO is disabled by the user, then it can still
> take the normal path. If in emulation (non-UPT) mode, ESXi will perform LRO.
> 
>> Suppose user enable the software GRO using ethtool, disabling the GRO through some runtime
>> checking seems against the will of the user.
>>
> We are not disabling GRO here, it's either we perform LRO on ESXi or GRO in guest stack.

I means software GRO performed by netstack.
There are NETIF_F_GRO_HW and NETIF_F_LRO bit for GRO and LRO performed by hw. LRO on ESXi
is like hw offload in the eye of the driver in the guest, even if it is processed by some
software in the ESXi.

> 
> 
>> Also, if you are able to "add an event to notify the guest about this", I suppose the
>> para-virtualized driver will clear the specific bit in netdev->hw_features and
>> netdev->features when handling the event? does user need to be notified about this, does
>> user get confusion about this change without notification?
>>
> We won’t be changing any feature bits. It is just to let know the driver that UPT is active and it
> should use GRO path instead of relying on ESXi LRO.

As above, there is different feature bit for that, NETIF_F_LRO, NETIF_F_GRO and
NETIF_F_GRO_HW.
IMHO, deciding which callback to be used depending on some driver configuation
without corporation with the above feature bits does not seems right to me.

> 
> Thanks,
> Ronak
> 
