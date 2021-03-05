Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C15132DF3E
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhCEBun (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:50:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41126 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhCEBun (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 20:50:43 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lHzbv-009MdW-LM; Fri, 05 Mar 2021 02:50:35 +0100
Date:   Fri, 5 Mar 2021 02:50:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Don Bollinger <don@thebollingers.org>
Cc:     'Moshe Shemesh' <moshe@nvidia.com>,
        "'David S. Miller'" <davem@davemloft.net>,
        'Jakub Kicinski' <kuba@kernel.org>,
        'Adrian Pop' <pop.adrian61@gmail.com>,
        'Michal Kubecek' <mkubecek@suse.cz>, netdev@vger.kernel.org,
        'Vladyslav Tarasiuk' <vladyslavt@nvidia.com>
Subject: Re: [RFC PATCH V2 net-next 5/5] ethtool: Add fallback to
 get_module_eeprom from netlink command
Message-ID: <YEGOa2NFiw3fc5sT@lunn.ch>
References: <1614884228-8542-1-git-send-email-moshe@nvidia.com>
 <1614884228-8542-6-git-send-email-moshe@nvidia.com>
 <001201d71159$88013120$98039360$@thebollingers.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001201d71159$88013120$98039360$@thebollingers.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int fallback_set_params(struct eeprom_data_req_info *request,
> > +			       struct ethtool_modinfo *modinfo,
> > +			       struct ethtool_eeprom *eeprom) {
> 
> This is translating the new data structure into the old.  Hence, I assume we
> have i2c_addr, page, bank, offset, len to work with, and we should use
> all of them.

Nope. We actually have none of them. The old API just asked the driver
to give me the data in the SFP. And the driver gets to decide what it
returns, following a well known layout. The driver can decide to give
just the first 1/2 page, or any number of multiple 1/2 pages in a well
known linear way, which ethtool knows how to decode.

So when mapping the new KAPI onto the old driver API, you need to call
the old API, and see if what is returned can be used to fulfil the
KAPI request. If the bytes are there, great, return them, otherwise
EOPNOTSUPP.

And we also need to consider the other way around. The old KAPI is
used, and the MAC driver only supports the new driver API. Since the
linear layout is well know, you need to make a number of calls into
the driver to read the 1/2 pages, and them glue them together and
return them.

I've not reviewed this code in detail yet, so i've no idea how it
actually works. But i would like to see as much compatibility as
possible. That has been the approach with moving from IOCTL to netlink
with ethool. Everything the old KAPI can do, netlink should also be
able to, plus there can be additional features.

> > +	switch (modinfo->type) {
> > +	case ETH_MODULE_SFF_8079:
> > +		if (request->page > 1)
> > +			return -EINVAL;
> > +		break;
> > +	case ETH_MODULE_SFF_8472:
> > +		if (request->page > 3)
> 
> Not sure this is needed, there can be pages higher than 3.

Not with the old KAPI call. As far as i remember, it stops at three
pages. But i need to check the ethtool(1) sources to be sure.

       Andrew

