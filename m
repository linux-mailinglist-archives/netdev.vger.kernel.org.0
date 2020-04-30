Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855F41C0946
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgD3VcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:32:04 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:48833 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgD3VcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:32:03 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MfHUx-1iwbf70Yfb-00gsjk; Thu, 30 Apr 2020 23:31:46 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 02/15] iwlwifi: mvm: fix gcc-10 zero-length-bounds warning
Date:   Thu, 30 Apr 2020 23:30:44 +0200
Message-Id: <20200430213101.135134-3-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200430213101.135134-1-arnd@arndb.de>
References: <20200430213101.135134-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:lQP65S7LwC6OwI92N4uIJiItdidHEpOk62jho5rpr9MQGl0HjXZ
 61U0AbdpViblUikFmv9NwFYuekR9P0SmnIQkiDlSXipkrAVHEO5BMq88MZI6NRnqryCssyS
 vpgpn5jAG/7xFSbqWmLBDyjm2Rlw6Bv246k8MEhF+J6vpqkjfjwPTx2w3YBFUamsfMxcbal
 HerQDt2KcBHgm1DPAhILQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Eq+KYWUtplI=:bbiSluhmCo/PlA0yETxveN
 90eKlGoZpYuNinQfPNl9y8guRXUHQPAj+0g31axpsZVcPGPQIAZVTwzWtyMUyfQxG6l3sH6h6
 l3lVCvXlc76LzqgpQCmXlGm+fFopVRqu3WuTm9DXXYDGMAPEK0XXCtvVnYY/mzOiJDd6QS1Mt
 3/u9JANIkGmRc9kBKOb9RnKa35mTZmvjltyFsRfK4y+VszQB4oXneTbrSoSpAGV6ET0t2F+n/
 xzqdAnY3ZpsaMHUZUAfnTnJz1Pa0NTBV9PB93OlVwqB/HKqYkIHXfWXtjU8gguSyvsu+XtG7I
 QAoRk+tRpgQUcWqY881mD74t9NCG+LAGChcI9xsmnwUjDZjxxGY5xucUtVTmYS5TvC3Eh76fW
 8Gv9ujukt+BBaiCFJIJ6Caq4IlVanpBQrP4CAxoIcz0Yuo61IGAqUETgJrl0QeEqpkwd7z3fl
 8sr1HRCBJ4C1gqZ44zf/d9OOpaRHb9MstxDL5puR5lELpXXiC8kwmqB+sFmVL0C6+3J5uaUrD
 sMm1Yctdw1a+Ivu9IZfw9ml3xm87F9vvwJ2aIOFnlEBC4kAwQLpomxwb29vpAqGTtNpTrpod3
 REeXd699bO6GkcXhnbbB6oXrEmf2M8Dyf3ZTM86BQpj0slz4AKvjTDzVSdhfT9kzwVjiDohLz
 tm6q5qBybVGwplf5fUHJNU/ITmwvRsnVSMUWlQI2RKmCbfmUfTpuanzVRYdtrJ9gfZZQYS9M1
 2qrJRipmwEi5Nk/wjWFRbOpP0kyaUbQkm4tnAlas9Q9cH9IKjvHnf2OaBDyEbfbqNFzzlOZcv
 5dfXRPv3v1jXC7lgTp20eNIXHMkuri0PCRNJaEX/W1NQ+48kDI=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc-10 complains when a zero-length array is accessed:

drivers/net/wireless/intel/iwlwifi/mvm/tx.c: In function 'iwl_mvm_rx_ba_notif':
drivers/net/wireless/intel/iwlwifi/mvm/tx.c:1929:17: warning: array subscript 9 is outside the bounds of an interior zero-length array 'struct iwl_mvm_compressed_ba_tfd[0]' [-Wzero-length-bounds]
 1929 |     &ba_res->tfd[i];
      |      ~~~~~~~~~~~^~~
In file included from drivers/net/wireless/intel/iwlwifi/mvm/../fw/api/tdls.h:68,
                 from drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h:68,
                 from drivers/net/wireless/intel/iwlwifi/mvm/sta.h:73,
                 from drivers/net/wireless/intel/iwlwifi/mvm/mvm.h:83,
                 from drivers/net/wireless/intel/iwlwifi/mvm/tx.c:72:
drivers/net/wireless/intel/iwlwifi/mvm/../fw/api/tx.h:769:35: note: while referencing 'tfd'
  769 |  struct iwl_mvm_compressed_ba_tfd tfd[0];
      |                                   ^~~

Change this structure to use a flexible-array member for 'tfd' instead,
along with the various structures using an zero-length ieee80211_hdr
array that do not show warnings today but might be affected by similar
issues in the future.

Fixes: 6f68cc367ab6 ("iwlwifi: api: annotate compressed BA notif array sizes")
Fixes: c46e7724bfe9 ("iwlwifi: mvm: support new BA notification response")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index f1d1fe96fecc..82d59b5a5f8c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -293,7 +293,7 @@ struct iwl_tx_cmd {
 	__le16 pm_frame_timeout;
 	__le16 reserved4;
 	u8 payload[0];
-	struct ieee80211_hdr hdr[0];
+	struct ieee80211_hdr hdr[];
 } __packed; /* TX_CMD_API_S_VER_6 */
 
 struct iwl_dram_sec_info {
@@ -319,7 +319,7 @@ struct iwl_tx_cmd_gen2 {
 	__le32 flags;
 	struct iwl_dram_sec_info dram_info;
 	__le32 rate_n_flags;
-	struct ieee80211_hdr hdr[0];
+	struct ieee80211_hdr hdr[];
 } __packed; /* TX_CMD_API_S_VER_7 */
 
 /**
@@ -342,7 +342,7 @@ struct iwl_tx_cmd_gen3 {
 	struct iwl_dram_sec_info dram_info;
 	__le32 rate_n_flags;
 	__le64 ttl;
-	struct ieee80211_hdr hdr[0];
+	struct ieee80211_hdr hdr[];
 } __packed; /* TX_CMD_API_S_VER_8 */
 
 /*
@@ -766,8 +766,8 @@ struct iwl_mvm_compressed_ba_notif {
 	__le32 tx_rate;
 	__le16 tfd_cnt;
 	__le16 ra_tid_cnt;
-	struct iwl_mvm_compressed_ba_tfd tfd[0];
 	struct iwl_mvm_compressed_ba_ratid ra_tid[0];
+	struct iwl_mvm_compressed_ba_tfd tfd[];
 } __packed; /* COMPRESSED_BA_RES_API_S_VER_4 */
 
 /**
@@ -784,7 +784,7 @@ struct iwl_mac_beacon_cmd_v6 {
 	__le32 template_id;
 	__le32 tim_idx;
 	__le32 tim_size;
-	struct ieee80211_hdr frame[0];
+	struct ieee80211_hdr frame[];
 } __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_6 */
 
 /**
@@ -805,7 +805,7 @@ struct iwl_mac_beacon_cmd_v7 {
 	__le32 tim_size;
 	__le32 ecsa_offset;
 	__le32 csa_offset;
-	struct ieee80211_hdr frame[0];
+	struct ieee80211_hdr frame[];
 } __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_7 */
 
 enum iwl_mac_beacon_flags {
@@ -840,7 +840,7 @@ struct iwl_mac_beacon_cmd {
 	__le32 tim_size;
 	__le32 ecsa_offset;
 	__le32 csa_offset;
-	struct ieee80211_hdr frame[0];
+	struct ieee80211_hdr frame[];
 } __packed; /* BEACON_TEMPLATE_CMD_API_S_VER_10 */
 
 struct iwl_beacon_notif {
-- 
2.26.0

