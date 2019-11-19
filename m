Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73D46102F2A
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbfKSWTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:19:42 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34580 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727142AbfKSWTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:19:41 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJXPH027136;
        Tue, 19 Nov 2019 16:19:33 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574201973;
        bh=oyphnleb+WfWIso3NKHHlnLrANFVt1MEpsqUVj9/3/g=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=jwKzkpxBFjzPGOjd27s3uQRVuRVeH1zCZs8734h+5IKzGltN30iyjACPqTN3DsDvr
         eGKChytym/qHGa0G51jUGj17Df355GQtNcmlhDrkIKa/98Fxc0C2l0CxfVS1pvOihr
         j/XXWERb9C+AkPPuCCSs+nGOtNVNAnc9LlfXAl8o=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAJMJXFr093131
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 Nov 2019 16:19:33 -0600
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 16:19:32 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 16:19:32 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJVAP084800;
        Tue, 19 Nov 2019 16:19:32 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v7 net-next 03/13] net: ethernet: ti: ale: modify vlan/mdb api for switchdev
Date:   Wed, 20 Nov 2019 00:19:15 +0200
Message-ID: <20191119221925.28426-4-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119221925.28426-1-grygorii.strashko@ti.com>
References: <20191119221925.28426-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilias Apalodimas <ilias.apalodimas@linaro.org>

A following patch introduces switchdev functionality, so modify
ALE engine VLANs/MDBs API:
- cpsw_ale_del_mcast(): update so it will remove only selected ports from
mcast port_mask or delete whole mcast record if !port_mask
- cpsw_ale_del_vlan(): update so it will remove only selected ports from
all VLAN record's masks or delete whole VLAN record if !port_mask
- add cpsw_ale_vlan_add_modify() to add or modify existing VLAN record's
masks
- add cpsw_ale_set_unreg_mcast() for enabling unreg mcast on port VLANs

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 127 ++++++++++++++++++++++++++---
 drivers/net/ethernet/ti/cpsw_ale.h |   6 ++
 2 files changed, 123 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 723f742e6437..929f3d3354e3 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -384,6 +384,7 @@ int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
 		       int flags, u16 vid)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS] = {0, 0, 0};
+	int mcast_members;
 	int idx;
 
 	idx = cpsw_ale_match_addr(ale, addr, (flags & ALE_VLAN) ? vid : 0);
@@ -392,11 +393,15 @@ int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
 
 	cpsw_ale_read(ale, idx, ale_entry);
 
-	if (port_mask)
-		cpsw_ale_set_port_mask(ale_entry, port_mask,
+	if (port_mask) {
+		mcast_members = cpsw_ale_get_port_mask(ale_entry,
+						       ale->port_mask_bits);
+		mcast_members &= ~port_mask;
+		cpsw_ale_set_port_mask(ale_entry, mcast_members,
 				       ale->port_mask_bits);
-	else
+	} else {
 		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
+	}
 
 	cpsw_ale_write(ale, idx, ale_entry);
 	return 0;
@@ -428,7 +433,7 @@ static void cpsw_ale_set_vlan_untag(struct cpsw_ale *ale, u32 *ale_entry,
 		bitmap_clear(ale->p0_untag_vid_mask, vid, 1);
 }
 
-int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port, int untag,
+int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port_mask, int untag,
 		      int reg_mcast, int unreg_mcast)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS] = {0, 0, 0};
@@ -450,7 +455,8 @@ int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port, int untag,
 	} else {
 		cpsw_ale_set_vlan_mcast(ale, ale_entry, reg_mcast, unreg_mcast);
 	}
-	cpsw_ale_set_vlan_member_list(ale_entry, port, ale->vlan_field_bits);
+	cpsw_ale_set_vlan_member_list(ale_entry, port_mask,
+				      ale->vlan_field_bits);
 
 	if (idx < 0)
 		idx = cpsw_ale_match_free(ale);
@@ -463,6 +469,41 @@ int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port, int untag,
 	return 0;
 }
 
+static void cpsw_ale_del_vlan_modify(struct cpsw_ale *ale, u32 *ale_entry,
+				     u16 vid, int port_mask)
+{
+	int reg_mcast, unreg_mcast;
+	int members, untag;
+
+	members = cpsw_ale_get_vlan_member_list(ale_entry,
+						ale->vlan_field_bits);
+	members &= ~port_mask;
+
+	untag = cpsw_ale_get_vlan_untag_force(ale_entry,
+					      ale->vlan_field_bits);
+	reg_mcast = cpsw_ale_get_vlan_reg_mcast(ale_entry,
+						ale->vlan_field_bits);
+	unreg_mcast = cpsw_ale_get_vlan_unreg_mcast(ale_entry,
+						    ale->vlan_field_bits);
+	untag &= members;
+	reg_mcast &= members;
+	unreg_mcast &= members;
+
+	cpsw_ale_set_vlan_untag(ale, ale_entry, vid, untag);
+
+	if (!ale->params.nu_switch_ale) {
+		cpsw_ale_set_vlan_reg_mcast(ale_entry, reg_mcast,
+					    ale->vlan_field_bits);
+		cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_mcast,
+					      ale->vlan_field_bits);
+	} else {
+		cpsw_ale_set_vlan_mcast(ale, ale_entry, reg_mcast,
+					unreg_mcast);
+	}
+	cpsw_ale_set_vlan_member_list(ale_entry, members,
+				      ale->vlan_field_bits);
+}
+
 int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS] = {0, 0, 0};
@@ -473,18 +514,84 @@ int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 		return -ENOENT;
 
 	cpsw_ale_read(ale, idx, ale_entry);
-	cpsw_ale_set_vlan_untag(ale, ale_entry, vid, 0);
 
-	if (port_mask)
-		cpsw_ale_set_vlan_member_list(ale_entry, port_mask,
-					      ale->vlan_field_bits);
-	else
+	if (port_mask) {
+		cpsw_ale_del_vlan_modify(ale, ale_entry, vid, port_mask);
+	} else {
+		cpsw_ale_set_vlan_untag(ale, ale_entry, vid, 0);
 		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
+	}
 
 	cpsw_ale_write(ale, idx, ale_entry);
+
 	return 0;
 }
 
+int cpsw_ale_vlan_add_modify(struct cpsw_ale *ale, u16 vid, int port_mask,
+			     int untag_mask, int reg_mask, int unreg_mask)
+{
+	u32 ale_entry[ALE_ENTRY_WORDS] = {0, 0, 0};
+	int reg_mcast_members, unreg_mcast_members;
+	int vlan_members, untag_members;
+	int idx, ret = 0;
+
+	idx = cpsw_ale_match_vlan(ale, vid);
+	if (idx >= 0)
+		cpsw_ale_read(ale, idx, ale_entry);
+
+	vlan_members = cpsw_ale_get_vlan_member_list(ale_entry,
+						     ale->vlan_field_bits);
+	reg_mcast_members = cpsw_ale_get_vlan_reg_mcast(ale_entry,
+							ale->vlan_field_bits);
+	unreg_mcast_members =
+		cpsw_ale_get_vlan_unreg_mcast(ale_entry,
+					      ale->vlan_field_bits);
+	untag_members = cpsw_ale_get_vlan_untag_force(ale_entry,
+						      ale->vlan_field_bits);
+
+	vlan_members |= port_mask;
+	untag_members = (untag_members & ~port_mask) | untag_mask;
+	reg_mcast_members = (reg_mcast_members & ~port_mask) | reg_mask;
+	unreg_mcast_members = (unreg_mcast_members & ~port_mask) | unreg_mask;
+
+	ret = cpsw_ale_add_vlan(ale, vid, vlan_members, untag_members,
+				reg_mcast_members, unreg_mcast_members);
+	if (ret) {
+		dev_err(ale->params.dev, "Unable to add vlan\n");
+		return ret;
+	}
+	dev_dbg(ale->params.dev, "port mask 0x%x untag 0x%x\n", vlan_members,
+		untag_mask);
+
+	return ret;
+}
+
+void cpsw_ale_set_unreg_mcast(struct cpsw_ale *ale, int unreg_mcast_mask,
+			      bool add)
+{
+	u32 ale_entry[ALE_ENTRY_WORDS];
+	int unreg_members = 0;
+	int type, idx;
+
+	for (idx = 0; idx < ale->params.ale_entries; idx++) {
+		cpsw_ale_read(ale, idx, ale_entry);
+		type = cpsw_ale_get_entry_type(ale_entry);
+		if (type != ALE_TYPE_VLAN)
+			continue;
+
+		unreg_members =
+			cpsw_ale_get_vlan_unreg_mcast(ale_entry,
+						      ale->vlan_field_bits);
+		if (add)
+			unreg_members |= unreg_mcast_mask;
+		else
+			unreg_members &= ~unreg_mcast_mask;
+		cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_members,
+					      ale->vlan_field_bits);
+		cpsw_ale_write(ale, idx, ale_entry);
+	}
+}
+
 void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti, int port)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS];
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 93d6d56d12f4..70d0955c2652 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -120,4 +120,10 @@ static inline int cpsw_ale_get_vlan_p0_untag(struct cpsw_ale *ale, u16 vid)
 {
 	return test_bit(vid, ale->p0_untag_vid_mask);
 }
+
+int cpsw_ale_vlan_add_modify(struct cpsw_ale *ale, u16 vid, int port_mask,
+			     int untag_mask, int reg_mcast, int unreg_mcast);
+void cpsw_ale_set_unreg_mcast(struct cpsw_ale *ale, int unreg_mcast_mask,
+			      bool add);
+
 #endif
-- 
2.17.1

