Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8777E289D5B
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 04:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgJJCFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 22:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:33528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729817AbgJJBqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 21:46:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCC8122245;
        Sat, 10 Oct 2020 01:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602294358;
        bh=iTtWEPs7R3iiq6VK1b1OfrjyVJP0Uism8CyeDJiP+1A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i3/UCdo4sP3wFVvX/GsyGPxSv+NwjzRumeuYLzX3/3SJCoMs2bq/S9SartvMqeZoV
         1SX+uZiRywSiMnwT0mk9trEnqyUeXfqOr5S87gAFtHsBvy+29SeRG8OiO0D0lwo1cX
         sHjtwGtujakQCWBgra+Xjitb8AkkTyt2bGyKVatA=
Date:   Fri, 9 Oct 2020 18:45:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v4 07/10] bridge: cfm: Netlink SET
 configuration Interface.
Message-ID: <20201009184556.6cfe6fbc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201009143530.2438738-8-henrik.bjoernlund@microchip.com>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
        <20201009143530.2438738-8-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Oct 2020 14:35:27 +0000 Henrik Bjoernlund wrote:
> +static inline struct mac_addr nla_get_mac(const struct nlattr *nla)

static inlines are generally not needed in C sources and just hide
unused code. Please drop the inline annotation.

> +{
> +	struct mac_addr mac;
> +
> +	nla_memcpy(&mac.addr, nla, sizeof(mac.addr));
> +
> +	return mac;
> +}
> +
> +static inline struct br_cfm_maid nla_get_maid(const struct nlattr *nla)

ditto

> +{
> +	struct br_cfm_maid maid;
> +
> +	nla_memcpy(&maid.data, nla, sizeof(maid.data));

returning a 48B struct from a helper is a little strange, but I guess
it's not too bad when compiler inlines the thing?

> +	return maid;
> +}
> +
> +static const struct nla_policy
> +br_cfm_policy[IFLA_BRIDGE_CFM_MAX + 1] = {
> +	[IFLA_BRIDGE_CFM_UNSPEC]		= { .type = NLA_REJECT },

Not needed, REJECT is treated the same as 0 / uninit, right?

> +	[IFLA_BRIDGE_CFM_MEP_CREATE]		= { .type = NLA_NESTED },

Consider using NLA_POLICY_NESTED() to link up the next layers.

> +	[IFLA_BRIDGE_CFM_MEP_DELETE]		= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_CFM_MEP_CONFIG]		= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_CFM_CC_CONFIG]		= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD]	= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE]	= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_CFM_CC_RDI]		= { .type = NLA_NESTED },
> +	[IFLA_BRIDGE_CFM_CC_CCM_TX]		= { .type = NLA_NESTED },
> +};
