Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFADC150EB
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 18:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfEFQJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 12:09:12 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:55090 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726646AbfEFQJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 12:09:11 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id E6AA643DE;
        Mon,  6 May 2019 18:09:08 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id b59045df;
        Mon, 6 May 2019 18:09:07 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
Subject: [PATCH RESEND net-next 3/3] staging: octeon-ethernet: Fix of_get_mac_address ERR_PTR check
Date:   Mon,  6 May 2019 18:08:40 +0200
Message-Id: <1557158920-31586-4-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1557158920-31586-1-git-send-email-ynezz@true.cz>
References: <1557158920-31586-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 284eb160681c ("staging: octeon-ethernet: support
of_get_mac_address new ERR_PTR error") has introduced checking for
ERR_PTR encoded error value from of_get_mac_address with IS_ERR macro,
which is not sufficient in this case, as the mac variable is set to NULL
initialy and if the kernel is compiled without DT support this NULL
would get passed to IS_ERR, which would lead to the wrong decision and
would pass that NULL pointer and invalid MAC address further.

Fixes: 284eb160681c ("staging: octeon-ethernet: support of_get_mac_address new ERR_PTR error")
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 drivers/staging/octeon/ethernet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index 2b03018..8847a11c2 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -421,7 +421,7 @@ int cvm_oct_common_init(struct net_device *dev)
 	if (priv->of_node)
 		mac = of_get_mac_address(priv->of_node);
 
-	if (!IS_ERR(mac))
+	if (!IS_ERR_OR_NULL(mac))
 		ether_addr_copy(dev->dev_addr, mac);
 	else
 		eth_hw_addr_random(dev);
-- 
1.9.1

