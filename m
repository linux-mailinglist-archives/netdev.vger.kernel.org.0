Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6626147DD4F
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:19:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241033AbhLWBQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:16:54 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:17754 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235634AbhLWBOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:14:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=EAPQRl9XYrJUUbnmBFI0oiwVcQ9+ZAVKjeClJzCesz8=;
        b=bmo2xaUcf4Gu0xVrnJmREEsXgLBlENc3edPCdKxjQYBPf2zpHAkoRKU3VOuqJLBeHBuG
        v/sN03Z6xFCWwuifdMVAxlyJLeq5NojC6rZ3iaBJ9cpTnCmeZOfUWmNOmLVHeI2pNBvvmv
        oWLcQ7Sa1fGYHq3zw90H5JGLemGnAvnzgwkzzRNy2TbqoB7WvpWl7leldGUpCw1bkZ/vqJ
        trI+oPEJw4MKap6sEvu0cwjq6OMv23Qb3nWf8Lb+2VYU4lKw2/PYkSvRmd0Qeg1rICNXP1
        Qt9dM8mzXGsJg3twScDtNK/pOGzdZW3SFbfB4UzweU8nqnjVvH6pDaCKl2UR1PQg==
Received: by filterdrecv-64fcb979b9-7lnp4 with SMTP id filterdrecv-64fcb979b9-7lnp4-1-61C3CD5D-31
        2021-12-23 01:14:05.752259373 +0000 UTC m=+8644592.682819742
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-6-1 (SG)
        with ESMTP
        id O7tYqgpCS7SEqvxXfg_VLg
        Thu, 23 Dec 2021 01:14:05.558 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id DAC1E700BB0; Wed, 22 Dec 2021 18:14:04 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH v2 04/50] wilc1000: factor common code in wilc_wlan_cfg_set()
 and wilc_wlan_cfg_get()
Date:   Thu, 23 Dec 2021 01:14:05 +0000 (UTC)
Message-Id: <20211223011358.4031459-5-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211223011358.4031459-1-davidm@egauge.net>
References: <20211223011358.4031459-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvKRPg1r8DnHgLz9uT?=
 =?us-ascii?Q?sd8CBTF3hyA386sin=2FBGCA3+pABmTC=2FMMOPAidl?=
 =?us-ascii?Q?lHc49Lyg8vU82CAz1L5iTJI+eUXDHHNYpapH6dN?=
 =?us-ascii?Q?sP0geGYDkZ=2F2Cfa=2FdVY6FbeC1diNkAd80iRKxfP?=
 =?us-ascii?Q?GatdbA32i5NNn5QwcBWSPYjFpLsGn1I5Hex4ga?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        David Mosberger-Tang <davidm@egauge.net>
X-Entity-ID: Xg4JGAcGrJFIz2kDG9eoaQ==
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The functions are almost identical, so factor the common code into new
function wilc_wlan_cfg_apply_wid().  No functional change.

Signed-off-by: David Mosberger-Tang <davidm@egauge.net>
---
 .../net/wireless/microchip/wilc1000/wlan.c    | 79 ++++++++++---------
 1 file changed, 41 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index d1f68df1dbeef..97624f758cbe4 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1276,8 +1276,28 @@ static int wilc_wlan_cfg_commit(struct wilc_vif *vif, int type,
 	return 0;
 }
 
-int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
-		      u32 buffer_size, int commit, u32 drv_handler)
+/**
+ * wilc_wlan_cfg_apply_wid() - Add a config set or get (query).
+ * @vif: The virtual interface to which the set/get applies.
+ * @start: Should be 1 if a new config packet should be initialized,
+ *	0 otherwise.
+ * @wid: The WID to use.
+ * @buffer: For a set, the bytes to include in the request,
+ *	for a get, the buffer in which to return the result.
+ * @buffer_size: The size of the buffer in bytes.
+ * @commit: Should be 1 if the config packet should be sent after
+ *	adding this request/query.
+ * @drv_handler: An opaque cookie that will be sent in the config header.
+ * @set: Should be true if a set, false for get.
+ *
+ * Add a WID set/query to the current config packet and optionally
+ * submit the resulting packet to the chip and wait for its reply.
+ *
+ * Return: Zero on failure, positive number on success.
+ */
+static int wilc_wlan_cfg_apply_wid(struct wilc_vif *vif, int start, u16 wid,
+				   u8 *buffer, u32 buffer_size, int commit,
+				   u32 drv_handler, bool set)
 {
 	u32 offset;
 	int ret_size;
@@ -1289,8 +1309,12 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 		wilc->cfg_frame_offset = 0;
 
 	offset = wilc->cfg_frame_offset;
-	ret_size = wilc_wlan_cfg_set_wid(wilc->cfg_frame.frame, offset,
-					 wid, buffer, buffer_size);
+	if (set)
+		ret_size = wilc_wlan_cfg_set_wid(wilc->cfg_frame.frame, offset,
+						 wid, buffer, buffer_size);
+	else
+		ret_size = wilc_wlan_cfg_get_wid(wilc->cfg_frame.frame, offset,
+						 wid);
 	offset += ret_size;
 	wilc->cfg_frame_offset = offset;
 
@@ -1299,9 +1323,11 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 		return ret_size;
 	}
 
-	netdev_dbg(vif->ndev, "%s: seqno[%d]\n", __func__, wilc->cfg_seq_no);
+	netdev_dbg(vif->ndev, "%s: %s seqno[%d]\n",
+		   __func__, set ? "set" : "get", wilc->cfg_seq_no);
 
-	if (wilc_wlan_cfg_commit(vif, WILC_CFG_SET, drv_handler))
+	if (wilc_wlan_cfg_commit(vif, set ? WILC_CFG_SET : WILC_CFG_QUERY,
+				 drv_handler))
 		ret_size = 0;
 
 	if (!wait_for_completion_timeout(&wilc->cfg_event,
@@ -1317,41 +1343,18 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
 	return ret_size;
 }
 
+int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
+		      u32 buffer_size, int commit, u32 drv_handler)
+{
+	return wilc_wlan_cfg_apply_wid(vif, start, wid, buffer, buffer_size,
+				       commit, drv_handler, true);
+}
+
 int wilc_wlan_cfg_get(struct wilc_vif *vif, int start, u16 wid, int commit,
 		      u32 drv_handler)
 {
-	u32 offset;
-	int ret_size;
-	struct wilc *wilc = vif->wilc;
-
-	mutex_lock(&wilc->cfg_cmd_lock);
-
-	if (start)
-		wilc->cfg_frame_offset = 0;
-
-	offset = wilc->cfg_frame_offset;
-	ret_size = wilc_wlan_cfg_get_wid(wilc->cfg_frame.frame, offset, wid);
-	offset += ret_size;
-	wilc->cfg_frame_offset = offset;
-
-	if (!commit) {
-		mutex_unlock(&wilc->cfg_cmd_lock);
-		return ret_size;
-	}
-
-	if (wilc_wlan_cfg_commit(vif, WILC_CFG_QUERY, drv_handler))
-		ret_size = 0;
-
-	if (!wait_for_completion_timeout(&wilc->cfg_event,
-					 WILC_CFG_PKTS_TIMEOUT)) {
-		netdev_dbg(vif->ndev, "%s: Timed Out\n", __func__);
-		ret_size = 0;
-	}
-	wilc->cfg_frame_offset = 0;
-	wilc->cfg_seq_no += 1;
-	mutex_unlock(&wilc->cfg_cmd_lock);
-
-	return ret_size;
+	return wilc_wlan_cfg_apply_wid(vif, start, wid, NULL, 0,
+				       commit, drv_handler, false);
 }
 
 int wilc_send_config_pkt(struct wilc_vif *vif, u8 mode, struct wid *wids,
-- 
2.25.1

