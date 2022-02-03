Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530964A88AD
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:37:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352254AbiBCQhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:37:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41184 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234433AbiBCQhd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 11:37:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=EEdnBGZvqaQpfo8tguZMww3Zd/NVN+gqcVWHywSpMlU=; b=OainZRUfP+rJ4YLRUYs67ZGGlc
        QWb+WFl8+g38zJkZAiahunkjAsCHh4IpWaHyK8jhL9D6aLcXfF4Mykw0452tMRElJrgcgWeN6y71m
        fiPOy/tVtaDW8wMowXeh0/HKCMEy271HOBWcrrlaeZfYzKWeelXIHmK0J9Wzsg4Qh9K8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nFf6k-0048vh-UF; Thu, 03 Feb 2022 17:37:18 +0100
Date:   Thu, 3 Feb 2022 17:37:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led
 functions
Message-ID: <YfwEvgerYddIUp1V@lunn.ch>
References: <20210421055047.22858-1-ms@dev.tdt.de>
 <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch>
 <CAJ+vNU2v9WD2kzB9uTD5j6DqnBBKhv-XOttKLoZ-VzkwdzwjXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU2v9WD2kzB9uTD5j6DqnBBKhv-XOttKLoZ-VzkwdzwjXw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew,
> 
> I agree with the goal of having PHY drivers and dt-bindings in Linux
> to configure everything but in the case I mention in the other thread
> adding rgmii delay configuration which sets a default if a new dt
> binding is missing is wrong in my opinion as it breaks backward
> compatibility. If a new dt binding is missing then I feel that the
> register fields those bindings act on should not be changed.

I would like that understand this specific case in more detail.  We
have seen a few cases were the DT is broken, yet works. This is often
caused by having a wrong phy-mode, which historically the PHY driver
was ignoring. Then support for honouring the phy-mode was added to the
PHY driver, and all the boards with broken DT files actually break.

So it could be that is what has happened here. Or it could be the
driver is plan wrong. If i understand correctly, you say it is adding
a default delay of 2ns. That would be correct for a phy-mode of
rgmii-id, but wrong for a phy-mode of rgmii.

> > LEDs are trickier. There is a slow on going effort to allow PHY LEDs
> > to be configured as standard Linux LEDs. That should result in a DT
> > binding which can be used to configure LEDs from DT.
> 
> Can you point me to something I can look at? PHY LED bindings don't at
> all behave like normal LED's as they are blinked internally depending
> on a large set of rules that differ per PHY.

Yes, this is what is slowing the work done, agreeing on details like
this, and how the user space API would actually work. In the end, i
suspect a subset of LED modes will be supported, covering the common
blink patterns.

> Completely off topic, but due to the chip shortage we have had to
> redesign many of our boards with different PHY's that now have
> different bindings for RGMII delays so I have to add multiple PHY
> configurations to DT's if I am going to support the use of PHY
> drivers. What is your suggestion there? Using DT overlays I suppose is
> the right approach.

I would try to only use phy-mode, and avoid all PHY specific tweaks.
So long as the track lengths don't change too much on your redesign,
and are kept about the same length, the standard 2ns delay should
work.

	Andrew
