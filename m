Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C5E2F6EBC
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730853AbhANW7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:59:19 -0500
Received: from mga06.intel.com ([134.134.136.31]:6328 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730794AbhANW7S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 17:59:18 -0500
IronPort-SDR: L1Ls6/pPnv36gA2B2QWENqTm/5iJo239ykmUKpaK8tnDP1oxG5SVmEX7XieMEsJ4MvFUEjq9SC
 ZCsyPxfzGfRQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="240003543"
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="240003543"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 14:58:34 -0800
IronPort-SDR: Wpw7auf9pE3rzzJbHERI3TM7OzqWak1M0x8+jtoy7AIR4PLsDVfqsHeeyNUYJH8C+GoWxqz/0g
 7nYTbZnoyQMw==
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="354072986"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.116.186]) ([10.254.116.186])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2021 14:58:33 -0800
Subject: Re: [patch net-next RFC 00/10] introduce line card support for
 modular switch
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, roopa@nvidia.com,
        mlxsw@nvidia.com
References: <20210113121222.733517-1-jiri@resnulli.us>
 <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <13348f01-2c68-c0a6-3bd8-a111fb0e565b@intel.com>
Date:   Thu, 14 Jan 2021 14:58:33 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210113182716.2b2aa8fa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/13/2021 6:27 PM, Jakub Kicinski wrote:
> On Wed, 13 Jan 2021 13:12:12 +0100 Jiri Pirko wrote:
>> This patchset introduces support for modular switch systems.
>> NVIDIA Mellanox SN4800 is an example of such. It contains 8 slots
>> to accomodate line cards. Available line cards include:
>> 16X 100GbE (QSFP28)
>> 8X 200GbE (QSFP56)
>> 4X 400GbE (QSFP-DD)
>>
>> Similar to split cabels, it is essencial for the correctness of
>> configuration and funcionality to treat the line card entities
>> in the same way, no matter the line card is inserted or not.
>> Meaning, the netdevice of a line card port cannot just disappear
>> when line card is removed. Also, system admin needs to be able
>> to apply configuration on netdevices belonging to line card port
>> even before the linecard gets inserted.
> 
> I don't understand why that would be. Please provide reasoning, 
> e.g. what the FW/HW limitation is.
> 

I agree, I wouldn't imagine that plugging or unplugging line cards is
expected to be done on a regular basis?

>> To resolve this, a concept of "provisioning" is introduced.
>> The user may "provision" certain slot with a line card type.
>> Driver then creates all instances (devlink ports, netdevices, etc)
>> related to this line card type. The carrier of netdevices stays down.
>> Once the line card is inserted and activated, the carrier of the
>> related netdevices goes up.
> 
> Dunno what "line card" means for Mellovidia but I don't think 
> the analogy of port splitting works. To my knowledge traditional
> line cards often carry processors w/ full MACs etc. so I'd say 
> plugging in a line card is much more like plugging in a new NIC.
> 

Even if they didn't...

> There is no way to tell a breakout cable from normal one, so the
> system has no chance to magically configure itself. Besides SFP
> is just plugging a cable, not a module of the system.. 
> 
If you're able to tell what is plugged in, why would we want to force
user to provision ahead of time? Wouldn't it make more sense to just
instantiate them as the card is plugged in? I guess it might be useful
to allow programming the netdevices before the cable is actually
inserted... I guess I don't see why that is valuable.

It would be sort of like if you provision a PCI slot before a device is
plugged into it..
