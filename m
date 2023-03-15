Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437BC6BA4D9
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 02:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCOBvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 21:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCOBvw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 21:51:52 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84221515FD;
        Tue, 14 Mar 2023 18:51:50 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PbtcK71vMzHwx4;
        Wed, 15 Mar 2023 09:49:37 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Wed, 15 Mar
 2023 09:51:48 +0800
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
Date:   Wed, 15 Mar 2023 09:51:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

On 2023/3/15 5:09, Ronak Doshi wrote:
> 
> ﻿> On 3/9/23, 5:02 PM, "Yunsheng Lin" <linyunsheng@huawei.com <mailto:linyunsheng@huawei.com>> wrote:
>>
>> So it is a run time thing? What happens if some LRO'ed packet is put in the rx queue,
>> and the the vnic switches the mode to UPT, is it ok for those LRO'ed packets to go through
>> the software GSO processing?
> Yes, it should be fine.
> 
>> If yes, why not just call napi_gro_receive() for LRO case too?
>>
> We had done perf measurements in the past and it turned out this results in perf penalty.
> See https://patchwork.ozlabs.org/project/netdev/patch/1308947605-4300-1-git-send-email-jesse@nicira.com/
> 
> In fact, internally recently we did some perf measurements on RHEL 9.0, and it still showed some penalty.

Does clearing the NETIF_F_GRO for netdev->features bring back the performance?
If no, maybe there is something need investigating.

> 
>> Looking closer, it seems vnic is implementing hw GRO from driver' view, as the driver is
>> setting skb_shinfo(skb)->gso_* accordingly:
>>
>>
>> https://nam04.safelinks.protection.outlook.com/?url=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Flatest%2Fsource%2Fdrivers%2Fnet%2Fvmxnet3%2Fvmxnet3_drv.c%23L1665&data=05%7C01%7Cdoshir%40vmware.com%7C68e4b3dbd7d948887f0808db21031e2c%>7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C638140069565449054%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=LAw6oCG2MgYH4TPQAnWUy25E2u%2FDMSW2aSJ7OY2%2FOu8%3D&reserved=0 <https://nam04.safelinks.protection.outlook.com/?url=https%3A%2F%2Felixir.bootlin.com%2Flinux%2Flatest%2Fsource%2Fdrivers%2Fnet%2Fvmxnet3%2Fvmxnet3_drv.c%23L1665&amp;data=05%7C01%7Cdoshir%40vmware.com%7C68e4b3dbd7d948887f0808db21031e2c%7Cb39138ca3cee4b4aa4d6cd83d9dd62f0%7C0%7C0%7C638140069565449054%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=LAw6oCG2MgYH4TPQAnWUy25E2u%2FDMSW2aSJ7OY2%2FOu8%3D&amp;reserved=0>
>>
>>
>> In that case, you may call napi_gro_receive() for those GRO'ed skb too, see:
>>
> 
> I see. Seems this got added recently. This will need re-evaluation by the team based on ToT Linux.
> But this can be done in near future and as this might take time, for now this patch should be applied as
> UPT patches are already up-streamed.

Checking rq->shared->updateRxProd in the driver to decide if gro is allow does not seems right to
me, as the netstack has used the NETIF_F_GRO checking in netif_elide_gro().

Does clearing NETIF_F_GRO for netdev->features during the driver init process works for your
case?

As netdev->hw_features is for the driver to advertise the hw's capability, and the driver
can enable/disable specific capability by setting netdev->features during the driver init
process, and user can get to enable/disable specific capability using ethtool later if user
need to.

> 
> Thanks, 
> Ronak 
> 
> 
