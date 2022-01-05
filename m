Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED624854E0
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:44:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241035AbiAEOoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241022AbiAEOoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:44:19 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB183C06179B
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:44:18 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57WT-0004BX-5e
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 15:44:17 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 416B16D1B09
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 14:44:09 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 217DB6D1AC0;
        Wed,  5 Jan 2022 14:44:05 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ff8955cc;
        Wed, 5 Jan 2022 14:44:04 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Lukas Magel <lukas.magel@escrypt.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 06/15] can: etas_es58x: es58x_init_netdev: populate net_device::dev_port
Date:   Wed,  5 Jan 2022 15:43:53 +0100
Message-Id: <20220105144402.1174191-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220105144402.1174191-1-mkl@pengutronix.de>
References: <20220105144402.1174191-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

The field dev_port of struct net_device indicates the port number of a
network device [1]. This patch populates this field.

This field can be helpful to distinguish between the two network
interfaces of a dual channel device (i.e. ES581.4 or ES582.1). Indeed,
at the moment, all the network interfaces of a same device share the
same static udev attributes c.f. output of:

| udevadm info --attribute-walk /sys/class/net/canX

The dev_port attribute can then be used to write some udev rules to,
for example, assign a permanent name to each network interface based
on the serial/dev_port pair (which is convenient when you have a test
bench with several CAN devices connected simultaneously and wish to
keep consistent interface names upon reboot).

[1] https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-net

Link: https://lore.kernel.org/all/20211026180553.1953189-1-mailhol.vincent@wanadoo.fr
Suggested-by: Lukas Magel <lukas.magel@escrypt.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 24627ab14626..8508a73d648e 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2094,6 +2094,7 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 
 	netdev->netdev_ops = &es58x_netdev_ops;
 	netdev->flags |= IFF_ECHO;	/* We support local echo */
+	netdev->dev_port = channel_idx;
 
 	ret = register_candev(netdev);
 	if (ret)
-- 
2.34.1


