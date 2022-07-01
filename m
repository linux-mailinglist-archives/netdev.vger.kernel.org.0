Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A46A563B38
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiGAUsA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiGAUsA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:48:00 -0400
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8EBD5C977;
        Fri,  1 Jul 2022 13:47:57 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id C8CAD102DFB85;
        Fri,  1 Jul 2022 22:47:55 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 6FC6861A6B50;
        Fri,  1 Jul 2022 22:47:55 +0200 (CEST)
X-Mailbox-Line: From c45e311ac5b95798fe7cddd7bb834c5df83bb97e Mon Sep 17 00:00:00 2001
Message-Id: <cover.1656707954.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Fri, 1 Jul 2022 22:47:50 +0200
Subject: [PATCH net-next v2 0/3] Deadlock no more in LAN95xx
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Ferry Toth <fntoth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Alan Stern <stern@rowland.harvard.edu>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Second attempt at fixing a runtime resume deadlock in the LAN95xx USB driver:

In short, the driver isn't using the "nopm" register accessors in portions
of its runtime resume path, causing a deadlock.  I'm fixing that by
auto-detecting whether nopm accessors shall be used, instead of
having to explicitly call them wherever it's necessary.
As a byproduct, code size shrinks significantly (see diffstat below).

Back in April I submitted a first attempt which was rejected by Alan Stern:
https://lore.kernel.org/all/6710d8c18ff54139cdc538763ba544187c5a0cee.1651041411.git.lukas@wunner.de/

That approach only detected whether a PM callback is running concurrently,
not whether the access is performed by the PM callback.  I've come up with
a different approach which should resolve the objection (see patch [1/3]).

Thanks!

Lukas Wunner (3):
  usbnet: smsc95xx: Fix deadlock on runtime resume
  usbnet: smsc95xx: Clean up nopm handling
  usbnet: smsc95xx: Clean up unnecessary BUG_ON() upon register access

 drivers/net/usb/smsc95xx.c | 202 ++++++++++++++++---------------------
 1 file changed, 86 insertions(+), 116 deletions(-)

-- 
2.36.1

