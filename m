Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C05F4BDDF4
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 14:15:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405613AbfIYMOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 08:14:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405600AbfIYMOV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Sep 2019 08:14:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Mc0hUP8ePWslLla0cU6JmvO8WPLp+8dYd7zpy7w9PjI=; b=2DFsg264J4DTy0ewkg55FjMZWk
        /oX5gfIZ1G7fOKY2HrMeGg8Nau8Ri4UuNxZd7VXz7Mwg8v3L+iCJx+gZxoz6pEMhpBwzo7CpgKTR5
        wtAsTsU3XrsYUsoP0TUqQ7X2tdxfzt4P4D1Qlm0y5uQUiUI0UIDJuLfdo27VYb6ms5jA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1iD6BK-0004BH-Uw; Wed, 25 Sep 2019 14:14:06 +0200
Date:   Wed, 25 Sep 2019 14:14:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     alvaro.gamez@hazent.com, dan.carpenter@oracle.com,
        radhey.shyam.pandey@xilinx.com, michal.simek@xilinx.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: axienet: fix a signedness bug in probe
Message-ID: <20190925121406.GA1864@lunn.ch>
References: <20190925105911.GI3264@mwanda>
 <20190925110542.GA21923@salem.gmr.ssr.upm.es>
 <20190925.133507.2083224833639646147.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925.133507.2083224833639646147.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 01:35:07PM +0200, David Miller wrote:
> From: "Alvaro G. M" <alvaro.gamez@hazent.com>
> Date: Wed, 25 Sep 2019 13:05:43 +0200
> 
> > Hi, Dan
> > 
> > On Wed, Sep 25, 2019 at 01:59:11PM +0300, Dan Carpenter wrote:
> >> The "lp->phy_mode" is an enum but in this context GCC treats it as an
> >> unsigned int so the error handling is never triggered.
> >> 
> >>  		lp->phy_mode = of_get_phy_mode(pdev->dev.of_node);
> >> -		if (lp->phy_mode < 0) {
> >> +		if ((int)lp->phy_mode < 0) {
> > 
> > This (almost) exact code appears in a lot of different drivers too,
> > so maybe it'd be nice to review them all and apply the same cast if needed?
> 
> Or make the thing an int if negative values are never valid 32-bit phy_mode
> values anyways.

Maybe we should change the API

int of_get_phy_mode(struct device_node *np, phy_interface_t *phy_mode);

Separate the error from the value we are getting.

	 Andrew
