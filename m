Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCA726E65A
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbgIQUMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:12:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:43993 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgIQUMP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:12:15 -0400
IronPort-SDR: I6MXuz9pGh/nXzcU9SqFJ6f59RaTYzv+GeBgfDM//IPBF/LSiwFuGWqZJTtTdIL8veYFSztFGb
 +uSM2ugDdK8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9747"; a="147470759"
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="147470759"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 12:55:11 -0700
IronPort-SDR: iFaLWQyuvWsnN4py/zyBR5YiLxeRaN9UzXOHNoz0gFnKoeQ9WpnrDJgxWz28VB7X2EFL4K1eMh
 JKROWX3p4Xlg==
X-IronPort-AV: E=Sophos;i="5.77,271,1596524400"; 
   d="scan'208";a="483887797"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.151.155]) ([10.212.151.155])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2020 12:55:09 -0700
Subject: Re: [PATCH v4 net-next 5/5] ionic: add devlink firmware update
To:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20200917030204.50098-1-snelson@pensando.io>
 <20200917030204.50098-6-snelson@pensando.io>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <92b48756-565a-eb02-ea1e-3e08237aec11@intel.com>
Date:   Thu, 17 Sep 2020 12:55:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200917030204.50098-6-snelson@pensando.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/16/2020 8:02 PM, Shannon Nelson wrote:
> Add support for firmware update through the devlink interface.
> This update copies the firmware object into the device, asks
> the current firmware to install it, then asks the firmware to
> select the new firmware for the next boot-up.
> 
> The install and select steps are launched as asynchronous
> requests, which are then followed up with status request
> commands.  These status request commands will be answered with
> an EAGAIN return value and will try again until the request
> has completed or reached the timeout specified.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>
> ---
>  drivers/net/ethernet/pensando/ionic/Makefile  |   2 +-
>  .../ethernet/pensando/ionic/ionic_devlink.c   |  14 ++
>  .../ethernet/pensando/ionic/ionic_devlink.h   |   3 +
>  .../net/ethernet/pensando/ionic/ionic_fw.c    | 206 ++++++++++++++++++
>  .../net/ethernet/pensando/ionic/ionic_main.c  |  23 +-
>  5 files changed, 239 insertions(+), 9 deletions(-)
>  create mode 100644 drivers/net/ethernet/pensando/ionic/ionic_fw.c
> 
> diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
> index 29f304d75261..8d3c2d3cb10d 100644
> --- a/drivers/net/ethernet/pensando/ionic/Makefile
> +++ b/drivers/net/ethernet/pensando/ionic/Makefile
> @@ -5,4 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
>  
>  ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
>  	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
> -	   ionic_txrx.o ionic_stats.o
> +	   ionic_txrx.o ionic_stats.o ionic_fw.o
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> index 8d9fb2e19cca..5348f05ebc32 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
> @@ -9,6 +9,19 @@
>  #include "ionic_lif.h"
>  #include "ionic_devlink.h"
>  
> +static int ionic_dl_flash_update(struct devlink *dl,
> +				 const char *fwname,
> +				 const char *component,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct ionic *ionic = devlink_priv(dl);
> +
> +	if (component)
> +		return -EOPNOTSUPP;
> +
> +	return ionic_firmware_update(ionic->lif, fwname, extack);
> +}
> +
>  static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
>  			     struct netlink_ext_ack *extack)
>  {
> @@ -48,6 +61,7 @@ static int ionic_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
>  
>  static const struct devlink_ops ionic_dl_ops = {
>  	.info_get	= ionic_dl_info_get,
> +	.flash_update	= ionic_dl_flash_update,
>  };
>  
>  struct ionic *ionic_devlink_alloc(struct device *dev)
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
> index 0690172fc57a..5c01a9e306d8 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.h
> @@ -6,6 +6,9 @@
>  
>  #include <net/devlink.h>
>  
> +int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
> +			  struct netlink_ext_ack *extack);
> +
>  struct ionic *ionic_devlink_alloc(struct device *dev);
>  void ionic_devlink_free(struct ionic *ionic);
>  int ionic_devlink_register(struct ionic *ionic);
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_fw.c b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
> new file mode 100644
> index 000000000000..f492ae406a60
> --- /dev/null
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
> @@ -0,0 +1,206 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2020 Pensando Systems, Inc */
> +
> +#include <linux/kernel.h>
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/firmware.h>
> +
> +#include "ionic.h"
> +#include "ionic_dev.h"
> +#include "ionic_lif.h"
> +#include "ionic_devlink.h"
> +
> +/* The worst case wait for the install activity is about 25 minutes when
> + * installing a new CPLD, which is very seldom.  Normal is about 30-35
> + * seconds.  Since the driver can't tell if a CPLD update will happen we
> + * set the timeout for the ugly case.
> + */
> +#define IONIC_FW_INSTALL_TIMEOUT	(25 * 60)
> +#define IONIC_FW_SELECT_TIMEOUT		30
> +
> +/* Number of periodic log updates during fw file download */
> +#define IONIC_FW_INTERVAL_FRACTION	32
> +
> +static void ionic_dev_cmd_firmware_download(struct ionic_dev *idev, u64 addr,
> +					    u32 offset, u32 length)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.fw_download.opcode = IONIC_CMD_FW_DOWNLOAD,
> +		.fw_download.offset = offset,
> +		.fw_download.addr = addr,
> +		.fw_download.length = length
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> +
> +static void ionic_dev_cmd_firmware_install(struct ionic_dev *idev)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.fw_control.opcode = IONIC_CMD_FW_CONTROL,
> +		.fw_control.oper = IONIC_FW_INSTALL_ASYNC
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> +
> +static void ionic_dev_cmd_firmware_activate(struct ionic_dev *idev, u8 slot)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.fw_control.opcode = IONIC_CMD_FW_CONTROL,
> +		.fw_control.oper = IONIC_FW_ACTIVATE_ASYNC,
> +		.fw_control.slot = slot
> +	};
> +
> +	ionic_dev_cmd_go(idev, &cmd);
> +}
> +
> +static int ionic_fw_status_long_wait(struct ionic *ionic,
> +				     const char *label,
> +				     unsigned long timeout,
> +				     u8 fw_cmd,
> +				     struct netlink_ext_ack *extack)
> +{
> +	union ionic_dev_cmd cmd = {
> +		.fw_control.opcode = IONIC_CMD_FW_CONTROL,
> +		.fw_control.oper = fw_cmd,
> +	};
> +	unsigned long start_time;
> +	unsigned long end_time;
> +	int err;
> +
> +	start_time = jiffies;
> +	end_time = start_time + (timeout * HZ);
> +	do {
> +		mutex_lock(&ionic->dev_cmd_lock);
> +		ionic_dev_cmd_go(&ionic->idev, &cmd);
> +		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> +		mutex_unlock(&ionic->dev_cmd_lock);
> +
> +		msleep(20);
> +	} while (time_before(jiffies, end_time) && (err == -EAGAIN || err == -ETIMEDOUT));
> +
> +	if (err == -EAGAIN || err == -ETIMEDOUT) {
> +		NL_SET_ERR_MSG_MOD(extack, "Firmware wait timed out");
> +		dev_err(ionic->dev, "DEV_CMD firmware wait %s timed out\n", label);
> +	} else if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Firmware wait failed");
> +	}
> +
> +	return err;
> +}
> +
> +int ionic_firmware_update(struct ionic_lif *lif, const char *fw_name,
> +			  struct netlink_ext_ack *extack)
> +{
> +	struct ionic_dev *idev = &lif->ionic->idev;
> +	struct net_device *netdev = lif->netdev;
> +	struct ionic *ionic = lif->ionic;
> +	union ionic_dev_cmd_comp comp;
> +	u32 buf_sz, copy_sz, offset;
> +	const struct firmware *fw;
> +	struct devlink *dl;
> +	int next_interval;
> +	int err = 0;
> +	u8 fw_slot;
> +
> +	netdev_info(netdev, "Installing firmware %s\n", fw_name);
> +
> +	dl = priv_to_devlink(ionic);
> +	devlink_flash_update_begin_notify(dl);
> +	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
> +
> +	err = request_firmware(&fw, fw_name, ionic->dev);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Unable to find firmware file");
> +		goto err_out;
> +	}
> +
> +	buf_sz = sizeof(idev->dev_cmd_regs->data);
> +
> +	netdev_dbg(netdev,
> +		   "downloading firmware - size %d part_sz %d nparts %lu\n",
> +		   (int)fw->size, buf_sz, DIV_ROUND_UP(fw->size, buf_sz));
> +
> +	offset = 0;
> +	next_interval = 0;
> +	while (offset < fw->size) {
> +		if (offset >= next_interval) {
> +			devlink_flash_update_status_notify(dl, "Downloading", NULL,
> +							   offset, fw->size);
> +			next_interval = offset + (fw->size / IONIC_FW_INTERVAL_FRACTION);
> +		}
> +
> +		copy_sz = min_t(unsigned int, buf_sz, fw->size - offset);
> +		mutex_lock(&ionic->dev_cmd_lock);
> +		memcpy_toio(&idev->dev_cmd_regs->data, fw->data + offset, copy_sz);
> +		ionic_dev_cmd_firmware_download(idev,
> +						offsetof(union ionic_dev_cmd_regs, data),
> +						offset, copy_sz);
> +		err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> +		mutex_unlock(&ionic->dev_cmd_lock);
> +		if (err) {
> +			netdev_err(netdev,
> +				   "download failed offset 0x%x addr 0x%lx len 0x%x\n",
> +				   offset, offsetof(union ionic_dev_cmd_regs, data),
> +				   copy_sz);
> +			NL_SET_ERR_MSG_MOD(extack, "Segment download failed");
> +			goto err_out;
> +		}
> +		offset += copy_sz;
> +	}
> +	devlink_flash_update_status_notify(dl, "Downloading", NULL,
> +					   fw->size, fw->size);
> +

I'm a little surprised to see these one-after-the-other here. Oh, this
first one is to complete the download message above. Ok, that makes sense.

> +	devlink_flash_update_timeout_notify(dl, "Installing", NULL,
> +					    IONIC_FW_INSTALL_TIMEOUT);
> +
> +	mutex_lock(&ionic->dev_cmd_lock);
> +	ionic_dev_cmd_firmware_install(idev);
> +	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> +	ionic_dev_cmd_comp(idev, (union ionic_dev_cmd_comp *)&comp);
> +	fw_slot = comp.fw_control.slot;
> +	mutex_unlock(&ionic->dev_cmd_lock);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware install");
> +		goto err_out;
> +	}
> +
> +	err = ionic_fw_status_long_wait(ionic, "Installing",
> +					IONIC_FW_INSTALL_TIMEOUT,
> +					IONIC_FW_INSTALL_STATUS,
> +					extack);
> +	if (err)
> +		goto err_out;
> +
> +	devlink_flash_update_timeout_notify(dl, "Selecting", NULL,
> +					    IONIC_FW_SELECT_TIMEOUT);
> +
> +	mutex_lock(&ionic->dev_cmd_lock);
> +	ionic_dev_cmd_firmware_activate(idev, fw_slot);
> +	err = ionic_dev_cmd_wait(ionic, DEVCMD_TIMEOUT);
> +	mutex_unlock(&ionic->dev_cmd_lock);
> +	if (err) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to start firmware select");
> +		goto err_out;
> +	}
> +
> +	err = ionic_fw_status_long_wait(ionic, "Selecting",
> +					IONIC_FW_SELECT_TIMEOUT,
> +					IONIC_FW_ACTIVATE_STATUS,
> +					extack);
> +	if (err)
> +		goto err_out;
> +
> +	netdev_info(netdev, "Firmware update completed\n");
> +
> +err_out:
> +	if (err)
> +		devlink_flash_update_status_notify(dl, "Flash failed", NULL, 0, 0);
> +	else
> +		devlink_flash_update_status_notify(dl, "Flash done", NULL, 0, 0);
> +	release_firmware(fw);
> +	devlink_flash_update_end_notify(dl);
> +	return err;
> +}
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> index 99e9dd15a303..e339216949a6 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -335,17 +335,22 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
>  	 */
>  	max_wait = jiffies + (max_seconds * HZ);
>  try_again:
> +	opcode = idev->dev_cmd_regs->cmd.cmd.opcode;
>  	start_time = jiffies;
>  	do {
>  		done = ionic_dev_cmd_done(idev);
>  		if (done)
>  			break;
> -		msleep(5);
> -		hb = ionic_heartbeat_check(ionic);
> +		usleep_range(100, 200);
> +
> +		/* Don't check the heartbeat on FW_CONTROL commands as they are
> +		 * notorious for interrupting the firmware's heartbeat update.
> +		 */
> +		if (opcode != IONIC_CMD_FW_CONTROL)
> +			hb = ionic_heartbeat_check(ionic);
>  	} while (!done && !hb && time_before(jiffies, max_wait));
>  	duration = jiffies - start_time;
>  
> -	opcode = idev->dev_cmd_regs->cmd.cmd.opcode;
>  	dev_dbg(ionic->dev, "DEVCMD %s (%d) done=%d took %ld secs (%ld jiffies)\n",
>  		ionic_opcode_to_str(opcode), opcode,
>  		done, duration / HZ, duration);
> @@ -369,8 +374,9 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
>  
>  	err = ionic_dev_cmd_status(&ionic->idev);
>  	if (err) {
> -		if (err == IONIC_RC_EAGAIN && !time_after(jiffies, max_wait)) {
> -			dev_err(ionic->dev, "DEV_CMD %s (%d) error, %s (%d) retrying...\n",
> +		if (err == IONIC_RC_EAGAIN &&
> +		    time_before(jiffies, (max_wait - HZ))) {
> +			dev_dbg(ionic->dev, "DEV_CMD %s (%d), %s (%d) retrying...\n",
>  				ionic_opcode_to_str(opcode), opcode,
>  				ionic_error_to_str(err), err);
>  
> @@ -380,9 +386,10 @@ int ionic_dev_cmd_wait(struct ionic *ionic, unsigned long max_seconds)
>  			goto try_again;
>  		}
>  
> -		dev_err(ionic->dev, "DEV_CMD %s (%d) error, %s (%d) failed\n",
> -			ionic_opcode_to_str(opcode), opcode,
> -			ionic_error_to_str(err), err);
> +		if (!(opcode == IONIC_CMD_FW_CONTROL && err == IONIC_RC_EAGAIN))
> +			dev_err(ionic->dev, "DEV_CMD %s (%d) error, %s (%d) failed\n",
> +				ionic_opcode_to_str(opcode), opcode,
> +				ionic_error_to_str(err), err);
>  
>  		return ionic_error_to_errno(err);
>  	}
> 
