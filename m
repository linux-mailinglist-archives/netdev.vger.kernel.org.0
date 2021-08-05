Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CB03E1017
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 10:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbhHEIVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 04:21:09 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:51378 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhHEIVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 04:21:03 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 1758KfTc014180;
        Thu, 5 Aug 2021 03:20:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628151641;
        bh=4hCNiB7Ae6o+MkPVbyIYfkKVdhRoHdcAYaWmdgkvEyE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=hKatD/oLPwz+G59TDp9dWh7LWj0gtpA8n0hzVaYTzXYZEixe0mb3JRuIZ4RiEm7dw
         zvWHgkm7IAoVGc9vlt5lcjcvtZm8i+pjqncm5UVsUf8tVN4+o9HkuJWCJtHT9dWz77
         W4Kh41N1oioLspI2U18CCoJgw3S4CcWOEFpnTH1Q=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 1758Kf7P077622
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Aug 2021 03:20:41 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 03:20:40 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 03:20:40 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 1758KcME077146;
        Thu, 5 Aug 2021 03:20:39 -0500
Subject: Re: [PATCH net-next 1/4] ethtool: runtime-resume netdev parent before
 ethtool ioctl ops
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
 <cb44d295-5267-48a7-b7c7-e4bf5b884e7a@gmail.com>
 <b4744988-4463-6463-243a-354cd87c4ced@ti.com>
 <75bdf142-f5f4-9a98-bf85-ac2cbbf1179b@gmail.com>
 <5b401877-51a2-7a67-09b4-4227a82ce027@ti.com>
 <4d84eaea-a5be-9790-8884-a2555fabf507@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <ad83fe47-e9ef-73cb-06fa-765cd69f5a6d@ti.com>
Date:   Thu, 5 Aug 2021 11:20:37 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <4d84eaea-a5be-9790-8884-a2555fabf507@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/08/2021 22:33, Heiner Kallweit wrote:
> On 04.08.2021 10:43, Grygorii Strashko wrote:
>>
>>
>> On 04/08/2021 00:32, Heiner Kallweit wrote:
>>> On 03.08.2021 22:41, Grygorii Strashko wrote:
>>>>
>>>>
>>>> On 01/08/2021 13:36, Heiner Kallweit wrote:
>>>>> If a network device is runtime-suspended then:
>>>>> - network device may be flagged as detached and all ethtool ops (even if not
>>>>>      accessing the device) will fail because netif_device_present() returns
>>>>>      false
>>>>> - ethtool ops may fail because device is not accessible (e.g. because being
>>>>>      in D3 in case of a PCI device)
>>>>>
>>>>> It may not be desirable that userspace can't use even simple ethtool ops
>>>>> that not access the device if interface or link is down. To be more friendly
>>>>> to userspace let's ensure that device is runtime-resumed when executing the
>>>>> respective ethtool op in kernel.
>>>>>
>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>> ---
>>>>>     net/ethtool/ioctl.c | 18 +++++++++++++++---
>>>>>     1 file changed, 15 insertions(+), 3 deletions(-)
>>>>>
>>>>> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
>>>>> index baa5d1004..b7ff9abe7 100644
>>>>> --- a/net/ethtool/ioctl.c
>>>>> +++ b/net/ethtool/ioctl.c
>>>>> @@ -23,6 +23,7 @@
>>>>>     #include <linux/rtnetlink.h>
>>>>>     #include <linux/sched/signal.h>
>>>>>     #include <linux/net.h>
>>>>> +#include <linux/pm_runtime.h>
>>>>>     #include <net/devlink.h>
>>>>>     #include <net/xdp_sock_drv.h>
>>>>>     #include <net/flow_offload.h>
>>>>> @@ -2589,7 +2590,7 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
>>>>>         int rc;
>>>>>         netdev_features_t old_features;
>>>>>     -    if (!dev || !netif_device_present(dev))
>>>>> +    if (!dev)
>>>>>             return -ENODEV;
>>>>>           if (copy_from_user(&ethcmd, useraddr, sizeof(ethcmd)))
>>>>> @@ -2645,10 +2646,18 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
>>>>>                 return -EPERM;
>>>>>         }
>>>>>     +    if (dev->dev.parent)
>>>>> +        pm_runtime_get_sync(dev->dev.parent);
>>>>
>>>> the PM Runtime should allow to wake up parent when child is resumed if everything is configured properly.
>>>>
>>> Not sure if there's any case yet where the netdev-embedded device is power-managed.
>>> Typically only the parent (e.g. a PCI device) is.
>>>
>>>> rpm_resume()
>>>> ...
>>>>       if (!parent && dev->parent) {
>>>>    --> here
>>>>
>>> Currently we don't get that far because we will bail out here already:
>>>
>>> else if (dev->power.disable_depth > 0)
>>>          retval = -EACCES;
>>>
>>> If netdev-embedded device isn't power-managed then disable_depth is 1.
>>
>> Right. But if pm_runtime_enable() is added for ndev->dev then PM runtime will start working for it
>> and should handle parent properly - from my experience, every time any code need manipulate with "parent" or
>> smth. else to make PM runtime working it means smth. is wrong.
>>
>> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>> index f6197774048b..33b72b788aa2 100644
>> --- a/net/core/net-sysfs.c
>> +++ b/net/core/net-sysfs.c
>> @@ -1963,6 +1963,7 @@ int netdev_register_kobject(struct net_device *ndev)
>>          }
>>   
>>          pm_runtime_set_memalloc_noio(dev, true);
>> +       pm_runtime_enable(dev);
>>   
>>          return error;
>>   }
>>
>>
>>>
>>>> So, hence PM runtime calls are moved to from drivers to net_core wouldn't be more correct approach to
>>>> enable PM runtime for netdev->dev and lets PM runtime do the job?
>>>>
>>> Where would netdev->dev be runtime-resumed so that netif_device_present() passes?
>>
>> That's the biggest issues here. Some driver uses netif_device_detach() in PM runtime and, this way, introduces custom dependency
>> between Core device PM (runtime) sate and Net core, other driver does not do.
>> Does it means every driver with PM runtime now have to be updated to indicate it PM state to Net core with netif_device_detach()?
> 
> No, that's not needed.
> 
>> Why? Why return value from pm_runtime_get calls is not enough?
>>
>> Believe me it's terrible idea to introduce custom PM state dependency between PM runtime and Net core,
>> for example it took years to sync properly System wide suspend and PM runtime which are separate framworks.
>>
>> By the way netif_device_detach() during System Wide suspend is looks perfectly valid, because entering
>> System wide Suspend should prohibit any access to netdev at some stage. And that's what 99% of network drivers are doing
>> (actually I can find only ./realtek/r8169_main.c which abuse netif_device_detach() function and,
>> I assume, it is your case)
>>
> Actually I was inspired by the Intel drivers, see e.g. __igc_shutdown(). They also detach the
> netdevice on runtime suspend. One reason is that several core functions check for device
> presence before e.g. calling a ndo callback. Example: dev_set_mtu_ext()

right and also:
- netlink - which you've hacked already
- 8021q: vlan_dev_ioctl/vlan_dev_neigh_setup/vlan_add_rx_filter_info/vlan_kill_rx_filter_info


> Same applies for __dev_set_rx_mode(). Therefore I wondered whether cpsw_ndo_set_rx_mode()
> - that does not include runtime-resuming the device - may be called when device is
> runtime-suspended, e.g. if interface is up, but link is down.

CPSW doesn't manage PM runtime in link status handler, as it has only on/off state and off state can cause full
context loss restore of which is expensive and hard to implement. And for most of netdev drivers no aggressive PM runtime
is implemented exactly because of that (mac/vlan/fdb/mdb/...). Common patterns:

(a)
.probe
  -get
.remove
  -put

(b)
.probe
  -get
  -put
.open
  -get
.close
  -put
.protect places which may be called when netif is down

The CPSW follows (b) and so cpsw_ndo_set_rx_mode() can't be called when when device is
runtime-suspended.

I assume, some hw like PCI, can have more PM states and in some of them keep HW context intact.


> 
>>> Wouldn't we then need RPM ops for the parent (e.g. PCI) and for netdev->dev?
>>
>> No. as I know -  netdev->dev can be declared as pm_runtime_no_callbacks(&adap->dev);
>> I2C adapter might be a good example to check.
>>
>>> E.g. the parent runtime-resume can be triggered by a PCI PME, then it would
>>> have to resume netdev->dev.
>>>
>>>> But, to be honest, I'm not sure adding PM runtime manipulation to the net core is a good idea -
>>>
>>> The TI CPSW driver runtime-resumes the device in begin ethtool op and suspends
>>> it in complete. This pattern is used in more than one driver and may be worth
>>> being moved to the core.
>>
>> I'm not against code refactoring and optimization, but in my opinion it has to be done right from the beginning or
>> not done at all.
>>
>>>
>>>> at minimum it might be tricky and required very careful approach (especially in err path).
>>>> For example, even in this patch you do not check return value of pm_runtime_get_sync() and in
>>>> commit bd869245a3dc ("net: core: try to runtime-resume detached device in __dev_open") also actualy.
>>>
>>> The pm_runtime_get_sync() calls are attempts here. We don't want to bail out if a device
>>> doesn't support RPM.
>>
>> And if 'parent' is not supporting PM runtime - it, as i see, should be handled by PM runtime core properly.
>>
>> I agree that checking the return code could make sense, but then we would
>>> have to be careful which error codes we consider as failed.
>>
>> huh. you can't 'try' pm_runtime_get_sync() and then align on netif_device_present() :(
>>
>> might be, some how, it will work for r8169_main, but will not work for others.
>> - no checking pm_runtime_get_sync() err code will cause PM runtime 'usage_count' leak
> 
> No. pm_runtime_get_sync() always bumps the usage count, no matter whether it fails or not.


> This makes it easy to deal with this. The problem you describe exists with
> pm_runtime_resume_and_get(). That's why I wondered whether we should annotate this
> function as __must_check. See here:
> https://lore.kernel.org/linux-pm/CAJZ5v0gps0C2923VqM8876npvhcETsyN+ajAkBKX5kf49J0+Mg@mail.gmail.com/T/#t
> 
>> - no checking pm_runtime_get_sync() err may cause to continue( for TI CPSW for example) with
>>    device in undefined PM state ("disabled" or "half-enabled") and so crash later.
>>
> I'd say 95% of rpm callers don't check the return value. I'm not saying this is a good thing,
> but obviously it doesn't cause relevant harm.

this is completely wrong assumption as PM errors cause silent stuck, undefined behavior or dumps (sometimes delayed)
which is terribly hard to root cause.

yes. many drivers do not check, but over last few years more and more strict policies applied to avoid that and
in many case no checking return code - is red flag and patch reject.
Don't like that phrase ;), but "It doesn't mean that incorrect code has to be copy-pasted all over the places"

this is correct get pattern for get:
	ret = pm_runtime_get_sync(&pdev->dev);
	if (ret < 0) {
		pm_runtime_put_noidle(&pdev->dev);
		return ret;
	}

My strong opinion
  - PM runtime return code must be checked.
  - get rid of netif_device_detach() in r8169

by the way, have you tried below test with your driver (not sure how it works for you):

.rtl_open
  - pm_runtime_get_sync
  - pm_runtime_put_sync - usage_count == 0
.r8169_phylink_handler
  - pm_request_resume - why async? still usage_count == 0
.some ethtool request to go through dev_ethtool()
  - pm_runtime_get_sync
  - pm_runtime_put - async, usage_count == 0
    ^ would not it put r8169 in runtime-suspended state while link is still UP?
  

> 
>>
>>
>>>
>>>>
>>>>
>>>> The TI CPSW driver may also be placed in non reachable state when netdev is closed (and even lose context),
>>>> but we do not use netif_device_detach() (so netdev is accessible through netdev_ops/ethtool_ops),
>>>> but instead wake up device by runtime PM for allowed operations or just save requested configuration which
>>>> is applied at netdev->open() time then.
>>>> I feel that using netif_device_detach() in PM runtime sounds like a too heavy approach ;)
>>>>
>>> That's not a rare pattern when suspending or runtime-suspending to prevent different types
>>> of access to a not accessible device. But yes, it's relatively big hammer ..
>>
>> Again, netif_device_detach() seems correct for System wide suspend, but in my opinion - it's
>> not correct for PM runtime.
>>
>> Sry, with all do respect, first corresponding driver has to be fixed and not Net core hacked to support it.
>>
>> Further decisions is up to maintainers.
>>
>>
>>>
>>>> huh, see it's merged already, so...
>>>>
>>>>> +
>>>>> +    if (!netif_device_present(dev)) {
>>>>> +        rc = -ENODEV;
>>>>> +        goto out;
>>>>> +    }
>>>>> +
>>>>>         if (dev->ethtool_ops->begin) {
>>>>>             rc = dev->ethtool_ops->begin(dev);
>>>>> -        if (rc  < 0)
>>>>> -            return rc;
>>>>> +        if (rc < 0)
>>>>> +            goto out;
>>>>>         }
>>>>>         old_features = dev->features;
>>>>>     @@ -2867,6 +2876,9 @@ int dev_ethtool(struct net *net, struct ifreq *ifr)
>>>>>           if (old_features != dev->features)
>>>>>             netdev_features_change(dev);
>>>>> +out:
>>>>> +    if (dev->dev.parent)
>>>>> +        pm_runtime_put(dev->dev.parent);
>>>>>           return rc;
>>>>>     }
>>>>>
>>>>
>>>
>>
> 

-- 
Best regards,
grygorii
