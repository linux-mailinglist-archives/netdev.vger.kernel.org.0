Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2FF524825
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351553AbiELInF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:43:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346555AbiELInB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:43:01 -0400
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E053ED2D;
        Thu, 12 May 2022 01:42:59 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 52EC8101917A2;
        Thu, 12 May 2022 10:42:57 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 3042761C2B10;
        Thu, 12 May 2022 10:42:57 +0200 (CEST)
X-Mailbox-Line: From 4a90661372af73e056f7b243df9c039945715a3b Mon Sep 17 00:00:00 2001
Message-Id: <cover.1652343655.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 12 May 2022 10:42:00 +0200
Subject: [PATCH net-next v3 0/7] Polling be gone on LAN95xx
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
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

Link to v2:
https://lore.kernel.org/netdev/cover.1651574194.git.lukas@wunner.de/

Only change since v2:

* Patch [5/7]:
  * Drop call to __irq_enter_raw() which worked around a warning in
    generic_handle_domain_irq().  That warning is gone since
    792ea6a074ae (queued on tip.git/irq/urgent).
    (Marc Zyngier, Thomas Gleixner)


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
 drivers/net/usb/smsc95xx.c     | 152 +++++++++++++++------------------
 drivers/net/usb/usbnet.c       |   6 +-
 4 files changed, 88 insertions(+), 104 deletions(-)

-- 
2.35.2

