Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3C8E40A5EE
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 07:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239506AbhINFbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 01:31:25 -0400
Received: from mga17.intel.com ([192.55.52.151]:26858 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239411AbhINFbY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 01:31:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="202058750"
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="202058750"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 22:30:07 -0700
X-IronPort-AV: E=Sophos;i="5.85,291,1624345200"; 
   d="scan'208";a="469965621"
Received: from mckumar-mobl1.gar.corp.intel.com (HELO [10.215.179.214]) ([10.215.179.214])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 22:30:01 -0700
Message-ID: <491d4920-ca53-7473-74ab-0aa6f6851376@linux.intel.com>
Date:   Tue, 14 Sep 2021 10:59:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH net-next] net: wwan: iosm: firmware flashing and coredump
 collection
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
References: <20210913130412.898895-1-m.chetan.kumar@linux.intel.com>
 <20210913092554.21bdbb97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
In-Reply-To: <20210913092554.21bdbb97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/13/2021 9:55 PM, Jakub Kicinski wrote:
> On Mon, 13 Sep 2021 18:34:12 +0530 M Chetan Kumar wrote:
>> This patch brings-in support for M.2 7560 Device firmware flashing &
>> coredump collection using devlink.
>> - Driver Registers with Devlink framework.
>> - Register devlink params callback for configuring device params
>>    required in flashing or coredump flow.
>> - Implements devlink ops flash_update callback that programs modem
>>    firmware.
>> - Creates region & snapshot required for device coredump log collection.
>>
>> On early detection of device in boot rom stage. Driver registers with
>> Devlink framework and establish transport channel for PSI (Primary Signed
>> Image) injection. Once PSI is injected to device, the device execution
>> stage details are read to determine whether device is in flash or
>> exception mode.
> 
> Is this normal operation flow for the device? After each boot device
> boots from the rom image and then user has to "inject" the full FW
> image with devlink?

No. It's not a normal operation flow for the device.
M.2 7560 Device has a NAND flash. Only when device needs to be reflashed 
then only fw image is injected via devlink.

In order to keep device in boot rom stage a special AT command or MBIM 
CID is issued prior to fw flash.

>> +int ipc_coredump_get_list(struct iosm_devlink *devlink, u16 cmd)
>> +{
>> +	u32 byte_read, num_entries, file_size;
>> +	struct iosm_cd_table *cd_table;
>> +	u8 size[MAX_SIZE_LEN], i;
>> +	char *filename;
>> +	int ret = 0;
>> +
>> +	cd_table = kzalloc(MAX_CD_LIST_SIZE, GFP_KERNEL);
>> +	if (!cd_table) {
>> +		ret = -ENOMEM;
>> +		goto  cd_init_fail;
>> +	}
>> +
>> +	ret = ipc_devlink_send_cmd(devlink, cmd, MAX_CD_LIST_SIZE);
>> +	if (ret) {
>> +		dev_err(devlink->dev, "rpsi_cmd_coredump_start failed");
>> +		goto cd_init_fail;
>> +	}
>> +
>> +	ret = ipc_imem_sys_devlink_read(devlink, (u8 *)cd_table,
>> +					MAX_CD_LIST_SIZE, &byte_read);
>> +	if (ret) {
>> +		dev_err(devlink->dev, "Coredump data is invalid");
>> +		goto cd_init_fail;
>> +	}
>> +
>> +	if (byte_read != MAX_CD_LIST_SIZE)
>> +		goto cd_init_fail;
>> +
>> +	if (cmd == rpsi_cmd_coredump_start) {
>> +		num_entries = le32_to_cpu(cd_table->list.num_entries);
>> +		if (num_entries == 0 || num_entries > IOSM_NOF_CD_REGION) {
>> +			ret = -EINVAL;
>> +			goto cd_init_fail;
>> +		}
>> +
>> +		for (i = 0; i < num_entries; i++) {
>> +			file_size = le32_to_cpu(cd_table->list.entry[i].size);
>> +			filename = cd_table->list.entry[i].filename;
>> +
>> +			if (file_size > devlink->cd_file_info[i].default_size) {
>> +				ret = -EINVAL;
>> +				goto cd_init_fail;
>> +			}
>> +
>> +			devlink->cd_file_info[i].actual_size = file_size;
>> +			dev_dbg(devlink->dev, "file: %s actual size %d",
>> +				filename, file_size);
>> +			devlink_flash_update_status_notify(devlink->devlink_ctx,
>> +							   filename,
>> +							   "FILENAME", 0, 0);
> 
> Why are you using flash_update_status_notify() in a snapshot collecting
> function? As the name indicates that helper is for reporting flashing
> progress.

Coredump collection process starts with pre-flashing procedure (primary 
fw injection), depending on current device state either in exception or 
flash stage the device reported information is notified to devlink via 
_flash_update_status_notify.

This is an early procedure for coredump collection.
