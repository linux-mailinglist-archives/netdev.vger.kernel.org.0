Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33FE215EEC
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgGFSkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729842AbgGFSkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 14:40:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F416207C4;
        Mon,  6 Jul 2020 18:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594060802;
        bh=GCzjI5LNoEYSHBzDGeERWoVoi65qdJkPvvM8agbWZJs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uNc6pW6pEw9WAHZwQsD1YUi1tX+QGaA9mBT8oOELvl/1DZcXiF3JRphX2BdFezDaq
         6GGpP76mQSF0TuxLVNdhODTfyKVOeS+ibt5CZ/qu5aJEZQDxE4lN/hJddzHHOjgM0+
         RRKo8OKLGNaz1fu8Xof5bZQifk1gO+S9SLcbV3GE=
Date:   Mon, 6 Jul 2020 11:40:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH net-next v2 3/3] net: ethtool: Remove PHYLIB direct
 dependency
Message-ID: <20200706114000.223e27eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200706042758.168819-4-f.fainelli@gmail.com>
References: <20200706042758.168819-1-f.fainelli@gmail.com>
        <20200706042758.168819-4-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  5 Jul 2020 21:27:58 -0700 Florian Fainelli wrote:
> +	ops = ethtool_phy_ops;
> +	if (!ops || !ops->start_cable_test) {

nit: don't think member-by-member checking is necessary. We don't
expect there to be any alternative versions of the ops, right?

> +		ret = -EOPNOTSUPP;
> +		goto out_rtnl;
> +	}
> +
>  	ret = ethnl_ops_begin(dev);
>  	if (ret < 0)
>  		goto out_rtnl;
>  
> -	ret = phy_start_cable_test(dev->phydev, info->extack);
> +	ret = ops->start_cable_test(dev->phydev, info->extack);

nit: my personal preference would be to hide checking the ops and
calling the member in a static inline helper.

Note that we should be able to remove this from phy.h now:

#if IS_ENABLED(CONFIG_PHYLIB)
int phy_start_cable_test(struct phy_device *phydev,
			 struct netlink_ext_ack *extack);
int phy_start_cable_test_tdr(struct phy_device *phydev,
			     struct netlink_ext_ack *extack,
			     const struct phy_tdr_config *config);
#else
static inline
int phy_start_cable_test(struct phy_device *phydev,
			 struct netlink_ext_ack *extack)
{
	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
	return -EOPNOTSUPP;
}
static inline
int phy_start_cable_test_tdr(struct phy_device *phydev,
			     struct netlink_ext_ack *extack,
			     const struct phy_tdr_config *config)
{
	NL_SET_ERR_MSG(extack, "Kernel not compiled with PHYLIB support");
	return -EOPNOTSUPP;
}
#endif


We could even risk a direct call:

#if IS_REACHABLE(CONFIG_PHYLIB)
static inline int do_x()
{
	return __do_x();
}
#else
static inline int do_x()
{
	if (!ops)
		return -EOPNOTSUPP;
	return ops->do_x();
}
#endif

But that's perhaps doing too much...
