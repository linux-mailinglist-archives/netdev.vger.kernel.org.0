Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A797304937
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387725AbhAZFah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:30:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:50872 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729396AbhAZBZS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 20:25:18 -0500
IronPort-SDR: oxgCSTlF8d6yRP9DtwPpM+cK9fNJ8RPtvNt1K3V+ErPC+GiT0p18ZiaINscKNS4dgF6xOW/x5h
 5u6nuMxdrutA==
X-IronPort-AV: E=McAfee;i="6000,8403,9875"; a="179911441"
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="179911441"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 17:01:44 -0800
IronPort-SDR: xtZkSNkt1CuBIENkrmeIaXUQ1CDJ19qajK1Nu62DxYCV9OeL81tG2gouzssm/kiWtmY1d21yM5
 wYgNgm/2ztPw==
X-IronPort-AV: E=Sophos;i="5.79,375,1602572400"; 
   d="scan'208";a="353271108"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.255.231.75]) ([10.255.231.75])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2021 17:01:43 -0800
Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
 implement private channel OPs
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     "dledford@redhat.com" <dledford@redhat.com>,
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
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <5b3f609d-034a-826f-1e50-0a5f8ad8406e@intel.com>
Date:   Mon, 25 Jan 2021 17:01:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <2072c76154cd4232b78392c650b2b2bf@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/25/2021 4:39 PM, Saleem, Shiraz wrote:
>> Subject: Re: [PATCH 07/22] RDMA/irdma: Register an auxiliary driver and
>> implement private channel OPs
>>
>> On Sun, Jan 24, 2021 at 03:45:51PM +0200, Leon Romanovsky wrote:
>>> On Fri, Jan 22, 2021 at 05:48:12PM -0600, Shiraz Saleem wrote:
>>>> From: Mustafa Ismail <mustafa.ismail@intel.com>
>>>>
>>>> Register irdma as an auxiliary driver which can attach to auxiliary
>>>> RDMA devices from Intel PCI netdev drivers i40e and ice. Implement
>>>> the private channel ops, add basic devlink support in the driver and
>>>> register net notifiers.
>>>
>>> Devlink part in "the RDMA client" is interesting thing.
>>>
>>> The idea behind auxiliary bus was that PCI logic will stay at one
>>> place and devlink considered as the tool to manage that.
>>
>> Yes, this doesn't seem right, I don't think these auxiliary bus objects should have
>> devlink instances, or at least someone from devlink land should approve of the
>> idea.
>>
> 
> In our model, we have one auxdev (for RDMA) per PCI device function owned by netdev driver
> and one devlink instance per auxdev. Plus there is an Intel netdev driver for each HW generation.
> Moving the devlink logic to the PCI netdev driver would mean duplicating the same set of RDMA
> params in each Intel netdev driver. Additionally, plumbing RDMA specific params in the netdev
> driver sort of seems misplaced to me.
> 

I agree that plumbing these parameters at the PCI side in the devlink of
the parent device is weird. They don't seem to be parameters that the
parent driver cares about.

Maybe there is another mechanism that makes more sense? To me it is a
bit like if we were plumbing netdev specific paramters into devlink
instead of trying to expose them through netdevice specific interfaces
like iproute2 or ethtool.
