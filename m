Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562A82B18E1
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 11:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbgKMKQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 05:16:50 -0500
Received: from mslow2.mail.gandi.net ([217.70.178.242]:34048 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgKMKQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 05:16:50 -0500
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 93E143ACD7F
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 10:04:21 +0000 (UTC)
X-Originating-IP: 86.194.74.19
Received: from localhost (lfbn-lyo-1-997-19.w86-194.abo.wanadoo.fr [86.194.74.19])
        (Authenticated sender: alexandre.belloni@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id AA89CC002B;
        Fri, 13 Nov 2020 10:03:59 +0000 (UTC)
Date:   Fri, 13 Nov 2020 11:03:59 +0100
From:   Alexandre Belloni <alexandre.belloni@bootlin.com>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] macb: support the 2-deep Tx queue on at91
Message-ID: <20201113100359.GJ4556@piout.net>
References: <20201011090944.10607-1-w@1wt.eu>
 <20201013170358.1a4d282a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201014030630.GA12531@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201014030630.GA12531@1wt.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/10/2020 05:06:30+0200, Willy Tarreau wrote:
> On Tue, Oct 13, 2020 at 05:03:58PM -0700, Jakub Kicinski wrote:
> > On Sun, 11 Oct 2020 11:09:41 +0200 Willy Tarreau wrote:
> > > while running some tests on my Breadbee board, I noticed poor network
> > > Tx performance. I had a look at the driver (macb, at91ether variant)
> > > and noticed that at91ether_start_xmit() immediately stops the queue
> > > after sending a frame and waits for the interrupt to restart the queue,
> > > causing a dead time after each packet is sent.
> > > 
> > > The AT91RM9200 datasheet states that the controller supports two frames,
> > > one being sent and the other one being queued, so I performed minimal
> > > changes to support this. The transmit performance on my board has
> > > increased by 50% on medium-sized packets (HTTP traffic), and with large
> > > packets I can now reach line rate.
> > > 
> > > Since this driver is shared by various platforms, I tried my best to
> > > isolate and limit the changes as much as possible and I think it's pretty
> > > reasonable as-is. I've run extensive tests and couldn't meet any
> > > unexpected situation (no stall, overflow nor lockup).
> > > 
> > > There are 3 patches in this series. The first one adds the missing
> > > interrupt flag for RM9200 (TBRE, indicating the tx buffer is willing
> > > to take a new packet). The second one replaces the single skb with a
> > > 2-array and uses only index 0. It does no other change, this is just
> > > to prepare the code for the third one. The third one implements the
> > > queue. Packets are added at the tail of the queue, the queue is
> > > stopped at 2 packets and the interrupt releases 0, 1 or 2 depending
> > > on what the transmit status register reports.
> > 
> > LGTM. There's always a chance that this will make other 
> > designs explode, but short of someone from Cadence giving 
> > us a timely review we have only one way to find that out.. :)
> 
> Not that much in fact, given that the at91ether_* functions are only
> used by AT91RM9200 (whose datasheet I used to do this) and Mstar which
> I used for the tests. I initially wanted to get my old SAM9G20 board
> to boot until I noticed that it doesn't even use the same set of
> functions, so the potential victims are extremely limited :-)
> 

I think I'm the only one booting recent linux kernels on at91rm9200 and
I'm currently stuck home while the board is at the office. I'll try to
test as soon as possible, which may not be before 2021... At least I'll
know who is the culprit ;)


-- 
Alexandre Belloni, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
