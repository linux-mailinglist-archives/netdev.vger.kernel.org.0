Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57CD1345446
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhCWAzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:55:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41970 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231180AbhCWAyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 20:54:35 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lOVJW-00CVJm-4n; Tue, 23 Mar 2021 01:54:30 +0100
Date:   Tue, 23 Mar 2021 01:54:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Adrian Pop <pop.adrian61@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Don Bollinger <don@thebollingers.org>, netdev@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V4 net-next 1/5] ethtool: Allow network drivers to
 dump arbitrary EEPROM data
Message-ID: <YFk8RldROAyivyuj@lunn.ch>
References: <1616433075-27051-1-git-send-email-moshe@nvidia.com>
 <1616433075-27051-2-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1616433075-27051-2-git-send-email-moshe@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int eeprom_prepare_data(const struct ethnl_req_info *req_base,
> +			       struct ethnl_reply_data *reply_base,
> +			       struct genl_info *info)
> +{
> +	struct eeprom_reply_data *reply = MODULE_EEPROM_REPDATA(reply_base);
> +	struct eeprom_req_info *request = MODULE_EEPROM_REQINFO(req_base);
> +	struct ethtool_module_eeprom page_data = {0};
> +	struct net_device *dev = reply_base->dev;
> +	int ret;
> +
> +	if (!dev->ethtool_ops->get_module_eeprom_by_page)
> +		return -EOPNOTSUPP;
> +
> +	/* Allow dumps either of low or high page without crossing half page boundary */
> +	if ((request->offset < ETH_MODULE_EEPROM_PAGE_LEN / 2 &&
> +	     request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN / 2) ||
> +	    request->offset + request->length > ETH_MODULE_EEPROM_PAGE_LEN)
> +		return -EINVAL;

Please keep all the parameter validation together, in
eeprom_parse_request(). At some point, we may extend
eeprom_parse_request() to make use of extack, to indicate which
parameter is invalid. Just getting an -EINVAL can be hard to debug,
where as NL_SET_ERR_MSG_ATTR() can help the user.

      Andrew
