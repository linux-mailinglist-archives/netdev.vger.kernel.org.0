Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C75D34BDC7
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhC1Rro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:47:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51966 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhC1Rrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 13:47:32 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lQZVY-00DUY2-U4; Sun, 28 Mar 2021 19:47:28 +0200
Date:   Sun, 28 Mar 2021 19:47:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sunil Kovvuri <sunil.kovvuri@gmail.com>
Cc:     Hariprasad Kelam <hkelam@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Subject: Re: [net-next PATCH 0/8] configuration support for switch headers &
 phy
Message-ID: <YGDBMIICAHylrIyL@lunn.ch>
References: <MWHPR18MB14217B983EFC521DAA2EEAD2DE649@MWHPR18MB1421.namprd18.prod.outlook.com>
 <YFpO7n9uDt167ANk@lunn.ch>
 <CA+sq2CeT2m2QcrzSn6g5rxUfmJDVQqjYFayW+bcuopCCoYuQ6Q@mail.gmail.com>
 <YFyHKqUpG9th+F62@lunn.ch>
 <CA+sq2CfvscPPNTq4PR-6hjYhQuj=u2nmLa0Jq2cKRNCA-PypGQ@mail.gmail.com>
 <YFyOW5X0Nrjz8w/v@lunn.ch>
 <CA+sq2CeRjJNaNbZhs17LDrBtyvR_fb3uN=Wd=j9sLHJapVB50A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+sq2CeRjJNaNbZhs17LDrBtyvR_fb3uN=Wd=j9sLHJapVB50A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The usecase is simple, unlike DSA tag, this 4byte FDSA tag doesn't
> have a ethertype,
> so HW cannot recognize this header. If such packers arise, then HW parsing will
> fail and RSS will not work.
> 
> Hypothetically if we introduce some communication between MAC driver
> and DSA driver,
> wouldn't that also become specific to the device, what generic usecase
> that communication
> will have ?

Hi Sunil

We need to be careful with wording. Due to history, the Linux kernel
uses dsa to mean any driver to control an Ethernet switch. It does not
imply the {E}DSA protocol used by Marvell switches, or even that the
switch is a Marvell switch.

netdev_uses_dsa(ndev) will tell you if the MAC is being used to
connect to a switch. It is set by the Linux DSA core when the switch
cluster is setup. That could be before or after the MAC is configured
up, which makes it a bit hard to use, since you don't have a clear
indicator when to evaluate to determine if you need to change your
packet parsing.

netdev_uses_dsa() looks at ndev->dsa_ptr. This is a pointer to the
structure which represents the port on the switch the MAC is connected
to. In Linux DSA terms, this is the CPU port. You can follow
dsa_ptr->tag_ops which gives you the tagger operations, i.e. those
used to add and remove the header/trailer. One member of that is
proto. This contains the tagging protocol, so EDSA, DSA, or
potentially FDSA, if that is ever supported. And this is all within
the core DSA code, so is generic. It should work for any tagging
protocol used by any switch which Linux DSA supports.

So actually, everything you need is already present, you don't need a
private flag. But adding a notifier that the MAC has been connected to
a switch and ndev->dsa_ptr is set would be useful. We could maybe use
NETDEV_CHANGE for that, or NETDEV_CHANGELOWERSTATE, since the MAC is
below the switch slave interfaces.

      Andrew

