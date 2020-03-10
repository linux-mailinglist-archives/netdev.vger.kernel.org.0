Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39FED180524
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgCJRo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:44:58 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:52710 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726466AbgCJRo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:44:58 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E2552A80061;
        Tue, 10 Mar 2020 17:44:55 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 10 Mar
 2020 17:44:50 +0000
Subject: Re: [patch net-next v2] flow_offload: use flow_action_for_each in
 flow_action_mixed_hw_stats_types_check()
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pablo@netfilter.org>,
        <mlxsw@mellanox.com>
References: <20200310101157.5567-1-jiri@resnulli.us>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <cf6e79eb-c68a-d063-a6e4-3795e30f3543@solarflare.com>
Date:   Tue, 10 Mar 2020 17:44:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200310101157.5567-1-jiri@resnulli.us>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25280.003
X-TM-AS-Result: No-2.743800-8.000000-10
X-TMASE-MatchedRID: nVQUmLJJeya8rRvefcjeTfZvT2zYoYOwt3aeg7g/usBUjspoiX02FxQt
        LIUOz+UCBTL3N8yyT9ePQi9XuOWoOHI/MxNRI7Uk/NOUkr6ADzfdhJoeWdkvzRQTXyPPP3faUkj
        MOacb5HuESVL06fzYOw3Pu1JZ6TRWVWK5eX+o89tlpwNsTvdlKX0tCKdnhB58vqq8s2MNhPCy5/
        tFZu9S3Ku6xVHLhqfxWBd6ltyXuvvXqYkKVufEnIWoLRfach/Dwoj8Mx4ZogtuIsKVRY1TTlh46
        bAfzB50VlLRH305DQMXaIliuehFa98wCpXKg/URA4GxPA3ZGSrwHX5+Q8jjw1wuriZ3P6dErIJZ
        JbQfMXRqaM5LmpUkwzunJXJz8X1QftwZ3X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.743800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25280.003
X-MDID: 1583862296-D6JAdvivFZDJ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2020 10:11, Jiri Pirko wrote:
> Instead of manually iterating over entries, use flow_action_for_each
> helper. Move the helper and wrap it to fit to 80 cols on the way.
>
> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Acked-by: Edward Cree <ecree@solarflare.com>
> ---
> v1->v2:
> - removed action_entry init in loop
> ---
>  include/net/flow_offload.h | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index 64807aa03cee..891e15055708 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -256,6 +256,11 @@ static inline bool flow_offload_has_one_action(const struct flow_action *action)
>  	return action->num_entries == 1;
>  }
>  
> +#define flow_action_for_each(__i, __act, __actions)			\
> +        for (__i = 0, __act = &(__actions)->entries[0];			\
> +	     __i < (__actions)->num_entries;				\
> +	     __act = &(__actions)->entries[++__i])
> +
>  static inline bool
>  flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
>  				       struct netlink_ext_ack *extack)
> @@ -267,8 +272,7 @@ flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
>  	if (flow_offload_has_one_action(action))
>  		return true;
>  
> -	for (i = 0; i < action->num_entries; i++) {
> -		action_entry = &action->entries[i];
> +	flow_action_for_each(i, action_entry, action) {
>  		if (i && action_entry->hw_stats_type != last_hw_stats_type) {
>  			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
>  			return false;
> @@ -316,9 +320,6 @@ flow_action_basic_hw_stats_types_check(const struct flow_action *action,
>  	return flow_action_hw_stats_types_check(action, extack, 0);
>  }
>  
> -#define flow_action_for_each(__i, __act, __actions)			\
> -        for (__i = 0, __act = &(__actions)->entries[0]; __i < (__actions)->num_entries; __act = &(__actions)->entries[++__i])
> -
>  struct flow_rule {
>  	struct flow_match	match;
>  	struct flow_action	action;

