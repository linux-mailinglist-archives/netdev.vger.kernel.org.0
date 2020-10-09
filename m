Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9E7B2891D9
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390708AbgJITjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:39:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:28204 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731727AbgJITjG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:39:06 -0400
IronPort-SDR: MXtpdl7+j4kpmFLQv0lO54YKsEEd0IJpaQFsUfFoiD9eL5QmeYcEdty998WdhUYxhmhxWETk24
 YtENxgAxHhlw==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="144849614"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="144849614"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:39:05 -0700
IronPort-SDR: uMWCl/z89ewPADQDqDsvE8uTFL+LonNGnd79CWADG9OCdGywjmbO0qu5ER6L8tWeAIcomXKybm
 iE+SSrwwwBIg==
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="462298616"
Received: from dnittama-mobl.amr.corp.intel.com (HELO [10.212.225.198]) ([10.212.225.198])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 12:39:03 -0700
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     "Ertman, David M" <david.m.ertman@intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006172317.GN1874917@unreal>
 <DM6PR11MB2841976B8E89C980CCC29AD2DD0B0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <CAPcyv4hoS7ZT_PPrXqFBzEHBKL-O4x1jHtY8x9WWesCPA=2E0g@mail.gmail.com>
 <7dbbc51c-2cbd-a7c5-69de-76f190f1d130@linux.intel.com>
 <CAPcyv4h24md531OYTVkHqzK7Nb0dJc5PHkLDSDywh8mYgrXBjg@mail.gmail.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <a6eddd81-9746-aee7-3403-971c2b6286ef@linux.intel.com>
Date:   Fri, 9 Oct 2020 14:39:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h24md531OYTVkHqzK7Nb0dJc5PHkLDSDywh8mYgrXBjg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>>>>> +
>>>>>> +   ancildrv->driver.owner = owner;
>>>>>> +   ancildrv->driver.bus = &ancillary_bus_type;
>>>>>> +   ancildrv->driver.probe = ancillary_probe_driver;
>>>>>> +   ancildrv->driver.remove = ancillary_remove_driver;
>>>>>> +   ancildrv->driver.shutdown = ancillary_shutdown_driver;
>>>>>> +
>>>>>
>>>>> I think that this part is wrong, probe/remove/shutdown functions should
>>>>> come from ancillary_bus_type.
>>>>
>>>>   From checking other usage cases, this is the model that is used for probe, remove,
>>>> and shutdown in drivers.  Here is the example from Greybus.
>>>>
>>>> int greybus_register_driver(struct greybus_driver *driver, struct module *owner,
>>>>                               const char *mod_name)
>>>> {
>>>>           int retval;
>>>>
>>>>           if (greybus_disabled())
>>>>                   return -ENODEV;
>>>>
>>>>           driver->driver.bus = &greybus_bus_type;
>>>>           driver->driver.name = driver->name;
>>>>           driver->driver.probe = greybus_probe;
>>>>           driver->driver.remove = greybus_remove;
>>>>           driver->driver.owner = owner;
>>>>           driver->driver.mod_name = mod_name;
>>>>
>>>>
>>>>> You are overwriting private device_driver
>>>>> callbacks that makes impossible to make container_of of ancillary_driver
>>>>> to chain operations.
>>>>>
>>>>
>>>> I am sorry, you lost me here.  you cannot perform container_of on the callbacks
>>>> because they are pointers, but if you are referring to going from device_driver
>>>> to the auxiliary_driver, that is what happens in auxiliary_probe_driver in the
>>>> very beginning.
>>>>
>>>> static int auxiliary_probe_driver(struct device *dev)
>>>> 145 {
>>>> 146         struct auxiliary_driver *auxdrv = to_auxiliary_drv(dev->driver);
>>>> 147         struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
>>>>
>>>> Did I miss your meaning?
>>>
>>> I think you're misunderstanding the cases when the
>>> bus_type.{probe,remove} is used vs the driver.{probe,remove}
>>> callbacks. The bus_type callbacks are to implement a pattern where the
>>> 'probe' and 'remove' method are typed to the bus device type. For
>>> example 'struct pci_dev *' instead of raw 'struct device *'. See this
>>> conversion of dax bus as an example of going from raw 'struct device
>>> *' typed probe/remove to dax-device typed probe/remove:
>>>
>>> https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=75797273189d
>>
>> Thanks Dan for the reference, very useful. This doesn't look like a a
>> big change to implement, just wondering about the benefits and
>> drawbacks, if any? I am a bit confused here.
>>
>> First, was the initial pattern wrong as Leon asserted it? Such code
>> exists in multiple examples in the kernel and there's nothing preventing
>> the use of container_of that I can think of. Put differently, if this
>> code was wrong then there are other existing buses that need to be updated.
>>
>> Second, what additional functionality does this move from driver to
>> bus_type provide? The commit reference just states 'In preparation for
>> introducing seed devices the dax-bus core needs to be able to intercept
>> ->probe() and ->remove() operations", but that doesn't really help me
>> figure out what 'intercept' means. Would you mind elaborating?
>>
>> And last, the existing probe function does calls dev_pm_domain_attach():
>>
>> static int ancillary_probe_driver(struct device *dev)
>> {
>>          struct ancillary_driver *ancildrv = to_ancillary_drv(dev->driver);
>>          struct ancillary_device *ancildev = to_ancillary_dev(dev);
>>          int ret;
>>
>>          ret = dev_pm_domain_attach(dev, true);
>>
>> So the need to access the raw device still exists. Is this still legit
>> if the probe() is moved to the bus_type structure?
> 
> Sure, of course.
> 
>>
>> I have no objection to this change if it preserves the same
>> functionality and possibly extends it, just wanted to better understand
>> the reasons for the change and in which cases the bus probe() makes more
>> sense than a driver probe().
>>
>> Thanks for enlightening the rest of us!
> 
> tl;dr: The ops set by the device driver should never be overwritten by
> the bus, the bus can only wrap them in its own ops.
> 
> The reason to use the bus_type is because the bus type is the only
> agent that knows both how to convert a raw 'struct device *' to the
> bus's native type, and how to convert a raw 'struct device_driver *'
> to the bus's native driver type. The driver core does:
> 
>          if (dev->bus->probe) {
>                  ret = dev->bus->probe(dev);
>          } else if (drv->probe) {
>                  ret = drv->probe(dev);
>          }
> 
> ...so that the bus has the first priority for probing a device /
> wrapping the native driver ops. The bus ->probe, in addition to
> optionally performing some bus specific pre-work, lets the bus upcast
> the device to bus-native type.
> 
> The bus also knows the types of drivers that will be registered to it,
> so the bus can upcast the dev->driver to the native type.
> 
> So with bus_type based driver ops driver authors can do:
> 
> struct auxiliary_device_driver auxdrv {
>      .probe = fn(struct auxiliary_device *, <any aux bus custom probe arguments>)
> };
> 
> auxiliary_driver_register(&auxdrv); <-- the core code can hide bus details
> 
> Without bus_type the driver author would need to do:
> 
> struct auxiliary_device_driver auxdrv {
>      .drv = {
>          .probe = fn(struct device *), <-- no opportunity for bus
> specific probe args
>          .bus = &auxilary_bus_type, <-- unnecessary export to device drivers
>      },
> };
> 
> driver_register(&auxdrv.drv)

Thanks Dan, I appreciate the explanation.

I guess the misunderstanding on my side was that in practice the drivers 
only declare a probe at the auxiliary level:

struct auxiliary_device_driver auxdrv {
     .drv = {
         .name = "my driver"
         <<< .probe not set here.
     }
     .probe =  fn(struct auxiliary_device *, int id),	
}

It looks indeed cleaner with your suggestion. DaveE and I were talking 
about this moments ago and made the change, will be testing later today.

Again thanks for the write-up and have a nice week-end.


