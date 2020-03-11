Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B989A1825C2
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 00:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbgCKXWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 19:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387410AbgCKXWx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 19:22:53 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4A6020751;
        Wed, 11 Mar 2020 23:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583968973;
        bh=3tRF0qODHgRc2/92DC4wS65TgSACth1Nm0FyprTE08s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PsZ4/Visf0exp0IIyIOP6r25c9a9N236F1EPIAj5bZAzsXYMCS+fk+fH/u892aVXU
         seqoxETfxP9p1RA5qXVL31xcrEWgC7Gcyr3iIJQYNOpircxQVaoZWsHTwJFcbFv0OG
         gmLdxAVmakAR451XxESw/tc+94llxrE8na4mSknw=
Date:   Wed, 11 Mar 2020 16:22:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 11/15] ethtool: set device ring sizes with
 RINGS_SET request
Message-ID: <20200311162251.0317e09a@kicinski-fedora-PC1C0HJN>
In-Reply-To: <ec91e4c53d75ec8e499ecaec36948674b2ef07cc.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
        <ec91e4c53d75ec8e499ecaec36948674b2ef07cc.1583962006.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 22:40:58 +0100 (CET) Michal Kubecek wrote:
> +int ethnl_set_rings(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct nlattr *tb[ETHTOOL_A_RINGS_MAX + 1];
> +	struct ethtool_ringparam ringparam = {};
> +	struct ethnl_req_info req_info = {};
> +	const struct nlattr *err_attr;
> +	const struct ethtool_ops *ops;
> +	struct net_device *dev;
> +	bool mod = false;
> +	int ret;
> +
> +	ret = nlmsg_parse(info->nlhdr, GENL_HDRLEN, tb,
> +			  ETHTOOL_A_RINGS_MAX, rings_set_policy,
> +			  info->extack);
> +	if (ret < 0)
> +		return ret;
> +	ret = ethnl_parse_header_dev_get(&req_info,
> +					 tb[ETHTOOL_A_RINGS_HEADER],
> +					 genl_info_net(info), info->extack,
> +					 true);
> +	if (ret < 0)
> +		return ret;
> +	dev = req_info.dev;
> +	ops = dev->ethtool_ops;
> +	if (!ops->get_ringparam || !ops->set_ringparam)
> +		return -EOPNOTSUPP;

Leaking the dev reference here?

> +
> +	rtnl_lock();
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		goto out_rtnl;
> +	ops->get_ringparam(dev, &ringparam);
> +
> +	ethnl_update_u32(&ringparam.rx_pending, tb[ETHTOOL_A_RINGS_RX], &mod);
> +	ethnl_update_u32(&ringparam.rx_mini_pending,
> +			 tb[ETHTOOL_A_RINGS_RX_MINI], &mod);
> +	ethnl_update_u32(&ringparam.rx_jumbo_pending,
> +			 tb[ETHTOOL_A_RINGS_RX_JUMBO], &mod);
> +	ethnl_update_u32(&ringparam.tx_pending, tb[ETHTOOL_A_RINGS_TX], &mod);
> +	ret = 0;
> +	if (!mod)
> +		goto out_ops;
> +
> +	/* ensure new ring parameters are within limits */
> +	if (ringparam.rx_pending > ringparam.rx_max_pending)
> +		err_attr = tb[ETHTOOL_A_RINGS_RX];
> +	else if (ringparam.rx_mini_pending > ringparam.rx_mini_max_pending)
> +		err_attr = tb[ETHTOOL_A_RINGS_RX_MINI];
> +	else if (ringparam.rx_jumbo_pending > ringparam.rx_jumbo_max_pending)
> +		err_attr = tb[ETHTOOL_A_RINGS_RX_JUMBO];
> +	else if (ringparam.tx_pending > ringparam.tx_max_pending)
> +		err_attr = tb[ETHTOOL_A_RINGS_TX];
> +	else
> +		err_attr = NULL;
> +	if (err_attr) {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG_ATTR(info->extack, err_attr,
> +				    "requested ring size exceeeds maximum");
> +		goto out_ops;
> +	}
> +
> +	ret = dev->ethtool_ops->set_ringparam(dev, &ringparam);
> +
> +out_ops:
> +	ethnl_ops_complete(dev);
> +out_rtnl:
> +	rtnl_unlock();
> +	dev_put(dev);
> +	return ret;
> +}

