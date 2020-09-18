Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB0227090E
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 01:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbgIRXHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 19:07:00 -0400
Received: from mga12.intel.com ([192.55.52.136]:4180 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726119AbgIRXHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 19:07:00 -0400
IronPort-SDR: Tn/ogOVKD7rizHd6hPmhMQncNlHiSRQduk9fv3VM84lIJDOYtTrn2nxUXFDGqaRyxvRfmNVNpS
 lUPoxNqhdQrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9748"; a="139547633"
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="139547633"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:07:00 -0700
IronPort-SDR: jwYu9qi4o8T940LvHHvGvstayzrfsOAFq8WWOfDNr3Kx1wPjrEwE9tjwAdRnA7xnAFfi+gTJmg
 uKW4MLYTe3mA==
X-IronPort-AV: E=Sophos;i="5.77,276,1596524400"; 
   d="scan'208";a="484417444"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.100.226]) ([10.209.100.226])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2020 16:06:59 -0700
Subject: Re: [PATCH net-next v2 2/8] devlink: Support add and delete devlink
 port
To:     Parav Pandit <parav@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-3-parav@nvidia.com>
 <28cbe5b9-a39e-9299-8c9b-6cce63328f0f@intel.com>
 <BY5PR12MB43227952D5E596D50CD0D74DDC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <35296a46-e0c7-264d-b69b-a3a617ae2ba3@intel.com>
Date:   Fri, 18 Sep 2020 16:06:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43227952D5E596D50CD0D74DDC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 9:25 PM, Parav Pandit wrote:
>> From: Jacob Keller <jacob.e.keller@intel.com>
>> Sent: Friday, September 18, 2020 12:13 AM
>>
>>
>> On 9/17/2020 10:20 AM, Parav Pandit wrote:
>>> Extended devlink interface for the user to add and delete port.
>>> Extend devlink to connect user requests to driver to add/delete such
>>> port in the device.
>>>
>>> When driver routines are invoked, devlink instance lock is not held.
>>> This enables driver to perform several devlink objects registration,
>>> unregistration such as (port, health reporter, resource etc) by using
>>> exising devlink APIs.
>>> This also helps to uniformly used the code for port registration
>>> during driver unload and during port deletion initiated by user.
>>>
>>
>> Ok. Seems like a good goal to be able to share code uniformly between driver
>> load and new port creation.
>>
> Yes.
>  
>>> +static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb, struct
>>> +genl_info *info) {
>>> +	struct netlink_ext_ack *extack = info->extack;
>>> +	struct devlink_port_new_attrs new_attrs = {};
>>> +	struct devlink *devlink = info->user_ptr[0];
>>> +
>>> +	if (!info->attrs[DEVLINK_ATTR_PORT_FLAVOUR] ||
>>> +	    !info->attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
>>> +		NL_SET_ERR_MSG_MOD(extack, "Port flavour or PCI PF are not
>> specified");
>>> +		return -EINVAL;
>>> +	}
>>> +	new_attrs.flavour = nla_get_u16(info-
>>> attrs[DEVLINK_ATTR_PORT_FLAVOUR]);
>>> +	new_attrs.pfnum =
>>> +nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]);
>>> +
>>
>> Presuming that the device supports it, this could be used to allow creating other
>> types of ports bsides subfunctions?
>>
> This series is creating PCI PF and subfunction ports.
> Jiri's RFC [1] explained a possibility for VF representors to follow the similar scheme if device supports it.
>

Right, VFs was the most obvious point. The ability to create VFs without
needing to destroy all VFs and re-create them seems quite useful.

> I am not sure creating other port flavours are useful enough such as CPU, PHYSICAL etc.
> I do not have enough knowledge about use case for creating CPU ports, if at all it exists.
> Usually physical ports are linked to a card hardware on how many physical ports present on circuit.
> So I find it odd if a device support physical port creation, but again its my limited view at the moment.
>
Yea, I agree here too. I find that somewhat odd, but I suppose for
everything but PHYSICAL types it's not impossible.
