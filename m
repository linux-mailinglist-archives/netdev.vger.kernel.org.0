Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A2C6BA573
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 04:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjCODE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 23:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCODE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 23:04:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88369574E5;
        Tue, 14 Mar 2023 20:04:56 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PbwDg4BWYzHwMn;
        Wed, 15 Mar 2023 11:02:43 +0800 (CST)
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21; Wed, 15 Mar
 2023 11:04:54 +0800
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
Date:   Wed, 15 Mar 2023 11:04:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

On 2023/3/15 10:27, Ronak Doshi wrote:
> 
>> On 3/14/23, 6:52 PM, "Yunsheng Lin" <linyunsheng@huawei.com <mailto:linyunsheng@huawei.com>> wrote:
>>
>> Does clearing the NETIF_F_GRO for netdev->features bring back the performance?
>> If no, maybe there is something need investigating.
> 
> Yes, it does. Simply using netif_receive_skb works fine.
> 
>> Checking rq->shared->updateRxProd in the driver to decide if gro is allow does not seems right to
>> me, as the netstack has used the NETIF_F_GRO checking in netif_elide_gro().
>>
> updateRxProd is NOT being used to determine if GRO is allowed. It is being used to indicate UPT is
> active, so the driver should just use GRO callback. This is as good as having only GRO callback for UPT driver
> which you were suggesting earlier.
> 
>> Does clearing NETIF_F_GRO for netdev->features during the driver init process works for your
>> case?
> 
> No this does not work as UPT mode can be enabled/disabled at runtime without guest being informed.
> This is para-virtualized driver and does not know if the guest is being run in emulation or UPT.

I think checking updateRxProd in some way means the above para-virtualized driver need to
know if the guest is being run in emulation or UPT.

I am not sure how we can handle the runtime hw capability changing thing yet, that is why
I suggested setting the hw capability during the driver init process, then user can enable
or disable GRO if need to.

Suppose user enable the software GRO using ethtool, disabling the GRO through some runtime
checking seems against the will of the user.

Also, if you are able to "add an event to notify the guest about this", I suppose the
para-virtualized driver will clear the specific bit in netdev->hw_features and
netdev->features when handling the event? does user need to be notified about this, does
user get confusion about this change without notification?

IMHO, being para-virtualized driver does not make any difference, the users do not care if
they are configuring a netdev behind a para-virtualized driver or not.

> 
>> As netdev->hw_features is for the driver to advertise the hw's capability, and the driver
>> can enable/disable specific capability by setting netdev->features during the driver init
>> process, and user can get to enable/disable specific capability using ethtool later if user
>> need to.
> 
> As I mentioned above, guest is not informed at runtime about UPT status. So, we need this
> mechanism to avoid performance penalty.
> 
> Thanks,
> Ronak
> 
> 
> 
