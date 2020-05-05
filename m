Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02C21C603D
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728937AbgEESkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgEESkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 14:40:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B208206FA;
        Tue,  5 May 2020 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588704012;
        bh=hVKf+qmR8DpkiGRwne0mtB2DZPrZLcSf3Iil71IS5vM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EEXvDeNNzf3QITsVdYe6EBro2bKd6nY1bELVMFbwWYDBhJljMAaU4+njozpbfxTNg
         zwwsZroMPaKv1qDHbWnccpRvBRkAUfZkFbzc05NtAp3ZrbpEuNf1R3shCtJ7+0htbH
         FfbxvtGoPcnixt4vhGzFe2q5p1ysQR53bZS439Hs=
Date:   Tue, 5 May 2020 11:40:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, ecree@solarflare.com
Subject: Re: [PATCH net,v2] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DONT_CARE
Message-ID: <20200505114010.132abebd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200505174736.29414-1-pablo@netfilter.org>
References: <20200505174736.29414-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  5 May 2020 19:47:36 +0200 Pablo Neira Ayuso wrote:
> This patch adds FLOW_ACTION_HW_STATS_DONT_CARE which tells the driver
> that the frontend does not need counters, this hw stats type request
> never fails. The FLOW_ACTION_HW_STATS_DISABLED type explicitly requests
> the driver to disable the stats, however, if the driver cannot disable
> counters, it bails out.
> 
> TCA_ACT_HW_STATS_* maintains the 1:1 mapping with FLOW_ACTION_HW_STATS_*
> except by disabled which is mapped to FLOW_ACTION_HW_STATS_DISABLED
> (this is 0 in tc). Add tc_act_hw_stats() to perform the mapping between
> TCA_ACT_HW_STATS_* and FLOW_ACTION_HW_STATS_*.
> 
> Fixes: 319a1d19471e ("flow_offload: check for basic action hw stats type")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: define FLOW_ACTION_HW_STATS_DISABLED at the end of the enumeration
>     as Jiri suggested. Keep the 1:1 mapping between TCA_ACT_HW_STATS_*
>     and FLOW_ACTION_HW_STATS_* except by the disabled case.
> 
>  include/net/flow_offload.h |  9 ++++++++-
>  net/sched/cls_api.c        | 14 ++++++++++++--
>  2 files changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 3619c6acf60f..efc8350b42fb 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -166,15 +166,18 @@ enum flow_action_mangle_base {
>  enum flow_action_hw_stats_bit {
>  	FLOW_ACTION_HW_STATS_IMMEDIATE_BIT,
>  	FLOW_ACTION_HW_STATS_DELAYED_BIT,
> +	FLOW_ACTION_HW_STATS_DISABLED_BIT,
>  };
>  
>  enum flow_action_hw_stats {
> -	FLOW_ACTION_HW_STATS_DISABLED = 0,
> +	FLOW_ACTION_HW_STATS_DONT_CARE = 0,

Why not ~0? Or ANY | DISABLED? 
Otherwise you may confuse drivers which check bit by bit.

>  	FLOW_ACTION_HW_STATS_IMMEDIATE =
>  		BIT(FLOW_ACTION_HW_STATS_IMMEDIATE_BIT),
>  	FLOW_ACTION_HW_STATS_DELAYED = BIT(FLOW_ACTION_HW_STATS_DELAYED_BIT),
>  	FLOW_ACTION_HW_STATS_ANY = FLOW_ACTION_HW_STATS_IMMEDIATE |
>  				   FLOW_ACTION_HW_STATS_DELAYED,
> +	FLOW_ACTION_HW_STATS_DISABLED =
> +		BIT(FLOW_ACTION_HW_STATS_DISABLED_BIT),
>  };
>  
>  typedef void (*action_destr)(void *priv);
> @@ -325,7 +328,11 @@ __flow_action_hw_stats_check(const struct flow_action *action,
>  		return true;
>  	if (!flow_action_mixed_hw_stats_check(action, extack))
>  		return false;
> +
>  	action_entry = flow_action_first_entry_get(action);
> +	if (action_entry->hw_stats == FLOW_ACTION_HW_STATS_DONT_CARE)
> +		return true;
> +
>  	if (!check_allow_bit &&
>  	    action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
>  		NL_SET_ERR_MSG_MOD(extack, "Driver supports only default HW stats type \"any\"");
> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
> index 55bd1429678f..56cf1b9e1e24 100644
> --- a/net/sched/cls_api.c
> +++ b/net/sched/cls_api.c
> @@ -3523,6 +3523,16 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
>  #endif
>  }
>  
> +static enum flow_action_hw_stats tc_act_hw_stats(u8 hw_stats)
> +{
> +	if (WARN_ON_ONCE(hw_stats > TCA_ACT_HW_STATS_ANY))
> +		return FLOW_ACTION_HW_STATS_DONT_CARE;
> +	else if (!hw_stats)
> +		return FLOW_ACTION_HW_STATS_DISABLED;
> +
> +	return hw_stats;
> +}
> +
>  int tc_setup_flow_action(struct flow_action *flow_action,
>  			 const struct tcf_exts *exts)
>  {
> @@ -3546,7 +3556,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  		if (err)
>  			goto err_out_locked;
>  
> -		entry->hw_stats = act->hw_stats;
> +		entry->hw_stats = tc_act_hw_stats(act->hw_stats);
>  
>  		if (is_tcf_gact_ok(act)) {
>  			entry->id = FLOW_ACTION_ACCEPT;
> @@ -3614,7 +3624,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
>  				entry->mangle.mask = tcf_pedit_mask(act, k);
>  				entry->mangle.val = tcf_pedit_val(act, k);
>  				entry->mangle.offset = tcf_pedit_offset(act, k);
> -				entry->hw_stats = act->hw_stats;
> +				entry->hw_stats = tc_act_hw_stats(act->hw_stats);
>  				entry = &flow_action->entries[++j];
>  			}
>  		} else if (is_tcf_csum(act)) {

