Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3146F4855B
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfFQO2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 10:28:21 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33194 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726642AbfFQO2U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 10:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2ill3+BPg+PjYSkFeffTLMYEsH7eA76ZuTeUwvDT5ig=; b=EJIBwP/1X4q3GB6IpNCDIptbCh
        il2B7WWqPOsjMq8H6R/+1nj6lXipox0lrztKuamG2jk6dlnY8WeE4Tc/uzsyNaoZrxoO/DkDQLqjj
        eZogdnHYOdwXb3CDHB4MbZuq4cdduJiP/b3bI7S2d0mv3QP4Ce/yQPel+OphB29GBB6s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hcscH-000837-Mc; Mon, 17 Jun 2019 16:28:13 +0200
Date:   Mon, 17 Jun 2019 16:28:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH RFC 3/6] dpaa2-mac: add MC API for the DPMAC object
Message-ID: <20190617142813.GD25211@lunn.ch>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-4-git-send-email-ioana.ciornei@nxp.com>
 <20190614011224.GC28822@lunn.ch>
 <VI1PR0402MB28002EE1DB0B3FB39B907052E0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB28002EE1DB0B3FB39B907052E0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 02:06:05PM +0000, Ioana Ciornei wrote:
> > Subject: Re: [PATCH RFC 3/6] dpaa2-mac: add MC API for the DPMAC object
> > 
> > > +/**
> > > + * dpmac_set_link_state() - Set the Ethernet link status
> > > + * @mc_io:      Pointer to opaque I/O object
> > > + * @cmd_flags:  Command flags; one or more of 'MC_CMD_FLAG_'
> > > + * @token:      Token of DPMAC object
> > > + * @link_state: Link state configuration
> > > + *
> > > + * Return:      '0' on Success; Error code otherwise.
> > > + */
> > > +int dpmac_set_link_state(struct fsl_mc_io *mc_io,
> > > +			 u32 cmd_flags,
> > > +			 u16 token,
> > > +			 struct dpmac_link_state *link_state) {
> > > +	struct dpmac_cmd_set_link_state *cmd_params;
> > > +	struct fsl_mc_command cmd = { 0 };
> > > +
> > > +	/* prepare command */
> > > +	cmd.header =
> > mc_encode_cmd_header(DPMAC_CMDID_SET_LINK_STATE,
> > > +					  cmd_flags,
> > > +					  token);
> > > +	cmd_params = (struct dpmac_cmd_set_link_state *)cmd.params;
> > > +	cmd_params->options = cpu_to_le64(link_state->options);
> > > +	cmd_params->rate = cpu_to_le32(link_state->rate);
> > > +	dpmac_set_field(cmd_params->state, STATE, link_state->up);
> > > +	dpmac_set_field(cmd_params->state, STATE_VALID,
> > > +			link_state->state_valid);
> > > +	cmd_params->supported = cpu_to_le64(link_state->supported);
> > > +	cmd_params->advertising = cpu_to_le64(link_state->advertising);
> > 
> > I don't understand what supported and advertising mean in the context of a
> > MAC. PHY yes, but MAC?
> 
> It's still in the context of the PHY.

If this is for the PHY why are you not using DPNI? That is the object
which represents the PHY.

> As stated in the previous reply, the MAC can do pause, asym pause
> but not half duplex or EEE.

I'm very surprised it cannot do EEE! I hope the firmware is getting
the auto-neg advertisement correct.

   Andrew

