Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DAB5E72CD
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 06:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiIWEUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 00:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiIWEUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 00:20:44 -0400
Received: from bmailout2.hostsharing.net (bmailout2.hostsharing.net [83.223.78.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419C7F3100;
        Thu, 22 Sep 2022 21:20:42 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 31C39280973F2;
        Fri, 23 Sep 2022 06:20:37 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 1690F4EA97; Fri, 23 Sep 2022 06:20:37 +0200 (CEST)
Date:   Fri, 23 Sep 2022 06:20:37 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
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
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY interrupts
 to PHY driver to avoid polling
Message-ID: <20220923042037.GA10101@wunner.de>
References: <e598a232-6c78-782a-316f-77902644ad6c@samsung.com>
 <20220826071924.GA21264@wunner.de>
 <2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com>
 <20220826075331.GA32117@wunner.de>
 <093730dd-2f2c-bd0b-bd13-b97f8a2898bd@samsung.com>
 <81c0f21f-f8f1-f7b3-c52f-c6a564c6a445@samsung.com>
 <20220918191333.GA2107@wunner.de>
 <d963b1a3-e18d-25d5-f07c-42d17d382174@gmail.com>
 <20220918205516.GA13914@wunner.de>
 <adb2de4e-0ad0-a94a-93e6-572f58a2141b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adb2de4e-0ad0-a94a-93e6-572f58a2141b@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 18, 2022 at 03:11:47PM -0700, Florian Fainelli wrote:
> On 9/18/2022 1:55 PM, Lukas Wunner wrote:
> > On Sun, Sep 18, 2022 at 01:41:13PM -0700, Florian Fainelli wrote:
> > > On 9/18/2022 12:13 PM, Lukas Wunner wrote:
> > > > On Mon, Aug 29, 2022 at 01:40:05PM +0200, Marek Szyprowski wrote:
> > > > > I've finally traced what has happened. I've double checked and indeed
> > > > > the 1758bde2e4aa commit fixed the issue on next-20220516 kernel and as
> > > > > such it has been merged to linus tree. Then the commit 744d23c71af3
> > > > > ("net: phy: Warn about incorrect mdio_bus_phy_resume() state") has been
> > > > > merged to linus tree, which triggers a new warning during the
> > > > > suspend/resume cycle with smsc95xx driver. Please note, that the
> > > > > smsc95xx still works fine regardless that warning. However it look that
> > > > > the commit 1758bde2e4aa only hide a real problem, which the commit
> > > > > 744d23c71af3 warns about.
> > > > > 
> > > > > Probably a proper fix for smsc95xx driver is to call phy_stop/start
> > > > > during suspend/resume cycle, like in similar patches for other drivers:
> > > > > 
> > > > > https://lore.kernel.org/all/20220825023951.3220-1-f.fainelli@gmail.com/
> > > > 
> > > > No, smsc95xx.c relies on mdio_bus_phy_{suspend,resume}() and there's
> > > > no need to call phy_{stop,start}() >
> > > > 744d23c71af3 was flawed and 6dbe852c379f has already fixed a portion
> > > > of the fallout.
> > > > 
> > > > However the WARN() condition still seems too broad and causes false
> > > > positives such as in your case.  In particular, mdio_bus_phy_suspend()
> > > > may leave the device in PHY_UP state, so that's a legal state that
> > > > needs to be exempted from the WARN().
> > > 
> > > How is that a legal state when the PHY should be suspended? Even if we are
> > > interrupt driven, the state machine should be stopped, does not mean that
> > > Wake-on-LAN or other activity interrupts should be disabled.
> > 
> > mdio_bus_phy_suspend()
> >    phy_stop_machine()
> >      phydev->state = PHY_UP  #  if (phydev->state >= PHY_UP)
> > 
> > So apparently PHY_UP is a legal state for a suspended PHY.
> 
> It is not clear to me why, however. Sure it does ensure that when we resume
> we set needs_aneg = true but this feels like a hack in the sense that we are
> setting the PHY in a provisional state in anticipation for what might come
> next.

I've just submitted a fix so that at least v6.0 doesn't get released
with a false-positive WARN splat on resume:

https://lore.kernel.org/netdev/8128fdb51eeebc9efbf3776a4097363a1317aaf1.1663905575.git.lukas@wunner.de/

I guess we can look into making the state setting more logical in a
separate step.


> > > If you allow PHY_UP, then the warning becomes effectively useless, so I
> > > don't believe this is quite what you want to do here.
> > 
> > Hm, maybe the WARN() should be dropped altogether?
> 
> And then be left with debugging similar problems that prompted me to submit
> the patch in the first place, no thank you. I guess I would rather accept
> that PHY_UP needs to be special cased then.

I've interpreted that as an Acked-by for exempting PHY_UP.
If that was not what you wanted, please speak up.

Thanks,

Lukas
