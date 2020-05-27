Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A0B1E464A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 16:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388931AbgE0OpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 10:45:04 -0400
Received: from mga04.intel.com ([192.55.52.120]:54217 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388356AbgE0OpE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 May 2020 10:45:04 -0400
IronPort-SDR: PTQURh6rKttCQ8AVE4ZKvNld3EDDraFxi6GEX9ODVmnoOQ55iRYRw+KQErjvupd6VW2NQOXsFP
 Jk6bVZJ+o0NA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2020 07:45:03 -0700
IronPort-SDR: OtwnxPNxSmHczI5y7ictvpQ5bh36kD5GZa4Az9rPhj5aUykRKMs6MgV55/P3mKY+gUH8dqvSZz
 6L6TY1wTgDPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,441,1583222400"; 
   d="scan'208";a="468763162"
Received: from vmgould-mobl.amr.corp.intel.com (HELO [10.252.133.103]) ([10.252.133.103])
  by fmsmga006.fm.intel.com with ESMTP; 27 May 2020 07:45:02 -0700
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
To:     Greg KH <gregkh@linuxfoundation.org>, Takashi Iwai <tiwai@suse.de>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>
References: <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
 <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
 <20200524063519.GB1369260@kroah.com>
 <fe44419b-924c-b183-b761-78771b7d506d@linux.intel.com>
 <s5h5zcistpb.wl-tiwai@suse.de> <20200527071733.GB52617@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <76007750-e0ec-4bc1-d6ae-96677584a51c@linux.intel.com>
Date:   Wed, 27 May 2020 09:05:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200527071733.GB52617@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>>>>> If yes, that's yet another problem... During the PCI probe, we start a
>>>>> workqueue and return success to avoid blocking everything.
>>>>
>>>> That's crazy.
>>>>
>>>>> And only 'later' do we actually create the card. So that's two levels
>>>>> of probe that cannot report a failure. I didn't come up with this
>>>>> design, IIRC this is due to audio-DRM dependencies and it's been used
>>>>> for 10+ years.
>>>>
>>>> Then if the probe function fails, it needs to unwind everything itself
>>>> and unregister the device with the PCI subsystem so that things work
>>>> properly.  If it does not do that today, that's a bug.
>>>>
>>>> What kind of crazy dependencies cause this type of "requirement"?
>>>
>>> I think it is related to the request_module("i915") in
>>> snd_hdac_i915_init(), and possibly other firmware download.
>>>
>>> Adding Takashi for more details.
>>
>> Right, there are a few levels of complexity there.  The HD-audio
>> PCI controller driver, for example, is initialized in an async way
>> with a work.  It loads the firmware files with
>> request_firmware_nowait() and also binds itself as a component master
>> with the DRM graphics driver via component framework.
>>
>> Currently it has no way to unwind the PCI binding itself at the error
>> path, though.  In theory it should be possible to unregister the PCI
>> from the driver itself in the work context, but it failed in the
>> earlier experiments, hence the driver sets itself in a disabled state
>> instead.  Maybe worth to try again.
>>
>> But, to be noted, all belonging sub-devices aren't instantiated but
>> deleted at the error path.  Only the main PCI binding is kept in a
>> disabled state just as a place holder until it's unbound explicitly.
> 
> Ok, that's good to hear.  But platform devices should never be showing
> up as a child of a PCI device.  In the "near future" when we get the
> virtual bus code merged, we can convert any existing users like this to
> the new code.

yes that's the plan. It'll be however more than a 1:1 replacement, i.e. 
we want to use this opportunity to split existing cards into separate 
ones when it makes sense to do so. There's really no rationale for 
having code to deal with HDMI in each machine driver when we could have 
a single driver for HDMI. That's really what drove us to suggest this 
patchset based on the virtual bus: removal of platform devices + 
repartition.
