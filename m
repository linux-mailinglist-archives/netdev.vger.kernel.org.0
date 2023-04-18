Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E611A6E5A6A
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 09:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbjDRHZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 03:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjDRHZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 03:25:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C8E5BA0
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 00:25:01 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pofhr-0002tt-EE; Tue, 18 Apr 2023 09:24:51 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pofhq-0002s2-8f; Tue, 18 Apr 2023 09:24:50 +0200
Date:   Tue, 18 Apr 2023 09:24:50 +0200
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
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL
 support for ksz9477 switches
Message-ID: <20230418072450.GC30964@pengutronix.de>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230413042936.GA12562@pengutronix.de>
 <20230416165904.2y7zwgyxwltjzj7m@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230416165904.2y7zwgyxwltjzj7m@skbuf>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 16, 2023 at 07:59:04PM +0300, Vladimir Oltean wrote:
> On Thu, Apr 13, 2023 at 06:29:36AM +0200, Oleksij Rempel wrote:
> > According to KSZ9477S 5.2.8.2 Port Priority Control Register
> > "To achieve the desired functionality, do not set more than one bit at a
> > time in this register.
> > ...
> > Bit 6 - OR’ed Priority
> > ...
> > Bit 2 - 802.1p Priority Classification
> > Bit 1 - Diffserv Priority Classification
> > Bit 0 - ACL Priority Classification
> > "
> > @Arun  what will happen if multiple engines are used for packet
> > prioritization? For example ACL || Diffserv || 802.1p... ?
> > If I see it correctly, it is possible but not recommended. Should I
> > prevent usage of multiple prio sources? 
> 
> You could try and find out which one takes priority... we support VLAN
> PCP and DSCP prioritization through the dcbnl application priority table.

What will be the mainlineable interface for the DSCP support for KSZ8 series?
If i see it correctly, it should be possible to use tc:
tc filter add dev lan2 ingress protocol ip flower ip_tos 0x28 skip_sw skbedit priority 7
or dcb:
dcb app add dev lan2 dscp-prio 28:7

dcb implementation seems to have some advantages, since it will
allow to use OpenLLDP to configure traffic priorities. Correct?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
