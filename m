Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E8B51853D
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 15:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbiECNSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 09:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbiECNSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 09:18:36 -0400
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B432ED6C;
        Tue,  3 May 2022 06:15:03 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id 3AEEC101E6B56;
        Tue,  3 May 2022 15:15:02 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 033F1630FA12;
        Tue,  3 May 2022 15:15:01 +0200 (CEST)
X-Mailbox-Line: From 95ff93fffa161a7a96604b4dfe2be933fe740785 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1651574194.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Tue, 3 May 2022 15:15:00 +0200
Subject: [PATCH net-next v2 0/7] Polling be gone on LAN95xx
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
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
        Ferry Toth <fntoth@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do away with link status polling on LAN95xx USB Ethernet
and rely on interrupts instead, thereby reducing bus traffic,
CPU overhead and improving interface bringup latency.

Link to v1:
https://lore.kernel.org/netdev/cover.1651037513.git.lukas@wunner.de/


Changes since v1:

* Patch [4/7]:
  * Silence "Error updating MAC full duplex mode" warning if it's
    caused by hot-removal. (Oleksij Rempel)
  * Explain in commit message why a semicolon on a line by itself is
    temporarily added in smsc95xx_status(). (Andrew Lunn)

* Patch [5/7]:
  * Eliminate a checkpatch "no space before tabs" warning.
  * Explain in commit message why the call to phy_init_hw() is moved
    in smsc95xx_resume().

* Patch [6/7]:
  * Expand commit message to explain in greater detail why caching the
    interrupt mask is beneficial. (Andrew Lunn)


Lukas Wunner (7):
  usbnet: Run unregister_netdev() before unbind() again
  usbnet: smsc95xx: Don't clear read-only PHY interrupt
  usbnet: smsc95xx: Don't reset PHY behind PHY driver's back
  usbnet: smsc95xx: Avoid link settings race on interrupt reception
  usbnet: smsc95xx: Forward PHY interrupts to PHY driver to avoid
    polling
  net: phy: smsc: Cache interrupt mask
  net: phy: smsc: Cope with hot-removal in interrupt handler

 drivers/net/phy/smsc.c         |  28 +++---
 drivers/net/usb/asix_devices.c |   6 +-
 drivers/net/usb/smsc95xx.c     | 157 ++++++++++++++++-----------------
 drivers/net/usb/usbnet.c       |   6 +-
 4 files changed, 93 insertions(+), 104 deletions(-)

-- 
2.35.2

