Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F133178C0A
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 08:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgCDH7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 02:59:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:46656 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbgCDH7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 02:59:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 717F8AF9F;
        Wed,  4 Mar 2020 07:59:30 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id D69AFE037F; Wed,  4 Mar 2020 08:59:26 +0100 (CET)
Date:   Wed, 4 Mar 2020 08:59:26 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, thomas.lendacky@amd.com, benve@cisco.com,
        _govind@gmx.com, pkaustub@cisco.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, snelson@pensando.io,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, jacob.e.keller@intel.com,
        alexander.h.duyck@linux.intel.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/12] ethtool: add infrastructure for
 centralized checking of coalescing parameters
Message-ID: <20200304075926.GH4264@unicorn.suse.cz>
References: <20200304043354.716290-1-kuba@kernel.org>
 <20200304043354.716290-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304043354.716290-2-kuba@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 08:33:43PM -0800, Jakub Kicinski wrote:
> Linux supports 22 different interrupt coalescing parameters.
> No driver implements them all. Some drivers just ignore the
> ones they don't support, while others have to carry a long
> list of checks to reject unsupported settings.
> 
> To simplify the drivers add the ability to specify inside
> ethtool_ops which parameters are supported and let the core
> reject attempts to set any other one.
> 
> This commit makes the mechanism an opt-in, only drivers which
> set ethtool_opts->coalesce_types to a non-zero value will have
> the checks enforced.
> 
> The same mask is used for global and per queue settings.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
[...]
> +static bool
> +ethtool_set_coalesce_supported(struct net_device *dev,
> +			       struct ethtool_coalesce *coalesce)
> +{
> +	u32 used_types = 0;
> +
> +	if (coalesce->rx_coalesce_usecs)
> +		used_types |= ETHTOOL_COALESCE_RX_USECS;
> +	if (coalesce->rx_max_coalesced_frames)
> +		used_types |= ETHTOOL_COALESCE_RX_MAX_FRAMES;
> +	if (coalesce->rx_coalesce_usecs_irq)
> +		used_types |= ETHTOOL_COALESCE_RX_USECS_IRQ;
> +	if (coalesce->rx_max_coalesced_frames_irq)
> +		used_types |= ETHTOOL_COALESCE_RX_MAX_FRAMES_IRQ;
> +	if (coalesce->tx_coalesce_usecs)
> +		used_types |= ETHTOOL_COALESCE_TX_USECS;
> +	if (coalesce->tx_max_coalesced_frames)
> +		used_types |= ETHTOOL_COALESCE_TX_MAX_FRAMES;
> +	if (coalesce->tx_coalesce_usecs_irq)
> +		used_types |= ETHTOOL_COALESCE_TX_USECS_IRQ;
> +	if (coalesce->tx_max_coalesced_frames_irq)
> +		used_types |= ETHTOOL_COALESCE_TX_MAX_FRAMES_IRQ;
> +	if (coalesce->stats_block_coalesce_usecs)
> +		used_types |= ETHTOOL_COALESCE_STATS_BLOCK_USECS;
> +	if (coalesce->use_adaptive_rx_coalesce)
> +		used_types |= ETHTOOL_COALESCE_USE_ADAPTIVE_RX;
> +	if (coalesce->use_adaptive_tx_coalesce)
> +		used_types |= ETHTOOL_COALESCE_USE_ADAPTIVE_TX;
> +	if (coalesce->pkt_rate_low)
> +		used_types |= ETHTOOL_COALESCE_PKT_RATE_LOW;
> +	if (coalesce->rx_coalesce_usecs_low)
> +		used_types |= ETHTOOL_COALESCE_RX_USECS_LOW;
> +	if (coalesce->rx_max_coalesced_frames_low)
> +		used_types |= ETHTOOL_COALESCE_RX_MAX_FRAMES_LOW;
> +	if (coalesce->tx_coalesce_usecs_low)
> +		used_types |= ETHTOOL_COALESCE_TX_USECS_LOW;
> +	if (coalesce->tx_max_coalesced_frames_low)
> +		used_types |= ETHTOOL_COALESCE_TX_MAX_FRAMES_LOW;
> +	if (coalesce->pkt_rate_high)
> +		used_types |= ETHTOOL_COALESCE_PKT_RATE_HIGH;
> +	if (coalesce->rx_coalesce_usecs_high)
> +		used_types |= ETHTOOL_COALESCE_RX_USECS_HIGH;
> +	if (coalesce->rx_max_coalesced_frames_high)
> +		used_types |= ETHTOOL_COALESCE_RX_MAX_FRAMES_HIGH;
> +	if (coalesce->tx_coalesce_usecs_high)
> +		used_types |= ETHTOOL_COALESCE_TX_USECS_HIGH;
> +	if (coalesce->tx_max_coalesced_frames_high)
> +		used_types |= ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH;
> +	if (coalesce->rate_sample_interval)
> +		used_types |= ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL;

Just an idea: perhaps we could use the fact that struct ethtool_coalesce
is de facto an array so that this block could be replaced by a loop like

	u32 supported_types = dev->ethtool_ops->coalesce_types;
	const u32 *values = &coalesce->rx_coalesce_usecs;

	for (i = 0; i < __ETHTOOL_COALESCE_COUNT; i++)
		if (values[i] && !(supported_types & BIT(i)))
			return false;

and to be sure, BUILD_BUG_ON() or static_assert() check that the offset
of ->rate_sample_interval matches ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL.

> +	return !dev->ethtool_ops->coalesce_types ||
> +		(dev->ethtool_ops->coalesce_types & used_types) == used_types;
> +}

I suggest to move the check for !dev->ethtool_ops->coalesce_types to the
beginning of the function so that we avoid calculating the bitmap if we
are not going to check it anyway.

Michal
