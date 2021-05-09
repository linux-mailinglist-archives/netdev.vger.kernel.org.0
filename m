Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0723774CB
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 03:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhEIBIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 21:08:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59754 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEIBIb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 May 2021 21:08:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Dz3THjNc/hy4xJDJZNJeu/zoWAbn2LAuayWuBUNNRE0=; b=UTe51yoGXOVfLA3xqXKRLGzWpj
        BjeSCwjAXMAFGwq8+sPSjDtSMWmo8lGYnsTBcL43fNeYEtRVbVWaVU+ykYsQif2U5qivDHOC1e3ZI
        7sDsFcd3PEd873qdXrM1rdZn8oiXKK5scRAp1TFkOUWGmzvHQzNuOsgYfCn8wlGtYWVc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lfXud-003KRL-MP; Sun, 09 May 2021 03:07:15 +0200
Date:   Sun, 9 May 2021 03:07:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next v4 19/28] net: dsa: qca8k: make rgmii delay
 configurable
Message-ID: <YJc1w9Mndqbdb71Z@lunn.ch>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-19-ansuelsmth@gmail.com>
 <YJbUignEbuthTguo@lunn.ch>
 <YJclj7wLsR3CK3KQ@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJclj7wLsR3CK3KQ@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 09, 2021 at 01:58:07AM +0200, Ansuel Smith wrote:
> On Sat, May 08, 2021 at 08:12:26PM +0200, Andrew Lunn wrote:
> > > +
> > > +	/* Assume only one port with rgmii-id mode */
> > 
> > Since this is only valid for the RGMII port, please look in that
> > specific node for these properties.
> > 
> > 	 Andrew
> 
> Sorry, can you clarify this? You mean that I should check in the phandle
> pointed by the phy-handle or that I should modify the logic to only
> check for one (and the unique in this case) rgmii port?

Despite there only being one register, it should be a property of the
port. If future chips have multiple RGMII ports, i expect there will
be multiple registers. To avoid confusion in the future, we should
make this a proper to the port it applies to. So assuming the RGMII
port is port 0:

                                #address-cells = <1>;
                                #size-cells = <0>;
                                port@0 {
                                        reg = <0>;
                                        label = "cpu";
                                        ethernet = <&gmac1>;
                                        phy-mode = "rgmii";
                                        fixed-link {
                                                speed = 1000;
                                                full-duplex;
                                        };
					rx-internal-delay-ps = <2000>;
					tx-internal-delay-ps = <2000>;
                                };

                                port@1 {
                                        reg = <1>;
                                        label = "lan1";
                                        phy-handle = <&phy_port1>;
                                };

                                port@2 {
                                        reg = <2>;
                                        label = "lan2";
                                        phy-handle = <&phy_port2>;
                                };

                                port@3 {
                                        reg = <3>;
                                        label = "lan3";
                                        phy-handle = <&phy_port3>;
                                };

                                port@4 {
                                        reg = <4>;
                                        label = "lan4";
                                        phy-handle = <&phy_port4>;
                                };

                                port@5 {
                                        reg = <5>;
                                        label = "wan";
                                        phy-handle = <&phy_port5>;
                                };
                        };
                };
        };

You also should validate that phy-mode is rgmii and only rgmii. You
get into odd situations if it is any of the other three rgmii modes.

    Andrew
