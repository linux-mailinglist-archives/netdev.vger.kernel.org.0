Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F061150E6A
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgBCRKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:10:55 -0500
Received: from mga06.intel.com ([134.134.136.31]:61760 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728737AbgBCRKz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 12:10:55 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 08:56:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278798860"
Received: from unknown (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 08:56:57 -0800
Subject: Re: [PATCH 08/15] devlink: add devres managed devlinkm_alloc and
 devlinkm_free
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-9-jacob.e.keller@intel.com>
 <20200203112919.GB2260@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <e9ac5cfd-34dd-cb99-8950-473a97c20090@intel.com>
Date:   Mon, 3 Feb 2020 08:56:57 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200203112919.GB2260@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/2020 3:29 AM, Jiri Pirko wrote:
> Thu, Jan 30, 2020 at 11:59:03PM CET, jacob.e.keller@intel.com wrote:
>> Add devres managed allocation functions for allocating a devlink
>> instance. These can be used by device drivers based on the devres
>> framework which want to allocate a devlink instance.
>>
>> For simplicity and to reduce churn in the devlink core code, the devres
>> management works by creating a node with a double-pointer. The devlink
>> instance is allocated using the normal devlink_alloc and released using
>> the normal devlink_free.
>>
>> An alternative solution where the raw memory for devlink is allocated
>> directly via devres_alloc could be done. Such an implementation would
>> either significantly increase code duplication or code churn in order to
>> refactor the setup from the allocation.
>>
>> The new devres managed allocation function will be used by the ice
>> driver in a following change to implement initial devlink support.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>> include/net/devlink.h |  4 ++++
>> lib/devres.c          |  1 +
>> net/core/devlink.c    | 54 +++++++++++++++++++++++++++++++++++++++++++
>> 3 files changed, 59 insertions(+)
>>
>> diff --git a/include/net/devlink.h b/include/net/devlink.h
>> index 63e954241404..1c3540280396 100644
>> --- a/include/net/devlink.h
>> +++ b/include/net/devlink.h
>> @@ -858,11 +858,15 @@ struct ib_device;
>> struct net *devlink_net(const struct devlink *devlink);
>> void devlink_net_set(struct devlink *devlink, struct net *net);
>> struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size);
>> +struct devlink *devlinkm_alloc(struct device * dev,
>> +			       const struct devlink_ops *ops,
>> +			       size_t priv_size);
>> int devlink_register(struct devlink *devlink, struct device *dev);
>> void devlink_unregister(struct devlink *devlink);
>> void devlink_reload_enable(struct devlink *devlink);
>> void devlink_reload_disable(struct devlink *devlink);
>> void devlink_free(struct devlink *devlink);
>> +void devlinkm_free(struct device *dev, struct devlink *devlink);
>> int devlink_port_register(struct devlink *devlink,
>> 			  struct devlink_port *devlink_port,
>> 			  unsigned int port_index);
>> diff --git a/lib/devres.c b/lib/devres.c
>> index 6ef51f159c54..239c81d40612 100644
>> --- a/lib/devres.c
>> +++ b/lib/devres.c
>> @@ -5,6 +5,7 @@
>> #include <linux/gfp.h>
>> #include <linux/export.h>
>> #include <linux/of_address.h>
>> +#include <net/devlink.h>
>>
>> enum devm_ioremap_type {
>> 	DEVM_IOREMAP = 0,
>> diff --git a/net/core/devlink.c b/net/core/devlink.c
>> index 574008c536fa..b2b855d12a11 100644
>> --- a/net/core/devlink.c
>> +++ b/net/core/devlink.c
>> @@ -6531,6 +6531,60 @@ void devlink_free(struct devlink *devlink)
>> }
>> EXPORT_SYMBOL_GPL(devlink_free);
>>
>> +static void devres_devlink_release(struct device *dev, void *res)
>> +{
>> +	devlink_free(*(struct devlink **)res);
>> +}
>> +
>> +static int devres_devlink_match(struct device *dev, void *res, void *data)
>> +{
>> +	return *(struct devlink **)res == data;
>> +}
>> +
>> +/**
>> + * devlinkm_alloc - Allocate devlink instance managed by devres
>> + * @dev: device to allocate devlink for
>> + * @ops: devlink ops structure
>> + * @priv_size: size of private data portion
>> + *
>> + * Allocate a devlink instance and manage its release via devres.
>> + */
>> +struct devlink *devlinkm_alloc(struct device *dev,
> 
> Why "devlinkm"? Looks like the usual prefix for this is "devm_"
> So "devm_devlink_alloc/free"?
> 
> 

pcim_enable_device
pcim_iomap
pcim_iomap_devres
pcim_iomap_regions
pcim_iomap_regions_request_all
pcim_iomap_release
pcim_iomap_table
pcim_iounmap
pcim_iounmap_regions
pcim_pin_device
pcim_release
pcim_set_mwi
pcim_state

There are some devm_pci_* though... Heh.

Regardless, I agree wit Jakub, and am going to remove this, because it
seems less valuable since the driver needs to manage the remaining
devlink state regardless. (Unless we add devm_devlink_* for every thing,
but....)

I think it makes more sense to assume a devres driver would need to
manage its own usage via direct devres calls to setup the teardown
actions manually.

Thanks,
Jake
