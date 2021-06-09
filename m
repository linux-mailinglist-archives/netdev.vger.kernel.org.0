Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6F3A1108
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238802AbhFIK0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 06:26:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38483 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238766AbhFIK0r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 06:26:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lqvOD-0007LP-4r; Wed, 09 Jun 2021 10:24:49 +0000
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2][next][V2] net: usb: asix: ax88772: Fix less than zero comparison of a u16
Date:   Wed,  9 Jun 2021 11:24:48 +0100
Message-Id: <20210609102448.182798-2-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609102448.182798-1-colin.king@canonical.com>
References: <20210609102448.182798-1-colin.king@canonical.com>
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

Fixes: 7e88b11a862a ("net: usb: asix: refactor asix_read_phy_addr() and handle errors on return")
Addresses-Coverity: ("Unsigned compared against 0")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---

V2: fix up return check.

---
 drivers/net/usb/ax88172a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/ax88172a.c b/drivers/net/usb/ax88172a.c
index 2e2081346740..530947d7477b 100644
--- a/drivers/net/usb/ax88172a.c
+++ b/drivers/net/usb/ax88172a.c
@@ -205,11 +205,11 @@ static int ax88172a_bind(struct usbnet *dev, struct usb_interface *intf)
 		goto free;
 	}
 
-	priv->phy_addr = asix_read_phy_addr(dev, priv->use_embdphy);
-	if (priv->phy_addr < 0) {
-		ret = priv->phy_addr;
+	ret = asix_read_phy_addr(dev, priv->use_embdphy);
+	if (ret < 0)
 		goto free;
-	}
+
+	priv->phy_addr = ret;
 
 	ax88172a_reset_phy(dev, priv->use_embdphy);
 
-- 
2.31.1

