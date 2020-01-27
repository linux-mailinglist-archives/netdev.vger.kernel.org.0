Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 218ED149EFA
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 07:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgA0GXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 01:23:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:47502 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgA0GXW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 01:23:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CF065B071;
        Mon, 27 Jan 2020 06:23:19 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id EBE4FE0B78; Mon, 27 Jan 2020 07:23:17 +0100 (CET)
Date:   Mon, 27 Jan 2020 07:23:17 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] ethtool: set message mask with DEBUG_SET
 request
Message-ID: <20200127062317.GB570@unicorn.suse.cz>
References: <cover.1580075977.git.mkubecek@suse.cz>
 <844bf6bf518640fbfc67b5dd7976d9e8683c2d2d.1580075977.git.mkubecek@suse.cz>
 <20200127002206.GC12816@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127002206.GC12816@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 01:22:06AM +0100, Andrew Lunn wrote:
> On Sun, Jan 26, 2020 at 11:11:07PM +0100, Michal Kubecek wrote:
> > Implement DEBUG_SET netlink request to set debugging settings for a device.
> > At the moment, only message mask corresponding to message level as set by
> > ETHTOOL_SMSGLVL ioctl request can be set. (It is called message level in
> > ioctl interface but almost all drivers interpret it as a bit mask.)
> > 
> > Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
> > +int ethnl_set_debug(struct sk_buff *skb, struct genl_info *info)
> > +{
> > +	struct nlattr *tb[ETHTOOL_A_DEBUG_MAX + 1];
> > +	struct ethnl_req_info req_info = {};
> > +	struct net_device *dev;
> > +	bool mod = false;
> > +	u32 msg_mask;
> > +	int ret;
> > +
> > +	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
> > +			  ETHTOOL_A_DEBUG_MAX, debug_set_policy,
> > +			  info->extack);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = ethnl_parse_header(&req_info, tb[ETHTOOL_A_DEBUG_HEADER],
> > +				 genl_info_net(info), info->extack, true);
> > +	if (ret < 0)
> > +		return ret;
> > +	dev = req_info.dev;
> > +	if (!dev->ethtool_ops->get_msglevel || !dev->ethtool_ops->set_msglevel)
> > +		return -EOPNOTSUPP;
> 
> This seems like a new requirement, that both get and set callbacks are
> implemented. However, A quick look thought the code suggests all
> drivers already do have both get and set. So i think this is safe.

Technically it's a new requirement but as ethtool (userspace utility)
always issues ETHTOOL_GMSGLVL before ETHTOOL_SMSGLVL and does so even
for command lines like "ethtool -s eth0 msglvl 5" where it's not really
needed, providing ->set_msglevel() without ->get_msglevel() wouldn't
be of much use even now.

Michal

> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>     Andrew
