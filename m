Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34624023A5
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 08:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhIGGyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 02:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbhIGGyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 02:54:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9952C0613C1
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 23:52:59 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mNUyY-00055E-3y
        for netdev@vger.kernel.org; Tue, 07 Sep 2021 08:52:58 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id B6B73678853
        for <netdev@vger.kernel.org>; Tue,  7 Sep 2021 06:52:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 91DB8678841;
        Tue,  7 Sep 2021 06:52:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3fabed0f;
        Tue, 7 Sep 2021 06:52:54 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Tong Zhang <ztong0001@gmail.com>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/2] can: c_can: fix null-ptr-deref on ioctl()
Date:   Tue,  7 Sep 2021 08:52:52 +0200
Message-Id: <20210907065252.1061052-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210907065252.1061052-1-mkl@pengutronix.de>
References: <20210907065252.1061052-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

The pdev maybe not a platform device, e.g. c_can_pci device, in this
case, calling to_platform_device() would not make sense. Also, per the
comment in drivers/net/can/c_can/c_can_ethtool.c, @bus_info should
match dev_name() string, so I am replacing this with dev_name() to fix
this issue.

[    1.458583] BUG: unable to handle page fault for address: 0000000100000000
[    1.460921] RIP: 0010:strnlen+0x1a/0x30
[    1.466336]  ? c_can_get_drvinfo+0x65/0xb0 [c_can]
[    1.466597]  ethtool_get_drvinfo+0xae/0x360
[    1.466826]  dev_ethtool+0x10f8/0x2970
[    1.467880]  sock_ioctl+0xef/0x300

Fixes: 2722ac986e93 ("can: c_can: add ethtool support")
Link: https://lore.kernel.org/r/20210906233704.1162666-1-ztong0001@gmail.com
Cc: stable@vger.kernel.org # 5.14+
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can_ethtool.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/can/c_can/c_can_ethtool.c b/drivers/net/can/c_can/c_can_ethtool.c
index cd5f07fca2a5..377c7d2e7612 100644
--- a/drivers/net/can/c_can/c_can_ethtool.c
+++ b/drivers/net/can/c_can/c_can_ethtool.c
@@ -15,10 +15,8 @@ static void c_can_get_drvinfo(struct net_device *netdev,
 			      struct ethtool_drvinfo *info)
 {
 	struct c_can_priv *priv = netdev_priv(netdev);
-	struct platform_device *pdev = to_platform_device(priv->device);
-
 	strscpy(info->driver, "c_can", sizeof(info->driver));
-	strscpy(info->bus_info, pdev->name, sizeof(info->bus_info));
+	strscpy(info->bus_info, dev_name(priv->device), sizeof(info->bus_info));
 }
 
 static void c_can_get_ringparam(struct net_device *netdev,
-- 
2.33.0


