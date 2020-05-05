Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B01A1C5464
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 13:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbgEELcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 07:32:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:45310 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbgEELcu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 07:32:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 0660DAD08;
        Tue,  5 May 2020 11:32:50 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id DDEFD602B9; Tue,  5 May 2020 13:32:47 +0200 (CEST)
Date:   Tue, 5 May 2020 13:32:47 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>, michael@walle.cc
Subject: Re: [PATCH net-next v2 10/10] net: phy: Send notifier when starting
 the cable test
Message-ID: <20200505113247.GN8237@lion.mk-sys.cz>
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-11-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200505001821.208534-11-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 05, 2020 at 02:18:21AM +0200, Andrew Lunn wrote:
> Given that it takes time to run a cable test, send a notify message at
> the start, as well as when it is completed.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  net/ethtool/cabletest.c | 39 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 39 insertions(+)
> 
> diff --git a/net/ethtool/cabletest.c b/net/ethtool/cabletest.c
> index f500454a54eb..e59f570494c0 100644
> --- a/net/ethtool/cabletest.c
> +++ b/net/ethtool/cabletest.c
> @@ -20,6 +20,41 @@ cable_test_act_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
>  	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
>  };
>  
> +static int ethnl_cable_test_started(struct phy_device *phydev)
> +{
> +	struct sk_buff *skb;
> +	int err = -ENOMEM;
> +	void *ehdr;
> +
> +	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (!skb)
> +		goto out;
> +
> +	ehdr = ethnl_bcastmsg_put(skb, ETHTOOL_MSG_CABLE_TEST_NTF);
> +	if (!ehdr) {
> +		err = -EINVAL;

This should rather be -EMSGSIZE. But as we are not going to use the
return value anyway, it's only cosmetic problem.

Michal

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

> +		goto out;
> +	}
> +
> +	err = ethnl_fill_reply_header(skb, phydev->attached_dev,
> +				      ETHTOOL_A_CABLE_TEST_NTF_HEADER);
> +	if (err)
> +		goto out;
> +
> +	err = nla_put_u8(skb, ETHTOOL_A_CABLE_TEST_NTF_STATUS,
> +			 ETHTOOL_A_CABLE_TEST_NTF_STATUS_STARTED);
> +	if (err)
> +		goto out;
> +
> +	genlmsg_end(skb, ehdr);
> +
> +	return ethnl_multicast(skb, phydev->attached_dev);
> +
> +out:
> +	nlmsg_free(skb);
> +	return err;
> +}
> +
>  int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
> @@ -54,6 +89,10 @@ int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
>  	ret = phy_start_cable_test(dev->phydev, info->extack);
>  
>  	ethnl_ops_complete(dev);
> +
> +	if (!ret)
> +		ethnl_cable_test_started(dev->phydev);
> +
>  out_rtnl:
>  	rtnl_unlock();
>  out_dev_put:
> -- 
> 2.26.2
> 
