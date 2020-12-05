Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF0C2CFCD3
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 19:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgLESTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 13:19:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727736AbgLERoH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 12:44:07 -0500
Date:   Sat, 5 Dec 2020 09:43:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607190206;
        bh=NsgD2LcgtN1aqnXL816NviWBVSH9uR21h6KTOZFn01I=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=jU9oI3v235hXaxa4SevgOB3aDzL+T4tNoDhQOgNMlN8z3Jc73uKGXjEQ4w4BDw4aj
         bWzPsXtY1DkK0pU38qfkzhZyl/4pJKYD0iSsXb8UAPMZF+93y48Dv6bwGKju0K6ZVb
         RL3x6HW1xuJrr6aMKgql9yBi0FeA8lJG0NrWp48jXW+HnLZ4aEuRHjA19R9nqkCLfP
         kkp82V6AODHdC1AY0afgBaO/Uz3i5rl+SzyQjAsuk5YD+hY1zHbkVkTVpoeROk6xa0
         dKQkjZ+OqtexDI6xr+iisGSO4QMV8/OR4GYVqSsMitUDPhY+uwfot5T1IahAP+AW/Y
         o0nNF3QWxtGMg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, m-karicheri2@ti.com, vladimir.oltean@nxp.com,
        Jose.Abreu@synopsys.com, po.liu@nxp.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com
Subject: Re: [PATCH net-next v1 1/9] ethtool: Add support for configuring
 frame preemption
Message-ID: <20201205094325.790b187f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202045325.3254757-2-vinicius.gomes@intel.com>
References: <20201202045325.3254757-1-vinicius.gomes@intel.com>
        <20201202045325.3254757-2-vinicius.gomes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Dec 2020 20:53:17 -0800 Vinicius Costa Gomes wrote:
> Frame preemption (described in IEEE 802.3br-2016) defines the concept
> of preemptible and express queues. It allows traffic from express
> queues to "interrupt" traffic from preemptible queues, which are
> "resumed" after the express traffic has finished transmitting.
> 
> Frame preemption can only be used when both the local device and the
> link partner support it.
> 
> Only parameters for enabling/disabling frame preemption and
> configuring the minimum fragment size are included here. Expressing
> which queues are marked as preemptible is left to mqprio/taprio, as
> having that information there should be easier on the user.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  include/linux/ethtool.h              |  19 ++++
>  include/uapi/linux/ethtool_netlink.h |  17 +++
>  net/ethtool/Makefile                 |   2 +-
>  net/ethtool/netlink.c                |  19 ++++
>  net/ethtool/netlink.h                |   4 +
>  net/ethtool/preempt.c                | 151 +++++++++++++++++++++++++++
>  6 files changed, 211 insertions(+), 1 deletion(-)
>  create mode 100644 net/ethtool/preempt.c
> 
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index e3da25b51ae4..16d6ee29a6ac 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -263,6 +263,19 @@ struct ethtool_pause_stats {
>  	u64 rx_pause_frames;
>  };
>  
> +/**
> + * struct ethtool_fp - Frame Preemption information
> + *
> + * @enabled: Enable frame preemption.
> + *

The empty line between members seems unnecessary.

> + * @min_frag_size_mult: Minimum size for all non-final fragment size,
> + * expressed in terms of X in '(1 + X)*64 + 4'

Is this way of expressing the min frag size from the standard?

> + */
> +struct ethtool_fp {
> +	u8 enabled;
> +	u8 min_frag_size_mult;
> +};

> +	int	(*get_preempt)(struct net_device *,
> +			       struct ethtool_fp *);
> +	int	(*set_preempt)(struct net_device *,
> +			       struct ethtool_fp *);

Since this is a new op we should probably pass extack to the drivers?

>  extern const struct nla_policy ethnl_header_policy[ETHTOOL_A_HEADER_FLAGS + 1];
>  extern const struct nla_policy ethnl_header_policy_stats[ETHTOOL_A_HEADER_FLAGS + 1];
> @@ -375,6 +376,8 @@ extern const struct nla_policy ethnl_tsinfo_get_policy[ETHTOOL_A_TSINFO_HEADER +
>  extern const struct nla_policy ethnl_cable_test_act_policy[ETHTOOL_A_CABLE_TEST_HEADER + 1];
>  extern const struct nla_policy ethnl_cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_CFG + 1];
>  extern const struct nla_policy ethnl_tunnel_info_get_policy[ETHTOOL_A_TUNNEL_INFO_HEADER + 1];
> +extern const struct nla_policy ethnl_preempt_get_policy[ETHTOOL_A_PREEMPT_MAX + 1];
> +extern const struct nla_policy ethnl_preempt_set_policy[ETHTOOL_A_PREEMPT_MAX + 1];

Let's make the size

ETHTOOL_A_PREEMPT_MIN_FRAG_SIZE_MULT + 1

for set, and

ETHTOOL_A_PREEMPT_HEADER + 1

for get, like the other tables

> +const struct nla_policy
> +ethnl_preempt_get_policy[ETHTOOL_A_PREEMPT_MAX + 1] = {
> +	[ETHTOOL_A_PREEMPT_UNSPEC]		= { .type = NLA_REJECT },

Unnecessary, NLA_REJECT is 0.

> +	[ETHTOOL_A_PREEMPT_HEADER]		= { .type = NLA_NESTED },

Please specify nested policy

> +	[ETHTOOL_A_PREEMPT_ENABLED]		= { .type = NLA_REJECT },
> +	[ETHTOOL_A_PREEMPT_MIN_FRAG_SIZE_MULT]	= { .type = NLA_REJECT },

Unnecessary

> +const struct nla_policy
> +ethnl_preempt_set_policy[ETHTOOL_A_PREEMPT_MAX + 1] = {
> +	[ETHTOOL_A_PREEMPT_UNSPEC]			= { .type = NLA_REJECT },
> +	[ETHTOOL_A_PREEMPT_HEADER]			= { .type = NLA_NESTED },
> +	[ETHTOOL_A_PREEMPT_ENABLED]			= { .type = NLA_U8 },

Set the right netlink policy to check the value is <= 1.

> +	[ETHTOOL_A_PREEMPT_MIN_FRAG_SIZE_MULT]		= { .type = NLA_U8 },
> +};
