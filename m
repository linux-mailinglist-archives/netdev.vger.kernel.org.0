Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D796D7821
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbjDEJ1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237354AbjDEJ1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:27:42 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D5A4C23
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:27:32 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <m.felsch@pengutronix.de>)
        id 1pjzPz-0004pA-Ue; Wed, 05 Apr 2023 11:27:03 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
Date:   Wed, 05 Apr 2023 11:26:53 +0200
Subject: [PATCH 02/12] net: phy: refactor get_phy_device function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-net-next-topic-net-phy-reset-v1-2-7e5329f08002@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
X-Mailer: b4 0.12.1
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: m.felsch@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split get_phy_device() into local helper function. This commit is in
preparation of fixing the phy reset handling. No functional changes for
the public API users.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/net/phy/phy_device.c | 44 +++++++++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index dd0aaa866d17..64292e47e3fc 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -938,6 +938,32 @@ int fwnode_get_phy_id(struct fwnode_handle *fwnode, u32 *phy_id)
 }
 EXPORT_SYMBOL(fwnode_get_phy_id);
 
+static int phy_device_detect(struct mii_bus *bus, int addr, bool *is_c45,
+			     u32 *phy_id, struct phy_c45_device_ids *c45_ids)
+{
+	int r;
+
+	if (*is_c45)
+		r = get_phy_c45_ids(bus, addr, c45_ids);
+	else
+		r = get_phy_c22_id(bus, addr, phy_id);
+
+	if (r)
+		return r;
+
+	/* PHY device such as the Marvell Alaska 88E2110 will return a PHY ID
+	 * of 0 when probed using get_phy_c22_id() with no error. Proceed to
+	 * probe with C45 to see if we're able to get a valid PHY ID in the C45
+	 * space, if successful, create the C45 PHY device.
+	 */
+	if (!*is_c45 && *phy_id == 0 && bus->read_c45) {
+		*is_c45 = true;
+		return get_phy_c45_ids(bus, addr, c45_ids);
+	}
+
+	return 0;
+}
+
 /**
  * get_phy_device - reads the specified PHY device and returns its @phy_device
  *		    struct
@@ -967,26 +993,10 @@ struct phy_device *get_phy_device(struct mii_bus *bus, int addr, bool is_c45)
 	c45_ids.mmds_present = 0;
 	memset(c45_ids.device_ids, 0xff, sizeof(c45_ids.device_ids));
 
-	if (is_c45)
-		r = get_phy_c45_ids(bus, addr, &c45_ids);
-	else
-		r = get_phy_c22_id(bus, addr, &phy_id);
-
+	r = phy_device_detect(bus, addr, &is_c45, &phy_id, &c45_ids);
 	if (r)
 		return ERR_PTR(r);
 
-	/* PHY device such as the Marvell Alaska 88E2110 will return a PHY ID
-	 * of 0 when probed using get_phy_c22_id() with no error. Proceed to
-	 * probe with C45 to see if we're able to get a valid PHY ID in the C45
-	 * space, if successful, create the C45 PHY device.
-	 */
-	if (!is_c45 && phy_id == 0 && bus->read_c45) {
-		r = get_phy_c45_ids(bus, addr, &c45_ids);
-		if (!r)
-			return phy_device_create(bus, addr, phy_id,
-						 true, &c45_ids);
-	}
-
 	return phy_device_create(bus, addr, phy_id, is_c45, &c45_ids);
 }
 EXPORT_SYMBOL(get_phy_device);

-- 
2.39.2

