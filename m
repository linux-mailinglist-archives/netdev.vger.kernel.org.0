Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B6926A4E4
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 14:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgIOMRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 08:17:50 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:18371 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgIOMMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 08:12:49 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f60af880000>; Tue, 15 Sep 2020 05:11:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 15 Sep 2020 05:12:39 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 15 Sep 2020 05:12:39 -0700
Received: from [10.21.180.139] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 15 Sep
 2020 12:12:28 +0000
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
To:     Jiri Pirko <jiri@resnulli.us>, Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-2-git-send-email-moshe@mellanox.com>
 <20200914122732.GE2236@nanopsycho.orion>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <996866b1-5472-dd95-f415-85c34c4d01c0@nvidia.com>
Date:   Tue, 15 Sep 2020 15:12:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200914122732.GE2236@nanopsycho.orion>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600171912; bh=93zH06n9j7eKgQYshkDcT1pzgysQuuh1mYc2wXgbh40=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Originating-IP:
         X-ClientProxiedBy;
        b=Pvqk5NwWYfoJYVYOvbf+qPq2dGDOWqpJZ4jzbzkDLyL1npF2xpCczPurw31/NxnS9
         v5lt/9541ZCP73/o2hUQ0h7xDkZfsk05dbve3cBJFbZT6j+BURTYAvQfbaZUaTlix9
         4gnpEMZ20Yh2BIrC+Ftx+YteJquLHRFUT934i8Gav5I+9btnAWQJNBxP0Q1JiDzz3Y
         BT1OGoj7VC67GVgbnrmePVncdLu/s3kMk6sChcW9965zgCc6W8liZAmuc1RIbqR/3l
         VL3HHpSj75cQBHLECLbQxXF7sXf3HqRQmNJwPKKLRICy+gnBv1F+k/zbUB2v6XfyGJ
         /X90z7wTXHaRQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/14/2020 3:27 PM, Jiri Pirko wrote:
> Mon, Sep 14, 2020 at 08:07:48AM CEST, moshe@mellanox.com wrote:
>> Add devlink reload action to allow the user to request a specific reload
>> action. The action parameter is optional, if not specified then devlink
>> driver re-init action is used (backward compatible).
>> Note that when required to do firmware activation some drivers may need
>> to reload the driver. On the other hand some drivers may need to reset
>> the firmware to reinitialize the driver entities. Therefore, the devlink
>> reload command returns the actions which were actually performed.
>> Reload actions supported are:
>> driver_reinit: driver entities re-initialization, applying devlink-param
>>                and devlink-resource values.
>> fw_activate: firmware activate.
>>
>> command examples:
>> $devlink dev reload pci/0000:82:00.0 action driver_reinit
>> reload_actions_performed:
>>   driver_reinit
>>
>> $devlink dev reload pci/0000:82:00.0 action fw_activate
>> reload_actions_performed:
>>   driver_reinit fw_activate
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> ---
>> v3 -> v4:
>> - Removed fw_activate_no_reset as an action (next patch adds limit
>>   levels instead).
>> - Renamed actions_done to actions_performed
>> v2 -> v3:
>> - Replace fw_live_patch action by fw_activate_no_reset
>> - Devlink reload returns the actions done over netlink reply
>> v1 -> v2:
>> - Instead of reload levels driver,fw_reset,fw_live_patch have reload
>>   actions driver_reinit,fw_activate,fw_live_patch
>> - Remove driver default level, the action driver_reinit is the default
>>   action for all drivers
>> ---
>> drivers/net/ethernet/mellanox/mlx4/main.c     |  14 ++-
>> .../net/ethernet/mellanox/mlx5/core/devlink.c |  15 ++-
>> drivers/net/ethernet/mellanox/mlxsw/core.c    |  25 ++--
>> drivers/net/netdevsim/dev.c                   |  16 ++-
>> include/net/devlink.h                         |   7 +-
>> include/uapi/linux/devlink.h                  |  19 +++
>> net/core/devlink.c                            | 111 +++++++++++++++++-
>> 7 files changed, 180 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
>> index 70cf24ba71e4..aadf1676a0ed 100644
>> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
>> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
>> @@ -3946,6 +3946,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
>> 			       struct devlink *devlink);
>>
>> static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
>> +				    enum devlink_reload_action action,
>> 				    struct netlink_ext_ack *extack)
>> {
>> 	struct mlx4_priv *priv = devlink_priv(devlink);
>> @@ -3962,8 +3963,8 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
>> 	return 0;
>> }
>>
>> -static int mlx4_devlink_reload_up(struct devlink *devlink,
>> -				  struct netlink_ext_ack *extack)
>> +static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
>> +				  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>> {
>> 	struct mlx4_priv *priv = devlink_priv(devlink);
>> 	struct mlx4_dev *dev = &priv->dev;
>> @@ -3971,15 +3972,20 @@ static int mlx4_devlink_reload_up(struct devlink *devlink,
>> 	int err;
>>
>> 	err = mlx4_restart_one_up(persist->pdev, true, devlink);
>> -	if (err)
>> +	if (err) {
>> 		mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=%d\n",
>> 			 err);
>> +		return err;
>> +	}
>> +	if (actions_performed)
> Nit, pass the unsigned long allways (even when it would be unused) and
> avoid check in every driver.
>

Ack.

>> +		*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
>>
>> -	return err;
>> +	return 0;
>> }
>>
>> static const struct devlink_ops mlx4_devlink_ops = {
>> 	.port_type_set	= mlx4_devlink_port_type_set,
>> +	.supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
>> 	.reload_down	= mlx4_devlink_reload_down,
>> 	.reload_up	= mlx4_devlink_reload_up,
>> };
> [..]
>
>
>> @@ -2969,29 +2975,72 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>> EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>>
>> static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>> -			  struct netlink_ext_ack *extack)
>> +			  enum devlink_reload_action action, struct netlink_ext_ack *extack,
>> +			  unsigned long *actions_performed)
>> {
>> 	int err;
>>
>> 	if (!devlink->reload_enabled)
>> 		return -EOPNOTSUPP;
>>
>> -	err = devlink->ops->reload_down(devlink, !!dest_net, extack);
>> +	err = devlink->ops->reload_down(devlink, !!dest_net, action, extack);
>> 	if (err)
>> 		return err;
>>
>> 	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>> 		devlink_reload_netns_change(devlink, dest_net);
>>
>> -	err = devlink->ops->reload_up(devlink, extack);
>> +	err = devlink->ops->reload_up(devlink, action, extack, actions_performed);
> Here, please add a WARN_ON() check:
> 	WARN_ON(!(*actions_performed & action));
>
> The requested action should be always performed.
>
Good point, I will add.
>> 	devlink_reload_failed_set(devlink, !!err);
>> 	return err;
>> }
>>
>> +static int
>> +devlink_nl_reload_actions_performed_fill(struct sk_buff *msg,
>> +					 struct devlink *devlink,
>> +					 unsigned long actions_performed,
>> +					 enum devlink_command cmd, u32 portid,
>> +					 u32 seq, int flags)
>> +{
>> +	struct nlattr *actions_performed_attr;
>> +	void *hdr;
>> +	int i;
>> +
>> +	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
>> +	if (!hdr)
>> +		return -EMSGSIZE;
>> +
>> +	if (devlink_nl_put_handle(msg, devlink))
>> +		goto genlmsg_cancel;
>> +
>> +	actions_performed_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED);
>> +	if (!actions_performed_attr)
>> +		goto genlmsg_cancel;
>> +
>> +	for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
>> +		if (!test_bit(i, &actions_performed))
>> +			continue;
>> +		if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, i))
>> +			goto actions_performed_nest_cancel;
>> +	}
>> +	nla_nest_end(msg, actions_performed_attr);
>> +	genlmsg_end(msg, hdr);
>> +	return 0;
>> +
>> +actions_performed_nest_cancel:
>> +	nla_nest_cancel(msg, actions_performed_attr);
>> +genlmsg_cancel:
>> +	genlmsg_cancel(msg, hdr);
>> +	return -EMSGSIZE;
>> +}
>> +
>> static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>> {
>> 	struct devlink *devlink = info->user_ptr[0];
>> +	enum devlink_reload_action action;
>> +	unsigned long actions_performed;
>> 	struct net *dest_net = NULL;
>> +	struct sk_buff *msg;
>> 	int err;
>>
>> 	if (!devlink_reload_supported(devlink))
>> @@ -3011,12 +3060,41 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>> 			return PTR_ERR(dest_net);
>> 	}
>>
>> -	err = devlink_reload(devlink, dest_net, info->extack);
>> +	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
>> +		action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
>> +	else
>> +		action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
>> +
>> +	if (action == DEVLINK_RELOAD_ACTION_UNSPEC || action > DEVLINK_RELOAD_ACTION_MAX) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Invalid reload action");
> Hmm, I understand the unspec check, but the max check is not needed. The
> following check will take care of it.
>
Ack.
>> +		return -EINVAL;
>> +	} else if (!devlink_reload_action_is_supported(devlink, action)) {
>> +		NL_SET_ERR_MSG_MOD(info->extack, "Requested reload action is not supported");
> ".. by the driver" ?
> 	


Yes, will fix.

>> +		return -EOPNOTSUPP;
>> +	}
>> +
>> +	err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);
>>
>> 	if (dest_net)
>> 		put_net(dest_net);
>>
>> -	return err;
>> +	if (err)
>> +		return err;
>> +
>> +	WARN_ON(!actions_performed);
>> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +	if (!msg)
>> +		return -ENOMEM;
>> +
>> +	err = devlink_nl_reload_actions_performed_fill(msg, devlink, actions_performed,
>> +						       DEVLINK_CMD_RELOAD, info->snd_portid,
>> +						       info->snd_seq, 0);
>> +	if (err) {
>> +		nlmsg_free(msg);
>> +		return err;
>> +	}
>> +
>> +	return genlmsg_reply(msg, info);
>> }
>>
>> static int devlink_nl_flash_update_fill(struct sk_buff *msg,
>> @@ -7047,6 +7125,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>> 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
>> 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
>> 	[DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
>> +	[DEVLINK_ATTR_RELOAD_ACTION] = { .type = NLA_U8 },
>> };
>>
>> static const struct genl_ops devlink_nl_ops[] = {
>> @@ -7372,6 +7451,20 @@ static struct genl_family devlink_nl_family __ro_after_init = {
>> 	.n_mcgrps	= ARRAY_SIZE(devlink_nl_mcgrps),
>> };
>>
>> +static int devlink_reload_actions_verify(struct devlink *devlink)
>> +{
>> +	const struct devlink_ops *ops;
>> +
>> +	if (!devlink_reload_supported(devlink))
> If reload is not supported, the supported_reload_actions should be 0.
> Please check that with WARN_ON too.
>
OK, same goes to supported limit levels.
>> +		return 0;
>> +
>> +	ops = devlink->ops;
>> +	if (WARN_ON(ops->supported_reload_actions >= BIT(__DEVLINK_RELOAD_ACTION_MAX) ||
>> +		    ops->supported_reload_actions <= BIT(DEVLINK_RELOAD_ACTION_UNSPEC)))
>> +		return -EINVAL;
>> +	return 0;
>> +}
>> +
>> /**
>>   *	devlink_alloc - Allocate new devlink instance resources
>>   *
>> @@ -7392,6 +7485,11 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
>> 	if (!devlink)
>> 		return NULL;
>> 	devlink->ops = ops;
>> +	if (devlink_reload_actions_verify(devlink)) {
> Move this check to the beginning. You don't need devlink instance for
> the check, just ops.


Right, will fix.

> also, your devlink_reload_actions_verify() function returns
> 0/-ESOMETHING. Treat it accordingly here.


Well, yes, but I rather return NULL here since devlink_alloc() failed. 
If devlink_reload_actions_verify() fails it has WARN_ON which will lead 
the driver developer to his bug.

>
>> +		kfree(devlink);
>> +		return NULL;
>> +	}
>> +
>> 	xa_init_flags(&devlink->snapshot_ids, XA_FLAGS_ALLOC);
>> 	__devlink_net_set(devlink, &init_net);
>> 	INIT_LIST_HEAD(&devlink->port_list);
>> @@ -9657,7 +9755,8 @@ static void __net_exit devlink_pernet_pre_exit(struct net *net)
>> 		if (net_eq(devlink_net(devlink), net)) {
>> 			if (WARN_ON(!devlink_reload_supported(devlink)))
>> 				continue;
>> -			err = devlink_reload(devlink, &init_net, NULL);
>> +			err = devlink_reload(devlink, &init_net,
>> +					     DEVLINK_RELOAD_ACTION_DRIVER_REINIT, NULL, NULL);
>> 			if (err && err != -EOPNOTSUPP)
>> 				pr_warn("Failed to reload devlink instance into init_net\n");
>> 		}
>> -- 
>> 2.17.1
>>
