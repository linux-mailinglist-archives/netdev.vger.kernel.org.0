Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5045217E50B
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 17:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgCIQxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 12:53:02 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:45666 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727132AbgCIQxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 12:53:01 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 36BED940058;
        Mon,  9 Mar 2020 16:53:00 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 9 Mar 2020
 16:52:50 +0000
Subject: Re: [patch net-next v4 03/10] flow_offload: check for basic action hw
 stats type
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <saeedm@mellanox.com>,
        <leon@kernel.org>, <michael.chan@broadcom.com>,
        <vishal@chelsio.com>, <jeffrey.t.kirsher@intel.com>,
        <idosch@mellanox.com>, <aelior@marvell.com>,
        <peppe.cavallaro@st.com>, <alexandre.torgue@st.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
        <pablo@netfilter.org>, <mlxsw@mellanox.com>
References: <20200307114020.8664-1-jiri@resnulli.us>
 <20200307114020.8664-4-jiri@resnulli.us>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <180ffa93-943c-95ba-437b-a9d15db2a955@solarflare.com>
Date:   Mon, 9 Mar 2020 16:52:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200307114020.8664-4-jiri@resnulli.us>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25278.003
X-TM-AS-Result: No-7.898800-8.000000-10
X-TMASE-MatchedRID: 8+bhjh9TQnG8rRvefcjeTfZvT2zYoYOwC/ExpXrHizyCQSnu1cYjSvBU
        q5JsuvxSIH2zryPqfYNS74Ih0H60xazZmuc72EUiEhGH3CRdKUWXGEdoE+kH/2u9/l5WAy7sT6Y
        y0anPBpbv6S0chV3w+E7t26LLa1HUIeFIFB+CV+wD2WXLXdz+AY1j+mrGi/PFbDD7i2QfyEfSJJ
        cbp1Y+W8zZyIgK4/i/FXQRPpObc2nKGuE12Tco0PSG/+sPtZVkUNr9nJzA3WTaFXyMyYYsNEcqj
        CyI/1gNfeLMdo7pGOSTTSbe+KfbafwJAeGTOT9SUVIPjtU7G5I1X1Ls767cppQSL3wNKmMrrBhy
        v2DtHP/i8zVgXoAltkWL4rBlm20vt7DW3B48kkHdB/CxWTRRuwihQpoXbuXFNZyeJluopEZaF/t
        FrhQZ/OQRjrMIUV7XECuHhq54zDxz5sFdSpNgwkngvFdh1lh40cn37k6dX2sc+Q8OO0W0Cl0sRj
        MF9/0QooBB8uyeEuspZK3gOa9uGmJwouYrZN4qaw+fkLqdalOeqD9WtJkSIw==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--7.898800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25278.003
X-MDID: 1583772781-Ntm97hECncPy
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2020 11:40, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
>
> Introduce flow_action_basic_hw_stats_types_check() helper and use it
> in drivers. That sanitizes the drivers which do not have support
> for action HW stats types.
>
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v3->v4:
> - fixed entries iteration in check (s/0/i/)
> - compare allowed type explicitly to 0 to avoid confusion
> v2->v3:
> - added flow_action_hw_stats_types_check() to pass allowed types
> - "mixed" bool got remove, iterate entries in check
> - added mlx5 checking instead of separate patches (will be changed by
>   later patch to flow_action_hw_stats_types_check()
> v1->v2:
> - new patch
> ---
> <snip>
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 93d17f37e980..8b40f612a565 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/list.h>
> +#include <linux/netlink.h>
>  #include <net/flow_dissector.h>
>  #include <linux/rhashtable.h>
>  
> @@ -251,6 +252,66 @@ static inline bool flow_offload_has_one_action(const struct flow_action *action)
>  	return action->num_entries == 1;
>  }
>  
> +static inline bool
> +flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
> +				       struct netlink_ext_ack *extack)
> +{
> +	const struct flow_action_entry *action_entry;
> +	u8 uninitialized_var(last_hw_stats_type);
> +	int i;
> +
> +	if (flow_offload_has_one_action(action))
> +		return true;
> +
> +	for (i = 0; i < action->num_entries; i++) {
Any reason you didn't use flow_action_for_each() here?
-ed

> +		action_entry = &action->entries[i];
> +		if (i && action_entry->hw_stats_type != last_hw_stats_type) {
> +			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
> +			return false;
> +		}
> +		last_hw_stats_type = action_entry->hw_stats_type;
> +	}
> +	return true;
> +}
> +
> +static inline const struct flow_action_entry *
> +flow_action_first_entry_get(const struct flow_action *action)
> +{
> +	WARN_ON(!flow_action_has_entries(action));
> +	return &action->entries[0];
> +}
> +
> +static inline bool
> +flow_action_hw_stats_types_check(const struct flow_action *action,
> +				 struct netlink_ext_ack *extack,
> +				 u8 allowed_hw_stats_type)
> +{
> +	const struct flow_action_entry *action_entry;
> +
> +	if (!flow_action_has_entries(action))
> +		return true;
> +	if (!flow_action_mixed_hw_stats_types_check(action, extack))
> +		return false;
> +	action_entry = flow_action_first_entry_get(action);
> +	if (allowed_hw_stats_type == 0 &&
> +	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
> +		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
> +		return false;
> +	} else if (allowed_hw_stats_type != 0 &&
> +		   action_entry->hw_stats_type != allowed_hw_stats_type) {
> +		NL_SET_ERR_MSG_MOD(extack, "Driver does not support selected HW stats type");
> +		return false;
> +	}
> +	return true;
> +}
> +
> +static inline bool
> +flow_action_basic_hw_stats_types_check(const struct flow_action *action,
> +				       struct netlink_ext_ack *extack)
> +{
> +	return flow_action_hw_stats_types_check(action, extack, 0);
> +}
> +
>  #define flow_action_for_each(__i, __act, __actions)			\
>          for (__i = 0, __act = &(__actions)->entries[0]; __i < (__actions)->num_entries; __act = &(__actions)->entries[++__i])
>  
> diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> index 79d9b4384d7b..fca9bfa8437e 100644
> --- a/net/dsa/slave.c
> +++ b/net/dsa/slave.c
> @@ -865,6 +865,10 @@ static int dsa_slave_add_cls_matchall(struct net_device *dev,
>  	if (!flow_offload_has_one_action(&cls->rule->action))
>  		return err;
>  
> +	if (!flow_action_basic_hw_stats_types_check(&cls->rule->action,
> +						    cls->common.extack))
> +		return err;
> +
>  	act = &cls->rule->action.entries[0];
>  
>  	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {

