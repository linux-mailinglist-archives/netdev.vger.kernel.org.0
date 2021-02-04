Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC9330F82A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 17:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbhBDQkH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 11:40:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238051AbhBDQaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 11:30:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBE4C64F53;
        Thu,  4 Feb 2021 16:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612456170;
        bh=nUrqQVGTdVdtTvEZW10cth7m+C3EvTsyClTjZCQlpaA=;
        h=From:To:Cc:Subject:Date:From;
        b=cGb0IozHEQwQpcghNonA3NiIhwU2TbMxGZkbUHMzbhF9xKoXQuDkMZ2yb0TN38pft
         4scK04m0vuMVOqukfe3jBXNzyHHXq2OeMw+B324Q4/pSjMTTNDeGwpsyGDhkecCOz9
         mtCzrWsRZz5RIIZuKKgRTkyzCJKwWfh858ZBJJxs0x4ZWRCVOVrYlkV844gjWL6trU
         B6KGKQWD8aENjviCsBcVVq7Vqla9JuWwz1hLpSK9If1iUp5b5+MoWkHvuYWVlf2Lmx
         P+LAKyEX69p2+bqHo7OSOQt3duFAYsjFxPnmDKRi0IOkiaE2S+wse0h58U95ex7lBx
         Cnk1QgX4MFjxw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] carl9170: fix struct alignment conflict
Date:   Thu,  4 Feb 2021 17:29:17 +0100
Message-Id: <20210204162926.3262598-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Multiple structures in the carl9170 driver have alignment
impossible alignment constraints that gcc warns about when
building with 'make W=1':

drivers/net/wireless/ath/carl9170/fwcmd.h:243:2: warning: alignment 1 of 'union <anonymous>' is less than 4 [-Wpacked-not-aligned]
drivers/net/wireless/ath/carl9170/wlan.h:373:1: warning: alignment 1 of 'struct ar9170_rx_frame_single' is less than 2 [-Wpacked-not-aligned]

In the carl9170_cmd structure, multiple members that have an explicit
alignment requirement of four bytes are added into a union with explicit
byte alignment, but this in turn is part of a structure that also has
four-byte alignment.

In the wlan.h header, multiple structures contain a ieee80211_hdr member
that is required to be two-byte aligned to avoid alignmnet faults when
processing network headers, but all members are forced to be byte-aligned
using the __packed tag at the end of the struct definition.

In both cases, leaving out the packing does not change the internal
layout of the structure but changes the alignment constraint of the
structure itself.

Change all affected structures to only apply packing where it does
not violate the alignment requirement of the contained structure.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/carl9170/fwcmd.h |  2 +-
 drivers/net/wireless/ath/carl9170/wlan.h  | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/fwcmd.h b/drivers/net/wireless/ath/carl9170/fwcmd.h
index 56999a3b9d3b..4a500095555c 100644
--- a/drivers/net/wireless/ath/carl9170/fwcmd.h
+++ b/drivers/net/wireless/ath/carl9170/fwcmd.h
@@ -240,7 +240,7 @@ struct carl9170_cmd {
 		struct carl9170_bcn_ctrl_cmd	bcn_ctrl;
 		struct carl9170_rx_filter_cmd	rx_filter;
 		u8 data[CARL9170_MAX_CMD_PAYLOAD_LEN];
-	} __packed;
+	} __packed __aligned(4);
 } __packed __aligned(4);
 
 #define	CARL9170_TX_STATUS_QUEUE	3
diff --git a/drivers/net/wireless/ath/carl9170/wlan.h b/drivers/net/wireless/ath/carl9170/wlan.h
index ea17995b32f4..bb73553fd7c2 100644
--- a/drivers/net/wireless/ath/carl9170/wlan.h
+++ b/drivers/net/wireless/ath/carl9170/wlan.h
@@ -367,27 +367,27 @@ struct ar9170_rx_macstatus {
 
 struct ar9170_rx_frame_single {
 	struct ar9170_rx_head phy_head;
-	struct ieee80211_hdr i3e;
+	struct ieee80211_hdr i3e __packed __aligned(2);
 	struct ar9170_rx_phystatus phy_tail;
 	struct ar9170_rx_macstatus macstatus;
-} __packed;
+};
 
 struct ar9170_rx_frame_head {
 	struct ar9170_rx_head phy_head;
-	struct ieee80211_hdr i3e;
+	struct ieee80211_hdr i3e __packed __aligned(2);
 	struct ar9170_rx_macstatus macstatus;
-} __packed;
+};
 
 struct ar9170_rx_frame_middle {
-	struct ieee80211_hdr i3e;
+	struct ieee80211_hdr i3e __packed __aligned(2);
 	struct ar9170_rx_macstatus macstatus;
-} __packed;
+};
 
 struct ar9170_rx_frame_tail {
-	struct ieee80211_hdr i3e;
+	struct ieee80211_hdr i3e __packed __aligned(2);
 	struct ar9170_rx_phystatus phy_tail;
 	struct ar9170_rx_macstatus macstatus;
-} __packed;
+};
 
 struct ar9170_rx_frame {
 	union {
@@ -395,8 +395,8 @@ struct ar9170_rx_frame {
 		struct ar9170_rx_frame_head head;
 		struct ar9170_rx_frame_middle middle;
 		struct ar9170_rx_frame_tail tail;
-	} __packed;
-} __packed;
+	};
+};
 
 static inline u8 ar9170_get_decrypt_type(struct ar9170_rx_macstatus *t)
 {
-- 
2.29.2

