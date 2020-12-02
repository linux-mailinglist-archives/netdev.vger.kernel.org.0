Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04932CC9A4
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727185AbgLBWcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:32:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgLBWcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:32:41 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A9FC0613D6;
        Wed,  2 Dec 2020 14:32:16 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id z12so419712pjn.1;
        Wed, 02 Dec 2020 14:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AQ4gA2y/PYlwXj67l9+499A4y1Bq+vXQAK09BGlvH2k=;
        b=P7H+UR5MpF3y9get2WITTgJQM+PPq2OIRRHQQDj0IVOItEOeTU4ry9RtD2DIBiQWYJ
         cUEn9bSHi3VU2vMF7K4khbh0ka12gwpFT7xCp+FkjtubQgLVanOd8trSrIOaNBfoeVtq
         uXKOr3SgyiU3iUZHS0kx6xcw4SIDis7ZcIFkzuzGjBriYwdHrXXCUYjoFbA0s/pqdRSw
         r5XllWbGv1bOUJQBn3QWVfAykUr9EJ/IXlIf1KtXcGKlK13sSWYubVBt0L7GIcESNB16
         mGH6k/7xleNEKbnuJgrNFRM5dFr1+R/cn37tM6Eb/TGtEYreZDf5Xg922//oDLwg2pmV
         hrXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AQ4gA2y/PYlwXj67l9+499A4y1Bq+vXQAK09BGlvH2k=;
        b=gFHdGOu8B0UDI3oM3QSl5491E00GF2gNRibpZJdUtwrcNvYK9FZuiLPBhJvPntz0gb
         5oLV7Q6V9+NdAMYPYujVe02p8KFYkWsuMmgDvhk1vPje+3dROufiob9SYBfaWiDU6W4/
         3DLaAeBckVW8+ZXPQ9pFJQSV+cKV/1whPYHdZ/3NOGepa5tssBcuyqjNyTmUD68LcnLw
         ir78M86zU9P2jUzRFLgMpjuIJbHrxMX4hHIMnFekZqqr407qjIlplI6VkD4Snpvtn1EC
         DcvyzllO70s0doLHTOAm0RKZXR1nDmhCQhaNs7bYNuT3zrJc2rUarGwa2qBwd8bhus1S
         24Fw==
X-Gm-Message-State: AOAM533sdJP+hPpZIwiy89sM944UC1FJ+OgB/kdz/X+bFxMgkwMS7Y/S
        ToRIl5/Q6gLkXhWIzlsrPfzHBy9dSyU=
X-Google-Smtp-Source: ABdhPJwp4rsi8VLYmo6X1EePuO0MbysplY6M9ZNRBwQ6cLH6D6x1lZpD5CLv3me3v2Rr5Nur3xMQ0Q==
X-Received: by 2002:a17:90a:62c8:: with SMTP id k8mr128892pjs.33.1606948335542;
        Wed, 02 Dec 2020 14:32:15 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id q23sm90742pfg.192.2020.12.02.14.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 14:32:14 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     kuba@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next v4] net/nfc/nci: Support NCI 2.x initial sequence
Date:   Thu,  3 Dec 2020 07:31:47 +0900
Message-Id: <20201202223147.3472-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

implement the NCI 2.x initial sequence to support NCI 2.x NFCC.
Since NCI 2.0, CORE_RESET and CORE_INIT sequence have been changed.
If NFCEE supports NCI 2.x, then NCI 2.x initial sequence will work.

In NCI 1.0, Initial sequence and payloads are as below:
(DH)                     (NFCC)
 |  -- CORE_RESET_CMD --> |
 |  <-- CORE_RESET_RSP -- |
 |  -- CORE_INIT_CMD -->  |
 |  <-- CORE_INIT_RSP --  |
 CORE_RESET_RSP payloads are Status, NCI version, Configuration Status.
 CORE_INIT_CMD payloads are empty.
 CORE_INIT_RSP payloads are Status, NFCC Features,
    Number of Supported RF Interfaces, Supported RF Interface,
    Max Logical Connections, Max Routing table Size,
    Max Control Packet Payload Size, Max Size for Large Parameters,
    Manufacturer ID, Manufacturer Specific Information.

In NCI 2.0, Initial Sequence and Parameters are as below:
(DH)                     (NFCC)
 |  -- CORE_RESET_CMD --> |
 |  <-- CORE_RESET_RSP -- |
 |  <-- CORE_RESET_NTF -- |
 |  -- CORE_INIT_CMD -->  |
 |  <-- CORE_INIT_RSP --  |
 CORE_RESET_RSP payloads are Status.
 CORE_RESET_NTF payloads are Reset Trigger,
    Configuration Status, NCI Version, Manufacturer ID,
    Manufacturer Specific Information Length,
    Manufacturer Specific Information.
 CORE_INIT_CMD payloads are Feature1, Feature2.
 CORE_INIT_RSP payloads are Status, NFCC Features,
    Max Logical Connections, Max Routing Table Size,
    Max Control Packet Payload Size,
    Max Data Packet Payload Size of the Static HCI Connection,
    Number of Credits of the Static HCI Connection,
    Max NFC-V RF Frame Size, Number of Supported RF Interfaces,
    Supported RF Interfaces.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---

 Changes in v4:
  - remove the unnecessary empty line.
  - pull out the common code.
  - change the unsigned char to u8.
  - order the variable declarations longest to shortest.

 Changes in v3:
  - remove the unused struct nci_core_reset_rsp_nci_ver2.
  - remove the __packed because of no need.
  - remove the unnecessary brackets.
  - change the asignment code for ndev->num_supported_rf_interfaces.

 Changes in v2:
  - fix the warning of type casting.
  - changed the __u8 type to unsigned char.

 include/net/nfc/nci.h | 34 ++++++++++++++++++
 net/nfc/nci/core.c    | 18 ++++++++--
 net/nfc/nci/ntf.c     | 21 +++++++++++
 net/nfc/nci/rsp.c     | 81 +++++++++++++++++++++++++++++++++++--------
 4 files changed, 138 insertions(+), 16 deletions(-)

diff --git a/include/net/nfc/nci.h b/include/net/nfc/nci.h
index 0550e0380b8d..e82f55f543bb 100644
--- a/include/net/nfc/nci.h
+++ b/include/net/nfc/nci.h
@@ -25,6 +25,8 @@
 #define NCI_MAX_PARAM_LEN					251
 #define NCI_MAX_PAYLOAD_SIZE					255
 #define NCI_MAX_PACKET_SIZE					258
+#define NCI_MAX_LARGE_PARAMS_NCI_v2				15
+#define NCI_VER_2_MASK						0x20
 
 /* NCI Status Codes */
 #define NCI_STATUS_OK						0x00
@@ -131,6 +133,9 @@
 #define NCI_LF_CON_BITR_F_212					0x02
 #define NCI_LF_CON_BITR_F_424					0x04
 
+/* NCI 2.x Feature Enable Bit */
+#define NCI_FEATURE_DISABLE					0x00
+
 /* NCI Reset types */
 #define NCI_RESET_TYPE_KEEP_CONFIG				0x00
 #define NCI_RESET_TYPE_RESET_CONFIG				0x01
@@ -220,6 +225,11 @@ struct nci_core_reset_cmd {
 } __packed;
 
 #define NCI_OP_CORE_INIT_CMD		nci_opcode_pack(NCI_GID_CORE, 0x01)
+/* To support NCI 2.x */
+struct nci_core_init_v2_cmd {
+	u8	feature1;
+	u8	feature2;
+};
 
 #define NCI_OP_CORE_SET_CONFIG_CMD	nci_opcode_pack(NCI_GID_CORE, 0x02)
 struct set_config_param {
@@ -334,6 +344,20 @@ struct nci_core_init_rsp_2 {
 	__le32	manufact_specific_info;
 } __packed;
 
+/* To support NCI ver 2.x */
+struct nci_core_init_rsp_nci_ver2 {
+	u8	status;
+	__le32	nfcc_features;
+	u8	max_logical_connections;
+	__le16	max_routing_table_size;
+	u8	max_ctrl_pkt_payload_len;
+	u8	max_data_pkt_hci_payload_len;
+	u8	number_of_hci_credit;
+	__le16	max_nfc_v_frame_size;
+	u8	num_supported_rf_interfaces;
+	u8	supported_rf_interfaces[];
+} __packed;
+
 #define NCI_OP_CORE_SET_CONFIG_RSP	nci_opcode_pack(NCI_GID_CORE, 0x02)
 struct nci_core_set_config_rsp {
 	__u8	status;
@@ -372,6 +396,16 @@ struct nci_nfcee_discover_rsp {
 /* --------------------------- */
 /* ---- NCI Notifications ---- */
 /* --------------------------- */
+#define NCI_OP_CORE_RESET_NTF		nci_opcode_pack(NCI_GID_CORE, 0x00)
+struct nci_core_reset_ntf {
+	u8	reset_trigger;
+	u8	config_status;
+	u8	nci_ver;
+	u8	manufact_id;
+	u8	manufacturer_specific_len;
+	__le32	manufact_specific_info;
+} __packed;
+
 #define NCI_OP_CORE_CONN_CREDITS_NTF	nci_opcode_pack(NCI_GID_CORE, 0x06)
 struct conn_credit_entry {
 	__u8	conn_id;
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 4953ee5146e1..e64727e1a72f 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -165,7 +165,12 @@ static void nci_reset_req(struct nci_dev *ndev, unsigned long opt)
 
 static void nci_init_req(struct nci_dev *ndev, unsigned long opt)
 {
-	nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, 0, NULL);
+	u8 plen = 0;
+
+	if (opt)
+		plen = sizeof(struct nci_core_init_v2_cmd);
+
+	nci_send_cmd(ndev, NCI_OP_CORE_INIT_CMD, plen, (void *)opt);
 }
 
 static void nci_init_complete_req(struct nci_dev *ndev, unsigned long opt)
@@ -497,7 +502,16 @@ static int nci_open_device(struct nci_dev *ndev)
 	}
 
 	if (!rc) {
-		rc = __nci_request(ndev, nci_init_req, 0,
+		struct nci_core_init_v2_cmd nci_init_v2_cmd = {
+			.feature1 = NCI_FEATURE_DISABLE,
+			.feature2 = NCI_FEATURE_DISABLE
+		};
+		unsigned long opt = 0;
+
+		if (!(ndev->nci_ver & NCI_VER_2_MASK))
+			opt = (unsigned long)&nci_init_v2_cmd;
+
+		rc = __nci_request(ndev, nci_init_req, opt,
 				   msecs_to_jiffies(NCI_INIT_TIMEOUT));
 	}
 
diff --git a/net/nfc/nci/ntf.c b/net/nfc/nci/ntf.c
index 33e1170817f0..98af04c86b2c 100644
--- a/net/nfc/nci/ntf.c
+++ b/net/nfc/nci/ntf.c
@@ -27,6 +27,23 @@
 
 /* Handle NCI Notification packets */
 
+static void nci_core_reset_ntf_packet(struct nci_dev *ndev,
+				      struct sk_buff *skb)
+{
+	/* Handle NCI 2.x core reset notification */
+	struct nci_core_reset_ntf *ntf = (void *)skb->data;
+
+	ndev->nci_ver = ntf->nci_ver;
+	pr_debug("nci_ver 0x%x, config_status 0x%x\n",
+		 ntf->nci_ver, ntf->config_status);
+
+	ndev->manufact_id = ntf->manufact_id;
+	ndev->manufact_specific_info =
+		__le32_to_cpu(ntf->manufact_specific_info);
+
+	nci_req_complete(ndev, NCI_STATUS_OK);
+}
+
 static void nci_core_conn_credits_ntf_packet(struct nci_dev *ndev,
 					     struct sk_buff *skb)
 {
@@ -756,6 +773,10 @@ void nci_ntf_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	}
 
 	switch (ntf_opcode) {
+	case NCI_OP_CORE_RESET_NTF:
+		nci_core_reset_ntf_packet(ndev, skb);
+		break;
+
 	case NCI_OP_CORE_CONN_CREDITS_NTF:
 		nci_core_conn_credits_ntf_packet(ndev, skb);
 		break;
diff --git a/net/nfc/nci/rsp.c b/net/nfc/nci/rsp.c
index a48297b79f34..e9605922a322 100644
--- a/net/nfc/nci/rsp.c
+++ b/net/nfc/nci/rsp.c
@@ -31,16 +31,19 @@ static void nci_core_reset_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 
 	pr_debug("status 0x%x\n", rsp->status);
 
-	if (rsp->status == NCI_STATUS_OK) {
-		ndev->nci_ver = rsp->nci_ver;
-		pr_debug("nci_ver 0x%x, config_status 0x%x\n",
-			 rsp->nci_ver, rsp->config_status);
-	}
+	/* Handle NCI 1.x ver */
+	if (skb->len != 1) {
+		if (rsp->status == NCI_STATUS_OK) {
+			ndev->nci_ver = rsp->nci_ver;
+			pr_debug("nci_ver 0x%x, config_status 0x%x\n",
+				 rsp->nci_ver, rsp->config_status);
+		}
 
-	nci_req_complete(ndev, rsp->status);
+		nci_req_complete(ndev, rsp->status);
+	}
 }
 
-static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
+static u8 nci_core_init_rsp_packet_v1(struct nci_dev *ndev, struct sk_buff *skb)
 {
 	struct nci_core_init_rsp_1 *rsp_1 = (void *) skb->data;
 	struct nci_core_init_rsp_2 *rsp_2;
@@ -48,16 +51,14 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	pr_debug("status 0x%x\n", rsp_1->status);
 
 	if (rsp_1->status != NCI_STATUS_OK)
-		goto exit;
+		return rsp_1->status;
 
 	ndev->nfcc_features = __le32_to_cpu(rsp_1->nfcc_features);
 	ndev->num_supported_rf_interfaces = rsp_1->num_supported_rf_interfaces;
 
-	if (ndev->num_supported_rf_interfaces >
-	    NCI_MAX_SUPPORTED_RF_INTERFACES) {
-		ndev->num_supported_rf_interfaces =
-			NCI_MAX_SUPPORTED_RF_INTERFACES;
-	}
+	ndev->num_supported_rf_interfaces =
+		min((int)ndev->num_supported_rf_interfaces,
+		    NCI_MAX_SUPPORTED_RF_INTERFACES);
 
 	memcpy(ndev->supported_rf_interfaces,
 	       rsp_1->supported_rf_interfaces,
@@ -77,6 +78,58 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 	ndev->manufact_specific_info =
 		__le32_to_cpu(rsp_2->manufact_specific_info);
 
+	return NCI_STATUS_OK;
+}
+
+static u8 nci_core_init_rsp_packet_v2(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	struct nci_core_init_rsp_nci_ver2 *rsp = (void *)skb->data;
+	u8 *supported_rf_interface = rsp->supported_rf_interfaces;
+	u8 rf_interface_idx = 0;
+	u8 rf_extension_cnt = 0;
+
+	pr_debug("status %x\n", rsp->status);
+
+	if (rsp->status != NCI_STATUS_OK)
+		return rsp->status;
+
+	ndev->nfcc_features = __le32_to_cpu(rsp->nfcc_features);
+	ndev->num_supported_rf_interfaces = rsp->num_supported_rf_interfaces;
+
+	ndev->num_supported_rf_interfaces =
+		min((int)ndev->num_supported_rf_interfaces,
+		    NCI_MAX_SUPPORTED_RF_INTERFACES);
+
+	while (rf_interface_idx < ndev->num_supported_rf_interfaces) {
+		ndev->supported_rf_interfaces[rf_interface_idx++] = *supported_rf_interface++;
+
+		/* skip rf extension parameters */
+		rf_extension_cnt = *supported_rf_interface++;
+		supported_rf_interface += rf_extension_cnt;
+	}
+
+	ndev->max_logical_connections = rsp->max_logical_connections;
+	ndev->max_routing_table_size =
+			__le16_to_cpu(rsp->max_routing_table_size);
+	ndev->max_ctrl_pkt_payload_len =
+			rsp->max_ctrl_pkt_payload_len;
+	ndev->max_size_for_large_params = NCI_MAX_LARGE_PARAMS_NCI_v2;
+
+	return NCI_STATUS_OK;
+}
+
+static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
+{
+	u8 status = 0;
+
+	if (!(ndev->nci_ver & NCI_VER_2_MASK))
+		status = nci_core_init_rsp_packet_v1(ndev, skb);
+	else
+		status = nci_core_init_rsp_packet_v2(ndev, skb);
+
+	if (status != NCI_STATUS_OK)
+		goto exit;
+
 	pr_debug("nfcc_features 0x%x\n",
 		 ndev->nfcc_features);
 	pr_debug("num_supported_rf_interfaces %d\n",
@@ -103,7 +156,7 @@ static void nci_core_init_rsp_packet(struct nci_dev *ndev, struct sk_buff *skb)
 		 ndev->manufact_specific_info);
 
 exit:
-	nci_req_complete(ndev, rsp_1->status);
+	nci_req_complete(ndev, status);
 }
 
 static void nci_core_set_config_rsp_packet(struct nci_dev *ndev,
-- 
2.17.1

