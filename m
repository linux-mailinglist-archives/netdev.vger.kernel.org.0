Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D7922875E
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730108AbgGURbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:31:33 -0400
Received: from mga04.intel.com ([192.55.52.120]:53160 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729207AbgGURbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:31:32 -0400
IronPort-SDR: kAijL58LnI09lSEqJAo0vGttmef4LBIGbXazn1QITFOe1sDp9jnIKdaFlrqmlYeT0Dn00RW+G7
 CzbF7THe66qw==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="147691050"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="147691050"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 10:31:30 -0700
IronPort-SDR: GmkwgW4nS/72k0Pqcj8Xa6ETGw0MI/ukd2jKPD8GMtcxvKN8VulTnTMvAQSZgD0fLmtC2Ok9U3
 EPnPTc/WQbIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="270500070"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.252.139.199]) ([10.252.139.199])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jul 2020 10:31:29 -0700
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
To:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Tom Herbert <tom@herbertland.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-7-jacob.e.keller@intel.com>
 <20200720100953.GB2235@nanopsycho>
 <20200720085159.57479106@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200721135356.GB2205@nanopsycho>
 <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <eb874428-51ca-aaa3-9e01-c55969749348@intel.com>
Date:   Tue, 21 Jul 2020 10:31:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200721100406.67c17ce9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/2020 10:04 AM, Jakub Kicinski wrote:
> On Tue, 21 Jul 2020 15:53:56 +0200 Jiri Pirko wrote:
>> Mon, Jul 20, 2020 at 05:51:59PM CEST, kubakici@wp.pl wrote:
>>> On Mon, 20 Jul 2020 12:09:53 +0200 Jiri Pirko wrote:  
>>>> This looks odd. You have a single image yet you somehow divide it
>>>> into "program" and "config" areas. We already have infra in place to
>>>> take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
>>>> You should have 2 components:
>>>> 1) "program"
>>>> 2) "config"
>>>>
>>>> Then it is up to the user what he decides to flash.  
>>>
>>> 99.9% of the time users want to flash "all". To achieve "don't flash
>>> config" with current infra users would have to flash each component   
>>
>> Well you can have multiple component what would overlap:
>> 1) "program" + "config" (default)
>> 2) "program"
>> 3) "config"
> 
> Say I have FW component and UNDI driver. Now I'll have 4 components?
> fw.prog, fw.config, undi.prog etc? Are those extra ones visible or just
> "implied"? If they are visible what version does the config have?
> 
> Also (3) - flashing config from one firmware version and program from
> another - makes a very limited amount of sense to me.
> 

Right, this is actually one of the potential problems I've been told
about: if the config doesn't match the firmware it's supposed to work,
but the "overwrite config" option is partially there to help have a way
out in case the config and firmware aren't in sync and something goes wrong.

>>> one by one and then omit the one(s) which is config (guessing which 
>>> one that is based on the name).
>>>
>>> Wouldn't this be quite inconvenient?  
>>
>> I see it as an extra knob that is actually somehow provides degradation
>> of components.
> 
> Hm. We have the exact opposite view on the matter. To me components
> currently correspond to separate fw/hw entities, that's a very clear
> meaning. PHY firmware, management FW, UNDI. Now we would add a
> completely orthogonal meaning to the same API. 
> 
> Why?
> 
> In the name of "field reuse"?
> 

Right. I understand that other hardware works differently and has all
config separated to separate distinct components, but I think it would
be needlessly confusing to have separate component names. Plus, as I
said in another thread: I can't really separate the two components when
I update. I have to send the combined block to firmware with the flag
indicating how it should do preservation/merging. So I can't really do
"just settings" anyways, meaning that it really would be two components
which overlap. Plus, I wouldn't really have a separate "info" display.

Ultimately it ends up feeling like a significant hack of the component
name if I go that route.

