Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0995A177FDC
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 19:58:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732328AbgCCRxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:53:17 -0500
Received: from mga02.intel.com ([134.134.136.20]:30618 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731538AbgCCRxQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 12:53:16 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 09:53:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="229006617"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2020 09:53:16 -0800
Subject: Re: [RFC PATCH v2 04/22] ice: enable initial devlink support
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-5-jacob.e.keller@intel.com>
 <20200302163056.GB2168@nanopsycho>
 <12a9a9bb-12ca-7cfa-43f1-ade9d13b9651@intel.com>
 <20200303134704.GM2178@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <23a42719-5bb2-4a11-c082-290205aff8c1@intel.com>
Date:   Tue, 3 Mar 2020 09:53:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303134704.GM2178@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/2020 5:47 AM, Jiri Pirko wrote:
> Mon, Mar 02, 2020 at 08:29:44PM CET, jacob.e.keller@intel.com wrote:
>>
>>
>> On 3/2/2020 8:30 AM, Jiri Pirko wrote:
>>> Sat, Feb 15, 2020 at 12:22:03AM CET, jacob.e.keller@intel.com wrote:
>>>
>>> [...]
>>>
>>>> +int ice_devlink_create_port(struct ice_pf *pf)
>>>> +{
>>>> +	struct devlink *devlink = priv_to_devlink(pf);
>>>> +	struct ice_vsi *vsi = ice_get_main_vsi(pf);
>>>> +	struct device *dev = ice_pf_to_dev(pf);
>>>> +	int err;
>>>> +
>>>> +	if (!vsi) {
>>>> +		dev_err(dev, "%s: unable to find main VSI\n", __func__);
>>>> +		return -EIO;
>>>> +	}
>>>> +
>>>> +	devlink_port_attrs_set(&pf->devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
>>>> +			       pf->hw.pf_id, false, 0, NULL, 0);
>>>> +	err = devlink_port_register(devlink, &pf->devlink_port, pf->hw.pf_id);
>>>> +	if (err) {
>>>> +		dev_err(dev, "devlink_port_register failed: %d\n", err);
>>>> +		return err;
>>>> +	}
>>>
>>> You need to register_netdev here. Otherwise you'll get inconsistent udev
>>> naming.
>>>
>>
>> The netdev is registered in other portion of the code, and should
>> already be registered by the time we call ice_devlink_create_port. This
>> check is mostly here to prevent a NULL pointer if the VSI somehow
>> doesn't have a netdev associated with it.
> 
> My point is, the correct order is:
> devlink_register()
> devlink_port_attrs_set()
> devlink_port_register()
> register_netdev()
> devlink_port_type_eth_set()
> 

Oh. Hmm. Ok, I'll need to move this around. Will fix.

Thanks,
Jake
