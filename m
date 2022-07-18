Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36195578D98
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 00:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbiGRWg2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 18:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiGRWg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 18:36:28 -0400
X-Greylist: delayed 474 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 15:36:26 PDT
Received: from mail.aperture-lab.de (mail.aperture-lab.de [116.203.183.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3D0E22BED;
        Mon, 18 Jul 2022 15:36:26 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2ADCC3EEC0;
        Tue, 19 Jul 2022 00:28:19 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     Johannes Berg <johannes.berg@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <ll@simonwunderlich.de>
Subject: [PATCH] mac80211: Fix wrong channel bandwidths reported for aggregates
Date:   Tue, 19 Jul 2022 00:28:04 +0200
Message-Id: <20220718222804.21708-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Lüssing <ll@simonwunderlich.de>

AR9003 based wifi chips have a hardware bug, they always report a
channel bandwidth of HT40 for any sub-frame of an aggregate which is
not the last one. Only the last sub-frame has correct channel bandwidth
information.

This can be easily reproduced by setting an ath9k based wifi to HT20 and
running an iperf test. Then "iw dev wlan0 station dump" will occasionally,
wrongly show something like:

  rx bitrate:     121.5 MBit/s MCS 6 40MHz

Debug output in ath9k_hw_process_rxdesc_edma() confirmed that it is
always frames with (rxs->rs_isaggr && !rxs->rs_moreaggr) and no others
which report RATE_INFO_BW_40.

Unfortunately we cannot easily fix this within ath9k as in ath9k we
cannot peek at the rate/bandwidth info of the last aggregate
sub-frame and there is no queueing within ath9k after receiving the
frame from the wifi chip, it is directly handed over to mac80211.

Therefore fixing this within mac80211: For an aggergated AMPDU only
update the RX "last_rate" variable from the last sub-frame of an
aggregate. In theory, without hardware bugs, rate/bandwidth info
should be the same for all sub-frames of an aggregate anyway.

This change only affects ath9k, ath9k-htc and ath10k as these are
currently the only drivers implementing the RX_FLAG_AMPDU_LAST_KNOWN
flag.

Tested-on: 8devices Lima board, QCA9531 WiFi

Cc: Sven Eckelmann <sven@narfation.org>
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Cc: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Linus Lüssing <ll@simonwunderlich.de>
---
 net/mac80211/rx.c       |  8 ++++----
 net/mac80211/sta_info.h | 16 +++++++++++++---
 2 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 304b9909f025..988dbf058489 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1723,6 +1723,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	u32 *last_rate = &sta->deflink.rx_stats.last_rate;
 	int i;
 
 	if (!sta)
@@ -1744,8 +1745,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 			sta->deflink.rx_stats.last_rx = jiffies;
 			if (ieee80211_is_data(hdr->frame_control) &&
 			    !is_multicast_ether_addr(hdr->addr1))
-				sta->deflink.rx_stats.last_rate =
-					sta_stats_encode_rate(status);
+				sta_stats_encode_rate(status, last_rate);
 		}
 	} else if (rx->sdata->vif.type == NL80211_IFTYPE_OCB) {
 		sta->deflink.rx_stats.last_rx = jiffies;
@@ -1757,7 +1757,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		 */
 		sta->deflink.rx_stats.last_rx = jiffies;
 		if (ieee80211_is_data(hdr->frame_control))
-			sta->deflink.rx_stats.last_rate = sta_stats_encode_rate(status);
+			sta_stats_encode_rate(status, last_rate);
 	}
 
 	sta->deflink.rx_stats.fragments++;
@@ -4502,7 +4502,7 @@ static void ieee80211_rx_8023(struct ieee80211_rx_data *rx,
 	/* end of statistics */
 
 	stats->last_rx = jiffies;
-	stats->last_rate = sta_stats_encode_rate(status);
+	sta_stats_encode_rate(status, &stats->last_rate);
 
 	stats->fragments++;
 	stats->packets++;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 70ee55ec5518..67f9c1647567 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -941,10 +941,19 @@ enum sta_stats_type {
 
 #define STA_STATS_RATE_INVALID		0
 
-static inline u32 sta_stats_encode_rate(struct ieee80211_rx_status *s)
+static inline void
+sta_stats_encode_rate(struct ieee80211_rx_status *s, u32 *rate)
 {
 	u32 r;
 
+	/* some drivers (notably ath9k) only report a valid bandwidth
+	 * in the last subframe of an aggregate, skip the others
+	 * in that case
+	 */
+	if (s->flag & RX_FLAG_AMPDU_LAST_KNOWN &&
+	    !(s->flag & RX_FLAG_AMPDU_IS_LAST))
+		return;
+
 	r = STA_STATS_FIELD(BW, s->bw);
 
 	if (s->enc_flags & RX_ENC_FLAG_SHORT_GI)
@@ -975,10 +984,11 @@ static inline u32 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 		break;
 	default:
 		WARN_ON(1);
-		return STA_STATS_RATE_INVALID;
+		*rate = STA_STATS_RATE_INVALID;
+		return;
 	}
 
-	return r;
+	*rate = r;
 }
 
 #endif /* STA_INFO_H */
-- 
2.36.1

