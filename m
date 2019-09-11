Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6A3AF484
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 04:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfIKCu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 22:50:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39354 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfIKCu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 22:50:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so10728097pgi.6
        for <netdev@vger.kernel.org>; Tue, 10 Sep 2019 19:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xRxl/QIvNNCgw66wHW2wXyLaF/BO3ld+u5bBESn67Vo=;
        b=oP8tS61onGCO7N3InDrtGwrb13cQq3okpf722CyzpMJhunQbwPUz0v9xuhvOThexnC
         Ooo21h6M1V+9owTrbKsFMl3bCzMva7UPkEghnbjkOdapc4/S0QsfBSp6cDbTRkqd0CL+
         siJNLRtJrFm5yPUQorwcfZiFO2/siQdMGe3Tp3C9VGyIhoX6n8OLzopMNmQ2mgaUBvJz
         QtGlZtbmHvaaeIHWKZJXWkHHraQ/WNNZRahumMSiibjVxgCOq93rhdN7bf2ttQ0vgiUj
         Q4oxYJmmOQB2R9IJoyRk7Gdc7JSpWJRXZGFK1EORQ+Ip8OAqganptwad6OFNFKnkVfRm
         hN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xRxl/QIvNNCgw66wHW2wXyLaF/BO3ld+u5bBESn67Vo=;
        b=Udv41ABxzRXoSvtP0KPDUKNTGKwTiYlWwCRkhrZOmt/1fBi/HKYBvQTB4TRqS/OL2R
         2nDqmal/52X4JKod23rcN3JthvBjgYeZsV791gSIPt2aSSo5DbmiJw1rhAyYdEQRokRH
         gDz0S/TuyLGcyPU/r52l4vUBlAfDmeXPSCPTEoX1MHRj15EgIDH55CQ6i0DLEJ8F8goi
         AhzhgFKTyJ8RcnKV8OTe1W3f1z01A5lBZa0ThbAVIF43LPJ35zKZOzbdvBFHIcOX2yHj
         gdDA43bTxpGAXKDSoQRZljSmyHHy5XD6y7gnF+rG94I4dwtd0cuUzOCRJlVkGKWWWws6
         y5YQ==
X-Gm-Message-State: APjAAAXiY2/ER4Bp/0OEIv8ckTT/RjFWR9kz2UyrqnurXTPKNksHv9mg
        agg04gwDX+3JmiUfPsbRmE/jWnL4ySs=
X-Google-Smtp-Source: APXvYqy3amYH+xUTnxWDHI1Ib5/wkhfmh+ItKicfuBE2UmxVXBJLps1xjio1mLXgOjSDEva0JmMvNQ==
X-Received: by 2002:a17:90a:322c:: with SMTP id k41mr2983383pjb.32.1568170255994;
        Tue, 10 Sep 2019 19:50:55 -0700 (PDT)
Received: from localhost.localdomain (59-127-47-126.HINET-IP.hinet.net. [59.127.47.126])
        by smtp.gmail.com with ESMTPSA id x10sm24915280pfr.44.2019.09.10.19.50.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 10 Sep 2019 19:50:55 -0700 (PDT)
From:   Chris Chiu <chiu@endlessm.com>
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com
Subject: [PATCH v2] rtl8xxxu: add bluetooth co-existence support for single antenna
Date:   Wed, 11 Sep 2019 10:50:45 +0800
Message-Id: <20190911025045.20918-1-chiu@endlessm.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RTL8723BU suffers the wifi disconnection problem while bluetooth
device connected. While wifi is doing tx/rx, the bluetooth will scan
without results. This is due to the wifi and bluetooth share the same
single antenna for RF communication and they need to have a mechanism
to collaborate.

BT information is provided via the packet sent from co-processor to
host (C2H). It contains the status of BT but the rtl8723bu_handle_c2h
dose not really handle it. And there's no bluetooth coexistence
mechanism to deal with it.

This commit adds a workqueue to set the tdma configurations and
coefficient table per the parsed bluetooth link status and given
wifi connection state. The tdma/coef table comes from the vendor
driver code of the RTL8192EU and RTL8723BU. However, this commit is
only for single antenna scenario which RTL8192EU is default dual
antenna. The rtl8xxxu_parse_rxdesc24 which invokes the handle_c2h
is only for 8723b and 8192e so the mechanism is expected to work
on both chips with single antenna. Note RTL8192EU dual antenna is
not supported.

Signed-off-by: Chris Chiu <chiu@endlessm.com>
---

Notes:
  v2:
   - Add helper functions to replace bunch of tdma settings
   - Reformat some lines to meet kernel coding style


 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  37 +++
 .../realtek/rtl8xxxu/rtl8xxxu_8723b.c         |   2 -
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 262 +++++++++++++++++-
 3 files changed, 294 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index 582c2a346cec..22e95b11bfbb 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1220,6 +1220,37 @@ enum ratr_table_mode_new {
 	RATEID_IDX_BGN_3SS = 14,
 };
 
+#define BT_INFO_8723B_1ANT_B_FTP		BIT(7)
+#define BT_INFO_8723B_1ANT_B_A2DP		BIT(6)
+#define BT_INFO_8723B_1ANT_B_HID		BIT(5)
+#define BT_INFO_8723B_1ANT_B_SCO_BUSY		BIT(4)
+#define BT_INFO_8723B_1ANT_B_ACL_BUSY		BIT(3)
+#define BT_INFO_8723B_1ANT_B_INQ_PAGE		BIT(2)
+#define BT_INFO_8723B_1ANT_B_SCO_ESCO		BIT(1)
+#define BT_INFO_8723B_1ANT_B_CONNECTION	BIT(0)
+
+enum _BT_8723B_1ANT_STATUS {
+	BT_8723B_1ANT_STATUS_NON_CONNECTED_IDLE      = 0x0,
+	BT_8723B_1ANT_STATUS_CONNECTED_IDLE          = 0x1,
+	BT_8723B_1ANT_STATUS_INQ_PAGE                = 0x2,
+	BT_8723B_1ANT_STATUS_ACL_BUSY                = 0x3,
+	BT_8723B_1ANT_STATUS_SCO_BUSY                = 0x4,
+	BT_8723B_1ANT_STATUS_ACL_SCO_BUSY            = 0x5,
+	BT_8723B_1ANT_STATUS_MAX
+};
+
+struct rtl8xxxu_btcoex {
+	u8      bt_status;
+	bool	bt_busy;
+	bool	has_sco;
+	bool	has_a2dp;
+	bool    has_hid;
+	bool    has_pan;
+	bool	hid_only;
+	bool	a2dp_only;
+	bool    c2h_bt_inquiry;
+};
+
 #define RTL8XXXU_RATR_STA_INIT 0
 #define RTL8XXXU_RATR_STA_HIGH 1
 #define RTL8XXXU_RATR_STA_MID  2
@@ -1340,6 +1371,10 @@ struct rtl8xxxu_priv {
 	 */
 	struct ieee80211_vif *vif;
 	struct delayed_work ra_watchdog;
+	struct work_struct c2hcmd_work;
+	struct sk_buff_head c2hcmd_queue;
+	spinlock_t c2hcmd_lock;
+	struct rtl8xxxu_btcoex bt_coex;
 };
 
 struct rtl8xxxu_rx_urb {
@@ -1486,6 +1521,8 @@ void rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 			     struct rtl8xxxu_txdesc32 *tx_desc32, bool sgi,
 			     bool short_preamble, bool ampdu_enable,
 			     u32 rts_rate);
+void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
+			   u8 arg1, u8 arg2, u8 arg3, u8 arg4, u8 arg5);
 
 extern struct rtl8xxxu_fileops rtl8192cu_fops;
 extern struct rtl8xxxu_fileops rtl8192eu_fops;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
index ceffe05bd65b..9ba661b3d767 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723b.c
@@ -1580,9 +1580,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 	/*
 	 * Software control, antenna at WiFi side
 	 */
-#ifdef NEED_PS_TDMA
 	rtl8723bu_set_ps_tdma(priv, 0x08, 0x00, 0x00, 0x00, 0x00);
-#endif
 
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
 	rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x55555555);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index a6f358b9e447..e4c1b08c8070 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -3820,9 +3820,8 @@ void rtl8xxxu_power_off(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0e);
 }
 
-#ifdef NEED_PS_TDMA
-static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
-				  u8 arg1, u8 arg2, u8 arg3, u8 arg4, u8 arg5)
+void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
+			   u8 arg1, u8 arg2, u8 arg3, u8 arg4, u8 arg5)
 {
 	struct h2c_cmd h2c;
 
@@ -3835,7 +3834,6 @@ static void rtl8723bu_set_ps_tdma(struct rtl8xxxu_priv *priv,
 	h2c.b_type_dma.data5 = arg5;
 	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.b_type_dma));
 }
-#endif
 
 void rtl8xxxu_gen2_disable_rf(struct rtl8xxxu_priv *priv)
 {
@@ -5186,12 +5184,258 @@ static void rtl8xxxu_rx_urb_work(struct work_struct *work)
 	}
 }
 
+void rtl8723bu_set_coex_with_type(struct rtl8xxxu_priv *priv, u8 type)
+{
+	switch (type) {
+	case 0:
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x55555555);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
+		rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
+		break;
+	case 1:
+	case 3:
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x5a5a5a5a);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
+		rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
+		break;
+	case 2:
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x5a5a5a5a);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0x5a5a5a5a);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
+		rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
+		break;
+	case 4:
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x5a5a5a5a);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0xaaaa5a5a);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
+		rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
+		break;
+	case 5:
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x5a5a5a5a);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0xaa5a5a5a);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
+		rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
+		break;
+	case 6:
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0x55555555);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0xaaaaaaaa);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
+		rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
+		break;
+	case 7:
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE1, 0xaaaaaaaa);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE2, 0xaaaaaaaa);
+		rtl8xxxu_write32(priv, REG_BT_COEX_TABLE3, 0x00ffffff);
+		rtl8xxxu_write8(priv, REG_BT_COEX_TABLE4, 0x03);
+		break;
+	default:
+		break;
+	}
+}
+
+void rtl8723bu_update_bt_link_info(struct rtl8xxxu_priv *priv, u8 bt_info)
+{
+	struct rtl8xxxu_btcoex *btcoex = &priv->bt_coex;
+
+	if (bt_info & BT_INFO_8723B_1ANT_B_INQ_PAGE)
+		btcoex->c2h_bt_inquiry = true;
+	else
+		btcoex->c2h_bt_inquiry = false;
+
+	if (!(bt_info & BT_INFO_8723B_1ANT_B_CONNECTION)) {
+		btcoex->bt_status = BT_8723B_1ANT_STATUS_NON_CONNECTED_IDLE;
+		btcoex->has_sco = false;
+		btcoex->has_hid = false;
+		btcoex->has_pan = false;
+		btcoex->has_a2dp = false;
+	} else {
+		if ((bt_info & 0x1f) == BT_INFO_8723B_1ANT_B_CONNECTION)
+			btcoex->bt_status = BT_8723B_1ANT_STATUS_CONNECTED_IDLE;
+		else if ((bt_info & BT_INFO_8723B_1ANT_B_SCO_ESCO) ||
+			 (bt_info & BT_INFO_8723B_1ANT_B_SCO_BUSY))
+			btcoex->bt_status = BT_8723B_1ANT_STATUS_SCO_BUSY;
+		else if (bt_info & BT_INFO_8723B_1ANT_B_ACL_BUSY)
+			btcoex->bt_status = BT_8723B_1ANT_STATUS_ACL_BUSY;
+		else
+			btcoex->bt_status = BT_8723B_1ANT_STATUS_MAX;
+
+		if (bt_info & BT_INFO_8723B_1ANT_B_FTP)
+			btcoex->has_pan = true;
+		else
+			btcoex->has_pan = false;
+
+		if (bt_info & BT_INFO_8723B_1ANT_B_A2DP)
+			btcoex->has_a2dp = true;
+		else
+			btcoex->has_a2dp = false;
+
+		if (bt_info & BT_INFO_8723B_1ANT_B_HID)
+			btcoex->has_hid = true;
+		else
+			btcoex->has_hid = false;
+
+		if (bt_info & BT_INFO_8723B_1ANT_B_SCO_ESCO)
+			btcoex->has_sco = true;
+		else
+			btcoex->has_sco = false;
+	}
+
+	if (!btcoex->has_a2dp && !btcoex->has_sco &&
+	    !btcoex->has_pan && btcoex->has_hid)
+		btcoex->hid_only = true;
+	else
+		btcoex->hid_only = false;
+
+	if (!btcoex->has_sco && !btcoex->has_pan &&
+	    !btcoex->has_hid && btcoex->has_a2dp)
+		btcoex->has_a2dp = true;
+	else
+		btcoex->has_a2dp = false;
+
+	if (btcoex->bt_status == BT_8723B_1ANT_STATUS_SCO_BUSY ||
+	    btcoex->bt_status == BT_8723B_1ANT_STATUS_ACL_BUSY)
+		btcoex->bt_busy = true;
+	else
+		btcoex->bt_busy = false;
+}
+
+void rtl8723bu_handle_bt_inquiry(struct rtl8xxxu_priv *priv)
+{
+	struct ieee80211_vif *vif;
+	struct rtl8xxxu_btcoex *btcoex;
+	bool wifi_connected;
+
+	vif = priv->vif;
+	btcoex = &priv->bt_coex;
+	wifi_connected = (vif && vif->bss_conf.assoc);
+
+	if (!wifi_connected) {
+		rtl8723bu_set_ps_tdma(priv, 0x8, 0x0, 0x0, 0x0, 0x0);
+		rtl8723bu_set_coex_with_type(priv, 0);
+	} else if (btcoex->has_sco || btcoex->has_hid || btcoex->has_a2dp) {
+		rtl8723bu_set_ps_tdma(priv, 0x61, 0x35, 0x3, 0x11, 0x11);
+		rtl8723bu_set_coex_with_type(priv, 4);
+	} else if (btcoex->has_pan) {
+		rtl8723bu_set_ps_tdma(priv, 0x61, 0x3f, 0x3, 0x11, 0x11);
+		rtl8723bu_set_coex_with_type(priv, 4);
+	} else {
+		rtl8723bu_set_ps_tdma(priv, 0x8, 0x0, 0x0, 0x0, 0x0);
+		rtl8723bu_set_coex_with_type(priv, 7);
+	}
+}
+
+void rtl8723bu_handle_bt_info(struct rtl8xxxu_priv *priv)
+{
+	struct ieee80211_vif *vif;
+	struct rtl8xxxu_btcoex *btcoex;
+	bool wifi_connected;
+
+	vif = priv->vif;
+	btcoex = &priv->bt_coex;
+	wifi_connected = (vif && vif->bss_conf.assoc);
+
+	if (wifi_connected) {
+		u32 val32 = 0;
+		u32 high_prio_tx = 0, high_prio_rx = 0;
+
+		val32 = rtl8xxxu_read32(priv, 0x770);
+		high_prio_tx = val32 & 0x0000ffff;
+		high_prio_rx = (val32  & 0xffff0000) >> 16;
+
+		if (btcoex->bt_busy) {
+			if (btcoex->hid_only) {
+				rtl8723bu_set_ps_tdma(priv, 0x61, 0x20,
+						      0x3, 0x11, 0x11);
+				rtl8723bu_set_coex_with_type(priv, 5);
+			} else if (btcoex->a2dp_only) {
+				rtl8723bu_set_ps_tdma(priv, 0x61, 0x35,
+						      0x3, 0x11, 0x11);
+				rtl8723bu_set_coex_with_type(priv, 4);
+			} else if ((btcoex->has_a2dp && btcoex->has_pan) ||
+				   (btcoex->has_hid && btcoex->has_a2dp &&
+				    btcoex->has_pan)) {
+				rtl8723bu_set_ps_tdma(priv, 0x51, 0x21,
+						      0x3, 0x10, 0x10);
+				rtl8723bu_set_coex_with_type(priv, 4);
+			} else if (btcoex->has_hid && btcoex->has_a2dp) {
+				rtl8723bu_set_ps_tdma(priv, 0x51, 0x21,
+						      0x3, 0x10, 0x10);
+				rtl8723bu_set_coex_with_type(priv, 3);
+			} else {
+				rtl8723bu_set_ps_tdma(priv, 0x61, 0x35,
+						      0x3, 0x11, 0x11);
+				rtl8723bu_set_coex_with_type(priv, 4);
+			}
+		} else {
+			rtl8723bu_set_ps_tdma(priv, 0x8, 0x0, 0x0, 0x0, 0x0);
+			if (high_prio_tx + high_prio_rx <= 60)
+				rtl8723bu_set_coex_with_type(priv, 2);
+			else
+				rtl8723bu_set_coex_with_type(priv, 7);
+		}
+	} else {
+		rtl8723bu_set_ps_tdma(priv, 0x8, 0x0, 0x0, 0x0, 0x0);
+		rtl8723bu_set_coex_with_type(priv, 0);
+	}
+}
+
+static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
+{
+	struct rtl8xxxu_priv *priv;
+	struct rtl8723bu_c2h *c2h;
+	struct ieee80211_vif *vif;
+	struct device *dev;
+	struct sk_buff *skb = NULL;
+	unsigned long flags;
+	int len;
+	u8 bt_info = 0;
+	struct rtl8xxxu_btcoex *btcoex;
+
+	priv = container_of(work, struct rtl8xxxu_priv, c2hcmd_work);
+	vif = priv->vif;
+	btcoex = &priv->bt_coex;
+	dev = &priv->udev->dev;
+
+	if (priv->rf_paths > 1)
+		goto out;
+
+	while (!skb_queue_empty(&priv->c2hcmd_queue)) {
+		spin_lock_irqsave(&priv->c2hcmd_lock, flags);
+		skb = __skb_dequeue(&priv->c2hcmd_queue);
+		spin_unlock_irqrestore(&priv->c2hcmd_lock, flags);
+
+		c2h = (struct rtl8723bu_c2h *)skb->data;
+		len = skb->len - 2;
+
+		switch (c2h->id) {
+		case C2H_8723B_BT_INFO:
+			bt_info = c2h->bt_info.bt_info;
+
+			rtl8723bu_update_bt_link_info(priv, bt_info);
+			if (btcoex->c2h_bt_inquiry) {
+				rtl8723bu_handle_bt_inquiry(priv);
+				break;
+			}
+			rtl8723bu_handle_bt_info(priv);
+			break;
+		default:
+			break;
+		}
+	}
+
+out:
+	dev_kfree_skb(skb);
+}
+
 static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 				 struct sk_buff *skb)
 {
 	struct rtl8723bu_c2h *c2h = (struct rtl8723bu_c2h *)skb->data;
 	struct device *dev = &priv->udev->dev;
 	int len;
+	unsigned long flags;
 
 	len = skb->len - 2;
 
@@ -5229,6 +5473,12 @@ static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
 			       16, 1, c2h->raw.payload, len, false);
 		break;
 	}
+
+	spin_lock_irqsave(&priv->c2hcmd_lock, flags);
+	__skb_queue_tail(&priv->c2hcmd_queue, skb);
+	spin_unlock_irqrestore(&priv->c2hcmd_lock, flags);
+
+	schedule_work(&priv->c2hcmd_work);
 }
 
 int rtl8xxxu_parse_rxdesc16(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
@@ -5353,7 +5603,6 @@ int rtl8xxxu_parse_rxdesc24(struct rtl8xxxu_priv *priv, struct sk_buff *skb)
 		struct device *dev = &priv->udev->dev;
 		dev_dbg(dev, "%s: C2H packet\n", __func__);
 		rtl8723bu_handle_c2h(priv, skb);
-		dev_kfree_skb(skb);
 		return RX_TYPE_C2H;
 	}
 
@@ -6272,6 +6521,9 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
 	spin_lock_init(&priv->rx_urb_lock);
 	INIT_WORK(&priv->rx_urb_wq, rtl8xxxu_rx_urb_work);
 	INIT_DELAYED_WORK(&priv->ra_watchdog, rtl8xxxu_watchdog_callback);
+	spin_lock_init(&priv->c2hcmd_lock);
+	INIT_WORK(&priv->c2hcmd_work, rtl8xxxu_c2hcmd_callback);
+	skb_queue_head_init(&priv->c2hcmd_queue);
 
 	usb_set_intfdata(interface, hw);
 
-- 
2.20.1

