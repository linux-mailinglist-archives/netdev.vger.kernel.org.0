Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EEBA6D601E
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 14:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbjDDMUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 08:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbjDDMTi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 08:19:38 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CF64FF
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 05:19:21 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjfd2-0004oI-5t; Tue, 04 Apr 2023 14:19:12 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjfd1-0000jI-BH; Tue, 04 Apr 2023 14:19:11 +0200
Date:   Tue, 4 Apr 2023 14:19:11 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/7] net: dsa: microchip: ksz8: Implement
 add/del_fdb and use static MAC table operations
Message-ID: <20230404121911.GA4044@pengutronix.de>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-3-o.rempel@pengutronix.de>
 <20230404101842.1382986-3-o.rempel@pengutronix.de>
 <20230404113124.nokweynmxtj3yqgt@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230404113124.nokweynmxtj3yqgt@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 02:31:24PM +0300, Vladimir Oltean wrote:
> On Tue, Apr 04, 2023 at 12:18:37PM +0200, Oleksij Rempel wrote:
> > Add support for add/del_fdb operations and utilize the refactored static
> > MAC table code. This resolves kernel warnings caused by the lack of fdb
> > add function support in the current driver.
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> 
> Side note, I wonder if it's so simple, why this was not done in
> e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")?

If I compare KSZ879CLX and KSZ8873MLL datasheets, i do not see direct
answer. The only reason I can imagine is the size of static MAC table.
All KSZ88xx and KSZ87xx variants have only 8 entries. One is already
used for STP (even if STP is not enabled, can be optimized). If
BRIDGE_VLAN compiled, each local address will be configured 2 times.
So, depending on system configuration the static MAC table will full
very soon.

I tested this patch on KSZ8873. Without this patch, if we do not
send any thing from CPU port, local MAC addresses will be forgotten by
the dynamic MAC table. Sending packets to a local MAC address from swp0
will flood packets to CPU and swp1. With this patch, packets fill be
forwarded only to CPU - as expected.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
