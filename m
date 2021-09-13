Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED505409903
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237476AbhIMQ1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:27:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:57784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237290AbhIMQ1L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 12:27:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42E1060184;
        Mon, 13 Sep 2021 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631550355;
        bh=DRqomqLcpgUyla8dpslpuevWAoffPhU5RVQNtKkgvXc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vQyFtmgBeX5vQM6oet2p0j6WmgSjUR1mg21YEbjJ65yLMQCR6/uKr/8n+xmL/xC2n
         swAO/CrS651aquEXN2p3ZxZY4YKXcsi9Ix7wsVagHtmNP+Vz37QzylP6NHg8bRpJI2
         7+ApvUHUXT5NA7PaNXcURHVO87NaPyvXofflvUqcax4rgPKZ8Rx3HyJ573GhV8oTen
         nZTd5mEfqfEuYnZSNaWt2KvBIdX/da3J/cG1+JaI3Ze3m1/z+h8XF6u2SOFilelbyM
         xwsmqFgOpIGvTZS5faonHZ3z5X1GRRQqEzP2/WKLi2rrLexutTYhNjFMGXqr62l1ND
         DpnJu1YyBIQvA==
Date:   Mon, 13 Sep 2021 09:25:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        linuxwwan@intel.com
Subject: Re: [PATCH net-next] net: wwan: iosm: firmware flashing and
 coredump collection
Message-ID: <20210913092554.21bdbb97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210913130412.898895-1-m.chetan.kumar@linux.intel.com>
References: <20210913130412.898895-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Sep 2021 18:34:12 +0530 M Chetan Kumar wrote:
> This patch brings-in support for M.2 7560 Device firmware flashing &
> coredump collection using devlink.
> - Driver Registers with Devlink framework.
> - Register devlink params callback for configuring device params
>   required in flashing or coredump flow.
> - Implements devlink ops flash_update callback that programs modem
>   firmware.
> - Creates region & snapshot required for device coredump log collection.
> 
> On early detection of device in boot rom stage. Driver registers with
> Devlink framework and establish transport channel for PSI (Primary Signed
> Image) injection. Once PSI is injected to device, the device execution
> stage details are read to determine whether device is in flash or
> exception mode.

Is this normal operation flow for the device? After each boot device
boots from the rom image and then user has to "inject" the full FW
image with devlink?

> The collected information is reported to devlink user
> space application & based on this informationi, application proceeds with
> either modem firmware flashing or coredump collection.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> ---
>  drivers/net/wwan/Kconfig                  |   1 +
>  drivers/net/wwan/iosm/Makefile            |   5 +-
>  drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c |   6 +-
>  drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.h |   1 +
>  drivers/net/wwan/iosm/iosm_ipc_coredump.c | 110 +++++
>  drivers/net/wwan/iosm/iosm_ipc_coredump.h |  75 +++
>  drivers/net/wwan/iosm/iosm_ipc_devlink.c  | 360 ++++++++++++++
>  drivers/net/wwan/iosm/iosm_ipc_devlink.h  | 207 ++++++++
>  drivers/net/wwan/iosm/iosm_ipc_flash.c    | 562 ++++++++++++++++++++++
>  drivers/net/wwan/iosm/iosm_ipc_flash.h    | 271 +++++++++++
>  drivers/net/wwan/iosm/iosm_ipc_imem.c     | 103 +++-
>  drivers/net/wwan/iosm/iosm_ipc_imem.h     |  19 +-
>  drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 317 ++++++++++++
>  drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |  49 +-
>  14 files changed, 2055 insertions(+), 31 deletions(-)

Please try to break your patches down, single patch with 2kLoC is hard
to review.

>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_coredump.c
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_coredump.h
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_devlink.c
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_devlink.h
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_flash.c
>  create mode 100644 drivers/net/wwan/iosm/iosm_ipc_flash.h

> +/* Get coredump list to be collected from modem */
> +int ipc_coredump_get_list(struct iosm_devlink *devlink, u16 cmd)
> +{
> +	u32 byte_read, num_entries, file_size;
> +	struct iosm_cd_table *cd_table;
> +	u8 size[MAX_SIZE_LEN], i;
> +	char *filename;
> +	int ret = 0;
> +
> +	cd_table = kzalloc(MAX_CD_LIST_SIZE, GFP_KERNEL);
> +	if (!cd_table) {
> +		ret = -ENOMEM;
> +		goto  cd_init_fail;
> +	}
> +
> +	ret = ipc_devlink_send_cmd(devlink, cmd, MAX_CD_LIST_SIZE);
> +	if (ret) {
> +		dev_err(devlink->dev, "rpsi_cmd_coredump_start failed");
> +		goto cd_init_fail;
> +	}
> +
> +	ret = ipc_imem_sys_devlink_read(devlink, (u8 *)cd_table,
> +					MAX_CD_LIST_SIZE, &byte_read);
> +	if (ret) {
> +		dev_err(devlink->dev, "Coredump data is invalid");
> +		goto cd_init_fail;
> +	}
> +
> +	if (byte_read != MAX_CD_LIST_SIZE)
> +		goto cd_init_fail;
> +
> +	if (cmd == rpsi_cmd_coredump_start) {
> +		num_entries = le32_to_cpu(cd_table->list.num_entries);
> +		if (num_entries == 0 || num_entries > IOSM_NOF_CD_REGION) {
> +			ret = -EINVAL;
> +			goto cd_init_fail;
> +		}
> +
> +		for (i = 0; i < num_entries; i++) {
> +			file_size = le32_to_cpu(cd_table->list.entry[i].size);
> +			filename = cd_table->list.entry[i].filename;
> +
> +			if (file_size > devlink->cd_file_info[i].default_size) {
> +				ret = -EINVAL;
> +				goto cd_init_fail;
> +			}
> +
> +			devlink->cd_file_info[i].actual_size = file_size;
> +			dev_dbg(devlink->dev, "file: %s actual size %d",
> +				filename, file_size);
> +			devlink_flash_update_status_notify(devlink->devlink_ctx,
> +							   filename,
> +							   "FILENAME", 0, 0);

Why are you using flash_update_status_notify() in a snapshot collecting
function? As the name indicates that helper is for reporting flashing
progress.

> +			snprintf(size, sizeof(size), "%d", file_size);
> +			devlink_flash_update_status_notify(devlink->devlink_ctx,
> +							   size, "FILE SIZE",
> +							   0, 0);
> +		}
> +	}
> +
> +cd_init_fail:
> +	kfree(cd_table);
> +	return ret;
> +}

> +/**
> + * ipc_coredump_collect - To collect coredump
> + * @devlink:		Pointer to devlink instance.
> + * @data:		Pointer to snapshot
> + * @entry:		ID of requested snapshot
> + * @region_size:	Region size
> + *
> + * Returns: 0 on success, error on failure
> + */
> +int ipc_coredump_collect(struct iosm_devlink *devlink, u8 **data, int entry,
> +			 u32 region_size);

kdoc belongs with the code not in the header.

> +/**
> + * ipc_coredump_get_list - Get coredump list
> + * @devlink:         Pointer to devlink instance.
> + * @cmd:	     RPSI command to be sent
> + *
> + * Returns: 0 on success, error on failure
> + */
> +int ipc_coredump_get_list(struct iosm_devlink *devlink, u16 cmd);

> +/* Devlink param structure array */
> +static const struct devlink_param iosm_devlink_params[] = {
> +	DEVLINK_PARAM_DRIVER(IOSM_DEVLINK_PARAM_ID_ERASE_FULL_FLASH,
> +			     "erase_full_flash", DEVLINK_PARAM_TYPE_BOOL,
> +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> +			     ipc_devlink_get_param, ipc_devlink_set_param,
> +			     NULL),
> +	DEVLINK_PARAM_DRIVER(IOSM_DEVLINK_PARAM_ID_DOWNLOAD_REGION,
> +			     "download_region", DEVLINK_PARAM_TYPE_BOOL,
> +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> +			     ipc_devlink_get_param, ipc_devlink_set_param,
> +			     NULL),
> +	DEVLINK_PARAM_DRIVER(IOSM_DEVLINK_PARAM_ID_ADDRESS,
> +			     "address", DEVLINK_PARAM_TYPE_U32,
> +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> +			     ipc_devlink_get_param, ipc_devlink_set_param,
> +			     NULL),
> +	DEVLINK_PARAM_DRIVER(IOSM_DEVLINK_PARAM_ID_REGION_COUNT,
> +			     "region_count", DEVLINK_PARAM_TYPE_U8,
> +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> +			     ipc_devlink_get_param, ipc_devlink_set_param,
> +			     NULL),
> +};

Parameters must be documented under Documentation/networking/devlink/

