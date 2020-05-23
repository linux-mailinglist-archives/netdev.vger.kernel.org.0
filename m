Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5CB1DFABF
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 21:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387874AbgEWTlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 15:41:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:1133 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbgEWTlx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 23 May 2020 15:41:53 -0400
IronPort-SDR: auwdd42frbNddXbo3A6lHJZNovqzRLWh6ydRfKA6AzkJL5G+PMgrtdiA4oLzDqmHTaq3a5LGK4
 8FXMUD3AU/HQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2020 12:41:53 -0700
IronPort-SDR: 9xTXQ3eSKUq1ff2sdczerEIM4xxOt+10NoU64lmA8FtX7D0AVwFoHhGtV3xuNEpPfkJW0/h5pz
 NUWuGPUmOMYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,426,1583222400"; 
   d="scan'208";a="301008853"
Received: from divyangx-mobl1.amr.corp.intel.com (HELO [10.252.131.178]) ([10.252.131.178])
  by fmsmga002.fm.intel.com with ESMTP; 23 May 2020 12:41:52 -0700
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
Date:   Sat, 23 May 2020 14:41:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200523062351.GD3156699@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/23/20 1:23 AM, Greg KH wrote:
> On Fri, May 22, 2020 at 09:29:57AM -0500, Pierre-Louis Bossart wrote:
>> This is not an hypothetical case, we've had this recurring problem when a
>> PCI device creates an audio card represented as a platform device. When the
>> card registration fails, typically due to configuration issues, the PCI
>> probe still completes.
> 
> Then fix that problem there.  The audio card should not be being created
> as a platform device, as that is not what it is.  And even if it was,
> the probe should not complete, it should clean up after itself and error
> out.

Did you mean 'the PCI probe should not complete and error out'?

If yes, that's yet another problem... During the PCI probe, we start a 
workqueue and return success to avoid blocking everything. And only 
'later' do we actually create the card. So that's two levels of probe 
that cannot report a failure. I didn't come up with this design, IIRC 
this is due to audio-DRM dependencies and it's been used for 10+ years.

> 
> That's not a driver core issue, sounds like a subsystem error handling
> issue that needs to be resolved.
> 
> thanks,
> 
> greg k-h
> 
