Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBC01B93A6
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 21:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgDZTgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 15:36:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:56080 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgDZTgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 15:36:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 75001AB64;
        Sun, 26 Apr 2020 19:36:34 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 40D6E602EE; Sun, 26 Apr 2020 21:36:34 +0200 (CEST)
Date:   Sun, 26 Apr 2020 21:36:34 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next v1 3/9] net: ethtool: netlink: Add support for
 triggering a cable test
Message-ID: <20200426193634.GB23225@lion.mk-sys.cz>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-4-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200425180621.1140452-4-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 25, 2020 at 08:06:15PM +0200, Andrew Lunn wrote:
> Add new ethtool netlink calls to trigger the starting of a PHY cable
> test.
> 
> Add Kconfig'ury to ETHTOOL_NETLINK so that PHYLIB is not a module when
> ETHTOOL_NETLINK is builtin, which would result in kernel linking errors.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  Documentation/networking/ethtool-netlink.rst | 18 ++++-
>  include/uapi/linux/ethtool_netlink.h         | 14 ++++
>  net/Kconfig                                  |  1 +
>  net/ethtool/Makefile                         |  2 +-
>  net/ethtool/cabletest.c                      | 82 ++++++++++++++++++++
>  net/ethtool/netlink.c                        |  6 ++
>  net/ethtool/netlink.h                        |  2 +
>  7 files changed, 122 insertions(+), 3 deletions(-)
>  create mode 100644 net/ethtool/cabletest.c
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index 567326491f80..0c354567e991 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
[...]
> @@ -758,7 +760,6 @@ Kernel checks that requested channel counts do not exceed limits reported by
>  driver. Driver may impose additional constraints and may not suspport all
>  attributes.
>  
> -
>  COALESCE_GET
>  ============
>  

Nitpick: this probably wasn't intended.

[...]
> diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
> new file mode 100644
> index 000000000000..44b8165ac66e
> --- /dev/null
> +++ b/net/ethtool/cabletest.c
> @@ -0,0 +1,82 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/phy.h>
> +#include "netlink.h"
> +#include "common.h"
> +#include "bitset.h"
> +
> +struct cable_test_req_info {
> +	struct ethnl_req_info		base;
> +};
> +
> +struct cable_test_reply_data {
> +	struct ethnl_reply_data		base;
> +};
> +
> +#define CABLE_TEST_REPDATA(__reply_base) \
> +	container_of(__reply_base, struct cable_test_reply_data, base)
> +
> +static const struct nla_policy
> +cable_test_get_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
> +	[ETHTOOL_A_CABLE_TEST_UNSPEC]		= { .type = NLA_REJECT },
> +	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
> +};
> +
> +const struct ethnl_request_ops ethnl_cable_test_act_ops = {
> +	.request_cmd		= ETHTOOL_MSG_CABLE_TEST_ACT,
> +	.reply_cmd		= ETHTOOL_MSG_CABLE_TEST_ACT_REPLY,
> +	.hdr_attr		= ETHTOOL_A_CABLE_TEST_HEADER,
> +	.max_attr		= ETHTOOL_A_CABLE_TEST_MAX,
> +	.req_info_size		= sizeof(struct cable_test_req_info),
> +	.reply_data_size	= sizeof(struct cable_test_reply_data),
> +	.request_policy		= cable_test_get_policy,
> +};
> +

As you register ethnl_act_cable_test() as doit handler and don't use any
of ethnl_default_*() handlers, you don't need to define
ethnl_cable_test_act_ops (and also struct cable_test_req_info and struct
cable_test_reply_data). These would be only used by default doit/dumpit
handlers and default notification handler.

> +/* CABLE_TEST_ACT */
> +
> +static const struct nla_policy
> +cable_test_set_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
> +	[ETHTOOL_A_CABLE_TEST_UNSPEC]		= { .type = NLA_REJECT },
> +	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
> +};

This should be probably rather named cable_test_act_policy - or maybe
cable_test_policy would suffice as you have only one request message
type (I've been using *_get_policy for *_GET request and *_set_policy
for *_SET).

> +
> +int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
> +	struct ethnl_req_info req_info = {};
> +	struct net_device *dev;
> +	int ret;
> +
> +	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
> +			  ETHTOOL_A_CABLE_TEST_MAX,
> +			  cable_test_set_policy, info->extack);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = ethnl_parse_header_dev_get(&req_info,
> +					 tb[ETHTOOL_A_CABLE_TEST_HEADER],
> +					 genl_info_net(info), info->extack,
> +					 true);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev = req_info.dev;
> +	if (!dev->phydev) {
> +		ret = -EOPNOTSUPP;
> +		goto out_dev_put;
> +	}
> +
> +	rtnl_lock();
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		goto out_rtnl;
> +
> +	ret = phy_start_cable_test(dev->phydev, info->extack);
> +
> +	ethnl_ops_complete(dev);
> +out_rtnl:
> +	rtnl_unlock();
> +out_dev_put:
> +	dev_put(dev);
> +	return ret;
> +}

As you don't send a reply message, you don't need
ETHTOOL_MSG_CABLE_TEST_ACT_REPLY either (we may introduce it later if
there is a reply message).

Michal
