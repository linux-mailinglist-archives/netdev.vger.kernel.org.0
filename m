Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A19251A48
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgHYN40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:56:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49302 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgHYN4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 09:56:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kAZQt-00BmIB-U5; Tue, 25 Aug 2020 15:56:15 +0200
Date:   Tue, 25 Aug 2020 15:56:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200825135615.GR2588906@lunn.ch>
References: <20200820081118.10105-1-kurt@linutronix.de>
 <20200820081118.10105-3-kurt@linutronix.de>
 <20200824224450.GK2403519@lunn.ch>
 <87eenv14bt.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eenv14bt.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> +static int hellcreek_detect(struct hellcreek *hellcreek)
> >> +{
> >> +	u16 id, rel_low, rel_high, date_low, date_high, tgd_ver;
> >> +	u8 tgd_maj, tgd_min;
> >> +	u32 rel, date;
> >> +
> >> +	id	  = hellcreek_read(hellcreek, HR_MODID_C);
> >> +	rel_low	  = hellcreek_read(hellcreek, HR_REL_L_C);
> >> +	rel_high  = hellcreek_read(hellcreek, HR_REL_H_C);
> >> +	date_low  = hellcreek_read(hellcreek, HR_BLD_L_C);
> >> +	date_high = hellcreek_read(hellcreek, HR_BLD_H_C);
> >> +	tgd_ver   = hellcreek_read(hellcreek, TR_TGDVER);
> >> +
> >> +	if (id != HELLCREEK_MODULE_ID)
> >> +		return -ENODEV;
> >
> > Are there other Hellcreek devices? I'm just wondering if we should
> > have a specific compatible for 0x4c30 as well as the more generic 
> > "hirschmann,hellcreek".
> 
> Yes, there will be different revisions of the Hellcreek devices. This ID
> is really device specific. A lot of features of this switch are
> configured in the VHDL code. For instance the MAC settings (100 or 1000
> Mbit/s).
> 
> I've discussed this with the HW engineer from Hirschmann. He suggested
> to keep this check here, as the driver is currently specific for the
> that device. We have to make sure that the driver matches the hardware.

I agree with the check here. The question is about the compatible
string. Should there be a more specific compatible string as well as
the generic one?

There have been a few discussions about how the Marvell DSA driver
does its compatible string. The compatible string tells you where to
find the ID register, not what value to expect in the ID register. The
ID register can currently be in one of three different locations. Do
all current and future Hellcreak devices have the same value for
HR_MODID_C? If not, now is a good time to add a more specific
compatible string to tell you where to find the ID register.

> My plan was to extend this when I have access to other revisions. There
> will be a SPI variant as well. But, I didn't want to implement it without the
> ability to test it.

Does the SPI variant use the same value for HR_MODID_C? Maybe you need
a different compatible, maybe not, depending on how the driver is
structured.

The compatible string is part of the ABI. So thinking about it a bit
now can make things easier later. I just want to make sure you have
thought about this.

	Andrew
