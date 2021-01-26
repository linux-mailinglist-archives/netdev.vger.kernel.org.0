Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A8E304DA9
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387624AbhAZXNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:13:21 -0500
Received: from mga12.intel.com ([192.55.52.136]:40976 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbhAZWI3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 17:08:29 -0500
IronPort-SDR: NAnPUhaiWxZ95zT7oKzW5e9CxNHSkksx9wrqFrIhGFtle25LxDYRBssDG16XSFZxsYSHda8HRT
 7nO6SjwoAXsw==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="159153059"
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="159153059"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 14:07:43 -0800
IronPort-SDR: JdBVuSuUm/XowqcsRNe8tNk+epVAjphlRAxgq9IK4LDUdGYce96lMMAESjmikJtr3EAimJYey2
 nhsLMoeQLX3A==
X-IronPort-AV: E=Sophos;i="5.79,377,1602572400"; 
   d="scan'208";a="388026878"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.209.75.167]) ([10.209.75.167])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2021 14:07:42 -0800
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
References: <20210122234827.1353-1-shiraz.saleem@intel.com>
 <20210122234827.1353-8-shiraz.saleem@intel.com>
 <20210124134551.GB5038@unreal> <20210125132834.GK4147@nvidia.com>
 <2072c76154cd4232b78392c650b2b2bf@intel.com>
 <5b3f609d-034a-826f-1e50-0a5f8ad8406e@intel.com>
 <20210126052914.GN579511@unreal>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <236bd48f-ad16-1502-3194-b3e48ca2de97@intel.com>
Date:   Tue, 26 Jan 2021 14:07:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210126052914.GN579511@unreal>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/25/2021 9:29 PM, Leon Romanovsky wrote:
> On Mon, Jan 25, 2021 at 05:01:40PM -0800, Jacob Keller wrote:
>>
>>
>> On 1/25/2021 4:39 PM, Saleem, Shiraz wrote:
>>>> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
>>>> implement private channel OPs
>>>>
>>>> On Sun, Jan 24, 2021 at 03:45:51PM +0200, Leon Romanovsky wrote:
>>>>> On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
>>>>>> From: Mustafa Ismail <mustafa.ismail@intel.com>
>>>>>>
>>>>>> Register irdma as an auxiliary driver which can attach to auxiliary
>>>>>> RDMA devices from Intel PCI netdev drivers i40e and ice. Implement
>>>>>> the private channel ops, add basic devlink support in the driver and
>>>>>> register net notifiers.
>>>>>
>>>>> Devlink part in "the RDMA client" is interesting thing.
>>>>>
>>>>> The idea behind auxiliary bus was that PCI logic will stay at one
>>>>> place and devlink considered as the tool to manage that.
>>>>
>>>> Yes, this doesn't seem right, I don't think these auxiliary bus objects should have
>>>> devlink instances, or at least someone from devlink land should approve of the
>>>> idea.
>>>>
>>>
>>> In our model, we have one auxdev (for RDMA) per PCI device function owned by netdev driver
>>> and one devlink instance per auxdev. Plus there is an Intel netdev driver for each HW generation.
>>> Moving the devlink logic to the PCI netdev driver would mean duplicating the same set of RDMA
>>> params in each Intel netdev driver. Additionally, plumbing RDMA specific params in the netdev
>>> driver sort of seems misplaced to me.
>>>
>>
>> I agree that plumbing these parameters at the PCI side in the devlink of
>> the parent device is weird. They don't seem to be parameters that the
>> parent driver cares about.
>>
>> Maybe there is another mechanism that makes more sense? To me it is a
>> bit like if we were plumbing netdev specific paramters into devlink
>> instead of trying to expose them through netdevice specific interfaces
>> like iproute2 or ethtool.
> 
> I'm far from being expert in devlink, but for me separation is following:
> 1. devlink - operates on physical device level, when PCI device already initialized.
> 2. ethtool - changes needed to be done on netdev layer.
> 3. ip - upper layer of the netdev
> 4. rdmatool - RDMA specific when IB device already exists.
> 
> And the ENABLE_ROCE/ENABLE_RDMA thing shouldn't be in the RDMA driver at
> all, because it is physical device property which once toggled will
> prohibit creation of respective aux device.
> 

Ok. I guess I hadn't looked quite as close at the specifics here. I
agree that ENABLE_RDMA should go in the PF devlink.

If there's any other sort of RDMA-specific configuration that ties to
the IB device, that should go somehow into rdmatool, rather than
devlink. And thus: I think I agree, we don't want the IB device or the
aux device to create a devlink instance.

> Thanks
> 
