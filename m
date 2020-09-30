Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B8627F453
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgI3Vn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:43:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:30825 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgI3Vn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 17:43:27 -0400
IronPort-SDR: eHkylh3V/cVIZKJduYez4B1XVL9KTBgBeHHYt2px9bRQBCFb+JosOjQ7H7BR2cN0uImZB4+0l5
 ABfMDdnNq9Lw==
X-IronPort-AV: E=McAfee;i="6000,8403,9760"; a="180713514"
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="180713514"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 14:43:24 -0700
IronPort-SDR: eYudss1prjY/reT+PbLCsNhEGDvAW5/yqExThupUY6Hks5TWkChM9Z3OAk8Zv6WU+iac88+W+A
 a5SiLAydAidA==
X-IronPort-AV: E=Sophos;i="5.77,322,1596524400"; 
   d="scan'208";a="457824315"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.35.112]) ([10.212.35.112])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2020 14:43:23 -0700
Subject: Re: [iproute2-next v1] devlink: display elapsed time during flash
 update
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org
References: <20200929215651.3538844-1-jacob.e.keller@intel.com>
 <df1ad702-ab31-e027-e711-46d09f8fa095@pensando.io>
 <1f8a0423-97ef-29c4-4d77-4b91d23a9e7c@intel.com>
 <20200930143659.7fee35d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <7a9ff898-bdae-9dab-12a9-30d825b6b67d@intel.com>
Date:   Wed, 30 Sep 2020 14:43:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930143659.7fee35d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/2020 2:36 PM, Jakub Kicinski wrote:
> On Wed, 30 Sep 2020 14:20:43 -0700 Jacob Keller wrote:
>>> Thanks, Jake.  In general this seems to work pretty well.  One thing, 
>>> tho'...
>>>
>>> Our fw download is slow (I won't go into the reasons here) so we're 
>>> clicking through the Download x% over maybe 100+ seconds.  Since we send 
>>> an update every 3% or so, we end up seeing the ( 0m 3s ) pop up and stay 
>>> there the whole time, looking a little odd:
>>>
>>>      ./iproute2-5.8.0/devlink/devlink dev flash pci/0000:b5:00.0 file 
>>> ionic/dsc_fw_1.15.0-150.tar
>>>      Preparing to flash
>>>      Downloading  37% ( 0m 3s )
>>>    ...
>>>      Downloading  59% ( 0m 3s )
>>>    ...
>>>      Downloading  83% ( 0m 3s )
> 
> I'm not sure how to interpret this - are you saying that the timer
> doesn't tick up or that the FW happens to complete the operation right
> around the 3sec mark?
> 


The elapsed time is calculated from the last status message we receive.
In Shannon's case, the done/total % status messages come approximately
slow enough that the elapsed time message keeps popping up. Since it's
measuring from the last time we got a status message, it looks weird
because it resets to 3 seconds over and over and over.

>>> And at the end we see:
>>>
>>>      Preparing to flash
>>>      Downloading 100% ( 0m 3s )
>>>      Installing ( 0m 43s : 25m 0s )
>>>      Selecting ( 0m 5s : 0m 30s )
>>>      Flash done
>>>
>>> I can have the driver do updates more often in order to stay under the 3 
>>> second limit and hide this, but it looks a bit funky, especially at the 
>>> end where I know that 100% took a lot longer than 3 seconds.
>>>   
>>
>> I think we have two options here:
>>
>> 1) never display an elapsed time when we have done/total information
>>
>> or
>>
>> 2) treat elapsed time as a measure since the last status message
>> changed, refactoring this so that it shows the total time spent on that
>> status message.
>>
>> Thoughts on this? I think I'm leaning towards (2) at the moment myself.
>> This might lead to displaying the timing info on many % calculations
>> though... Hmm
> 
> Is the time information useful after stage is complete? I'd just wipe
> it before moving on to the next message.
> 

My point was about changing when we calculated elapsed time from to be
"since the status message changed" rather than "since the last time the
driver sent any status even if the message remains the same".

I think clearing the timing message is a good improvement either way, so
I'll do that too.
