Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E655D194427
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 17:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbgCZQTd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 12:19:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:34427 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726296AbgCZQTd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 12:19:33 -0400
IronPort-SDR: 9dQAAG1W5jRRzY5gkSDwYgJ7f8elEnRiJVkPQyI09UqX+fy42dgPnL82ElclIfBQ20ujc7qLQi
 yk+QCdlZ07wQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 09:19:31 -0700
IronPort-SDR: IyVLKxFTGoyGkOSeMNKBRKziaOWe/wLNWE33+BfvdpTfwza3yoeuyQeQKUe3NG4VQLEUY7MJXT
 LEy6vSBkdjAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="282553523"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.179.43]) ([10.254.179.43])
  by fmsmga002.fm.intel.com with ESMTP; 26 Mar 2020 09:19:31 -0700
Subject: Re: [net-next v2 09/11] devlink: implement DEVLINK_CMD_REGION_NEW
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-10-jacob.e.keller@intel.com>
 <20200326085239.GO11304@nanopsycho.orion>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <5fe502ca-8b67-673c-150a-86a28938faad@intel.com>
Date:   Thu, 26 Mar 2020 09:19:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326085239.GO11304@nanopsycho.orion>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/26/2020 1:52 AM, Jiri Pirko wrote:
> Thu, Mar 26, 2020 at 04:51:55AM CET, jacob.e.keller@intel.com wrote:
> 
> [...]
> 
>> +	err = __devlink_snapshot_id_insert(devlink, snapshot_id);
>> +	if (err) {
>> +		return err;
>> +	}
>> +
>> +	err = region->ops->snapshot(devlink, info->extack, &data);
>> +	if (err)
>> +		goto snapshot_capture_failure;
>> +
>> +	err = __devlink_region_snapshot_create(region, data, snapshot_id);
>> +	if (err)
>> +		goto snapshot_create_failure;
>> +
>> +	return 0;
>> +
>> +snapshot_create_failure:
>> +	region->ops->destructor(data);
>> +snapshot_capture_failure:
> 
> Eh, this actually should be "err_snapshot_capture" and
> "err_snapshot_create"
> 

Sure. It seems a lot of functions use "out" or "nla_put_failure", or
other styles.

$grep "^[A-Za-z0-9_]*:" net/core/devlink.c | sort | uniq -c | less
      1 dump_err:
      1 err_action_value_put:
      1 err_action_values_put:
      1 err_cancel_msg:
      1 err_group_init:
      1 err_group_link:
      1 err_match_value_put:
      1 err_match_values_put:
      1 err_resource_put:
      2 err_stats_alloc:
      2 err_table_put:
      1 err_trap_fill:
      1 err_trap_group_fill:
      1 err_trap_group_register:
      1 err_trap_group_verify:
      1 err_trap_init:
      1 err_trap_register:
      1 err_trap_verify:
      1 free_msg:
      2 genlmsg_cancel:
      1 id_increment_failure:
     34 nla_put_failure:
      1 nla_put_failure_type_locked:
     27 out:
      1 out_cancel_msg:
      1 out_dev:
      2 out_free_msg:
      1 out_unlock:
      1 param_nest_cancel:
      1 reporter_nest_cancel:
      1 resource_put_failure:
      1 rollback:
      4 send_done:
      1 snapshot_capture_failure:
      1 snapshot_create_failure:
      3 start_again:
      9 unlock:
      1 value_nest_cancel:
      1 values_list_nest_cancel:

But I'll change these.
