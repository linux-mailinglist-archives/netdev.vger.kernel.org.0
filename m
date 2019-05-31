Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A65230B8B
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEaJae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:30:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:33358 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726232AbfEaJae (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 05:30:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 072ACAFE2;
        Fri, 31 May 2019 09:30:32 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id C2E3CE00E3; Fri, 31 May 2019 11:30:29 +0200 (CEST)
Date:   Fri, 31 May 2019 11:30:29 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, linville@redhat.com
Subject: Re: [PATCH 2/2] ethtool: Add 100BaseT1 and 1000BaseT1 link modes
Message-ID: <20190531093029.GD15954@unicorn.suse.cz>
References: <20190530180616.1418-1-andrew@lunn.ch>
 <20190530180616.1418-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530180616.1418-3-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 08:06:16PM +0200, Andrew Lunn wrote:
> The kernel can now indicate if the PHY supports operating over a
> single pair at 100Mbps or 1000Mbps.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  ethtool.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/ethtool.c b/ethtool.c
> index 66a907edd97b..35158939e04c 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -494,8 +494,10 @@ static void init_global_link_mode_masks(void)
>  		ETHTOOL_LINK_MODE_10baseT_Full_BIT,
>  		ETHTOOL_LINK_MODE_100baseT_Half_BIT,
>  		ETHTOOL_LINK_MODE_100baseT_Full_BIT,
> +		ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
>  		ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
>  		ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
> +		ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
>  		ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
>  		ETHTOOL_LINK_MODE_2500baseX_Full_BIT,
>  		ETHTOOL_LINK_MODE_10000baseT_Full_BIT,

The only place where the all_advertised_modes_bits[] array is used is

	ethtool_link_mode_zero(all_advertised_modes);
	ethtool_link_mode_zero(all_advertised_flags);
	for (i = 0; i < ARRAY_SIZE(all_advertised_modes_bits); ++i) {
		ethtool_link_mode_set_bit(all_advertised_modes_bits[i],
					  all_advertised_modes);
		ethtool_link_mode_set_bit(all_advertised_modes_bits[i],
					  all_advertised_flags);
	}

so the order does not really matter. I would prefer to have the elements
ordered the same way as in enum ethtool_link_mode_bit_indices so that
it's easier to check if something is missing.

> @@ -634,10 +636,14 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
>  		  "100baseT/Half" },
>  		{ 1, ETHTOOL_LINK_MODE_100baseT_Full_BIT,
>  		  "100baseT/Full" },
> +		{ 1, ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
> +		  "100baseT1/Full" },
>  		{ 0, ETHTOOL_LINK_MODE_1000baseT_Half_BIT,
>  		  "1000baseT/Half" },
>  		{ 1, ETHTOOL_LINK_MODE_1000baseT_Full_BIT,
>  		  "1000baseT/Full" },
> +		{ 1, ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
> +		  "1000baseT1/Full" },
>  		{ 0, ETHTOOL_LINK_MODE_1000baseKX_Full_BIT,
>  		  "1000baseKX/Full" },
>  		{ 0, ETHTOOL_LINK_MODE_2500baseX_Full_BIT,

Does it mean that we could end up with lines like

                                100baseT/Half 100baseT/Full 100baseT1/Full
                                1000baseT/Full 1000baseT1/Full

if there is a NIC supporting both T and T1? (I'm not sure if it's
possible - but if not, there is no need for setting same_line.) It would
be probably confusing for users as modes on the same line always were
half/full duplex variants of the same.

You should also add the new modes to ethtool.8.in.

Michal
