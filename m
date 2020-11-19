Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A05D52B892B
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgKSAwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:52:47 -0500
Received: from mga17.intel.com ([192.55.52.151]:10633 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgKSAwq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 19:52:46 -0500
IronPort-SDR: 8HPm4gs1JS7zBDa/oHD2uHpai8v8PUGt6f92AUPAhz7ZyAale4esKZ/noXA36O2GgUGIVm5QOG
 +hTSSWt5+96A==
X-IronPort-AV: E=McAfee;i="6000,8403,9809"; a="151059162"
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="151059162"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 16:52:46 -0800
IronPort-SDR: 6hesk7xiAj6OkjRYuKCQcLetqK8AF0kwZmDswV4EKUJlC9hJVOIPt3CSnM1X7MiAF0gX/vAPml
 fq8u4V6kTwaw==
X-IronPort-AV: E=Sophos;i="5.77,488,1596524400"; 
   d="scan'208";a="330729523"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.247.114]) ([10.212.247.114])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2020 16:52:44 -0800
Subject: Re: [PATCH net-next 03/13] devlink: Support add and delete devlink
 port
To:     Parav Pandit <parav@nvidia.com>, David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vu Pham <vuhuong@nvidia.com>
References: <20201112192424.2742-1-parav@nvidia.com>
 <20201112192424.2742-4-parav@nvidia.com>
 <e7b2b21f-b7d0-edd5-1af0-a52e2fc542ce@gmail.com>
 <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <f04da4a9-df6d-3002-ea10-12eaf2637331@intel.com>
Date:   Wed, 18 Nov 2020 16:52:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <BY5PR12MB43222AB94ED279AF9B710FF1DCE10@BY5PR12MB4322.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 9:02 AM, Parav Pandit wrote:
> 
>> From: David Ahern <dsahern@gmail.com>
>> Sent: Wednesday, November 18, 2020 9:51 PM
>>
>> On 11/12/20 12:24 PM, Parav Pandit wrote:
>>> Extended devlink interface for the user to add and delete port.
>>> Extend devlink to connect user requests to driver to add/delete such
>>> port in the device.
>>>
>>> When driver routines are invoked, devlink instance lock is not held.
>>> This enables driver to perform several devlink objects registration,
>>> unregistration such as (port, health reporter, resource etc) by using
>>> exising devlink APIs.
>>> This also helps to uniformly use the code for port unregistration
>>> during driver unload and during port deletion initiated by user.
>>>
>>> Examples of add, show and delete commands:
>>> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
>>>
>>> $ devlink port show
>>> pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical
>>> port 0 splittable false
>>>
>>> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
>>>
>>> $ devlink port show pci/0000:06:00.0/32768
>>> pci/0000:06:00.0/32768: type eth netdev eth0 flavour pcisf controller 0
>> pfnum 0 sfnum 88 external false splittable false
>>>   function:
>>>     hw_addr 00:00:00:00:88:88 state inactive opstate detached
>>>
>>
>> There has to be limits on the number of sub functions that can be created for
>> a device. How does a user find that limit?
> Yes, this came up internally, but didn't really converged.
> The devlink resource looked too verbose for an average or simple use cases.
> But it may be fine.
> The hurdle I faced with devlink resource is with defining the granularity.
> 
> For example one devlink instance deploys sub functions on multiple pci functions.
> So how to name them? Currently we have controller and PFs in port annotation.
> So resource name as 
> c0pf0_subfunctions -> for controller 0, pf 0 
> c1pf2_subfunctions -> for controller 1, pf 2
> 
> Couldn't convince my self to name it this way.

Yea, I think we need to extend the plumbing of resources to allow
specifying or assigning parent resources to a subfunction.

> 
> Below example looked simpler to use but plumbing doesn’t exist for it.
> 
> $ devlink resource show pci/0000:03:00.0
> pci/0000:03:00.0/1: name max_sfs count 256 controller 0 pf 0
> pci/0000:03:00.0/2: name max_sfs count 100 controller 1 pf 0
> pci/0000:03:00.0/3: name max_sfs count 64 controller 1 pf 1
> 
> $ devlink resource set pci/0000:03:00.0/1 max_sfs 100
> 
> Second option I was considering was use port params which doesn't sound so right as resource.
> 

I don't think port parameters make sense here. They only encapsulate
single name -> value pairs, and don't really help show the relationships
between the subfunction ports and the parent device.

>>
>> Also, seems like there are hardware constraint at play. e.g., can a user reduce
>> the number of queues used by the physical function to support more sub-
>> functions? If so how does a user programmatically learn about this limitation?
>> e.g., devlink could have support to show resource sizing and configure
>> constraints similar to what mlxsw has.
> Yes, need to figure out its naming. For mlx5 num queues doesn't have relation to subfunctions.
> But PCI resource has relation and this is something we want to do in future, as you said may be using devlink resource.
> 

I've been looking into queue management and being able to add and remove
queue groups and queues. I'm leaning towards building on top of devlink
resource for this.

Specifically I have been looking at picking up the work started by
Magnus last year, around creating interface for representing queues to
the stack better for AF_XDP, but it also has other possible uses.

I'd like to make sure it aligns with the ideas here for partitioning
resources. It seems like that should be best done at the devlink level,
where the main devlink instance knows about all the part limitations and
can then have new commands for allowing assignment of resources to ports.
