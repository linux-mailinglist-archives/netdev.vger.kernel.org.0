Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42BD1763F1
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgCBT3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:29:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:47521 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727234AbgCBT3p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 14:29:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 11:29:44 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="258061098"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.106]) ([134.134.177.106])
  by orsmga002.jf.intel.com with ESMTP; 02 Mar 2020 11:29:44 -0800
Subject: Re: [RFC PATCH v2 04/22] ice: enable initial devlink support
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-5-jacob.e.keller@intel.com>
 <20200302163056.GB2168@nanopsycho>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <12a9a9bb-12ca-7cfa-43f1-ade9d13b9651@intel.com>
Date:   Mon, 2 Mar 2020 11:29:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302163056.GB2168@nanopsycho>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/2020 8:30 AM, Jiri Pirko wrote:
> Sat, Feb 15, 2020 at 12:22:03AM CET, jacob.e.keller@intel.com wrote:
> 
> [...]
> 
>> +int ice_devlink_create_port(struct ice_pf *pf)
>> +{
>> +	struct devlink *devlink = priv_to_devlink(pf);
>> +	struct ice_vsi *vsi = ice_get_main_vsi(pf);
>> +	struct device *dev = ice_pf_to_dev(pf);
>> +	int err;
>> +
>> +	if (!vsi) {
>> +		dev_err(dev, "%s: unable to find main VSI\n", __func__);
>> +		return -EIO;
>> +	}
>> +
>> +	devlink_port_attrs_set(&pf->devlink_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
>> +			       pf->hw.pf_id, false, 0, NULL, 0);
>> +	err = devlink_port_register(devlink, &pf->devlink_port, pf->hw.pf_id);
>> +	if (err) {
>> +		dev_err(dev, "devlink_port_register failed: %d\n", err);
>> +		return err;
>> +	}
> 
> You need to register_netdev here. Otherwise you'll get inconsistent udev
> naming.
> 

The netdev is registered in other portion of the code, and should
already be registered by the time we call ice_devlink_create_port. This
check is mostly here to prevent a NULL pointer if the VSI somehow
doesn't have a netdev associated with it.

> 
>> +	if (vsi->netdev)
>> +		devlink_port_type_eth_set(&pf->devlink_port, vsi->netdev);
>> +
>> +	return 0;
>> +}
> 
> 
> [...]
> 
