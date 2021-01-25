Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F69A304913
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387493AbhAZF3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:29:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731417AbhAYTDH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 14:03:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46EAC2067B;
        Mon, 25 Jan 2021 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611601345;
        bh=Skuwd1IPU3qk3d6diQvKSRj1qZmAePV3Biv3OTvGyVI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GbMXZ46TquDqE0EbDwB8bsPAiqyQLzI1kPfJNTbmVpcR1tY9c4Yvkm/ZgIpYYbhAZ
         3iNnrUevp/ov0kDfLYBTUV3A+SXIwRcUJeG1u0g4SG7k7n+7gNbyg7XX9vSCkruf5G
         juKHl8KRVZjtYcqwb3gOiNGrqKsJPjSf24ZYzSQbQhKglzn/SFYTBx71IemHVxVwnn
         hFW1AVpismZ9rWU5vmfOQdbrqshf6keN8MyOV5QhzRCX0kxwZN3d3SOb4uwDvmwAJA
         Aca7rDMRM400R4my9oP1R9q09+uqDN7IOHD++yiqp2jUnRka1sBsAl4g2Rj4Ur+tJy
         cOfrbo8ZjYJxA==
Date:   Mon, 25 Jan 2021 11:02:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>, mlxsw <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next v3 1/7] ethtool: Extend link modes settings
 uAPI with lanes
Message-ID: <20210125110224.08886797@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <DM6PR12MB4516C3011B5D158930444203D8BD9@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210120093713.4000363-1-danieller@nvidia.com>
        <20210120093713.4000363-2-danieller@nvidia.com>
        <20210121194451.3fe8c8bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DM6PR12MB4516C3011B5D158930444203D8BD9@DM6PR12MB4516.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jan 2021 15:53:24 +0000 Danielle Ratson wrote:
> > > @@ -353,10 +358,39 @@ static int ethnl_update_linkmodes(struct
> > > genl_info *info, struct nlattr **tb,
> > >
> > >  	*mod = false;
> > >  	req_speed = tb[ETHTOOL_A_LINKMODES_SPEED];
> > > +	req_lanes = tb[ETHTOOL_A_LINKMODES_LANES];
> > >  	req_duplex = tb[ETHTOOL_A_LINKMODES_DUPLEX];
> > >
> > >  	ethnl_update_u8(&lsettings->autoneg, tb[ETHTOOL_A_LINKMODES_AUTONEG],
> > >  			mod);
> > > +
> > > +	if (req_lanes) {
> > > +		u32 lanes_cfg = nla_get_u32(tb[ETHTOOL_A_LINKMODES_LANES]);  
> > 
> > req_lanes == tb[ETHTOOL_A_LINKMODES_LANES], right?   
> 
> Yes, but req_lanes is a bool and doesn't fit to nla_get_u32. Do you want me to change the req_lanes type and name?

Ah, yes please.

> > Please use req_lanes variable where possible.
> >   
> > > +
> > > +		if (!is_power_of_2(lanes_cfg)) {
> > > +			NL_SET_ERR_MSG_ATTR(info->extack,
> > > +					    tb[ETHTOOL_A_LINKMODES_LANES],
> > > +					    "lanes value is invalid");
> > > +			return -EINVAL;
> > > +		}
> > > +
> > > +		/* If autoneg is off and lanes parameter is not supported by the
> > > +		 * driver, return an error.
> > > +		 */
> > > +		if (!lsettings->autoneg &&
> > > +		    !dev->ethtool_ops->cap_link_lanes_supported) {
> > > +			NL_SET_ERR_MSG_ATTR(info->extack,
> > > +					    tb[ETHTOOL_A_LINKMODES_LANES],
> > > +					    "lanes configuration not supported by device");
> > > +			return -EOPNOTSUPP;
> > > +		}  
> > 
> > This validation does not depend on the current settings at all,
> > it's just input validation, it can be done before rtnl_lock is
> > taken (in a new function).
> > 
> > You can move ethnl_validate_master_slave_cfg() to that function as
> > well (as a cleanup before this patch).  
> 
> Do you mean to move the ethnl_validate_master_slave_cfg() if from
> that function? 

Yes, to a separate helper.

> Doesn't it depend on the current settings, as opposed
> to the supported lanes param that you wanted me to move as well? Not
> sure I understand the second part of the request...

Sorry maybe I quoted a little too much context form the patch.

A helper like this:

static int ethnl_check_linkmodes(...)
{
	const struct nlattr *master_slave_cfg;
	
	master_slave_cfg = tb[ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG];
	if (master_slave_cfg && 
	    !ethnl_validate_master_slave_cfg(nla_get_u8(master_slave_cfg))) {
		NL_SET_ERR_MSG_ATTR(info->extack, master_slave_cfg,
				    "master/slave value is invalid");
		return -EOPNOTSUPP;
	}

	lanes_cfg = ...
	if (!is_power_of_2(...lanes_cfg)) {
		...
		return -EINVAL;
	}

	return 0;
}
 
Which you can call before the device reference is taken:

 int ethnl_set_linkmodes(struct sk_buff *skb, struct genl_info *info)
 {
 	struct ethtool_link_ksettings ksettings = {};
 	struct ethnl_req_info req_info = {};
 	struct nlattr **tb = info->attrs;
 	struct net_device *dev;
 	bool mod = false;
 	int ret;
 
+	ret = ethnl_check_linkmodes(tb);
+	if (ret)
+		return ret;
 
 	ret = ethnl_parse_header_dev_get(&req_info,
 					 tb[ETHTOOL_A_LINKMODES_HEADER],
 					 genl_info_net(info), info->extack,
 					 true);
 	if (ret < 0)
 		return ret;


But please make sure that you move the master_slave_cfg check in a
separate patch.
