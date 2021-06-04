Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDD1839AFE8
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 03:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhFDBgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 21:36:22 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3535 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbhFDBgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 21:36:21 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Fx4xG43JBzYsCB;
        Fri,  4 Jun 2021 09:31:46 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 09:34:31 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 4 Jun 2021
 09:34:31 +0800
Subject: Re: [PATCH RESEND iproute2-next] devlink: Add optional controller
 user input
To:     Parav Pandit <parav@nvidia.com>, <dsahern@gmail.com>,
        <stephen@networkplumber.org>, <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, moyufeng <moyufeng@huawei.com>,
        "Jakub Kicinski" <kuba@kernel.org>
References: <20210603111901.9888-1-parav@nvidia.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <c50ebdd6-a388-4d39-4052-50b4966def2e@huawei.com>
Date:   Fri, 4 Jun 2021 09:34:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210603111901.9888-1-parav@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/6/3 19:19, Parav Pandit wrote:
> A user optionally provides the external controller number when user
> wants to create devlink port for the external controller.

Hi, Parav
   I was planing to use controller id to solve the devlink
instance representing problem for multi-function which shares
common resource in the same ASIC, see [1].

It seems the controller id used here is to differentiate the
function used in different host?

1. https://lkml.org/lkml/2021/5/31/296

> 
> An example on eswitch system:
> $ devlink dev eswitch set pci/0033:01:00.0 mode switchdev
> 
> $ devlink port show
> pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour physical port 0 splittable false
> 
> $ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77 controller 1
> pci/0033:01:00.0/163840: type eth netdev eth0 flavour pcisf controller 1 pfnum 0 sfnum 77 external true splittable false
>   function:
>     hw_addr 00:00:00:00:00:00 state inactive opstate detached
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  devlink/devlink.c       | 17 ++++++++++++++---
>  man/man8/devlink-port.8 | 19 +++++++++++++++++++
>  2 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index 0b5548fb..170e8616 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -286,6 +286,7 @@ static void ifname_map_free(struct ifname_map *ifname_map)
>  #define DL_OPT_PORT_PFNUMBER BIT(43)
>  #define DL_OPT_PORT_SFNUMBER BIT(44)
>  #define DL_OPT_PORT_FUNCTION_STATE BIT(45)
> +#define DL_OPT_PORT_CONTROLLER BIT(46)
>  
>  struct dl_opts {
>  	uint64_t present; /* flags of present items */
> @@ -336,6 +337,7 @@ struct dl_opts {
>  	uint32_t overwrite_mask;
>  	enum devlink_reload_action reload_action;
>  	enum devlink_reload_limit reload_limit;
> +	uint32_t port_controller;
>  	uint32_t port_sfnumber;
>  	uint16_t port_flavour;
>  	uint16_t port_pfnumber;
> @@ -1886,6 +1888,12 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
>  			if (err)
>  				return err;
>  			o_found |= DL_OPT_PORT_SFNUMBER;
> +		} else if (dl_argv_match(dl, "controller") && (o_all & DL_OPT_PORT_CONTROLLER)) {
> +			dl_arg_inc(dl);
> +			err = dl_argv_uint32_t(dl, &opts->port_controller);
> +			if (err)
> +				return err;
> +			o_found |= DL_OPT_PORT_CONTROLLER;
>  		} else {
>  			pr_err("Unknown option \"%s\"\n", dl_argv(dl));
>  			return -EINVAL;
> @@ -2079,6 +2087,9 @@ static void dl_opts_put(struct nlmsghdr *nlh, struct dl *dl)
>  		mnl_attr_put_u16(nlh, DEVLINK_ATTR_PORT_PCI_PF_NUMBER, opts->port_pfnumber);
>  	if (opts->present & DL_OPT_PORT_SFNUMBER)
>  		mnl_attr_put_u32(nlh, DEVLINK_ATTR_PORT_PCI_SF_NUMBER, opts->port_sfnumber);
> +	if (opts->present & DL_OPT_PORT_CONTROLLER)
> +		mnl_attr_put_u32(nlh, DEVLINK_ATTR_PORT_CONTROLLER_NUMBER,
> +				 opts->port_controller);
>  }
>  
>  static int dl_argv_parse_put(struct nlmsghdr *nlh, struct dl *dl,
> @@ -3795,7 +3806,7 @@ static void cmd_port_help(void)
>  	pr_err("       devlink port param set DEV/PORT_INDEX name PARAMETER value VALUE cmode { permanent | driverinit | runtime }\n");
>  	pr_err("       devlink port param show [DEV/PORT_INDEX name PARAMETER]\n");
>  	pr_err("       devlink port health show [ DEV/PORT_INDEX reporter REPORTER_NAME ]\n");
> -	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
> +	pr_err("       devlink port add DEV/PORT_INDEX flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ] [ controller CNUM ]\n");
>  	pr_err("       devlink port del DEV/PORT_INDEX\n");
>  }
>  
> @@ -4324,7 +4335,7 @@ static int __cmd_health_show(struct dl *dl, bool show_device, bool show_port);
>  
>  static void cmd_port_add_help(void)
>  {
> -	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ]\n");
> +	pr_err("       devlink port add { DEV | DEV/PORT_INDEX } flavour FLAVOUR pfnum PFNUM [ sfnum SFNUM ] [ controller CNUM ]\n");
>  }
>  
>  static int cmd_port_add(struct dl *dl)
> @@ -4342,7 +4353,7 @@ static int cmd_port_add(struct dl *dl)
>  
>  	err = dl_argv_parse_put(nlh, dl, DL_OPT_HANDLE | DL_OPT_HANDLEP |
>  				DL_OPT_PORT_FLAVOUR | DL_OPT_PORT_PFNUMBER,
> -				DL_OPT_PORT_SFNUMBER);
> +				DL_OPT_PORT_SFNUMBER | DL_OPT_PORT_CONTROLLER);
>  	if (err)
>  		return err;
>  
> diff --git a/man/man8/devlink-port.8 b/man/man8/devlink-port.8
> index 563c5833..a5142c4e 100644
> --- a/man/man8/devlink-port.8
> +++ b/man/man8/devlink-port.8
> @@ -54,6 +54,8 @@ devlink-port \- devlink port configuration
>  .IR PFNUMBER " ]"
>  .RB "{ " pcisf
>  .IR SFNUMBER " }"
> +.RB "{ " controller
> +.IR CNUM " }"
>  .br
>  
>  .ti -8
> @@ -174,6 +176,12 @@ Specifies sfnumber to assign to the device of the SF.
>  This field is optional for those devices which supports auto assignment of the
>  SF number.
>  
> +.TP
> +.BR controller " { " controller " } "
> +Specifies controller number for which the SF port is created.
> +This field is optional. It is used only when SF port is created for the
> +external controller.
> +
>  .ti -8
>  .SS devlink port function set - Set the port function attribute(s).
>  
> @@ -327,6 +335,17 @@ devlink dev param set pci/0000:01:00.0/1 name internal_error_reset value true cm
>  .RS 4
>  Sets the parameter internal_error_reset of specified devlink port (#1) to true.
>  .RE
> +.PP
> +devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88 controller 1
> +.RS 4
> +Add a devlink port of flavour PCI SF on controller 1 which has PCI PF of number
> +0 with SF number 88. To make use of the function an example sequence is to add
> +a port, configure the function attribute and activate the function. Once
> +the function usage is completed, deactivate the function and finally delete
> +the port. When there is desire to reuse the port without deletion, it can be
> +reconfigured and activated again when function is in inactive state and
> +function's operational state is detached.
> +.RE
>  
>  .SH SEE ALSO
>  .BR devlink (8),
> 

