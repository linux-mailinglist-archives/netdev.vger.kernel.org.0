Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D12FD14F221
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 19:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgAaSZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 13:25:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:32595 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgAaSZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 13:25:45 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 10:25:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="377419437"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 31 Jan 2020 10:25:44 -0800
Subject: Re: [PATCH 10/15] ice: add basic handler for devlink .info_get
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, valex@mellanox.com,
        linyunsheng@huawei.com, lihong.yang@intel.com
References: <20200130225913.1671982-1-jacob.e.keller@intel.com>
 <20200130225913.1671982-11-jacob.e.keller@intel.com>
 <20200131100727.1e098f49@cakuba.hsd1.ca.comcast.net>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <538381f2-858e-9c93-4b59-bbb82a54ec34@intel.com>
Date:   Fri, 31 Jan 2020 10:25:44 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200131100727.1e098f49@cakuba.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/2020 10:07 AM, Jakub Kicinski wrote:
> On Thu, 30 Jan 2020 14:59:05 -0800, Jacob Keller wrote:
>> The devlink .info_get callback allows the driver to report detailed
>> version information. The following devlink versions are reported with
>> this initial implementation:
>>
>>  "driver.version" -> device driver version, to match ethtool -i version
>>  "fw" -> firmware version as reported by ethtool -i firmware-version
>>  "fw.mgmt" -> The version of the firmware that controls PHY, link, etc
>>  "fw.api" -> API version of interface exposed over the AdminQ
>>  "fw.build" -> Unique build identifier for the management firmware
>>  "nvm.version" -> Version of the NVM parameters section
>>  "nvm.oem" -> OEM-specific version information
>>  "nvm.eetrack" -> Unique identifier for the combined NVM image
> 
> These all need documentation.
> 

There's a patch at the end of the series, but it should probably just be
squashed in here.

>> With this, devlink can now report at least the same information as
>> reported by the older ethtool interface. Each section of the
>> "firmware-version" is also reported independently so that it is easier
>> to understand the meaning.
>>
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>>  drivers/net/ethernet/intel/ice/ice_devlink.c | 103 +++++++++++++++++++
>>  1 file changed, 103 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/ice/ice_devlink.c b/drivers/net/ethernet/intel/ice/ice_devlink.c
>> index 0b0f936122de..493c2c2986f2 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_devlink.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_devlink.c
>> @@ -2,9 +2,112 @@
>>  /* Copyright (c) 2019, Intel Corporation. */
>>  
>>  #include "ice.h"
>> +#include "ice_lib.h"
>>  #include "ice_devlink.h"
>>  
>> +/**
>> + * ice_devlink_info_get - .info_get devlink handler
>> + * @devlink: devlink instance structure
>> + * @req: the devlink info request
>> + * @extack: extended netdev ack structure
>> + *
>> + * Callback for the devlink .info_get operation. Reports information about the
>> + * device.
>> + *
>> + * @returns zero on success or an error code on failure.
>> + */
>> +static int ice_devlink_info_get(struct devlink *devlink,
>> +				struct devlink_info_req *req,
>> +				struct netlink_ext_ack *extack)
>> +{
>> +	u8 oem_ver, oem_patch, nvm_ver_hi, nvm_ver_lo;
>> +	struct ice_pf *pf = devlink_priv(devlink);
>> +	struct ice_hw *hw = &pf->hw;
>> +	u16 oem_build;
>> +	char buf[32]; /* TODO: size this properly */
>> +	int err;
>> +
>> +	ice_get_nvm_version(hw, &oem_ver, &oem_build, &oem_patch, &nvm_ver_hi,
>> +			    &nvm_ver_lo);
>> +
>> +	err = devlink_info_driver_name_put(req, KBUILD_MODNAME);
>> +	if (err) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Unable to set driver name");
>> +		return err;
>> +	}
>> +
>> +	/* driver.version */
>> +	err = devlink_info_version_fixed_put(req, "driver.version",
>> +					     ice_drv_ver);
> 
> Hard no. You should really try to follow the discussions on netdev.
> 
>> +	if (err) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Unable to set driver version");
>> +		return err;
>> +	}
>> +
>> +	/* fw (match exact output of ethtool -i firmware-version) */
> 
> That's generally a bad idea, the whole point of info was that people
> were stuffing multiple things into ethtool -i fw. Is this only one item
> referring to one single entity?

Right. I can just remove this entirely.

> 
>> +	err = devlink_info_version_running_put(req,
>> +					       DEVLINK_INFO_VERSION_GENERIC_FW,
>> +					       ice_nvm_version_str(hw));
>> +	if (err) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Unable to set combined fw version");
>> +		return err;
>> +	}
>> +
>> +	/* fw.mgmt (DEVLINK_INFO_VERSION_GENERIC_FW_MGMT) */
>> +	snprintf(buf, sizeof(buf), "%u.%u.%u", hw->fw_maj_ver, hw->fw_min_ver,
>> +		 hw->fw_patch);
>> +	err = devlink_info_version_running_put(req, "fw.mgmt", buf);
> 
> why not use the define?
> 
>> +	if (err) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Unable to set fw version data");
>> +		return err;
>> +	}
>> +
>> +	/* fw.api */
>> +	snprintf(buf, sizeof(buf), "%u.%u", hw->api_maj_ver,
>> +		 hw->api_min_ver);
>> +	err = devlink_info_version_running_put(req, "fw.api", buf);
> 
> Is this the API version of the management FW? I'd go for "fw.mgmt.api".
> Datapath, RoCE and other bits may have APIs which evolve independently
> for complex chips.
> 

I'm not 100% sure, but probably. Will check and update.

>> +	if (err) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Unable to set fw API data");
>> +		return err;
>> +	}
>> +
>> +	/* fw.build */
>> +	snprintf(buf, sizeof(buf), "%08x", hw->fw_build);
>> +	err = devlink_info_version_running_put(req, "fw.build", buf);
> 
> Huh? Why is this not part of the version?
> 
> Maybe you want to use fw.bundle? Naming is hard, at Netronome added
> that as a unique identifier for the FW in its entirety / the entire
> build as it is passed from Eng to QA and released externally.
> 

fw.bundle is probably more appropriate, yes.

>> +	if (err) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Unable to set fw build data");
>> +		return err;
>> +	}
>> +
>> +	/* nvm.version */
>> +	snprintf(buf, sizeof(buf), "%x.%02x", nvm_ver_hi, nvm_ver_lo);
>> +	err = devlink_info_version_running_put(req, "nvm.version", buf);
> 
> Please us the psid

Ok.

> 
>> +	if (err) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Unable to set NVM version data");
>> +		return err;
>> +	}
>> +
>> +	/* nvm.oem */
>> +	snprintf(buf, sizeof(buf), "%u.%u.%u", oem_ver, oem_build, oem_patch);
>> +	err = devlink_info_version_running_put(req, "nvm.oem", buf);
> 
> This looks like free form catch all. Let's not.

I'm not actually sure what these represent either. Will try to figure
that out and update.

> 
>> +	if (err) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Unable to set oem version data");
>> +		return err;
>> +	}
>> +
>> +	/* nvm.eetrack */
>> +	snprintf(buf, sizeof(buf), "0x%0X", hw->nvm.eetrack);
> 
> Mm. maybe this is bundle? Or psid. Hm. Please explain what this is and
> what it's supposed to be used for. I should probably add more docs to
> the existing items :S

It's probably closer to a bundle or psid. Will fix.

> 
>> +	err = devlink_info_version_running_put(req, "nvm.eetrack", buf);
>> +	if (err) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Unable to set NVM eetrack data");
>> +		return err;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>  const struct devlink_ops ice_devlink_ops = {
>> +	.info_get = ice_devlink_info_get,
>>  };
>>  
>>  /**
> 
