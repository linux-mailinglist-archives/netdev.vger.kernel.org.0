Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4CCB39D381
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 05:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbhFGDdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 23:33:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7123 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhFGDdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 23:33:37 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FyzNh30VnzYrks;
        Mon,  7 Jun 2021 11:28:36 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 11:31:24 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 7 Jun 2021
 11:31:24 +0800
Subject: Re: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
To:     Parav Pandit <parav@nvidia.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, moyufeng <moyufeng@huawei.com>,
        "Jakub Kicinski" <kuba@kernel.org>
References: <20210603111901.9888-1-parav@nvidia.com>
 <c50ebdd6-a388-4d39-4052-50b4966def2e@huawei.com>
 <PH0PR12MB548115AC5D6005781BAEC217DC399@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <a1b853ef-0c94-ba51-cf31-f1f194610204@huawei.com>
Date:   Mon, 7 Jun 2021 11:31:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <PH0PR12MB548115AC5D6005781BAEC217DC399@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/6 15:10, Parav Pandit wrote:
> Hi Yunsheng,
> 
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Sent: Friday, June 4, 2021 7:05 AM
>>
>> On 2021/6/3 19:19, Parav Pandit wrote:
>>> A user optionally provides the external controller number when user
>>> wants to create devlink port for the external controller.
>>
>> Hi, Parav
>>    I was planing to use controller id to solve the devlink instance representing
>> problem for multi-function which shares common resource in the same ASIC,
>> see [1].
>>
>> It seems the controller id used here is to differentiate the function used in
>> different host?
>>
> That’s correct. Controller holds one or more PCI functions (PF,VF,SF).

I am not sure I understand the exact usage of controller and why controller
id is in "devlink_port_*_attrs".

Let's consider a simplified case where there is two PF(supposing both have
VF enabled), and each PF has different controller and each PF corresponds
to a different physical port(Or it is about multi-host case multi PF may
sharing the same physical port?):
1. I suppose each PF has it's devlink instance for mlx case(I suppose each
   VF can not have it's own devlink instance for VF shares the same physical
   port with PF, right?).
2. each PF's devlink instance has three types of port, which is
   FLAVOUR_PHYSICAL, FLAVOUR_PCI_PF and FLAVOUR_PCI_VF(supposing I understand
   port flavour correctly).

If I understand above correctly, all ports in the same devlink instance should
have the same controller id, right? If yes, why not put the controller id in
the devlink instance?

> In your case if there is single devlink instance representing ASIC, it is better to have health reporters under this single instance.
> 
> Devlink parameters do not span multiple devlink instance.

Yes, that is what I try to do: shared status/parameters in devlink instance,
physical port specific status/parameters in devlink port instance.

> So if you need to control devlink instance parameters of each function byitself, you likely need devlink instance for each.
> And still continue to have ASIC wide health reporters under single instance that represents whole ASIC.

I do not think each function need a devlink instance if there is a
devlink instance representing a whole ASIC, using the devlink port
instance to represent the function seems enough?

>  
>> 1. https://lkml.org/lkml/2021/5/31/296

