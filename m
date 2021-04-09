Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB5C35A402
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbhDIQv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:51:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:10579 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234067AbhDIQv1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 12:51:27 -0400
IronPort-SDR: X1E5NPj7yT17qHTXiyJSoSO1vwcM2rC+9DJCJiqTw3t1EHx9s0TA001ezYF/6Y/ziuungouj0q
 sUbUk6XJ1Hgg==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="214236617"
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="214236617"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 09:51:14 -0700
IronPort-SDR: 7tKbdxLViKPA83RM8pfR8pjkGZ4Fd50GU8QHWDDSlil/YQKV+ax/+tbutzjR8omPHFWaU8aPkI
 g+jazIJis65w==
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="422809504"
Received: from samudral-mobl.amr.corp.intel.com (HELO [10.212.251.215]) ([10.212.251.215])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2021 09:51:13 -0700
Subject: Re: [RFC] net: core: devlink: add port_params_ops for devlink port
 parameters altering
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org, idosch@idosch.org, vadym.kochan@plvision.eu,
        Parav Pandit <parav@nvidia.com>
References: <20210409162247.4293-1-oleksandr.mazur@plvision.eu>
From:   "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Message-ID: <ce46643a-99ad-54e8-b5ed-b85ca35ecbcb@intel.com>
Date:   Fri, 9 Apr 2021 09:51:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210409162247.4293-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/9/2021 9:22 AM, Oleksandr Mazur wrote:
> I'd like to discuss a possibility of handling devlink port parameters
> with devlink port pointer supplied.
>
> Current design makes it impossible to distinguish which port's parameter
> should get altered (set) or retrieved (get) whenever there's a single
> parameter registered within a few ports.

I also noticed this issue recently when trying to add port parameters and
I have a patch that handles this in a different way. The ops in devlink_param
struct can be updated to include port_index as an argument

devlink: Fix devlink_param function pointers

devlink_param function pointers are used to register device parameters
as well as port parameters. So we need port_index also as an argument
to enable port specific parameters.

Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 57251d12b0fc..bf55acdf98ae 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -469,12 +469,12 @@ struct devlink_param {
         bool generic;
         enum devlink_param_type type;
         unsigned long supported_cmodes;
-       int (*get)(struct devlink *devlink, u32 id,
-                  struct devlink_param_gset_ctx *ctx);
-       int (*set)(struct devlink *devlink, u32 id,
-                  struct devlink_param_gset_ctx *ctx);
-       int (*validate)(struct devlink *devlink, u32 id,
-                       union devlink_param_value val,
+       int (*get)(struct devlink *devlink, unsigned int port_index,
+                  u32 id, struct devlink_param_gset_ctx *ctx);
+       int (*set)(struct devlink *devlink, unsigned int port_index,
+                  u32 id, struct devlink_param_gset_ctx *ctx);
+       int (*validate)(struct devlink *devlink, unsigned int port_index,
+                       u32 id, union devlink_param_value val,
                         struct netlink_ext_ack *extack);
  };

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 151f60af0c4a..65a819ead3d9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3826,21 +3826,23 @@ devlink_param_cmode_is_supported(const struct devlink_param *param,
  }

  static int devlink_param_get(struct devlink *devlink,
+                            unsigned int port_index,
                              const struct devlink_param *param,
                              struct devlink_param_gset_ctx *ctx)
  {
         if (!param->get)
                 return -EOPNOTSUPP;
-       return param->get(devlink, param->id, ctx);
+       return param->get(devlink, port_index, param->id, ctx);
  }

  static int devlink_param_set(struct devlink *devlink,
+                            unsigned int port_index,
                              const struct devlink_param *param,
                              struct devlink_param_gset_ctx *ctx)
  {
         if (!param->set)
                 return -EOPNOTSUPP;
-       return param->set(devlink, param->id, ctx);
+       return param->set(devlink, port_index, param->id, ctx);
  }

  static int
@@ -3941,7 +3943,8 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
                         if (!param_item->published)
                                 continue;
                         ctx.cmode = i;
-                       err = devlink_param_get(devlink, param, &ctx);
+                       err = devlink_param_get(devlink, port_index, param,
+                                               &ctx);
                         if (err)
                                 return err;
                         param_value[i] = ctx.val;
@@ -4216,7 +4219,8 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
         if (err)
                 return err;
         if (param->validate) {
-               err = param->validate(devlink, param->id, value, info->extack);
+               err = param->validate(devlink, port_index, param->id, value,
+                                     info->extack);
                 if (err)
                         return err;
         }
@@ -4238,7 +4242,7 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
                         return -EOPNOTSUPP;
                 ctx.val = value;
                 ctx.cmode = cmode;
-               err = devlink_param_set(devlink, param, &ctx);
+               err = devlink_param_set(devlink, port_index, param, &ctx);
                 if (err)
                         return err;
         }

>
> This patch aims to show how this can be changed:
>    - introduce structure port_params_ops that has callbacks for get/set/validate;
>    - if devlink has registered port_params_ops, then upon every devlink
>      port parameter get/set call invoke port parameters callback
>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
>   drivers/net/netdevsim/dev.c       | 46 +++++++++++++++++++++++++++++++
>   drivers/net/netdevsim/netdevsim.h |  1 +
>   include/net/devlink.h             | 11 ++++++++
>   net/core/devlink.c                | 16 ++++++++++-
>   4 files changed, 73 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index 6189a4c0d39e..4f9a3104ca46 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -39,6 +39,11 @@ static struct dentry *nsim_dev_ddir;
>   
>   #define NSIM_DEV_DUMMY_REGION_SIZE (1024 * 32)
>   
> +static int nsim_dev_port_param_set(struct devlink_port *port, u32 id,
> +				   struct devlink_param_gset_ctx *ctx);
> +static int nsim_dev_port_param_get(struct devlink_port *port, u32 id,
> +				   struct devlink_param_gset_ctx *ctx);
> +
>   static int
>   nsim_dev_take_snapshot(struct devlink *devlink,
>   		       const struct devlink_region_ops *ops,
> @@ -339,6 +344,7 @@ static int nsim_dev_resources_register(struct devlink *devlink)
>   enum nsim_devlink_param_id {
>   	NSIM_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
>   	NSIM_DEVLINK_PARAM_ID_TEST1,
> +	NSIM_DEVLINK_PARAM_ID_TEST2,
>   };
>   
>   static const struct devlink_param nsim_devlink_params[] = {
> @@ -349,6 +355,10 @@ static const struct devlink_param nsim_devlink_params[] = {
>   			     "test1", DEVLINK_PARAM_TYPE_BOOL,
>   			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
>   			     NULL, NULL, NULL),
> +	DEVLINK_PARAM_DRIVER(NSIM_DEVLINK_PARAM_ID_TEST2,
> +			     "test1", DEVLINK_PARAM_TYPE_U32,
> +			     BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
> +			     NULL, NULL, NULL),
>   };
>   
>   static void nsim_devlink_set_params_init_values(struct nsim_dev *nsim_dev,
> @@ -892,6 +902,11 @@ nsim_dev_devlink_trap_policer_counter_get(struct devlink *devlink,
>   	return 0;
>   }
>   
> +static const struct devlink_port_param_ops nsim_dev_port_param_ops = {
> +	.get = nsim_dev_port_param_get,
> +	.set = nsim_dev_port_param_set,
> +};
> +
>   static const struct devlink_ops nsim_dev_devlink_ops = {
>   	.supported_flash_update_params = DEVLINK_SUPPORT_FLASH_UPDATE_COMPONENT |
>   					 DEVLINK_SUPPORT_FLASH_UPDATE_OVERWRITE_MASK,
> @@ -905,6 +920,7 @@ static const struct devlink_ops nsim_dev_devlink_ops = {
>   	.trap_group_set = nsim_dev_devlink_trap_group_set,
>   	.trap_policer_set = nsim_dev_devlink_trap_policer_set,
>   	.trap_policer_counter_get = nsim_dev_devlink_trap_policer_counter_get,
> +	.port_param_ops = &nsim_dev_port_param_ops,
>   };
>   
>   #define NSIM_DEV_MAX_MACS_DEFAULT 32
> @@ -1239,6 +1255,36 @@ int nsim_dev_port_del(struct nsim_bus_dev *nsim_bus_dev,
>   	return err;
>   }
>   
> +static int nsim_dev_port_param_get(struct devlink_port *port, u32 id,
> +				   struct devlink_param_gset_ctx *ctx)
> +{
> +	struct nsim_dev *nsim_dev = devlink_priv(port->devlink);
> +	struct nsim_dev_port *nsim_port =
> +		__nsim_dev_port_lookup(nsim_dev, port->index);
> +
> +	if (id == NSIM_DEVLINK_PARAM_ID_TEST2) {
> +		ctx->val.vu32 = nsim_port->test_parameter_value;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
> +static int nsim_dev_port_param_set(struct devlink_port *port, u32 id,
> +				   struct devlink_param_gset_ctx *ctx)
> +{
> +	struct nsim_dev *nsim_dev = devlink_priv(port->devlink);
> +	struct nsim_dev_port *nsim_port =
> +		__nsim_dev_port_lookup(nsim_dev, port->index);
> +
> +	if (id == NSIM_DEVLINK_PARAM_ID_TEST2) {
> +		nsim_port->test_parameter_value = ctx->val.vu32;
> +		return 0;
> +	}
> +
> +	return -EINVAL;
> +}
> +
>   int nsim_dev_init(void)
>   {
>   	nsim_dev_ddir = debugfs_create_dir(DRV_NAME, NULL);
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> index 7ff24e03577b..4f5fc491c8d6 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -203,6 +203,7 @@ struct nsim_dev_port {
>   	unsigned int port_index;
>   	struct dentry *ddir;
>   	struct netdevsim *ns;
> +	u32 test_parameter_value;
>   };
>   
>   struct nsim_dev {
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 853420db5d32..85a7b9970496 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1189,6 +1189,16 @@ enum devlink_trap_group_generic_id {
>   		.min_burst = _min_burst,				      \
>   	}
>   
> +struct devlink_port_param_ops {
> +	int (*get)(struct devlink_port *port, u32 id,
> +		   struct devlink_param_gset_ctx *ctx);
> +	int (*set)(struct devlink_port *port, u32 id,
> +		   struct devlink_param_gset_ctx *ctx);
> +	int (*validate)(struct devlink_port *port, u32 id,
> +			union devlink_param_value val,
> +			struct netlink_ext_ack *extack);
> +};
> +
>   struct devlink_ops {
>   	/**
>   	 * @supported_flash_update_params:
> @@ -1451,6 +1461,7 @@ struct devlink_ops {
>   				 struct devlink_port *port,
>   				 enum devlink_port_fn_state state,
>   				 struct netlink_ext_ack *extack);
> +	struct devlink_port_param_ops *port_param_ops;
>   };
>   
>   static inline void *devlink_priv(struct devlink *devlink)
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 737b61c2976e..20f3545f4e7b 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -3918,6 +3918,7 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
>   				 enum devlink_command cmd,
>   				 u32 portid, u32 seq, int flags)
>   {
> +	struct devlink_port *dl_port;
>   	union devlink_param_value param_value[DEVLINK_PARAM_CMODE_MAX + 1];
>   	bool param_value_set[DEVLINK_PARAM_CMODE_MAX + 1] = {};
>   	const struct devlink_param *param = param_item->param;
> @@ -3941,7 +3942,20 @@ static int devlink_nl_param_fill(struct sk_buff *msg, struct devlink *devlink,
>   			if (!param_item->published)
>   				continue;
>   			ctx.cmode = i;
> -			err = devlink_param_get(devlink, param, &ctx);
> +			if ((cmd == DEVLINK_CMD_PORT_PARAM_GET ||
> +			    cmd == DEVLINK_CMD_PORT_PARAM_NEW ||
> +			    cmd == DEVLINK_CMD_PORT_PARAM_DEL) &&
> +			    devlink->ops->port_param_ops) {
> +
> +				dl_port = devlink_port_get_by_index(devlink,
> +								    port_index);
> +				err = devlink->ops->port_param_ops->get(dl_port,
> +									param->id,
> +									&ctx);
> +			} else {
> +				err = devlink_param_get(devlink, param, &ctx);
> +			}
> +
>   			if (err)
>   				return err;
>   			param_value[i] = ctx.val;

