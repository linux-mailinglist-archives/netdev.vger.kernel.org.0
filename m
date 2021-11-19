Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A322F4570A2
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:27:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235867AbhKSOa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:30:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:33024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235861AbhKSOa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Nov 2021 09:30:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EE83619E3;
        Fri, 19 Nov 2021 14:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637332045;
        bh=KkSnfXP+JzeiFNiVWni8AnyJAVnz02s51HnqHj9YIrw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CNKgcgnCrYrRVvWqSv4oocWObpM0D+nqnY+4R7jeIv13SUu1JaS+OF8aRcmQ74zZy
         berqVe6k+gQwkdg+qofMilwM6TQ/Wk88QvfFDworubc1PNBznDhfAHzl9VQXj/zVTB
         JXEJr/mCQkXvIsCHxXk9ZbDUO1PGEisI+DTgrLLCxMapN/H/FyIECJ3XSGSwBBEDPc
         LKe9DPthO9VrpdoKDDUWsmMlKTNSabzNZ6MI4XN8pEmzWFYiHChmKR3gmnsIhxL80Q
         dMHDX3KhUY+Km9k0c9KuQtMll2F6d+QuLZvjl4hyOMut+BchB43/mG0j7uTq76yCy9
         Hin+vDwWhtMXA==
Date:   Fri, 19 Nov 2021 06:27:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        YueHaibing <yuehaibing@huawei.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] ethtool: stats: Use struct_group() to clear all stats
 at once
Message-ID: <20211119062724.731da986@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211118203456.1288056-1-keescook@chromium.org>
References: <20211118203456.1288056-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 12:34:56 -0800 Kees Cook wrote:
> In preparation for FORTIFY_SOURCE performing compile-time and run-time
> field bounds checking for memset(), avoid intentionally writing across
> neighboring fields.
> 
> Add struct_group() to mark region of struct stats_reply_data that should
> be initialized, which can now be done in a single memset() call.

No objection to the patch, but the commit message does not work 
for this one ;)

> diff --git a/net/ethtool/stats.c b/net/ethtool/stats.c
> index ec07f5765e03..a20e0a24ff61 100644
> --- a/net/ethtool/stats.c
> +++ b/net/ethtool/stats.c
> @@ -14,10 +14,12 @@ struct stats_req_info {
>  
>  struct stats_reply_data {
>  	struct ethnl_reply_data		base;
> -	struct ethtool_eth_phy_stats	phy_stats;
> -	struct ethtool_eth_mac_stats	mac_stats;
> -	struct ethtool_eth_ctrl_stats	ctrl_stats;
> -	struct ethtool_rmon_stats	rmon_stats;
> +	struct_group(stats,
> +		struct ethtool_eth_phy_stats	phy_stats;
> +		struct ethtool_eth_mac_stats	mac_stats;
> +		struct ethtool_eth_ctrl_stats	ctrl_stats;
> +		struct ethtool_rmon_stats	rmon_stats;
> +	);
>  	const struct ethtool_rmon_hist_range	*rmon_ranges;
>  };
>  
> @@ -117,10 +119,7 @@ static int stats_prepare_data(const struct ethnl_req_info *req_base,
>  	/* Mark all stats as unset (see ETHTOOL_STAT_NOT_SET) to prevent them
>  	 * from being reported to user space in case driver did not set them.
>  	 */
> -	memset(&data->phy_stats, 0xff, sizeof(data->phy_stats));
> -	memset(&data->mac_stats, 0xff, sizeof(data->mac_stats));
> -	memset(&data->ctrl_stats, 0xff, sizeof(data->ctrl_stats));
> -	memset(&data->rmon_stats, 0xff, sizeof(data->rmon_stats));
> +	memset(&data->stats, 0xff, sizeof(data->stats));
>  
>  	if (test_bit(ETHTOOL_STATS_ETH_PHY, req_info->stat_mask) &&
>  	    dev->ethtool_ops->get_eth_phy_stats)

