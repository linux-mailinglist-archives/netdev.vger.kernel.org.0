Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 879642B6C19
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgKQRpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:45:51 -0500
Received: from mga18.intel.com ([134.134.136.126]:32618 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbgKQRpv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 12:45:51 -0500
IronPort-SDR: dJr+uNuVjn1GAg9rFErt8xc33C+0zFXvbadvEz/yoJ5WM6ugicyNANeq4BUpv41q01iwrTqgLG
 rK7F09dFXwGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9808"; a="158749050"
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="158749050"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 09:45:26 -0800
IronPort-SDR: l6ysCLhPGG2IDIKqt8qtpk7HzLcrB3FtwbCjQZGG96vvWYEcFUmJg5nuQtRHPZOMsl3PhqzWOd
 Pt97k+LA5kiA==
X-IronPort-AV: E=Sophos;i="5.77,486,1596524400"; 
   d="scan'208";a="330157289"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.255.231.91]) ([10.255.231.91])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2020 09:45:26 -0800
Subject: Re: devlink userspace process appears stuck (was: Re: [net-next]
 devlink: move request_firmware out of driver)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Shannon Nelson <snelson@pensando.io>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        Bin Luo <luobin9@huawei.com>
References: <20201113000142.3563690-1-jacob.e.keller@intel.com>
 <20201113131252.743c1226@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <01c79a25-3826-d0f3-8ea3-aa31e338dabe@intel.com>
 <6352e9d3-02af-721e-3a54-ef99a666be29@intel.com>
 <baf44b88-156f-7b34-5e8d-9fe3bc2e2c40@intel.com>
 <20201114201023.1b597c93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <7b14d689-8ca8-f65e-8c52-f6b4ef642938@intel.com>
Date:   Tue, 17 Nov 2020 09:45:22 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201114201023.1b597c93@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/14/2020 8:10 PM, Jakub Kicinski wrote:
> On Fri, 13 Nov 2020 14:51:36 -0800 Jacob Keller wrote:
>> On 11/13/2020 2:32 PM, Jacob Keller wrote:
>>>
>>>
>>> On 11/13/2020 1:34 PM, Jacob Keller wrote:  
>>>> Well, at least with ice, the experience is pretty bad. I tried out with
>>>> a garbage file name on one of my test systems. This was on a slightly
>>>> older kernel without this patch applied, and the device had a pending
>>>> update that had not yet been finalized with a reset:
>>>>
>>>> $ devlink dev flash pci/0000:af:00.0 file garbage_file_does_not_exist
>>>> Canceling previous pending update
>>>>
>>>>
>>>> The update looks like it got stuck, but actually it failed. Somehow the
>>>> extack error over the socket didn't get handled by the application very
>>>> well. Something buggy in the forked process probably.
>>>>
>>>> I do get this in the dmesg though:
>>>>
>>>> Nov 13 13:12:57 jekeller-stp-glorfindel kernel: ice 0000:af:00.0: Direct
>>>> firmware load for garbage_file_does_not_exist failed with error -2
>>>>  
>>>
>>> I think I figured out what is going on here, but I'm not sure what the
>>> best solution is.
>>>
>>> in userspace devlink.c:3410, the condition for exiting the while loop
>>> that monitors the flash update process is:
>>>
>>> (!ctx.flash_done || (ctx.not_first && !ctx.received_end))
>>>   
>>
>> FWIW changing this to
>>
>> (!ctx.flash_done && !ctx.received_end)
>>
>> works for this problem, but I suspect that the original condition
>> intended to try and catch the case where flash update has exited but we
>> haven't yet processed all of the status messages?
> 
> Yeah... I've only looked at this for 5 minutes, but it seems that ice
> should not send notifications outside of begin / end (in fact it could
> be nice to add an appropriate WARN_ON() in notify())...
> 

What about just moving begin/end outside of drivers entirely? These two
functions don't take any arguments from the drivers... Doing the calls
in the core stack would make it impossible for a driver to do the wrong
thing, and would make it easier to handle the error cleanup routine.

Will send a patch to that effect soon for further discussion.

Thanks,
Jake
