Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 329DE1E02C5
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 22:34:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388139AbgEXUeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 16:34:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:34342 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388045AbgEXUeP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 16:34:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2D952ACB1;
        Sun, 24 May 2020 20:34:15 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 3B9B6604C8; Sun, 24 May 2020 22:34:12 +0200 (CEST)
Date:   Sun, 24 May 2020 22:34:12 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH v2 net-next 5/6] net: ethtool: Allow PHY cable test TDR
 data to configured
Message-ID: <20200524203412.br2f5yj46cnmge2m@lion.mk-sys.cz>
References: <20200524152747.745893-1-andrew@lunn.ch>
 <20200524152747.745893-6-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200524152747.745893-6-andrew@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 05:27:45PM +0200, Andrew Lunn wrote:
> Allow the user to configure where on the cable the TDR data should be
> retrieved, in terms of first and last sample, and the step between
> samples. Also add the ability to ask for TDR data for just one pair.
> 
> If this configuration is not provided, it defaults to 1-150m at 1m
> intervals for all pairs.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
[...]
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index 739faa7070c6..0b68ab7d08ea 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -485,6 +485,10 @@ enum {
>  enum {
>  	ETHTOOL_A_CABLE_TEST_TDR_UNSPEC,
>  	ETHTOOL_A_CABLE_TEST_TDR_HEADER,	/* nest - _A_HEADER_* */
> +	ETHTOOL_A_CABLE_TEST_TDR_FIRST,		/* u32 */
> +	ETHTOOL_A_CABLE_TEST_TDR_LAST,		/* u32 */
> +	ETHTOOL_A_CABLE_TEST_TDR_STEP,		/* u32 */
> +	ETHTOOL_A_CABLE_TEST_TDR_PAIR,		/* u8 */
>  
>  	/* add new constants above here */
>  	__ETHTOOL_A_CABLE_TEST_TDR_CNT,

Please add description of these attributes to ethtool-netlink.rst.

Also, it might make sense to gather all "test parameters" in one nest
that could used in both request and the final notification (pulse
amplitude would not be allowed in request, unless there is a device
which allows to configure it as well). The main results nest would be
left only for measured results.

This nest could also directly correspond to a structure so that you
could pass one pointer instead of four arguments in some of the helpers
above.

> diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
> index c02575e26336..ddf678eae44f 100644
> --- a/net/ethtool/cabletest.c
> +++ b/net/ethtool/cabletest.c
> @@ -5,7 +5,11 @@
>  #include "netlink.h"
>  #include "common.h"
>  
> -/* CABLE_TEST_ACT */
> +/* 802.3 standard allows 100 meters for BaseT cables. However longer
> + * cables might work, depending on the quality of the cables and the
> + * PHY. So allow testing for up to 150 meters.
> + */
> +#define MAX_CABLE_LENGTH_CM (150 * 100)
>  
>  static const struct nla_policy
>  cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
> @@ -203,18 +207,30 @@ int ethnl_cable_test_fault_length(struct phy_device *phydev, u8 pair, u32 cm)
>  }
>  EXPORT_SYMBOL_GPL(ethnl_cable_test_fault_length);
>  
> +struct cable_test_tdr_req_info {
> +	struct ethnl_req_info		base;
> +};
> +
>  static const struct nla_policy
>  cable_test_tdr_act_policy[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1] = {
>  	[ETHTOOL_A_CABLE_TEST_TDR_UNSPEC]	= { .type = NLA_REJECT },
>  	[ETHTOOL_A_CABLE_TEST_TDR_HEADER]	= { .type = NLA_NESTED },
> +	[ETHTOOL_A_CABLE_TEST_TDR_FIRST]	= { .type = NLA_U32 },
> +	[ETHTOOL_A_CABLE_TEST_TDR_LAST]		= { .type = NLA_U32 },
> +	[ETHTOOL_A_CABLE_TEST_TDR_STEP]		= { .type = NLA_U32 },
> +	[ETHTOOL_A_CABLE_TEST_TDR_PAIR]		= { .type = NLA_U8 },
>  };
>  
> +/* CABLE_TEST_TDR_ACT */
> +
>  int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_TDR_MAX + 1];
>  	struct ethnl_req_info req_info = {};
>  	struct net_device *dev;
> +	u32 first, last, step;
>  	int ret;
> +	u8 pair;
>  
>  	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
>  			  ETHTOOL_A_CABLE_TEST_TDR_MAX,
> @@ -235,12 +251,59 @@ int ethnl_act_cable_test_tdr(struct sk_buff *skb, struct genl_info *info)
>  		goto out_dev_put;
>  	}
>  
> +	if (tb[ETHTOOL_A_CABLE_TEST_TDR_FIRST])
> +		first = nla_get_u32(tb[ETHTOOL_A_CABLE_TEST_TDR_FIRST]);
> +	else
> +		first = 100;
> +	if (tb[ETHTOOL_A_CABLE_TEST_TDR_LAST])
> +		last = nla_get_u32(tb[ETHTOOL_A_CABLE_TEST_TDR_LAST]);
> +	else
> +		last = MAX_CABLE_LENGTH_CM;
> +
> +	if (tb[ETHTOOL_A_CABLE_TEST_TDR_STEP])
> +		step = nla_get_u32(tb[ETHTOOL_A_CABLE_TEST_TDR_STEP]);
> +	else
> +		step = 100;
> +
> +	if (tb[ETHTOOL_A_CABLE_TEST_TDR_PAIR]) {
> +		pair = nla_get_u8(tb[ETHTOOL_A_CABLE_TEST_TDR_PAIR]);
> +		if (pair < ETHTOOL_A_CABLE_PAIR_A ||
> +		    pair > ETHTOOL_A_CABLE_PAIR_D) {
> +			NL_SET_ERR_MSG(info->extack,
> +				       "invalid pair parameter");

Please use NL_SET_ERR_MSG_ATTR() here and in the checks below (probably
except the "first > last" test).

> +			return -EINVAL;
> +		}
> +	} else {
> +		pair = PHY_PAIR_ALL;
> +	}
> +
> +	if (first > MAX_CABLE_LENGTH_CM) {
> +		NL_SET_ERR_MSG(info->extack, "invalid first parameter");
> +		return -EINVAL;
> +	}
> +
> +	if (last > MAX_CABLE_LENGTH_CM) {
> +		NL_SET_ERR_MSG(info->extack, "invalid last parameter");
> +		return -EINVAL;
> +	}
> +
> +	if (first > last) {
> +		NL_SET_ERR_MSG(info->extack, "invalid first/last parameter");
> +		return -EINVAL;
> +	}
> +
> +	if (!step) {
> +		NL_SET_ERR_MSG(info->extack, "invalid step parameter");
> +		return -EINVAL;
> +	}

Without an upper bound for step, there might be some nasty tricks with
first + step overflowing the u32 value range. I don't see an example
from the top of my head but I suspect syzkaller would invent something.

Michal


> +
>  	rtnl_lock();
>  	ret = ethnl_ops_begin(dev);
>  	if (ret < 0)
>  		goto out_rtnl;
>  
> -	ret = phy_start_cable_test_tdr(dev->phydev, info->extack);
> +	ret = phy_start_cable_test_tdr(dev->phydev, info->extack,
> +				       first, last, step, pair);
>  
>  	ethnl_ops_complete(dev);
>  
> -- 
> 2.27.0.rc0
> 
