Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF08477037
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 12:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbhLPL23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 06:28:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58354 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233799AbhLPL22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 06:28:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ChLvq75vLSrOtMDUaLyRmnH1JgKz3EjDw2+zIGft6mA=; b=x+tmVf1RU4bBytzxUnUjkZrT83
        zRgrkVE08eMm52G/ogUG1Fu08gFaqPWUz3Uh9MWi4fCh2CBub15gjhJFpYJHRjPeLtE6wRG/BoFlf
        TCXq+7RaZGGBMfV8VhwWG92fy3gqMZ585OX25MicwvMq7PmrkbevEtb6ogaOEgBngbnc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxovr-00GjZ3-GM; Thu, 16 Dec 2021 12:28:19 +0100
Date:   Thu, 16 Dec 2021 12:28:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <Ybsi00/CAd7oVl17@lunn.ch>
References: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
 <Ybm3NDeq96TSjh+k@lunn.ch>
 <20211215110139.GA64001@francesco-nb.int.toradex.com>
 <DB8PR04MB67951CB5217193E4CBF73B26E6779@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20211216075216.GA4190@francesco-nb.int.toradex.com>
 <YbsT2G5oMoe4baCJ@lunn.ch>
 <20211216112433.GB4190@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216112433.GB4190@francesco-nb.int.toradex.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 12:24:33PM +0100, Francesco Dolcini wrote:
> On Thu, Dec 16, 2021 at 11:24:24AM +0100, Andrew Lunn wrote:
> > I think you need to move the regulator into phylib, so the PHY driver
> > can do the right thing. It is really the only entity which knows what
> > is the correct thing to do.

> Do you believe that the right place is the phylib and not the phy driver?
> Is this generic enough?

It is split. phylib can do the lookup in DT, get the regulator and
provide a helper to enable/disable it. So very similar to the reset.

The phy driver would then use the helpers. It probably needs to look
into the phydev structure to see what is actually available, is there
a reset, a regulator etc, and then decide what is best to do given the
available resources.

	  Andrew
