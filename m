Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A4C36BBF9
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 01:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234703AbhDZXMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 19:12:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41916 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232022AbhDZXMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Apr 2021 19:12:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lbAOH-001GWh-SV; Tue, 27 Apr 2021 01:11:45 +0200
Date:   Tue, 27 Apr 2021 01:11:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     =?utf-8?B?5pu554Wc?= <cao88yu@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: mv88e6171r and mv88e6161 switch not working properly after
 commit 0f3c66a3c7b4e8b9f654b3c998e9674376a51b0f
Message-ID: <YIdIsbru1oMxyMRB@lunn.ch>
References: <CACu-5+1X1y-DmbyqB4Tooj+DuARhK_V1F16Pa3hWNF9q0sexbg@mail.gmail.com>
 <b5768b0e-1c11-b817-b66f-c565c0afb910@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b5768b0e-1c11-b817-b66f-c565c0afb910@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 09:25:42PM +0000, Chris Packham wrote:
> Hi,
> 
> On 23/04/21 7:57 pm, 曹煜 wrote:
> > Hi,
> >      I've confirmed that the mv88e6171r and mv88e6161 switch run into
> > MTU issue after that commit (from kernel 5.9.0 to kernel 5.12-rc):
> Sorry to hear that.
> > commit 0f3c66a3c7b4e8b9f654b3c998e9674376a51b0f
> > Author: Chris Packham <chris.packham@alliedtelesis.co.nz>
> > Date:   Fri Jul 24 11:21:20 2020 +1200
> >
> >      net: dsa: mv88e6xxx: MV88E6097 does not support jumbo configuration
> >
> >      The MV88E6097 chip does not support configuring jumbo frames. Prior to
> >      commit 5f4366660d65 only the 6352, 6351, 6165 and 6320 chips configured
> >      jumbo mode. The refactor accidentally added the function for the 6097.
> >      Remove the erroneous function pointer assignment.
> >
> Do you mean one of the other commits in that series? I think perhaps the 
> 88e6161 is missing from commit 1baf0fac10fb ("net: dsa: mv88e6xxx: Use 
> chip-wide max frame size for MTU"). I was doing that mostly from the 
> datasheets I had available so could have easily missed one.
> 
> > After my modify:
> >
> > remove
> > .port_set_jumbo_size = mv88e6165_port_set_jumbo_size,
> >
> > add
> > .set_max_frame_size = mv88e6185_g1_set_max_frame_size,
> >
> > The issue is gone, so could you please commit a fix for these two chips?

The datasheet i have for the 6161 shows that bits 13:12 control jumbo
mode. So at least the code fits the datasheet. Also, when describing
global 1 register 4, bit 10, it is reserved. However, the diagram at
the beginning of the global1 section does list bit 10 as being MAX
frame size.

So your testing suggests the data sheet which Chris and I have is
wrong. The change you suggest makes use of the older method of
controlling the MTU.

I will create a patch based on your suggestion.

  Andrew

