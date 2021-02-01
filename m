Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE0330B320
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 00:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhBAXJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 18:09:45 -0500
Received: from mga05.intel.com ([192.55.52.43]:37989 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229476AbhBAXJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 18:09:43 -0500
IronPort-SDR: vtZ899WqhXxKULEKhjVn5sBZqjGrasdNtSiksOw7entBhbWWdw8mdQ8vRBjXLa3deeQTbVGM5k
 9JSikdUAYmKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="265598942"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="265598942"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:03 -0800
IronPort-SDR: gjEiflDa9ZgnYHgw3wTBlJMlsw1K0NUmgCFsoiJv4ILAppzPam/Ojl9RZt2a99HwV++sxPv91T
 jIjSb3w5oZsg==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="412939345"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.75.41]) ([10.212.75.41])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 15:09:02 -0800
Subject: Re: [PATCH net-next 10/15] ice: display some stored NVM versions via
 devlink info
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
References: <20210129004332.3004826-1-anthony.l.nguyen@intel.com>
 <20210129004332.3004826-11-anthony.l.nguyen@intel.com>
 <20210129223754.0376285e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <977ae41c-c547-bc44-9857-24c88c228412@intel.com>
 <20210201143404.7e4a093b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <d1d73560-63d8-846e-e121-00daef7b2c94@intel.com>
Date:   Mon, 1 Feb 2021 15:09:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210201143404.7e4a093b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/1/2021 2:34 PM, Jakub Kicinski wrote:
> On Mon, 1 Feb 2021 13:40:27 -0800 Jacob Keller wrote:
>> On 1/29/2021 10:37 PM, Jakub Kicinski wrote:
>>> On Thu, 28 Jan 2021 16:43:27 -0800 Tony Nguyen wrote:  
>>>> When reporting the versions via devlink info, first read the device
>>>> capabilities. If there is a pending flash update, use this new function
>>>> to extract the inactive flash versions. Add the stored fields to the
>>>> flash version map structure so that they will be displayed when
>>>> available.  
>>>
>>> Why only report them when there is an update pending?
>>>
>>> The expectation was that you'd always report what you can and user 
>>> can tell the update is pending by comparing the fields.
>>
>> If there is no pending update, what is the expected behavior? We report
>> the currently active image version as both stored and running?
>>
>> In our case, the device has 2 copies of each of the 3 modules: NVM,
>> Netlist, and UNDI/OptionROM.
>>
>> For each module, the device has a bit that indicates whether it will
>> boot from the first or second bank of the image. When we update,
>> whichever bank is not active is erased, and then populated with the new
>> image contents. The bit indicating which bank to load is flipped. Once
>> the device is rebooted (EMP reset), then the new bank is loaded, and the
>> firmware performs some onetime initialization.
>>
>> So for us, in theory we have up to 2 versions within the device for each
>> bank: the version in the currently active bank, and a version in the
>> inactive bank. In the inactive case, it may or may not be valid
>> depending on if that banks contents were ever a valid image. On a fresh
>> card, this might be empty or filled with garbage.
>>
>> Presumably we do not want to report that we have "stored" a version
>> which is not going to be activated next time that we boot?
>>
>> The documentation indicated that stored should be the version which
>> *will* be activated.
>>
>> If I just blindly always reported what was inactive, then the following
>> scenarios exist:
>>
>> # Brand new card:
>>
>> running:
>>   fw.bundle_id: Version
>> stored
>>   fw.bundle_id: <zero or garbage>
>>
>> # Do an update:
>>
>> running:
>>   fw.bundle_id: Version
>> stored
>>   fw.bundle_id: NewVersion
>>
>> # reset/reboot
>>
>> running:
>>   fw.bundle_id: NewVersion
>> stored:
>>   fw.bundle_id: Version
>>
>>
>> I could get behind that if we do not have a pending update we report the
>> stored value as the same as the running value (i.e. from the active
>> bank), where as if we have a pending update that will be triggered we
>> would report the inactive bank. I didn't see the value in that before
>> because it seemed like "if you don't have a pending update, you don't
>> have a stored value, so just report the active version in the running
>> category")
>>
>> It's also plausibly useful to report the stored but not pending value in
>> some cases, but I really don't want to report zeros or garbage data on
>> accident. This would almost certainly lead to confusing support
>> conversations.
> 
> Very good points. Please see the documentation for example workflow:
> 
> https://www.kernel.org/doc/html/latest/networking/devlink/devlink-flash.html#firmware-version-management
> 
> The FW update agent should be able to rely on 'stored' for checking if
> flash update is needed.
> 
> If the FW update is not pending just report the same values as running.
> You should not report old version after 2 flashings (3rd output in your
> example) - that'd confuse the flow - as you said - the stored versions
> would not be what will get activated.
> 

Sure, ok. I can add that when implementing this in the v2 submission
(along with extracting the security revision patches to a separate series).

Thanks,
Jake
