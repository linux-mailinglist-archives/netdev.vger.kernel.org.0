Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868501DEBEC
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730124AbgEVPdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 11:33:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:6035 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728433AbgEVPdW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 11:33:22 -0400
IronPort-SDR: PDmt37e5R7/wTEE/hMgMom2ZNBwCng7fcV9o09pMblkFqRGrb0n10R8A7RbcsFLj1IvNpWSyBj
 g7EvidIgtP/Q==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 08:33:21 -0700
IronPort-SDR: kM8NV5pACghNRRx13BmJ5goZKNpAp/JZ3mya5KK5D8FmIrKrjvBEdLEHLwHeCHaIeZgPOVCX3b
 Jk3+T6XW0+Xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,422,1583222400"; 
   d="scan'208";a="255621290"
Received: from kaparr-mobl1.amr.corp.intel.com (HELO [10.252.133.17]) ([10.252.133.17])
  by fmsmga008.fm.intel.com with ESMTP; 22 May 2020 08:33:20 -0700
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Fred Oh <fred.oh@linux.intel.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200522145542.GI17583@ziepe.ca>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <6e129db7-2a76-bc67-0e56-2abb4d9761a3@linux.intel.com>
Date:   Fri, 22 May 2020 10:33:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200522145542.GI17583@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/20 9:55 AM, Jason Gunthorpe wrote:
> On Fri, May 22, 2020 at 09:29:57AM -0500, Pierre-Louis Bossart wrote:
>>
>>>>>> +	ret = virtbus_register_device(vdev);
>>>>>> +	if (ret < 0)
>>>>>> +		return ret;
>>>>>> +
>>>>>> +	/* make sure the probe is complete before updating client list
>>>>>> */
>>>>>> +	timeout = msecs_to_jiffies(SOF_CLIENT_PROBE_TIMEOUT_MS);
>>>>>> +	time = wait_for_completion_timeout(&cdev->probe_complete,
>>>>>> timeout);
>>>>>
>>>>> This seems bonkers - the whole point of something like virtual bus is
>>>>> to avoid madness like this.
>>>>
>>>> Thanks for your review, Jason. The idea of the times wait here is to
>>>> make the registration of the virtbus devices synchronous so that the
>>>> SOF core device has knowledge of all the clients that have been able to
>>>> probe successfully. This part is domain-specific and it works very well
>>>> in the audio driver case.
>>>
>>> This need to be hot plug safe. What if the module for this driver is
>>> not available until later in boot? What if the user unplugs the
>>> driver? What if the kernel runs probing single threaded?
>>>
>>> It is really unlikely you can both have the requirement that things be
>>> synchronous and also be doing all the other lifetime details properly..
>>
>> Can you suggest an alternate solution then?
> 
> I don't even know what problem you are trying to solve.
> 
>> The complete/wait_for_completion is a simple mechanism to tell that the
>> action requested by the parent is done. Absent that, we can end-up in a
>> situation where the probe may fail, or the requested module does not exist,
>> and the parent knows nothing about the failure - so the system is in a
>> zombie state and users are frustrated. It's not great either, is it?
> 
> Maybe not great, but at least it is consistent with all the lifetime
> models and the operation of the driver core.

I agree your comments are valid ones, I just don't have a solution to be 
fully compliant with these models and report failures of the driver 
probe for a child device due to configuration issues (bad audio 
topology, etc).

My understanding is that errors on probe are explicitly not handled in 
the driver core, see e.g. comments such as:

/*
  * Ignore errors returned by ->probe so that the next driver can try
  * its luck.
  */
https://elixir.bootlin.com/linux/latest/source/drivers/base/dd.c#L636

If somehow we could request the error to be reported then probably we 
wouldn't need this complete/wait_for_completion mechanism as a custom 
notification.

>> This is not an hypothetical case, we've had this recurring problem when a
>> PCI device creates an audio card represented as a platform device. When the
>> card registration fails, typically due to configuration issues, the PCI
>> probe still completes. That's really confusing and the source of lots of
>> support questions. If we use these virtual bus extensions to stpo abusing
>> platform devices, it'd be really nice to make those unreported probe
>> failures go away.
> 
> I think you need to address this in some other way that is hot plug
> safe.
> 
> Surely you can make this failure visible to users in some other way?

Not at the moment, no. there are no failures reported in dmesg, and the 
user does not see any card created. This is a silent error.

This is probably domain-specific btw, the use of complete() is only part 
of the SOF core where we extended the virtual bus to support SOF 
clients. This is not a requirement in general for virtual bus users. We 
are not forcing anyone to rely on this complete/wait_for_completion, and 
if someone has a better idea to help us report probe failures we are all 
ears.
