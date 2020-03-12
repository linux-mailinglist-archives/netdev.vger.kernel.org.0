Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E233182C40
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 10:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgCLJTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 05:19:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:49584 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgCLJTt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 05:19:49 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6B79AAC67;
        Thu, 12 Mar 2020 09:19:47 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 94220E0C79; Thu, 12 Mar 2020 10:19:43 +0100 (CET)
Date:   Thu, 12 Mar 2020 10:19:43 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 03/15] ethtool: provide netdev features with
 FEATURES_GET request
Message-ID: <20200312091943.GK8012@unicorn.suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
 <a3ed11c43f5ac0a68d3b3dfdf62de755ad240e59.1583962006.git.mkubecek@suse.cz>
 <20200311154908.7fd7047d@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311154908.7fd7047d@kicinski-fedora-PC1C0HJN>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 03:49:08PM -0700, Jakub Kicinski wrote:
> On Wed, 11 Mar 2020 22:40:18 +0100 (CET) Michal Kubecek wrote:
> >  
> > +#define ETHTOOL_DEV_FEATURE_WORDS	((NETDEV_FEATURE_COUNT + 31) / 32)
> 
> nit: since this line is touched perhaps worth converting to
> DIV_ROUND_UP()?

Yes.

> > +	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; i++)
> > +		dest[i] = (u32)(src >> (32 * i));
> 
> nit: cast unnecessary

OK.

> > +	all_features = ~(netdev_features_t)0 >>
> > +		       (8 * sizeof(all_features) - NETDEV_FEATURE_COUNT);
> 
> nit: GENMASK_ULL(NETDEV_FEATURE_COUNT % 32 - 1, 0) ?

Nice, I wasn't aware of this macro. But unless I want to fill data->all
directly, it would be without the "% 32" part.

> > +static int features_fill_reply(struct sk_buff *skb,
> > +			       const struct ethnl_req_info *req_base,
> > +			       const struct ethnl_reply_data *reply_base)
> > +{
> > +	const struct features_reply_data *data = FEATURES_REPDATA(reply_base);
> > +	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
> > +	int ret;
> > +
> > +	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_HW, data->hw,
> > +				 data->all, NETDEV_FEATURE_COUNT,
> > +				 netdev_features_strings, compact);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_WANTED, data->wanted,
> > +				 NULL, NETDEV_FEATURE_COUNT,
> > +				 netdev_features_strings, compact);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_ACTIVE, data->active,
> > +				 NULL, NETDEV_FEATURE_COUNT,
> > +				 netdev_features_strings, compact);
> > +	if (ret < 0)
> > +		return ret;
> > +	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_NOCHANGE,
> > +				 data->nochange, NULL, NETDEV_FEATURE_COUNT,
> > +				 netdev_features_strings, compact);
> > +
> > +	return ret;
> 
> nit: return directly?

Ah, right. I eliminated "if (ret < 0)" but did not check again.

Michal
