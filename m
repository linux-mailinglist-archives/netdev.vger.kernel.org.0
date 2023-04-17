Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063286E536A
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 22:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbjDQU6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 16:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbjDQU6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 16:58:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4614C17;
        Mon, 17 Apr 2023 13:55:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C1C362A46;
        Mon, 17 Apr 2023 20:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC1FC433EF;
        Mon, 17 Apr 2023 20:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681764894;
        bh=moYYi4bJv8zGeQ0K0+Ne+l5Pi5iujfuXRILl1xpKhX4=;
        h=From:To:Cc:Subject:Date:From;
        b=U80ja+1SzcQ202GY/MR/HKPGvEWUeI+Xc2gUAU5uNT5lGU/HSaRvyE8BxOaMLO5tL
         xRIasBX5T/QwtzhQ+2rLuEKOV9HrGGBzOiYPEOxooWyM6UqZAi9oHAwYHb5ZHo/9t+
         VavPigphAxfhdnYbUUn4LS17ceOwbrjNzAmhNzbP67u7QLV6PG9jI9BunFH9GieKBI
         Rf4w/fSR1d4GJfu2B8zueaVftAseqsHM73MTVSRDQlMQGrlNarbhp6ks3tR8epgFrn
         i4d56r8ZG895VfwH+ys+nUe4wioyJptqFqAChbslE+wIrTTtBaS4FJV5Vg+L1GmdSp
         TBCz7Lip00L9w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Wen Gong <quic_wgong@quicinc.com>,
        Baochen Qiang <quic_bqiang@quicinc.com>,
        Sowmiya Sree Elavalagan <quic_ssreeela@quicinc.com>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath12k@lists.infradead.org
Subject: [PATCH] wireless: ath: work around false-positive stringop-overread warning
Date:   Mon, 17 Apr 2023 22:54:20 +0200
Message-Id: <20230417205447.1800912-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

In a rare arm64 randconfig build, I got multiple warnings for ath11k
and ath12k:

In function 'ath11k_peer_assoc_h_ht',
    inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:2665:2:
drivers/net/wireless/ath/ath11k/mac.c:1709:13: error: 'ath11k_peer_assoc_h_ht_masked' reading 10 bytes from a region of size 0 [-Werror=stringop-overread]
 1709 |         if (ath11k_peer_assoc_h_ht_masked(ht_mcs_mask))
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This happens whenever gcc-13 fails to inline one of the functions
that take a fixed-length array argument but gets passed a pointer.

Change these functions to all take a regular pointer argument
instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath11k/mac.c | 12 ++++++------
 drivers/net/wireless/ath/ath12k/mac.c |  8 ++++----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index cad832e0e6b8..393669be7847 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -433,7 +433,7 @@ u8 ath11k_mac_bitrate_to_idx(const struct ieee80211_supported_band *sband,
 }
 
 static u32
-ath11k_mac_max_ht_nss(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+ath11k_mac_max_ht_nss(const u8 *ht_mcs_mask)
 {
 	int nss;
 
@@ -445,7 +445,7 @@ ath11k_mac_max_ht_nss(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
 }
 
 static u32
-ath11k_mac_max_vht_nss(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
+ath11k_mac_max_vht_nss(const u16 *vht_mcs_mask)
 {
 	int nss;
 
@@ -457,7 +457,7 @@ ath11k_mac_max_vht_nss(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
 }
 
 static u32
-ath11k_mac_max_he_nss(const u16 he_mcs_mask[NL80211_HE_NSS_MAX])
+ath11k_mac_max_he_nss(const u16 *he_mcs_mask)
 {
 	int nss;
 
@@ -1658,7 +1658,7 @@ static void ath11k_peer_assoc_h_rates(struct ath11k *ar,
 }
 
 static bool
-ath11k_peer_assoc_h_ht_masked(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+ath11k_peer_assoc_h_ht_masked(const u8 *ht_mcs_mask)
 {
 	int nss;
 
@@ -1670,7 +1670,7 @@ ath11k_peer_assoc_h_ht_masked(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
 }
 
 static bool
-ath11k_peer_assoc_h_vht_masked(const u16 vht_mcs_mask[])
+ath11k_peer_assoc_h_vht_masked(const u16 *vht_mcs_mask)
 {
 	int nss;
 
@@ -2065,7 +2065,7 @@ static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
 }
 
 static bool
-ath11k_peer_assoc_h_he_masked(const u16 he_mcs_mask[NL80211_HE_NSS_MAX])
+ath11k_peer_assoc_h_he_masked(const u16 *he_mcs_mask)
 {
 	int nss;
 
diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index d683a0668989..ea2313b6b759 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -381,7 +381,7 @@ u8 ath12k_mac_bitrate_to_idx(const struct ieee80211_supported_band *sband,
 }
 
 static u32
-ath12k_mac_max_ht_nss(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+ath12k_mac_max_ht_nss(const u8 *ht_mcs_mask)
 {
 	int nss;
 
@@ -393,7 +393,7 @@ ath12k_mac_max_ht_nss(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
 }
 
 static u32
-ath12k_mac_max_vht_nss(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
+ath12k_mac_max_vht_nss(const u16 *vht_mcs_mask)
 {
 	int nss;
 
@@ -1303,7 +1303,7 @@ static void ath12k_peer_assoc_h_rates(struct ath12k *ar,
 }
 
 static bool
-ath12k_peer_assoc_h_ht_masked(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
+ath12k_peer_assoc_h_ht_masked(const u8 *ht_mcs_mask)
 {
 	int nss;
 
@@ -1315,7 +1315,7 @@ ath12k_peer_assoc_h_ht_masked(const u8 ht_mcs_mask[IEEE80211_HT_MCS_MASK_LEN])
 }
 
 static bool
-ath12k_peer_assoc_h_vht_masked(const u16 vht_mcs_mask[NL80211_VHT_NSS_MAX])
+ath12k_peer_assoc_h_vht_masked(const u16 *vht_mcs_mask)
 {
 	int nss;
 
-- 
2.39.2

