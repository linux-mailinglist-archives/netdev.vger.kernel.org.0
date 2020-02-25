Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48A616B6BD
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 01:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728653AbgBYAbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 19:31:31 -0500
Received: from gateway22.websitewelcome.com ([192.185.47.179]:43825 "EHLO
        gateway22.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727081AbgBYAba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 19:31:30 -0500
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway22.websitewelcome.com (Postfix) with ESMTP id 6CB3362F4
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 18:31:29 -0600 (CST)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 6O8HjhwXmRP4z6O8Hj73g5; Mon, 24 Feb 2020 18:31:29 -0600
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Type:MIME-Version:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+57+TZ+YS4fZoiEVbZiT3ANzLG4Ir1hQoUxGBfOF4M4=; b=sh51uhl5baRoJtHSTmrspjD2QJ
        Ru1DDAERaQUgtBRxZld32WPyJwVT46uq1l+8Dm7ktFw8/+cR+HBNcpQqTrmfxn/I7t8b/mXhyebJh
        gHHyc1h5/ES31UlOe69t8dHj7i/t766pPjoJY2KCBztNdeP5FMnuGwWJBon6cuWTa6vl0t2xkGhb3
        VHzUpTqGZNbl8aF9+WAYd83VcHLdE71nAgWU6i6cs57sVllG1ntZZay8LOLuE6mz2ccNZ47wjYEbZ
        EVVIFs/ZL+DpxGZcMFGxs1buz+JD2OegK3gY2/nautdm4Pg8ePmI1I8vKKNe7mSzWqzDCbaBQl6i+
        rFBfrZIw==;
Received: from [201.166.191.211] (port=54920 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1j6O8F-002YvY-IY; Mon, 24 Feb 2020 18:31:27 -0600
Date:   Mon, 24 Feb 2020 18:34:08 -0600
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH][next] wireless: ti: Replace zero-length array with
 flexible-array member
Message-ID: <20200225003408.GA28675@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 201.166.191.211
X-Source-L: No
X-Exim-ID: 1j6O8F-002YvY-IY
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [201.166.191.211]:54920
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 44
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current codebase makes use of the zero-length array language
extension to the C90 standard, but the preferred mechanism to declare
variable-length types such as these ones is a flexible array member[1][2],
introduced in C99:

struct foo {
        int stuff;
        struct boo array[];
};

By making use of the mechanism above, we will get a compiler warning
in case the flexible array does not occur last in the structure, which
will help us prevent some kind of undefined behavior bugs from being
inadvertently introduced[3] to the codebase from now on.

Also, notice that, dynamic memory allocations won't be affected by
this change:

"Flexible array members have incomplete type, and so the sizeof operator
may not be applied. As a quirk of the original implementation of
zero-length arrays, sizeof evaluates to zero."[1]

This issue was found with the help of Coccinelle.

[1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
[2] https://github.com/KSPP/linux/issues/21
[3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/ti/wl1251/cmd.h          | 4 ++--
 drivers/net/wireless/ti/wl1251/wl12xx_80211.h | 2 +-
 drivers/net/wireless/ti/wlcore/acx.h          | 2 +-
 drivers/net/wireless/ti/wlcore/boot.h         | 2 +-
 drivers/net/wireless/ti/wlcore/cmd.h          | 2 +-
 drivers/net/wireless/ti/wlcore/conf.h         | 2 +-
 drivers/net/wireless/ti/wlcore/wl12xx_80211.h | 2 +-
 7 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.h b/drivers/net/wireless/ti/wl1251/cmd.h
index 1c1a591c6055..e5874186f9d7 100644
--- a/drivers/net/wireless/ti/wl1251/cmd.h
+++ b/drivers/net/wireless/ti/wl1251/cmd.h
@@ -90,7 +90,7 @@ struct wl1251_cmd_header {
 	u16 id;
 	u16 status;
 	/* payload */
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 struct  wl1251_command {
@@ -281,7 +281,7 @@ struct wl1251_cmd_packet_template {
 	struct wl1251_cmd_header header;
 
 	__le16 size;
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #define TIM_ELE_ID    5
diff --git a/drivers/net/wireless/ti/wl1251/wl12xx_80211.h b/drivers/net/wireless/ti/wl1251/wl12xx_80211.h
index 7fabe702c4cc..7e28fe435b43 100644
--- a/drivers/net/wireless/ti/wl1251/wl12xx_80211.h
+++ b/drivers/net/wireless/ti/wl1251/wl12xx_80211.h
@@ -65,7 +65,7 @@ struct ieee80211_header {
 	u8 sa[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	__le16 seq_ctl;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct wl12xx_ie_header {
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index a265fba0cb4c..c725f5855c13 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -938,7 +938,7 @@ struct acx_rx_filter_cfg {
 	u8 action;
 
 	u8 num_fields;
-	u8 fields[0];
+	u8 fields[];
 } __packed;
 
 struct acx_roaming_stats {
diff --git a/drivers/net/wireless/ti/wlcore/boot.h b/drivers/net/wireless/ti/wlcore/boot.h
index 14b367e98dce..24a2dfcb41ea 100644
--- a/drivers/net/wireless/ti/wlcore/boot.h
+++ b/drivers/net/wireless/ti/wlcore/boot.h
@@ -26,7 +26,7 @@ struct wl1271_static_data {
 	u8 fw_version[WL1271_FW_VERSION_MAX_LEN];
 	u32 hw_version;
 	u8 tx_power_table[WL1271_NO_SUBBANDS][WL1271_NO_POWER_LEVELS];
-	u8 priv[0];
+	u8 priv[];
 };
 
 /* number of times we try to read the INIT interrupt */
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index bfad7b5a1ac6..f2609d5b6bf7 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -209,7 +209,7 @@ struct wl1271_cmd_header {
 	__le16 id;
 	__le16 status;
 	/* payload */
-	u8 data[0];
+	u8 data[];
 } __packed;
 
 #define WL1271_CMD_MAX_PARAMS 572
diff --git a/drivers/net/wireless/ti/wlcore/conf.h b/drivers/net/wireless/ti/wlcore/conf.h
index 6116383ee248..31be425f2332 100644
--- a/drivers/net/wireless/ti/wlcore/conf.h
+++ b/drivers/net/wireless/ti/wlcore/conf.h
@@ -1150,7 +1150,7 @@ struct wlcore_conf {
 struct wlcore_conf_file {
 	struct wlcore_conf_header header;
 	struct wlcore_conf core;
-	u8 priv[0];
+	u8 priv[];
 } __packed;
 
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx_80211.h b/drivers/net/wireless/ti/wlcore/wl12xx_80211.h
index 181be725eff8..1dd7ecc11f86 100644
--- a/drivers/net/wireless/ti/wlcore/wl12xx_80211.h
+++ b/drivers/net/wireless/ti/wlcore/wl12xx_80211.h
@@ -66,7 +66,7 @@ struct ieee80211_header {
 	u8 sa[ETH_ALEN];
 	u8 bssid[ETH_ALEN];
 	__le16 seq_ctl;
-	u8 payload[0];
+	u8 payload[];
 } __packed;
 
 struct wl12xx_ie_header {
-- 
2.25.0

