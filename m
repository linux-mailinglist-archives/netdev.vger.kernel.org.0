Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9904214F1FC
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbgAaSNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:13:21 -0500
Received: from mga07.intel.com ([134.134.136.100]:65470 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgAaSNV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:13:21 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 10:12:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="377415638"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2020 10:12:19 -0800
Subject: Re: [PATCH 04/15] netdevsim: support taking immediate snapshot via
 devlink
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-5-jacob.e.keller@intel.com>
 <20200131100712.5ba1ce65@cakuba.hsd1.ca.comcast.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <eda2109e-edb8-d37c-ca85-80e767cdf89b@intel.com>
Date:   Fri, 31 Jan 2020 10:12:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200131100712.5ba1ce65@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/2020 10:07 AM, Jakub Kicinski wrote:
> On Thu, 30 Jan 2020 14:58:59 -0800, Jacob Keller wrote:
>> Implement the .snapshot region operation for the dummy data region. This
>> enables a region snapshot to be taken upon request via the new
>> DEVLINK_CMD_REGION_SNAPSHOT command.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>>  drivers/net/netdevsim/dev.c                   | 38 +++++++++++++++----
>>  .../drivers/net/netdevsim/devlink.sh          |  5 +++
>>  2 files changed, 36 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>> index d521b7bfe007..924cd328037f 100644
>> --- a/drivers/net/netdevsim/dev.c
>> +++ b/drivers/net/netdevsim/dev.c
>> @@ -38,24 +38,47 @@ static struct dentry *nsim_dev_ddir;
>>  
>>  #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
>>  
>> +static int nsim_dev_take_snapshot(struct devlink *devlink,
> 
> nit: break the line after static int, you've done it in other patches
>     so I trust you agree it's a superior formatting style :)
> 

Sure.

>> +				  struct netlink_ext_ack *extack,
>> +				  u8 **data,
>> +				  devlink_snapshot_data_dest_t **destructor)
>> +{
>> +	void *dummy_data;
>> +
>> +	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
>> +	if (!dummy_data) {
>> +		NL_SET_ERR_MSG(extack, "Out of memory");
> 
> Unnecessary, there will be an OOM splat, and ENOMEM is basically
> exactly the same as the message.
> 
>> +		return -ENOMEM;
>> +	}
>> +
>> +	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
>> +
>> +	*data = dummy_data;
>> +	*destructor = kfree;
> 
> Is there any driver which uses different destructor for different
> snapshots? Looks like something we could put in ops, maybe?
> 

Hmm. Yea I think you're right making this tied to the ops structure
instead of the callback makes sense to me.

>> +	return 0;
>> +}
>> +
>>  static ssize_t nsim_dev_take_snapshot_write(struct file *file,
>>  					    const char __user *data,
>>  					    size_t count, loff_t *ppos)
>>  {
>>  	struct nsim_dev *nsim_dev = file->private_data;
>> -	void *dummy_data;
>> +	devlink_snapshot_data_dest_t *destructor;
>> +	u8 *dummy_data;
>>  	int err;
>>  	u32 id;
>>  
>> -	dummy_data = kmalloc(NSIM_DEV_DUMMY_REGION_SIZE, GFP_KERNEL);
>> -	if (!dummy_data)
>> -		return -ENOMEM;
>> -
>> -	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
>> +	err = nsim_dev_take_snapshot(priv_to_devlink(nsim_dev), NULL,
>> +				     &dummy_data, &destructor);
>> +	if (err) {
>> +		pr_err("Failed to capture region snapshot\n");
> 
> Also not a very useful message for netdevsim IMHO give the caller
> clearly requested a snapshot and will get a more informative error 
> from errno.
> 

Will remove.

>> +		return err;
>> +	}
>>  
>>  	id = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev));
>>  	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
>> -					     dummy_data, id, kfree);
>> +					     dummy_data, id, destructor);
>>  	if (err) {
>>  		pr_err("Failed to create region snapshot\n");
>>  		kfree(dummy_data);
