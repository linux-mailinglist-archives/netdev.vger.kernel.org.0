Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C892F283EE2
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 20:39:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgJESjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 14:39:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:36096 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728361AbgJESjr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 14:39:47 -0400
IronPort-SDR: gSNmcYB5C3cDTzBcLvHH8U6FRAQ4LXL3mQtS3e9D8bfCzsujc20S15h6u8XiyXgx2kcS0w1v/9
 Ec1nquDqq2Xw==
X-IronPort-AV: E=McAfee;i="6000,8403,9765"; a="151132420"
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="151132420"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:39:36 -0700
IronPort-SDR: ib32QZLkaSeTUwpHWrPlfiVHb76oMasOB0NozT9SS6fn1suNQH7+spXpkFIJFVivIIdVe/Ssw/
 l4de97buw8ZQ==
X-IronPort-AV: E=Sophos;i="5.77,340,1596524400"; 
   d="scan'208";a="310158080"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.255.65.178]) ([10.255.65.178])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2020 11:39:35 -0700
Subject: Re: [PATCH net-next 02/16] devlink: Add reload action option to
 devlink reload command
To:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
 <1601560759-11030-3-git-send-email-moshe@mellanox.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <4e4e389c-704f-84f9-e69c-57ce5e9e2df7@intel.com>
Date:   Mon, 5 Oct 2020 11:39:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <1601560759-11030-3-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/1/2020 6:59 AM, Moshe Shemesh wrote:
> Add devlink reload action to allow the user to request a specific reload
> action. The action parameter is optional, if not specified then devlink
> driver re-init action is used (backward compatible).
> Note that when required to do firmware activation some drivers may need
> to reload the driver. On the other hand some drivers may need to reset
> the firmware to reinitialize the driver entities. Therefore, the devlink
> reload command returns the actions which were actually performed.
> Reload actions supported are:
> driver_reinit: driver entities re-initialization, applying devlink-param
>                and devlink-resource values.
> fw_activate: firmware activate.
> 
> command examples:
> $devlink dev reload pci/0000:82:00.0 action driver_reinit
> reload_actions_performed:
>   driver_reinit
> 
> $devlink dev reload pci/0000:82:00.0 action fw_activate
> reload_actions_performed:
>   driver_reinit fw_activate
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Looks straight forward.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> ---
> RFCv5 -> v1:
> - Rename supported_reload_actions to reload_actions.
> - Rename devlink_nl_reload_actions_performed_fill() to
> devlink_nl_reload_actions_performed_snd() and add genlmsg_reply() to it
> - Actions_performed sent to user space as a mask
> - Driver can initialize actions_performed before done as devlink ignores
> in case of failure
> - Use nla_poilcy range validation and remove the range check in
> devlink_nl_cmd_reload
> RFCv4 -> RFCv5:
> - Always pass actions_performed to unload_up() instead of checking in
>   each driver
> - Verify returned actions_performed includes the requested action
> - Changed  devlink_reload_actions_verify(devlink) to get ops
> - Changed  devlink_reload_actions_verify() to return bool and rename to
>   devlink_reload_actions_valid()
> -  Only generate the reply if request uses new attributes
> RFCv3 -> RFCv4:
> - Removed fw_activate_no_reset as an action (next patch adds limit
>   levels instead).
> - Renamed actions_done to actions_performed
> RFCv2 -> RFCv3:
> - Replace fw_live_patch action by fw_activate_no_reset
> - Devlink reload returns the actions done over netlink reply
> RFCv1 -> RFCv2:
> - Instead of reload levels driver,fw_reset,fw_live_patch have reload
>   actions driver_reinit,fw_activate,fw_live_patch
> - Remove driver default level, the action driver_reinit is the default
>   action for all drivers
> ---
>  drivers/net/ethernet/mellanox/mlx4/main.c     |   7 +-
>  .../net/ethernet/mellanox/mlx5/core/devlink.c |   7 +-
>  drivers/net/ethernet/mellanox/mlxsw/core.c    |  11 +-
>  drivers/net/netdevsim/dev.c                   |   8 +-
>  include/net/devlink.h                         |   7 +-
>  include/uapi/linux/devlink.h                  |  18 ++++
>  net/core/devlink.c                            | 101 ++++++++++++++++--
>  7 files changed, 139 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
> index 70cf24ba71e4..a44d8b733db3 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/main.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/main.c
> @@ -3946,6 +3946,7 @@ static int mlx4_restart_one_up(struct pci_dev *pdev, bool reload,
>  			       struct devlink *devlink);
>  
>  static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
> +				    enum devlink_reload_action action,
>  				    struct netlink_ext_ack *extack)
>  {

I might have opted to convert reload_down to take a structure of
parameters, given that we're about to add 2 parameters. Not really that
significant either way.
