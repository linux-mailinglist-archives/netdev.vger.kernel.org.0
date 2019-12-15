Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 093E811F8CB
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 17:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbfLOQO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 11:14:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53806 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbfLOQO1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Dec 2019 11:14:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=aIJ2dialPyU7vtpuk21GLSP7QRTPDedRCou+GmqKEXI=; b=Y41WMF3GkZYLtBZiy0vjVhQlNa
        rGzNvluz0ZD+QF90TVnTayo/ABwSXHW/Jp6MlZtcuY2csGOsK2oKoyiowfmQtn8uMelWOuXU+ZJXw
        1lwHfPDDifDIiIvp6x3qmW45O2mehwHemsxmCOCzWDDbKn3XgWH+3EL5CAqrM5LY58Xk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1igWXH-0005Yd-Dx; Sun, 15 Dec 2019 17:14:23 +0100
Date:   Sun, 15 Dec 2019 17:14:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Marek Behun <marek.behun@nic.cz>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [BUG] mv88e6xxx: tx regression in v5.3
Message-ID: <20191215161423.GE22725@lunn.ch>
References: <20191212151355.GE30053@lunn.ch>
 <20191212152355.iiepmi4cjriddeon@sapphire.tkos.co.il>
 <20191212193611.63111051@nic.cz>
 <20191212190640.6vki2pjfacdnxihh@sapphire.tkos.co.il>
 <20191212193129.GF30053@lunn.ch>
 <20191212204141.16a406cd@nic.cz>
 <8736dlucai.fsf@tarshish>
 <871rt5u9no.fsf@tarshish>
 <20191215145349.GB22725@lunn.ch>
 <87y2vdsk32.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y2vdsk32.fsf@tarshish>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 15, 2019 at 05:08:01PM +0200, Baruch Siach wrote:
> Hi Andrew,
> 
> On Sun, Dec 15 2019, Andrew Lunn wrote:
> >> This fixes cpu port configuration for me:
> >>
> >> diff --git a/drivers/net/dsa/mv88e6xxx/port.c b/drivers/net/dsa/mv88e6xxx/port.c
> >> index 7fe256c5739d..a6c320978bcf 100644
> >> --- a/drivers/net/dsa/mv88e6xxx/port.c
> >> +++ b/drivers/net/dsa/mv88e6xxx/port.c
> >> @@ -427,10 +427,6 @@ static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
> >>  		cmode = 0;
> >>  	}
> >>
> >> -	/* cmode doesn't change, nothing to do for us */
> >> -	if (cmode == chip->ports[port].cmode)
> >> -		return 0;
> >> -
> >>  	lane = mv88e6xxx_serdes_get_lane(chip, port);
> >>  	if (lane) {
> >>  		if (chip->ports[port].serdes_irq) {
> >>
> >> Does that make sense?
> >
> > This needs testing on a 6390, with a port 9 or 10 using fixed link. We
> > have had issues in the past where mac_config() has been called once
> > per second, and each time it reconfigured the MAC, causing the link to
> > go down/up. So we try to avoid doing work which is not requires and
> > which could upset the link.
> 
> You refer to ed8fe20205ac ("net: dsa: mv88e6xxx: prevent interrupt storm
> caused by mv88e6390x_port_set_cmode") that introduced this code.
> 
> The alternative is to call ->port_get_cmode() to refresh the cmode cache
> after mv88e6xxx_port_hidden_write().

Refreshing the cmode after mv88e6xxx_port_hidden_write() sounds like a
good idea. But please limit it to just switches which need to make
cmode writable. cmode is rather fragile and the 6390 family is easy to
break in this area.

      Thanks
		Andrew
