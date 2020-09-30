Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020BA27F419
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbgI3VUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:20:50 -0400
Received: from mga18.intel.com ([134.134.136.126]:25445 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725823AbgI3VUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:20:50 -0400
IronPort-SDR: /N9u0K86ywNMNKuWyw/BrjKbnPHfkBGTbpStJ/UHAQsMpYVOt/yx8uIgN/lvu05NWz809kWFoO
 +9q5tX1tCIig==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="150335196"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="150335196"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 14:20:47 -0700
IronPort-SDR: 79QCatnlA9OP1iXZ4zLCnJj4HU3ZoOl41Ec4E4pbagn3fR8tyoys8fz/msA8s7UN59Ep6PqoOQ
 ouzjuAEwGcMg==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="457814647"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.35.112]) ([10.212.35.112])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 14:20:46 -0700
Subject: Re: [iproute2-next v1] devlink: display elapsed time during flash
 update
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>
References: <20200929215651.3538844-1-jacob.e.keller@intel.com>
 <df1ad702-ab31-e027-e711-46d09f8fa095@pensando.io>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <1f8a0423-97ef-29c4-4d77-4b91d23a9e7c@intel.com>
Date:   Wed, 30 Sep 2020 14:20:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <df1ad702-ab31-e027-e711-46d09f8fa095@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/29/2020 3:44 PM, Shannon Nelson wrote:
> On 9/29/20 2:56 PM, Jacob Keller wrote:
>> For some devices, updating the flash can take significant time during
>> operations where no status can meaningfully be reported. This can be
>> somewhat confusing to a user who sees devlink appear to hang on the
>> terminal waiting for the device to update.
>>
>> Recent changes to the kernel interface allow such long running commands
>> to provide a timeout value indicating some upper bound on how long the
>> relevant action could take.
>>
>> Provide a ticking counter of the time elapsed since the previous status
>> message in order to make it clear that the program is not simply stuck.
>>
>> Display this message whenever the status message from the kernel
>> indicates a timeout value. Additionally also display the message if
>> we've received no status for more than couple of seconds. If we elapse
>> more than the timeout provided by the status message, replace the
>> timeout display with "timeout reached".
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>>
> 
> Thanks, Jake.  In general this seems to work pretty well.  One thing, 
> tho'...
> 
> Our fw download is slow (I won't go into the reasons here) so we're 
> clicking through the Download x% over maybe 100+ seconds.  Since we send 
> an update every 3% or so, we end up seeing the ( 0m 3s ) pop up and stay 
> there the whole time, looking a little odd:
> 
>      ./iproute2-5.8.0/devlink/devlink dev flash pci/0000:b5:00.0 file 
> ionic/dsc_fw_1.15.0-150.tar
>      Preparing to flash
>      Downloading  37% ( 0m 3s )
>    ...
>      Downloading  59% ( 0m 3s )
>    ...
>      Downloading  83% ( 0m 3s )
> 
> And at the end we see:
> 
>      Preparing to flash
>      Downloading 100% ( 0m 3s )
>      Installing ( 0m 43s : 25m 0s )
>      Selecting ( 0m 5s : 0m 30s )
>      Flash done
> 
> I can have the driver do updates more often in order to stay under the 3 
> second limit and hide this, but it looks a bit funky, especially at the 
> end where I know that 100% took a lot longer than 3 seconds.
> 

I think we have two options here:

1) never display an elapsed time when we have done/total information

or

2) treat elapsed time as a measure since the last status message
changed, refactoring this so that it shows the total time spent on that
status message.

Thoughts on this? I think I'm leaning towards (2) at the moment myself.
This might lead to displaying the timing info on many % calculations
though... Hmm

> sln
> 
> 
