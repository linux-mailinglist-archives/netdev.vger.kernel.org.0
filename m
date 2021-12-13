Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D518473150
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 17:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbhLMQLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 11:11:17 -0500
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:53572 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240490AbhLMQLQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 11:11:16 -0500
Received: from localhost.localdomain ([106.133.22.31])
        by smtp.orange.fr with ESMTPA
        id wnuom1qs4k3HQwnuxmkP2j; Mon, 13 Dec 2021 17:11:15 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: MDU0YmViZGZmMDIzYiBlMiM2NTczNTRjNWZkZTMwOGRiOGQ4ODf3NWI1ZTMyMzdiODlhOQ==
X-ME-Date: Mon, 13 Dec 2021 17:11:15 +0100
X-ME-IP: 106.133.22.31
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Lukas Magel <lukas.magel@escrypt.com>
Subject: [RESEND PATCH v1] can: etas_es58x: es58x_init_netdev: populate net_device::dev_port
Date:   Tue, 14 Dec 2021 01:10:58 +0900
Message-Id: <20211213161058.56599-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211029111829.crrwdjizlflzzhq2@pengutronix.de>
References: <20211029111829.crrwdjizlflzzhq2@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Suggested-by: Lukas Magel <lukas.magel@escrypt.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Hi Marc,

At one point, this patch was applied to linux-can-next/testing but was
then removed. I guess it just went off your radar. Resending it :)


Yours sincerely,
Vincent Mailhol

---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 96a13c770e4a..403de7e9d084 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2096,6 +2096,7 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 
 	netdev->netdev_ops = &es58x_netdev_ops;
 	netdev->flags |= IFF_ECHO;	/* We support local echo */
+	netdev->dev_port = channel_idx;
 
 	ret = register_candev(netdev);
 	if (ret)
-- 
2.32.0

