Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4989BFF1A9
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbfKPQNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:13:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729773AbfKPPr6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:58 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A116D20855;
        Sat, 16 Nov 2019 15:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919277;
        bh=I7BJNofsoP6hl8a//GDoTm7cBtYa5RqLyPJ2jwXpwQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=orrh+FzdCmKnyhMjkzc/JmRv0s8YQULQMESE+nEGgiSxxxPz+yOPNlf9yqr1DdrKg
         st8U8Abmwe5tltWA7gtlB9/S83tpnTScSNJcvJlMpIniy6FHGz10BX7dBWSjc6KKdy
         NMr64IPvBTUP/KE00DXuNWuhfUPri6Cmbp5c+jO4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rahul Verma <Rahul.Verma@cavium.com>,
        Rahul Verma <rahul.verma@cavium.com>,
        Ariel Elior <ariel.elior@cavium.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 026/150] qed: Align local and global PTT to propagate through the APIs.
Date:   Sat, 16 Nov 2019 10:45:24 -0500
Message-Id: <20191116154729.9573-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Verma <Rahul.Verma@cavium.com>

[ Upstream commit 706d08913d1f68610c32b4a001026aa989878dd9 ]

    Align the use of local PTT to propagate through the qed_mcp* API's.
    Global ptt should not be used.

    Register access should be done through layers. Register address is
    mapped into a PTT, PF translation table. Several interface functions
    require a PTT to direct read/write into register. There is a pool of
    PTT maintained, and several PTT are used simultaneously to access
    device registers in different flows. Same PTT should not be used in
    flows that can run concurrently.
    To avoid running out of PTT resources, too many PTT should not be
    acquired without releasing them. Every PF has a global PTT, which is
    used throughout the life of PF, in most important flows for register
    access. Generic functions acquire the PTT locally and release after
    the use. This patch aligns the use of Global PTT and Local PTT
    accordingly.

Signed-off-by: Rahul Verma <rahul.verma@cavium.com>
Signed-off-by: Ariel Elior <ariel.elior@cavium.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed.h      |  2 +-
 drivers/net/ethernet/qlogic/qed/qed_main.c | 22 ++++++++++++++----
 drivers/net/ethernet/qlogic/qed/qed_mcp.c  | 27 ++++++++++------------
 drivers/net/ethernet/qlogic/qed/qed_mcp.h  |  5 ++--
 drivers/net/ethernet/qlogic/qed/qed_vf.c   |  2 +-
 5 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 91003bc6f00bd..6c4714a8b54ce 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -829,7 +829,7 @@ u16 qed_get_cm_pq_idx_vf(struct qed_hwfn *p_hwfn, u16 vf);
 /* Prototypes */
 int qed_fill_dev_info(struct qed_dev *cdev,
 		      struct qed_dev_info *dev_info);
-void qed_link_update(struct qed_hwfn *hwfn);
+void qed_link_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt);
 u32 qed_unzip_data(struct qed_hwfn *p_hwfn,
 		   u32 input_len, u8 *input_buf,
 		   u32 max_size, u8 *unzip_buf);
diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c b/drivers/net/ethernet/qlogic/qed/qed_main.c
index 557332f1f886c..52e747fd9c839 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_main.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
@@ -1389,6 +1389,7 @@ static int qed_get_link_data(struct qed_hwfn *hwfn,
 }
 
 static void qed_fill_link(struct qed_hwfn *hwfn,
+			  struct qed_ptt *ptt,
 			  struct qed_link_output *if_link)
 {
 	struct qed_mcp_link_params params;
@@ -1469,7 +1470,7 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 
 	/* TODO - fill duplex properly */
 	if_link->duplex = DUPLEX_FULL;
-	qed_mcp_get_media_type(hwfn->cdev, &media_type);
+	qed_mcp_get_media_type(hwfn, ptt, &media_type);
 	if_link->port = qed_get_port_type(media_type);
 
 	if_link->autoneg = params.speed.autoneg;
@@ -1525,21 +1526,34 @@ static void qed_fill_link(struct qed_hwfn *hwfn,
 static void qed_get_current_link(struct qed_dev *cdev,
 				 struct qed_link_output *if_link)
 {
+	struct qed_hwfn *hwfn;
+	struct qed_ptt *ptt;
 	int i;
 
-	qed_fill_link(&cdev->hwfns[0], if_link);
+	hwfn = &cdev->hwfns[0];
+	if (IS_PF(cdev)) {
+		ptt = qed_ptt_acquire(hwfn);
+		if (ptt) {
+			qed_fill_link(hwfn, ptt, if_link);
+			qed_ptt_release(hwfn, ptt);
+		} else {
+			DP_NOTICE(hwfn, "Failed to fill link; No PTT\n");
+		}
+	} else {
+		qed_fill_link(hwfn, NULL, if_link);
+	}
 
 	for_each_hwfn(cdev, i)
 		qed_inform_vf_link_state(&cdev->hwfns[i]);
 }
 
-void qed_link_update(struct qed_hwfn *hwfn)
+void qed_link_update(struct qed_hwfn *hwfn, struct qed_ptt *ptt)
 {
 	void *cookie = hwfn->cdev->ops_cookie;
 	struct qed_common_cb_ops *op = hwfn->cdev->protocol_ops.common;
 	struct qed_link_output if_link;
 
-	qed_fill_link(hwfn, &if_link);
+	qed_fill_link(hwfn, ptt, &if_link);
 	qed_inform_vf_link_state(hwfn);
 
 	if (IS_LEAD_HWFN(hwfn) && cookie)
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index 7938abe9a3010..ef17ca09d3038 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -1352,7 +1352,7 @@ static void qed_mcp_handle_link_change(struct qed_hwfn *p_hwfn,
 	if (p_hwfn->mcp_info->capabilities & FW_MB_PARAM_FEATURE_SUPPORT_EEE)
 		qed_mcp_read_eee_config(p_hwfn, p_ptt, p_link);
 
-	qed_link_update(p_hwfn);
+	qed_link_update(p_hwfn, p_ptt);
 out:
 	spin_unlock_bh(&p_hwfn->mcp_info->link_lock);
 }
@@ -1722,12 +1722,10 @@ int qed_mcp_get_mbi_ver(struct qed_hwfn *p_hwfn,
 	return 0;
 }
 
-int qed_mcp_get_media_type(struct qed_dev *cdev, u32 *p_media_type)
+int qed_mcp_get_media_type(struct qed_hwfn *p_hwfn,
+			   struct qed_ptt *p_ptt, u32 *p_media_type)
 {
-	struct qed_hwfn *p_hwfn = &cdev->hwfns[0];
-	struct qed_ptt  *p_ptt;
-
-	if (IS_VF(cdev))
+	if (IS_VF(p_hwfn->cdev))
 		return -EINVAL;
 
 	if (!qed_mcp_is_init(p_hwfn)) {
@@ -1735,16 +1733,15 @@ int qed_mcp_get_media_type(struct qed_dev *cdev, u32 *p_media_type)
 		return -EBUSY;
 	}
 
-	*p_media_type = MEDIA_UNSPECIFIED;
-
-	p_ptt = qed_ptt_acquire(p_hwfn);
-	if (!p_ptt)
-		return -EBUSY;
-
-	*p_media_type = qed_rd(p_hwfn, p_ptt, p_hwfn->mcp_info->port_addr +
-			       offsetof(struct public_port, media_type));
+	if (!p_ptt) {
+		*p_media_type = MEDIA_UNSPECIFIED;
+		return -EINVAL;
+	}
 
-	qed_ptt_release(p_hwfn, p_ptt);
+	*p_media_type = qed_rd(p_hwfn, p_ptt,
+			       p_hwfn->mcp_info->port_addr +
+			       offsetof(struct public_port,
+					media_type));
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.h b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
index f1fe5e3427ea5..8fcdb2c3e5dba 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
@@ -284,14 +284,15 @@ int qed_mcp_get_mbi_ver(struct qed_hwfn *p_hwfn,
  * @brief Get media type value of the port.
  *
  * @param cdev      - qed dev pointer
+ * @param p_ptt
  * @param mfw_ver    - media type value
  *
  * @return int -
  *      0 - Operation was successul.
  *      -EBUSY - Operation failed
  */
-int qed_mcp_get_media_type(struct qed_dev      *cdev,
-			   u32                  *media_type);
+int qed_mcp_get_media_type(struct qed_hwfn *p_hwfn,
+			   struct qed_ptt *p_ptt, u32 *media_type);
 
 /**
  * @brief General function for sending commands to the MCP
diff --git a/drivers/net/ethernet/qlogic/qed/qed_vf.c b/drivers/net/ethernet/qlogic/qed/qed_vf.c
index 3220086f99dea..a2a9921b467b1 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_vf.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_vf.c
@@ -1669,7 +1669,7 @@ static void qed_handle_bulletin_change(struct qed_hwfn *hwfn)
 	ops->ports_update(cookie, vxlan_port, geneve_port);
 
 	/* Always update link configuration according to bulletin */
-	qed_link_update(hwfn);
+	qed_link_update(hwfn, NULL);
 }
 
 void qed_iov_vf_task(struct work_struct *work)
-- 
2.20.1

