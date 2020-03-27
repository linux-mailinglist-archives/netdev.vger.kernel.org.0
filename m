Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 009F4196229
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 00:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgC0Xw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 19:52:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgC0Xw0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 19:52:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2Gt0JTWH3GJschI7GZg2MVZKT4DyiRGI1f+V3wy8UfI=; b=AlyY4Z/N1RJzrcwpLiKwCcdhI0
        6FgOu/aJtmo+4vBER1M7Ss2GPEROvdiccgGZxkGinFPadYn/1AFCiLHYhzxiuR+OhGFdoOlLZZnxH
        RcxTXB6x0ztKdhV7NhlZXs+JiNQRk7UcbPoWMsTaFlFDw9gViVVjWIZRGzCmHGRMJ9zg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHylw-0006PJ-6B; Sat, 28 Mar 2020 00:52:20 +0100
Date:   Sat, 28 Mar 2020 00:52:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't force settings on CPU port
Message-ID: <20200327235220.GV3819@lunn.ch>
References: <20200327195156.1728163-1-daniel@zonque.org>
 <20200327200153.GR3819@lunn.ch>
 <d101df30-5a9e-eac1-94b0-f171dbcd5b88@zonque.org>
 <20200327211821.GT3819@lunn.ch>
 <1bff1da3-8c9d-55c6-3408-3ae1c3943041@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bff1da3-8c9d-55c6-3408-3ae1c3943041@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I tried this as well with v5.5, but that leads to the external phy not
> seeing a link at all. Will check again though.

Did you turn off auto-neg on the external PHY and use fixed 100Full?
Ethtool on the SoC interface should show you if the switch PHY is
advertising anything. I'm guessing it is not, and hence you need to
turn off auto neg on the external PHY.

Another option would be something like

                                        port@6 {
                                                reg = <6>;
                                                label = "cpu";
                                                ethernet = <&fec1>;

                                                phy-handle = <phy6>;
                                        };
                                };

                                mdio {
                                        #address-cells = <1>;
                                        #size-cells = <0>;
                                        phy6: ethernet-phy@6 {
                                                reg = <6>;
                                                interrupt-parent = <&switch0>;
                                                interrupts = <0 IRQ_TYPE_LEVEL_HIGH>;
                                        };
                                };

By explicitly saying there is a PHY for the CPU node, phylink might
drive it.

       Andrew
