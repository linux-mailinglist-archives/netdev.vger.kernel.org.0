Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D4639DA55
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 12:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhFGK6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 06:58:49 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7125 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbhFGK6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 06:58:48 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Fz9Gk0fbyzYsk5;
        Mon,  7 Jun 2021 18:54:06 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 18:56:54 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 7 Jun 2021
 18:56:54 +0800
Subject: Re: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
To:     Parav Pandit <parav@nvidia.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, <moyufeng@huawei.com>,
        <linuxarm@openeuler.org>
References: <20210603111901.9888-1-parav@nvidia.com>
 <c50ebdd6-a388-4d39-4052-50b4966def2e@huawei.com>
 <PH0PR12MB548115AC5D6005781BAEC217DC399@PH0PR12MB5481.namprd12.prod.outlook.com>
 <a1b853ef-0c94-ba51-cf31-f1f194610204@huawei.com>
 <PH0PR12MB5481A9B54850A62DF80E3EC1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <338a2463-eb3a-f642-a288-9ae45f721992@huawei.com>
Date:   Mon, 7 Jun 2021 18:56:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <PH0PR12MB5481A9B54850A62DF80E3EC1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/7 14:10, Parav Pandit wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Sent: Monday, June 7, 2021 9:01 AM
>>
>> On 2021/6/6 15:10, Parav Pandit wrote:
>>> Hi Yunsheng,
>>>
>>>> From: Yunsheng Lin <linyunsheng@huawei.com>
>>>> Sent: Friday, June 4, 2021 7:05 AM
>>>>
>>>> On 2021/6/3 19:19, Parav Pandit wrote:
>>>>> A user optionally provides the external controller number when user
>>>>> wants to create devlink port for the external controller.
>>>>
>>>> Hi, Parav
>>>>    I was planing to use controller id to solve the devlink instance
>>>> representing problem for multi-function which shares common resource
>>>> in the same ASIC, see [1].
>>>>
>>>> It seems the controller id used here is to differentiate the function
>>>> used in different host?
>>>>
>>> That’s correct. Controller holds one or more PCI functions (PF,VF,SF).
>>
>> I am not sure I understand the exact usage of controller and why controller id
>> is in "devlink_port_*_attrs".
>>
>> Let's consider a simplified case where there is two PF(supposing both have
>> VF enabled), and each PF has different controller and each PF corresponds to
>> a different physical port(Or it is about multi-host case multi PF may sharing
>> the same physical port?):
> Typically single host with two PFs have their own physical ports.
> Multi-host with two PFs, on each host they share respective physical ports.
> 
> Single host:
> Pf0.physical_port = p0
> Pf1.physical_port = p1.
> 
> Multi-host (two) host setup
> H1.pf0.phyical_port = p0.
> H1.pf1.phyical_port = p1.
> H2.pf0.phyical_port = p0.
> H2.pf1.phyical_port = p1.

Multi-host (two) host setup with separate physical port for each host:
H1.pf0.phyical_port = p0
H2.pf0.phyical_port = p1

Does above use case make sense for mlx, it seems a common case for
our internal use.

> 
>> 1. I suppose each PF has it's devlink instance for mlx case(I suppose each
>>    VF can not have it's own devlink instance for VF shares the same physical
>>    port with PF, right?).
> VF and SF ports are of flavour VIRTUAL.

Which devlink instance does the flavour VIRTUAL port instance for VF and SF is
registered to?
Does it mean VF has it's own devlink instance in VM when it is passed a VM,
and flavour VIRTUAL port instance for that VF is registered to that devlink
instance in the VM too？

Even in the same host as PF, the VF also has it's own devlink instance?

> 
>> 2. each PF's devlink instance has three types of port, which is
>>    FLAVOUR_PHYSICAL, FLAVOUR_PCI_PF and FLAVOUR_PCI_VF(supposing I
>> understand
>>    port flavour correctly).
>>
> FLAVOUR_PCI_{PF,VF,SF} belongs to eswitch (representor) side on switchdev device.

If devlink instance or eswitch is in DEVLINK_ESWITCH_MODE_LEGACY mode, the
FLAVOUR_PCI_{PF,VF,SF} port instance does not need to created?

> 
>> If I understand above correctly, all ports in the same devlink instance should
>> have the same controller id, right? If yes, why not put the controller id in the
>> devlink instance?
> Need not be. All PCI_{PF,VF,SF} can have controller id different for different controllers.

The point is that two VF from different PF may be in the different
host, all VF of a specific PF need to be in the same host, right?
otherwise it may break PCI enumeration process?

If yes, as PCI_{PF,VF,SF} belongs to eswitch (representor) side on
switchdev device(which means PCI_{PF,VF,SF} port instance is in the
same host, as the host corresponding to "controller_num=0" in diagram
[1]), so it seems all the PCI_{PF,VF,SF} of a specific PF should have
the same controller id, and using a controller id of the devlink instance
in "controller_num=0" in diagram [1] seems enough?

> Usually each multi-host is a different controller. 
> Refer to this diagram [1] and detailed description.

devlink instance does not exist in the host corresponding to
"controller_num=1" in diagram [1]?
Or devlink instance does exist in the host corresponding to
"controller_num=1", but the mode of that devlink instance is
DEVLINK_ESWITCH_MODE_LEGACY in diagram [1]?

Also, eswitch mode can only be set on the devlink instance corresponding
to PF, but not for VF/SF(supposing that VF/SF could have it's own devlink
instance too), right?

> 
>>
>>> In your case if there is single devlink instance representing ASIC, it is better
>> to have health reporters under this single instance.
>>>
>>> Devlink parameters do not span multiple devlink instance.
>>
>> Yes, that is what I try to do: shared status/parameters in devlink instance,
>> physical port specific status/parameters in devlink port instance.
>>
>>> So if you need to control devlink instance parameters of each function
>> byitself, you likely need devlink instance for each.
>>> And still continue to have ASIC wide health reporters under single instance
>> that represents whole ASIC.
>>
>> I do not think each function need a devlink instance if there is a devlink
>> instance representing a whole ASIC, using the devlink port instance to
>> represent the function seems enough?
> 'devlink port function's is equivalent of hypervisor/nicvisor entity controlled by the network/sysadmin.
> While devlink instance of a given PF,VF,SF is managed by the user of such function itself.

'devlink port function' means "struct devlink_port", right?
It seems 'devlink port function' in the host is representing
a VF when devlink instance of that VF is in the VM?

> For example when a VF is mapped to a VM, devlink instance of this VF resides in the VM managed by the guest VM.

Does the user in VM really care about devlink info or configuration
when network/sysadmin has configured the VF through 'devlink port function'
in the host?
which devlink info or configuration does user need to query or configure
in a VM?

> 
> Before this VF is given to VM, usually hypervisor/nicvisor admin programs this function (such as mac address) explained in [3].
> So that a given VM always gets the same mac address regardless of which VF {a or b).
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/devlink/devlink-port.rst?h=v5.13-rc5#n72
> [2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/devlink/devlink-port.rst?h=v5.13-rc5#n60
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/devlink/devlink-port.rst?h=v5.13-rc5#n110
> 
>>
>>>
>>>> 1. https://lkml.org/lkml/2021/5/31/296
> 

