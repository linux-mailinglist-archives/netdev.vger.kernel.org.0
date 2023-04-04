Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE82B6D61CE
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 15:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbjDDNGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 09:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234769AbjDDNGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 09:06:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441021995
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 06:06:18 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjgMT-0005aV-Ku; Tue, 04 Apr 2023 15:06:09 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pjgMR-0003hi-Fx; Tue, 04 Apr 2023 15:06:07 +0200
Date:   Tue, 4 Apr 2023 15:06:07 +0200
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
Message-ID: <20230404130607.GB4044@pengutronix.de>
References: <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-1-o.rempel@pengutronix.de>
 <20230404101842.1382986-3-o.rempel@pengutronix.de>
 <20230404101842.1382986-3-o.rempel@pengutronix.de>
 <20230404113124.nokweynmxtj3yqgt@skbuf>
 <20230404121911.GA4044@pengutronix.de>
 <20230404125002.dv2f4foojhy43dkx@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230404125002.dv2f4foojhy43dkx@skbuf>
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

On Tue, Apr 04, 2023 at 03:50:02PM +0300, Vladimir Oltean wrote:
> On Tue, Apr 04, 2023 at 02:19:11PM +0200, Oleksij Rempel wrote:
> > If I compare KSZ879CLX and KSZ8873MLL datasheets, i do not see direct
> > answer. The only reason I can imagine is the size of static MAC table.
> > All KSZ88xx and KSZ87xx variants have only 8 entries. One is already
> > used for STP (even if STP is not enabled, can be optimized). If
> > BRIDGE_VLAN compiled, each local address will be configured 2 times.
> > So, depending on system configuration the static MAC table will full
> > very soon.
> 
> Yikes. KSZ8765 has num_statics = 8 and port_cnt = 5 (so 4 user ports I
> assume). So if all 4 user ports had their own MAC address, it would
> simply not be possible to put them under a VLAN-aware bridge, since that
> would consume 2 BR_FDB_LOCAL entries for each port, so the static MAC
> table would be full even without taking the bridge's MAC address into
> consideration.
> 
> Even with CONFIG_BRIDGE_VLAN_FILTERING turned off or with the bridge
> option vlan_default_pvid = 0, this would still consume 4 BR_FDB_LOCAL
> entries + one for the bridge's MAC address + 1 for STP, leaving only 2
> entries usable for *both* bridge fdb, *and* bridge mdb.
> 
> I haven't opened the datasheets of these chips. Is it possible to use
> the dynamic MAC table to store static(-ish) entries?

According to KSZ8795CLX datasheet, dynamic MAC table is read-only.
But there is Access Control Lists (ACL) with 16 entries. It is possible
created a forwarding rule with match against DST MAC address.

Beside, I'm working right now on KSZ9477 tc-flower support based on ACL
implementation.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
