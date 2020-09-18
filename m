Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF526F53F
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 07:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgIRFAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 01:00:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:13893 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgIRFAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 01:00:24 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Sep 2020 01:00:24 EDT
IronPort-SDR: hGLtLNqOC499k3S1WA8W1Q7JGvwoDTOVFN7cVg94ZMf6TU+pICvDVCE26BThL5b/8yRnb8lCzv
 tDGhbVkq6FkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="139867023"
X-IronPort-AV: E=Sophos;i="5.77,273,1596524400"; 
   d="scan'208";a="139867023"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 21:53:16 -0700
IronPort-SDR: YWzM4T0BwpUVPZk66aYfXAZurZPV9xGQgroCxYM4ZSIwYpiddtSr+TPux3kSZNwd798eF6uVmW
 5NEcAwPQUyow==
X-IronPort-AV: E=Sophos;i="5.77,273,1596524400"; 
   d="scan'208";a="484041576"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.209.9.140]) ([10.209.9.140])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 21:53:15 -0700
Subject: Re: [PATCH net-next v2 8/8] netdevsim: Add support for add and delete
 PCI SF port
To:     Parav Pandit <parav@nvidia.com>, David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>
References: <20200917081731.8363-8-parav@nvidia.com>
 <20200917172020.26484-1-parav@nvidia.com>
 <20200917172020.26484-9-parav@nvidia.com>
 <e14f216f-19d9-7b4a-39ff-94ea89cd36c0@gmail.com>
 <BY5PR12MB43222EEBBC3B008918B82B98DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <c95859c8-e9cf-d218-e186-4f5d570c1298@gmail.com>
 <BY5PR12MB43220D8961B4F676CBA65A55DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <0b11ae28-3868-ee9f-184a-8cb577f717fc@intel.com>
Date:   Thu, 17 Sep 2020 21:53:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43220D8961B4F676CBA65A55DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/17/2020 9:41 PM, Parav Pandit wrote:
> Hi David,
> 
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Friday, September 18, 2020 9:08 AM
>>
>> On 9/17/20 9:29 PM, Parav Pandit wrote:
>>>>> Examples:
>>>>>
>>>>> Create a PCI PF and PCI SF port.
>>>>> $ devlink port add netdevsim/netdevsim10/10 flavour pcipf pfnum 0 $
>>>>> devlink port add netdevsim/netdevsim10/11 flavour pcisf pfnum 0
>>>>> sfnum
>>>>> 44 $ devlink port show netdevsim/netdevsim10/11
>>>>> netdevsim/netdevsim10/11: type eth netdev eni10npf0sf44 flavour
>>>>> pcisf
>>>> controller 0 pfnum 0 sfnum 44 external true splittable false
>>>>>    function:
>>>>>      hw_addr 00:00:00:00:00:00 state inactive
>>>>>
>>>>> $ devlink port function set netdevsim/netdevsim10/11 hw_addr
>>>>> 00:11:22:33:44:55 state active
>>>>>
>>>>> $ devlink port show netdevsim/netdevsim10/11 -jp {
>>>>>      "port": {
>>>>>          "netdevsim/netdevsim10/11": {
>>>>>              "type": "eth",
>>>>>              "netdev": "eni10npf0sf44",
>>>>
>>>> I could be missing something, but it does not seem like this patch
>>>> creates the netdevice for the subfunction.
>>>>
>>> The sf port created here is the eswitch port with a valid switch id similar to PF
>> and physical port.
>>> So the netdev created is the representor netdevice.
>>> It is created uniformly for subfunction and pf port flavours.
>>
>> To be clear: If I run the devlink commands to create a sub-function, `ip link
>> show` should list a net_device that corresponds to the sub-function?
> 
> In this series only representor netdevice corresponds to sub-function will be visible in ip link show, i.e. eni10npf0sf44.

This should be OK if the eSwitch mode is changed to switchdev.
But i think it should be possible to create a subfunction even in legacy 
mode where representor netdev is not created.

> 
> Netdevsim is only simulating the eswitch side or control path at present for pf/vf/sf ports.
> So other end of this port (netdevice/rdma device/vdpa device) are not yet created.
> 
> Subfunction will be anchored on virtbus described in RFC [1], which is not yet in-kernel yet.
> Grep for "every SF a device is created on virtbus" to jump to this part of the long RFC.
> 
> [1] https://lore.kernel.org/netdev/20200519092258.GF4655@nanopsycho/
> 
