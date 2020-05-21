Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7821E1DCD08
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 14:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbgEUMgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 08:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbgEUMgW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 08:36:22 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DD3E2070A;
        Thu, 21 May 2020 12:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590064581;
        bh=kvXZ5Ar3iD8sz53DrMiw67s4i3oP26P5U8RIKu85m7w=;
        h=From:To:Cc:Subject:Date:From;
        b=rWCdezUNKHzqfIMCzRYS+XVS5/oyB7Bb1P0TzT1i+QsqYY41xOuR0eRhrY0IrUWEK
         CyWN/a2Ra2tYZUMoYN8HOWW0jHEAKnZwUpircKK1XnSq+kEE2Uu1Od28c3lt+yWjK2
         wICBqFuF61FHmyefppz+GySgXfPqCr4oiEL0MNpU=
Received: by pali.im (Postfix)
        id 98A6734B; Thu, 21 May 2020 14:36:19 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mwifiex: Add support for NL80211_ATTR_MAX_AP_ASSOC_STA
Date:   Thu, 21 May 2020 14:35:59 +0200
Message-Id: <20200521123559.29028-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SD8997 firmware sends TLV_TYPE_MAX_CONN with struct hw_spec_max_conn to
inform kernel about maximum number of p2p connections and stations in AP
mode.

During initialization of SD8997 wifi chip kernel prints warning:

  mwifiex_sdio mmc0:0001:1: Unknown GET_HW_SPEC TLV type: 0x217

This patch adds support for parsing TLV_TYPE_MAX_CONN (0x217) and sets
appropriate cfg80211 member 'max_ap_assoc_sta' from retrieved structure.

It allows userspace to retrieve NL80211_ATTR_MAX_AP_ASSOC_STA attribute.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |  5 +++++
 drivers/net/wireless/marvell/mwifiex/cmdevt.c   | 12 ++++++++++++
 drivers/net/wireless/marvell/mwifiex/fw.h       |  8 ++++++++
 drivers/net/wireless/marvell/mwifiex/main.h     |  1 +
 4 files changed, 26 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 12bfd653a..7998e91c9 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -4339,6 +4339,11 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 		wiphy->iface_combinations = &mwifiex_iface_comb_ap_sta;
 	wiphy->n_iface_combinations = 1;
 
+	if (adapter->max_sta_conn > adapter->max_p2p_conn)
+		wiphy->max_ap_assoc_sta = adapter->max_sta_conn;
+	else
+		wiphy->max_ap_assoc_sta = adapter->max_p2p_conn;
+
 	/* Initialize cipher suits */
 	wiphy->cipher_suites = mwifiex_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(mwifiex_cipher_suites);
diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 589cc5eb1..d068b9075 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -1495,6 +1495,7 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct mwifiex_ie_types_header *tlv;
 	struct hw_spec_api_rev *api_rev;
+	struct hw_spec_max_conn *max_conn;
 	u16 resp_size, api_id;
 	int i, left_len, parsed_len = 0;
 
@@ -1604,6 +1605,17 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 					break;
 				}
 				break;
+			case TLV_TYPE_MAX_CONN:
+				max_conn = (struct hw_spec_max_conn *)tlv;
+				adapter->max_p2p_conn = max_conn->max_p2p_conn;
+				adapter->max_sta_conn = max_conn->max_sta_conn;
+				mwifiex_dbg(adapter, INFO,
+					    "max p2p connections: %u\n",
+					    adapter->max_p2p_conn);
+				mwifiex_dbg(adapter, INFO,
+					    "max sta connections: %u\n",
+					    adapter->max_sta_conn);
+				break;
 			default:
 				mwifiex_dbg(adapter, FATAL,
 					    "Unknown GET_HW_SPEC TLV type: %#x\n",
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 6f86f5b96..8047e3078 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -220,6 +220,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_BSS_MODE           (PROPRIETARY_TLV_BASE_ID + 206)
 #define TLV_TYPE_RANDOM_MAC         (PROPRIETARY_TLV_BASE_ID + 236)
 #define TLV_TYPE_CHAN_ATTR_CFG      (PROPRIETARY_TLV_BASE_ID + 237)
+#define TLV_TYPE_MAX_CONN           (PROPRIETARY_TLV_BASE_ID + 279)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -2388,4 +2389,11 @@ struct mwifiex_opt_sleep_confirm {
 	__le16 action;
 	__le16 resp_ctrl;
 } __packed;
+
+struct hw_spec_max_conn {
+	struct mwifiex_ie_types_header header;
+	u8 max_p2p_conn;
+	u8 max_sta_conn;
+} __packed;
+
 #endif /* !_MWIFIEX_FW_H_ */
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index afaffc325..5923c5c14 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1022,6 +1022,7 @@ struct mwifiex_adapter {
 	bool ext_scan;
 	u8 fw_api_ver;
 	u8 key_api_major_ver, key_api_minor_ver;
+	u8 max_p2p_conn, max_sta_conn;
 	struct memory_type_mapping *mem_type_mapping_tbl;
 	u8 num_mem_types;
 	bool scan_chan_gap_enabled;
-- 
2.20.1

