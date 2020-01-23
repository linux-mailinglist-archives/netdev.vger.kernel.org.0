Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8579214660E
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbgAWK64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:58:56 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:39802 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727307AbgAWK6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:58:55 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00NAwsNB023278;
        Thu, 23 Jan 2020 02:58:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=cEOr3Wxo3TSbav8Ewbkbmyqtu23ovav95Gyf+wKJlTk=;
 b=BXjfy83IZ7MJs/pn80eHzCIKzMnuQWp2JqnJVnhXvyYXi6kYyJNRa0xMgdS/UDUQdqVh
 4gFiX8VCS8xnj/dq5QNdHX89Y0lM+rIYSijH50NFts+Yf4tIX7f6s7N2wPmETH2BQc+t
 UppYZFSmht/mA5D5vX528iGtIXwnlXnKgZESvR/C6z4G3oHKSMLKCpU9IZs+h6JagfSG
 bMABWH6vXziDCfMhrP7RKZHJQTMgzXWBAG3GAzY4XL/oH4Pi0RQSxcOmqtAK4lUGnFf2
 mWArfHSSovTz6CXE7bjX2VZInQXPmhyD8unkDOnvgxEWMUUgbbmzqBojXV510ACPInyM xw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2xq4x4h2ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 23 Jan 2020 02:58:54 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 23 Jan
 2020 02:58:53 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 23 Jan 2020 02:58:53 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 7ED1F3F703F;
        Thu, 23 Jan 2020 02:58:51 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v2 net-next 04/13] qed: FW 8.42.2.0 Parser offsets modified
Date:   Thu, 23 Jan 2020 12:58:27 +0200
Message-ID: <20200123105836.15090-5-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200123105836.15090-1-michal.kalderon@marvell.com>
References: <20200123105836.15090-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-23_08:2020-01-23,2020-01-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert storm ram line to regpair rather than two distinct u32
to better represent the u64 width of the ram.
Convert some defines to be hex instead of negative values
these values also changed by FW from previous value.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    | 51 +++++++++++-----------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
index bdfc002c1877..a816fb5411b7 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_fw_funcs.c
@@ -1011,7 +1011,6 @@ bool qed_send_qm_stop_cmd(struct qed_hwfn *p_hwfn,
 	return true;
 }
 
-
 #define SET_TUNNEL_TYPE_ENABLE_BIT(var, offset, enable) \
 	do { \
 		typeof(var) *__p_var = &(var); \
@@ -1019,8 +1018,9 @@ bool qed_send_qm_stop_cmd(struct qed_hwfn *p_hwfn,
 		*__p_var = (*__p_var & ~BIT(__offset)) | \
 			   ((enable) ? BIT(__offset) : 0); \
 	} while (0)
-#define PRS_ETH_TUNN_OUTPUT_FORMAT        -188897008
-#define PRS_ETH_OUTPUT_FORMAT             -46832
+
+#define PRS_ETH_TUNN_OUTPUT_FORMAT     0xF4DAB910
+#define PRS_ETH_OUTPUT_FORMAT          0xFFFF4910
 
 void qed_set_vxlan_dest_port(struct qed_hwfn *p_hwfn,
 			     struct qed_ptt *p_ptt, u16 dest_port)
@@ -1164,8 +1164,8 @@ void qed_set_geneve_enable(struct qed_hwfn *p_hwfn,
 	       ip_geneve_enable ? 1 : 0);
 }
 
-#define PRS_ETH_VXLAN_NO_L2_ENABLE_OFFSET   4
-#define PRS_ETH_VXLAN_NO_L2_OUTPUT_FORMAT      -927094512
+#define PRS_ETH_VXLAN_NO_L2_ENABLE_OFFSET      3
+#define PRS_ETH_VXLAN_NO_L2_OUTPUT_FORMAT   -925189872
 
 void qed_set_vxlan_no_l2_enable(struct qed_hwfn *p_hwfn,
 				struct qed_ptt *p_ptt, bool enable)
@@ -1230,7 +1230,8 @@ void qed_gft_config(struct qed_hwfn *p_hwfn,
 		    bool udp,
 		    bool ipv4, bool ipv6, enum gft_profile_type profile_type)
 {
-	u32 reg_val, cam_line, ram_line_lo, ram_line_hi, search_non_ip_as_gft;
+	u32 reg_val, cam_line, search_non_ip_as_gft;
+	struct regpair ram_line = { };
 
 	if (!ipv6 && !ipv4)
 		DP_NOTICE(p_hwfn,
@@ -1296,35 +1297,33 @@ void qed_gft_config(struct qed_hwfn *p_hwfn,
 	    qed_rd(p_hwfn, p_ptt, PRS_REG_GFT_CAM + CAM_LINE_SIZE * pf_id);
 
 	/* Write line to RAM - compare to filter 4 tuple */
-	ram_line_lo = 0;
-	ram_line_hi = 0;
 
 	/* Search no IP as GFT */
 	search_non_ip_as_gft = 0;
 
 	/* Tunnel type */
-	SET_FIELD(ram_line_lo, GFT_RAM_LINE_TUNNEL_DST_PORT, 1);
-	SET_FIELD(ram_line_lo, GFT_RAM_LINE_TUNNEL_OVER_IP_PROTOCOL, 1);
+	SET_FIELD(ram_line.lo, GFT_RAM_LINE_TUNNEL_DST_PORT, 1);
+	SET_FIELD(ram_line.lo, GFT_RAM_LINE_TUNNEL_OVER_IP_PROTOCOL, 1);
 
 	if (profile_type == GFT_PROFILE_TYPE_4_TUPLE) {
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_DST_IP, 1);
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_SRC_IP, 1);
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_ETHERTYPE, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_SRC_PORT, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_DST_PORT, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_DST_IP, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_SRC_IP, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_SRC_PORT, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_DST_PORT, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_L4_DST_PORT) {
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_ETHERTYPE, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_DST_PORT, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_OVER_IP_PROTOCOL, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_DST_PORT, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_IP_DST_ADDR) {
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_DST_IP, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_DST_IP, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_IP_SRC_ADDR) {
-		SET_FIELD(ram_line_hi, GFT_RAM_LINE_SRC_IP, 1);
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_ETHERTYPE, 1);
+		SET_FIELD(ram_line.hi, GFT_RAM_LINE_SRC_IP, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_ETHERTYPE, 1);
 	} else if (profile_type == GFT_PROFILE_TYPE_TUNNEL_TYPE) {
-		SET_FIELD(ram_line_lo, GFT_RAM_LINE_TUNNEL_ETHERTYPE, 1);
+		SET_FIELD(ram_line.lo, GFT_RAM_LINE_TUNNEL_ETHERTYPE, 1);
 
 		/* Allow tunneled traffic without inner IP */
 		search_non_ip_as_gft = 1;
@@ -1335,11 +1334,11 @@ void qed_gft_config(struct qed_hwfn *p_hwfn,
 	qed_wr(p_hwfn,
 	       p_ptt,
 	       PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id,
-	       ram_line_lo);
+	       ram_line.lo);
 	qed_wr(p_hwfn,
 	       p_ptt,
 	       PRS_REG_GFT_PROFILE_MASK_RAM + RAM_LINE_SIZE * pf_id + REG_SIZE,
-	       ram_line_hi);
+	       ram_line.hi);
 
 	/* Set default profile so that no filter match will happen */
 	qed_wr(p_hwfn,
-- 
2.14.5

