Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74896476ECC
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 11:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236023AbhLPKYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 05:24:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58218 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236019AbhLPKYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 05:24:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=6BEIP/V3oqkY7sGdUunYItZjMJD8QvQE4qc4UzkQrQQ=; b=RFd2AhmvEchgikzhxwb7dgIcJu
        tSSiKJBtqkdqcuj9ICCLswPDYUfLrkL3cYp0uB0+mw+hGGnCcWQsM21zmDClxtXg8qMrT68x3KRws
        AIhFbk1QJ9zxtHBHE7goOeTjh3EmLuNFgDHHoxg/RlX32ivBOOThOrkqNvFD/bzfhM7Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mxnw0-00GjFa-J0; Thu, 16 Dec 2021 11:24:24 +0100
Date:   Thu, 16 Dec 2021 11:24:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francesco Dolcini <francesco.dolcini@toradex.com>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: fec: reset phy on resume after power-up
Message-ID: <YbsT2G5oMoe4baCJ@lunn.ch>
References: <DB8PR04MB679570A356B655A5D6BFE818E6769@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YbnDc/snmb1WYVCt@shell.armlinux.org.uk>
 <Ybm3NDeq96TSjh+k@lunn.ch>
 <20211215110139.GA64001@francesco-nb.int.toradex.com>
 <DB8PR04MB67951CB5217193E4CBF73B26E6779@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20211216075216.GA4190@francesco-nb.int.toradex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216075216.GA4190@francesco-nb.int.toradex.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 08:52:16AM +0100, Francesco Dolcini wrote:
> On Thu, Dec 16, 2021 at 04:52:39AM +0000, Joakim Zhang wrote:
> > As I can see, when system suspended, PHY is totally powered down,
> > since you disable the regulator. At this situation, if you
> > assert reset signal, you mean it will increase the power
> > consumption? PHY is totally powered down, why assert reset
> > signal still affect PHY? 

> In general there are *other* use cases in which the PHY is powered in
> suspend. We should not create a regression there.

Yes, this is the sticking point. We can do what you want, but
potentially, the change affects others.

I think you need to move the regulator into phylib, so the PHY driver
can do the right thing. It is really the only entity which knows what
is the correct thing to do.

   Andrew
