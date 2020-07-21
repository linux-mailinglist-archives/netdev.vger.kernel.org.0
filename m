Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCF2228751
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 19:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729207AbgGUR2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 13:28:09 -0400
Received: from mga12.intel.com ([192.55.52.136]:6114 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbgGUR2J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 13:28:09 -0400
IronPort-SDR: 4NcAA3Mss83VRdq/VbQ+WL7oq+ytIEe67BwqUZynUx4qefvBZwJHiGDM2hgpVb3KnBzrwSytyd
 MIbHZ3Go4scA==
X-IronPort-AV: E=McAfee;i="6000,8403,9689"; a="129758892"
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="129758892"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2020 10:28:08 -0700
IronPort-SDR: XCv2CEWXO3BcAdNK78xcQBL0f64ocT8DwwI2b9Pzp9UV8yv51wu7iynNhAa/cHsx+MjqkDtEe8
 NliWsqNgoU5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,379,1589266800"; 
   d="scan'208";a="270498927"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.252.139.199]) ([10.252.139.199])
  by fmsmga007.fm.intel.com with ESMTP; 21 Jul 2020 10:28:08 -0700
Subject: Re: [RFC PATCH net-next v2 6/6] devlink: add overwrite mode to flash
 update
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kubakici@wp.pl>, netdev@vger.kernel.org,
        Tom Herbert <tom@herbertland.com>,
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
 <078815e8-637c-10d0-b4ec-9485b1be5df0@intel.com>
 <20200721135626.GC2205@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <8c7a5ea2-fcc5-6f05-d9dc-abbf0ceddf6d@intel.com>
Date:   Tue, 21 Jul 2020 10:28:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200721135626.GC2205@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/21/2020 6:56 AM, Jiri Pirko wrote:
> Mon, Jul 20, 2020 at 08:52:58PM CEST, jacob.e.keller@intel.com wrote:
>>
>>
>> On 7/20/2020 8:51 AM, Jakub Kicinski wrote:
>>> On Mon, 20 Jul 2020 12:09:53 +0200 Jiri Pirko wrote:
>>>> This looks odd. You have a single image yet you somehow divide it
>>>> into "program" and "config" areas. We already have infra in place to
>>>> take care of this. See DEVLINK_ATTR_FLASH_UPDATE_COMPONENT.
>>>> You should have 2 components:
>>>> 1) "program"
>>>> 2) "config"
>>>>
>>
>> First off, unfortunately at least for ice, the "main" section of NVM
>> contains both the management firmware as well as config settings. I
>> don't really have a way to split it up.
> 
> You don't have to split it up. Just for component "x" you push binary
> "A" and flash part of it and for comonent "y" you push the same binary
> "A" and flash different part of it.
> 
> Consider the component as a "mask" in your case.
> 
> 

The driver itself doesn't really know what parts of the image are which.
I have to ask the firmware. And it doesn't have a "settings only" flag.
I have roughly equivalent to "binary only", "binary + settings" and
"binary + settings + vital fields"

Plus, this means that every update must be single-component and there's
no way to distinguish this when an update is supposed to be for all of
the components in the PLDM file.
