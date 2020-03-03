Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C87177B6A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 17:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbgCCQBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 11:01:03 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:56276 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729753AbgCCQAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 11:00:55 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 023G0rbT021754;
        Tue, 3 Mar 2020 10:00:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1583251253;
        bh=YfMSLkRxRKJplFUcpQZy4kjKb3RQ87tY18eRNwti45I=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=ShAiFsCUF/kYe7x1cksGs/+5FX8lkZWZBBCXTrB/LRtHzAexJTyvHOSIf49HchdB4
         FuIWspdIVRouJdn6aLyW738m9k4Y933DFQnHG60CkWF2dWU5Ph56fudQW/UPQyWYRM
         dRC/Fb0gigqebzgxgdBXwqpzN2Ga8gmfRQeD+FyU=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 023G0qnJ056564
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 3 Mar 2020 10:00:53 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 3 Mar
 2020 10:00:52 -0600
Received: from localhost.localdomain (10.64.41.19) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 3 Mar 2020 10:00:52 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by localhost.localdomain (8.15.2/8.15.2) with ESMTP id 023G0pwg030261;
        Tue, 3 Mar 2020 10:00:52 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>
CC:     Sekhar Nori <nsekhar@ti.com>, Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [for-next PATCH v2 3/5] phy: ti: gmii-sel: add support for am654x/j721e soc
Date:   Tue, 3 Mar 2020 18:00:27 +0200
Message-ID: <20200303160029.345-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303160029.345-1-grygorii.strashko@ti.com>
References: <20200303160029.345-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TI AM654x/J721E SoCs have the same PHY interface selection mechanism for
CPSWx subsystem as TI SoCs (AM3/4/5/DRA7), but registers and bit-fields
placement is different.

This patch adds corresponding support for TI AM654x/J721E SoCs PHY
interface selection.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/phy/ti/phy-gmii-sel.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/phy/ti/phy-gmii-sel.c b/drivers/phy/ti/phy-gmii-sel.c
index 1c536fc03c83..7edd5c3bc536 100644
--- a/drivers/phy/ti/phy-gmii-sel.c
+++ b/drivers/phy/ti/phy-gmii-sel.c
@@ -170,6 +170,21 @@ struct phy_gmii_sel_soc_data phy_gmii_sel_soc_dm814 = {
 	.regfields = phy_gmii_sel_fields_am33xx,
 };
 
+static const
+struct reg_field phy_gmii_sel_fields_am654[][PHY_GMII_SEL_LAST] = {
+	{
+		[PHY_GMII_SEL_PORT_MODE] = REG_FIELD(0x4040, 0, 1),
+		[PHY_GMII_SEL_RGMII_ID_MODE] = REG_FIELD((~0), 0, 0),
+		[PHY_GMII_SEL_RMII_IO_CLK_EN] = REG_FIELD((~0), 0, 0),
+	},
+};
+
+static const
+struct phy_gmii_sel_soc_data phy_gmii_sel_soc_am654 = {
+	.num_ports = 1,
+	.regfields = phy_gmii_sel_fields_am654,
+};
+
 static const struct of_device_id phy_gmii_sel_id_table[] = {
 	{
 		.compatible	= "ti,am3352-phy-gmii-sel",
@@ -187,6 +202,10 @@ static const struct of_device_id phy_gmii_sel_id_table[] = {
 		.compatible	= "ti,dm814-phy-gmii-sel",
 		.data		= &phy_gmii_sel_soc_dm814,
 	},
+	{
+		.compatible	= "ti,am654-phy-gmii-sel",
+		.data		= &phy_gmii_sel_soc_am654,
+	},
 	{}
 };
 MODULE_DEVICE_TABLE(of, phy_gmii_sel_id_table);
-- 
2.17.1

