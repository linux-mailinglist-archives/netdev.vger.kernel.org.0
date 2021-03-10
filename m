Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 801B53342DE
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhCJQSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:18:32 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:50481 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231519AbhCJQR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 11:17:59 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 12AGHGuu019933;
        Wed, 10 Mar 2021 17:17:16 +0100
Date:   Wed, 10 Mar 2021 17:17:16 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Claudiu.Beznea@microchip.com
Cc:     schwab@linux-m68k.org, linux-riscv@lists.infradead.org,
        ckeepax@opensource.cirrus.com, andrew@lunn.ch,
        Nicolas.Ferre@microchip.com, daniel@0x0f.com,
        alexandre.belloni@bootlin.com, pthombar@cadence.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: macb broken on HiFive Unleashed
Message-ID: <20210310161716.GB17851@1wt.eu>
References: <87tupl30kl.fsf@igel.home>
 <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04a7e801-9a55-c926-34ad-3a7665077a4e@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Mar 09, 2021 at 08:55:10AM +0000, Claudiu.Beznea@microchip.com wrote:
> Hi Andreas,
> 
> On 08.03.2021 21:30, Andreas Schwab wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > One of the changes to the macb driver between 5.10 and 5.11 has broken
> > the SiFive HiFive Unleashed.  These are the last messages before the
> > system hangs:
> > 
> > [   12.468674] libphy: Fixed MDIO Bus: probed
> > [   12.746518] macb 10090000.ethernet: Registered clk switch 'sifive-gemgxl-mgmt'
> > [   12.753119] macb 10090000.ethernet: GEM doesn't support hardware ptp.
> > [   12.760178] libphy: MACB_mii_bus: probed
> > [   12.881792] MACsec IEEE 802.1AE
> > [   12.944426] macb 10090000.ethernet eth0: Cadence GEM rev 0x10070109 at 0x10090000 irq 16 (70:b3:d5:92:f1:07)
> > 
> 
> I don't have a SiFive HiFive Unleashed to investigate this. Can you check
> if reverting commits on macb driver b/w 5.10 and 5.11 solves your issues:
> 
> git log --oneline v5.10..v5.11 -- drivers/net/ethernet/cadence/
> 1d0d561ad1d7 net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag
> 1d608d2e0d51 Revert "macb: support the two tx descriptors on at91rm9200"
> 700d566e8171 net: macb: add support for sama7g5 emac interface
> ec771de654e4 net: macb: add support for sama7g5 gem interface
> f4de93f03ed8 net: macb: unprepare clocks in case of failure
> 38493da4e6a8 net: macb: add function to disable all macb clocks
> daafa1d33cc9 net: macb: add capability to not set the clock rate
> edac63861db7 net: macb: add userio bits as platform configuration
> 9e6cad531c9d net: macb: Fix passing zero to 'PTR_ERR'
> 0012eeb370f8 net: macb: fix NULL dereference due to no pcs_config method
> e4e143e26ce8 net: macb: add support for high speed interface

In addition, it's worth mentioning that the driver has multiple rx/tx/irq
functions depending on the platforms or chip variants, and that based on
this it should be easy to further reduce this list.

Just my two cents,
Willy
