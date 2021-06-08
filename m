Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4206139FA55
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 17:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhFHPZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 11:25:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38424 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbhFHPYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 11:24:52 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lqdZ9-0005al-9X; Tue, 08 Jun 2021 15:22:55 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2][next] net: usb: asix: ax88772: net: Fix less than zero comparison of a u16
Date:   Tue,  8 Jun 2021 16:22:49 +0100
Message-Id: <20210608152249.160333-2-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608152249.160333-1-colin.king@canonical.com>
References: <20210608152249.160333-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The comparison of the u16 priv->phy_addr < 0 is always false because
phy_addr is unsigned. Fix this by assigning the return from the call
to function asix_read_phy_addr to int ret and using this for the
less than zero error check comparison.

Addresses-Coverity: ("Unsigned compared against 0")
Fixes: 7e88b11a862a ("net: usb: asix: refactor asix_read_phy_addr() and handle errors on return")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/usb/ax88172a.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index 2e2081346740..e24773bb9398 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -205,7 +205,8 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto free;
 	}
 
-	priv->phy_addr = asix_read_phy_addr(dev, priv->use_embdphy);
+	ret = asix_read_phy_addr(dev, priv->use_embdphy);
+	priv->phy_addr = ret;
 	if (priv->phy_addr < 0) {
 		ret = priv->phy_addr;
 		goto free;
-- 
2.31.1

