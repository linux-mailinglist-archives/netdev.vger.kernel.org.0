Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817171935F
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 22:29:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfEIU3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 16:29:34 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57245 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfEIU3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 16:29:34 -0400
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1hOpfX-0004oe-Qg; Thu, 09 May 2019 22:29:31 +0200
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1hOpfV-00086r-PU; Thu, 09 May 2019 22:29:29 +0200
Date:   Thu, 9 May 2019 22:29:29 +0200
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de
Subject: net: micrel: confusion about phyids used in driver
Message-ID: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I have a board here that has a KSZ8051MLL (datasheet:
http://ww1.microchip.com/downloads/en/DeviceDoc/ksz8051mll.pdf, phyid:
0x0022155x) assembled. The actual phyid is 0x00221556.

When enabling the micrel driver it successfully binds and claims to have
detected a "Micrel KSZ8031" because phyid & 0x00ffffff ==
PHY_ID_KSZ8031 (with PHY_ID_KSZ8031 = 0x00221556). I found a datasheet
for KSZ8021RNL and KSZ8031RNL in our collection, there the phyid is
documented as 0x0022155x, too. (So there is a deviation between driver
and data sheet.)

A difference between these two parts are register bits 0x16.9 and
0x1f.7. (I didn't check systematically and there are definitely more
differences, for example 0x16.7 which isn't handled at all in the
driver.)

The driver does the right thing with KSZ8051MLL for bit 0x16.9 (which is
setting a reserved bit on KSZ8021RNL/KSZ8031RNL) and for 0x1f.7 it's the
other way round.

To make the situation still more interesting there is another phy entry
"Micrel KSZ8051" that has .phy_id = 0x00221550 and .phy_id_mask =
0x00fffff0, which just judging from the name would be the better match.
(This isn't used however because even though it matches "Micrel KSZ8031"
is listed before and so is preferred.) With this the handling of the
register bit 0x16.9 isn't right for the KSZ8051MLL. (I think it would if
ksz8051_type had .has_broadcast_disable = true.)

I'm unclear what the right approach is to fix this muddle, maybe someone
with more insight in the driver and maybe also in possession of more
data sheets and hardware can tell?

My impression is that it is not possible to determine all features by
just using the phyid. Would it be sensible to not difference between
KSZ8031 and KSZ8051 and assume that writing to a reserved register bit
does nothing?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
