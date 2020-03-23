Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9140418F576
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgCWNPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:15:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54344 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728426AbgCWNPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:15:19 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ND60gO010448;
        Mon, 23 Mar 2020 06:15:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=nB5L/YQhDzKiQmfNfLVlTY1CBtwZFysLDTwKo2eUZhM=;
 b=cvyZ5zWEQabz2WXLNmWY0hn/5ztZJLA0uZZjuhYR1mvDoUCyuNN7fLnMKFAKdViQ3Wbp
 OLkdHkqEauwf3xPlgnxs649OLbjweoRenreUH85swV43wm/tI6hyC/lg5AewZ0eUBjqN
 tZl5YTf8ophRFGAJywTgXvRn9QV54i+WKHBPB0eHkz7r6lENGMcgCTLNqJg0MQVvVr8t
 7XhdwdTn2HfXeWvMLDEESkL5YjgtfCNHdTfpAcJjebniIksAWzj7DniuQq9EkiUXbwnG
 ZSEQxqOUYBPX6qsGgimfCJwWelPORGVyBNkT8ALgRelH5AoLZtja4kaht40L8bYONEnr ZQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ywg9nefrx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 06:15:12 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 06:15:10 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Mar 2020 06:15:10 -0700
Received: from localhost.localdomain (unknown [10.9.16.91])
        by maili.marvell.com (Postfix) with ESMTP id D96FF3F7040;
        Mon, 23 Mar 2020 06:15:08 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 13/17] net: atlantic: MACSec ingress offload HW bindings
Date:   Mon, 23 Mar 2020 16:13:44 +0300
Message-ID: <20200323131348.340-14-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323131348.340-1-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_04:2020-03-21,2020-03-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds the Atlantic HW-specific bindings for MACSec ingress, e.g.
register addresses / structs, helper function, etc, which will be used by
actual callback implementations.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../atlantic/macsec/MSS_Ingress_registers.h   |   77 +
 .../aquantia/atlantic/macsec/macsec_api.c     | 1239 +++++++++++++++++
 .../aquantia/atlantic/macsec/macsec_api.h     |  148 ++
 .../aquantia/atlantic/macsec/macsec_struct.h  |  383 +++++
 4 files changed, 1847 insertions(+)
 create mode 100644 drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Ingress_registers.h

diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Ingress_registers.h b/drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Ingress_registers.h
new file mode 100644
index 000000000000..d4c00d9a0fc6
--- /dev/null
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/MSS_Ingress_registers.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Atlantic Network Driver
+ * Copyright (C) 2020 Marvell International Ltd.
+ */
+
+#ifndef MSS_INGRESS_REGS_HEADER
+#define MSS_INGRESS_REGS_HEADER
+
+#define MSS_INGRESS_CTL_REGISTER_ADDR 0x0000800E
+#define MSS_INGRESS_LUT_ADDR_CTL_REGISTER_ADDR 0x00008080
+#define MSS_INGRESS_LUT_CTL_REGISTER_ADDR 0x00008081
+#define MSS_INGRESS_LUT_DATA_CTL_REGISTER_ADDR 0x000080A0
+
+struct mss_ingress_ctl_register {
+	union {
+		struct {
+			unsigned int soft_reset : 1;
+			unsigned int operation_point_to_point : 1;
+			unsigned int create_sci : 1;
+			/* Unused  */
+			unsigned int mask_short_length_error : 1;
+			unsigned int drop_kay_packet : 1;
+			unsigned int drop_igprc_miss : 1;
+			/* Unused  */
+			unsigned int check_icv : 1;
+			unsigned int clear_global_time : 1;
+			unsigned int clear_count : 1;
+			unsigned int high_prio : 1;
+			unsigned int remove_sectag : 1;
+			unsigned int global_validate_frames : 2;
+			unsigned int icv_lsb_8bytes_enabled : 1;
+			unsigned int reserved0 : 2;
+		} bits_0;
+		unsigned short word_0;
+	};
+	union {
+		struct {
+			unsigned int reserved0 : 16;
+		} bits_1;
+		unsigned short word_1;
+	};
+};
+
+struct mss_ingress_lut_addr_ctl_register {
+	union {
+		struct {
+			unsigned int lut_addr : 9;
+			unsigned int reserved0 : 3;
+			/* 0x0 : Ingress Pre-Security MAC Control FIlter
+			 *       (IGPRCTLF) LUT
+			 * 0x1 : Ingress Pre-Security Classification LUT (IGPRC)
+			 * 0x2 : Ingress Packet Format (IGPFMT) SAKey LUT
+			 * 0x3 : Ingress Packet Format (IGPFMT) SC/SA LUT
+			 * 0x4 : Ingress Post-Security Classification LUT
+			 *       (IGPOC)
+			 * 0x5 : Ingress Post-Security MAC Control Filter
+			 *       (IGPOCTLF) LUT
+			 * 0x6 : Ingress MIB (IGMIB)
+			 */
+			unsigned int lut_select : 4;
+		} bits_0;
+		unsigned short word_0;
+	};
+};
+
+struct mss_ingress_lut_ctl_register {
+	union {
+		struct {
+			unsigned int reserved0 : 14;
+			unsigned int lut_read : 1;
+			unsigned int lut_write : 1;
+		} bits_0;
+		unsigned short word_0;
+	};
+};
+
+#endif /* MSS_INGRESS_REGS_HEADER */
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
index 8448df694770..f2316d965715 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.c
@@ -5,6 +5,7 @@
 
 #include "macsec_api.h"
 #include <linux/mdio.h>
+#include "MSS_Ingress_registers.h"
 #include "MSS_Egress_registers.h"
 #include "aq_phy.h"
 
@@ -55,6 +56,115 @@ static int aq_mss_mdio_write(struct aq_hw_s *hw, u16 mmd, u16 addr, u16 data)
  *                          MACSEC config and status
  ******************************************************************************/
 
+static int set_raw_ingress_record(struct aq_hw_s *hw, u16 *packed_record,
+				  u8 num_words, u8 table_id,
+				  u16 table_index)
+{
+	struct mss_ingress_lut_addr_ctl_register lut_sel_reg;
+	struct mss_ingress_lut_ctl_register lut_op_reg;
+
+	unsigned int i;
+
+	/* NOTE: MSS registers must always be read/written as adjacent pairs.
+	 * For instance, to write either or both 1E.80A0 and 80A1, we have to:
+	 * 1. Write 1E.80A0 first
+	 * 2. Then write 1E.80A1
+	 *
+	 * For HHD devices: These writes need to be performed consecutively, and
+	 * to ensure this we use the PIF mailbox to delegate the reads/writes to
+	 * the FW.
+	 *
+	 * For EUR devices: Not need to use the PIF mailbox; it is safe to
+	 * write to the registers directly.
+	 */
+
+	/* Write the packed record words to the data buffer registers. */
+	for (i = 0; i < num_words; i += 2) {
+		aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				  MSS_INGRESS_LUT_DATA_CTL_REGISTER_ADDR + i,
+				  packed_record[i]);
+		aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				  MSS_INGRESS_LUT_DATA_CTL_REGISTER_ADDR + i +
+					  1,
+				  packed_record[i + 1]);
+	}
+
+	/* Clear out the unused data buffer registers. */
+	for (i = num_words; i < 24; i += 2) {
+		aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				  MSS_INGRESS_LUT_DATA_CTL_REGISTER_ADDR + i,
+				  0);
+		aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+			MSS_INGRESS_LUT_DATA_CTL_REGISTER_ADDR + i + 1, 0);
+	}
+
+	/* Select the table and row index to write to */
+	lut_sel_reg.bits_0.lut_select = table_id;
+	lut_sel_reg.bits_0.lut_addr = table_index;
+
+	lut_op_reg.bits_0.lut_read = 0;
+	lut_op_reg.bits_0.lut_write = 1;
+
+	aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+			  MSS_INGRESS_LUT_ADDR_CTL_REGISTER_ADDR,
+			  lut_sel_reg.word_0);
+	aq_mss_mdio_write(hw, MDIO_MMD_VEND1, MSS_INGRESS_LUT_CTL_REGISTER_ADDR,
+			  lut_op_reg.word_0);
+
+	return 0;
+}
+
+/*! Read the specified Ingress LUT table row.
+ *  packed_record - [OUT] The table row data (raw).
+ */
+static int get_raw_ingress_record(struct aq_hw_s *hw, u16 *packed_record,
+				  u8 num_words, u8 table_id,
+				  u16 table_index)
+{
+	struct mss_ingress_lut_addr_ctl_register lut_sel_reg;
+	struct mss_ingress_lut_ctl_register lut_op_reg;
+	int ret;
+
+	unsigned int i;
+
+	/* Select the table and row index to read */
+	lut_sel_reg.bits_0.lut_select = table_id;
+	lut_sel_reg.bits_0.lut_addr = table_index;
+
+	lut_op_reg.bits_0.lut_read = 1;
+	lut_op_reg.bits_0.lut_write = 0;
+
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_INGRESS_LUT_ADDR_CTL_REGISTER_ADDR,
+				lut_sel_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+	ret = aq_mss_mdio_write(hw, MDIO_MMD_VEND1,
+				MSS_INGRESS_LUT_CTL_REGISTER_ADDR,
+				lut_op_reg.word_0);
+	if (unlikely(ret))
+		return ret;
+
+	memset(packed_record, 0, sizeof(u16) * num_words);
+
+	for (i = 0; i < num_words; i += 2) {
+		ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+				       MSS_INGRESS_LUT_DATA_CTL_REGISTER_ADDR +
+					       i,
+				       &packed_record[i]);
+		if (unlikely(ret))
+			return ret;
+		ret = aq_mss_mdio_read(hw, MDIO_MMD_VEND1,
+				       MSS_INGRESS_LUT_DATA_CTL_REGISTER_ADDR +
+					       i + 1,
+				       &packed_record[i + 1]);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	return 0;
+}
+
 /*! Write packed_record to the specified Egress LUT table row. */
 static int set_raw_egress_record(struct aq_hw_s *hw, u16 *packed_record,
 				 u8 num_words, u8 table_id,
@@ -148,6 +258,1135 @@ static int get_raw_egress_record(struct aq_hw_s *hw, u16 *packed_record,
 	return 0;
 }
 
+static int
+set_ingress_prectlf_record(struct aq_hw_s *hw,
+			   const struct aq_mss_ingress_prectlf_record *rec,
+			   u16 table_index)
+{
+	u16 packed_record[6];
+
+	if (table_index >= NUMROWS_INGRESSPRECTLFRECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 6);
+
+	packed_record[0] = (packed_record[0] & 0x0000) |
+			   (((rec->sa_da[0] >> 0) & 0xFFFF) << 0);
+	packed_record[1] = (packed_record[1] & 0x0000) |
+			   (((rec->sa_da[0] >> 16) & 0xFFFF) << 0);
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->sa_da[1] >> 0) & 0xFFFF) << 0);
+	packed_record[3] = (packed_record[3] & 0x0000) |
+			   (((rec->eth_type >> 0) & 0xFFFF) << 0);
+	packed_record[4] = (packed_record[4] & 0x0000) |
+			   (((rec->match_mask >> 0) & 0xFFFF) << 0);
+	packed_record[5] = (packed_record[5] & 0xFFF0) |
+			   (((rec->match_type >> 0) & 0xF) << 0);
+	packed_record[5] =
+		(packed_record[5] & 0xFFEF) | (((rec->action >> 0) & 0x1) << 4);
+
+	return set_raw_ingress_record(hw, packed_record, 6, 0,
+				      ROWOFFSET_INGRESSPRECTLFRECORD +
+					      table_index);
+}
+
+int aq_mss_set_ingress_prectlf_record(struct aq_hw_s *hw,
+	const struct aq_mss_ingress_prectlf_record *rec,
+	u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_ingress_prectlf_record, hw, rec,
+				table_index);
+}
+
+static int get_ingress_prectlf_record(struct aq_hw_s *hw,
+				      struct aq_mss_ingress_prectlf_record *rec,
+				      u16 table_index)
+{
+	u16 packed_record[6];
+	int ret;
+
+	if (table_index >= NUMROWS_INGRESSPRECTLFRECORD)
+		return -EINVAL;
+
+	/* If the row that we want to read is odd, first read the previous even
+	 * row, throw that value away, and finally read the desired row.
+	 * This is a workaround for EUR devices that allows us to read
+	 * odd-numbered rows.  For HHD devices: this workaround will not work,
+	 * so don't bother; odd-numbered rows are not readable.
+	 */
+	if ((table_index % 2) > 0) {
+		ret = get_raw_ingress_record(hw, packed_record, 6, 0,
+					     ROWOFFSET_INGRESSPRECTLFRECORD +
+						     table_index - 1);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	ret = get_raw_ingress_record(hw, packed_record, 6, 0,
+				     ROWOFFSET_INGRESSPRECTLFRECORD +
+					     table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->sa_da[0] = (rec->sa_da[0] & 0xFFFF0000) |
+			(((packed_record[0] >> 0) & 0xFFFF) << 0);
+	rec->sa_da[0] = (rec->sa_da[0] & 0x0000FFFF) |
+			(((packed_record[1] >> 0) & 0xFFFF) << 16);
+
+	rec->sa_da[1] = (rec->sa_da[1] & 0xFFFF0000) |
+			(((packed_record[2] >> 0) & 0xFFFF) << 0);
+
+	rec->eth_type = (rec->eth_type & 0xFFFF0000) |
+			(((packed_record[3] >> 0) & 0xFFFF) << 0);
+
+	rec->match_mask = (rec->match_mask & 0xFFFF0000) |
+			  (((packed_record[4] >> 0) & 0xFFFF) << 0);
+
+	rec->match_type = (rec->match_type & 0xFFFFFFF0) |
+			  (((packed_record[5] >> 0) & 0xF) << 0);
+
+	rec->action = (rec->action & 0xFFFFFFFE) |
+		      (((packed_record[5] >> 4) & 0x1) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_ingress_prectlf_record(struct aq_hw_s *hw,
+				      struct aq_mss_ingress_prectlf_record *rec,
+				      u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_ingress_prectlf_record, hw, rec,
+				table_index);
+}
+
+static int
+set_ingress_preclass_record(struct aq_hw_s *hw,
+			    const struct aq_mss_ingress_preclass_record *rec,
+			    u16 table_index)
+{
+	u16 packed_record[20];
+
+	if (table_index >= NUMROWS_INGRESSPRECLASSRECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 20);
+
+	packed_record[0] = (packed_record[0] & 0x0000) |
+			   (((rec->sci[0] >> 0) & 0xFFFF) << 0);
+	packed_record[1] = (packed_record[1] & 0x0000) |
+			   (((rec->sci[0] >> 16) & 0xFFFF) << 0);
+
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->sci[1] >> 0) & 0xFFFF) << 0);
+	packed_record[3] = (packed_record[3] & 0x0000) |
+			   (((rec->sci[1] >> 16) & 0xFFFF) << 0);
+
+	packed_record[4] =
+		(packed_record[4] & 0xFF00) | (((rec->tci >> 0) & 0xFF) << 0);
+
+	packed_record[4] = (packed_record[4] & 0x00FF) |
+			   (((rec->encr_offset >> 0) & 0xFF) << 8);
+
+	packed_record[5] = (packed_record[5] & 0x0000) |
+			   (((rec->eth_type >> 0) & 0xFFFF) << 0);
+
+	packed_record[6] = (packed_record[6] & 0x0000) |
+			   (((rec->snap[0] >> 0) & 0xFFFF) << 0);
+	packed_record[7] = (packed_record[7] & 0x0000) |
+			   (((rec->snap[0] >> 16) & 0xFFFF) << 0);
+
+	packed_record[8] = (packed_record[8] & 0xFF00) |
+			   (((rec->snap[1] >> 0) & 0xFF) << 0);
+
+	packed_record[8] =
+		(packed_record[8] & 0x00FF) | (((rec->llc >> 0) & 0xFF) << 8);
+	packed_record[9] =
+		(packed_record[9] & 0x0000) | (((rec->llc >> 8) & 0xFFFF) << 0);
+
+	packed_record[10] = (packed_record[10] & 0x0000) |
+			    (((rec->mac_sa[0] >> 0) & 0xFFFF) << 0);
+	packed_record[11] = (packed_record[11] & 0x0000) |
+			    (((rec->mac_sa[0] >> 16) & 0xFFFF) << 0);
+
+	packed_record[12] = (packed_record[12] & 0x0000) |
+			    (((rec->mac_sa[1] >> 0) & 0xFFFF) << 0);
+
+	packed_record[13] = (packed_record[13] & 0x0000) |
+			    (((rec->mac_da[0] >> 0) & 0xFFFF) << 0);
+	packed_record[14] = (packed_record[14] & 0x0000) |
+			    (((rec->mac_da[0] >> 16) & 0xFFFF) << 0);
+
+	packed_record[15] = (packed_record[15] & 0x0000) |
+			    (((rec->mac_da[1] >> 0) & 0xFFFF) << 0);
+
+	packed_record[16] = (packed_record[16] & 0xFFFE) |
+			    (((rec->lpbk_packet >> 0) & 0x1) << 0);
+
+	packed_record[16] = (packed_record[16] & 0xFFF9) |
+			    (((rec->an_mask >> 0) & 0x3) << 1);
+
+	packed_record[16] = (packed_record[16] & 0xFE07) |
+			    (((rec->tci_mask >> 0) & 0x3F) << 3);
+
+	packed_record[16] = (packed_record[16] & 0x01FF) |
+			    (((rec->sci_mask >> 0) & 0x7F) << 9);
+	packed_record[17] = (packed_record[17] & 0xFFFE) |
+			    (((rec->sci_mask >> 7) & 0x1) << 0);
+
+	packed_record[17] = (packed_record[17] & 0xFFF9) |
+			    (((rec->eth_type_mask >> 0) & 0x3) << 1);
+
+	packed_record[17] = (packed_record[17] & 0xFF07) |
+			    (((rec->snap_mask >> 0) & 0x1F) << 3);
+
+	packed_record[17] = (packed_record[17] & 0xF8FF) |
+			    (((rec->llc_mask >> 0) & 0x7) << 8);
+
+	packed_record[17] = (packed_record[17] & 0xF7FF) |
+			    (((rec->_802_2_encapsulate >> 0) & 0x1) << 11);
+
+	packed_record[17] = (packed_record[17] & 0x0FFF) |
+			    (((rec->sa_mask >> 0) & 0xF) << 12);
+	packed_record[18] = (packed_record[18] & 0xFFFC) |
+			    (((rec->sa_mask >> 4) & 0x3) << 0);
+
+	packed_record[18] = (packed_record[18] & 0xFF03) |
+			    (((rec->da_mask >> 0) & 0x3F) << 2);
+
+	packed_record[18] = (packed_record[18] & 0xFEFF) |
+			    (((rec->lpbk_mask >> 0) & 0x1) << 8);
+
+	packed_record[18] = (packed_record[18] & 0xC1FF) |
+			    (((rec->sc_idx >> 0) & 0x1F) << 9);
+
+	packed_record[18] = (packed_record[18] & 0xBFFF) |
+			    (((rec->proc_dest >> 0) & 0x1) << 14);
+
+	packed_record[18] = (packed_record[18] & 0x7FFF) |
+			    (((rec->action >> 0) & 0x1) << 15);
+	packed_record[19] = (packed_record[19] & 0xFFFE) |
+			    (((rec->action >> 1) & 0x1) << 0);
+
+	packed_record[19] = (packed_record[19] & 0xFFFD) |
+			    (((rec->ctrl_unctrl >> 0) & 0x1) << 1);
+
+	packed_record[19] = (packed_record[19] & 0xFFFB) |
+			    (((rec->sci_from_table >> 0) & 0x1) << 2);
+
+	packed_record[19] = (packed_record[19] & 0xFF87) |
+			    (((rec->reserved >> 0) & 0xF) << 3);
+
+	packed_record[19] =
+		(packed_record[19] & 0xFF7F) | (((rec->valid >> 0) & 0x1) << 7);
+
+	return set_raw_ingress_record(hw, packed_record, 20, 1,
+				      ROWOFFSET_INGRESSPRECLASSRECORD +
+					      table_index);
+}
+
+int aq_mss_set_ingress_preclass_record(struct aq_hw_s *hw,
+	const struct aq_mss_ingress_preclass_record *rec,
+	u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_ingress_preclass_record, hw, rec,
+				table_index);
+}
+
+static int
+get_ingress_preclass_record(struct aq_hw_s *hw,
+			    struct aq_mss_ingress_preclass_record *rec,
+			    u16 table_index)
+{
+	u16 packed_record[20];
+	int ret;
+
+	if (table_index >= NUMROWS_INGRESSPRECLASSRECORD)
+		return -EINVAL;
+
+	/* If the row that we want to read is odd, first read the previous even
+	 * row, throw that value away, and finally read the desired row.
+	 */
+	if ((table_index % 2) > 0) {
+		ret = get_raw_ingress_record(hw, packed_record, 20, 1,
+					     ROWOFFSET_INGRESSPRECLASSRECORD +
+						     table_index - 1);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	ret = get_raw_ingress_record(hw, packed_record, 20, 1,
+				     ROWOFFSET_INGRESSPRECLASSRECORD +
+					     table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->sci[0] = (rec->sci[0] & 0xFFFF0000) |
+		      (((packed_record[0] >> 0) & 0xFFFF) << 0);
+	rec->sci[0] = (rec->sci[0] & 0x0000FFFF) |
+		      (((packed_record[1] >> 0) & 0xFFFF) << 16);
+
+	rec->sci[1] = (rec->sci[1] & 0xFFFF0000) |
+		      (((packed_record[2] >> 0) & 0xFFFF) << 0);
+	rec->sci[1] = (rec->sci[1] & 0x0000FFFF) |
+		      (((packed_record[3] >> 0) & 0xFFFF) << 16);
+
+	rec->tci = (rec->tci & 0xFFFFFF00) |
+		   (((packed_record[4] >> 0) & 0xFF) << 0);
+
+	rec->encr_offset = (rec->encr_offset & 0xFFFFFF00) |
+			   (((packed_record[4] >> 8) & 0xFF) << 0);
+
+	rec->eth_type = (rec->eth_type & 0xFFFF0000) |
+			(((packed_record[5] >> 0) & 0xFFFF) << 0);
+
+	rec->snap[0] = (rec->snap[0] & 0xFFFF0000) |
+		       (((packed_record[6] >> 0) & 0xFFFF) << 0);
+	rec->snap[0] = (rec->snap[0] & 0x0000FFFF) |
+		       (((packed_record[7] >> 0) & 0xFFFF) << 16);
+
+	rec->snap[1] = (rec->snap[1] & 0xFFFFFF00) |
+		       (((packed_record[8] >> 0) & 0xFF) << 0);
+
+	rec->llc = (rec->llc & 0xFFFFFF00) |
+		   (((packed_record[8] >> 8) & 0xFF) << 0);
+	rec->llc = (rec->llc & 0xFF0000FF) |
+		   (((packed_record[9] >> 0) & 0xFFFF) << 8);
+
+	rec->mac_sa[0] = (rec->mac_sa[0] & 0xFFFF0000) |
+			 (((packed_record[10] >> 0) & 0xFFFF) << 0);
+	rec->mac_sa[0] = (rec->mac_sa[0] & 0x0000FFFF) |
+			 (((packed_record[11] >> 0) & 0xFFFF) << 16);
+
+	rec->mac_sa[1] = (rec->mac_sa[1] & 0xFFFF0000) |
+			 (((packed_record[12] >> 0) & 0xFFFF) << 0);
+
+	rec->mac_da[0] = (rec->mac_da[0] & 0xFFFF0000) |
+			 (((packed_record[13] >> 0) & 0xFFFF) << 0);
+	rec->mac_da[0] = (rec->mac_da[0] & 0x0000FFFF) |
+			 (((packed_record[14] >> 0) & 0xFFFF) << 16);
+
+	rec->mac_da[1] = (rec->mac_da[1] & 0xFFFF0000) |
+			 (((packed_record[15] >> 0) & 0xFFFF) << 0);
+
+	rec->lpbk_packet = (rec->lpbk_packet & 0xFFFFFFFE) |
+			   (((packed_record[16] >> 0) & 0x1) << 0);
+
+	rec->an_mask = (rec->an_mask & 0xFFFFFFFC) |
+		       (((packed_record[16] >> 1) & 0x3) << 0);
+
+	rec->tci_mask = (rec->tci_mask & 0xFFFFFFC0) |
+			(((packed_record[16] >> 3) & 0x3F) << 0);
+
+	rec->sci_mask = (rec->sci_mask & 0xFFFFFF80) |
+			(((packed_record[16] >> 9) & 0x7F) << 0);
+	rec->sci_mask = (rec->sci_mask & 0xFFFFFF7F) |
+			(((packed_record[17] >> 0) & 0x1) << 7);
+
+	rec->eth_type_mask = (rec->eth_type_mask & 0xFFFFFFFC) |
+			     (((packed_record[17] >> 1) & 0x3) << 0);
+
+	rec->snap_mask = (rec->snap_mask & 0xFFFFFFE0) |
+			 (((packed_record[17] >> 3) & 0x1F) << 0);
+
+	rec->llc_mask = (rec->llc_mask & 0xFFFFFFF8) |
+			(((packed_record[17] >> 8) & 0x7) << 0);
+
+	rec->_802_2_encapsulate = (rec->_802_2_encapsulate & 0xFFFFFFFE) |
+				  (((packed_record[17] >> 11) & 0x1) << 0);
+
+	rec->sa_mask = (rec->sa_mask & 0xFFFFFFF0) |
+		       (((packed_record[17] >> 12) & 0xF) << 0);
+	rec->sa_mask = (rec->sa_mask & 0xFFFFFFCF) |
+		       (((packed_record[18] >> 0) & 0x3) << 4);
+
+	rec->da_mask = (rec->da_mask & 0xFFFFFFC0) |
+		       (((packed_record[18] >> 2) & 0x3F) << 0);
+
+	rec->lpbk_mask = (rec->lpbk_mask & 0xFFFFFFFE) |
+			 (((packed_record[18] >> 8) & 0x1) << 0);
+
+	rec->sc_idx = (rec->sc_idx & 0xFFFFFFE0) |
+		      (((packed_record[18] >> 9) & 0x1F) << 0);
+
+	rec->proc_dest = (rec->proc_dest & 0xFFFFFFFE) |
+			 (((packed_record[18] >> 14) & 0x1) << 0);
+
+	rec->action = (rec->action & 0xFFFFFFFE) |
+		      (((packed_record[18] >> 15) & 0x1) << 0);
+	rec->action = (rec->action & 0xFFFFFFFD) |
+		      (((packed_record[19] >> 0) & 0x1) << 1);
+
+	rec->ctrl_unctrl = (rec->ctrl_unctrl & 0xFFFFFFFE) |
+			   (((packed_record[19] >> 1) & 0x1) << 0);
+
+	rec->sci_from_table = (rec->sci_from_table & 0xFFFFFFFE) |
+			      (((packed_record[19] >> 2) & 0x1) << 0);
+
+	rec->reserved = (rec->reserved & 0xFFFFFFF0) |
+			(((packed_record[19] >> 3) & 0xF) << 0);
+
+	rec->valid = (rec->valid & 0xFFFFFFFE) |
+		     (((packed_record[19] >> 7) & 0x1) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_ingress_preclass_record(struct aq_hw_s *hw,
+	struct aq_mss_ingress_preclass_record *rec,
+	u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_ingress_preclass_record, hw, rec,
+				table_index);
+}
+
+static int set_ingress_sc_record(struct aq_hw_s *hw,
+				 const struct aq_mss_ingress_sc_record *rec,
+				 u16 table_index)
+{
+	u16 packed_record[8];
+
+	if (table_index >= NUMROWS_INGRESSSCRECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 8);
+
+	packed_record[0] = (packed_record[0] & 0x0000) |
+			   (((rec->stop_time >> 0) & 0xFFFF) << 0);
+	packed_record[1] = (packed_record[1] & 0x0000) |
+			   (((rec->stop_time >> 16) & 0xFFFF) << 0);
+
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->start_time >> 0) & 0xFFFF) << 0);
+	packed_record[3] = (packed_record[3] & 0x0000) |
+			   (((rec->start_time >> 16) & 0xFFFF) << 0);
+
+	packed_record[4] = (packed_record[4] & 0xFFFC) |
+			   (((rec->validate_frames >> 0) & 0x3) << 0);
+
+	packed_record[4] = (packed_record[4] & 0xFFFB) |
+			   (((rec->replay_protect >> 0) & 0x1) << 2);
+
+	packed_record[4] = (packed_record[4] & 0x0007) |
+			   (((rec->anti_replay_window >> 0) & 0x1FFF) << 3);
+	packed_record[5] = (packed_record[5] & 0x0000) |
+			   (((rec->anti_replay_window >> 13) & 0xFFFF) << 0);
+	packed_record[6] = (packed_record[6] & 0xFFF8) |
+			   (((rec->anti_replay_window >> 29) & 0x7) << 0);
+
+	packed_record[6] = (packed_record[6] & 0xFFF7) |
+			   (((rec->receiving >> 0) & 0x1) << 3);
+
+	packed_record[6] =
+		(packed_record[6] & 0xFFEF) | (((rec->fresh >> 0) & 0x1) << 4);
+
+	packed_record[6] =
+		(packed_record[6] & 0xFFDF) | (((rec->an_rol >> 0) & 0x1) << 5);
+
+	packed_record[6] = (packed_record[6] & 0x003F) |
+			   (((rec->reserved >> 0) & 0x3FF) << 6);
+	packed_record[7] = (packed_record[7] & 0x8000) |
+			   (((rec->reserved >> 10) & 0x7FFF) << 0);
+
+	packed_record[7] =
+		(packed_record[7] & 0x7FFF) | (((rec->valid >> 0) & 0x1) << 15);
+
+	return set_raw_ingress_record(hw, packed_record, 8, 3,
+				      ROWOFFSET_INGRESSSCRECORD + table_index);
+}
+
+int aq_mss_set_ingress_sc_record(struct aq_hw_s *hw,
+				 const struct aq_mss_ingress_sc_record *rec,
+				 u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_ingress_sc_record, hw, rec, table_index);
+}
+
+static int get_ingress_sc_record(struct aq_hw_s *hw,
+				 struct aq_mss_ingress_sc_record *rec,
+				 u16 table_index)
+{
+	u16 packed_record[8];
+	int ret;
+
+	if (table_index >= NUMROWS_INGRESSSCRECORD)
+		return -EINVAL;
+
+	ret = get_raw_ingress_record(hw, packed_record, 8, 3,
+				     ROWOFFSET_INGRESSSCRECORD + table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->stop_time = (rec->stop_time & 0xFFFF0000) |
+			 (((packed_record[0] >> 0) & 0xFFFF) << 0);
+	rec->stop_time = (rec->stop_time & 0x0000FFFF) |
+			 (((packed_record[1] >> 0) & 0xFFFF) << 16);
+
+	rec->start_time = (rec->start_time & 0xFFFF0000) |
+			  (((packed_record[2] >> 0) & 0xFFFF) << 0);
+	rec->start_time = (rec->start_time & 0x0000FFFF) |
+			  (((packed_record[3] >> 0) & 0xFFFF) << 16);
+
+	rec->validate_frames = (rec->validate_frames & 0xFFFFFFFC) |
+			       (((packed_record[4] >> 0) & 0x3) << 0);
+
+	rec->replay_protect = (rec->replay_protect & 0xFFFFFFFE) |
+			      (((packed_record[4] >> 2) & 0x1) << 0);
+
+	rec->anti_replay_window = (rec->anti_replay_window & 0xFFFFE000) |
+				  (((packed_record[4] >> 3) & 0x1FFF) << 0);
+	rec->anti_replay_window = (rec->anti_replay_window & 0xE0001FFF) |
+				  (((packed_record[5] >> 0) & 0xFFFF) << 13);
+	rec->anti_replay_window = (rec->anti_replay_window & 0x1FFFFFFF) |
+				  (((packed_record[6] >> 0) & 0x7) << 29);
+
+	rec->receiving = (rec->receiving & 0xFFFFFFFE) |
+			 (((packed_record[6] >> 3) & 0x1) << 0);
+
+	rec->fresh = (rec->fresh & 0xFFFFFFFE) |
+		     (((packed_record[6] >> 4) & 0x1) << 0);
+
+	rec->an_rol = (rec->an_rol & 0xFFFFFFFE) |
+		      (((packed_record[6] >> 5) & 0x1) << 0);
+
+	rec->reserved = (rec->reserved & 0xFFFFFC00) |
+			(((packed_record[6] >> 6) & 0x3FF) << 0);
+	rec->reserved = (rec->reserved & 0xFE0003FF) |
+			(((packed_record[7] >> 0) & 0x7FFF) << 10);
+
+	rec->valid = (rec->valid & 0xFFFFFFFE) |
+		     (((packed_record[7] >> 15) & 0x1) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_ingress_sc_record(struct aq_hw_s *hw,
+				 struct aq_mss_ingress_sc_record *rec,
+				 u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_ingress_sc_record, hw, rec, table_index);
+}
+
+static int set_ingress_sa_record(struct aq_hw_s *hw,
+				 const struct aq_mss_ingress_sa_record *rec,
+				 u16 table_index)
+{
+	u16 packed_record[8];
+
+	if (table_index >= NUMROWS_INGRESSSARECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 8);
+
+	packed_record[0] = (packed_record[0] & 0x0000) |
+			   (((rec->stop_time >> 0) & 0xFFFF) << 0);
+	packed_record[1] = (packed_record[1] & 0x0000) |
+			   (((rec->stop_time >> 16) & 0xFFFF) << 0);
+
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->start_time >> 0) & 0xFFFF) << 0);
+	packed_record[3] = (packed_record[3] & 0x0000) |
+			   (((rec->start_time >> 16) & 0xFFFF) << 0);
+
+	packed_record[4] = (packed_record[4] & 0x0000) |
+			   (((rec->next_pn >> 0) & 0xFFFF) << 0);
+	packed_record[5] = (packed_record[5] & 0x0000) |
+			   (((rec->next_pn >> 16) & 0xFFFF) << 0);
+
+	packed_record[6] = (packed_record[6] & 0xFFFE) |
+			   (((rec->sat_nextpn >> 0) & 0x1) << 0);
+
+	packed_record[6] =
+		(packed_record[6] & 0xFFFD) | (((rec->in_use >> 0) & 0x1) << 1);
+
+	packed_record[6] =
+		(packed_record[6] & 0xFFFB) | (((rec->fresh >> 0) & 0x1) << 2);
+
+	packed_record[6] = (packed_record[6] & 0x0007) |
+			   (((rec->reserved >> 0) & 0x1FFF) << 3);
+	packed_record[7] = (packed_record[7] & 0x8000) |
+			   (((rec->reserved >> 13) & 0x7FFF) << 0);
+
+	packed_record[7] =
+		(packed_record[7] & 0x7FFF) | (((rec->valid >> 0) & 0x1) << 15);
+
+	return set_raw_ingress_record(hw, packed_record, 8, 3,
+				      ROWOFFSET_INGRESSSARECORD + table_index);
+}
+
+int aq_mss_set_ingress_sa_record(struct aq_hw_s *hw,
+				 const struct aq_mss_ingress_sa_record *rec,
+				 u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_ingress_sa_record, hw, rec, table_index);
+}
+
+static int get_ingress_sa_record(struct aq_hw_s *hw,
+				 struct aq_mss_ingress_sa_record *rec,
+				 u16 table_index)
+{
+	u16 packed_record[8];
+	int ret;
+
+	if (table_index >= NUMROWS_INGRESSSARECORD)
+		return -EINVAL;
+
+	ret = get_raw_ingress_record(hw, packed_record, 8, 3,
+				     ROWOFFSET_INGRESSSARECORD + table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->stop_time = (rec->stop_time & 0xFFFF0000) |
+			 (((packed_record[0] >> 0) & 0xFFFF) << 0);
+	rec->stop_time = (rec->stop_time & 0x0000FFFF) |
+			 (((packed_record[1] >> 0) & 0xFFFF) << 16);
+
+	rec->start_time = (rec->start_time & 0xFFFF0000) |
+			  (((packed_record[2] >> 0) & 0xFFFF) << 0);
+	rec->start_time = (rec->start_time & 0x0000FFFF) |
+			  (((packed_record[3] >> 0) & 0xFFFF) << 16);
+
+	rec->next_pn = (rec->next_pn & 0xFFFF0000) |
+		       (((packed_record[4] >> 0) & 0xFFFF) << 0);
+	rec->next_pn = (rec->next_pn & 0x0000FFFF) |
+		       (((packed_record[5] >> 0) & 0xFFFF) << 16);
+
+	rec->sat_nextpn = (rec->sat_nextpn & 0xFFFFFFFE) |
+			  (((packed_record[6] >> 0) & 0x1) << 0);
+
+	rec->in_use = (rec->in_use & 0xFFFFFFFE) |
+		      (((packed_record[6] >> 1) & 0x1) << 0);
+
+	rec->fresh = (rec->fresh & 0xFFFFFFFE) |
+		     (((packed_record[6] >> 2) & 0x1) << 0);
+
+	rec->reserved = (rec->reserved & 0xFFFFE000) |
+			(((packed_record[6] >> 3) & 0x1FFF) << 0);
+	rec->reserved = (rec->reserved & 0xF0001FFF) |
+			(((packed_record[7] >> 0) & 0x7FFF) << 13);
+
+	rec->valid = (rec->valid & 0xFFFFFFFE) |
+		     (((packed_record[7] >> 15) & 0x1) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_ingress_sa_record(struct aq_hw_s *hw,
+				 struct aq_mss_ingress_sa_record *rec,
+				 u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_ingress_sa_record, hw, rec, table_index);
+}
+
+static int
+set_ingress_sakey_record(struct aq_hw_s *hw,
+			 const struct aq_mss_ingress_sakey_record *rec,
+			 u16 table_index)
+{
+	u16 packed_record[18];
+
+	if (table_index >= NUMROWS_INGRESSSAKEYRECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 18);
+
+	packed_record[0] = (packed_record[0] & 0x0000) |
+			   (((rec->key[0] >> 0) & 0xFFFF) << 0);
+	packed_record[1] = (packed_record[1] & 0x0000) |
+			   (((rec->key[0] >> 16) & 0xFFFF) << 0);
+
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->key[1] >> 0) & 0xFFFF) << 0);
+	packed_record[3] = (packed_record[3] & 0x0000) |
+			   (((rec->key[1] >> 16) & 0xFFFF) << 0);
+
+	packed_record[4] = (packed_record[4] & 0x0000) |
+			   (((rec->key[2] >> 0) & 0xFFFF) << 0);
+	packed_record[5] = (packed_record[5] & 0x0000) |
+			   (((rec->key[2] >> 16) & 0xFFFF) << 0);
+
+	packed_record[6] = (packed_record[6] & 0x0000) |
+			   (((rec->key[3] >> 0) & 0xFFFF) << 0);
+	packed_record[7] = (packed_record[7] & 0x0000) |
+			   (((rec->key[3] >> 16) & 0xFFFF) << 0);
+
+	packed_record[8] = (packed_record[8] & 0x0000) |
+			   (((rec->key[4] >> 0) & 0xFFFF) << 0);
+	packed_record[9] = (packed_record[9] & 0x0000) |
+			   (((rec->key[4] >> 16) & 0xFFFF) << 0);
+
+	packed_record[10] = (packed_record[10] & 0x0000) |
+			    (((rec->key[5] >> 0) & 0xFFFF) << 0);
+	packed_record[11] = (packed_record[11] & 0x0000) |
+			    (((rec->key[5] >> 16) & 0xFFFF) << 0);
+
+	packed_record[12] = (packed_record[12] & 0x0000) |
+			    (((rec->key[6] >> 0) & 0xFFFF) << 0);
+	packed_record[13] = (packed_record[13] & 0x0000) |
+			    (((rec->key[6] >> 16) & 0xFFFF) << 0);
+
+	packed_record[14] = (packed_record[14] & 0x0000) |
+			    (((rec->key[7] >> 0) & 0xFFFF) << 0);
+	packed_record[15] = (packed_record[15] & 0x0000) |
+			    (((rec->key[7] >> 16) & 0xFFFF) << 0);
+
+	packed_record[16] = (packed_record[16] & 0xFFFC) |
+			    (((rec->key_len >> 0) & 0x3) << 0);
+
+	return set_raw_ingress_record(hw, packed_record, 18, 2,
+				      ROWOFFSET_INGRESSSAKEYRECORD +
+					      table_index);
+}
+
+int aq_mss_set_ingress_sakey_record(struct aq_hw_s *hw,
+	const struct aq_mss_ingress_sakey_record *rec,
+	u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_ingress_sakey_record, hw, rec, table_index);
+}
+
+static int get_ingress_sakey_record(struct aq_hw_s *hw,
+				    struct aq_mss_ingress_sakey_record *rec,
+				    u16 table_index)
+{
+	u16 packed_record[18];
+	int ret;
+
+	if (table_index >= NUMROWS_INGRESSSAKEYRECORD)
+		return -EINVAL;
+
+	ret = get_raw_ingress_record(hw, packed_record, 18, 2,
+				     ROWOFFSET_INGRESSSAKEYRECORD +
+					     table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->key[0] = (rec->key[0] & 0xFFFF0000) |
+		      (((packed_record[0] >> 0) & 0xFFFF) << 0);
+	rec->key[0] = (rec->key[0] & 0x0000FFFF) |
+		      (((packed_record[1] >> 0) & 0xFFFF) << 16);
+
+	rec->key[1] = (rec->key[1] & 0xFFFF0000) |
+		      (((packed_record[2] >> 0) & 0xFFFF) << 0);
+	rec->key[1] = (rec->key[1] & 0x0000FFFF) |
+		      (((packed_record[3] >> 0) & 0xFFFF) << 16);
+
+	rec->key[2] = (rec->key[2] & 0xFFFF0000) |
+		      (((packed_record[4] >> 0) & 0xFFFF) << 0);
+	rec->key[2] = (rec->key[2] & 0x0000FFFF) |
+		      (((packed_record[5] >> 0) & 0xFFFF) << 16);
+
+	rec->key[3] = (rec->key[3] & 0xFFFF0000) |
+		      (((packed_record[6] >> 0) & 0xFFFF) << 0);
+	rec->key[3] = (rec->key[3] & 0x0000FFFF) |
+		      (((packed_record[7] >> 0) & 0xFFFF) << 16);
+
+	rec->key[4] = (rec->key[4] & 0xFFFF0000) |
+		      (((packed_record[8] >> 0) & 0xFFFF) << 0);
+	rec->key[4] = (rec->key[4] & 0x0000FFFF) |
+		      (((packed_record[9] >> 0) & 0xFFFF) << 16);
+
+	rec->key[5] = (rec->key[5] & 0xFFFF0000) |
+		      (((packed_record[10] >> 0) & 0xFFFF) << 0);
+	rec->key[5] = (rec->key[5] & 0x0000FFFF) |
+		      (((packed_record[11] >> 0) & 0xFFFF) << 16);
+
+	rec->key[6] = (rec->key[6] & 0xFFFF0000) |
+		      (((packed_record[12] >> 0) & 0xFFFF) << 0);
+	rec->key[6] = (rec->key[6] & 0x0000FFFF) |
+		      (((packed_record[13] >> 0) & 0xFFFF) << 16);
+
+	rec->key[7] = (rec->key[7] & 0xFFFF0000) |
+		      (((packed_record[14] >> 0) & 0xFFFF) << 0);
+	rec->key[7] = (rec->key[7] & 0x0000FFFF) |
+		      (((packed_record[15] >> 0) & 0xFFFF) << 16);
+
+	rec->key_len = (rec->key_len & 0xFFFFFFFC) |
+		       (((packed_record[16] >> 0) & 0x3) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_ingress_sakey_record(struct aq_hw_s *hw,
+				    struct aq_mss_ingress_sakey_record *rec,
+				    u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_ingress_sakey_record, hw, rec, table_index);
+}
+
+static int
+set_ingress_postclass_record(struct aq_hw_s *hw,
+			     const struct aq_mss_ingress_postclass_record *rec,
+			     u16 table_index)
+{
+	u16 packed_record[8];
+
+	if (table_index >= NUMROWS_INGRESSPOSTCLASSRECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 8);
+
+	packed_record[0] =
+		(packed_record[0] & 0xFF00) | (((rec->byte0 >> 0) & 0xFF) << 0);
+
+	packed_record[0] =
+		(packed_record[0] & 0x00FF) | (((rec->byte1 >> 0) & 0xFF) << 8);
+
+	packed_record[1] =
+		(packed_record[1] & 0xFF00) | (((rec->byte2 >> 0) & 0xFF) << 0);
+
+	packed_record[1] =
+		(packed_record[1] & 0x00FF) | (((rec->byte3 >> 0) & 0xFF) << 8);
+
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->eth_type >> 0) & 0xFFFF) << 0);
+
+	packed_record[3] = (packed_record[3] & 0xFFFE) |
+			   (((rec->eth_type_valid >> 0) & 0x1) << 0);
+
+	packed_record[3] = (packed_record[3] & 0xE001) |
+			   (((rec->vlan_id >> 0) & 0xFFF) << 1);
+
+	packed_record[3] = (packed_record[3] & 0x1FFF) |
+			   (((rec->vlan_up >> 0) & 0x7) << 13);
+
+	packed_record[4] = (packed_record[4] & 0xFFFE) |
+			   (((rec->vlan_valid >> 0) & 0x1) << 0);
+
+	packed_record[4] =
+		(packed_record[4] & 0xFFC1) | (((rec->sai >> 0) & 0x1F) << 1);
+
+	packed_record[4] = (packed_record[4] & 0xFFBF) |
+			   (((rec->sai_hit >> 0) & 0x1) << 6);
+
+	packed_record[4] = (packed_record[4] & 0xF87F) |
+			   (((rec->eth_type_mask >> 0) & 0xF) << 7);
+
+	packed_record[4] = (packed_record[4] & 0x07FF) |
+			   (((rec->byte3_location >> 0) & 0x1F) << 11);
+	packed_record[5] = (packed_record[5] & 0xFFFE) |
+			   (((rec->byte3_location >> 5) & 0x1) << 0);
+
+	packed_record[5] = (packed_record[5] & 0xFFF9) |
+			   (((rec->byte3_mask >> 0) & 0x3) << 1);
+
+	packed_record[5] = (packed_record[5] & 0xFE07) |
+			   (((rec->byte2_location >> 0) & 0x3F) << 3);
+
+	packed_record[5] = (packed_record[5] & 0xF9FF) |
+			   (((rec->byte2_mask >> 0) & 0x3) << 9);
+
+	packed_record[5] = (packed_record[5] & 0x07FF) |
+			   (((rec->byte1_location >> 0) & 0x1F) << 11);
+	packed_record[6] = (packed_record[6] & 0xFFFE) |
+			   (((rec->byte1_location >> 5) & 0x1) << 0);
+
+	packed_record[6] = (packed_record[6] & 0xFFF9) |
+			   (((rec->byte1_mask >> 0) & 0x3) << 1);
+
+	packed_record[6] = (packed_record[6] & 0xFE07) |
+			   (((rec->byte0_location >> 0) & 0x3F) << 3);
+
+	packed_record[6] = (packed_record[6] & 0xF9FF) |
+			   (((rec->byte0_mask >> 0) & 0x3) << 9);
+
+	packed_record[6] = (packed_record[6] & 0xE7FF) |
+			   (((rec->eth_type_valid_mask >> 0) & 0x3) << 11);
+
+	packed_record[6] = (packed_record[6] & 0x1FFF) |
+			   (((rec->vlan_id_mask >> 0) & 0x7) << 13);
+	packed_record[7] = (packed_record[7] & 0xFFFE) |
+			   (((rec->vlan_id_mask >> 3) & 0x1) << 0);
+
+	packed_record[7] = (packed_record[7] & 0xFFF9) |
+			   (((rec->vlan_up_mask >> 0) & 0x3) << 1);
+
+	packed_record[7] = (packed_record[7] & 0xFFE7) |
+			   (((rec->vlan_valid_mask >> 0) & 0x3) << 3);
+
+	packed_record[7] = (packed_record[7] & 0xFF9F) |
+			   (((rec->sai_mask >> 0) & 0x3) << 5);
+
+	packed_record[7] = (packed_record[7] & 0xFE7F) |
+			   (((rec->sai_hit_mask >> 0) & 0x3) << 7);
+
+	packed_record[7] = (packed_record[7] & 0xFDFF) |
+			   (((rec->firstlevel_actions >> 0) & 0x1) << 9);
+
+	packed_record[7] = (packed_record[7] & 0xFBFF) |
+			   (((rec->secondlevel_actions >> 0) & 0x1) << 10);
+
+	packed_record[7] = (packed_record[7] & 0x87FF) |
+			   (((rec->reserved >> 0) & 0xF) << 11);
+
+	packed_record[7] =
+		(packed_record[7] & 0x7FFF) | (((rec->valid >> 0) & 0x1) << 15);
+
+	return set_raw_ingress_record(hw, packed_record, 8, 4,
+				      ROWOFFSET_INGRESSPOSTCLASSRECORD +
+					      table_index);
+}
+
+int aq_mss_set_ingress_postclass_record(struct aq_hw_s *hw,
+	const struct aq_mss_ingress_postclass_record *rec,
+	u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_ingress_postclass_record, hw, rec,
+				table_index);
+}
+
+static int
+get_ingress_postclass_record(struct aq_hw_s *hw,
+			     struct aq_mss_ingress_postclass_record *rec,
+			     u16 table_index)
+{
+	u16 packed_record[8];
+	int ret;
+
+	if (table_index >= NUMROWS_INGRESSPOSTCLASSRECORD)
+		return -EINVAL;
+
+	/* If the row that we want to read is odd, first read the previous even
+	 * row, throw that value away, and finally read the desired row.
+	 */
+	if ((table_index % 2) > 0) {
+		ret = get_raw_ingress_record(hw, packed_record, 8, 4,
+					     ROWOFFSET_INGRESSPOSTCLASSRECORD +
+						     table_index - 1);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	ret = get_raw_ingress_record(hw, packed_record, 8, 4,
+				     ROWOFFSET_INGRESSPOSTCLASSRECORD +
+					     table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->byte0 = (rec->byte0 & 0xFFFFFF00) |
+		     (((packed_record[0] >> 0) & 0xFF) << 0);
+
+	rec->byte1 = (rec->byte1 & 0xFFFFFF00) |
+		     (((packed_record[0] >> 8) & 0xFF) << 0);
+
+	rec->byte2 = (rec->byte2 & 0xFFFFFF00) |
+		     (((packed_record[1] >> 0) & 0xFF) << 0);
+
+	rec->byte3 = (rec->byte3 & 0xFFFFFF00) |
+		     (((packed_record[1] >> 8) & 0xFF) << 0);
+
+	rec->eth_type = (rec->eth_type & 0xFFFF0000) |
+			(((packed_record[2] >> 0) & 0xFFFF) << 0);
+
+	rec->eth_type_valid = (rec->eth_type_valid & 0xFFFFFFFE) |
+			      (((packed_record[3] >> 0) & 0x1) << 0);
+
+	rec->vlan_id = (rec->vlan_id & 0xFFFFF000) |
+		       (((packed_record[3] >> 1) & 0xFFF) << 0);
+
+	rec->vlan_up = (rec->vlan_up & 0xFFFFFFF8) |
+		       (((packed_record[3] >> 13) & 0x7) << 0);
+
+	rec->vlan_valid = (rec->vlan_valid & 0xFFFFFFFE) |
+			  (((packed_record[4] >> 0) & 0x1) << 0);
+
+	rec->sai = (rec->sai & 0xFFFFFFE0) |
+		   (((packed_record[4] >> 1) & 0x1F) << 0);
+
+	rec->sai_hit = (rec->sai_hit & 0xFFFFFFFE) |
+		       (((packed_record[4] >> 6) & 0x1) << 0);
+
+	rec->eth_type_mask = (rec->eth_type_mask & 0xFFFFFFF0) |
+			     (((packed_record[4] >> 7) & 0xF) << 0);
+
+	rec->byte3_location = (rec->byte3_location & 0xFFFFFFE0) |
+			      (((packed_record[4] >> 11) & 0x1F) << 0);
+	rec->byte3_location = (rec->byte3_location & 0xFFFFFFDF) |
+			      (((packed_record[5] >> 0) & 0x1) << 5);
+
+	rec->byte3_mask = (rec->byte3_mask & 0xFFFFFFFC) |
+			  (((packed_record[5] >> 1) & 0x3) << 0);
+
+	rec->byte2_location = (rec->byte2_location & 0xFFFFFFC0) |
+			      (((packed_record[5] >> 3) & 0x3F) << 0);
+
+	rec->byte2_mask = (rec->byte2_mask & 0xFFFFFFFC) |
+			  (((packed_record[5] >> 9) & 0x3) << 0);
+
+	rec->byte1_location = (rec->byte1_location & 0xFFFFFFE0) |
+			      (((packed_record[5] >> 11) & 0x1F) << 0);
+	rec->byte1_location = (rec->byte1_location & 0xFFFFFFDF) |
+			      (((packed_record[6] >> 0) & 0x1) << 5);
+
+	rec->byte1_mask = (rec->byte1_mask & 0xFFFFFFFC) |
+			  (((packed_record[6] >> 1) & 0x3) << 0);
+
+	rec->byte0_location = (rec->byte0_location & 0xFFFFFFC0) |
+			      (((packed_record[6] >> 3) & 0x3F) << 0);
+
+	rec->byte0_mask = (rec->byte0_mask & 0xFFFFFFFC) |
+			  (((packed_record[6] >> 9) & 0x3) << 0);
+
+	rec->eth_type_valid_mask = (rec->eth_type_valid_mask & 0xFFFFFFFC) |
+				   (((packed_record[6] >> 11) & 0x3) << 0);
+
+	rec->vlan_id_mask = (rec->vlan_id_mask & 0xFFFFFFF8) |
+			    (((packed_record[6] >> 13) & 0x7) << 0);
+	rec->vlan_id_mask = (rec->vlan_id_mask & 0xFFFFFFF7) |
+			    (((packed_record[7] >> 0) & 0x1) << 3);
+
+	rec->vlan_up_mask = (rec->vlan_up_mask & 0xFFFFFFFC) |
+			    (((packed_record[7] >> 1) & 0x3) << 0);
+
+	rec->vlan_valid_mask = (rec->vlan_valid_mask & 0xFFFFFFFC) |
+			       (((packed_record[7] >> 3) & 0x3) << 0);
+
+	rec->sai_mask = (rec->sai_mask & 0xFFFFFFFC) |
+			(((packed_record[7] >> 5) & 0x3) << 0);
+
+	rec->sai_hit_mask = (rec->sai_hit_mask & 0xFFFFFFFC) |
+			    (((packed_record[7] >> 7) & 0x3) << 0);
+
+	rec->firstlevel_actions = (rec->firstlevel_actions & 0xFFFFFFFE) |
+				  (((packed_record[7] >> 9) & 0x1) << 0);
+
+	rec->secondlevel_actions = (rec->secondlevel_actions & 0xFFFFFFFE) |
+				   (((packed_record[7] >> 10) & 0x1) << 0);
+
+	rec->reserved = (rec->reserved & 0xFFFFFFF0) |
+			(((packed_record[7] >> 11) & 0xF) << 0);
+
+	rec->valid = (rec->valid & 0xFFFFFFFE) |
+		     (((packed_record[7] >> 15) & 0x1) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_ingress_postclass_record(struct aq_hw_s *hw,
+	struct aq_mss_ingress_postclass_record *rec,
+	u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_ingress_postclass_record, hw, rec,
+				table_index);
+}
+
+static int
+set_ingress_postctlf_record(struct aq_hw_s *hw,
+			    const struct aq_mss_ingress_postctlf_record *rec,
+			    u16 table_index)
+{
+	u16 packed_record[6];
+
+	if (table_index >= NUMROWS_INGRESSPOSTCTLFRECORD)
+		return -EINVAL;
+
+	memset(packed_record, 0, sizeof(u16) * 6);
+
+	packed_record[0] = (packed_record[0] & 0x0000) |
+			   (((rec->sa_da[0] >> 0) & 0xFFFF) << 0);
+	packed_record[1] = (packed_record[1] & 0x0000) |
+			   (((rec->sa_da[0] >> 16) & 0xFFFF) << 0);
+
+	packed_record[2] = (packed_record[2] & 0x0000) |
+			   (((rec->sa_da[1] >> 0) & 0xFFFF) << 0);
+
+	packed_record[3] = (packed_record[3] & 0x0000) |
+			   (((rec->eth_type >> 0) & 0xFFFF) << 0);
+
+	packed_record[4] = (packed_record[4] & 0x0000) |
+			   (((rec->match_mask >> 0) & 0xFFFF) << 0);
+
+	packed_record[5] = (packed_record[5] & 0xFFF0) |
+			   (((rec->match_type >> 0) & 0xF) << 0);
+
+	packed_record[5] =
+		(packed_record[5] & 0xFFEF) | (((rec->action >> 0) & 0x1) << 4);
+
+	return set_raw_ingress_record(hw, packed_record, 6, 5,
+				      ROWOFFSET_INGRESSPOSTCTLFRECORD +
+					      table_index);
+}
+
+int aq_mss_set_ingress_postctlf_record(struct aq_hw_s *hw,
+	const struct aq_mss_ingress_postctlf_record *rec,
+	u16 table_index)
+{
+	return AQ_API_CALL_SAFE(set_ingress_postctlf_record, hw, rec,
+				table_index);
+}
+
+static int
+get_ingress_postctlf_record(struct aq_hw_s *hw,
+			    struct aq_mss_ingress_postctlf_record *rec,
+			    u16 table_index)
+{
+	u16 packed_record[6];
+	int ret;
+
+	if (table_index >= NUMROWS_INGRESSPOSTCTLFRECORD)
+		return -EINVAL;
+
+	/* If the row that we want to read is odd, first read the previous even
+	 * row, throw that value away, and finally read the desired row.
+	 */
+	if ((table_index % 2) > 0) {
+		ret = get_raw_ingress_record(hw, packed_record, 6, 5,
+					     ROWOFFSET_INGRESSPOSTCTLFRECORD +
+						     table_index - 1);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	ret = get_raw_ingress_record(hw, packed_record, 6, 5,
+				     ROWOFFSET_INGRESSPOSTCTLFRECORD +
+					     table_index);
+	if (unlikely(ret))
+		return ret;
+
+	rec->sa_da[0] = (rec->sa_da[0] & 0xFFFF0000) |
+			(((packed_record[0] >> 0) & 0xFFFF) << 0);
+	rec->sa_da[0] = (rec->sa_da[0] & 0x0000FFFF) |
+			(((packed_record[1] >> 0) & 0xFFFF) << 16);
+
+	rec->sa_da[1] = (rec->sa_da[1] & 0xFFFF0000) |
+			(((packed_record[2] >> 0) & 0xFFFF) << 0);
+
+	rec->eth_type = (rec->eth_type & 0xFFFF0000) |
+			(((packed_record[3] >> 0) & 0xFFFF) << 0);
+
+	rec->match_mask = (rec->match_mask & 0xFFFF0000) |
+			  (((packed_record[4] >> 0) & 0xFFFF) << 0);
+
+	rec->match_type = (rec->match_type & 0xFFFFFFF0) |
+			  (((packed_record[5] >> 0) & 0xF) << 0);
+
+	rec->action = (rec->action & 0xFFFFFFFE) |
+		      (((packed_record[5] >> 4) & 0x1) << 0);
+
+	return 0;
+}
+
+int aq_mss_get_ingress_postctlf_record(struct aq_hw_s *hw,
+	struct aq_mss_ingress_postctlf_record *rec,
+	u16 table_index)
+{
+	memset(rec, 0, sizeof(*rec));
+
+	return AQ_API_CALL_SAFE(get_ingress_postctlf_record, hw, rec,
+				table_index);
+}
+
 static int set_egress_ctlf_record(struct aq_hw_s *hw,
 				  const struct aq_mss_egress_ctlf_record *rec,
 				  u16 table_index)
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
index cbc1226ae0d7..ab5415f99a32 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_api.h
@@ -9,6 +9,27 @@
 #include "aq_hw.h"
 #include "macsec_struct.h"
 
+#define NUMROWS_INGRESSPRECTLFRECORD 24
+#define ROWOFFSET_INGRESSPRECTLFRECORD 0
+
+#define NUMROWS_INGRESSPRECLASSRECORD 48
+#define ROWOFFSET_INGRESSPRECLASSRECORD 0
+
+#define NUMROWS_INGRESSPOSTCLASSRECORD 48
+#define ROWOFFSET_INGRESSPOSTCLASSRECORD 0
+
+#define NUMROWS_INGRESSSCRECORD 32
+#define ROWOFFSET_INGRESSSCRECORD 0
+
+#define NUMROWS_INGRESSSARECORD 32
+#define ROWOFFSET_INGRESSSARECORD 32
+
+#define NUMROWS_INGRESSSAKEYRECORD 32
+#define ROWOFFSET_INGRESSSAKEYRECORD 0
+
+#define NUMROWS_INGRESSPOSTCTLFRECORD 24
+#define ROWOFFSET_INGRESSPOSTCTLFRECORD 0
+
 #define NUMROWS_EGRESSCTLFRECORD 24
 #define ROWOFFSET_EGRESSCTLFRECORD 0
 
@@ -114,6 +135,133 @@ int aq_mss_set_egress_sakey_record(struct aq_hw_s *hw,
 				   const struct aq_mss_egress_sakey_record *rec,
 				   u16 table_index);
 
+/*!  Read the raw table data from the specified row of the Ingress
+ *   Pre-MACSec CTL Filter table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 23).
+ */
+int aq_mss_get_ingress_prectlf_record(struct aq_hw_s *hw,
+				      struct aq_mss_ingress_prectlf_record *rec,
+				      u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Ingress Pre-MACSec CTL Filter table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write(max 23).
+ */
+int aq_mss_set_ingress_prectlf_record(struct aq_hw_s *hw,
+	const struct aq_mss_ingress_prectlf_record *rec,
+	u16 table_index);
+
+/*!  Read the raw table data from the specified row of the Ingress
+ *   Pre-MACSec Packet Classifier table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 47).
+ */
+int aq_mss_get_ingress_preclass_record(struct aq_hw_s *hw,
+	struct aq_mss_ingress_preclass_record *rec,
+	u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Ingress Pre-MACSec Packet Classifier table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write(max 47).
+ */
+int aq_mss_set_ingress_preclass_record(struct aq_hw_s *hw,
+	const struct aq_mss_ingress_preclass_record *rec,
+	u16 table_index);
+
+/*!  Read the raw table data from the specified row of the Ingress SC
+ *   Lookup table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 31).
+ */
+int aq_mss_get_ingress_sc_record(struct aq_hw_s *hw,
+				 struct aq_mss_ingress_sc_record *rec,
+				 u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Ingress SC Lookup table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write(max 31).
+ */
+int aq_mss_set_ingress_sc_record(struct aq_hw_s *hw,
+				 const struct aq_mss_ingress_sc_record *rec,
+				 u16 table_index);
+
+/*!  Read the raw table data from the specified row of the Ingress SA
+ *   Lookup table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 31).
+ */
+int aq_mss_get_ingress_sa_record(struct aq_hw_s *hw,
+				 struct aq_mss_ingress_sa_record *rec,
+				 u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Ingress SA Lookup table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write(max 31).
+ */
+int aq_mss_set_ingress_sa_record(struct aq_hw_s *hw,
+				 const struct aq_mss_ingress_sa_record *rec,
+				 u16 table_index);
+
+/*!  Read the raw table data from the specified row of the Ingress SA
+ *   Key Lookup table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 31).
+ */
+int aq_mss_get_ingress_sakey_record(struct aq_hw_s *hw,
+				    struct aq_mss_ingress_sakey_record *rec,
+				    u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Ingress SA Key Lookup table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write(max 31).
+ */
+int aq_mss_set_ingress_sakey_record(struct aq_hw_s *hw,
+	const struct aq_mss_ingress_sakey_record *rec,
+	u16 table_index);
+
+/*!  Read the raw table data from the specified row of the Ingress
+ *   Post-MACSec Packet Classifier table, and unpack it into the
+ *   fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 48).
+ */
+int aq_mss_get_ingress_postclass_record(struct aq_hw_s *hw,
+	struct aq_mss_ingress_postclass_record *rec,
+	u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Ingress Post-MACSec Packet Classifier table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write(max 48).
+ */
+int aq_mss_set_ingress_postclass_record(struct aq_hw_s *hw,
+	const struct aq_mss_ingress_postclass_record *rec,
+	u16 table_index);
+
+/*!  Read the raw table data from the specified row of the Ingress
+ *   Post-MACSec CTL Filter table, and unpack it into the fields of rec.
+ *  rec - [OUT] The raw table row data will be unpacked into the fields of rec.
+ *  table_index - The table row to read (max 23).
+ */
+int aq_mss_get_ingress_postctlf_record(struct aq_hw_s *hw,
+	struct aq_mss_ingress_postctlf_record *rec,
+	u16 table_index);
+
+/*!  Pack the fields of rec, and write the packed data into the
+ *   specified row of the Ingress Post-MACSec CTL Filter table.
+ *  rec - [IN] The bitfield values to write to the table row.
+ *  table_index - The table row to write(max 23).
+ */
+int aq_mss_set_ingress_postctlf_record(struct aq_hw_s *hw,
+	const struct aq_mss_ingress_postctlf_record *rec,
+	u16 table_index);
+
 /*!  Get Egress SA expired. */
 int aq_mss_get_egress_sa_expired(struct aq_hw_s *hw, u32 *expired);
 /*!  Get Egress SA threshold expired. */
diff --git a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
index 7232bec643db..8c38a3470518 100644
--- a/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
+++ b/drivers/net/ethernet/aquantia/atlantic/macsec/macsec_struct.h
@@ -314,4 +314,387 @@ struct aq_mss_egress_sakey_record {
 	u32 key[8];
 };
 
+/*! Represents the bitfields of a single row in the Ingress Pre-MACSec
+ *  CTL Filter table.
+ */
+struct aq_mss_ingress_prectlf_record {
+	/*! This is used to store the 48 bit value used to compare SA, DA
+	 *  or halfDA+half SA value.
+	 */
+	u32 sa_da[2];
+	/*! This is used to store the 16 bit ethertype value used for
+	 *  comparison.
+	 */
+	u32 eth_type;
+	/*! The match mask is per-nibble. 0 means don't care, i.e. every
+	 *  value will match successfully. The total data is 64 bit, i.e.
+	 *  16 nibbles masks.
+	 */
+	u32 match_mask;
+	/*! 0: No compare, i.e. This entry is not used
+	 *  1: compare DA only
+	 *  2: compare SA only
+	 *  3: compare half DA + half SA
+	 *  4: compare ether type only
+	 *  5: compare DA + ethertype
+	 *  6: compare SA + ethertype
+	 *  7: compare DA+ range.
+	 */
+	u32 match_type;
+	/*! 0: Bypass the remaining modules if matched.
+	 *  1: Forward to next module for more classifications.
+	 */
+	u32 action;
+};
+
+/*! Represents the bitfields of a single row in the Ingress Pre-MACSec
+ *  Packet Classifier table.
+ */
+struct aq_mss_ingress_preclass_record {
+	/*! The 64 bit SCI field used to compare with extracted value.
+	 *  Should have SCI value in case TCI[SCI_SEND] == 0. This will be
+	 *  used for ICV calculation.
+	 */
+	u32 sci[2];
+	/*! The 8 bit TCI field used to compare with extracted value. */
+	u32 tci;
+	/*! 8 bit encryption offset. */
+	u32 encr_offset;
+	/*! The 16 bit Ethertype (in the clear) field used to compare with
+	 *  extracted value.
+	 */
+	u32 eth_type;
+	/*! This is to specify the 40bit SNAP header if the SNAP header's
+	 *  mask is enabled.
+	 */
+	u32 snap[2];
+	/*! This is to specify the 24bit LLC header if the LLC header's
+	 *  mask is enabled.
+	 */
+	u32 llc;
+	/*! The 48 bit MAC_SA field used to compare with extracted value. */
+	u32 mac_sa[2];
+	/*! The 48 bit MAC_DA field used to compare with extracted value. */
+	u32 mac_da[2];
+	/*! 0: this is to compare with non-LPBK packet
+	 *  1: this is to compare with LPBK packet.
+	 *  This value is used to compare with a controlled-tag which goes
+	 *  with the packet when looped back from Egress port.
+	 */
+	u32 lpbk_packet;
+	/*! The value of this bit mask will affects how the SC index and SA
+	 *  index created.
+	 *  2'b00: 1 SC has 4 SA.
+	 *    SC index is equivalent to {SC_Index[4:2], 1'b0}.
+	 *    SA index is equivalent to {SC_Index[4:2], SECTAG's AN[1:0]}
+	 *    Here AN bits are not compared.
+	 *  2'b10: 1 SC has 2 SA.
+	 *    SC index is equivalent to SC_Index[4:1]
+	 *    SA index is equivalent to {SC_Index[4:1], SECTAG's AN[0]}
+	 *    Compare AN[1] field only
+	 *  2'b11: 1 SC has 1 SA. No SC entry exists for the specific SA.
+	 *    SA index is equivalent to SC_Index[4:0]
+	 *    AN[1:0] bits are compared.
+	 *    NOTE: This design is to supports different usage of AN. User
+	 *    can either ping-pong buffer 2 SA by using only the AN[0] bit.
+	 *    Or use 4 SA per SC by use AN[1:0] bits. Or even treat each SA
+	 *    as independent. i.e. AN[1:0] is just another matching pointer
+	 *    to select SA.
+	 */
+	u32 an_mask;
+	/*! This is bit mask to enable comparison the upper 6 bits TCI
+	 *  field, which does not include the AN field.
+	 *  0: don't compare
+	 *  1: enable comparison of the bits.
+	 */
+	u32 tci_mask;
+	/*! 0: don't care
+	 *  1: enable comparison of SCI.
+	 */
+	u32 sci_mask;
+	/*! Mask is per-byte.
+	 *  0: don't care
+	 *  1: enable comparison of Ethertype.
+	 */
+	u32 eth_type_mask;
+	/*! Mask is per-byte.
+	 *  0: don't care and no SNAP header exist.
+	 *  1: compare the SNAP header.
+	 *  If this bit is set to 1, the extracted filed will assume the
+	 *  SNAP header exist as encapsulated in 802.3 (RFC 1042). I.E. the
+	 *  next 5 bytes after the the LLC header is SNAP header.
+	 */
+	u32 snap_mask;
+	/*! Mask is per-byte.
+	 *  0: don't care and no LLC header exist.
+	 *  1: compare the LLC header.
+	 *  If this bit is set to 1, the extracted filed will assume the
+	 *  LLC header exist as encapsulated in 802.3 (RFC 1042). I.E. the
+	 *  next three bytes after the 802.3MAC header is LLC header.
+	 */
+	u32 llc_mask;
+	/*! Reserved. This bit should be always 0. */
+	u32 _802_2_encapsulate;
+	/*! Mask is per-byte.
+	 *  0: don't care
+	 *  1: enable comparison of MAC_SA.
+	 */
+	u32 sa_mask;
+	/*! Mask is per-byte.
+	 *  0: don't care
+	 *  1: enable comparison of MAC_DA.
+	 */
+	u32 da_mask;
+	/*! 0: don't care
+	 *  1: enable checking if this is loopback packet or not.
+	 */
+	u32 lpbk_mask;
+	/*! If packet matches and tagged as controlled-packet. This SC/SA
+	 *  index is used for later SC and SA table lookup.
+	 */
+	u32 sc_idx;
+	/*! 0: the packets will be sent to MAC FIFO
+	 *  1: The packets will be sent to Debug/Loopback FIFO.
+	 *  If the above's action is drop. This bit has no meaning.
+	 */
+	u32 proc_dest;
+	/*! 0: Process: Forward to next two modules for 802.1AE decryption.
+	 *  1: Process but keep SECTAG: Forward to next two modules for
+	 *     802.1AE decryption but keep the MACSEC header with added error
+	 *     code information. ICV will be stripped for all control packets.
+	 *  2: Bypass: Bypass the next two decryption modules but processed
+	 *     by post-classification.
+	 *  3: Drop: drop this packet and update counts accordingly.
+	 */
+	u32 action;
+	/*! 0: This is a controlled-port packet if matched.
+	 *  1: This is an uncontrolled-port packet if matched.
+	 */
+	u32 ctrl_unctrl;
+	/*! Use the SCI value from the Table if 'SC' bit of the input
+	 *  packet is not present.
+	 */
+	u32 sci_from_table;
+	/*! Reserved. */
+	u32 reserved;
+	/*! 0: Not valid entry. This entry is not used
+	 *  1: valid entry.
+	 */
+	u32 valid;
+};
+
+/*! Represents the bitfields of a single row in the Ingress SC Lookup table. */
+struct aq_mss_ingress_sc_record {
+	/*! This is to specify when the SC was first used. Set by HW. */
+	u32 stop_time;
+	/*! This is to specify when the SC was first used. Set by HW. */
+	u32 start_time;
+	/*! 0: Strict
+	 *  1: Check
+	 *  2: Disabled.
+	 */
+	u32 validate_frames;
+	/*! 1: Replay control enabled.
+	 *  0: replay control disabled.
+	 */
+	u32 replay_protect;
+	/*! This is to specify the window range for anti-replay. Default is 0.
+	 *  0: is strict order enforcement.
+	 */
+	u32 anti_replay_window;
+	/*! 0: when none of the SA related to SC has inUse set.
+	 *  1: when either of the SA related to the SC has inUse set.
+	 *  This bit is set by HW.
+	 */
+	u32 receiving;
+	/*! 0: when hardware processed the SC for the first time, it clears
+	 *     this bit
+	 *  1: This bit is set by SW, when it sets up the SC.
+	 */
+	u32 fresh;
+	/*! 0: The AN number will not automatically roll over if Next_PN is
+	 *     saturated.
+	 *  1: The AN number will automatically roll over if Next_PN is
+	 *     saturated.
+	 *  Rollover is valid only after expiry. Normal roll over between
+	 *  SA's should be normal process.
+	 */
+	u32 an_rol;
+	/*! Reserved. */
+	u32 reserved;
+	/*! 0: Invalid SC
+	 *  1: Valid SC.
+	 */
+	u32 valid;
+};
+
+/*! Represents the bitfields of a single row in the Ingress SA Lookup table. */
+struct aq_mss_ingress_sa_record {
+	/*! This is to specify when the SC was first used. Set by HW. */
+	u32 stop_time;
+	/*! This is to specify when the SC was first used. Set by HW. */
+	u32 start_time;
+	/*! This is updated by HW to store the expected NextPN number for
+	 *  anti-replay.
+	 */
+	u32 next_pn;
+	/*! The Next_PN number is going to wrapped around from 0XFFFF_FFFF
+	 *  to 0. set by HW.
+	 */
+	u32 sat_nextpn;
+	/*! 0: This SA is not yet used.
+	 *  1: This SA is inUse.
+	 */
+	u32 in_use;
+	/*! 0: when hardware processed the SC for the first time, it clears
+	 *     this timer
+	 *  1: This bit is set by SW, when it sets up the SC.
+	 */
+	u32 fresh;
+	/*! Reserved. */
+	u32 reserved;
+	/*! 0: Invalid SA.
+	 *  1: Valid SA.
+	 */
+	u32 valid;
+};
+
+/*! Represents the bitfields of a single row in the Ingress SA Key
+ *  Lookup table.
+ */
+struct aq_mss_ingress_sakey_record {
+	/*! Key for AES-GCM processing. */
+	u32 key[8];
+	/*! AES key size
+	 *  00 - 128bits
+	 *  01 - 192bits
+	 *  10 - 256bits
+	 *  11 - reserved.
+	 */
+	u32 key_len;
+};
+
+/*! Represents the bitfields of a single row in the Ingress Post-
+ *  MACSec Packet Classifier table.
+ */
+struct aq_mss_ingress_postclass_record {
+	/*! The 8 bit value used to compare with extracted value for byte 0. */
+	u32 byte0;
+	/*! The 8 bit value used to compare with extracted value for byte 1. */
+	u32 byte1;
+	/*! The 8 bit value used to compare with extracted value for byte 2. */
+	u32 byte2;
+	/*! The 8 bit value used to compare with extracted value for byte 3. */
+	u32 byte3;
+	/*! Ethertype in the packet. */
+	u32 eth_type;
+	/*! Ether Type value > 1500 (0x5dc). */
+	u32 eth_type_valid;
+	/*! VLAN ID after parsing. */
+	u32 vlan_id;
+	/*! VLAN priority after parsing. */
+	u32 vlan_up;
+	/*! Valid VLAN coding. */
+	u32 vlan_valid;
+	/*! SA index. */
+	u32 sai;
+	/*! SAI hit, i.e. controlled packet. */
+	u32 sai_hit;
+	/*! Mask for payload ethertype field. */
+	u32 eth_type_mask;
+	/*! 0~63: byte location used extracted by packets comparator, which
+	 *  can be anything from the first 64 bytes of the MAC packets.
+	 *  This byte location counted from MAC' DA address. i.e. set to 0
+	 *  will point to byte 0 of DA address.
+	 */
+	u32 byte3_location;
+	/*! Mask for Byte Offset 3. */
+	u32 byte3_mask;
+	/*! 0~63: byte location used extracted by packets comparator, which
+	 *  can be anything from the first 64 bytes of the MAC packets.
+	 *  This byte location counted from MAC' DA address. i.e. set to 0
+	 *  will point to byte 0 of DA address.
+	 */
+	u32 byte2_location;
+	/*! Mask for Byte Offset 2. */
+	u32 byte2_mask;
+	/*! 0~63: byte location used extracted by packets comparator, which
+	 *  can be anything from the first 64 bytes of the MAC packets.
+	 *  This byte location counted from MAC' DA address. i.e. set to 0
+	 *  will point to byte 0 of DA address.
+	 */
+	u32 byte1_location;
+	/*! Mask for Byte Offset 1. */
+	u32 byte1_mask;
+	/*! 0~63: byte location used extracted by packets comparator, which
+	 *  can be anything from the first 64 bytes of the MAC packets.
+	 *  This byte location counted from MAC' DA address. i.e. set to 0
+	 *  will point to byte 0 of DA address.
+	 */
+	u32 byte0_location;
+	/*! Mask for Byte Offset 0. */
+	u32 byte0_mask;
+	/*! Mask for Ethertype valid field. Indicates 802.3 vs. Other. */
+	u32 eth_type_valid_mask;
+	/*! Mask for VLAN ID field. */
+	u32 vlan_id_mask;
+	/*! Mask for VLAN UP field. */
+	u32 vlan_up_mask;
+	/*! Mask for VLAN valid field. */
+	u32 vlan_valid_mask;
+	/*! Mask for SAI. */
+	u32 sai_mask;
+	/*! Mask for SAI_HIT. */
+	u32 sai_hit_mask;
+	/*! Action if only first level matches and second level does not.
+	 *  0: pass
+	 *  1: drop (fail).
+	 */
+	u32 firstlevel_actions;
+	/*! Action if both first and second level matched.
+	 *  0: pass
+	 *  1: drop (fail).
+	 */
+	u32 secondlevel_actions;
+	/*! Reserved. */
+	u32 reserved;
+	/*! 0: Not valid entry. This entry is not used
+	 *  1: valid entry.
+	 */
+	u32 valid;
+};
+
+/*! Represents the bitfields of a single row in the Ingress Post-
+ *  MACSec CTL Filter table.
+ */
+struct aq_mss_ingress_postctlf_record {
+	/*! This is used to store the 48 bit value used to compare SA, DA
+	 *  or halfDA+half SA value.
+	 */
+	u32 sa_da[2];
+	/*! This is used to store the 16 bit ethertype value used for
+	 *  comparison.
+	 */
+	u32 eth_type;
+	/*! The match mask is per-nibble. 0 means don't care, i.e. every
+	 *  value will match successfully. The total data is 64 bit, i.e.
+	 *  16 nibbles masks.
+	 */
+	u32 match_mask;
+	/*! 0: No compare, i.e. This entry is not used
+	 *  1: compare DA only
+	 *  2: compare SA only
+	 *  3: compare half DA + half SA
+	 *  4: compare ether type only
+	 *  5: compare DA + ethertype
+	 *  6: compare SA + ethertype
+	 *  7: compare DA+ range.
+	 */
+	u32 match_type;
+	/*! 0: Bypass the remaining modules if matched.
+	 *  1: Forward to next module for more classifications.
+	 */
+	u32 action;
+};
+
 #endif
-- 
2.17.1

