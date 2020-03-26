Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86C31193554
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 02:43:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgCZBnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 21:43:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:22345 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727561AbgCZBnX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 21:43:23 -0400
IronPort-SDR: +5hlAymmRXcpmsbRq2Ekrdf5FD6TNODrwtxOm81jvYO6eM8VIZ2yLxrrXnx7HVhlbbYClQrvhJ
 YjsHNImjHnuw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2020 18:43:22 -0700
IronPort-SDR: k6RCk5j3rvup9b3Gd8RUJ8iEphowQFsl6ap+UAJOgwdlFPwGenparml9jB6VtPaEQrNOJ6mbI4
 6nn7wJWTFgYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,306,1580803200"; 
   d="scan'208";a="282334013"
Received: from cdalvizo-mobl1.amr.corp.intel.com (HELO [10.252.133.80]) ([10.252.133.80])
  by fmsmga002.fm.intel.com with ESMTP; 25 Mar 2020 18:43:21 -0700
Subject: Re: [PATCH] devlink: track snapshot id usage count using an xarray
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20200324223445.2077900-1-jacob.e.keller@intel.com>
 <20200324223445.2077900-8-jacob.e.keller@intel.com>
 <20200325160832.GY11304@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <e0b46a11-4174-163b-401b-bdfe1d6e4f5c@intel.com>
Date:   Wed, 25 Mar 2020 18:43:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200325160832.GY11304@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/2020 9:08 AM, Jiri Pirko wrote:
> Tue, Mar 24, 2020 at 11:34:42PM CET, jacob.e.keller@intel.com wrote:
>> +static int __devlink_snapshot_id_increment(struct devlink *devlink, u32 id)
>> +{
>> +	unsigned long count;
>> +	int err;
>> +	void *p;
>> +
>> +	lockdep_assert_held(&devlink->lock);
>> +
>> +	p = xa_load(&devlink->snapshot_ids, id);
>> +	if (!p)
>> +		return -EEXIST;
> 
> This is confusing. You should return rather -ENOTEXIST, if it existed :)
> -EINVAL and WARN_ON. This should never happen
> 

Yea this is confusing. I'll add a WARN_ON, and use EINVAL.

> 
>> +
>> +	if (!xa_is_value(p))
>> +		return -EINVAL;
>> +
>> +	count = xa_to_value(p);
>> +	count++;
>> +
>> +	err = xa_err(xa_store(&devlink->snapshot_ids, id, xa_mk_value(count),
>> +			      GFP_KERNEL));
> 
> Just return here and remove err variable.

Yep.

>> -	if (devlink->snapshot_id >= INT_MAX)
>> -		return -ENOSPC;
>> +	/* xa_limit_31b ensures the id will be between 0 and INT_MAX */
> 
> Well, currently the snapshot_id is u32. Even the netlink attr is u32.
> I believe we should not limit it here.
> 
> Please have this as xa_limit_32b.
> 

Currently we can't do that. Negative values are used to represent
errors, and allowing up to u32 would break the get function, because
large IDs would be interpreted as errors.

I'll clean this up in a patch first before the xarray stuff.

Thanks,
Jake
