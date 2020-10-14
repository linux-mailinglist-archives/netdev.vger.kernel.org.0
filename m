Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25EC28E938
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 01:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731854AbgJNXdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 19:33:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:50024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727890AbgJNXdv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 19:33:51 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 656042078A;
        Wed, 14 Oct 2020 23:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602718430;
        bh=fJuaBZAYZB2ASZnOsQGXjvE2pynwdjPBgfBtVj+H8F4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c/Mwj5CLJFeg5vBNDeMaxa33nHbmDZun8T/4ILG736efYFWqfucNlCWD/mIFyIp0U
         EbkSPN2poPGBQpgEfedIaBV4grIdHVZ/SciOKy6ZsdQv2lRhMDJIo1dCmFQiNAj1mh
         NUAIvlAl5JzBpAH2m/B0/JqLfxXctsj8mei7fBTM=
Date:   Wed, 14 Oct 2020 16:33:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
Cc:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 08/10] bridge: cfm: Netlink GET
 configuration Interface.
Message-ID: <20201014163348.2f99e349@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201012140428.2549163-9-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
        <20201012140428.2549163-9-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Oct 2020 14:04:26 +0000 Henrik Bjoernlund wrote:
> +		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE,
> +				mep->cc_ccm_tx_info.seq_no_update))
> +			goto nla_put_failure;
> +
> +		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD,
> +				mep->cc_ccm_tx_info.period))
> +			goto nla_put_failure;
> +
> +		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV,
> +				mep->cc_ccm_tx_info.if_tlv))
> +			goto nla_put_failure;
> +
> +		if (nla_put_u8(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE,
> +			       mep->cc_ccm_tx_info.if_tlv_value))
> +			goto nla_put_failure;
> +
> +		if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV,
> +				mep->cc_ccm_tx_info.port_tlv))
> +			goto nla_put_failure;
> +
> +		if (nla_put_u8(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE,
> +			       mep->cc_ccm_tx_info.port_tlv_value))
> +			goto nla_put_failure;

Consider collapsing writing related attrs in a nest into a single
if statement:

	if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE,
			mep->cc_ccm_tx_info.seq_no_update) ||
	    nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD,
			mep->cc_ccm_tx_info.period) ||
		...
