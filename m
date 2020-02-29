Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E099A174762
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 15:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgB2Obd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 09:31:33 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38535 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgB2Obc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 09:31:32 -0500
Received: by mail-wr1-f65.google.com with SMTP id t11so418142wrw.5
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 06:31:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fTnYx0XWn68vKT/xPlP+X3+2BTgcsQyLClwd312IwJ4=;
        b=q6r6NddB80qFJH8QnThiNLdmb1cbXzeDAXwFn5BRuHADTvkyqozhjmtXGf/L4hrri6
         M1V9nYN0s9Jd+9D4fkzqlTEmZ1NBgxJ3ppYbYajJPm0JDKob3+SgocBsmMJjDYXILiIc
         K0BQQVUGpl9ySQQVZ14+pcAG4iO2kaMzLQyhfxmfDqsIWRb1f8xrCvHp/UW8y+3qff/J
         7gwJRO6dKGRxa07oTQxrxGzVIYPjdzVEIp1B0WV/xxSwQoe7nAnhopc1ZbNj58kqnAbX
         +jxCVjcHKcghFHPN+km4Mlz0AbV+yag/kOCD+wx7KHy5hF8UHmJhFyh5+B/to1AZG5MG
         vP/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fTnYx0XWn68vKT/xPlP+X3+2BTgcsQyLClwd312IwJ4=;
        b=TZYCZOTQGuc8qOPS/p+oCsTBtUCWeeGzgmuFmFvEzUa4lHUdArn149v5C5z2QItWTR
         1Zs0OlfkvQmNHo/CWX4Fs3IZ23f+QMyluanIkDvGbRjWISgKeqTm9yxKgkbqPya9G3qf
         KocdqNpclEMzmdykLEXLSgZ+VFg5kO5fcVpBK82ushTEgyyVrZmYTu1R+8BQ8TDWCP4V
         BbXXqbZ0wNSJI+R19Bwb5vSadNOO4KWI4Npj9WdlxS+JoseyLe4Q6d4ugU84Y8v+8Njj
         qqNlnV+0F1+D8W1OCfv5F8L8bcGuaB/0Reger19RpqreL9lxsCXJYa6F0Ojhh43yy0l8
         Cd6g==
X-Gm-Message-State: APjAAAVbFvvgvrp26aR7xCrglJNWsheDR7aPoDWY0vJkxX3YtRSqQDa9
        iKAN2ixSjPGpn3gsqKdG+0svKwDl4r8=
X-Google-Smtp-Source: APXvYqxikVhKITIVO/8wIaqrDKYiU7nVm9sOiw3z9lm2HnenTrm/VGysMarnEZvlsPFsrjJDXduWsg==
X-Received: by 2002:adf:f091:: with SMTP id n17mr10541935wro.387.1582986687446;
        Sat, 29 Feb 2020 06:31:27 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id d7sm7573528wmc.6.2020.02.29.06.31.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 06:31:26 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net
Cc:     horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [PATCH v2 net-next 06/10] net: mscc: ocelot: don't rely on preprocessor for vcap key/action packing
Date:   Sat, 29 Feb 2020 16:31:10 +0200
Message-Id: <20200229143114.10656-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200229143114.10656-1-olteanv@gmail.com>
References: <20200229143114.10656-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The IGR_PORT_MASK key width is different between the 11-port VSC7514 and
the 6-port VSC9959 switches. And since IGR_PORT_MASK is one of the first
fields of a VCAP key entry, it means that all further field
offset/length pairs are shifted between the 2.

The ocelot driver performs packing of VCAP half keys with the help of
some preprocessor macros:

- A set of macros for defining the HKO (Half Key Offset) and HKL (Half
  Key Length) of each possible key field. The offset of each field is
  defined as the sum between the offset and the sum of the previous
  field.

- A set of accessors on top of vcap_key_set for shorter (aka less
  typing) access to the HKO and HKL of each key field.

Since the field offsets and lengths are different between switches,
defining them through the preprocessor isn't going to fly. So introduce
a structure holding (offset, length) pairs and instantiate it in
ocelot_board.c for VSC7514. In a future patch, a similar structure will
be instantiated in felix_vsc9959.c for NXP LS1028A.

The accessors also need to go. They are based on macro name
concatenation, which is horrible to understand and follow.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
Changes in v2:
Added "struct ocelot *ocelot" as argument to all functions that need to
pack VCAP key fields, to avoid passing the ocelot backpointer to struct
vcap_data and cause difficult-to-solve reverse Christmas tree line
ordering issues.

 drivers/net/ethernet/mscc/ocelot_ace.c   | 315 +++++++++++-------
 drivers/net/ethernet/mscc/ocelot_board.c | 102 ++++++
 drivers/net/ethernet/mscc/ocelot_vcap.h  | 403 -----------------------
 include/soc/mscc/ocelot.h                |   3 +
 include/soc/mscc/ocelot_vcap.h           | 184 +++++++++++
 5 files changed, 484 insertions(+), 523 deletions(-)
 delete mode 100644 drivers/net/ethernet/mscc/ocelot_vcap.h
 create mode 100644 include/soc/mscc/ocelot_vcap.h

diff --git a/drivers/net/ethernet/mscc/ocelot_ace.c b/drivers/net/ethernet/mscc/ocelot_ace.c
index ec86d29d8be4..9922033a2aaf 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.c
+++ b/drivers/net/ethernet/mscc/ocelot_ace.c
@@ -6,8 +6,8 @@
 #include <linux/iopoll.h>
 #include <linux/proc_fs.h>
 
+#include <soc/mscc/ocelot_vcap.h>
 #include "ocelot_ace.h"
-#include "ocelot_vcap.h"
 #include "ocelot_s2.h"
 
 #define OCELOT_POLICER_DISCARD 0x17f
@@ -47,7 +47,7 @@ static const struct vcap_props vcap_is2 = {
 	.action_type_width = 1,
 	.action_table = {
 		{
-			.width = (IS2_AO_ACL_ID + IS2_AL_ACL_ID),
+			.width = 49,
 			.count = 2
 		},
 		{
@@ -243,22 +243,39 @@ static u32 vcap_data_get(u32 *data, u32 offset, u32 len)
 	return value;
 }
 
-static void vcap_key_set(struct vcap_data *data, u32 offset, u32 width,
-			 u32 value, u32 mask)
+static void vcap_key_field_set(struct vcap_data *data, u32 offset, u32 width,
+			       u32 value, u32 mask)
 {
 	vcap_data_set(data->entry, offset + data->key_offset, width, value);
 	vcap_data_set(data->mask, offset + data->key_offset, width, mask);
 }
 
-static void vcap_key_bytes_set(struct vcap_data *data, u32 offset, u8 *val,
-			       u8 *msk, u32 count)
+static void vcap_key_set(struct ocelot *ocelot, struct vcap_data *data,
+			 enum vcap_is2_half_key_field field,
+			 u32 value, u32 mask)
+{
+	u32 offset = ocelot->vcap_is2_keys[field].offset;
+	u32 length = ocelot->vcap_is2_keys[field].length;
+
+	vcap_key_field_set(data, offset, length, value, mask);
+}
+
+static void vcap_key_bytes_set(struct ocelot *ocelot, struct vcap_data *data,
+			       enum vcap_is2_half_key_field field,
+			       u8 *val, u8 *msk)
 {
+	u32 offset = ocelot->vcap_is2_keys[field].offset;
+	u32 count  = ocelot->vcap_is2_keys[field].length;
 	u32 i, j, n = 0, value = 0, mask = 0;
 
+	WARN_ON(count % 8);
+
 	/* Data wider than 32 bits are split up in chunks of maximum 32 bits.
 	 * The 32 LSB of the data are written to the 32 MSB of the TCAM.
 	 */
-	offset += (count * 8);
+	offset += count;
+	count /= 8;
+
 	for (i = 0; i < count; i++) {
 		j = (count - i - 1);
 		value += (val[j] << n);
@@ -266,7 +283,7 @@ static void vcap_key_bytes_set(struct vcap_data *data, u32 offset, u8 *val,
 		n += 8;
 		if (n == ENTRY_WIDTH || (i + 1) == count) {
 			offset -= n;
-			vcap_key_set(data, offset, n, value, mask);
+			vcap_key_field_set(data, offset, n, value, mask);
 			n = 0;
 			value = 0;
 			mask = 0;
@@ -274,55 +291,62 @@ static void vcap_key_bytes_set(struct vcap_data *data, u32 offset, u8 *val,
 	}
 }
 
-static void vcap_key_l4_port_set(struct vcap_data *data, u32 offset,
+static void vcap_key_l4_port_set(struct ocelot *ocelot, struct vcap_data *data,
+				 enum vcap_is2_half_key_field field,
 				 struct ocelot_vcap_udp_tcp *port)
 {
-	vcap_key_set(data, offset, 16, port->value, port->mask);
+	u32 offset = ocelot->vcap_is2_keys[field].offset;
+	u32 length = ocelot->vcap_is2_keys[field].length;
+
+	WARN_ON(length != 16);
+
+	vcap_key_field_set(data, offset, length, port->value, port->mask);
 }
 
-static void vcap_key_bit_set(struct vcap_data *data, u32 offset,
+static void vcap_key_bit_set(struct ocelot *ocelot, struct vcap_data *data,
+			     enum vcap_is2_half_key_field field,
 			     enum ocelot_vcap_bit val)
 {
-	vcap_key_set(data, offset, 1, val == OCELOT_VCAP_BIT_1 ? 1 : 0,
-		     val == OCELOT_VCAP_BIT_ANY ? 0 : 1);
-}
+	u32 offset = ocelot->vcap_is2_keys[field].offset;
+	u32 length = ocelot->vcap_is2_keys[field].length;
+	u32 value = (val == OCELOT_VCAP_BIT_1 ? 1 : 0);
+	u32 msk = (val == OCELOT_VCAP_BIT_ANY ? 0 : 1);
 
-#define VCAP_KEY_SET(fld, val, msk) \
-	vcap_key_set(&data, IS2_HKO_##fld, IS2_HKL_##fld, val, msk)
-#define VCAP_KEY_ANY_SET(fld) \
-	vcap_key_set(&data, IS2_HKO_##fld, IS2_HKL_##fld, 0, 0)
-#define VCAP_KEY_BIT_SET(fld, val) vcap_key_bit_set(&data, IS2_HKO_##fld, val)
-#define VCAP_KEY_BYTES_SET(fld, val, msk) \
-	vcap_key_bytes_set(&data, IS2_HKO_##fld, val, msk, IS2_HKL_##fld / 8)
+	WARN_ON(length != 1);
 
-static void vcap_action_set(struct vcap_data *data, u32 offset, u32 width,
-			    u32 value)
-{
-	vcap_data_set(data->action, offset + data->action_offset, width, value);
+	vcap_key_field_set(data, offset, length, value, msk);
 }
 
-#define VCAP_ACT_SET(fld, val) \
-	vcap_action_set(data, IS2_AO_##fld, IS2_AL_##fld, val)
+static void vcap_action_set(struct ocelot *ocelot, struct vcap_data *data,
+			    enum vcap_is2_action_field field, u32 value)
+{
+	int offset = ocelot->vcap_is2_actions[field].offset;
+	int length = ocelot->vcap_is2_actions[field].length;
+
+	vcap_data_set(data->action, offset + data->action_offset, length,
+		      value);
+}
 
-static void is2_action_set(struct vcap_data *data,
+static void is2_action_set(struct ocelot *ocelot, struct vcap_data *data,
 			   enum ocelot_ace_action action)
 {
 	switch (action) {
 	case OCELOT_ACL_ACTION_DROP:
-		VCAP_ACT_SET(PORT_MASK, 0x0);
-		VCAP_ACT_SET(MASK_MODE, 0x1);
-		VCAP_ACT_SET(POLICE_ENA, 0x1);
-		VCAP_ACT_SET(POLICE_IDX, OCELOT_POLICER_DISCARD);
-		VCAP_ACT_SET(CPU_QU_NUM, 0x0);
-		VCAP_ACT_SET(CPU_COPY_ENA, 0x0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 1);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 1);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_IDX,
+				OCELOT_POLICER_DISCARD);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 0);
 		break;
 	case OCELOT_ACL_ACTION_TRAP:
-		VCAP_ACT_SET(PORT_MASK, 0x0);
-		VCAP_ACT_SET(MASK_MODE, 0x1);
-		VCAP_ACT_SET(POLICE_ENA, 0x0);
-		VCAP_ACT_SET(POLICE_IDX, 0x0);
-		VCAP_ACT_SET(CPU_QU_NUM, 0x0);
-		VCAP_ACT_SET(CPU_COPY_ENA, 0x1);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_PORT_MASK, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_MASK_MODE, 1);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_ENA, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_POLICE_IDX, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_QU_NUM, 0);
+		vcap_action_set(ocelot, data, VCAP_IS2_ACT_CPU_COPY_ENA, 1);
 		break;
 	}
 }
@@ -352,53 +376,69 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 
 	data.type = IS2_ACTION_TYPE_NORMAL;
 
-	VCAP_KEY_ANY_SET(PAG);
-	VCAP_KEY_SET(IGR_PORT_MASK, 0, ~ace->ingress_port_mask);
-	VCAP_KEY_BIT_SET(FIRST, OCELOT_VCAP_BIT_1);
-	VCAP_KEY_BIT_SET(HOST_MATCH, OCELOT_VCAP_BIT_ANY);
-	VCAP_KEY_BIT_SET(L2_MC, ace->dmac_mc);
-	VCAP_KEY_BIT_SET(L2_BC, ace->dmac_bc);
-	VCAP_KEY_BIT_SET(VLAN_TAGGED, tag->tagged);
-	VCAP_KEY_SET(VID, tag->vid.value, tag->vid.mask);
-	VCAP_KEY_SET(PCP, tag->pcp.value[0], tag->pcp.mask[0]);
-	VCAP_KEY_BIT_SET(DEI, tag->dei);
+	vcap_key_set(ocelot, &data, VCAP_IS2_HK_PAG, 0, 0);
+	vcap_key_set(ocelot, &data, VCAP_IS2_HK_IGR_PORT_MASK, 0,
+		     ~ace->ingress_port_mask);
+	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_FIRST, OCELOT_VCAP_BIT_1);
+	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_HOST_MATCH,
+			 OCELOT_VCAP_BIT_ANY);
+	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L2_MC, ace->dmac_mc);
+	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L2_BC, ace->dmac_bc);
+	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_VLAN_TAGGED, tag->tagged);
+	vcap_key_set(ocelot, &data, VCAP_IS2_HK_VID,
+		     tag->vid.value, tag->vid.mask);
+	vcap_key_set(ocelot, &data, VCAP_IS2_HK_PCP,
+		     tag->pcp.value[0], tag->pcp.mask[0]);
+	vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_DEI, tag->dei);
 
 	switch (ace->type) {
 	case OCELOT_ACE_TYPE_ETYPE: {
 		struct ocelot_ace_frame_etype *etype = &ace->frame.etype;
 
 		type = IS2_TYPE_ETYPE;
-		VCAP_KEY_BYTES_SET(L2_DMAC, etype->dmac.value,
-				   etype->dmac.mask);
-		VCAP_KEY_BYTES_SET(L2_SMAC, etype->smac.value,
-				   etype->smac.mask);
-		VCAP_KEY_BYTES_SET(MAC_ETYPE_ETYPE, etype->etype.value,
-				   etype->etype.mask);
-		VCAP_KEY_ANY_SET(MAC_ETYPE_L2_PAYLOAD); // Clear unused bits
-		vcap_key_bytes_set(&data, IS2_HKO_MAC_ETYPE_L2_PAYLOAD,
-				   etype->data.value, etype->data.mask, 2);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_DMAC,
+				   etype->dmac.value, etype->dmac.mask);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_SMAC,
+				   etype->smac.value, etype->smac.mask);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_MAC_ETYPE_ETYPE,
+				   etype->etype.value, etype->etype.mask);
+		/* Clear unused bits */
+		vcap_key_set(ocelot, &data, VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0,
+			     0, 0);
+		vcap_key_set(ocelot, &data, VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1,
+			     0, 0);
+		vcap_key_set(ocelot, &data, VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2,
+			     0, 0);
+		vcap_key_bytes_set(ocelot, &data,
+				   VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0,
+				   etype->data.value, etype->data.mask);
 		break;
 	}
 	case OCELOT_ACE_TYPE_LLC: {
 		struct ocelot_ace_frame_llc *llc = &ace->frame.llc;
 
 		type = IS2_TYPE_LLC;
-		VCAP_KEY_BYTES_SET(L2_DMAC, llc->dmac.value, llc->dmac.mask);
-		VCAP_KEY_BYTES_SET(L2_SMAC, llc->smac.value, llc->smac.mask);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_DMAC,
+				   llc->dmac.value, llc->dmac.mask);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_SMAC,
+				   llc->smac.value, llc->smac.mask);
 		for (i = 0; i < 4; i++) {
 			payload.value[i] = llc->llc.value[i];
 			payload.mask[i] = llc->llc.mask[i];
 		}
-		VCAP_KEY_BYTES_SET(MAC_LLC_L2_LLC, payload.value, payload.mask);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_MAC_LLC_L2_LLC,
+				   payload.value, payload.mask);
 		break;
 	}
 	case OCELOT_ACE_TYPE_SNAP: {
 		struct ocelot_ace_frame_snap *snap = &ace->frame.snap;
 
 		type = IS2_TYPE_SNAP;
-		VCAP_KEY_BYTES_SET(L2_DMAC, snap->dmac.value, snap->dmac.mask);
-		VCAP_KEY_BYTES_SET(L2_SMAC, snap->smac.value, snap->smac.mask);
-		VCAP_KEY_BYTES_SET(MAC_SNAP_L2_SNAP,
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_DMAC,
+				   snap->dmac.value, snap->dmac.mask);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L2_SMAC,
+				   snap->smac.value, snap->smac.mask);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_MAC_SNAP_L2_SNAP,
 				   ace->frame.snap.snap.value,
 				   ace->frame.snap.snap.mask);
 		break;
@@ -407,26 +447,42 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 		struct ocelot_ace_frame_arp *arp = &ace->frame.arp;
 
 		type = IS2_TYPE_ARP;
-		VCAP_KEY_BYTES_SET(MAC_ARP_L2_SMAC, arp->smac.value,
-				   arp->smac.mask);
-		VCAP_KEY_BIT_SET(MAC_ARP_ARP_ADDR_SPACE_OK, arp->ethernet);
-		VCAP_KEY_BIT_SET(MAC_ARP_ARP_PROTO_SPACE_OK, arp->ip);
-		VCAP_KEY_BIT_SET(MAC_ARP_ARP_LEN_OK, arp->length);
-		VCAP_KEY_BIT_SET(MAC_ARP_ARP_TGT_MATCH, arp->dmac_match);
-		VCAP_KEY_BIT_SET(MAC_ARP_ARP_SENDER_MATCH, arp->smac_match);
-		VCAP_KEY_BIT_SET(MAC_ARP_ARP_OPCODE_UNKNOWN, arp->unknown);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_MAC_ARP_SMAC,
+				   arp->smac.value, arp->smac.mask);
+		vcap_key_bit_set(ocelot, &data,
+				 VCAP_IS2_HK_MAC_ARP_ADDR_SPACE_OK,
+				 arp->ethernet);
+		vcap_key_bit_set(ocelot, &data,
+				 VCAP_IS2_HK_MAC_ARP_PROTO_SPACE_OK,
+				 arp->ip);
+		vcap_key_bit_set(ocelot, &data,
+				 VCAP_IS2_HK_MAC_ARP_LEN_OK,
+				 arp->length);
+		vcap_key_bit_set(ocelot, &data,
+				 VCAP_IS2_HK_MAC_ARP_TARGET_MATCH,
+				 arp->dmac_match);
+		vcap_key_bit_set(ocelot, &data,
+				 VCAP_IS2_HK_MAC_ARP_SENDER_MATCH,
+				 arp->smac_match);
+		vcap_key_bit_set(ocelot, &data,
+				 VCAP_IS2_HK_MAC_ARP_OPCODE_UNKNOWN,
+				 arp->unknown);
 
 		/* OPCODE is inverse, bit 0 is reply flag, bit 1 is RARP flag */
 		val = ((arp->req == OCELOT_VCAP_BIT_0 ? 1 : 0) |
 		       (arp->arp == OCELOT_VCAP_BIT_0 ? 2 : 0));
 		msk = ((arp->req == OCELOT_VCAP_BIT_ANY ? 0 : 1) |
 		       (arp->arp == OCELOT_VCAP_BIT_ANY ? 0 : 2));
-		VCAP_KEY_SET(MAC_ARP_ARP_OPCODE, val, msk);
-		vcap_key_bytes_set(&data, IS2_HKO_MAC_ARP_L3_IP4_DIP,
-				   arp->dip.value.addr, arp->dip.mask.addr, 4);
-		vcap_key_bytes_set(&data, IS2_HKO_MAC_ARP_L3_IP4_SIP,
-				   arp->sip.value.addr, arp->sip.mask.addr, 4);
-		VCAP_KEY_ANY_SET(MAC_ARP_DIP_EQ_SIP);
+		vcap_key_set(ocelot, &data, VCAP_IS2_HK_MAC_ARP_OPCODE,
+			     val, msk);
+		vcap_key_bytes_set(ocelot, &data,
+				   VCAP_IS2_HK_MAC_ARP_L3_IP4_DIP,
+				   arp->dip.value.addr, arp->dip.mask.addr);
+		vcap_key_bytes_set(ocelot, &data,
+				   VCAP_IS2_HK_MAC_ARP_L3_IP4_SIP,
+				   arp->sip.value.addr, arp->sip.mask.addr);
+		vcap_key_set(ocelot, &data, VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP,
+			     0, 0);
 		break;
 	}
 	case OCELOT_ACE_TYPE_IPV4:
@@ -494,18 +550,23 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 			seq_zero = ipv6->seq_zero;
 		}
 
-		VCAP_KEY_BIT_SET(IP4,
+		vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_IP4,
 				 ipv4 ? OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
-		VCAP_KEY_BIT_SET(L3_FRAGMENT, fragment);
-		VCAP_KEY_ANY_SET(L3_FRAG_OFS_GT0);
-		VCAP_KEY_BIT_SET(L3_OPTIONS, options);
-		VCAP_KEY_BIT_SET(L3_TTL_GT0, ttl);
-		VCAP_KEY_BYTES_SET(L3_TOS, ds.value, ds.mask);
-		vcap_key_bytes_set(&data, IS2_HKO_L3_IP4_DIP, dip.value.addr,
-				   dip.mask.addr, 4);
-		vcap_key_bytes_set(&data, IS2_HKO_L3_IP4_SIP, sip.value.addr,
-				   sip.mask.addr, 4);
-		VCAP_KEY_BIT_SET(DIP_EQ_SIP, sip_eq_dip);
+		vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L3_FRAGMENT,
+				 fragment);
+		vcap_key_set(ocelot, &data, VCAP_IS2_HK_L3_FRAG_OFS_GT0, 0, 0);
+		vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L3_OPTIONS,
+				 options);
+		vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_IP4_L3_TTL_GT0,
+				 ttl);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L3_TOS,
+				   ds.value, ds.mask);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L3_IP4_DIP,
+				   dip.value.addr, dip.mask.addr);
+		vcap_key_bytes_set(ocelot, &data, VCAP_IS2_HK_L3_IP4_SIP,
+				   sip.value.addr, sip.mask.addr);
+		vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_DIP_EQ_SIP,
+				 sip_eq_dip);
 		val = proto.value[0];
 		msk = proto.mask[0];
 		type = IS2_TYPE_IP_UDP_TCP;
@@ -513,25 +574,34 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 			/* UDP/TCP protocol match */
 			tcp = (val == 6 ?
 			       OCELOT_VCAP_BIT_1 : OCELOT_VCAP_BIT_0);
-			VCAP_KEY_BIT_SET(IP4_TCP_UDP_TCP, tcp);
-			vcap_key_l4_port_set(&data,
-					     IS2_HKO_IP4_TCP_UDP_L4_DPORT,
-					     dport);
-			vcap_key_l4_port_set(&data,
-					     IS2_HKO_IP4_TCP_UDP_L4_SPORT,
-					     sport);
-			VCAP_KEY_ANY_SET(IP4_TCP_UDP_L4_RNG);
-			VCAP_KEY_BIT_SET(IP4_TCP_UDP_SPORT_EQ_DPORT,
+			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_TCP, tcp);
+			vcap_key_l4_port_set(ocelot, &data,
+					     VCAP_IS2_HK_L4_DPORT, dport);
+			vcap_key_l4_port_set(ocelot, &data,
+					     VCAP_IS2_HK_L4_SPORT, sport);
+			vcap_key_set(ocelot, &data, VCAP_IS2_HK_L4_RNG, 0, 0);
+			vcap_key_bit_set(ocelot, &data,
+					 VCAP_IS2_HK_L4_SPORT_EQ_DPORT,
 					 sport_eq_dport);
-			VCAP_KEY_BIT_SET(IP4_TCP_UDP_SEQUENCE_EQ0, seq_zero);
-			VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_FIN, tcp_fin);
-			VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_SYN, tcp_syn);
-			VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_RST, tcp_rst);
-			VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_PSH, tcp_psh);
-			VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_ACK, tcp_ack);
-			VCAP_KEY_BIT_SET(IP4_TCP_UDP_L4_URG, tcp_urg);
-			VCAP_KEY_ANY_SET(IP4_TCP_UDP_L4_1588_DOM);
-			VCAP_KEY_ANY_SET(IP4_TCP_UDP_L4_1588_VER);
+			vcap_key_bit_set(ocelot, &data,
+					 VCAP_IS2_HK_L4_SEQUENCE_EQ0,
+					 seq_zero);
+			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_FIN,
+					 tcp_fin);
+			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_SYN,
+					 tcp_syn);
+			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_RST,
+					 tcp_rst);
+			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_PSH,
+					 tcp_psh);
+			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_ACK,
+					 tcp_ack);
+			vcap_key_bit_set(ocelot, &data, VCAP_IS2_HK_L4_URG,
+					 tcp_urg);
+			vcap_key_set(ocelot, &data, VCAP_IS2_HK_L4_1588_DOM,
+				     0, 0);
+			vcap_key_set(ocelot, &data, VCAP_IS2_HK_L4_1588_VER,
+				     0, 0);
 		} else {
 			if (msk == 0) {
 				/* Any IP protocol match */
@@ -544,10 +614,12 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 					payload.mask[i] = ip_data->mask[i];
 				}
 			}
-			VCAP_KEY_BYTES_SET(IP4_OTHER_L3_PROTO, proto.value,
-					   proto.mask);
-			VCAP_KEY_BYTES_SET(IP4_OTHER_L3_PAYLOAD, payload.value,
-					   payload.mask);
+			vcap_key_bytes_set(ocelot, &data,
+					   VCAP_IS2_HK_IP4_L3_PROTO,
+					   proto.value, proto.mask);
+			vcap_key_bytes_set(ocelot, &data,
+					   VCAP_IS2_HK_L3_PAYLOAD,
+					   payload.value, payload.mask);
 		}
 		break;
 	}
@@ -556,18 +628,20 @@ static void is2_entry_set(struct ocelot *ocelot, int ix,
 		type = 0;
 		type_mask = 0;
 		count = (vcap_is2.entry_width / 2);
-		for (i = (IS2_HKO_PCP + IS2_HKL_PCP); i < count;
-		     i += ENTRY_WIDTH) {
-			/* Clear entry data */
-			vcap_key_set(&data, i, min(32u, count - i), 0, 0);
+		/* Iterate over the non-common part of the key and
+		 * clear entry data
+		 */
+		for (i = ocelot->vcap_is2_keys[VCAP_IS2_HK_L2_DMAC].offset;
+		     i < count; i += ENTRY_WIDTH) {
+			vcap_key_field_set(&data, i, min(32u, count - i), 0, 0);
 		}
 		break;
 	}
 
-	VCAP_KEY_SET(TYPE, type, type_mask);
-	is2_action_set(&data, ace->action);
-	vcap_data_set(data.counter, data.counter_offset, vcap_is2.counter_width,
-		      ace->stats.pkts);
+	vcap_key_set(ocelot, &data, VCAP_IS2_TYPE, type, type_mask);
+	is2_action_set(ocelot, &data, ace->action);
+	vcap_data_set(data.counter, data.counter_offset,
+		      vcap_is2.counter_width, ace->stats.pkts);
 
 	/* Write row */
 	vcap_entry2cache(ocelot, &data);
@@ -734,6 +808,7 @@ int ocelot_ace_init(struct ocelot *ocelot)
 	struct vcap_data data;
 
 	memset(&data, 0, sizeof(data));
+
 	vcap_entry2cache(ocelot, &data);
 	ocelot_write(ocelot, vcap_is2.entry_count, S2_CORE_MV_CFG);
 	vcap_cmd(ocelot, 0, VCAP_CMD_INITIALIZE, VCAP_SEL_ENTRY);
diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 7c3dae87d505..2f52d2866c9d 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -14,6 +14,7 @@
 #include <linux/skbuff.h>
 #include <net/switchdev.h>
 
+#include <soc/mscc/ocelot_vcap.h>
 #include "ocelot.h"
 
 #define IFH_EXTRACT_BITFIELD64(x, o, w) (((x) >> (o)) & GENMASK_ULL((w) - 1, 0))
@@ -262,6 +263,104 @@ static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 };
 
+static const struct vcap_field vsc7514_vcap_is2_keys[] = {
+	/* Common: 46 bits */
+	[VCAP_IS2_TYPE]				= {  0,   4},
+	[VCAP_IS2_HK_FIRST]			= {  4,   1},
+	[VCAP_IS2_HK_PAG]			= {  5,   8},
+	[VCAP_IS2_HK_IGR_PORT_MASK]		= { 13,  12},
+	[VCAP_IS2_HK_RSV2]			= { 25,   1},
+	[VCAP_IS2_HK_HOST_MATCH]		= { 26,   1},
+	[VCAP_IS2_HK_L2_MC]			= { 27,   1},
+	[VCAP_IS2_HK_L2_BC]			= { 28,   1},
+	[VCAP_IS2_HK_VLAN_TAGGED]		= { 29,   1},
+	[VCAP_IS2_HK_VID]			= { 30,  12},
+	[VCAP_IS2_HK_DEI]			= { 42,   1},
+	[VCAP_IS2_HK_PCP]			= { 43,   3},
+	/* MAC_ETYPE / MAC_LLC / MAC_SNAP / OAM common */
+	[VCAP_IS2_HK_L2_DMAC]			= { 46,  48},
+	[VCAP_IS2_HK_L2_SMAC]			= { 94,  48},
+	/* MAC_ETYPE (TYPE=000) */
+	[VCAP_IS2_HK_MAC_ETYPE_ETYPE]		= {142,  16},
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0]	= {158,  16},
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1]	= {174,   8},
+	[VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2]	= {182,   3},
+	/* MAC_LLC (TYPE=001) */
+	[VCAP_IS2_HK_MAC_LLC_L2_LLC]		= {142,  40},
+	/* MAC_SNAP (TYPE=010) */
+	[VCAP_IS2_HK_MAC_SNAP_L2_SNAP]		= {142,  40},
+	/* MAC_ARP (TYPE=011) */
+	[VCAP_IS2_HK_MAC_ARP_SMAC]		= { 46,  48},
+	[VCAP_IS2_HK_MAC_ARP_ADDR_SPACE_OK]	= { 94,   1},
+	[VCAP_IS2_HK_MAC_ARP_PROTO_SPACE_OK]	= { 95,   1},
+	[VCAP_IS2_HK_MAC_ARP_LEN_OK]		= { 96,   1},
+	[VCAP_IS2_HK_MAC_ARP_TARGET_MATCH]	= { 97,   1},
+	[VCAP_IS2_HK_MAC_ARP_SENDER_MATCH]	= { 98,   1},
+	[VCAP_IS2_HK_MAC_ARP_OPCODE_UNKNOWN]	= { 99,   1},
+	[VCAP_IS2_HK_MAC_ARP_OPCODE]		= {100,   2},
+	[VCAP_IS2_HK_MAC_ARP_L3_IP4_DIP]	= {102,  32},
+	[VCAP_IS2_HK_MAC_ARP_L3_IP4_SIP]	= {134,  32},
+	[VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP]	= {166,   1},
+	/* IP4_TCP_UDP / IP4_OTHER common */
+	[VCAP_IS2_HK_IP4]			= { 46,   1},
+	[VCAP_IS2_HK_L3_FRAGMENT]		= { 47,   1},
+	[VCAP_IS2_HK_L3_FRAG_OFS_GT0]		= { 48,   1},
+	[VCAP_IS2_HK_L3_OPTIONS]		= { 49,   1},
+	[VCAP_IS2_HK_IP4_L3_TTL_GT0]		= { 50,   1},
+	[VCAP_IS2_HK_L3_TOS]			= { 51,   8},
+	[VCAP_IS2_HK_L3_IP4_DIP]		= { 59,  32},
+	[VCAP_IS2_HK_L3_IP4_SIP]		= { 91,  32},
+	[VCAP_IS2_HK_DIP_EQ_SIP]		= {123,   1},
+	/* IP4_TCP_UDP (TYPE=100) */
+	[VCAP_IS2_HK_TCP]			= {124,   1},
+	[VCAP_IS2_HK_L4_SPORT]			= {125,  16},
+	[VCAP_IS2_HK_L4_DPORT]			= {141,  16},
+	[VCAP_IS2_HK_L4_RNG]			= {157,   8},
+	[VCAP_IS2_HK_L4_SPORT_EQ_DPORT]		= {165,   1},
+	[VCAP_IS2_HK_L4_SEQUENCE_EQ0]		= {166,   1},
+	[VCAP_IS2_HK_L4_URG]			= {167,   1},
+	[VCAP_IS2_HK_L4_ACK]			= {168,   1},
+	[VCAP_IS2_HK_L4_PSH]			= {169,   1},
+	[VCAP_IS2_HK_L4_RST]			= {170,   1},
+	[VCAP_IS2_HK_L4_SYN]			= {171,   1},
+	[VCAP_IS2_HK_L4_FIN]			= {172,   1},
+	[VCAP_IS2_HK_L4_1588_DOM]		= {173,   8},
+	[VCAP_IS2_HK_L4_1588_VER]		= {181,   4},
+	/* IP4_OTHER (TYPE=101) */
+	[VCAP_IS2_HK_IP4_L3_PROTO]		= {124,   8},
+	[VCAP_IS2_HK_L3_PAYLOAD]		= {132,  56},
+	/* IP6_STD (TYPE=110) */
+	[VCAP_IS2_HK_IP6_L3_TTL_GT0]		= { 46,   1},
+	[VCAP_IS2_HK_L3_IP6_SIP]		= { 47, 128},
+	[VCAP_IS2_HK_IP6_L3_PROTO]		= {175,   8},
+	/* OAM (TYPE=111) */
+	[VCAP_IS2_HK_OAM_MEL_FLAGS]		= {142,   7},
+	[VCAP_IS2_HK_OAM_VER]			= {149,   5},
+	[VCAP_IS2_HK_OAM_OPCODE]		= {154,   8},
+	[VCAP_IS2_HK_OAM_FLAGS]			= {162,   8},
+	[VCAP_IS2_HK_OAM_MEPID]			= {170,  16},
+	[VCAP_IS2_HK_OAM_CCM_CNTS_EQ0]		= {186,   1},
+	[VCAP_IS2_HK_OAM_IS_Y1731]		= {187,   1},
+};
+
+static const struct vcap_field vsc7514_vcap_is2_actions[] = {
+	[VCAP_IS2_ACT_HIT_ME_ONCE]		= {  0,  1},
+	[VCAP_IS2_ACT_CPU_COPY_ENA]		= {  1,  1},
+	[VCAP_IS2_ACT_CPU_QU_NUM]		= {  2,  3},
+	[VCAP_IS2_ACT_MASK_MODE]		= {  5,  2},
+	[VCAP_IS2_ACT_MIRROR_ENA]		= {  7,  1},
+	[VCAP_IS2_ACT_LRN_DIS]			= {  8,  1},
+	[VCAP_IS2_ACT_POLICE_ENA]		= {  9,  1},
+	[VCAP_IS2_ACT_POLICE_IDX]		= { 10,  9},
+	[VCAP_IS2_ACT_POLICE_VCAP_ONLY]		= { 19,  1},
+	[VCAP_IS2_ACT_PORT_MASK]		= { 20, 11},
+	[VCAP_IS2_ACT_REW_OP]			= { 31,  9},
+	[VCAP_IS2_ACT_SMAC_REPLACE_ENA]		= { 40,  1},
+	[VCAP_IS2_ACT_RSV]			= { 41,  2},
+	[VCAP_IS2_ACT_ACL_ID]			= { 43,  6},
+	[VCAP_IS2_ACT_HIT_CNT]			= { 49, 32},
+};
+
 static int mscc_ocelot_probe(struct platform_device *pdev)
 {
 	struct device_node *np = pdev->dev.of_node;
@@ -362,6 +461,9 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->ports = devm_kcalloc(&pdev->dev, ocelot->num_phys_ports,
 				     sizeof(struct ocelot_port *), GFP_KERNEL);
 
+	ocelot->vcap_is2_keys = vsc7514_vcap_is2_keys;
+	ocelot->vcap_is2_actions = vsc7514_vcap_is2_actions;
+
 	ocelot_init(ocelot);
 	/* No NPI port */
 	ocelot_configure_cpu(ocelot, -1, OCELOT_TAG_PREFIX_NONE,
diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.h b/drivers/net/ethernet/mscc/ocelot_vcap.h
deleted file mode 100644
index e22eac1da783..000000000000
--- a/drivers/net/ethernet/mscc/ocelot_vcap.h
+++ /dev/null
@@ -1,403 +0,0 @@
-/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
- * Microsemi Ocelot Switch driver
- * Copyright (c) 2019 Microsemi Corporation
- */
-
-#ifndef _OCELOT_VCAP_H_
-#define _OCELOT_VCAP_H_
-
-/* =================================================================
- *  VCAP Common
- * =================================================================
- */
-
-/* VCAP Type-Group values */
-#define VCAP_TG_NONE 0 /* Entry is invalid */
-#define VCAP_TG_FULL 1 /* Full entry */
-#define VCAP_TG_HALF 2 /* Half entry */
-#define VCAP_TG_QUARTER 3 /* Quarter entry */
-
-/* =================================================================
- *  VCAP IS2
- * =================================================================
- */
-
-#define VCAP_IS2_CNT 64
-#define VCAP_IS2_ENTRY_WIDTH 376
-#define VCAP_IS2_ACTION_WIDTH 99
-#define VCAP_PORT_CNT 11
-
-/* IS2 half key types */
-#define IS2_TYPE_ETYPE 0
-#define IS2_TYPE_LLC 1
-#define IS2_TYPE_SNAP 2
-#define IS2_TYPE_ARP 3
-#define IS2_TYPE_IP_UDP_TCP 4
-#define IS2_TYPE_IP_OTHER 5
-#define IS2_TYPE_IPV6 6
-#define IS2_TYPE_OAM 7
-#define IS2_TYPE_SMAC_SIP6 8
-#define IS2_TYPE_ANY 100 /* Pseudo type */
-
-/* IS2 half key type mask for matching any IP */
-#define IS2_TYPE_MASK_IP_ANY 0xe
-
-/* IS2 action types */
-#define IS2_ACTION_TYPE_NORMAL 0
-#define IS2_ACTION_TYPE_SMAC_SIP 1
-
-/* IS2 MASK_MODE values */
-#define IS2_ACT_MASK_MODE_NONE 0
-#define IS2_ACT_MASK_MODE_FILTER 1
-#define IS2_ACT_MASK_MODE_POLICY 2
-#define IS2_ACT_MASK_MODE_REDIR 3
-
-/* IS2 REW_OP values */
-#define IS2_ACT_REW_OP_NONE 0
-#define IS2_ACT_REW_OP_PTP_ONE 2
-#define IS2_ACT_REW_OP_PTP_TWO 3
-#define IS2_ACT_REW_OP_SPECIAL 8
-#define IS2_ACT_REW_OP_PTP_ORG 9
-#define IS2_ACT_REW_OP_PTP_ONE_SUB_DELAY_1 (IS2_ACT_REW_OP_PTP_ONE | (1 << 3))
-#define IS2_ACT_REW_OP_PTP_ONE_SUB_DELAY_2 (IS2_ACT_REW_OP_PTP_ONE | (2 << 3))
-#define IS2_ACT_REW_OP_PTP_ONE_ADD_DELAY (IS2_ACT_REW_OP_PTP_ONE | (1 << 5))
-#define IS2_ACT_REW_OP_PTP_ONE_ADD_SUB BIT(7)
-
-#define VCAP_PORT_WIDTH 4
-
-/* IS2 quarter key - SMAC_SIP4 */
-#define IS2_QKO_IGR_PORT 0
-#define IS2_QKL_IGR_PORT VCAP_PORT_WIDTH
-#define IS2_QKO_L2_SMAC (IS2_QKO_IGR_PORT + IS2_QKL_IGR_PORT)
-#define IS2_QKL_L2_SMAC 48
-#define IS2_QKO_L3_IP4_SIP (IS2_QKO_L2_SMAC + IS2_QKL_L2_SMAC)
-#define IS2_QKL_L3_IP4_SIP 32
-
-/* IS2 half key - common */
-#define IS2_HKO_TYPE 0
-#define IS2_HKL_TYPE 4
-#define IS2_HKO_FIRST (IS2_HKO_TYPE + IS2_HKL_TYPE)
-#define IS2_HKL_FIRST 1
-#define IS2_HKO_PAG (IS2_HKO_FIRST + IS2_HKL_FIRST)
-#define IS2_HKL_PAG 8
-#define IS2_HKO_IGR_PORT_MASK (IS2_HKO_PAG + IS2_HKL_PAG)
-#define IS2_HKL_IGR_PORT_MASK (VCAP_PORT_CNT + 1)
-#define IS2_HKO_SERVICE_FRM (IS2_HKO_IGR_PORT_MASK + IS2_HKL_IGR_PORT_MASK)
-#define IS2_HKL_SERVICE_FRM 1
-#define IS2_HKO_HOST_MATCH (IS2_HKO_SERVICE_FRM + IS2_HKL_SERVICE_FRM)
-#define IS2_HKL_HOST_MATCH 1
-#define IS2_HKO_L2_MC (IS2_HKO_HOST_MATCH + IS2_HKL_HOST_MATCH)
-#define IS2_HKL_L2_MC 1
-#define IS2_HKO_L2_BC (IS2_HKO_L2_MC + IS2_HKL_L2_MC)
-#define IS2_HKL_L2_BC 1
-#define IS2_HKO_VLAN_TAGGED (IS2_HKO_L2_BC + IS2_HKL_L2_BC)
-#define IS2_HKL_VLAN_TAGGED 1
-#define IS2_HKO_VID (IS2_HKO_VLAN_TAGGED + IS2_HKL_VLAN_TAGGED)
-#define IS2_HKL_VID 12
-#define IS2_HKO_DEI (IS2_HKO_VID + IS2_HKL_VID)
-#define IS2_HKL_DEI 1
-#define IS2_HKO_PCP (IS2_HKO_DEI + IS2_HKL_DEI)
-#define IS2_HKL_PCP 3
-
-/* IS2 half key - MAC_ETYPE/MAC_LLC/MAC_SNAP/OAM common */
-#define IS2_HKO_L2_DMAC (IS2_HKO_PCP + IS2_HKL_PCP)
-#define IS2_HKL_L2_DMAC 48
-#define IS2_HKO_L2_SMAC (IS2_HKO_L2_DMAC + IS2_HKL_L2_DMAC)
-#define IS2_HKL_L2_SMAC 48
-
-/* IS2 half key - MAC_ETYPE */
-#define IS2_HKO_MAC_ETYPE_ETYPE (IS2_HKO_L2_SMAC + IS2_HKL_L2_SMAC)
-#define IS2_HKL_MAC_ETYPE_ETYPE 16
-#define IS2_HKO_MAC_ETYPE_L2_PAYLOAD                                           \
-	(IS2_HKO_MAC_ETYPE_ETYPE + IS2_HKL_MAC_ETYPE_ETYPE)
-#define IS2_HKL_MAC_ETYPE_L2_PAYLOAD 27
-
-/* IS2 half key - MAC_LLC */
-#define IS2_HKO_MAC_LLC_L2_LLC IS2_HKO_MAC_ETYPE_ETYPE
-#define IS2_HKL_MAC_LLC_L2_LLC 40
-
-/* IS2 half key - MAC_SNAP */
-#define IS2_HKO_MAC_SNAP_L2_SNAP IS2_HKO_MAC_ETYPE_ETYPE
-#define IS2_HKL_MAC_SNAP_L2_SNAP 40
-
-/* IS2 half key - ARP */
-#define IS2_HKO_MAC_ARP_L2_SMAC IS2_HKO_L2_DMAC
-#define IS2_HKL_MAC_ARP_L2_SMAC 48
-#define IS2_HKO_MAC_ARP_ARP_ADDR_SPACE_OK                                      \
-	(IS2_HKO_MAC_ARP_L2_SMAC + IS2_HKL_MAC_ARP_L2_SMAC)
-#define IS2_HKL_MAC_ARP_ARP_ADDR_SPACE_OK 1
-#define IS2_HKO_MAC_ARP_ARP_PROTO_SPACE_OK                                     \
-	(IS2_HKO_MAC_ARP_ARP_ADDR_SPACE_OK + IS2_HKL_MAC_ARP_ARP_ADDR_SPACE_OK)
-#define IS2_HKL_MAC_ARP_ARP_PROTO_SPACE_OK 1
-#define IS2_HKO_MAC_ARP_ARP_LEN_OK                                             \
-	(IS2_HKO_MAC_ARP_ARP_PROTO_SPACE_OK +                                  \
-	 IS2_HKL_MAC_ARP_ARP_PROTO_SPACE_OK)
-#define IS2_HKL_MAC_ARP_ARP_LEN_OK 1
-#define IS2_HKO_MAC_ARP_ARP_TGT_MATCH                                          \
-	(IS2_HKO_MAC_ARP_ARP_LEN_OK + IS2_HKL_MAC_ARP_ARP_LEN_OK)
-#define IS2_HKL_MAC_ARP_ARP_TGT_MATCH 1
-#define IS2_HKO_MAC_ARP_ARP_SENDER_MATCH                                       \
-	(IS2_HKO_MAC_ARP_ARP_TGT_MATCH + IS2_HKL_MAC_ARP_ARP_TGT_MATCH)
-#define IS2_HKL_MAC_ARP_ARP_SENDER_MATCH 1
-#define IS2_HKO_MAC_ARP_ARP_OPCODE_UNKNOWN                                     \
-	(IS2_HKO_MAC_ARP_ARP_SENDER_MATCH + IS2_HKL_MAC_ARP_ARP_SENDER_MATCH)
-#define IS2_HKL_MAC_ARP_ARP_OPCODE_UNKNOWN 1
-#define IS2_HKO_MAC_ARP_ARP_OPCODE                                             \
-	(IS2_HKO_MAC_ARP_ARP_OPCODE_UNKNOWN +                                  \
-	 IS2_HKL_MAC_ARP_ARP_OPCODE_UNKNOWN)
-#define IS2_HKL_MAC_ARP_ARP_OPCODE 2
-#define IS2_HKO_MAC_ARP_L3_IP4_DIP                                             \
-	(IS2_HKO_MAC_ARP_ARP_OPCODE + IS2_HKL_MAC_ARP_ARP_OPCODE)
-#define IS2_HKL_MAC_ARP_L3_IP4_DIP 32
-#define IS2_HKO_MAC_ARP_L3_IP4_SIP                                             \
-	(IS2_HKO_MAC_ARP_L3_IP4_DIP + IS2_HKL_MAC_ARP_L3_IP4_DIP)
-#define IS2_HKL_MAC_ARP_L3_IP4_SIP 32
-#define IS2_HKO_MAC_ARP_DIP_EQ_SIP                                             \
-	(IS2_HKO_MAC_ARP_L3_IP4_SIP + IS2_HKL_MAC_ARP_L3_IP4_SIP)
-#define IS2_HKL_MAC_ARP_DIP_EQ_SIP 1
-
-/* IS2 half key - IP4_TCP_UDP/IP4_OTHER common */
-#define IS2_HKO_IP4 IS2_HKO_L2_DMAC
-#define IS2_HKL_IP4 1
-#define IS2_HKO_L3_FRAGMENT (IS2_HKO_IP4 + IS2_HKL_IP4)
-#define IS2_HKL_L3_FRAGMENT 1
-#define IS2_HKO_L3_FRAG_OFS_GT0 (IS2_HKO_L3_FRAGMENT + IS2_HKL_L3_FRAGMENT)
-#define IS2_HKL_L3_FRAG_OFS_GT0 1
-#define IS2_HKO_L3_OPTIONS (IS2_HKO_L3_FRAG_OFS_GT0 + IS2_HKL_L3_FRAG_OFS_GT0)
-#define IS2_HKL_L3_OPTIONS 1
-#define IS2_HKO_L3_TTL_GT0 (IS2_HKO_L3_OPTIONS + IS2_HKL_L3_OPTIONS)
-#define IS2_HKL_L3_TTL_GT0 1
-#define IS2_HKO_L3_TOS (IS2_HKO_L3_TTL_GT0 + IS2_HKL_L3_TTL_GT0)
-#define IS2_HKL_L3_TOS 8
-#define IS2_HKO_L3_IP4_DIP (IS2_HKO_L3_TOS + IS2_HKL_L3_TOS)
-#define IS2_HKL_L3_IP4_DIP 32
-#define IS2_HKO_L3_IP4_SIP (IS2_HKO_L3_IP4_DIP + IS2_HKL_L3_IP4_DIP)
-#define IS2_HKL_L3_IP4_SIP 32
-#define IS2_HKO_DIP_EQ_SIP (IS2_HKO_L3_IP4_SIP + IS2_HKL_L3_IP4_SIP)
-#define IS2_HKL_DIP_EQ_SIP 1
-
-/* IS2 half key - IP4_TCP_UDP */
-#define IS2_HKO_IP4_TCP_UDP_TCP (IS2_HKO_DIP_EQ_SIP + IS2_HKL_DIP_EQ_SIP)
-#define IS2_HKL_IP4_TCP_UDP_TCP 1
-#define IS2_HKO_IP4_TCP_UDP_L4_DPORT                                           \
-	(IS2_HKO_IP4_TCP_UDP_TCP + IS2_HKL_IP4_TCP_UDP_TCP)
-#define IS2_HKL_IP4_TCP_UDP_L4_DPORT 16
-#define IS2_HKO_IP4_TCP_UDP_L4_SPORT                                           \
-	(IS2_HKO_IP4_TCP_UDP_L4_DPORT + IS2_HKL_IP4_TCP_UDP_L4_DPORT)
-#define IS2_HKL_IP4_TCP_UDP_L4_SPORT 16
-#define IS2_HKO_IP4_TCP_UDP_L4_RNG                                             \
-	(IS2_HKO_IP4_TCP_UDP_L4_SPORT + IS2_HKL_IP4_TCP_UDP_L4_SPORT)
-#define IS2_HKL_IP4_TCP_UDP_L4_RNG 8
-#define IS2_HKO_IP4_TCP_UDP_SPORT_EQ_DPORT                                     \
-	(IS2_HKO_IP4_TCP_UDP_L4_RNG + IS2_HKL_IP4_TCP_UDP_L4_RNG)
-#define IS2_HKL_IP4_TCP_UDP_SPORT_EQ_DPORT 1
-#define IS2_HKO_IP4_TCP_UDP_SEQUENCE_EQ0                                       \
-	(IS2_HKO_IP4_TCP_UDP_SPORT_EQ_DPORT +                                  \
-	 IS2_HKL_IP4_TCP_UDP_SPORT_EQ_DPORT)
-#define IS2_HKL_IP4_TCP_UDP_SEQUENCE_EQ0 1
-#define IS2_HKO_IP4_TCP_UDP_L4_FIN                                             \
-	(IS2_HKO_IP4_TCP_UDP_SEQUENCE_EQ0 + IS2_HKL_IP4_TCP_UDP_SEQUENCE_EQ0)
-#define IS2_HKL_IP4_TCP_UDP_L4_FIN 1
-#define IS2_HKO_IP4_TCP_UDP_L4_SYN                                             \
-	(IS2_HKO_IP4_TCP_UDP_L4_FIN + IS2_HKL_IP4_TCP_UDP_L4_FIN)
-#define IS2_HKL_IP4_TCP_UDP_L4_SYN 1
-#define IS2_HKO_IP4_TCP_UDP_L4_RST                                             \
-	(IS2_HKO_IP4_TCP_UDP_L4_SYN + IS2_HKL_IP4_TCP_UDP_L4_SYN)
-#define IS2_HKL_IP4_TCP_UDP_L4_RST 1
-#define IS2_HKO_IP4_TCP_UDP_L4_PSH                                             \
-	(IS2_HKO_IP4_TCP_UDP_L4_RST + IS2_HKL_IP4_TCP_UDP_L4_RST)
-#define IS2_HKL_IP4_TCP_UDP_L4_PSH 1
-#define IS2_HKO_IP4_TCP_UDP_L4_ACK                                             \
-	(IS2_HKO_IP4_TCP_UDP_L4_PSH + IS2_HKL_IP4_TCP_UDP_L4_PSH)
-#define IS2_HKL_IP4_TCP_UDP_L4_ACK 1
-#define IS2_HKO_IP4_TCP_UDP_L4_URG                                             \
-	(IS2_HKO_IP4_TCP_UDP_L4_ACK + IS2_HKL_IP4_TCP_UDP_L4_ACK)
-#define IS2_HKL_IP4_TCP_UDP_L4_URG 1
-#define IS2_HKO_IP4_TCP_UDP_L4_1588_DOM                                        \
-	(IS2_HKO_IP4_TCP_UDP_L4_URG + IS2_HKL_IP4_TCP_UDP_L4_URG)
-#define IS2_HKL_IP4_TCP_UDP_L4_1588_DOM 8
-#define IS2_HKO_IP4_TCP_UDP_L4_1588_VER                                        \
-	(IS2_HKO_IP4_TCP_UDP_L4_1588_DOM + IS2_HKL_IP4_TCP_UDP_L4_1588_DOM)
-#define IS2_HKL_IP4_TCP_UDP_L4_1588_VER 4
-
-/* IS2 half key - IP4_OTHER */
-#define IS2_HKO_IP4_OTHER_L3_PROTO IS2_HKO_IP4_TCP_UDP_TCP
-#define IS2_HKL_IP4_OTHER_L3_PROTO 8
-#define IS2_HKO_IP4_OTHER_L3_PAYLOAD                                           \
-	(IS2_HKO_IP4_OTHER_L3_PROTO + IS2_HKL_IP4_OTHER_L3_PROTO)
-#define IS2_HKL_IP4_OTHER_L3_PAYLOAD 56
-
-/* IS2 half key - IP6_STD */
-#define IS2_HKO_IP6_STD_L3_TTL_GT0 IS2_HKO_L2_DMAC
-#define IS2_HKL_IP6_STD_L3_TTL_GT0 1
-#define IS2_HKO_IP6_STD_L3_IP6_SIP                                             \
-	(IS2_HKO_IP6_STD_L3_TTL_GT0 + IS2_HKL_IP6_STD_L3_TTL_GT0)
-#define IS2_HKL_IP6_STD_L3_IP6_SIP 128
-#define IS2_HKO_IP6_STD_L3_PROTO                                               \
-	(IS2_HKO_IP6_STD_L3_IP6_SIP + IS2_HKL_IP6_STD_L3_IP6_SIP)
-#define IS2_HKL_IP6_STD_L3_PROTO 8
-
-/* IS2 half key - OAM */
-#define IS2_HKO_OAM_OAM_MEL_FLAGS IS2_HKO_MAC_ETYPE_ETYPE
-#define IS2_HKL_OAM_OAM_MEL_FLAGS 7
-#define IS2_HKO_OAM_OAM_VER                                                    \
-	(IS2_HKO_OAM_OAM_MEL_FLAGS + IS2_HKL_OAM_OAM_MEL_FLAGS)
-#define IS2_HKL_OAM_OAM_VER 5
-#define IS2_HKO_OAM_OAM_OPCODE (IS2_HKO_OAM_OAM_VER + IS2_HKL_OAM_OAM_VER)
-#define IS2_HKL_OAM_OAM_OPCODE 8
-#define IS2_HKO_OAM_OAM_FLAGS (IS2_HKO_OAM_OAM_OPCODE + IS2_HKL_OAM_OAM_OPCODE)
-#define IS2_HKL_OAM_OAM_FLAGS 8
-#define IS2_HKO_OAM_OAM_MEPID (IS2_HKO_OAM_OAM_FLAGS + IS2_HKL_OAM_OAM_FLAGS)
-#define IS2_HKL_OAM_OAM_MEPID 16
-#define IS2_HKO_OAM_OAM_CCM_CNTS_EQ0                                           \
-	(IS2_HKO_OAM_OAM_MEPID + IS2_HKL_OAM_OAM_MEPID)
-#define IS2_HKL_OAM_OAM_CCM_CNTS_EQ0 1
-
-/* IS2 half key - SMAC_SIP6 */
-#define IS2_HKO_SMAC_SIP6_IGR_PORT IS2_HKL_TYPE
-#define IS2_HKL_SMAC_SIP6_IGR_PORT VCAP_PORT_WIDTH
-#define IS2_HKO_SMAC_SIP6_L2_SMAC                                              \
-	(IS2_HKO_SMAC_SIP6_IGR_PORT + IS2_HKL_SMAC_SIP6_IGR_PORT)
-#define IS2_HKL_SMAC_SIP6_L2_SMAC 48
-#define IS2_HKO_SMAC_SIP6_L3_IP6_SIP                                           \
-	(IS2_HKO_SMAC_SIP6_L2_SMAC + IS2_HKL_SMAC_SIP6_L2_SMAC)
-#define IS2_HKL_SMAC_SIP6_L3_IP6_SIP 128
-
-/* IS2 full key - common */
-#define IS2_FKO_TYPE 0
-#define IS2_FKL_TYPE 2
-#define IS2_FKO_FIRST (IS2_FKO_TYPE + IS2_FKL_TYPE)
-#define IS2_FKL_FIRST 1
-#define IS2_FKO_PAG (IS2_FKO_FIRST + IS2_FKL_FIRST)
-#define IS2_FKL_PAG 8
-#define IS2_FKO_IGR_PORT_MASK (IS2_FKO_PAG + IS2_FKL_PAG)
-#define IS2_FKL_IGR_PORT_MASK (VCAP_PORT_CNT + 1)
-#define IS2_FKO_SERVICE_FRM (IS2_FKO_IGR_PORT_MASK + IS2_FKL_IGR_PORT_MASK)
-#define IS2_FKL_SERVICE_FRM 1
-#define IS2_FKO_HOST_MATCH (IS2_FKO_SERVICE_FRM + IS2_FKL_SERVICE_FRM)
-#define IS2_FKL_HOST_MATCH 1
-#define IS2_FKO_L2_MC (IS2_FKO_HOST_MATCH + IS2_FKL_HOST_MATCH)
-#define IS2_FKL_L2_MC 1
-#define IS2_FKO_L2_BC (IS2_FKO_L2_MC + IS2_FKL_L2_MC)
-#define IS2_FKL_L2_BC 1
-#define IS2_FKO_VLAN_TAGGED (IS2_FKO_L2_BC + IS2_FKL_L2_BC)
-#define IS2_FKL_VLAN_TAGGED 1
-#define IS2_FKO_VID (IS2_FKO_VLAN_TAGGED + IS2_FKL_VLAN_TAGGED)
-#define IS2_FKL_VID 12
-#define IS2_FKO_DEI (IS2_FKO_VID + IS2_FKL_VID)
-#define IS2_FKL_DEI 1
-#define IS2_FKO_PCP (IS2_FKO_DEI + IS2_FKL_DEI)
-#define IS2_FKL_PCP 3
-
-/* IS2 full key - IP6_TCP_UDP/IP6_OTHER common */
-#define IS2_FKO_L3_TTL_GT0 (IS2_FKO_PCP + IS2_FKL_PCP)
-#define IS2_FKL_L3_TTL_GT0 1
-#define IS2_FKO_L3_TOS (IS2_FKO_L3_TTL_GT0 + IS2_FKL_L3_TTL_GT0)
-#define IS2_FKL_L3_TOS 8
-#define IS2_FKO_L3_IP6_DIP (IS2_FKO_L3_TOS + IS2_FKL_L3_TOS)
-#define IS2_FKL_L3_IP6_DIP 128
-#define IS2_FKO_L3_IP6_SIP (IS2_FKO_L3_IP6_DIP + IS2_FKL_L3_IP6_DIP)
-#define IS2_FKL_L3_IP6_SIP 128
-#define IS2_FKO_DIP_EQ_SIP (IS2_FKO_L3_IP6_SIP + IS2_FKL_L3_IP6_SIP)
-#define IS2_FKL_DIP_EQ_SIP 1
-
-/* IS2 full key - IP6_TCP_UDP */
-#define IS2_FKO_IP6_TCP_UDP_TCP (IS2_FKO_DIP_EQ_SIP + IS2_FKL_DIP_EQ_SIP)
-#define IS2_FKL_IP6_TCP_UDP_TCP 1
-#define IS2_FKO_IP6_TCP_UDP_L4_DPORT                                           \
-	(IS2_FKO_IP6_TCP_UDP_TCP + IS2_FKL_IP6_TCP_UDP_TCP)
-#define IS2_FKL_IP6_TCP_UDP_L4_DPORT 16
-#define IS2_FKO_IP6_TCP_UDP_L4_SPORT                                           \
-	(IS2_FKO_IP6_TCP_UDP_L4_DPORT + IS2_FKL_IP6_TCP_UDP_L4_DPORT)
-#define IS2_FKL_IP6_TCP_UDP_L4_SPORT 16
-#define IS2_FKO_IP6_TCP_UDP_L4_RNG                                             \
-	(IS2_FKO_IP6_TCP_UDP_L4_SPORT + IS2_FKL_IP6_TCP_UDP_L4_SPORT)
-#define IS2_FKL_IP6_TCP_UDP_L4_RNG 8
-#define IS2_FKO_IP6_TCP_UDP_SPORT_EQ_DPORT                                     \
-	(IS2_FKO_IP6_TCP_UDP_L4_RNG + IS2_FKL_IP6_TCP_UDP_L4_RNG)
-#define IS2_FKL_IP6_TCP_UDP_SPORT_EQ_DPORT 1
-#define IS2_FKO_IP6_TCP_UDP_SEQUENCE_EQ0                                       \
-	(IS2_FKO_IP6_TCP_UDP_SPORT_EQ_DPORT +                                  \
-	 IS2_FKL_IP6_TCP_UDP_SPORT_EQ_DPORT)
-#define IS2_FKL_IP6_TCP_UDP_SEQUENCE_EQ0 1
-#define IS2_FKO_IP6_TCP_UDP_L4_FIN                                             \
-	(IS2_FKO_IP6_TCP_UDP_SEQUENCE_EQ0 + IS2_FKL_IP6_TCP_UDP_SEQUENCE_EQ0)
-#define IS2_FKL_IP6_TCP_UDP_L4_FIN 1
-#define IS2_FKO_IP6_TCP_UDP_L4_SYN                                             \
-	(IS2_FKO_IP6_TCP_UDP_L4_FIN + IS2_FKL_IP6_TCP_UDP_L4_FIN)
-#define IS2_FKL_IP6_TCP_UDP_L4_SYN 1
-#define IS2_FKO_IP6_TCP_UDP_L4_RST                                             \
-	(IS2_FKO_IP6_TCP_UDP_L4_SYN + IS2_FKL_IP6_TCP_UDP_L4_SYN)
-#define IS2_FKL_IP6_TCP_UDP_L4_RST 1
-#define IS2_FKO_IP6_TCP_UDP_L4_PSH                                             \
-	(IS2_FKO_IP6_TCP_UDP_L4_RST + IS2_FKL_IP6_TCP_UDP_L4_RST)
-#define IS2_FKL_IP6_TCP_UDP_L4_PSH 1
-#define IS2_FKO_IP6_TCP_UDP_L4_ACK                                             \
-	(IS2_FKO_IP6_TCP_UDP_L4_PSH + IS2_FKL_IP6_TCP_UDP_L4_PSH)
-#define IS2_FKL_IP6_TCP_UDP_L4_ACK 1
-#define IS2_FKO_IP6_TCP_UDP_L4_URG                                             \
-	(IS2_FKO_IP6_TCP_UDP_L4_ACK + IS2_FKL_IP6_TCP_UDP_L4_ACK)
-#define IS2_FKL_IP6_TCP_UDP_L4_URG 1
-#define IS2_FKO_IP6_TCP_UDP_L4_1588_DOM                                        \
-	(IS2_FKO_IP6_TCP_UDP_L4_URG + IS2_FKL_IP6_TCP_UDP_L4_URG)
-#define IS2_FKL_IP6_TCP_UDP_L4_1588_DOM 8
-#define IS2_FKO_IP6_TCP_UDP_L4_1588_VER                                        \
-	(IS2_FKO_IP6_TCP_UDP_L4_1588_DOM + IS2_FKL_IP6_TCP_UDP_L4_1588_DOM)
-#define IS2_FKL_IP6_TCP_UDP_L4_1588_VER 4
-
-/* IS2 full key - IP6_OTHER */
-#define IS2_FKO_IP6_OTHER_L3_PROTO IS2_FKO_IP6_TCP_UDP_TCP
-#define IS2_FKL_IP6_OTHER_L3_PROTO 8
-#define IS2_FKO_IP6_OTHER_L3_PAYLOAD                                           \
-	(IS2_FKO_IP6_OTHER_L3_PROTO + IS2_FKL_IP6_OTHER_L3_PROTO)
-#define IS2_FKL_IP6_OTHER_L3_PAYLOAD 56
-
-/* IS2 full key - CUSTOM */
-#define IS2_FKO_CUSTOM_CUSTOM_TYPE IS2_FKO_L3_TTL_GT0
-#define IS2_FKL_CUSTOM_CUSTOM_TYPE 1
-#define IS2_FKO_CUSTOM_CUSTOM                                                  \
-	(IS2_FKO_CUSTOM_CUSTOM_TYPE + IS2_FKL_CUSTOM_CUSTOM_TYPE)
-#define IS2_FKL_CUSTOM_CUSTOM 320
-
-/* IS2 action - BASE_TYPE */
-#define IS2_AO_HIT_ME_ONCE 0
-#define IS2_AL_HIT_ME_ONCE 1
-#define IS2_AO_CPU_COPY_ENA (IS2_AO_HIT_ME_ONCE + IS2_AL_HIT_ME_ONCE)
-#define IS2_AL_CPU_COPY_ENA 1
-#define IS2_AO_CPU_QU_NUM (IS2_AO_CPU_COPY_ENA + IS2_AL_CPU_COPY_ENA)
-#define IS2_AL_CPU_QU_NUM 3
-#define IS2_AO_MASK_MODE (IS2_AO_CPU_QU_NUM + IS2_AL_CPU_QU_NUM)
-#define IS2_AL_MASK_MODE 2
-#define IS2_AO_MIRROR_ENA (IS2_AO_MASK_MODE + IS2_AL_MASK_MODE)
-#define IS2_AL_MIRROR_ENA 1
-#define IS2_AO_LRN_DIS (IS2_AO_MIRROR_ENA + IS2_AL_MIRROR_ENA)
-#define IS2_AL_LRN_DIS 1
-#define IS2_AO_POLICE_ENA (IS2_AO_LRN_DIS + IS2_AL_LRN_DIS)
-#define IS2_AL_POLICE_ENA 1
-#define IS2_AO_POLICE_IDX (IS2_AO_POLICE_ENA + IS2_AL_POLICE_ENA)
-#define IS2_AL_POLICE_IDX 9
-#define IS2_AO_POLICE_VCAP_ONLY (IS2_AO_POLICE_IDX + IS2_AL_POLICE_IDX)
-#define IS2_AL_POLICE_VCAP_ONLY 1
-#define IS2_AO_PORT_MASK (IS2_AO_POLICE_VCAP_ONLY + IS2_AL_POLICE_VCAP_ONLY)
-#define IS2_AL_PORT_MASK VCAP_PORT_CNT
-#define IS2_AO_REW_OP (IS2_AO_PORT_MASK + IS2_AL_PORT_MASK)
-#define IS2_AL_REW_OP 9
-#define IS2_AO_LM_CNT_DIS (IS2_AO_REW_OP + IS2_AL_REW_OP)
-#define IS2_AL_LM_CNT_DIS 1
-#define IS2_AO_ISDX_ENA                                                        \
-	(IS2_AO_LM_CNT_DIS + IS2_AL_LM_CNT_DIS + 1) /* Reserved bit */
-#define IS2_AL_ISDX_ENA 1
-#define IS2_AO_ACL_ID (IS2_AO_ISDX_ENA + IS2_AL_ISDX_ENA)
-#define IS2_AL_ACL_ID 6
-
-/* IS2 action - SMAC_SIP */
-#define IS2_AO_SMAC_SIP_CPU_COPY_ENA 0
-#define IS2_AL_SMAC_SIP_CPU_COPY_ENA 1
-#define IS2_AO_SMAC_SIP_CPU_QU_NUM 1
-#define IS2_AL_SMAC_SIP_CPU_QU_NUM 3
-#define IS2_AO_SMAC_SIP_FWD_KILL_ENA 4
-#define IS2_AL_SMAC_SIP_FWD_KILL_ENA 1
-#define IS2_AO_SMAC_SIP_HOST_MATCH 5
-#define IS2_AL_SMAC_SIP_HOST_MATCH 1
-
-#endif /* _OCELOT_VCAP_H_ */
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 3d9e83e78c59..f9da90c5171b 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -521,6 +521,9 @@ struct ocelot {
 
 	struct ocelot_acl_block		acl_block;
 
+	const struct vcap_field		*vcap_is2_keys;
+	const struct vcap_field		*vcap_is2_actions;
+
 	/* Workqueue to check statistics for overflow with its lock */
 	struct mutex			stats_lock;
 	u64				*stats;
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
new file mode 100644
index 000000000000..0783f0ffc813
--- /dev/null
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -0,0 +1,184 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT)
+ * Microsemi Ocelot Switch driver
+ * Copyright (c) 2019 Microsemi Corporation
+ */
+
+#ifndef _OCELOT_VCAP_H_
+#define _OCELOT_VCAP_H_
+
+/* =================================================================
+ *  VCAP Common
+ * =================================================================
+ */
+
+/* VCAP Type-Group values */
+#define VCAP_TG_NONE 0 /* Entry is invalid */
+#define VCAP_TG_FULL 1 /* Full entry */
+#define VCAP_TG_HALF 2 /* Half entry */
+#define VCAP_TG_QUARTER 3 /* Quarter entry */
+
+/* =================================================================
+ *  VCAP IS2
+ * =================================================================
+ */
+
+#define VCAP_IS2_CNT 64
+#define VCAP_IS2_ENTRY_WIDTH 376
+#define VCAP_IS2_ACTION_WIDTH 99
+#define VCAP_PORT_CNT 11
+
+/* IS2 half key types */
+#define IS2_TYPE_ETYPE 0
+#define IS2_TYPE_LLC 1
+#define IS2_TYPE_SNAP 2
+#define IS2_TYPE_ARP 3
+#define IS2_TYPE_IP_UDP_TCP 4
+#define IS2_TYPE_IP_OTHER 5
+#define IS2_TYPE_IPV6 6
+#define IS2_TYPE_OAM 7
+#define IS2_TYPE_SMAC_SIP6 8
+#define IS2_TYPE_ANY 100 /* Pseudo type */
+
+/* IS2 half key type mask for matching any IP */
+#define IS2_TYPE_MASK_IP_ANY 0xe
+
+/* IS2 action types */
+#define IS2_ACTION_TYPE_NORMAL 0
+#define IS2_ACTION_TYPE_SMAC_SIP 1
+
+/* IS2 MASK_MODE values */
+#define IS2_ACT_MASK_MODE_NONE 0
+#define IS2_ACT_MASK_MODE_FILTER 1
+#define IS2_ACT_MASK_MODE_POLICY 2
+#define IS2_ACT_MASK_MODE_REDIR 3
+
+/* IS2 REW_OP values */
+#define IS2_ACT_REW_OP_NONE 0
+#define IS2_ACT_REW_OP_PTP_ONE 2
+#define IS2_ACT_REW_OP_PTP_TWO 3
+#define IS2_ACT_REW_OP_SPECIAL 8
+#define IS2_ACT_REW_OP_PTP_ORG 9
+#define IS2_ACT_REW_OP_PTP_ONE_SUB_DELAY_1 (IS2_ACT_REW_OP_PTP_ONE | (1 << 3))
+#define IS2_ACT_REW_OP_PTP_ONE_SUB_DELAY_2 (IS2_ACT_REW_OP_PTP_ONE | (2 << 3))
+#define IS2_ACT_REW_OP_PTP_ONE_ADD_DELAY (IS2_ACT_REW_OP_PTP_ONE | (1 << 5))
+#define IS2_ACT_REW_OP_PTP_ONE_ADD_SUB BIT(7)
+
+#define VCAP_PORT_WIDTH 4
+
+/* IS2 quarter key - SMAC_SIP4 */
+#define IS2_QKO_IGR_PORT 0
+#define IS2_QKL_IGR_PORT VCAP_PORT_WIDTH
+#define IS2_QKO_L2_SMAC (IS2_QKO_IGR_PORT + IS2_QKL_IGR_PORT)
+#define IS2_QKL_L2_SMAC 48
+#define IS2_QKO_L3_IP4_SIP (IS2_QKO_L2_SMAC + IS2_QKL_L2_SMAC)
+#define IS2_QKL_L3_IP4_SIP 32
+
+enum vcap_is2_half_key_field {
+	/* Common */
+	VCAP_IS2_TYPE,
+	VCAP_IS2_HK_FIRST,
+	VCAP_IS2_HK_PAG,
+	VCAP_IS2_HK_RSV1,
+	VCAP_IS2_HK_IGR_PORT_MASK,
+	VCAP_IS2_HK_RSV2,
+	VCAP_IS2_HK_HOST_MATCH,
+	VCAP_IS2_HK_L2_MC,
+	VCAP_IS2_HK_L2_BC,
+	VCAP_IS2_HK_VLAN_TAGGED,
+	VCAP_IS2_HK_VID,
+	VCAP_IS2_HK_DEI,
+	VCAP_IS2_HK_PCP,
+	/* MAC_ETYPE / MAC_LLC / MAC_SNAP / OAM common */
+	VCAP_IS2_HK_L2_DMAC,
+	VCAP_IS2_HK_L2_SMAC,
+	/* MAC_ETYPE (TYPE=000) */
+	VCAP_IS2_HK_MAC_ETYPE_ETYPE,
+	VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD0,
+	VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD1,
+	VCAP_IS2_HK_MAC_ETYPE_L2_PAYLOAD2,
+	/* MAC_LLC (TYPE=001) */
+	VCAP_IS2_HK_MAC_LLC_DMAC,
+	VCAP_IS2_HK_MAC_LLC_SMAC,
+	VCAP_IS2_HK_MAC_LLC_L2_LLC,
+	/* MAC_SNAP (TYPE=010) */
+	VCAP_IS2_HK_MAC_SNAP_SMAC,
+	VCAP_IS2_HK_MAC_SNAP_DMAC,
+	VCAP_IS2_HK_MAC_SNAP_L2_SNAP,
+	/* MAC_ARP (TYPE=011) */
+	VCAP_IS2_HK_MAC_ARP_SMAC,
+	VCAP_IS2_HK_MAC_ARP_ADDR_SPACE_OK,
+	VCAP_IS2_HK_MAC_ARP_PROTO_SPACE_OK,
+	VCAP_IS2_HK_MAC_ARP_LEN_OK,
+	VCAP_IS2_HK_MAC_ARP_TARGET_MATCH,
+	VCAP_IS2_HK_MAC_ARP_SENDER_MATCH,
+	VCAP_IS2_HK_MAC_ARP_OPCODE_UNKNOWN,
+	VCAP_IS2_HK_MAC_ARP_OPCODE,
+	VCAP_IS2_HK_MAC_ARP_L3_IP4_DIP,
+	VCAP_IS2_HK_MAC_ARP_L3_IP4_SIP,
+	VCAP_IS2_HK_MAC_ARP_DIP_EQ_SIP,
+	/* IP4_TCP_UDP / IP4_OTHER common */
+	VCAP_IS2_HK_IP4,
+	VCAP_IS2_HK_L3_FRAGMENT,
+	VCAP_IS2_HK_L3_FRAG_OFS_GT0,
+	VCAP_IS2_HK_L3_OPTIONS,
+	VCAP_IS2_HK_IP4_L3_TTL_GT0,
+	VCAP_IS2_HK_L3_TOS,
+	VCAP_IS2_HK_L3_IP4_DIP,
+	VCAP_IS2_HK_L3_IP4_SIP,
+	VCAP_IS2_HK_DIP_EQ_SIP,
+	/* IP4_TCP_UDP (TYPE=100) */
+	VCAP_IS2_HK_TCP,
+	VCAP_IS2_HK_L4_SPORT,
+	VCAP_IS2_HK_L4_DPORT,
+	VCAP_IS2_HK_L4_RNG,
+	VCAP_IS2_HK_L4_SPORT_EQ_DPORT,
+	VCAP_IS2_HK_L4_SEQUENCE_EQ0,
+	VCAP_IS2_HK_L4_URG,
+	VCAP_IS2_HK_L4_ACK,
+	VCAP_IS2_HK_L4_PSH,
+	VCAP_IS2_HK_L4_RST,
+	VCAP_IS2_HK_L4_SYN,
+	VCAP_IS2_HK_L4_FIN,
+	VCAP_IS2_HK_L4_1588_DOM,
+	VCAP_IS2_HK_L4_1588_VER,
+	/* IP4_OTHER (TYPE=101) */
+	VCAP_IS2_HK_IP4_L3_PROTO,
+	VCAP_IS2_HK_L3_PAYLOAD,
+	/* IP6_STD (TYPE=110) */
+	VCAP_IS2_HK_IP6_L3_TTL_GT0,
+	VCAP_IS2_HK_IP6_L3_PROTO,
+	VCAP_IS2_HK_L3_IP6_SIP,
+	/* OAM (TYPE=111) */
+	VCAP_IS2_HK_OAM_MEL_FLAGS,
+	VCAP_IS2_HK_OAM_VER,
+	VCAP_IS2_HK_OAM_OPCODE,
+	VCAP_IS2_HK_OAM_FLAGS,
+	VCAP_IS2_HK_OAM_MEPID,
+	VCAP_IS2_HK_OAM_CCM_CNTS_EQ0,
+	VCAP_IS2_HK_OAM_IS_Y1731,
+};
+
+struct vcap_field {
+	int offset;
+	int length;
+};
+
+enum vcap_is2_action_field {
+	VCAP_IS2_ACT_HIT_ME_ONCE,
+	VCAP_IS2_ACT_CPU_COPY_ENA,
+	VCAP_IS2_ACT_CPU_QU_NUM,
+	VCAP_IS2_ACT_MASK_MODE,
+	VCAP_IS2_ACT_MIRROR_ENA,
+	VCAP_IS2_ACT_LRN_DIS,
+	VCAP_IS2_ACT_POLICE_ENA,
+	VCAP_IS2_ACT_POLICE_IDX,
+	VCAP_IS2_ACT_POLICE_VCAP_ONLY,
+	VCAP_IS2_ACT_PORT_MASK,
+	VCAP_IS2_ACT_REW_OP,
+	VCAP_IS2_ACT_SMAC_REPLACE_ENA,
+	VCAP_IS2_ACT_RSV,
+	VCAP_IS2_ACT_ACL_ID,
+	VCAP_IS2_ACT_HIT_CNT,
+};
+
+#endif /* _OCELOT_VCAP_H_ */
-- 
2.17.1

