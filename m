Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 780471BCE3A
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgD1VJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726683AbgD1VJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:09:07 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED79C03C1AC;
        Tue, 28 Apr 2020 14:09:07 -0700 (PDT)
Received: from apollo.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:6257:18ff:fec4:ca34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9D3F522726;
        Tue, 28 Apr 2020 23:09:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588108144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VBWZc7eYd5lE5SGLvgbg0EQUGMFti8WYzZ1zAOtYcuI=;
        b=uLB9to3jP2gjJMtFrX+Th1LJnxLPZ19e/R49T4hvQ2HdGtoqWk2TV5KosaToTd/6nYGrvp
        6LC3/Qf9fY/hMaRP3Q2AGETjGjWWNQyn4XyeQNroCOalzDYa3s03dtJQkVjZxiDcK4zXCE
        WNdU9xjEpgi4qe28Z9fj6+oq+Do5PFU=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 2/4] net: phy: bcm54140: fix phy_id_mask
Date:   Tue, 28 Apr 2020 23:08:52 +0200
Message-Id: <20200428210854.28088-2-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200428210854.28088-1-michael@walle.cc>
References: <20200428210854.28088-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++
X-Spam-Level: ******
X-Rspamd-Server: web
X-Spam-Status: Yes, score=6.40
X-Spam-Score: 6.40
X-Rspamd-Queue-Id: 9D3F522726
X-Spamd-Result: default: False [6.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         MID_CONTAINS_FROM(1.00)[];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c:8000::/33, country:DE];
         FREEMAIL_CC(0.00)[lunn.ch,gmail.com,armlinux.org.uk,davemloft.net,walle.cc];
         SUSPICIOUS_RECIPS(1.50)[]
X-Spam: Yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Broadcom defines the bits for this PHY as follows:
  { oui[24:3], model[6:0], revision[2:0] }

Thus we have to mask the lower three bits only.

Fixes: 6937602ed3f9 ("net: phy: add Broadcom BCM54140 support")
Signed-off-by: Michael Walle <michael@walle.cc>
---

Please note that although this patch contains a Fixes tag its subject
contains the net-next tag, because the commit in question is only in
net-next.

 drivers/net/phy/bcm54140.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/bcm54140.c b/drivers/net/phy/bcm54140.c
index eb5dbacc1253..edafc9dc2f63 100644
--- a/drivers/net/phy/bcm54140.c
+++ b/drivers/net/phy/bcm54140.c
@@ -852,7 +852,7 @@ static int bcm54140_set_tunable(struct phy_device *phydev,
 static struct phy_driver bcm54140_drivers[] = {
 	{
 		.phy_id         = PHY_ID_BCM54140,
-		.phy_id_mask    = 0xfffffff0,
+		.phy_id_mask    = 0xfffffff8,
 		.name           = "Broadcom BCM54140",
 		.features       = PHY_GBIT_FEATURES,
 		.config_init    = bcm54140_config_init,
@@ -870,7 +870,7 @@ static struct phy_driver bcm54140_drivers[] = {
 module_phy_driver(bcm54140_drivers);
 
 static struct mdio_device_id __maybe_unused bcm54140_tbl[] = {
-	{ PHY_ID_BCM54140, 0xfffffff0 },
+	{ PHY_ID_BCM54140, 0xfffffff8 },
 	{ }
 };
 
-- 
2.20.1

