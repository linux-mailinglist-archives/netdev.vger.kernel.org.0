Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE73E2651B3
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 23:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgIJU7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:59:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:22224 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbgIJU7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 16:59:47 -0400
IronPort-SDR: LbUG+deJo9XzqiQIOWGV07IsdvzLvt40/PS2F75H5576EVuqiIZ4OiSOMA0OZ1ywch3lV77nvq
 UQJL884mwUkA==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="176695813"
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="176695813"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 13:59:46 -0700
IronPort-SDR: SnKi32s0t/dXl71tYvZt+6wc10bJLB8hI6xZ0kCtuf1awmd54whB2vU/ZaBTxF6OBx7xGwNuBv
 a5uOkLouJ70w==
X-IronPort-AV: E=Sophos;i="5.76,413,1592895600"; 
   d="scan'208";a="505968127"
Received: from pojenhsi-mobl1.amr.corp.intel.com (HELO [10.252.128.198]) ([10.252.128.198])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 13:59:45 -0700
Subject: Re: [net-next v4 2/5] devlink: convert flash_update to use params
 structure
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Bin Luo <luobin9@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Ido Schimmel <idosch@mellanox.com>,
        Danielle Ratson <danieller@mellanox.com>
References: <20200909222653.32994-1-jacob.e.keller@intel.com>
 <20200909222653.32994-3-jacob.e.keller@intel.com>
 <20200909175545.3ea38a80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <f8c32083-da74-b7cc-e6a0-6b819533897c@intel.com>
Date:   Thu, 10 Sep 2020 13:59:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200909175545.3ea38a80@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2020 5:55 PM, Jakub Kicinski wrote:
> On Wed,  9 Sep 2020 15:26:50 -0700 Jacob Keller wrote:
>> The devlink core recently gained support for checking whether the driver
>> supports a flash_update parameter, via `supported_flash_update_params`.
>> However, parameters are specified as function arguments. Adding a new
>> parameter still requires modifying the signature of the .flash_update
>> callback in all drivers.
>>
>> Convert the .flash_update function to take a new `struct
>> devlink_flash_update_params` instead. By using this structure, and the
>> `supported_flash_update_params` bit field, a new parameter to
>> flash_update can be added without requiring modification to existing
>> drivers.
>>
>> As before, all parameters except file_name will require driver opt-in.
>> Because file_name is a necessary field to for the flash_update to make
>> sense, no "SUPPORTED" bitflag is provided and it is always considered
>> valid. All future additional parameters will require a new bit in the
>> supported_flash_update_params bitfield.
> 
> I keep thinking we should also make the core do the
> request_firmware_direct(). What else is the driver gonna do with the file name..
> 
> But I don't want to drag your series out so:
> 
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> 

Hmm. What does _direct do? I guess it means it won't fall back to the
userspace helper if it can't find the firmware? It looks like MLX
drivers use it, but others seem to just stick to regular request_firmware.

This seems like an improvement that we can handle in a follow up series
either way. Thanks for the review!
