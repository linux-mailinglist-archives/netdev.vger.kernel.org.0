Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B44119354C
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 02:33:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgCZBdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 21:33:43 -0400
Received: from mga18.intel.com ([134.134.136.126]:47403 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727574AbgCZBdn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 21:33:43 -0400
IronPort-SDR: 9q8IdNB0+umKWd/zAe2jZBIp42RJeSEHqIDAomRQDyRU7vlF9p31LUCRP4gvB/W2P84skws8r0
 VqmHaP8b3Z0g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 18:33:42 -0700
IronPort-SDR: ZR3TOtkEBe1LVRuIJka2du90FDcHundI97zG6fTSAjLDeIC0jthSa6Wh7jEttA3J/PkmMkVd+S
 86VdukSTplVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="282332448"
Received: from cdalvizo-mobl1.amr.corp.intel.com (HELO [10.252.133.80]) ([10.252.133.80])
  by fmsmga002.fm.intel.com with ESMTP; 25 Mar 2020 18:33:41 -0700
Subject: Re: [PATCH 06/10] devlink: convert snapshot id getter to return an
 error
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jiri Pirko <jiri@mellanox.com>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-7-jacob.e.keller@intel.com>
 <20200325110425.6fdf6cb3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <c119488b-1b27-7c65-7e60-a64bdda585c1@intel.com>
Date:   Wed, 25 Mar 2020 18:33:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325110425.6fdf6cb3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2020 11:04 AM, Jakub Kicinski wrote:
> On Tue, 24 Mar 2020 15:34:41 -0700 Jacob Keller wrote:
>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> index f7621ccb7b88..f9420b77e5fd 100644
>> --- a/drivers/net/netdevsim/dev.c
>> +++ b/drivers/net/netdevsim/dev.c
>> @@ -45,8 +45,7 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>>  {
>>  	struct nsim_dev *nsim_dev = file->private_data;
>>  	void *dummy_data;
>> -	int err;
>> -	u32 id;
>> +	int err, id;
>>  
>>  	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
>>  	if (!dummy_data)
>> @@ -55,6 +54,10 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>>  	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
>>  
>>  	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
>> +	if (id < 0) {
>> +		pr_err("Failed to get snapshot id\n");
>> +		return id;
>> +	}
>>  	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
>>  					     dummy_data, id);
>>  	if (err) {
> 
> Hmm... next patch introduces some ref counting on the ID AFAICT,
> should there be some form of snapshot_id_put(), once the driver is 
> done creating the regions it wants?
> 
> First what if driver wants to create two snapshots with the same ID but
> user space manages to delete the first one before second one is created.
> 
> Second what if create fails, won't the snapshot ID just stay in XA with
> count of 0 forever?
> 

Ah, yep good catch. I'll add a _put* function and make drivers call this.

Thanks,
Jake
