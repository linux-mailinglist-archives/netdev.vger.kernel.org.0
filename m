Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6B52869C0
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgJGU7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 16:59:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:64568 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbgJGU7b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 16:59:31 -0400
IronPort-SDR: u6ujo6C3eLb9HTZFxVubVhv2IH6VSZTh0SS/zzHP8WdPSAviBAxeWtciFZ8YUanvh3TpKIM7M5
 +DQm+5y154pw==
X-IronPort-AV: E=McAfee;i="6000,8403,9767"; a="182578295"
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="182578295"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 13:59:31 -0700
IronPort-SDR: blahSc5fD490yQjY09s2bxXJZwKaRwtkEPoF7rGqNKXzjTddO0QJ+BQivrdZRqVZFO9bRdIk9N
 UItRhzMd83BQ==
X-IronPort-AV: E=Sophos;i="5.77,348,1596524400"; 
   d="scan'208";a="528161440"
Received: from unknown (HELO [10.135.3.161]) ([10.135.3.161])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2020 13:59:29 -0700
Subject: Re: [PATCH v2 1/6] Add ancillary bus support
To:     "Ertman, David M" <david.m.ertman@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Patil, Kiran" <kiran.patil@intel.com>
References: <20201005182446.977325-1-david.m.ertman@intel.com>
 <20201005182446.977325-2-david.m.ertman@intel.com>
 <20201006071821.GI1874917@unreal>
 <b4f6b5d1-2cf4-ae7a-3e57-b66230a58453@linux.intel.com>
 <20201006170241.GM1874917@unreal>
 <DM6PR11MB2841C531FC27DB41E078C52BDD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
 <20201007192610.GD3964015@unreal>
 <BY5PR12MB43221A308CE750FACEB0A806DC0A0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
From:   Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Message-ID: <c90316f5-a5a9-fe22-ec11-a30a54ff0a9d@linux.intel.com>
Date:   Wed, 7 Oct 2020 15:59:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DM6PR11MB28415A8E53B5FFC276D5A2C4DD0A0@DM6PR11MB2841.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>> Below is most simple, intuitive and matching with core APIs for name and
>> design pattern wise.
>> init()
>> {
>> 	err = ancillary_device_initialize();
>> 	if (err)
>> 		return ret;
>>
>> 	err = ancillary_device_add();
>> 	if (ret)
>> 		goto err_unwind;
>>
>> 	err = some_foo();
>> 	if (err)
>> 		goto err_foo;
>> 	return 0;
>>
>> err_foo:
>> 	ancillary_device_del(adev);
>> err_unwind:
>> 	ancillary_device_put(adev->dev);
>> 	return err;
>> }
>>
>> cleanup()
>> {
>> 	ancillary_device_de(adev);
>> 	ancillary_device_put(adev);
>> 	/* It is common to have a one wrapper for this as
>> ancillary_device_unregister().
>> 	 * This will match with core device_unregister() that has precise
>> documentation.
>> 	 * but given fact that init() code need proper error unwinding, like
>> above,
>> 	 * it make sense to have two APIs, and no need to export another
>> symbol for unregister().
>> 	 * This pattern is very easy to audit and code.
>> 	 */
>> }
> 
> I like this flow +1
> 
> But ... since the init() function is performing both device_init and
> device_add - it should probably be called ancillary_device_register,
> and we are back to a single exported API for both register and
> unregister.

Kind reminder that we introduced the two functions to allow the caller 
to know if it needed to free memory when initialize() fails, and it 
didn't need to free memory when add() failed since put_device() takes 
care of it. If you have a single init() function it's impossible to know 
which behavior to select on error.

I also have a case with SoundWire where it's nice to first initialize, 
then set some data and then add.

> 
> At that point, do we need wrappers on the primitives init, add, del,
> and put?
> 
> -DaveE
> 
