Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5F21B93F8
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 22:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgDZUif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 16:38:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36862 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgDZUif (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 16:38:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XChHcol3z6WkRRfudKrv6MH2+54Zu4xgD2AAuW6iUlU=; b=VGm7pITwwyJTSgbuCPRjjhOklb
        9PC0Un5gEDcfW9SwbNMX5oYumcslCddRsmk1ZZ2i6xciVA3loBX47rFTG2MM9WCElRo5TXIqqqIrJ
        nsSfVwL7dUQCcyey0yiqwByFXldviK2UQcRc9miEZxG7kRt8pnTczkk0gm7C/MFwAGxk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jSo2r-0050tu-MU; Sun, 26 Apr 2020 22:38:33 +0200
Date:   Sun, 26 Apr 2020 22:38:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>
Subject: Re: [PATCH net-next v1 3/9] net: ethtool: netlink: Add support for
 triggering a cable test
Message-ID: <20200426203833.GB1183480@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200425180621.1140452-4-andrew@lunn.ch>
 <20200426193634.GB23225@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426193634.GB23225@lion.mk-sys.cz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +const struct ethnl_request_ops ethnl_cable_test_act_ops = {
> > +	.request_cmd		= ETHTOOL_MSG_CABLE_TEST_ACT,
> > +	.reply_cmd		= ETHTOOL_MSG_CABLE_TEST_ACT_REPLY,
> > +	.hdr_attr		= ETHTOOL_A_CABLE_TEST_HEADER,
> > +	.max_attr		= ETHTOOL_A_CABLE_TEST_MAX,
> > +	.req_info_size		= sizeof(struct cable_test_req_info),
> > +	.reply_data_size	= sizeof(struct cable_test_reply_data),
> > +	.request_policy		= cable_test_get_policy,
> > +};
> > +
> 
> As you register ethnl_act_cable_test() as doit handler and don't use any
> of ethnl_default_*() handlers, you don't need to define
> ethnl_cable_test_act_ops (and also struct cable_test_req_info and struct
> cable_test_reply_data). These would be only used by default doit/dumpit
> handlers and default notification handler.

O.K, than

> 
> > +/* CABLE_TEST_ACT */
> > +
> > +static const struct nla_policy
> > +cable_test_set_policy[ETHTOOL_A_CABLE_TEST_MAX + 1] = {
> > +	[ETHTOOL_A_CABLE_TEST_UNSPEC]		= { .type = NLA_REJECT },
> > +	[ETHTOOL_A_CABLE_TEST_HEADER]		= { .type = NLA_NESTED },
> > +};
> 
> This should be probably rather named cable_test_act_policy - or maybe
> cable_test_policy would suffice as you have only one request message
> type (I've been using *_get_policy for *_GET request and *_set_policy
> for *_SET).

I probably just cut/paste and changes the name, but not set to act. I
will fix this.

> > +int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
> > +{
> > +	struct nlattr *tb[ETHTOOL_A_CABLE_TEST_MAX + 1];
> > +	struct ethnl_req_info req_info = {};
> > +	struct net_device *dev;
> > +	int ret;
> > +
> > +	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
> > +			  ETHTOOL_A_CABLE_TEST_MAX,
> > +			  cable_test_set_policy, info->extack);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	ret = ethnl_parse_header_dev_get(&req_info,
> > +					 tb[ETHTOOL_A_CABLE_TEST_HEADER],
> > +					 genl_info_net(info), info->extack,
> > +					 true);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	dev = req_info.dev;
> > +	if (!dev->phydev) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out_dev_put;
> > +	}
> > +
> > +	rtnl_lock();
> > +	ret = ethnl_ops_begin(dev);
> > +	if (ret < 0)
> > +		goto out_rtnl;
> > +
> > +	ret = phy_start_cable_test(dev->phydev, info->extack);
> > +
> > +	ethnl_ops_complete(dev);
> > +out_rtnl:
> > +	rtnl_unlock();
> > +out_dev_put:
> > +	dev_put(dev);
> > +	return ret;
> > +}
> 
> As you don't send a reply message, you don't need
> ETHTOOL_MSG_CABLE_TEST_ACT_REPLY either (we may introduce it later if
> there is a reply message).

One thing i was thinking about is sending user space a cookie at this
point, to help pair the request to the multicasted results. Then the
reply would be useful.

      Andrew
