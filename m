Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC295110BA
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 07:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357917AbiD0GAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357916AbiD0GAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:00:18 -0400
X-Greylist: delayed 459 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 26 Apr 2022 22:57:08 PDT
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C0D2BB1F;
        Tue, 26 Apr 2022 22:57:07 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id EA04F1033C2C7;
        Wed, 27 Apr 2022 07:49:26 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id BC6BC61ABA99;
        Wed, 27 Apr 2022 07:49:26 +0200 (CEST)
X-Mailbox-Line: From 62b8375ae008035bcaa85c348ea4aa80c519bb07 Mon Sep 17 00:00:00 2001
Message-Id: <cover.1651037513.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 27 Apr 2022 07:48:00 +0200
Subject: [PATCH net-next 0/7] Polling be gone on LAN95xx
To:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do away with link status polling on LAN95XX USB Ethernet
and rely on interrupts instead, thereby reducing bus traffic,
CPU overhead and improving interface bringup latency.

The meat of the series is in patch [5/7].  The preceding and
following patches are various cleanups to prepare for and
adjust to interrupt-driven link state detection.

Please review and test.  Thanks!

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
 drivers/net/usb/smsc95xx.c     | 155 ++++++++++++++++-----------------
 drivers/net/usb/usbnet.c       |   6 +-
 4 files changed, 91 insertions(+), 104 deletions(-)

-- 
2.35.2

