Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8760317C64F
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 20:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgCFT2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 14:28:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgCFT2y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 14:28:54 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F7292064A;
        Fri,  6 Mar 2020 19:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583522934;
        bh=1VW6Wfj0d4flx7Mc6PZSavMPotiUH8d+ul6DwcCodQM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XrAhB70umpBkLxLBVF5V2xGEPkEXkyvdt/gwknSrZknFnNME09bbVssHLewWwWWw3
         b/p56bOYGv4+33X/BKilZf2rkCAXgcW/9SqEvKsVl2so3AIi+l0BDHY62+DS+2Mq+/
         yYOM1eMGXv1mu9ySEisyFMMQrhOVLrSwKvydnJws=
Date:   Fri, 6 Mar 2020 11:28:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 03/10] flow_offload: check for basic action
 hw stats type
Message-ID: <20200306112851.2dc630e7@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200306132856.6041-4-jiri@resnulli.us>
References: <20200306132856.6041-1-jiri@resnulli.us>
        <20200306132856.6041-4-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Mar 2020 14:28:49 +0100 Jiri Pirko wrote:
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

Perhaps just initialize before the loop to action 0 and start loop 
from 1?

> +	int i;
> +
> +	if (flow_offload_has_one_action(action))
> +		return true;
> +
> +	for (i = 0; i < action->num_entries; i++) {
> +		action_entry = &action->entries[0];

s/0/i/ ?

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
> +	if (!allowed_hw_stats_type &&
> +	    action_entry->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_ANY) {
> +		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
> +		return false;
> +	} else if (allowed_hw_stats_type &&
> +		   action_entry->hw_stats_type != allowed_hw_stats_type) {

Should this be an logical 'and' if we're doing it the bitfield way?

> +		NL_SET_ERR_MSG_MOD(extack, "Driver does not support selected HW stats type");
> +		return false;
> +	}
> +	return true;
> +}

