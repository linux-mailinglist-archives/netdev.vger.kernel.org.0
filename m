Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C001F4510D
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 03:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725886AbfFNBMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 21:12:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54120 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbfFNBMa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 21:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O1UiBE1s0tMb0CzdEK7VtfLz1osTnXVPdOS0E6pQi9I=; b=KDIm0p71c1im1lUYO6WUL9DAcO
        pPkFskm5t5KDdLnzgcDWCkk3IlbAr5eF5odqmxplf/XAemNhckk3dZL9h66sRlx74Fp4Dk0TZmj1O
        /A/RWfWh7A7LZczcAhmEwX5PgrE1aLrulROquCuftOgHFqRqzp09Yb9lTSOBTcrBRz6M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hbalU-0007zk-Vs; Fri, 14 Jun 2019 03:12:24 +0200
Date:   Fri, 14 Jun 2019 03:12:24 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     linux@armlinux.org.uk, hkallweit1@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, ruxandra.radulescu@nxp.com
Subject: Re: [PATCH RFC 3/6] dpaa2-mac: add MC API for the DPMAC object
Message-ID: <20190614011224.GC28822@lunn.ch>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-4-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560470153-26155-4-git-send-email-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +/**
> + * dpmac_set_link_state() - Set the Ethernet link status
> + * @mc_io:      Pointer to opaque I/O object
> + * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'
> + * @token:      Token of DPMAC object
> + * @link_state: Link state configuration
> + *
> + * Return:      '0' on Success; Error code otherwise.
> + */
> +int dpmac_set_link_state(struct fsl_mc_io *mc_io,
> +			 u32 cmd_flags,
> +			 u16 token,
> +			 struct dpmac_link_state *link_state)
> +{
> +	struct dpmac_cmd_set_link_state *cmd_params;
> +	struct fsl_mc_command cmd = { 0 };
> +
> +	/* prepare command */
> +	cmd.header = mc_encode_cmd_header(DPMAC_CMDID_SET_LINK_STATE,
> +					  cmd_flags,
> +					  token);
> +	cmd_params = (struct dpmac_cmd_set_link_state *)cmd.params;
> +	cmd_params->options = cpu_to_le64(link_state->options);
> +	cmd_params->rate = cpu_to_le32(link_state->rate);
> +	dpmac_set_field(cmd_params->state, STATE, link_state->up);
> +	dpmac_set_field(cmd_params->state, STATE_VALID,
> +			link_state->state_valid);
> +	cmd_params->supported = cpu_to_le64(link_state->supported);
> +	cmd_params->advertising = cpu_to_le64(link_state->advertising);

I don't understand what supported and advertising mean in the context
of a MAC. PHY yes, but MAC?

> + * DPMAC link configuration/state options
> + */
> +
> +/**
> + * Enable auto-negotiation
> + */
> +#define DPMAC_LINK_OPT_AUTONEG			BIT_ULL(0)
> +/**
> + * Enable half-duplex mode
> + */
> +#define DPMAC_LINK_OPT_HALF_DUPLEX		BIT_ULL(1)
> +/**
> + * Enable pause frames
> + */
> +#define DPMAC_LINK_OPT_PAUSE			BIT_ULL(2)
> +/**
> + * Enable a-symmetric pause frames
> + */
> +#define DPMAC_LINK_OPT_ASYM_PAUSE		BIT_ULL(3)

So is this to configure the MAC? The MAC can do half duplex, pause,
asym pause? 

But from the previous patch, the PHY cannot do half duplex?

     Andrew
