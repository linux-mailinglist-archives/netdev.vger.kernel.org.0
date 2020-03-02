Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79C0A1766A2
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgCBWOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:14:35 -0500
Received: from mga06.intel.com ([134.134.136.31]:33913 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgCBWOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 17:14:35 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 14:14:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="258116967"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2020 14:14:34 -0800
Subject: Re: [RFC PATCH v2 14/22] devlink: implement DEVLINK_CMD_REGION_NEW
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-15-jacob.e.keller@intel.com>
 <20200302174106.GC2168@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <49a5384c-32ed-4179-646f-4823fd63d99d@intel.com>
Date:   Mon, 2 Mar 2020 14:14:34 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302174106.GC2168@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/2020 9:41 AM, Jiri Pirko wrote:
> Sat, Feb 15, 2020 at 12:22:13AM CET, jacob.e.keller@intel.com wrote:
>> Implement support for the DEVLINK_CMD_REGION_NEW command for creating
>> snapshots. This new command parallels the existing
>> DEVLINK_CMD_REGION_DEL.
>>
>> In order for DEVLINK_CMD_REGION_NEW to work for a region, the new
>> ".snapshot" operation must be implemented in the region's ops structure.
>>
>> The desired snapshot id may be provided. If the requested id is already
>> in use, an error will be reported. If no id is provided one will be
>> selected in the same way as a triggered snapshot.
>>
>> In either case, the reference count for that id will be incremented
>> in the snapshot IDR.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>> .../networking/devlink/devlink-region.rst     | 12 +++-
>> include/net/devlink.h                         |  6 ++
>> net/core/devlink.c                            | 72 +++++++++++++++++++
>> 3 files changed, 88 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/networking/devlink/devlink-region.rst b/Documentation/networking/devlink/devlink-region.rst
>> index 1a7683e7acb2..a24faf2b6b7a 100644
>> --- a/Documentation/networking/devlink/devlink-region.rst
>> +++ b/Documentation/networking/devlink/devlink-region.rst
>> @@ -20,6 +20,11 @@ address regions that are otherwise inaccessible to the user.
>> Regions may also be used to provide an additional way to debug complex error
>> states, but see also :doc:`devlink-health`
>>
>> +Regions may optionally support capturing a snapshot on demand via the
>> +``DEVLINK_CMD_REGION_NEW`` netlink message. A driver wishing to allow
>> +requested snapshots must implement the ``.snapshot`` callback for the region
>> +in its ``devlink_region_ops`` structure.
>> +
>> example usage
>> -------------
>>
>> @@ -40,8 +45,11 @@ example usage
>>     # Delete a snapshot using:
>>     $ devlink region del pci/0000:00:05.0/cr-space snapshot 1
>>
>> -    # Trigger (request) a snapshot be taken:
>> -    $ devlink region trigger pci/0000:00:05.0/cr-space
> 
> Odd. It is actually "devlink region dump". There is no trigger.
> 

This appears to have happened as I was working on the original "trigger"
patches at the same time as the documentation refactor, and things must
have gotten squashed in.

I can send a separate patch to remove it with a clearer explanation.

Thanks,
Jake
