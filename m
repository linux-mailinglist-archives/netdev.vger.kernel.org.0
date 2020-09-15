Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1775426A55B
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 14:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgIOMit (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 08:38:49 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:3477 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbgIOMib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 08:38:31 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f60b5960004>; Tue, 15 Sep 2020 05:37:42 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 05:38:30 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 15 Sep 2020 05:38:30 -0700
Received: from [10.21.180.139] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 12:38:19 +0000
Subject: Re: [PATCH net-next RFC v4 10/15] net/mlx5: Add support for devlink
 reload action fw activate
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-11-git-send-email-moshe@mellanox.com>
 <20200914135251.GI2236@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <33e78e4a-3e62-feca-e0e7-84ae846fa32d@nvidia.com>
Date:   Tue, 15 Sep 2020 15:38:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914135251.GI2236@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600173462; bh=eUVH0GLHb9g/QgPCpl3usd4v7sCQaq3NoKCPCZ5ztGs=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=L3JOOraqBM7ZXPnEn3agUHlquI5pwBpHoZQLdqINH7pjvo8D1alfvvMcw/YOqcqWc
         Em7YXKkGrkQ6igPTzE8U2REJ3A/rDyTwGWG7tDh7jsLRgXvSd78HUjb4hAYpv9GRMb
         lc7lIjYgaTy1wCWnbrFyMLF4FPTI53cy4FdcdQh1Wt9ceztE0xJjBiI+fQcq/2B23b
         ngU8sqwUNNjnHs4FLnvmhamy0WNrxwPZ5RAWhrr+zirBSQh1mdZWfsuaqDJo5qUYm7
         aigRsSP1Cem/d8bw11fglmuk4vN8kOK1yxqci7cZl4hd73bSaoBuOL9HzpukifKW7S
         NEDyoimV1d6Xw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/14/2020 4:52 PM, Jiri Pirko wrote:
> Mon, Sep 14, 2020 at 08:07:57AM CEST, moshe@mellanox.com wrote:
>> Add support for devlink reload action fw_activate. To activate firmware
>> image the mlx5 driver resets the firmware and reloads it from flash. If
>> a new image was stored on flash it will be loaded. Once this reload
>> command is executed the driver initiates fw sync reset flow, where the
>> firmware synchronizes all PFs on coming reset and driver reload.
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> v3 -> v4:
>> - Renamed actions_done to actions_performed
>> v2 -> v3:
>> - Return the reload actions done
>> - Update reload action counters if reset initiated by remote host
>> v1 -> v2:
>> - Have fw_activate action instead of fw_reset level
>> ---
>> .../net/ethernet/mellanox/mlx5/core/devlink.c | 62 ++++++++++++++++---
>> .../ethernet/mellanox/mlx5/core/fw_reset.c    | 60 ++++++++++++++++--
>> .../ethernet/mellanox/mlx5/core/fw_reset.h    |  1 +
>> 3 files changed, 109 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>> index f6b29deaf02e..fa8f6abbea4e 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
>> @@ -4,6 +4,7 @@
>> #include <devlink.h>
>>
>> #include "mlx5_core.h"
>> +#include "fw_reset.h"
>> #include "fs_core.h"
>> #include "eswitch.h"
>>
>> @@ -88,6 +89,32 @@ mlx5_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
>> 	return 0;
>> }
>>
>> +static int mlx5_devlink_reload_fw_activate(struct devlink *devlink, struct netlink_ext_ack *extack)
>> +{
>> +	struct mlx5_core_dev *dev = devlink_priv(devlink);
>> +	u8 reset_level, reset_type, net_port_alive;
>> +	int err;
>> +
>> +	err = mlx5_reg_mfrl_query(dev, &reset_level, &reset_type);
>> +	if (err)
>> +		return err;
>> +	if (!(reset_level & MLX5_MFRL_REG_RESET_LEVEL3)) {
>> +		NL_SET_ERR_MSG_MOD(extack, "FW activate requires reboot");
>> +		return -EINVAL;
>> +	}
>> +
>> +	net_port_alive = !!(reset_type & MLX5_MFRL_REG_RESET_TYPE_NET_PORT_ALIVE);
>> +	err = mlx5_fw_set_reset_sync(dev, net_port_alive);
>> +	if (err)
>> +		goto out;
>> +
>> +	err = mlx5_fw_wait_fw_reset_done(dev);
>> +out:
>> +	if (err)
>> +		NL_SET_ERR_MSG_MOD(extack, "FW activate command failed");
>> +	return err;
>> +}
>> +
>> static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
>> 				    enum devlink_reload_action action,
>> 				    enum devlink_reload_action_limit_level limit_level,
>> @@ -95,8 +122,17 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
>> {
>> 	struct mlx5_core_dev *dev = devlink_priv(devlink);
>>
>> -	mlx5_unload_one(dev, false);
>> -	return 0;
>> +	switch (action) {
>> +	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
>> +		mlx5_unload_one(dev, false);
>> +		return 0;
>> +	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
>> +		return mlx5_devlink_reload_fw_activate(devlink, extack);
>> +	default:
>> +		/* Unsupported action should not get to this function */
>> +		WARN_ON(1);
>> +		return -EOPNOTSUPP;
>> +	}
>> }
>>
>> static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
>> @@ -104,13 +140,22 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
>> 				  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>> {
>> 	struct mlx5_core_dev *dev = devlink_priv(devlink);
>> -	int err;
>>
>> -	err = mlx5_load_one(dev, false);
>> -	if (err)
>> -		return err;
>> 	if (actions_performed)
>> -		*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
>> +		*actions_performed = BIT(action);
>> +
>> +	switch (action) {
>> +	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
>> +	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
>> +		/* On fw_activate action, also driver is reloaded and reinit performed */
>> +		if (actions_performed)
>> +			*actions_performed |= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
> You should set DEVLINK_RELOAD_ACTION_FW_ACTIVATE bit in actions_performed
> upon activation.
>

I have set it before the switch. As this is reload_up() in mlx5 only 
driver_up(), only driver up left to complete these actions. Also 
devlink_reload() will ignore the returned value of actions_performed if 
devlink_reload_up() failed.

>> +		return mlx5_load_one(dev, false);
>> +	default:
>> +		/* Unsupported action should not get to this function */
>> +		WARN_ON(1);
>> +		return -EOPNOTSUPP;
>> +	}
>>
>> 	return 0;
>> }
>> @@ -128,7 +173,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
>> #endif
>> 	.flash_update = mlx5_devlink_flash_update,
>> 	.info_get = mlx5_devlink_info_get,
>> -	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
>> +	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>> +				    BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE),
>> 	.supported_reload_action_limit_levels = BIT(DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE),
>> 	.reload_down = mlx5_devlink_reload_down,
>> 	.reload_up = mlx5_devlink_reload_up,
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
>> index 61237f4836cc..550f67b00473 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
>> @@ -5,6 +5,7 @@
>>
>> enum {
>> 	MLX5_FW_RESET_FLAGS_RESET_REQUESTED,
>> +	MLX5_FW_RESET_FLAGS_PENDING_COMP
>> };
>>
>> struct mlx5_fw_reset {
>> @@ -17,6 +18,8 @@ struct mlx5_fw_reset {
>> 	struct work_struct reset_abort_work;
>> 	unsigned long reset_flags;
>> 	struct timer_list timer;
>> +	struct completion done;
>> +	int ret;
>> };
>>
>> static int mlx5_reg_mfrl_set(struct mlx5_core_dev *dev, u8 reset_level,
>> @@ -53,7 +56,14 @@ int mlx5_reg_mfrl_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
>>
>> int mlx5_fw_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel)
>> {
>> -	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, reset_type_sel, 0, true);
>> +	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
>> +	int err;
>> +
>> +	set_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
>> +	err =  mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, reset_type_sel, 0, true);
>> +	if (err)
>> +		clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
>> +	return err;
>> }
>>
>> int mlx5_fw_set_live_patch(struct mlx5_core_dev *dev)
>> @@ -66,19 +76,36 @@ static int mlx5_fw_set_reset_sync_ack(struct mlx5_core_dev *dev)
>> 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, 0, 1, false);
>> }
>>
>> +static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
>> +{
>> +	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
>> +
>> +	/* if this is the driver that initiated the fw reset, devlink completed the reload */
>> +	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
>> +		complete(&fw_reset->done);
>> +	} else {
>> +		mlx5_load_one(dev, false);
>> +		devlink_reload_implicit_actions_performed(priv_to_devlink(dev),
>> +							  DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
>> +							  BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
>> +							  BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
>> +	}
>> +}
>> +
>> static void mlx5_sync_reset_reload_work(struct work_struct *work)
>> {
>> 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
>> 						      reset_reload_work);
>> 	struct mlx5_core_dev *dev = fw_reset->dev;
>> +	int err;
>>
>> 	mlx5_enter_error_state(dev, true);
>> 	mlx5_unload_one(dev, false);
>> -	if (mlx5_health_wait_pci_up(dev)) {
>> +	err = mlx5_health_wait_pci_up(dev);
>> +	if (err)
>> 		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
>> -		return;
>> -	}
>> -	mlx5_load_one(dev, false);
>> +	fw_reset->ret = err;
>> +	mlx5_fw_reset_complete_reload(dev);
>> }
>>
>> static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
>> @@ -264,7 +291,8 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
>> done:
>> 	if (err)
>> 		mlx5_start_health_poll(dev);
>> -	mlx5_load_one(dev, false);
>> +	fw_reset->ret = err;
>> +	mlx5_fw_reset_complete_reload(dev);
>> }
>>
>> static void mlx5_sync_reset_abort_event(struct work_struct *work)
>> @@ -313,6 +341,25 @@ static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long acti
>> 	return NOTIFY_OK;
>> }
>>
>> +#define MLX5_FW_RESET_TIMEOUT_MSEC 5000
>> +int mlx5_fw_wait_fw_reset_done(struct mlx5_core_dev *dev)
>> +{
>> +	unsigned long timeout = msecs_to_jiffies(MLX5_FW_RESET_TIMEOUT_MSEC);
>> +	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
>> +	int err;
>> +
>> +	if (!wait_for_completion_timeout(&fw_reset->done, timeout)) {
>> +		mlx5_core_warn(dev, "FW sync reset timeout after %d seconds\n",
>> +			       MLX5_FW_RESET_TIMEOUT_MSEC / 1000);
>> +		err = -ETIMEDOUT;
>> +		goto out;
>> +	}
>> +	err = fw_reset->ret;
>> +out:
>> +	clear_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags);
>> +	return err;
>> +}
>> +
>> int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev)
>> {
>> 	struct mlx5_fw_reset *fw_reset = kzalloc(sizeof(*fw_reset), GFP_KERNEL);
>> @@ -336,6 +383,7 @@ int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev)
>> 	MLX5_NB_INIT(&fw_reset->nb, fw_reset_event_notifier, GENERAL_EVENT);
>> 	mlx5_eq_notifier_register(dev, &fw_reset->nb);
>>
>> +	init_completion(&fw_reset->done);
>> 	return 0;
>> }
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
>> index 278f538ea92a..d7ee951a2258 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
>> @@ -10,6 +10,7 @@ int mlx5_reg_mfrl_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
>> int mlx5_fw_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel);
>> int mlx5_fw_set_live_patch(struct mlx5_core_dev *dev);
>>
>> +int mlx5_fw_wait_fw_reset_done(struct mlx5_core_dev *dev);
>> int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev);
>> void mlx5_fw_reset_events_cleanup(struct mlx5_core_dev *dev);
>>
>> -- 
>> 2.17.1
>>
