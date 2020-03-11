Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8314818252D
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 23:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbgCKWtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 18:49:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729739AbgCKWtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 18:49:12 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA6A2206E7;
        Wed, 11 Mar 2020 22:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583966951;
        bh=XDMWLM9ZHsVTFkpy0uJjXIAczv20ViLNNjhPI5zknsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1w/KIC0mZ0s4oZnaEPtBnHleQZ6kopaDqTWirZwjawbTR9KjRTFAFIM88rUl2BTPM
         OoQuXoXxJ8H39IJx3Zf5bwYtMIFeVPXauFBPYBCwQi7azq+aBm8WZgd5uNd7nTXq/u
         VrP6MGat6sMTkAEfvs/HGdCjARGgOfSYwhzEaMSo=
Date:   Wed, 11 Mar 2020 15:49:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 03/15] ethtool: provide netdev features with
 FEATURES_GET request
Message-ID: <20200311154908.7fd7047d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <a3ed11c43f5ac0a68d3b3dfdf62de755ad240e59.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
        <a3ed11c43f5ac0a68d3b3dfdf62de755ad240e59.1583962006.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 22:40:18 +0100 (CET) Michal Kubecek wrote:
> diff --git a/net/ethtool/common.h b/net/ethtool/common.h
> index 40ba74e0b9bb..82211430d3db 100644
> --- a/net/ethtool/common.h
> +++ b/net/ethtool/common.h
> @@ -6,6 +6,8 @@
>  #include <linux/netdevice.h>
>  #include <linux/ethtool.h>
>  
> +#define ETHTOOL_DEV_FEATURE_WORDS	((NETDEV_FEATURE_COUNT + 31) / 32)

nit: since this line is touched perhaps worth converting to
DIV_ROUND_UP()?

>  /* compose link mode index from speed, type and duplex */
>  #define ETHTOOL_LINK_MODE(speed, type, duplex) \
>  	ETHTOOL_LINK_MODE_ ## speed ## base ## type ## _ ## duplex ## _BIT

> +static void ethnl_features_to_bitmap32(u32 *dest, netdev_features_t src)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ETHTOOL_DEV_FEATURE_WORDS; i++)
> +		dest[i] = (u32)(src >> (32 * i));

nit: cast unnecessary

> +}
> +
> +static int features_prepare_data(const struct ethnl_req_info *req_base,
> +				 struct ethnl_reply_data *reply_base,
> +				 struct genl_info *info)
> +{
> +	struct features_reply_data *data = FEATURES_REPDATA(reply_base);
> +	struct net_device *dev = reply_base->dev;
> +	netdev_features_t all_features;
> +
> +	ethnl_features_to_bitmap32(data->hw, dev->hw_features);
> +	ethnl_features_to_bitmap32(data->wanted, dev->wanted_features);
> +	ethnl_features_to_bitmap32(data->active, dev->features);
> +	ethnl_features_to_bitmap32(data->nochange, NETIF_F_NEVER_CHANGE);
> +	all_features = ~(netdev_features_t)0 >>
> +		       (8 * sizeof(all_features) - NETDEV_FEATURE_COUNT);

nit: GENMASK_ULL(NETDEV_FEATURE_COUNT % 32 - 1, 0) ?

> +	ethnl_features_to_bitmap32(data->all, all_features);
> +
> +	return 0;
> +}

> +static int features_fill_reply(struct sk_buff *skb,
> +			       const struct ethnl_req_info *req_base,
> +			       const struct ethnl_reply_data *reply_base)
> +{
> +	const struct features_reply_data *data = FEATURES_REPDATA(reply_base);
> +	bool compact = req_base->flags & ETHTOOL_FLAG_COMPACT_BITSETS;
> +	int ret;
> +
> +	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_HW, data->hw,
> +				 data->all, NETDEV_FEATURE_COUNT,
> +				 netdev_features_strings, compact);
> +	if (ret < 0)
> +		return ret;
> +	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_WANTED, data->wanted,
> +				 NULL, NETDEV_FEATURE_COUNT,
> +				 netdev_features_strings, compact);
> +	if (ret < 0)
> +		return ret;
> +	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_ACTIVE, data->active,
> +				 NULL, NETDEV_FEATURE_COUNT,
> +				 netdev_features_strings, compact);
> +	if (ret < 0)
> +		return ret;
> +	ret = ethnl_put_bitset32(skb, ETHTOOL_A_FEATURES_NOCHANGE,
> +				 data->nochange, NULL, NETDEV_FEATURE_COUNT,
> +				 netdev_features_strings, compact);
> +
> +	return ret;

nit: return directly?

> +}

Probably not worth respinning for just those nits:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

