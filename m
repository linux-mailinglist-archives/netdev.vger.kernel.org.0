Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FDA2EC07A
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 16:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbhAFPf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 10:35:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbhAFPf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 10:35:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78B562311E;
        Wed,  6 Jan 2021 15:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609947317;
        bh=+5LLOXHbEcfB3G60Sp6ym5Voaah7J9yIam8M8z+JwZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XPw5prEhpX98fHp5qsZEEUAujQ4xxdG/Z5uhYhlVl+0j75WeqiTLmYt+lR5Diwkr3
         22q2mjYp0/V7m80apMm9abf/P47pkw4V+IydOZY19pylhzKGiCm4jmJIoqD20w7bf9
         xeB8sy7EOyKYI1S7llJvyLktojMcDlGgM/srDihyRFy1tO2eoEG0H6teJCF1KZGoFb
         J4xIhrkumJt9SmcDf8QNYzQUz7AXKkqs2P3ROC882aLSbpaPbRZ5HFU27rdKRnuO97
         r6kOMYr0OGAaGTrNd0xZxep318/s/4ReSHJE1MpiBBp3cCudyr1zmUQVy5cwkE+AUI
         XzJr6D9c7X/Iw==
Received: by pali.im (Postfix)
        id 21E9B44E; Wed,  6 Jan 2021 16:35:15 +0100 (CET)
Date:   Wed, 6 Jan 2021 16:35:14 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] net: sfp: add workaround for Realtek RTL8672 and
 RTL9601C chips
Message-ID: <20210106153514.aoticfuoyvb32diq@pali>
References: <X+3ume1+wz8HXHEf@lunn.ch>
 <20201231170039.zkoa6mij3q3gt7c6@pali>
 <X+4GwpFnJ0Asq/Yj@lunn.ch>
 <20210102014955.2xv27xla65eeqyzz@pali>
 <CALQZrspktLr3SfVRhBrVK2zhjFzJMm9tQjWXU_07zjwJytk7Cg@mail.gmail.com>
 <20210103024132.fpvjumilazrxiuzj@pali>
 <20210106145532.xynhoufpfyzmurd5@pali>
 <20210106152138.GK1551@shell.armlinux.org.uk>
 <20210106152338.GN1605@shell.armlinux.org.uk>
 <20210106152707.GO1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210106152707.GO1605@shell.armlinux.org.uk>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 06 January 2021 15:27:07 Russell King - ARM Linux admin wrote:
> On Wed, Jan 06, 2021 at 03:23:38PM +0000, Russell King - ARM Linux admin wrote:
> > On Wed, Jan 06, 2021 at 03:21:38PM +0000, Russell King - ARM Linux admin wrote:
> > > On Wed, Jan 06, 2021 at 03:55:32PM +0100, Pali Rohár wrote:
> > > > On my tested CarlitoxxPro module is:
> > > > 
> > > >         Option values                             : 0x00 0x1c
> > > >         Option                                    : RX_LOS implemented, inverted
> > > >         Option                                    : TX_FAULT implemented
> > > >         Option                                    : TX_DISABLE implemented
> > > > 
> > > > When cable is disconnected then in EEPROM at position 0x16e is value
> > > > 0x82. If I call 'ip link set eth1 up' then value changes to 0x02, module
> > > > itself has a link and I can connect to its internal telnet/webserver to
> > > > configure it.
> > > 
> > > Bit 7 reflects the TX_DISABLE pin state. Bit 1 reflects the RX_LOS pin
> > > state. It isn't specified whether the inverted/non-inverted state is
> > > reflected in bit 1 or not - the definition just says that bit 1 is
> > > "Digital state of the RX_LOS Output Pin."
> > > 
> > > > I also tested UBNT module and result is:
> > > > 
> > > >         Option values                             : 0x00 0x06
> > > >         Option                                    : RX_LOS implemented
> > > >         Option                                    : RX_LOS implemented, inverted
> > > > 
> > > > Which means that those bits are not implemented.
> > > > 
> > > > Anyway I check position 0x16e and value on its value is randomly either
> > > > 0x79 or 0xff independently of the state of the GPON module.
> > > > 
> > > > So it is really not implemented on UBNT.
> > > 
> > > There are enhanced options at offset 93 which tell you which of the
> > > offset 110 signals are implemented.
> > 
> > That's the ID EEPROM (A0) offset 93 for the Diagnostic address (A2)
> > offset 110.
> 
> Looking at the EEPROM dumps you've sent me... the VSOL V2801F has
> 0xe0 at offset 93, meaning TX_DISABLE and TX_FAULT soft signals
> (which is basically offset 110) are implemented, RX_LOS is not. No
> soft signals are implemented on the Ubiquiti module.

UBNT has at EEPROM offset 0x5E value 0x80.

CarlitoxxPRO has at this offset value 0xE0.

So both SFPs claims that support alarm/warning flags and CarlitoxxPRO
claims that support TX_DISABLE and TX_FAULT.
