Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837256468C4
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 06:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiLHFzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 00:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbiLHFzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 00:55:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1989699537
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 21:55:18 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p39sJ-0006mT-Dm; Thu, 08 Dec 2022 06:55:15 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1p39sG-0001fG-Qo; Thu, 08 Dec 2022 06:55:12 +0100
Date:   Thu, 8 Dec 2022 06:55:12 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>, kernel@pengutronix.de,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: add stats64 support
 for ksz8 series of switches
Message-ID: <20221208055512.GE19179@pengutronix.de>
References: <20221205052904.2834962-1-o.rempel@pengutronix.de>
 <20221206114133.291881a4@kernel.org>
 <20221207061630.GC19179@pengutronix.de>
 <20221207154826.5477008b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221207154826.5477008b@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 03:48:26PM -0800, Jakub Kicinski wrote:
> On Wed, 7 Dec 2022 07:16:30 +0100 Oleksij Rempel wrote:
> > > FWIW for normal netdevs / NICs the rtnl_link_stat pkts do not include
> > > pause frames, normally. Otherwise one can't maintain those stats in SW
> > > (and per-ring stats, if any, don't add up to the full link stats).
> > > But if you have a good reason to do this - I won't nack..  
> > 
> > Pause frames are accounted by rx/tx_bytes by HW. Since pause frames may
> > have different size, it is not possible to correct byte counters, so I
> > need to add them to the packet counters.
> 
> I have embarrassed myself with my lack of understanding of pause frames
> before but nonetheless - are you sure?  I thought they are always 64B.
> Quick look at the standard seems to agree:
> 
>  31C.3.1 Receive state diagram (INITIATE MAC CONTROL FUNCTION) for
>          EXTENSION operation
> 
> shows a 64 octet frame.
> 
> Sending long pause frames seems self-defeating as we presumably want
> the receiver to react ASAP.

I tested it by sending correct and malformed pause frames manually with
mausezahn. Since it is possible to send and receive pause frames
manually, it is good to count all bytes in use, otherwise we may have
bogus or malicious stealth traffic without possibility to measure it.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
