Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7F46BE9FF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 14:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCQNWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 09:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCQNWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 09:22:08 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54AE4DBF0
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 06:22:06 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pdA1i-0004H6-9G; Fri, 17 Mar 2023 14:21:46 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pdA1c-0007xo-KL; Fri, 17 Mar 2023 14:21:40 +0100
Date:   Fri, 17 Mar 2023 14:21:40 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Vasut <marex@denx.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Ben Hutchings <ben.hutchings@mind.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT PATCH net-next 2/4] net: dsa: microchip: partial
 conversion to regfields API for KSZ8795 (WIP)
Message-ID: <20230317132140.GB15269@pengutronix.de>
References: <20230316161250.3286055-1-vladimir.oltean@nxp.com>
 <20230316161250.3286055-3-vladimir.oltean@nxp.com>
 <20230317094629.nryf6qkuxp4nisul@skbuf>
 <20230317114646.GA15269@pengutronix.de>
 <20230317125022.ujbnwf2k5uvhyx53@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230317125022.ujbnwf2k5uvhyx53@skbuf>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 02:50:22PM +0200, Vladimir Oltean wrote:
> On Fri, Mar 17, 2023 at 12:46:46PM +0100, Oleksij Rempel wrote:
> > There reason is that ksz8795_regfields[] is assigned only to KSZ8795.
> > KSZ8794, KSZ8765 and KSZ8830 (KSZ8863/KSZ8873) do not have needed regfields.
> > 
> > Please note, ksz8795_regfields[] is not compatible with KSZ8830 (KSZ8863/KSZ8873)
> > series.
> 
> Right... well, it's kind of in the title and in the commit description:
> 
> | !! WARNING !! I only attempted to add a ksz_reg_fields structure for
> | KSZ8795. The other switch families will currently crash!
> 
> If the only device you can test on is KSZ8873, that isn't going to help
> me very much at the moment, because it doesn't have an xMII port, but
> rather, either MII or RMII depending on part number. AFAIU, ksz_is_ksz88x3()
> returns true for your device, and this means that neither phylink_mac_link_up()
> nor phylink_mac_config() do nothing for your device. Also, above all,
> ksz8863_regs[] does not have either P_XMII_CTRL_0 nor P_XMII_CTRL_1
> defined, which are some of the registers I had converted to reg_fields,
> in order to see whether it's possible to access a global register via a
> port regfield call.
> 
> I'm going to let this patch set simmer for a few more days. If no one
> volunteers to test on a KSZ8795, IMO the exercise is slightly pointless,
> as that's where the problems were, and more and more blind reasoning
> about what could be a problem isn't going to get us very far. I'd rather
> not spend more time on this problem at this stage. I've copied some more
> people who contributed patches to this switch family in the past few
> years, in the hope that maybe someone can help.
> 
> For context, the cover letter is here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20230316161250.3286055-1-vladimir.oltean@nxp.com/

If you'll give up, may be i'll be able to take it over.

Thanks!
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
