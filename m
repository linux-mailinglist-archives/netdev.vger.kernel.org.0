Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A1225FF27
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 18:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730585AbgIGQ2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 12:28:08 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:55838 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729907AbgIGOcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 10:32:53 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 087EW19q113953;
        Mon, 7 Sep 2020 09:32:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599489121;
        bh=MrJ8oniUAvkpJjFUq2IygbIoO9wyGKNWBqzzRnaJdfQ=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=uTk/+NJ2x0OKWkJuUuziM8OUrVHTH2oIuF2/o06X6MLgm0OM6BR9XoRWvx3paa1up
         P63yF8MMJN1LPUkAj5YI1aZy0+EC14Xrx2hYeQ2fOosFwZ9SEAaJPryhcjq9tpmP9t
         tn6Q/xajwjj8T99Ro9C2Y2PR+n1TXhaUr4yoU5Ww=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 087EW1pY066922
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 7 Sep 2020 09:32:01 -0500
Received: from DLEE109.ent.ti.com (157.170.170.41) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 7 Sep
 2020 09:32:00 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 7 Sep 2020 09:32:00 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 087EW08r106572;
        Mon, 7 Sep 2020 09:32:00 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v2 9/9] net: ethernet: ti: ale: add support for multi port k3 cpsw versions
Date:   Mon, 7 Sep 2020 17:31:43 +0300
Message-ID: <20200907143143.13735-10-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200907143143.13735-1-grygorii.strashko@ti.com>
References: <20200907143143.13735-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TI J721E (CPSW9g) ALE version is similar, in general, to Sitara AM3/4/5
CPSW ALE, but has more extended functions and different ALE VLAN entry
format.

This patch adds support for for multi port TI J721E (CPSW9g) ALE variant.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 0dd0c3329dee..a6a455c32628 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -191,6 +191,14 @@ static const struct ale_entry_fld vlan_entry_nu[ALE_ENT_VID_LAST] = {
 	ALE_ENTRY_FLD(ALE_ENT_VID_REG_MCAST_IDX, 44, 3),
 };
 
+/* K3 j721e/j7200 cpsw9g/5g, am64x cpsw3g  */
+static const struct ale_entry_fld vlan_entry_k3_cpswxg[] = {
+	ALE_ENTRY_FLD_DYN_MSK_SIZE(ALE_ENT_VID_MEMBER_LIST, 0),
+	ALE_ENTRY_FLD_DYN_MSK_SIZE(ALE_ENT_VID_UNREG_MCAST_MSK, 12),
+	ALE_ENTRY_FLD_DYN_MSK_SIZE(ALE_ENT_VID_FORCE_UNTAGGED_MSK, 24),
+	ALE_ENTRY_FLD_DYN_MSK_SIZE(ALE_ENT_VID_REG_MCAST_MSK, 36),
+};
+
 DEFINE_ALE_FIELD(entry_type,		60,	2)
 DEFINE_ALE_FIELD(vlan_id,		48,	12)
 DEFINE_ALE_FIELD(mcast_state,		62,	2)
@@ -1213,6 +1221,12 @@ static const struct cpsw_ale_dev_id cpsw_ale_id_match[] = {
 		.nu_switch_ale = true,
 		.vlan_entry_tbl = vlan_entry_nu,
 	},
+	{
+		.dev_id = "j721e-cpswxg",
+		.features = CPSW_ALE_F_STATUS_REG | CPSW_ALE_F_HW_AUTOAGING,
+		.major_ver_mask = 0x7,
+		.vlan_entry_tbl = vlan_entry_k3_cpswxg,
+	},
 	{ },
 };
 
-- 
2.17.1

