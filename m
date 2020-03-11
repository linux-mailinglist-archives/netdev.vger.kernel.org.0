Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9253F1825B4
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 00:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731494AbgCKXQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 19:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731338AbgCKXQ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 19:16:28 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4BDBE2074F;
        Wed, 11 Mar 2020 23:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583968587;
        bh=M70agrfssHoPC0ilpkLCRMDtLq4/+qKfN23DruDaesA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zGb2nUUcfnL2QLTUh6RV9QAQrmf2L7DOqnEEoJMSonXk5Rdx7OuMhNE4y0aTvaz+L
         LLwABvSgQouIcektbiVBBLYuFlJ2zA6HHdgnSiwQtBLpf7+fSv7KqumdZRKX2X4xGl
         ODuwMizUBUWTKNA9g7nHU+NeVhXC4o6FZ46MGXLU=
Date:   Wed, 11 Mar 2020 16:16:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Linville <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 10/15] ethtool: provide ring sizes with
 RINGS_GET request
Message-ID: <20200311161625.7292f745@kicinski-fedora-PC1C0HJN>
In-Reply-To: <55a76ca4eecc92c7209775340ff36ba5dd32f713.1583962006.git.mkubecek@suse.cz>
References: <cover.1583962006.git.mkubecek@suse.cz>
        <55a76ca4eecc92c7209775340ff36ba5dd32f713.1583962006.git.mkubecek@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 22:40:53 +0100 (CET) Michal Kubecek wrote:
> +static int rings_prepare_data(const struct ethnl_req_info *req_base,
> +			      struct ethnl_reply_data *reply_base,
> +			      struct genl_info *info)
> +{
> +	struct rings_reply_data *data = RINGS_REPDATA(reply_base);
> +	struct net_device *dev = reply_base->dev;
> +	int ret;
> +
> +	if (!dev->ethtool_ops->get_ringparam)
> +		return -EOPNOTSUPP;
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		return ret;
> +	dev->ethtool_ops->get_ringparam(dev, &data->ringparam);
> +	ret = 0;
> +	ethnl_ops_complete(dev);
> +
> +	return ret;

nit: just return 0 and drop ret = 0 above, there is no goto here

> +}
> +
> +static int rings_reply_size(const struct ethnl_req_info *req_base,
> +			    const struct ethnl_reply_data *reply_base)
> +{
> +	return 8 * nla_total_size(sizeof(u32))

nit: 8 is a little bit of a magic constant

> +		+ 0;

nit: personally not a huge fan

> +}
> +
> +static int rings_fill_reply(struct sk_buff *skb,
> +			    const struct ethnl_req_info *req_base,
> +			    const struct ethnl_reply_data *reply_base)
> +{
> +	const struct rings_reply_data *data = RINGS_REPDATA(reply_base);
> +	const struct ethtool_ringparam *ringparam = &data->ringparam;
> +
> +	if (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_MAX,
> +			ringparam->rx_max_pending) ||
> +	    nla_put_u32(skb, ETHTOOL_A_RINGS_RX_MINI_MAX,
> +			ringparam->rx_mini_max_pending) ||
> +	    nla_put_u32(skb, ETHTOOL_A_RINGS_RX_JUMBO_MAX,
> +			ringparam->rx_jumbo_max_pending) ||
> +	    nla_put_u32(skb, ETHTOOL_A_RINGS_TX_MAX,
> +			ringparam->tx_max_pending) ||
> +	    nla_put_u32(skb, ETHTOOL_A_RINGS_RX,
> +			ringparam->rx_pending) ||
> +	    nla_put_u32(skb, ETHTOOL_A_RINGS_RX_MINI,
> +			ringparam->rx_mini_pending) ||
> +	    nla_put_u32(skb, ETHTOOL_A_RINGS_RX_JUMBO,
> +			ringparam->rx_jumbo_pending) ||
> +	    nla_put_u32(skb, ETHTOOL_A_RINGS_TX,
> +			ringparam->tx_pending))
> +		return -EMSGSIZE;

nit: I wonder if it's necessary to report the zero values..

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
