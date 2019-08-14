Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D09C98D569
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 15:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbfHNNwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 09:52:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbfHNNwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 09:52:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Qvdn2Dw1d4DDxzvSgjuApr0beTUq2yU3gH6I2fFNWKQ=; b=ki/niEc7yxU8K2TVNDsMfZ3qZE
        6Q8jABE4BQCgQ1+k7FxyMwXnhXNmiRi76/Hb1z947vIfTgTkO8rcRptujCobwWVPhNKIY2pasLVZu
        EaeH5d+OktPsHUBNP+Wn2cSmQBjCULRHLyB+wq8TZv0G4l1voEveGFsaKSHRcH4phzA0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxthT-0001d0-4l; Wed, 14 Aug 2019 15:52:27 +0200
Date:   Wed, 14 Aug 2019 15:52:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     "Y.b. Lu" <yangbo.lu@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
Message-ID: <20190814135227.GC5265@lunn.ch>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-4-yangbo.lu@nxp.com>
 <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
 <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190813134236.GG15047@lunn.ch>
 <VI1PR0401MB2237D9358AA17400E72A776EF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190814085711.7654bff2u66o4yjj@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814085711.7654bff2u66o4yjj@lx-anielsen.microsemi.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 14, 2019 at 10:57:12AM +0200, Allan W. Nielsen wrote:
> Hi Y.b. and Andrew,
> 
> The 08/14/2019 04:28, Y.b. Lu wrote:
> > > > I'd like to trap all IEEE 1588 PTP Ethernet frames to CPU through etype
> > > 0x88f7.
> > > 
> > > Is this the correct way to handle PTP for this switch? For other switches we
> > > don't need such traps. The switch itself identifies PTP frames and forwards
> > > them to the CPU so it can process them.
> > > 
> > > I'm just wondering if your general approach is wrong?
> > 
> > [Y.b. Lu] PTP messages over Ethernet will use two multicast addresses.
> > 01-80-C2-00-00-0E for peer delay messages.
> Yes, and as you write, this is a BPDU which must not be forwarded (and they are
> not).
> 
> > 01-1B-19-00-00-00 for other messages.
> Yes, this is a normal L2 multicast address, which by default are broadcastet.
> 
> > But only 01-80-C2-00-00-0E could be handled by hardware filter for BPDU frames
> > (01-80-C2-00-00-0x).  For PTP messages handling, trapping them to CPU through
> > VCAP IS2 is the suggested way by Ocelot/Felix.

Hi Allan

The typical userspace for this is linuxptp. It implements Boundary
Clock (BC), Ordinary Clock (OC) and Transparent Clock (TC). On
switches, it works great for L2 PTP. But it has architectural issues
for L3 PTP when used with a bridge. I've no idea if Richard is fixing
this.

> 3) It can be done via 'tc' using the trap action, but I do not know if this is
>    the desired way of doing it.

No, it is not. It could be the way you the implement
ptp_clock_info.enable() does the same as what TC could do, but TC
itself is not used, it should all be internal to the driver. And you
might also want to consider hiding such rules from TC, otherwise the
user might remove them and things break.

     Andrew
