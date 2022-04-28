Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C57951337B
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 14:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346136AbiD1MXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 08:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346119AbiD1MXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 08:23:13 -0400
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06D9ADD62;
        Thu, 28 Apr 2022 05:19:58 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 6E77A103201CF;
        Thu, 28 Apr 2022 14:19:56 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 3547BA3DD6; Thu, 28 Apr 2022 14:19:56 +0200 (CEST)
Date:   Thu, 28 Apr 2022 14:19:56 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, Andre Edich <andre.edich@microchip.com>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 0/7] Polling be gone on LAN95xx
Message-ID: <20220428121956.GA18418@wunner.de>
References: <cover.1651037513.git.lukas@wunner.de>
 <20220427123715.GC17577@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427123715.GC17577@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 27, 2022 at 02:37:15PM +0200, Oleksij Rempel wrote:
> On Wed, Apr 27, 2022 at 07:48:00AM +0200, Lukas Wunner wrote:
> > Do away with link status polling on LAN95XX USB Ethernet
> > and rely on interrupts instead, thereby reducing bus traffic,
> > CPU overhead and improving interface bringup latency.
> > 
> > The meat of the series is in patch [5/7].  The preceding and
> > following patches are various cleanups to prepare for and
> > adjust to interrupt-driven link state detection.
> 
> Tested-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> Tested on:
> - LAN9514 (RPi2)
> - LAN9512 (EVB)
> - LAN9500 (EVB)

Thanks a lot for testing, this helps greatly.

> On USB unplug i get some not usable kernel message, but it is not the
> show stopper for me:
> smsc95xx 1-1.4.1:1.0 eth1: Error updating MAC full duplex mode
> smsc95xx 1-1.4.1:1.0 eth1: hardware isn't capable of remote wakeup

Okay, I've amended patch [4/7] to silence the first of these messages
if the error is caused by hot-removal.

The second message isn't related to this series, I'll address that
separately at a later point in time.

Thanks,

Lukas
