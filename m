Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8BB396A4E
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbhFAAf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhFAAfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 20:35:16 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B530C061756
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:35 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gb17so18892396ejc.8
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 17:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8xMWSio0MbluNP/rt7iWz8iiiphfVJh8gU1raW5y2Io=;
        b=JE9XZSKs6yW24ubBcg6rF0jal5DXAcLFOT/O+PQKPiiy4nBDsvhQV4X5ZhlnGl8wFc
         5+ZeWPVovWY86aoL0FMbtDkxxcgk6gS+3OhHmdPt8z6/0/6XrK04QIHV7iK6iC1DY2Aw
         Fksnf9iD7Rj/39iebZaoDxhaV63NisXVyhhNsqsEWl+Nu2e7/TBC6zzbLRHuGe3+Ihwu
         Hqtlkk0r+NM2aUnvLKowwe9BFa+tXSh2lQvZEqBqOrTJofk8eWL3QsGa/L+99l6PVSsR
         pS7/7DVbDx8SC5C9JD9dT/NbsYm/pBahZFgsFmkZbI+bWACJHxr9VhhCzcrC49W9CPRH
         MAhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8xMWSio0MbluNP/rt7iWz8iiiphfVJh8gU1raW5y2Io=;
        b=h6z8mtV6qc3t8AJpO+uax3SfMteXhRSitnDeAiae/LUDkzj5+SMqAk/Vix4Vnb75el
         DBahYV8e054BxkT4qAuD4nPmmsTv8rTqKbgZuXGPSrVcHyl9tlPqmmltZBhdzL2xQoBv
         PrzVmw3qN+1XGAim/X4tbplYi+dS9lFeDlbA1hW2Oc/3YBD+FkIUn7XExKFtC8+ayZ1j
         cZF8terlkAT778IAWD932ZrjqepJRAcVl5oDv46bNGPwojzqBRpowjOpQp7Yh1tMhSil
         9XOxJT6ESmoZa65h04pe3cUVrDkZ0BsZaCsqafVrDoZJMz718+ho08Np7Z6l2Hm+Rtni
         9bmA==
X-Gm-Message-State: AOAM533KF2qzjL8ZfQB9rscYJR2r/dn6b1G/O290ycJU75hdX3bCBYrs
        0K8Cy64OG8p5nxWO4tXEzZw=
X-Google-Smtp-Source: ABdhPJy1GVhAhs8a58AAUb6pVDKR1yYuXv5c6eHz0jwEKHOMD7Q6dTYzwokkUVbOUZ4gB3S911X5Uw==
X-Received: by 2002:a17:906:7b88:: with SMTP id s8mr20851651ejo.525.1622507613734;
        Mon, 31 May 2021 17:33:33 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g13sm6510521ejr.63.2021.05.31.17.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 17:33:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v2 net-next 2/9] net: pcs: xpcs: there is only one PHY ID
Date:   Tue,  1 Jun 2021 03:33:18 +0300
Message-Id: <20210601003325.1631980-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601003325.1631980-1-olteanv@gmail.com>
References: <20210601003325.1631980-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The xpcs driver has an apparently inadequate structure for the actual
hardware it drives.

These defines and the xpcs_probe() function would suggest that there is
one PHY ID per supported PHY interface type, and the driver simply
validates whether the mode it should operate in (the argument of
xpcs_probe) matches what the hardware is capable of:

	#define SYNOPSYS_XPCS_USXGMII_ID	0x7996ced0
	#define SYNOPSYS_XPCS_10GKR_ID		0x7996ced0
	#define SYNOPSYS_XPCS_XLGMII_ID		0x7996ced0
	#define SYNOPSYS_XPCS_SGMII_ID		0x7996ced0
	#define SYNOPSYS_XPCS_MASK		0xffffffff

but that is not the case, because upon closer inspection, all the above
4 PHY ID definitions are in fact equal.

So it is the same XPCS that is compatible with all 4 sets of PHY
interface types.

This change introduces an array of struct xpcs_compat which is populated
by the single struct xpcs_id instance. It also eliminates the bogus
defines for multiple Synopsys XPCS PHY IDs and replaces them with a
single XPCS_ID, which better reflects the way in which the hardware
operates.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/pcs/pcs-xpcs.c | 103 +++++++++++++++++++++++--------------
 1 file changed, 65 insertions(+), 38 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index aa985a5aae8d..8491cfe1c11d 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -12,10 +12,7 @@
 #include <linux/phylink.h>
 #include <linux/workqueue.h>
 
-#define SYNOPSYS_XPCS_USXGMII_ID	0x7996ced0
-#define SYNOPSYS_XPCS_10GKR_ID		0x7996ced0
-#define SYNOPSYS_XPCS_XLGMII_ID		0x7996ced0
-#define SYNOPSYS_XPCS_SGMII_ID		0x7996ced0
+#define SYNOPSYS_XPCS_ID		0x7996ced0
 #define SYNOPSYS_XPCS_MASK		0xffffffff
 
 /* Vendor regs access */
@@ -163,58 +160,76 @@ static const int xpcs_sgmii_features[] = {
 
 static const phy_interface_t xpcs_usxgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_USXGMII,
-	PHY_INTERFACE_MODE_MAX,
 };
 
 static const phy_interface_t xpcs_10gkr_interfaces[] = {
 	PHY_INTERFACE_MODE_10GKR,
-	PHY_INTERFACE_MODE_MAX,
 };
 
 static const phy_interface_t xpcs_xlgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_XLGMII,
-	PHY_INTERFACE_MODE_MAX,
 };
 
 static const phy_interface_t xpcs_sgmii_interfaces[] = {
 	PHY_INTERFACE_MODE_SGMII,
-	PHY_INTERFACE_MODE_MAX,
 };
 
-static struct xpcs_id {
-	u32 id;
-	u32 mask;
+enum {
+	DW_XPCS_USXGMII,
+	DW_XPCS_10GKR,
+	DW_XPCS_XLGMII,
+	DW_XPCS_SGMII,
+	DW_XPCS_INTERFACE_MAX,
+};
+
+struct xpcs_compat {
 	const int *supported;
 	const phy_interface_t *interface;
+	int num_interfaces;
 	int an_mode;
-} xpcs_id_list[] = {
-	{
-		.id = SYNOPSYS_XPCS_USXGMII_ID,
-		.mask = SYNOPSYS_XPCS_MASK,
+};
+
+static const struct xpcs_compat synopsys_xpcs_compat[DW_XPCS_INTERFACE_MAX] = {
+	[DW_XPCS_USXGMII] = {
 		.supported = xpcs_usxgmii_features,
 		.interface = xpcs_usxgmii_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_usxgmii_interfaces),
 		.an_mode = DW_AN_C73,
-	}, {
-		.id = SYNOPSYS_XPCS_10GKR_ID,
-		.mask = SYNOPSYS_XPCS_MASK,
+	},
+	[DW_XPCS_10GKR] = {
 		.supported = xpcs_10gkr_features,
 		.interface = xpcs_10gkr_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_10gkr_interfaces),
 		.an_mode = DW_AN_C73,
-	}, {
-		.id = SYNOPSYS_XPCS_XLGMII_ID,
-		.mask = SYNOPSYS_XPCS_MASK,
+	},
+	[DW_XPCS_XLGMII] = {
 		.supported = xpcs_xlgmii_features,
 		.interface = xpcs_xlgmii_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_xlgmii_interfaces),
 		.an_mode = DW_AN_C73,
-	}, {
-		.id = SYNOPSYS_XPCS_SGMII_ID,
-		.mask = SYNOPSYS_XPCS_MASK,
+	},
+	[DW_XPCS_SGMII] = {
 		.supported = xpcs_sgmii_features,
 		.interface = xpcs_sgmii_interfaces,
+		.num_interfaces = ARRAY_SIZE(xpcs_sgmii_interfaces),
 		.an_mode = DW_AN_C37_SGMII,
 	},
 };
 
+struct xpcs_id {
+	u32 id;
+	u32 mask;
+	const struct xpcs_compat *compat;
+};
+
+static const struct xpcs_id xpcs_id_list[] = {
+	{
+		.id = SYNOPSYS_XPCS_ID,
+		.mask = SYNOPSYS_XPCS_MASK,
+		.compat = synopsys_xpcs_compat,
+	},
+};
+
 static int xpcs_read(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
 {
 	u32 reg_addr = MII_ADDR_C45 | dev << 16 | reg;
@@ -911,35 +926,47 @@ static u32 xpcs_get_id(struct mdio_xpcs_args *xpcs)
 }
 
 static bool xpcs_check_features(struct mdio_xpcs_args *xpcs,
-				struct xpcs_id *match,
+				const struct xpcs_id *match,
 				phy_interface_t interface)
 {
-	int i;
+	int i, j;
 
-	for (i = 0; match->interface[i] != PHY_INTERFACE_MODE_MAX; i++) {
-		if (match->interface[i] == interface)
-			break;
-	}
+	for (i = 0; i < DW_XPCS_INTERFACE_MAX; i++) {
+		const struct xpcs_compat *compat = &match->compat[i];
+		bool supports_interface = false;
 
-	if (match->interface[i] == PHY_INTERFACE_MODE_MAX)
-		return false;
+		for (j = 0; j < compat->num_interfaces; j++) {
+			if (compat->interface[j] == interface) {
+				supports_interface = true;
+				break;
+			}
+		}
 
-	for (i = 0; match->supported[i] != __ETHTOOL_LINK_MODE_MASK_NBITS; i++)
-		set_bit(match->supported[i], xpcs->supported);
+		if (!supports_interface)
+			continue;
+
+		/* Populate the supported link modes for this
+		 * PHY interface type
+		 */
+		for (j = 0; compat->supported[j] != __ETHTOOL_LINK_MODE_MASK_NBITS; j++)
+			set_bit(compat->supported[j], xpcs->supported);
 
-	xpcs->an_mode = match->an_mode;
+		xpcs->an_mode = compat->an_mode;
+
+		return true;
+	}
 
-	return true;
+	return false;
 }
 
 static int xpcs_probe(struct mdio_xpcs_args *xpcs, phy_interface_t interface)
 {
+	const struct xpcs_id *match = NULL;
 	u32 xpcs_id = xpcs_get_id(xpcs);
-	struct xpcs_id *match = NULL;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(xpcs_id_list); i++) {
-		struct xpcs_id *entry = &xpcs_id_list[i];
+		const struct xpcs_id *entry = &xpcs_id_list[i];
 
 		if ((xpcs_id & entry->mask) == entry->id) {
 			match = entry;
-- 
2.25.1

