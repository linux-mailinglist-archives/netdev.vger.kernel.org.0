Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48B5D17C651
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 20:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgCFTbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 14:31:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:43826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgCFTbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 14:31:19 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52A412064A;
        Fri,  6 Mar 2020 19:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583523079;
        bh=IztYeqduI3Bi7rgdzQ1Br5VvXiIqhzCjkLLGSIRr7JY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iJNUTF4M+tnYRZ5IwLFWm18Ap2uzmp8CJdqbiepLJZeNVKOd7WcKkDr0RrxLSthRi
         MB84vOHRHzJEfg0rdM3y+krx73TBcQTFBMH8mBejURQoEpDQ+qDEcQaJ/MGJgday/p
         0s/dmoU+sSGVAcMKqLqq5c4HmQosr/5PDrkLZm3Q=
Date:   Fri, 6 Mar 2020 11:31:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v3 09/10] flow_offload: introduce "disabled" HW
 stats type and allow it in mlxsw
Message-ID: <20200306113116.1d7b0955@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200306132856.6041-10-jiri@resnulli.us>
References: <20200306132856.6041-1-jiri@resnulli.us>
        <20200306132856.6041-10-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Mar 2020 14:28:55 +0100 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Introduce new type for disabled HW stats and allow the value in
> mlxsw offload.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
> v2->v3:
> - moved to bitfield
> v1->v2:
> - moved to action
> ---
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c | 2 +-
>  include/net/flow_offload.h                            | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> index 4bf3ac1cb20d..88aa554415df 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> @@ -36,7 +36,7 @@ static int mlxsw_sp_flower_parse_actions(struct mlxsw_sp *mlxsw_sp,
>  		err = mlxsw_sp_acl_rulei_act_count(mlxsw_sp, rulei, extack);
>  		if (err)
>  			return err;
> -	} else {
> +	} else if (act->hw_stats_type != FLOW_ACTION_HW_STATS_TYPE_DISABLED) {
>  		NL_SET_ERR_MSG_MOD(extack, "Unsupported action HW stats type");
>  		return -EOPNOTSUPP;
>  	}
> diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> index d597d500a5df..b700c570f7f1 100644
> --- a/include/net/flow_offload.h
> +++ b/include/net/flow_offload.h
> @@ -159,6 +159,7 @@ enum flow_action_mangle_base {
>  #define FLOW_ACTION_HW_STATS_TYPE_DELAYED BIT(1)
>  #define FLOW_ACTION_HW_STATS_TYPE_ANY (FLOW_ACTION_HW_STATS_TYPE_IMMEDIATE | \
>  				       FLOW_ACTION_HW_STATS_TYPE_DELAYED)
> +#define FLOW_ACTION_HW_STATS_TYPE_DISABLED 0

Would it fit better for the bitfield if disabled internally is 
BIT(last type + 1)? 
