Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320A754AC84
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 10:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355840AbiFNIu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 04:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355486AbiFNIuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 04:50:39 -0400
Received: from mailout1.hostsharing.net (mailout1.hostsharing.net [IPv6:2a01:37:1000::53df:5fcc:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D0041F9C;
        Tue, 14 Jun 2022 01:50:29 -0700 (PDT)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id C3498101920DA;
        Tue, 14 Jun 2022 10:50:25 +0200 (CEST)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 9F4926283BEF;
        Tue, 14 Jun 2022 10:50:25 +0200 (CEST)
X-Mailbox-Line: From 80e88f61ca68c36ebce5d17dfcaa8e956e19fb2f Mon Sep 17 00:00:00 2001
Message-Id: <80e88f61ca68c36ebce5d17dfcaa8e956e19fb2f.1655196227.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Tue, 14 Jun 2022 10:50:24 +0200
Subject: [PATCH net] sierra_net: Fix use-after-free on unbind
To:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On unbind, the Sierra USB WWAN driver cancels the sierra_net_kevent()
work, then stops polling for interrupts by calling usbnet_status_stop().

However the interrupt handler sierra_net_status() may re-schedule the
work after it's been canceled and thus cause a use-after-free.

Fix by inverting the teardown order.

Fixes: 7b0c5f21f348 ("sierra_net: keep status interrupt URB active")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.10+
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/net/usb/sierra_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index bb4cbe8fc846..197e1356ae98 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -758,6 +758,8 @@ static void sierra_net_unbind(struct usbnet *dev, struct usb_interface *intf)
 
 	dev_dbg(&dev->udev->dev, "%s", __func__);
 
+	usbnet_status_stop(dev);
+
 	/* kill the timer and work */
 	del_timer_sync(&priv->sync_timer);
 	cancel_work_sync(&priv->sierra_net_kevent);
@@ -769,8 +771,6 @@ static void sierra_net_unbind(struct usbnet *dev, struct usb_interface *intf)
 		netdev_err(dev->net,
 			"usb_control_msg failed, status %d\n", status);
 
-	usbnet_status_stop(dev);
-
 	sierra_net_set_private(dev, NULL);
 	kfree(priv);
 }
-- 
2.35.2

