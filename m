Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230BD535042
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 15:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345716AbiEZNz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 09:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbiEZNz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 09:55:58 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860446B67E;
        Thu, 26 May 2022 06:55:56 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id C2000280D406E;
        Thu, 26 May 2022 15:55:54 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id AC8B12ED8D5; Thu, 26 May 2022 15:55:54 +0200 (CEST)
Date:   Thu, 26 May 2022 15:55:54 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY interrupts
 to PHY driver to avoid polling
Message-ID: <20220526135554.GA22214@wunner.de>
References: <cover.1652343655.git.lukas@wunner.de>
 <748ac44eeb97b209f66182f3788d2a49d7bc28fe.1652343655.git.lukas@wunner.de>
 <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
 <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
 <20220519190841.GA30869@wunner.de>
 <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
 <20220523094343.GA7237@wunner.de>
 <Yowv95s7g7Ou5U8J@lunn.ch>
 <2f612dd0-ac30-4860-ef1b-bbb180da21af@samsung.com>
 <YozJqD5bhg31gjz7@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YozJqD5bhg31gjz7@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 24, 2022 at 02:03:52PM +0200, Andrew Lunn wrote:
> As for this hardware, if it does not support WOL, why are interrupts
> still enabled?

LAN95xx chips do support WoL and will signal a USB wake event.
But whether that actually results in resume from system sleep
depends on the capabilities of the SoC and its USB host controller.

LAN95xx supports a variety of wake options (WoL, PHY Energy Detect, ...)
and can use either its integrated SMSC PHY or an external PHY.
I'm not sure all wake options will work with arbitrary external PHYs.

If WoL or Wake on PHY Energy Detect is not used, we just program the
LAN95xx to enter a deeper power state which results in the respective
wake events being ignored.  As a result, interrupts may be left enabled
even though they're not used as a wakeup source.  The phylib doesn't
provide an API to selectively disable or enable interrupts, other than
phy_stop() and phy_start(), which does a lot more.

The patch I've submitted today treats such unnecessarily enabled
interrupts leniently:  It will not signal wakeup if that wasn't enabled
and just remembers that an interrupt occurred.  The interrupt will be
replayed upon resume and that's it.

Thanks,

Lukas
