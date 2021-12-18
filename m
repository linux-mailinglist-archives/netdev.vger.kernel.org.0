Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B27479E3C
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 00:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235019AbhLRXyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 18:54:23 -0500
Received: from o1.ptr2625.egauge.net ([167.89.112.53]:25322 "EHLO
        o1.ptr2625.egauge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbhLRXyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 18:54:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=egauge.net;
        h=from:subject:in-reply-to:references:mime-version:to:cc:
        content-transfer-encoding:content-type;
        s=sgd; bh=0hlvidBJdhIlrLaOHqRVQf+FcgIZ6mOxvt9oZ5jAdx0=;
        b=vQ9EnhDfneo5BqECP/eh1ztxPZq24D5XUBEaQAsws/L7qQ1jRNwgl5i3Gt9LaGrt0Txq
        p/bSHsC2I5KuElmBo/qIt/Da9Kx/KRpmMzXUT68KapI2JHMOmNGamups9cBzWd5R6DpEmC
        97DzFXmAmYjTbOcY/ooOHab/jItIWv3rXLATYzeX7nwuvelkmWJRVAm8OOREo/F4jAhlnL
        AflfqxNeopq11JwrY3EoJLKPZikm1H3vjW8sMw7Z7/xSK3BrmLxZGkmSiO99RmiwwNcswm
        6PUqJmQTQaXL+9BZ0qhU45sZkiXpaPNMqhAEqPHaWDRfszCy5P1o+kcKLgrlT+hw==
Received: by filterdrecv-75ff7b5ffb-wdd5z with SMTP id filterdrecv-75ff7b5ffb-wdd5z-1-61BE74A8-17
        2021-12-18 23:54:16.568724745 +0000 UTC m=+9336864.670000613
Received: from pearl.egauge.net (unknown)
        by geopod-ismtpd-1-1 (SG)
        with ESMTP
        id 6K7gRl6-Tv2qCxjFpmNq-A
        Sat, 18 Dec 2021 23:54:16.367 +0000 (UTC)
Received: by pearl.egauge.net (Postfix, from userid 1000)
        id 8D75D70086E; Sat, 18 Dec 2021 16:54:15 -0700 (MST)
From:   David Mosberger-Tang <davidm@egauge.net>
Subject: [PATCH 04/23] wilc1000: factor common code in wilc_wlan_cfg_set() and
 wilc_wlan_cfg_get()
Date:   Sat, 18 Dec 2021 23:54:16 +0000 (UTC)
Message-Id: <20211218235404.3963475-5-davidm@egauge.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211218235404.3963475-1-davidm@egauge.net>
References: <20211218235404.3963475-1-davidm@egauge.net>
MIME-Version: 1.0
X-SG-EID: =?us-ascii?Q?+kMxBqj35EdRUKoy8diX1j4AXmPtd302oan+iXZuF8m2Nw4HRW2irNspffT=2Fkh?=
 =?us-ascii?Q?ET6RJF6+Prbl0h=2FEtF1rRLvE+Fbp=2FMICLbrzIyn?=
 =?us-ascii?Q?lqvh2mpwH=2F4CJ7Fl+jG2+wFUWQcq78AkswDBm0M?=
 =?us-ascii?Q?GRp9lFxQYYmrW1+AHjdJjCedyCNvjiM0P+1tk5q?=
 =?us-ascii?Q?bv4DYM5ngcDR09SLY7Iw0FXD89zVWiRd+V5IpbX?=
 =?us-ascii?Q?4ypYEvcs=2Flu6e6tulvi61egZD0APyUnMG4dKh9?=
To:     Ajay Singh <ajay.kathat@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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
 .../net/wireless/microchip/wilc1000/wlan.c    | 65 ++++++++-----------
 1 file changed, 27 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 2d103131b2e93..1c487342c1a88 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -1276,8 +1276,14 @@ static int wilc_wlan_cfg_commit(struct wilc_vif *vif, int type,
 	return 0;
 }
 
-int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
-		      u32 buffer_size, int commit, u32 drv_handler)
+/**
+ * Add a WID set/query to the current config packet and optionally
+ * submit the resulting packet to the chip and wait for its reply.
+ * Returns 0 on failure, positive number on success.
+ */
+static int wilc_wlan_cfg_apply_wid(struct wilc_vif *vif, int start, u16 wid,
+				   u8 *buffer, u32 buffer_size, int commit,
+				   u32 drv_handler, bool set)
 {
 	u32 offset;
 	int ret_size;
@@ -1289,8 +1295,12 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
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
 
@@ -1299,9 +1309,11 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
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
@@ -1317,41 +1329,18 @@ int wilc_wlan_cfg_set(struct wilc_vif *vif, int start, u16 wid, u8 *buffer,
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

