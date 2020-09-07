Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1DE260195
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 19:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731157AbgIGRHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 13:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730656AbgIGQcr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 12:32:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E9B021556;
        Mon,  7 Sep 2020 16:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599496367;
        bh=C5nYHHmzLBhPiD7ig2bFdxvJ0Nr7tdZERMtqLZ99Zg0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lPpgcKYiPGCdVhN9hlAUKtDKtff+92OWpkNMe9w+ZEKPgtMYO5OcZLaSL4mxQQmmP
         PbjlyECOE7JnvElHiKKJCNYoLhKyRWeHitnQ+L7Q+ufRfpcIcRyLAfivqdqu1jj5TA
         3p9+w0zjeYUnaWVIMybUBj66kTz9sD8/XXDA31ng=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 20/53] mac80211: reduce packet loss event false positives
Date:   Mon,  7 Sep 2020 12:31:46 -0400
Message-Id: <20200907163220.1280412-20-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200907163220.1280412-1-sashal@kernel.org>
References: <20200907163220.1280412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 47df8e059b49a80c179fae39256bcd7096810934 ]

When running a large number of packets per second with a high data rate
and long A-MPDUs, the packet loss threshold can be reached very quickly
when the link conditions change. This frequently shows up as spurious
disconnects.
Mitigate false positives by using a similar logic for regular stations
as the one being used for TDLS, though with a more aggressive timeout.
Packet loss events are only reported if no ACK was received for a second.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20200808172542.41628-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/sta_info.h |  4 ++--
 net/mac80211/status.c   | 31 +++++++++++++++----------------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 49728047dfad6..f66fcce8e6a45 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -522,7 +522,7 @@ struct ieee80211_sta_rx_stats {
  * @status_stats.retry_failed: # of frames that failed after retry
  * @status_stats.retry_count: # of retries attempted
  * @status_stats.lost_packets: # of lost packets
- * @status_stats.last_tdls_pkt_time: timestamp of last TDLS packet
+ * @status_stats.last_pkt_time: timestamp of last ACKed packet
  * @status_stats.msdu_retries: # of MSDU retries
  * @status_stats.msdu_failed: # of failed MSDUs
  * @status_stats.last_ack: last ack timestamp (jiffies)
@@ -595,7 +595,7 @@ struct sta_info {
 		unsigned long filtered;
 		unsigned long retry_failed, retry_count;
 		unsigned int lost_packets;
-		unsigned long last_tdls_pkt_time;
+		unsigned long last_pkt_time;
 		u64 msdu_retries[IEEE80211_NUM_TIDS + 1];
 		u64 msdu_failed[IEEE80211_NUM_TIDS + 1];
 		unsigned long last_ack;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index cbc40b358ba26..819c4221c284e 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -755,12 +755,16 @@ static void ieee80211_report_used_skb(struct ieee80211_local *local,
  *  - current throughput (higher value for higher tpt)?
  */
 #define STA_LOST_PKT_THRESHOLD	50
+#define STA_LOST_PKT_TIME	HZ		/* 1 sec since last ACK */
 #define STA_LOST_TDLS_PKT_THRESHOLD	10
 #define STA_LOST_TDLS_PKT_TIME		(10*HZ) /* 10secs since last ACK */
 
 static void ieee80211_lost_packet(struct sta_info *sta,
 				  struct ieee80211_tx_info *info)
 {
+	unsigned long pkt_time = STA_LOST_PKT_TIME;
+	unsigned int pkt_thr = STA_LOST_PKT_THRESHOLD;
+
 	/* If driver relies on its own algorithm for station kickout, skip
 	 * mac80211 packet loss mechanism.
 	 */
@@ -773,21 +777,20 @@ static void ieee80211_lost_packet(struct sta_info *sta,
 		return;
 
 	sta->status_stats.lost_packets++;
-	if (!sta->sta.tdls &&
-	    sta->status_stats.lost_packets < STA_LOST_PKT_THRESHOLD)
-		return;
+	if (sta->sta.tdls) {
+		pkt_time = STA_LOST_TDLS_PKT_TIME;
+		pkt_thr = STA_LOST_PKT_THRESHOLD;
+	}
 
 	/*
 	 * If we're in TDLS mode, make sure that all STA_LOST_TDLS_PKT_THRESHOLD
 	 * of the last packets were lost, and that no ACK was received in the
 	 * last STA_LOST_TDLS_PKT_TIME ms, before triggering the CQM packet-loss
 	 * mechanism.
+	 * For non-TDLS, use STA_LOST_PKT_THRESHOLD and STA_LOST_PKT_TIME
 	 */
-	if (sta->sta.tdls &&
-	    (sta->status_stats.lost_packets < STA_LOST_TDLS_PKT_THRESHOLD ||
-	     time_before(jiffies,
-			 sta->status_stats.last_tdls_pkt_time +
-			 STA_LOST_TDLS_PKT_TIME)))
+	if (sta->status_stats.lost_packets < pkt_thr ||
+	    !time_after(jiffies, sta->status_stats.last_pkt_time + pkt_time))
 		return;
 
 	cfg80211_cqm_pktloss_notify(sta->sdata->dev, sta->sta.addr,
@@ -1035,9 +1038,7 @@ static void __ieee80211_tx_status(struct ieee80211_hw *hw,
 					sta->status_stats.lost_packets = 0;
 
 				/* Track when last TDLS packet was ACKed */
-				if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
-					sta->status_stats.last_tdls_pkt_time =
-						jiffies;
+				sta->status_stats.last_pkt_time = jiffies;
 			} else if (noack_success) {
 				/* nothing to do here, do not account as lost */
 			} else {
@@ -1170,9 +1171,8 @@ void ieee80211_tx_status_ext(struct ieee80211_hw *hw,
 			if (sta->status_stats.lost_packets)
 				sta->status_stats.lost_packets = 0;
 
-			/* Track when last TDLS packet was ACKed */
-			if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
-				sta->status_stats.last_tdls_pkt_time = jiffies;
+			/* Track when last packet was ACKed */
+			sta->status_stats.last_pkt_time = jiffies;
 		} else if (test_sta_flag(sta, WLAN_STA_PS_STA)) {
 			return;
 		} else if (noack_success) {
@@ -1261,8 +1261,7 @@ void ieee80211_tx_status_8023(struct ieee80211_hw *hw,
 			if (sta->status_stats.lost_packets)
 				sta->status_stats.lost_packets = 0;
 
-			if (test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
-				sta->status_stats.last_tdls_pkt_time = jiffies;
+			sta->status_stats.last_pkt_time = jiffies;
 		} else {
 			ieee80211_lost_packet(sta, info);
 		}
-- 
2.25.1

