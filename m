Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8ADB2C92EA
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 00:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbgK3Xn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 18:43:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58712 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729627AbgK3Xn7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 18:43:59 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjsKA-009b6p-6D; Tue, 01 Dec 2020 00:11:14 +0100
Date:   Tue, 1 Dec 2020 00:11:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: warnings from MTU setting on switch ports
Message-ID: <20201130231114.GI2073444@lunn.ch>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
 <20201130223507.rav22imba73dtfxb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130223507.rav22imba73dtfxb@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > A thought: Shouldn't the initialization of slave_dev->max_mtu in
> > dsa_slave_create() be capped by master->max_mtu minus tag overhead?
> 
> Talk to Andrew:
> https://www.spinics.net/lists/netdev/msg645810.html

Yes, this is historic. DSA started life with Marvell switches
connected to Marvell MACs. And Marvell MACs always allowed frames
bigger than the MTU to be sent/received. A few more MACs were paired
with Marvell switches, and they also happened to allow bigger frames
than the MTU to be used. So it all worked fine until a MAC/Switch pair
came along where the MAC did not pass frames bigger than the MTU. We
could not break backwards compatibility, so decided to ask the MAC to
up its MTU, but not error out if it failed. It was like that for a
long time, until Vladimir added jumbo support. Then you do need to
know if the MAC supports bigger MTU, so you can disallow jumbo. So
this warning got added.

     Andrew
