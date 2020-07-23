Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B86622BA39
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 01:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgGWXdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 19:33:14 -0400
Received: from mga18.intel.com ([134.134.136.126]:17205 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbgGWXdO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 19:33:14 -0400
IronPort-SDR: 1pDkhslvXSkpE7eeRpWhjYGYQ5nAKjwWjPRPuBC891A3v8k6z7V/29iIPk69t6SY9SV/BDWqOH
 sylhuSFfbCQQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9691"; a="138135002"
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="138135002"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2020 16:33:13 -0700
IronPort-SDR: CqvoQwL7jNIM4oaCKFNXXngZ3XcYJkFGSKa5zU4fb4j/M9bT7pvY00rh9qkRnl0IWW0MhAsE58
 J0YPfRuJDmdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="489002950"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.181.37]) ([10.212.181.37])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jul 2020 16:33:12 -0700
Subject: Re: [RFC PATCH net-next v2 5/6] ice: implement device flash update
 via devlink
To:     netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jakub Kicinski <kubakici@wp.pl>, Jiri Pirko <jiri@resnulli.us>,
        Tom Herbert <tom@herbertland.com>
References: <20200717183541.797878-1-jacob.e.keller@intel.com>
 <20200717183541.797878-6-jacob.e.keller@intel.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <45bd606f-e0bf-de8b-7e1f-5bd01aa07618@intel.com>
Date:   Thu, 23 Jul 2020 16:33:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <20200717183541.797878-6-jacob.e.keller@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2020 11:35 AM, Jacob Keller wrote:

> +	devlink_flash_update_begin_notify(devlink);
> +	devlink_flash_update_status_notify(devlink, "Preparing to flash",
> +					   component, 0, 0);
> +	err = ice_flash_pldm_image(pf, fw, extack);
> +	devlink_flash_update_end_notify(devlink);
> +
> +	release_firmware(fw);
> +
> +	return err;
> +}
> +

Hi Jakub, Jiri,

I noticed something interesting recently in regards to the
devlink_flash_update_end_notify.

The way that iproute2/devlink works is that if
DEVLINK_CMD_FLASH_UPDATE_END is sent, then it will stop waiting for the
error response from DEVLINK_CMD_FLASH_UPDATE.

This means that if a driver sends DEVLINK_CMD_FLASH_UPDATE_END on a
failed update, the devlink program doesn't report the error or the
netlink status message.

Is it expected to send DEVLINK_CMD_FLASH_UPDATE_END on failures? All
current drivers appear to do so.

Perhaps its a bug in the devlink application on not waiting for the
flash command to properly complete?

Would it make sense to extend DEVLINK_FLASH_UPDATE_END to include an
attribute which specified the error code? But then would that include
the netlink extended status message?

It's not a huge deal but it seemed weird that if we detect any errors
during the main flash update process we will not properly report them.

I wasn't quite sure where the bug actually lies, so help here is
appreciated on figuring out what the best fix is.

Regards,
Jake
