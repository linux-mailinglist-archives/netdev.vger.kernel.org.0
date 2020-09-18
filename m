Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53D6527090B
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 01:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgIRXFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 19:05:09 -0400
Received: from mga06.intel.com ([134.134.136.31]:37642 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726009AbgIRXFJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 19:05:09 -0400
IronPort-SDR: KfinRy2E9cj1nMdvKn8uKEDXIHsweTgpdVyWqVpo8kVa+uRhBsE13dfrJYp4yRQ4igBIS+8gLL
 Qk1AKTQc8ykA==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="221615370"
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="221615370"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:05:02 -0700
IronPort-SDR: ubDUrOK2HBGXca3TyKKo/E9uWZDxmud16ijxnRVFcWW2a3hF8K40FCWTDaxdnkpzhW3E4MWeEB
 t8vOZ/zjPpBA==
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="484416816"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.100.226]) ([10.209.100.226])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:05:01 -0700
Subject: Re: [PATCH net-next v2 1/8] devlink: Introduce PCI SF port flavour
 and port attribute
To:     Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-2-parav@nvidia.com>
 <fcb55cc1-3be3-3eaa-68d5-28b4d112e291@intel.com>
 <BY5PR12MB4322441DBA23EB8F5B8D3B90DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1c5459bb-ca89-732e-3a23-78ef6d27869d@intel.com>
Date:   Fri, 18 Sep 2020 16:04:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB4322441DBA23EB8F5B8D3B90DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 8:54 PM, Parav Pandit wrote:
> 
> 
>> From: Jacob Keller <jacob.e.keller@intel.com>
>> Sent: Friday, September 18, 2020 12:00 AM
>>
>>
>> On 9/17/2020 10:20 AM, Parav Pandit wrote:
>>> A PCI sub-function (SF) represents a portion of the device similar to
>>> PCI VF.
>>>
>>> In an eswitch, PCI SF may have port which is normally represented
>>> using a representor netdevice.
>>> To have better visibility of eswitch port, its association with SF,
>>> and its representor netdevice, introduce a PCI SF port flavour.
>>>
>>> When devlink port flavour is PCI SF, fill up PCI SF attributes of the
>>> port.
>>>
>>> Extend port name creation using PCI PF and SF number scheme on best
>>> effort basis, so that vendor drivers can skip defining their own
>>> scheme.
>>
>> What does this mean? What's the scheme used? 
>>
> Scheme used is equivalent as what is used for PCI VF ports. pfNvfM.
> It is pfNsfM.
> Below example shows the representor netdevice name as 'eni10npf0sf44' built by systemd/udev using phys_port_name.
> 
>> Do drivers still have the option to make their own scheme? If so, why?
> Today we have two types of drivers (mlx5_core, netdevsim) which uses devlink core which creates the name.
> Or other drivers (bnxt, nfp) which doesn't yet migrated to use devlink infra for PCI PF, VF ports.
> Such drivers are phys_port_name and other ndos.
> It is not the role of this patch to block those drivers, but any new implementation doesn't need to hand code switch_id and phys_port_name related ndos for SF.
> For example, bnxt_vf_rep_get_phys_port_name().
> 


Ok, thanks for the explanation.

>> It's not obvious to me in this patch where the numbering scheme comes from. It
>> looks like it's still up to the caller to set the numbers.
>>
> Naming scheme for PCI PF and PCI VF port flavours already exist.
> Scheme is equivalent for PCI SF flavour.
> 
> I thought example is good enough to show that, but I will update commit message to describe this scheme to make it clear. pfNsfM.
>  

I think I just hadn't quite moved from "sf number" to "name of the
netdevice" and was thinking of scheme for how the sf number is selected,
which isn't really what the statement was about.

>>>>>> An example view of a PCI SF port.
>>>
>>> $ devlink port show netdevsim/netdevsim10/2
>>> netdevsim/netdevsim10/2: type eth netdev eni10npf0sf44 flavour pcisf
>> controller 0 pfnum 0 sfnum 44 external false splittable false
>>>   function:
>>>     hw_addr 00:00:00:00:00:00
>>>
>>> devlink port show netdevsim/netdevsim10/2 -jp {
>>>     "port": {
>>>         "netdevsim/netdevsim10/2": {
>>>             "type": "eth",
>>>             "netdev": "eni10npf0sf44",
>>>             "flavour": "pcisf",
>>>             "controller": 0,
>>>             "pfnum": 0,
>>>             "sfnum": 44,
>>>             "external": false,
>>>             "splittable": false,
>>>             "function": {
>>>                 "hw_addr": "00:00:00:00:00:00"
>>>             }
>>>         }
>>>     }
>>> }
>>>
>>> Signed-off-by: Parav Pandit <parav@nvidia.com>
>>> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
>>> ---
>>>  include/net/devlink.h        | 17 +++++++++++++++++
>>>  include/uapi/linux/devlink.h |  7 +++++++
>>>  net/core/devlink.c           | 37 ++++++++++++++++++++++++++++++++++++
>>>  3 files changed, 61 insertions(+)
>>>
> 
> 
>>>  static int __devlink_port_phys_port_name_get(struct devlink_port
>> *devlink_port,
>>>  					     char *name, size_t len)
>>>  {
>>> @@ -7855,6 +7889,9 @@ static int
>> __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
>>>  		n = snprintf(name, len, "pf%uvf%u",
>>>  			     attrs->pci_vf.pf, attrs->pci_vf.vf);
>>>  		break;
>>> +	case DEVLINK_PORT_FLAVOUR_PCI_SF:
>>> +		n = snprintf(name, len, "pf%usf%u", attrs->pci_sf.pf, attrs-
>>> pci_sf.sf);
>>> +		break;
>>>  	}
>>>
> This is where the naming scheme is done, like pcipf and pcivf port flavours.
> 
>>>  	if (n >= len)
>>>
