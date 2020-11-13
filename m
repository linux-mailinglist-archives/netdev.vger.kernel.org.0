Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C670B2B24D0
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 20:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgKMTop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 14:44:45 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:47548 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgKMTop (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 14:44:45 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 0ADJiWcF010910;
        Fri, 13 Nov 2020 20:44:32 +0100
Date:   Fri, 13 Nov 2020 20:44:32 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        netdev@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/3] macb: support the 2-deep Tx queue on at91
Message-ID: <20201113194432.GA10904@1wt.eu>
References: <20201011090944.10607-1-w@1wt.eu>
 <20201013170358.1a4d282a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201014030630.GA12531@1wt.eu>
 <20201113100359.GJ4556@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113100359.GJ4556@piout.net>
User-Agent: Mutt/1.6.1 (2016-04-27)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexandre!

On Fri, Nov 13, 2020 at 11:03:59AM +0100, Alexandre Belloni wrote:
> I think I'm the only one booting recent linux kernels on at91rm9200 and
> I'm currently stuck home while the board is at the office. I'll try to
> test as soon as possible, which may not be before 2021... At least I'll
> know who is the culprit ;)

Oh that's great. I have a SAMG20 based one, which uses slightly different
registers and supports a tx ring, so initially I thought that I couldn't
test it there. But a friend of mine who wrote the drivers for FreeBSD
told me that the original driver still worked for the SAMG20, and I
suspect that despite not being mentioned in the datasheet, the more
recent chip still supports the old behavior, at least to ease the
transistion for their customers. So eventually I'll try it too.

In all transparency, I must tell you that I recently noticed an issue
when facing intense bidirectional traffic, eventually the chip would
report a TX overrun and would stop sending. I finally attributed this
to the unmerged changes needed for the MStar chip, which uses two 16
bit I/O accesses instead of a single 32-bit one, and which apparently
doesn't like being interrupted between the two when writing to the TAR
or TLEN registers. It took me the whole week-end to figure the root
cause so now I need to remove all my debugging code, address the issue
and test again. If I can't manage to fix this and you can't find a
moment to test on your board, I'll propose to revert my patch to stay
on the safe side, as I want at least one implementation to be 100%
reliable with it.

Cheers,
Willy
