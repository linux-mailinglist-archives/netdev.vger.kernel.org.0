Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985D15720A0
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 18:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbiGLQSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 12:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233981AbiGLQSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 12:18:50 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7E32A278;
        Tue, 12 Jul 2022 09:18:48 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CAo3gm005611;
        Tue, 12 Jul 2022 09:18:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=XSEOOSM/CZIFA+0y2+rJiAtoktl/g4BhH0rINP6lQTQ=;
 b=OeTDTMppizMPWqsrcAFobC5VuVwDMyUmTgFnUp6zEYAO7yDnAm4K4OtA+V/0H9lAfGkK
 yl/l9GUUoGOZaMCwje/W/Q1C7dLaF8q2QZsXjtLoGmH07Vv7EB3D06df+F+KadIwliYB
 vjGCqznKhbNTbMMDxRlvz53PqTNAgT6s0x099Tts8sOsQZ3aITAzCT9GPphMzWQeaGlD
 x1Ae9fK4NAuiGsrCb3QfGMjaAjBRN7//YRhb3E5hCgG4752rBWz0GNI0vZtDYtvUo7jB
 MrUnOJVKNISdHn2vLExeiq8pnmKcP+kBCDWWgAGKItIEPNRjw1cqIySsMx158VR2Vn4Y 5A== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h8tajbprh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Jul 2022 09:18:34 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Jul
 2022 09:18:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Jul 2022 09:18:33 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 3270E3F7084;
        Tue, 12 Jul 2022 09:18:29 -0700 (PDT)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <sgoutham@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>,
        Geetha Sowjanya <gakula@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Limit link bringup time at firmware
Date:   Tue, 12 Jul 2022 21:48:15 +0530
Message-ID: <20220712161815.12621-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: dLf90WSSBtBT2vmHzOvfuMVT38hqb-ip
X-Proofpoint-ORIG-GUID: dLf90WSSBtBT2vmHzOvfuMVT38hqb-ip
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_10,2022-07-12_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hariprasad Kelam <hkelam@marvell.com>

Set the maximum time firmware should poll for a link.
If not set firmware could block CPU for a long time resulting
in mailbox failures. If link doesn't come up within 1second,
firmware will anyway notify the status as and when LINK comes up

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Geetha Sowjanya <gakula@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 14 +++++++++++---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  2 +-
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  2 ++
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  2 +-
 4 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 931a1a7ebf76..618b9d167fa6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1440,11 +1440,19 @@ static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool enable)
 	u64 req = 0;
 	u64 resp;
 
-	if (enable)
+	if (enable) {
 		req = FIELD_SET(CMDREG_ID, CGX_CMD_LINK_BRING_UP, req);
-	else
-		req = FIELD_SET(CMDREG_ID, CGX_CMD_LINK_BRING_DOWN, req);
+		/* On CN10K firmware offloads link bring up/down operations to ECP
+		 * On Octeontx2 link operations are handled by firmware itself
+		 * which can cause mbox errors so configure maximum time firmware
+		 * poll for Link as 1000 ms
+		 */
+		if (!is_dev_rpm(cgx))
+			req = FIELD_SET(LINKCFG_TIMEOUT, 1000, req);
 
+	} else {
+		req = FIELD_SET(CMDREG_ID, CGX_CMD_LINK_BRING_DOWN, req);
+	}
 	return cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index bd2f33a26eee..0b06788b8d80 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -92,7 +92,7 @@
 
 #define CGX_COMMAND_REG			CGXX_SCRATCH1_REG
 #define CGX_EVENT_REG			CGXX_SCRATCH0_REG
-#define CGX_CMD_TIMEOUT			2200 /* msecs */
+#define CGX_CMD_TIMEOUT			5000 /* msecs */
 #define DEFAULT_PAUSE_TIME		0x7FF
 
 #define CGX_LMAC_FWI			0
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index f72ec0e2506f..d4a27c882a5b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -261,4 +261,6 @@ struct cgx_lnk_sts {
 #define CMDMODECHANGE_PORT		GENMASK_ULL(21, 14)
 #define CMDMODECHANGE_FLAGS		GENMASK_ULL(63, 22)
 
+/* LINK_BRING_UP command timeout */
+#define LINKCFG_TIMEOUT		GENMASK_ULL(21, 8)
 #endif /* __CGX_FW_INTF_H__ */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 430aa8a05c23..529f2c5513ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -33,7 +33,7 @@
 
 #define INTR_MASK(pfvfs) ((pfvfs < 64) ? (BIT_ULL(pfvfs) - 1) : (~0ull))
 
-#define MBOX_RSP_TIMEOUT	3000 /* Time(ms) to wait for mbox response */
+#define MBOX_RSP_TIMEOUT	6000 /* Time(ms) to wait for mbox response */
 
 #define MBOX_MSG_ALIGN		16  /* Align mbox msg start to 16bytes */
 
-- 
2.17.1

