Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBE425E406
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 01:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgIDXKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 19:10:36 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:51184 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728397AbgIDXKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 19:10:32 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 084NASSj127266;
        Fri, 4 Sep 2020 18:10:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599261028;
        bh=JUdzrdT3ahPoMTStJWGq/vLlrwMrpZOuxc9XcQOO+l0=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=P/s/EL1GRAOyAL0ENWRlWi+/V6j8OXKz2i6xK2t5XsMClGVMJs47/kgDVdZMaP5Dy
         yNa2uGiEf+OXQrauEbkYUzVjqJLLFN3PJwCzGsnhOnHD+PzX5VkCfelJ0V/PZIAMNU
         2PV8/ZhlRdjMQukdGmx4ku6gAKBvjeipUzMWcLrc=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 084NASg7091551
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 4 Sep 2020 18:10:28 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 4 Sep
 2020 18:10:28 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 4 Sep 2020 18:10:27 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 084NARSm006860;
        Fri, 4 Sep 2020 18:10:27 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Murali Karicheri <m-karicheri2@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 8/9] net: ethernet: ti: ale: switch to use tables for vlan entry description
Date:   Sat, 5 Sep 2020 02:09:23 +0300
Message-ID: <20200904230924.9971-9-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904230924.9971-1-grygorii.strashko@ti.com>
References: <20200904230924.9971-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ALE VLAN entries are too much differ between different TI CPSW ALE
versions. So, handling them using flags, defines and get/set functions
became over-complicated.

This patch introduces tables to describe the ALE VLAN entries fields, which
are different between TI CPSW ALE versions, and new get/set access
functions. It also allows to detect incorrect access to not available ALL
entry fields.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 239 ++++++++++++++++++++++-------
 drivers/net/ethernet/ti/cpsw_ale.h |   3 +
 2 files changed, 188 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 7b54e9911b1e..7ca46936a36c 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -50,6 +50,18 @@
 /* ALE_AGING_TIMER */
 #define ALE_AGING_TIMER_MASK	GENMASK(23, 0)
 
+/**
+ * struct ale_entry_fld - The ALE tbl entry field description
+ * @start_bit: field start bit
+ * @u8 num_bits: field bit length
+ * @flags: field flags
+ */
+struct ale_entry_fld {
+	u8 start_bit;
+	u8 num_bits;
+	u8 flags;
+};
+
 enum {
 	CPSW_ALE_F_STATUS_REG = BIT(0), /* Status register present */
 	CPSW_ALE_F_HW_AUTOAGING = BIT(1), /* HW auto aging */
@@ -64,6 +76,7 @@ enum {
  * @tbl_entries: number of ALE entries
  * @major_ver_mask: mask of ALE Major Version Value in ALE_IDVER reg.
  * @nu_switch_ale: NU Switch ALE
+ * @vlan_entry_tbl: ALE vlan entry fields description tbl
  */
 struct cpsw_ale_dev_id {
 	const char *dev_id;
@@ -71,6 +84,7 @@ struct cpsw_ale_dev_id {
 	u32 tbl_entries;
 	u32 major_ver_mask;
 	bool nu_switch_ale;
+	const struct ale_entry_fld *vlan_entry_tbl;
 };
 
 #define ALE_TABLE_WRITE		BIT(31)
@@ -132,6 +146,51 @@ static inline void cpsw_ale_set_##name(u32 *ale_entry, u32 value,	\
 	cpsw_ale_set_field(ale_entry, start, bits, value);		\
 }
 
+enum {
+	ALE_ENT_VID_MEMBER_LIST = 0,
+	ALE_ENT_VID_UNREG_MCAST_MSK,
+	ALE_ENT_VID_REG_MCAST_MSK,
+	ALE_ENT_VID_FORCE_UNTAGGED_MSK,
+	ALE_ENT_VID_UNREG_MCAST_IDX,
+	ALE_ENT_VID_REG_MCAST_IDX,
+	ALE_ENT_VID_LAST,
+};
+
+#define ALE_FLD_ALLOWED			BIT(0)
+#define ALE_FLD_SIZE_PORT_MASK_BITS	BIT(1)
+#define ALE_FLD_SIZE_PORT_NUM_BITS	BIT(2)
+
+#define ALE_ENTRY_FLD(id, start, bits)	\
+[id] = {				\
+	.start_bit = start,		\
+	.num_bits = bits,		\
+	.flags = ALE_FLD_ALLOWED,	\
+}
+
+#define ALE_ENTRY_FLD_DYN_MSK_SIZE(id, start)	\
+[id] = {					\
+	.start_bit = start,			\
+	.num_bits = 0,				\
+	.flags = ALE_FLD_ALLOWED |		\
+		 ALE_FLD_SIZE_PORT_MASK_BITS,	\
+}
+
+/* dm814x, am3/am4/am5, k2hk */
+const struct ale_entry_fld vlan_entry_cpsw[ALE_ENT_VID_LAST] = {
+	ALE_ENTRY_FLD(ALE_ENT_VID_MEMBER_LIST, 0, 3),
+	ALE_ENTRY_FLD(ALE_ENT_VID_UNREG_MCAST_MSK, 8, 3),
+	ALE_ENTRY_FLD(ALE_ENT_VID_REG_MCAST_MSK, 16, 3),
+	ALE_ENTRY_FLD(ALE_ENT_VID_FORCE_UNTAGGED_MSK, 24, 3),
+};
+
+/* k2e/k2l, k3 am65/j721e cpsw2g  */
+const struct ale_entry_fld vlan_entry_nu[ALE_ENT_VID_LAST] = {
+	ALE_ENTRY_FLD_DYN_MSK_SIZE(ALE_ENT_VID_MEMBER_LIST, 0),
+	ALE_ENTRY_FLD(ALE_ENT_VID_UNREG_MCAST_IDX, 20, 3),
+	ALE_ENTRY_FLD_DYN_MSK_SIZE(ALE_ENT_VID_FORCE_UNTAGGED_MSK, 24),
+	ALE_ENTRY_FLD(ALE_ENT_VID_REG_MCAST_IDX, 44, 3),
+};
+
 DEFINE_ALE_FIELD(entry_type,		60,	2)
 DEFINE_ALE_FIELD(vlan_id,		48,	12)
 DEFINE_ALE_FIELD(mcast_state,		62,	2)
@@ -141,17 +200,76 @@ DEFINE_ALE_FIELD(ucast_type,		62,     2)
 DEFINE_ALE_FIELD1(port_num,		66)
 DEFINE_ALE_FIELD(blocked,		65,     1)
 DEFINE_ALE_FIELD(secure,		64,     1)
-DEFINE_ALE_FIELD1(vlan_untag_force,	24)
-DEFINE_ALE_FIELD1(vlan_reg_mcast,	16)
-DEFINE_ALE_FIELD1(vlan_unreg_mcast,	8)
-DEFINE_ALE_FIELD1(vlan_member_list,	0)
 DEFINE_ALE_FIELD(mcast,			40,	1)
-/* ALE NetCP nu switch specific */
-DEFINE_ALE_FIELD(vlan_unreg_mcast_idx,	20,	3)
-DEFINE_ALE_FIELD(vlan_reg_mcast_idx,	44,	3)
 
 #define NU_VLAN_UNREG_MCAST_IDX	1
 
+static int cpsw_ale_entry_get_fld(struct cpsw_ale *ale,
+				  u32 *ale_entry,
+				  const struct ale_entry_fld *entry_tbl,
+				  int fld_id)
+{
+	const struct ale_entry_fld *entry_fld;
+	u32 bits;
+
+	if (!ale || !ale_entry)
+		return -EINVAL;
+
+	entry_fld = &entry_tbl[fld_id];
+	if (!(entry_fld->flags & ALE_FLD_ALLOWED)) {
+		dev_err(ale->params.dev, "get: wrong ale fld id %d\n", fld_id);
+		return -ENOENT;
+	}
+
+	bits = entry_fld->num_bits;
+	if (entry_fld->flags & ALE_FLD_SIZE_PORT_MASK_BITS)
+		bits = ale->port_mask_bits;
+
+	return cpsw_ale_get_field(ale_entry, entry_fld->start_bit, bits);
+}
+
+static void cpsw_ale_entry_set_fld(struct cpsw_ale *ale,
+				   u32 *ale_entry,
+				   const struct ale_entry_fld *entry_tbl,
+				   int fld_id,
+				   u32 value)
+{
+	const struct ale_entry_fld *entry_fld;
+	u32 bits;
+
+	if (!ale || !ale_entry)
+		return;
+
+	entry_fld = &entry_tbl[fld_id];
+	if (!(entry_fld->flags & ALE_FLD_ALLOWED)) {
+		dev_err(ale->params.dev, "set: wrong ale fld id %d\n", fld_id);
+		return;
+	}
+
+	bits = entry_fld->num_bits;
+	if (entry_fld->flags & ALE_FLD_SIZE_PORT_MASK_BITS)
+		bits = ale->port_mask_bits;
+
+	cpsw_ale_set_field(ale_entry, entry_fld->start_bit, bits, value);
+}
+
+static int cpsw_ale_vlan_get_fld(struct cpsw_ale *ale,
+				 u32 *ale_entry,
+				 int fld_id)
+{
+	return cpsw_ale_entry_get_fld(ale, ale_entry,
+				      ale->vlan_entry_tbl, fld_id);
+}
+
+static void cpsw_ale_vlan_set_fld(struct cpsw_ale *ale,
+				  u32 *ale_entry,
+				  int fld_id,
+				  u32 value)
+{
+	cpsw_ale_entry_set_fld(ale, ale_entry,
+			       ale->vlan_entry_tbl, fld_id, value);
+}
+
 /* The MAC address field in the ALE entry cannot be macroized as above */
 static inline void cpsw_ale_get_addr(u32 *ale_entry, u8 *addr)
 {
@@ -446,19 +564,22 @@ static void cpsw_ale_set_vlan_mcast(struct cpsw_ale *ale, u32 *ale_entry,
 	int idx;
 
 	/* Set VLAN registered multicast flood mask */
-	idx = cpsw_ale_get_vlan_reg_mcast_idx(ale_entry);
+	idx = cpsw_ale_vlan_get_fld(ale, ale_entry,
+				    ALE_ENT_VID_REG_MCAST_IDX);
 	writel(reg_mcast, ale->params.ale_regs + ALE_VLAN_MASK_MUX(idx));
 
 	/* Set VLAN unregistered multicast flood mask */
-	idx = cpsw_ale_get_vlan_unreg_mcast_idx(ale_entry);
+	idx = cpsw_ale_vlan_get_fld(ale, ale_entry,
+				    ALE_ENT_VID_UNREG_MCAST_IDX);
 	writel(unreg_mcast, ale->params.ale_regs + ALE_VLAN_MASK_MUX(idx));
 }
 
 static void cpsw_ale_set_vlan_untag(struct cpsw_ale *ale, u32 *ale_entry,
 				    u16 vid, int untag_mask)
 {
-	cpsw_ale_set_vlan_untag_force(ale_entry,
-				      untag_mask, ale->vlan_field_bits);
+	cpsw_ale_vlan_set_fld(ale, ale_entry,
+			      ALE_ENT_VID_FORCE_UNTAGGED_MSK,
+			      untag_mask);
 	if (untag_mask & ALE_PORT_HOST)
 		bitmap_set(ale->p0_untag_vid_mask, vid, 1);
 	else
@@ -480,17 +601,19 @@ int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port_mask, int untag,
 	cpsw_ale_set_vlan_untag(ale, ale_entry, vid, untag);
 
 	if (!ale->params.nu_switch_ale) {
-		cpsw_ale_set_vlan_reg_mcast(ale_entry, reg_mcast,
-					    ale->vlan_field_bits);
-		cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_mcast,
-					      ale->vlan_field_bits);
+		cpsw_ale_vlan_set_fld(ale, ale_entry,
+				      ALE_ENT_VID_REG_MCAST_MSK, reg_mcast);
+		cpsw_ale_vlan_set_fld(ale, ale_entry,
+				      ALE_ENT_VID_UNREG_MCAST_MSK, unreg_mcast);
 	} else {
-		cpsw_ale_set_vlan_unreg_mcast_idx(ale_entry,
-						  NU_VLAN_UNREG_MCAST_IDX);
+		cpsw_ale_vlan_set_fld(ale, ale_entry,
+				      ALE_ENT_VID_UNREG_MCAST_IDX,
+				      NU_VLAN_UNREG_MCAST_IDX);
 		cpsw_ale_set_vlan_mcast(ale, ale_entry, reg_mcast, unreg_mcast);
 	}
-	cpsw_ale_set_vlan_member_list(ale_entry, port_mask,
-				      ale->vlan_field_bits);
+
+	cpsw_ale_vlan_set_fld(ale, ale_entry,
+			      ALE_ENT_VID_MEMBER_LIST, port_mask);
 
 	if (idx < 0)
 		idx = cpsw_ale_match_free(ale);
@@ -509,20 +632,20 @@ static void cpsw_ale_del_vlan_modify(struct cpsw_ale *ale, u32 *ale_entry,
 	int reg_mcast, unreg_mcast;
 	int members, untag;
 
-	members = cpsw_ale_get_vlan_member_list(ale_entry,
-						ale->vlan_field_bits);
+	members = cpsw_ale_vlan_get_fld(ale, ale_entry,
+					ALE_ENT_VID_MEMBER_LIST);
 	members &= ~port_mask;
 	if (!members) {
 		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
 		return;
 	}
 
-	untag = cpsw_ale_get_vlan_untag_force(ale_entry,
-					      ale->vlan_field_bits);
-	reg_mcast = cpsw_ale_get_vlan_reg_mcast(ale_entry,
-						ale->vlan_field_bits);
-	unreg_mcast = cpsw_ale_get_vlan_unreg_mcast(ale_entry,
-						    ale->vlan_field_bits);
+	untag = cpsw_ale_vlan_get_fld(ale, ale_entry,
+				      ALE_ENT_VID_FORCE_UNTAGGED_MSK);
+	reg_mcast = cpsw_ale_vlan_get_fld(ale, ale_entry,
+					  ALE_ENT_VID_REG_MCAST_MSK);
+	unreg_mcast = cpsw_ale_vlan_get_fld(ale, ale_entry,
+					    ALE_ENT_VID_UNREG_MCAST_MSK);
 	untag &= members;
 	reg_mcast &= members;
 	unreg_mcast &= members;
@@ -530,16 +653,16 @@ static void cpsw_ale_del_vlan_modify(struct cpsw_ale *ale, u32 *ale_entry,
 	cpsw_ale_set_vlan_untag(ale, ale_entry, vid, untag);
 
 	if (!ale->params.nu_switch_ale) {
-		cpsw_ale_set_vlan_reg_mcast(ale_entry, reg_mcast,
-					    ale->vlan_field_bits);
-		cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_mcast,
-					      ale->vlan_field_bits);
+		cpsw_ale_vlan_set_fld(ale, ale_entry,
+				      ALE_ENT_VID_REG_MCAST_MSK, reg_mcast);
+		cpsw_ale_vlan_set_fld(ale, ale_entry,
+				      ALE_ENT_VID_UNREG_MCAST_MSK, unreg_mcast);
 	} else {
 		cpsw_ale_set_vlan_mcast(ale, ale_entry, reg_mcast,
 					unreg_mcast);
 	}
-	cpsw_ale_set_vlan_member_list(ale_entry, members,
-				      ale->vlan_field_bits);
+	cpsw_ale_vlan_set_fld(ale, ale_entry,
+			      ALE_ENT_VID_MEMBER_LIST, members);
 }
 
 int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
@@ -577,15 +700,15 @@ int cpsw_ale_vlan_add_modify(struct cpsw_ale *ale, u16 vid, int port_mask,
 	if (idx >= 0)
 		cpsw_ale_read(ale, idx, ale_entry);
 
-	vlan_members = cpsw_ale_get_vlan_member_list(ale_entry,
-						     ale->vlan_field_bits);
-	reg_mcast_members = cpsw_ale_get_vlan_reg_mcast(ale_entry,
-							ale->vlan_field_bits);
+	vlan_members = cpsw_ale_vlan_get_fld(ale, ale_entry,
+					     ALE_ENT_VID_MEMBER_LIST);
+	reg_mcast_members = cpsw_ale_vlan_get_fld(ale, ale_entry,
+						  ALE_ENT_VID_REG_MCAST_MSK);
 	unreg_mcast_members =
-		cpsw_ale_get_vlan_unreg_mcast(ale_entry,
-					      ale->vlan_field_bits);
-	untag_members = cpsw_ale_get_vlan_untag_force(ale_entry,
-						      ale->vlan_field_bits);
+		cpsw_ale_vlan_get_fld(ale, ale_entry,
+				      ALE_ENT_VID_UNREG_MCAST_MSK);
+	untag_members = cpsw_ale_vlan_get_fld(ale, ale_entry,
+					      ALE_ENT_VID_FORCE_UNTAGGED_MSK);
 
 	vlan_members |= port_mask;
 	untag_members = (untag_members & ~port_mask) | untag_mask;
@@ -618,14 +741,15 @@ void cpsw_ale_set_unreg_mcast(struct cpsw_ale *ale, int unreg_mcast_mask,
 			continue;
 
 		unreg_members =
-			cpsw_ale_get_vlan_unreg_mcast(ale_entry,
-						      ale->vlan_field_bits);
+			cpsw_ale_vlan_get_fld(ale, ale_entry,
+					      ALE_ENT_VID_UNREG_MCAST_MSK);
 		if (add)
 			unreg_members |= unreg_mcast_mask;
 		else
 			unreg_members &= ~unreg_mcast_mask;
-		cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_members,
-					      ale->vlan_field_bits);
+		cpsw_ale_vlan_set_fld(ale, ale_entry,
+				      ALE_ENT_VID_UNREG_MCAST_MSK,
+				      unreg_members);
 		cpsw_ale_write(ale, idx, ale_entry);
 	}
 }
@@ -635,15 +759,15 @@ static void cpsw_ale_vlan_set_unreg_mcast(struct cpsw_ale *ale, u32 *ale_entry,
 {
 	int unreg_mcast;
 
-	unreg_mcast =
-		cpsw_ale_get_vlan_unreg_mcast(ale_entry,
-					      ale->vlan_field_bits);
+	unreg_mcast = cpsw_ale_vlan_get_fld(ale, ale_entry,
+					    ALE_ENT_VID_UNREG_MCAST_MSK);
 	if (allmulti)
 		unreg_mcast |= ALE_PORT_HOST;
 	else
 		unreg_mcast &= ~ALE_PORT_HOST;
-	cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_mcast,
-				      ale->vlan_field_bits);
+
+	cpsw_ale_vlan_set_fld(ale, ale_entry,
+			      ALE_ENT_VID_UNREG_MCAST_MSK, unreg_mcast);
 }
 
 static void
@@ -653,7 +777,8 @@ cpsw_ale_vlan_set_unreg_mcast_idx(struct cpsw_ale *ale, u32 *ale_entry,
 	int unreg_mcast;
 	int idx;
 
-	idx = cpsw_ale_get_vlan_unreg_mcast_idx(ale_entry);
+	idx = cpsw_ale_vlan_get_fld(ale, ale_entry,
+				    ALE_ENT_VID_UNREG_MCAST_IDX);
 
 	unreg_mcast = readl(ale->params.ale_regs + ALE_VLAN_MASK_MUX(idx));
 
@@ -677,9 +802,9 @@ void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti, int port)
 		type = cpsw_ale_get_entry_type(ale_entry);
 		if (type != ALE_TYPE_VLAN)
 			continue;
-		vlan_members =
-			cpsw_ale_get_vlan_member_list(ale_entry,
-						      ale->vlan_field_bits);
+
+		vlan_members = cpsw_ale_vlan_get_fld(ale, ale_entry,
+						     ALE_ENT_VID_MEMBER_LIST);
 
 		if (port != -1 && !(vlan_members & BIT(port)))
 			continue;
@@ -1056,18 +1181,21 @@ static const struct cpsw_ale_dev_id cpsw_ale_id_match[] = {
 		.dev_id = "cpsw",
 		.tbl_entries = 1024,
 		.major_ver_mask = 0xff,
+		.vlan_entry_tbl = vlan_entry_cpsw,
 	},
 	{
 		/* 66ak2h_xgbe */
 		.dev_id = "66ak2h-xgbe",
 		.tbl_entries = 2048,
 		.major_ver_mask = 0xff,
+		.vlan_entry_tbl = vlan_entry_cpsw,
 	},
 	{
 		.dev_id = "66ak2el",
 		.features = CPSW_ALE_F_STATUS_REG,
 		.major_ver_mask = 0x7,
 		.nu_switch_ale = true,
+		.vlan_entry_tbl = vlan_entry_nu,
 	},
 	{
 		.dev_id = "66ak2g",
@@ -1075,6 +1203,7 @@ static const struct cpsw_ale_dev_id cpsw_ale_id_match[] = {
 		.tbl_entries = 64,
 		.major_ver_mask = 0x7,
 		.nu_switch_ale = true,
+		.vlan_entry_tbl = vlan_entry_nu,
 	},
 	{
 		.dev_id = "am65x-cpsw2g",
@@ -1082,6 +1211,7 @@ static const struct cpsw_ale_dev_id cpsw_ale_id_match[] = {
 		.tbl_entries = 64,
 		.major_ver_mask = 0x7,
 		.nu_switch_ale = true,
+		.vlan_entry_tbl = vlan_entry_nu,
 	},
 	{ },
 };
@@ -1129,6 +1259,7 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 	ale->params = *params;
 	ale->ageout = ale->params.ale_ageout * HZ;
 	ale->features = ale_dev_id->features;
+	ale->vlan_entry_tbl = ale_dev_id->vlan_entry_tbl;
 
 	rev = readl_relaxed(ale->params.ale_regs + ALE_IDVER);
 	ale->version =
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 9c6da58183c9..5e4a69662c5f 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -28,6 +28,8 @@ struct cpsw_ale_params {
 	unsigned long		bus_freq;
 };
 
+struct ale_entry_fld;
+
 struct cpsw_ale {
 	struct cpsw_ale_params	params;
 	struct timer_list	timer;
@@ -39,6 +41,7 @@ struct cpsw_ale {
 	u32			port_num_bits;
 	u32			vlan_field_bits;
 	unsigned long		*p0_untag_vid_mask;
+	const struct ale_entry_fld *vlan_entry_tbl;
 };
 
 enum cpsw_ale_control {
-- 
2.17.1

