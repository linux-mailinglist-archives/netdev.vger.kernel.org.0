Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8A92CFFCE
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 00:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgLEXok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 18:44:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:53768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbgLEXok (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Dec 2020 18:44:40 -0500
Date:   Sat, 5 Dec 2020 15:43:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607211839;
        bh=cX6RfE9GirUTLY+Lvd4qBUjK2nEAbYOZHkyB4WHUa4c=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=PhtW3YuWYKZlcM/8gqxUv8fDwCzhakJHu9GI1JPmvVKRc18g/mP/rd5FeGWbAccB8
         5sa6myeXQNxMDeBNj+EuWWzT7bu3zPj7aK9ddC+tw9nESoSEF3kPq5v72ZC53v/DGO
         AGOGDIxQ+PzCqq3An7QN0YfCl3dmqr6r7xiGHWJ7+CQibqrQpXdHBZC4dQRxxb9p3q
         RHHlHAhgazv17tld1QRXddyLJksxvICHECIueC/rXUHFFHDfCDdRg/SWZlIUNrkoYp
         /zVRdh2v+H02R5TSer+7BuWygvKhpTedDsPaiyGsSgqKVNYXOkqgqyO6Jk/fMTnV4e
         wQGkOiqa1y9Pg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>
Subject: Re: [PATCH net] net: mscc: ocelot: fix dropping of unknown IPv4
 multicast on Seville
Message-ID: <20201205154358.0fdce3dd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204181329.GM74177@piout.net>
References: <20201204175416.1445937-1-vladimir.oltean@nxp.com>
        <20201204181329.GM74177@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 19:13:29 +0100 Alexandre Belloni wrote:
> On 04/12/2020 19:54:16+0200, Vladimir Oltean wrote:
> > The current assumption is that the felix DSA driver has flooding knobs
> > per traffic class, while ocelot switchdev has a single flooding knob.
> > This was correct for felix VSC9959 and ocelot VSC7514, but with the
> > introduction of seville VSC9953, we see a switch driven by felix.c which
> > has a single flooding knob.
> > 
> > So it is clear that we must do what should have been done from the
> > beginning, which is not to overwrite the configuration done by ocelot.c
> > in felix, but instead to teach the common ocelot library about the
> > differences in our switches, and set up the flooding PGIDs centrally.
> > 
> > The effect that the bogus iteration through FELIX_NUM_TC has upon
> > seville is quite dramatic. ANA_FLOODING is located at 0x00b548, and
> > ANA_FLOODING_IPMC is located at 0x00b54c. So the bogus iteration will
> > actually overwrite ANA_FLOODING_IPMC when attempting to write
> > ANA_FLOODING[1]. There is no ANA_FLOODING[1] in sevile, just ANA_FLOODING.
> > 
> > And when ANA_FLOODING_IPMC is overwritten with a bogus value, the effect
> > is that ANA_FLOODING_IPMC gets the value of 0x0003CF7D:
> > 	MC6_DATA = 61,
> > 	MC6_CTRL = 61,
> > 	MC4_DATA = 60,
> > 	MC4_CTRL = 0.
> > Because MC4_CTRL is zero, this means that IPv4 multicast control packets
> > are not flooded, but dropped. An invalid configuration, and this is how
> > the issue was actually spotted.
> > 
> > Reported-by: Eldar Gasanov <eldargasanov2@gmail.com>
> > Reported-by: Maxim Kochetkov <fido_max@inbox.ru>
> > Tested-by: Eldar Gasanov <eldargasanov2@gmail.com>
> > Fixes: 84705fc16552 ("net: dsa: felix: introduce support for Seville VSC9953 switch")
> > Fixes: 3c7b51bd39b2 ("net: dsa: felix: allow flooding for all traffic classes")
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>  
> Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Applied, thanks!
