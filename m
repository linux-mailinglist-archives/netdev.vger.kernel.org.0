Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B81F45BBF7A
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 21:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiIRTNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 15:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiIRTNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 15:13:41 -0400
Received: from bmailout1.hostsharing.net (bmailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5f64:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D6EC9FDE;
        Sun, 18 Sep 2022 12:13:39 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id DAB62300002D5;
        Sun, 18 Sep 2022 21:13:33 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B518330F86; Sun, 18 Sep 2022 21:13:33 +0200 (CEST)
Date:   Sun, 18 Sep 2022 21:13:33 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY interrupts
 to PHY driver to avoid polling
Message-ID: <20220918191333.GA2107@wunner.de>
References: <CGME20220517101846eucas1p2c132f7e7032ed00996e222e9cc6cdf99@eucas1p2.samsung.com>
 <a5315a8a-32c2-962f-f696-de9a26d30091@samsung.com>
 <20220519190841.GA30869@wunner.de>
 <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
 <e598a232-6c78-782a-316f-77902644ad6c@samsung.com>
 <20220826071924.GA21264@wunner.de>
 <2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com>
 <20220826075331.GA32117@wunner.de>
 <093730dd-2f2c-bd0b-bd13-b97f8a2898bd@samsung.com>
 <81c0f21f-f8f1-f7b3-c52f-c6a564c6a445@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81c0f21f-f8f1-f7b3-c52f-c6a564c6a445@samsung.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[cc += Florian]

On Mon, Aug 29, 2022 at 01:40:05PM +0200, Marek Szyprowski wrote:
> I've finally traced what has happened. I've double checked and indeed 
> the 1758bde2e4aa commit fixed the issue on next-20220516 kernel and as 
> such it has been merged to linus tree. Then the commit 744d23c71af3 
> ("net: phy: Warn about incorrect mdio_bus_phy_resume() state") has been 
> merged to linus tree, which triggers a new warning during the 
> suspend/resume cycle with smsc95xx driver. Please note, that the 
> smsc95xx still works fine regardless that warning. However it look that 
> the commit 1758bde2e4aa only hide a real problem, which the commit 
> 744d23c71af3 warns about.
> 
> Probably a proper fix for smsc95xx driver is to call phy_stop/start 
> during suspend/resume cycle, like in similar patches for other drivers:
> 
> https://lore.kernel.org/all/20220825023951.3220-1-f.fainelli@gmail.com/

No, smsc95xx.c relies on mdio_bus_phy_{suspend,resume}() and there's
no need to call phy_{stop,start}().

744d23c71af3 was flawed and 6dbe852c379f has already fixed a portion
of the fallout.

However the WARN() condition still seems too broad and causes false
positives such as in your case.  In particular, mdio_bus_phy_suspend()
may leave the device in PHY_UP state, so that's a legal state that
needs to be exempted from the WARN().

Does the issue still appear even after 6dbe852c379f?

If it does, could you test whether exempting PHY_UP silences the
gratuitous WARN splat?  I.e.:

-	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY);
+	WARN_ON(phydev->state != PHY_HALTED && phydev->state != PHY_READY &&
+		phydev->state != PHY_UP);

Thanks,

Lukas
