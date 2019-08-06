Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F55483595
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 17:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732676AbfHFPrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 11:47:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729161AbfHFPrH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 11:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tDkHFpyJMWg4Q2gavETNLZvz+JZOHVdkyGeG2qTN/Wc=; b=hEaWAU47mmu5QooLLHmVN7tdiw
        CrrTPK3IXB8rPkzZLVoRUuqJqD1OOsbdcObJUTgVPE4vDlXE5CJrd3AGL4MqvzF9w8NS/n8PYXpv4
        rVWRo5Fo7/4uuQdds/R02lU7PjiW8ljaC8eojAI7I3kuUG+RlCQ0/2nEobaSizTCA6b0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hv1fu-0005YJ-3h; Tue, 06 Aug 2019 17:46:58 +0200
Date:   Tue, 6 Aug 2019 17:46:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH 15/16] net: phy: adin: add ethtool get_stats support
Message-ID: <20190806154658.GC20422@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-16-alexandru.ardelean@analog.com>
 <20190805152832.GT24275@lunn.ch>
 <ce952e3f8d927cdbccb268d708b4e47179d69b06.camel@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce952e3f8d927cdbccb268d708b4e47179d69b06.camel@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 06, 2019 at 07:11:57AM +0000, Ardelean, Alexandru wrote:
> On Mon, 2019-08-05 at 17:28 +0200, Andrew Lunn wrote:
> > [External]
> > 
> > > +struct adin_hw_stat {
> > > +	const char *string;
> > > +static void adin_get_strings(struct phy_device *phydev, u8 *data)
> > > +{
> > > +	int i;
> > > +
> > > +	for (i = 0; i < ARRAY_SIZE(adin_hw_stats); i++) {
> > > +		memcpy(data + i * ETH_GSTRING_LEN,
> > > +		       adin_hw_stats[i].string, ETH_GSTRING_LEN);
> > 
> > You define string as a char *. So it will be only as long as it should
> > be. However memcpy always copies ETH_GSTRING_LEN bytes, doing off the
> > end of the string and into whatever follows.
> > 
> 
> hmm, will use strlcpy()
> i blindedly copied memcpy() from some other driver

Hopefully that driver used const char string[ETH_GSTRING_LEN]. Then a
memcpy is safe. If not, please let me know what driver you copied.

> i'm afraid i don't understand about the snapshot feature you are mentioning;
> i.e. i don't remember seeing it in other chips;

It is frequency done at the MAC layer for statistics. You tell the
hardware to snapshot all the statistics. It atomically makes a copy of
all the statistics into a set of registers. These values are then
static, and consistent between counters. You can read them out knowing
they are not going to change.

> regarding the danger that stat->reg1 rolls over, i guess that is
> possible, but it's a bit hard to guard against;

The normal solution is the read the MSB, the LSB and then the MSB
again. If the MSB value has changed between the two reads, you know a
roll over has happened, and you need to do it all again.

     Andrew
