Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4051DEF4B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730854AbgEVSf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:35:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:61764 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730798AbgEVSf4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 14:35:56 -0400
IronPort-SDR: 5GfKK96ueadz2cnBLwLtn2J/7tsMsjfAwRjOvUFGSHM+Y45ofX0xCcRg0L5zA0QaDRUModyj22
 jEwA+uSoP9aA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 11:35:56 -0700
IronPort-SDR: UVr5H5TStw2/Pu1VRx9dumArmGl+Ll7oIr4/JbUzm/V0CTJNqhIKRRwkTbM9SiX4m8aQ1nvqfy
 LI/s+v21+nRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,422,1583222400"; 
   d="scan'208";a="254424236"
Received: from jfarmer-mobl1.amr.corp.intel.com (HELO [10.254.66.73]) ([10.254.66.73])
  by orsmga007.jf.intel.com with ESMTP; 22 May 2020 11:35:55 -0700
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
 <6e129db7-2a76-bc67-0e56-2abb4d9761a3@linux.intel.com>
 <20200522171055.GK17583@ziepe.ca>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <01efd24a-edb6-3d0c-d7fa-a602ecd381d1@linux.intel.com>
Date:   Fri, 22 May 2020 13:35:54 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200522171055.GK17583@ziepe.ca>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/20 12:10 PM, Jason Gunthorpe wrote:
> On Fri, May 22, 2020 at 10:33:20AM -0500, Pierre-Louis Bossart wrote:
> 
>>> Maybe not great, but at least it is consistent with all the lifetime
>>> models and the operation of the driver core.
>>
>> I agree your comments are valid ones, I just don't have a solution to be
>> fully compliant with these models and report failures of the driver probe
>> for a child device due to configuration issues (bad audio topology, etc).
> 
> 
>> My understanding is that errors on probe are explicitly not handled in the
>> driver core, see e.g. comments such as:
> 
> Yes, but that doesn't really apply here...
>   
>> /*
>>   * Ignore errors returned by ->probe so that the next driver can try
>>   * its luck.
>>   */
>> https://elixir.bootlin.com/linux/latest/source/drivers/base/dd.c#L636
>>
>> If somehow we could request the error to be reported then probably we
>> wouldn't need this complete/wait_for_completion mechanism as a custom
>> notification.
> 
> That is the same issue as the completion, a driver should not be
> making assumptions about ordering like this. For instance what if the
> current driver is in the initrd and the 2nd driver is in a module in
> the filesystem? It will not probe until the system boots more
> completely.
> 
> This is all stuff that is supposed to work properly.
> 
>> Not at the moment, no. there are no failures reported in dmesg, and
>> the user does not see any card created. This is a silent error.
> 
> Creating a partial non-function card until all the parts are loaded
> seems like the right way to surface an error like this.
> 
> Or don't break the driver up in this manner if all the parts are really
> required just for it to function - quite strange place to get into.

This is not about having all the parts available - that's handled 
already with deferred probe - but an error happening during card 
registration. In that case the ALSA/ASoC core throws an error and we 
cannot report it back to the parent.

> What happens if the user unplugs this sub driver once things start
> running?

refcounting in the ALSA core prevents that from happening usually.
