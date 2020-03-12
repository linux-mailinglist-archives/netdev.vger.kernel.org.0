Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB01183036
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 13:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgCLM3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 08:29:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:58204 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726841AbgCLM3a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 08:29:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7C355AFE3;
        Thu, 12 Mar 2020 12:29:26 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id ACE64E0C79; Thu, 12 Mar 2020 13:29:22 +0100 (CET)
Date:   Thu, 12 Mar 2020 13:29:22 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 10/15] ethtool: provide ring sizes with
 RINGS_GET request
Message-ID: <20200312122922.GN8012@unicorn.suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
 <55a76ca4eecc92c7209775340ff36ba5dd32f713.1583962006.git.mkubecek@suse.cz>
 <20200311161625.7292f745@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311161625.7292f745@kicinski-fedora-PC1C0HJN>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 04:16:25PM -0700, Jakub Kicinski wrote:
> On Wed, 11 Mar 2020 22:40:53 +0100 (CET) Michal Kubecek wrote:
> > +static int rings_prepare_data(const struct ethnl_req_info *req_base,
> > +			      struct ethnl_reply_data *reply_base,
> > +			      struct genl_info *info)
> > +{
> > +	struct rings_reply_data *data = RINGS_REPDATA(reply_base);
> > +	struct net_device *dev = reply_base->dev;
> > +	int ret;
> > +
> > +	if (!dev->ethtool_ops->get_ringparam)
> > +		return -EOPNOTSUPP;
> > +	ret = ethnl_ops_begin(dev);
> > +	if (ret < 0)
> > +		return ret;
> > +	dev->ethtool_ops->get_ringparam(dev, &data->ringparam);
> > +	ret = 0;
> > +	ethnl_ops_complete(dev);
> > +
> > +	return ret;
> 
> nit: just return 0 and drop ret = 0 above, there is no goto here

OK

> > +}
> > +
> > +static int rings_reply_size(const struct ethnl_req_info *req_base,
> > +			    const struct ethnl_reply_data *reply_base)
> > +{
> > +	return 8 * nla_total_size(sizeof(u32))
> 
> nit: 8 is a little bit of a magic constant

I'll rewrite this as a sum of 8 entries with comment referring to
attribute types. It's still a compile time computed constant so that
there should be no impact on resulting code.

> > +		+ 0;
> 
> nit: personally not a huge fan

I don't like it either, to be honest. I just thought, based on reading
some earlier discussions, that it's the preferred way as it enforces
a compiler error when someone adds a new attribute and forgets to
replace the semicolon with plus (which IIRC happened in the past).

But as I checked now, reasonably new gcc (at least from version 7)
issues a warning in such case so that it wouldn't go unnoticed with
various kbuild bots around. So I agree to get rid of this trick.

> > +static int rings_fill_reply(struct sk_buff *skb,
> > +			    const struct ethnl_req_info *req_base,
> > +			    const struct ethnl_reply_data *reply_base)
> > +{
> > +	const struct rings_reply_data *data = RINGS_REPDATA(reply_base);
> > +	const struct ethtool_ringparam *ringparam = &data->ringparam;
> > +
> > +	if (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_MAX,
> > +			ringparam->rx_max_pending) ||
> > +	    nla_put_u32(skb, ETHTOOL_A_RINGS_RX_MINI_MAX,
> > +			ringparam->rx_mini_max_pending) ||
> > +	    nla_put_u32(skb, ETHTOOL_A_RINGS_RX_JUMBO_MAX,
> > +			ringparam->rx_jumbo_max_pending) ||
> > +	    nla_put_u32(skb, ETHTOOL_A_RINGS_TX_MAX,
> > +			ringparam->tx_max_pending) ||
> > +	    nla_put_u32(skb, ETHTOOL_A_RINGS_RX,
> > +			ringparam->rx_pending) ||
> > +	    nla_put_u32(skb, ETHTOOL_A_RINGS_RX_MINI,
> > +			ringparam->rx_mini_pending) ||
> > +	    nla_put_u32(skb, ETHTOOL_A_RINGS_RX_JUMBO,
> > +			ringparam->rx_jumbo_pending) ||
> > +	    nla_put_u32(skb, ETHTOOL_A_RINGS_TX,
> > +			ringparam->tx_pending))
> > +		return -EMSGSIZE;
> 
> nit: I wonder if it's necessary to report the zero values..

Good point. I would say that it makes perfect sense to omit the
attributes if the max value is zero (i.e. this type of ring is not
supported) but I would still report zero current size if corresponding
limit is not zero as it means the zero size is meaningful. (Many drivers
do not allow zero size but I found one which does.)

Michal
