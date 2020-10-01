Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4039327FDCF
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732220AbgJAKxo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:53:44 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43122 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731990AbgJAKxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:53:35 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 091ArVAF064297;
        Thu, 1 Oct 2020 05:53:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601549611;
        bh=UOsV4hFzLJcmVg5PO1oqNX4CoiVj9cQF3QnIMYWLfo4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=tg1vaO67/+SVG1jJ+Uc7wk6gn8YA15K1Q3TL3ElV3Aw6JFdyRBxtpCTOA+XODdw3c
         oOgNb0OSZqzdGfwzqKUaUVmBZsQhZeOH74W/e+wRaddp8R1CmZMG0SsXAupAEoiuAO
         FSuSXKTOOkGTYxBGVWM7XTKLAnrV1t8PpgIJUX5g=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 091ArVwl130407
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 1 Oct 2020 05:53:31 -0500
Received: from DLEE104.ent.ti.com (157.170.170.34) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 1 Oct
 2020 05:53:31 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 1 Oct 2020 05:53:31 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 091ArTPY001454;
        Thu, 1 Oct 2020 05:53:30 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 4/8] net: ethernet: ti: cpsw_ale: add cpsw_ale_vlan_del_modify()
Date:   Thu, 1 Oct 2020 13:52:54 +0300
Message-ID: <20201001105258.2139-5-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001105258.2139-1-grygorii.strashko@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add/export cpsw_ale_vlan_del_modify() and use it in cpsw_switchdev instead
of generic cpsw_ale_del_vlan() to avoid mixing 8021Q and switchdev VLAN
offload. This is preparation patch equired by follow up changes.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c       | 24 +++++++++++++++++++++---
 drivers/net/ethernet/ti/cpsw_ale.h       |  1 +
 drivers/net/ethernet/ti/cpsw_switchdev.c |  2 +-
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index a6a455c32628..b1cce39eda17 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -634,8 +634,8 @@ int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port_mask, int untag,
 	return 0;
 }
 
-static void cpsw_ale_del_vlan_modify(struct cpsw_ale *ale, u32 *ale_entry,
-				     u16 vid, int port_mask)
+static void cpsw_ale_vlan_del_modify_int(struct cpsw_ale *ale,  u32 *ale_entry,
+					 u16 vid, int port_mask)
 {
 	int reg_mcast, unreg_mcast;
 	int members, untag;
@@ -644,6 +644,7 @@ static void cpsw_ale_del_vlan_modify(struct cpsw_ale *ale, u32 *ale_entry,
 					ALE_ENT_VID_MEMBER_LIST);
 	members &= ~port_mask;
 	if (!members) {
+		cpsw_ale_set_vlan_untag(ale, ale_entry, vid, 0);
 		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
 		return;
 	}
@@ -673,6 +674,23 @@ static void cpsw_ale_del_vlan_modify(struct cpsw_ale *ale, u32 *ale_entry,
 			      ALE_ENT_VID_MEMBER_LIST, members);
 }
 
+int cpsw_ale_vlan_del_modify(struct cpsw_ale *ale, u16 vid, int port_mask)
+{
+	u32 ale_entry[ALE_ENTRY_WORDS] = {0, 0, 0};
+	int idx;
+
+	idx = cpsw_ale_match_vlan(ale, vid);
+	if (idx < 0)
+		return -ENOENT;
+
+	cpsw_ale_read(ale, idx, ale_entry);
+
+	cpsw_ale_vlan_del_modify_int(ale, ale_entry, vid, port_mask);
+	cpsw_ale_write(ale, idx, ale_entry);
+
+	return 0;
+}
+
 int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS] = {0, 0, 0};
@@ -685,7 +703,7 @@ int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 	cpsw_ale_read(ale, idx, ale_entry);
 
 	if (port_mask) {
-		cpsw_ale_del_vlan_modify(ale, ale_entry, vid, port_mask);
+		cpsw_ale_vlan_del_modify_int(ale, ale_entry, vid, port_mask);
 	} else {
 		cpsw_ale_set_vlan_untag(ale, ale_entry, vid, 0);
 		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 5e4a69662c5f..13fe47687fde 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -134,6 +134,7 @@ static inline int cpsw_ale_get_vlan_p0_untag(struct cpsw_ale *ale, u16 vid)
 
 int cpsw_ale_vlan_add_modify(struct cpsw_ale *ale, u16 vid, int port_mask,
 			     int untag_mask, int reg_mcast, int unreg_mcast);
+int cpsw_ale_vlan_del_modify(struct cpsw_ale *ale, u16 vid, int port_mask);
 void cpsw_ale_set_unreg_mcast(struct cpsw_ale *ale, int unreg_mcast_mask,
 			      bool add);
 
diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index 985a929bb957..29747da5c514 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -227,7 +227,7 @@ static int cpsw_port_vlan_del(struct cpsw_priv *priv, u16 vid,
 	else
 		port_mask = BIT(priv->emac_port);
 
-	ret = cpsw_ale_del_vlan(cpsw->ale, vid, port_mask);
+	ret = cpsw_ale_vlan_del_modify(cpsw->ale, vid, port_mask);
 	if (ret != 0)
 		return ret;
 
-- 
2.17.1

