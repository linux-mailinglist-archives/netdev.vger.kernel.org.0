Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 292AA1DE8F8
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 16:30:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgEVO37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 10:29:59 -0400
Received: from mga17.intel.com ([192.55.52.151]:52038 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbgEVO36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 10:29:58 -0400
IronPort-SDR: tQR/Jg+4YeYHZvbL9h91ahu/rC5HS4KA04mJJaf/13Lq19pj6CFusqGtND86IfMmmdYzYDQ3sS
 bywb/hZ1JuCg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 07:29:58 -0700
IronPort-SDR: R6J4OK2fyWsjRrODANZms18sJEkjWmj1ghgSRi6+nbZYzVuDDohyRGXS3tc9q0RP3uZhX/ZbvQ
 LYJcJu7Z58Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,422,1583222400"; 
   d="scan'208";a="255608130"
Received: from kaparr-mobl1.amr.corp.intel.com (HELO [10.252.133.17]) ([10.252.133.17])
  by fmsmga008.fm.intel.com with ESMTP; 22 May 2020 07:29:57 -0700
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
Date:   Fri, 22 May 2020 09:29:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200521233437.GF17583@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>>>> +	ret = virtbus_register_device(vdev);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	/* make sure the probe is complete before updating client list
>>>> */
>>>> +	timeout = msecs_to_jiffies(SOF_CLIENT_PROBE_TIMEOUT_MS);
>>>> +	time = wait_for_completion_timeout(&cdev->probe_complete,
>>>> timeout);
>>>
>>> This seems bonkers - the whole point of something like virtual bus is
>>> to avoid madness like this.
>>
>> Thanks for your review, Jason. The idea of the times wait here is to
>> make the registration of the virtbus devices synchronous so that the
>> SOF core device has knowledge of all the clients that have been able to
>> probe successfully. This part is domain-specific and it works very well
>> in the audio driver case.
> 
> This need to be hot plug safe. What if the module for this driver is
> not available until later in boot? What if the user unplugs the
> driver? What if the kernel runs probing single threaded?
> 
> It is really unlikely you can both have the requirement that things be
> synchronous and also be doing all the other lifetime details properly..

Can you suggest an alternate solution then?

The complete/wait_for_completion is a simple mechanism to tell that the 
action requested by the parent is done. Absent that, we can end-up in a 
situation where the probe may fail, or the requested module does not 
exist, and the parent knows nothing about the failure - so the system is 
in a zombie state and users are frustrated. It's not great either, is it?

This is not an hypothetical case, we've had this recurring problem when 
a PCI device creates an audio card represented as a platform device. 
When the card registration fails, typically due to configuration issues, 
the PCI probe still completes. That's really confusing and the source of 
lots of support questions. If we use these virtual bus extensions to 
stpo abusing platform devices, it'd be really nice to make those 
unreported probe failures go away.

