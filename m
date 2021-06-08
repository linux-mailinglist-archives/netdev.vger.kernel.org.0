Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0405A39ED10
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 05:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFHD3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 23:29:47 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3096 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhFHD3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 23:29:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FzbCp0076zWtGf;
        Tue,  8 Jun 2021 11:23:01 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 11:27:52 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 8 Jun 2021
 11:27:52 +0800
Subject: Re: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
To:     Parav Pandit <parav@nvidia.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <20210603111901.9888-1-parav@nvidia.com>
 <c50ebdd6-a388-4d39-4052-50b4966def2e@huawei.com>
 <PH0PR12MB548115AC5D6005781BAEC217DC399@PH0PR12MB5481.namprd12.prod.outlook.com>
 <a1b853ef-0c94-ba51-cf31-f1f194610204@huawei.com>
 <PH0PR12MB5481A9B54850A62DF80E3EC1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
 <338a2463-eb3a-f642-a288-9ae45f721992@huawei.com>
 <PH0PR12MB5481FB8528A90E34FA3578C1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <8c3e48ce-f5ed-d35d-4f5e-1b572f251bd1@huawei.com>
Date:   Tue, 8 Jun 2021 11:27:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <PH0PR12MB5481FB8528A90E34FA3578C1DC389@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/7 19:12, Parav Pandit wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Sent: Monday, June 7, 2021 4:27 PM
>>

[..]

>>>
>>>> 2. each PF's devlink instance has three types of port, which is
>>>>    FLAVOUR_PHYSICAL, FLAVOUR_PCI_PF and
>> FLAVOUR_PCI_VF(supposing I
>>>> understand
>>>>    port flavour correctly).
>>>>
>>> FLAVOUR_PCI_{PF,VF,SF} belongs to eswitch (representor) side on
>> switchdev device.
>>
>> If devlink instance or eswitch is in DEVLINK_ESWITCH_MODE_LEGACY mode,
>> the FLAVOUR_PCI_{PF,VF,SF} port instance does not need to created?
> No. in eswitch legacy, there are no representor netdevice or devlink ports.

It seems each devlink port instance corresponds to a netdevice.
More specificly, the devlink instance is created in the
struct pci_driver' probe function of a pci function, a devlink
port instance is created and registered to that devlink instance
when a netdev of that pci function is created?

As in diagram [1], the devlink port instance(flavour FLAVOUR_PHYSICAL)
for ctrl-0-pf0 is created when the netdev of ctrl-0-pf0 is created in
the host of smartNIC, the devlink port instance(flavour FLAVOUR_VIRTUAL)
for ctrl-0-pf0vfN is created when the netdev of ctrl-0-pf0vfN is created
in the host of smartNIC, right?

When eswitch mode is set to DEVLINK_ESWITCH_MODE_SWITCHDEV, the representor
netdev for PF/VF in "controller_num=1" is created in the host of smartNIC,
so is the devlink port instance(FLAVOUR_PCI_{PF,VF,SF}) corresponding to that
representor netdev just created in the host of smartNIC? More specificly,
devlink port instance(flavour FLAVOUR_PCI_PF) for ctrl-1-pf0 and devlink port
instance (flavour FLAVOUR_PCI_VF)for ctrl-1-pf0vfN?

When "controller_num=1" is plugged to a server, the server host creates
devlink instance and devlink port instance in the host of server as
similar as the ctrl-0-pf0 and ctrl-0-pf0vfN in the host of smartNIC?

> 
>>
>>>
>>>> If I understand above correctly, all ports in the same devlink
>>>> instance should have the same controller id, right? If yes, why not
>>>> put the controller id in the devlink instance?
>>> Need not be. All PCI_{PF,VF,SF} can have controller id different for
>> different controllers.
>>
>> The point is that two VF from different PF may be in the different host, all VF
>> of a specific PF need to be in the same host, right?
>> otherwise it may break PCI enumeration process?
>>
> Sure. VFs belong to PF, PF belong to controller, controller is plugged into a host root complex.
> 
>> If yes, as PCI_{PF,VF,SF} belongs to eswitch (representor) side on switchdev
>> device(which means PCI_{PF,VF,SF} port instance is in the same host, as the
>> host corresponding to "controller_num=0" in diagram [1]), so it seems all the
>> PCI_{PF,VF,SF} of a specific PF should have the same controller id, 
> Yes.
> 
>> and using
>> a controller id of the devlink instance in "controller_num=0" in diagram [1]
>> seems enough?
> Yes.
> 
>>
>>> Usually each multi-host is a different controller.
>>> Refer to this diagram [1] and detailed description.
>>
>> devlink instance does not exist in the host corresponding to
>> "controller_num=1" in diagram [1]?
> Devlink instance do exist for controller=1 related PCI PF,VF,SF devices when those functions are plugged in the host.

> 
>> Or devlink instance does exist in the host corresponding to
>> "controller_num=1", but the mode of that devlink instance is
>> DEVLINK_ESWITCH_MODE_LEGACY in diagram [1]?
> As you can see that eswitch is located only on controller=0.
> This eswitch is serving PF, VF, SFs of controller=1 + controlloler=0 as well.

How do we decide where eswitch is located? through some fw/hw
configuration?

It seems if the eswitch is enabled on "controller=1", that is
a nested eswitch too, which you mentioned below?

>>
>> Also, eswitch mode can only be set on the devlink instance corresponding to
>> PF, but not for VF/SF(supposing that VF/SF could have it's own devlink
>> instance too), right?
> Yes. Eswitch can be located on the VF too. Mlx5 driver doesn't have it yet on VF.
> This may be some nested eswitch in future. I do not know when.
> 
>> by the network/sysadmin.
>>> While devlink instance of a given PF,VF,SF is managed by the user of such
>> function itself.
>>
>> 'devlink port function' means "struct devlink_port", right?
> 'function' is the object managing the function connected on the otherside of this port.
> This includes its hw_addr, rate, state, operational state.

Does "other side of this port" means the pci function that is most
likely have been passed through to a VM?

"devlink port" without the "function" represents the representor
netdev on the host where eswitch is located?

> 
>> It seems 'devlink port function' in the host is representing a VF when devlink
>> instance of that VF is in the VM?
> Right.
>>
>>> For example when a VF is mapped to a VM, devlink instance of this VF
>> resides in the VM managed by the guest VM.
>>
>> Does the user in VM really care about devlink info or configuration when
>> network/sysadmin has configured the VF through 'devlink port function'
>> in the host?
> Yes. devlink instance offers many knobs in uniform way on PF, VF, SF.
> They are in use in mlx5 for devlink params, reload, net ns.

"net ns" refer to "net namespace", right?
I am not sure how devlink instance related to net namespace yet.
I thought devlink is not limited to networking, it can be used in
other pcie device other than ethernet device?

> 
>> which devlink info or configuration does user need to query or configure in a
>> VM?
> Usually not much.
> Few examples that mlx5 users do with devlink instance of VF in a VM are, devlink params, devlink reload, board info. Health reporters, health recovery to name few.
> 

