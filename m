Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23332542E42
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 12:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237247AbiFHKrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 06:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237318AbiFHKrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 06:47:41 -0400
X-Greylist: delayed 1799 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Jun 2022 03:47:36 PDT
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C8419B6AD;
        Wed,  8 Jun 2022 03:47:35 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id D7E4A101E6C50;
        Wed,  8 Jun 2022 11:52:35 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 94BC5621B6E1;
        Wed,  8 Jun 2022 11:52:35 +0200 (CEST)
X-Mailbox-Line: From 78ad73b93adb59edfa2d68e44a9fcfea65e98131 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1654680790.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 8 Jun 2022 11:52:10 +0200
Subject: [PATCH net v2 0/1] PHY interruptus horribilis
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>
Cc:     netdev@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn (PHY maintainer) asked me to resend this patch and cc the
IRQ maintainer.  I'm also cc'ing PM maintainers for good measure.

The patch addresses an issue with PHY interrupts occurring during a
system sleep transition after the PHY has already been suspended.

The IRQ subsystem uses an internal flag IRQD_WAKEUP_ARMED to avoid
handling such interrupts, but it's not set until suspend_device_irqs()
is called during the ->suspend_noirq() phase.  That's too late in this
case as PHYs are suspended in the ->suspend() phase.  And there's
no external interface to set the flag earlier.

As I'm lacking access to the flag, I'm open coding its functionality
in this patch.  Is this the correct approach or should I instead look
into providing an external interface to the flag?

Side note: suspend_device_irqs() and resume_device_irqs() have been
exported since forever even though there's no module user...

Thanks!

Changes since v1:
* Extend rationale in the commit message.
* Drop Fixes tag, add Tested-by tag (Marek).

Link to v1:
https://lore.kernel.org/netdev/688f559346ea747d3b47a4d16ef8277e093f9ebe.1653556322.git.lukas@wunner.de/

Lukas Wunner (1):
  net: phy: Don't trigger state machine while in suspend

 drivers/net/phy/phy.c        | 23 +++++++++++++++++++++++
 drivers/net/phy/phy_device.c | 23 +++++++++++++++++++++++
 include/linux/phy.h          |  6 ++++++
 3 files changed, 52 insertions(+)

-- 
2.35.2

