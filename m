Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB9C68ACC
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730476AbfGONgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730419AbfGONgB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:36:01 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB28C2083D;
        Mon, 15 Jul 2019 13:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563197760;
        bh=KCYLOsGoG359+oREF2v3J7YYuSkQnjbjlMV7bKPIiJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i97cgAHeCGwdgnJHQfG4ooJYd2PvBbn+WCEJw//CmSeA+RUHuPkBT14EyCRtXzBkI
         1tU3bHFUrAWvqgxBdPNTHBfsgIWXXZ3vQTk3yM90I8RXlneUF52av6vsDU+RQUjWaZ
         RpoEmVk32w3XLzdWT7XchsytsbVti1MYRcn7kgOs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Miguel Catalan Cid <miguel.catalan@i2cat.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 004/249] ath9k: Don't trust TX status TID number when reporting airtime
Date:   Mon, 15 Jul 2019 09:31:45 -0400
Message-Id: <20190715133550.1772-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715133550.1772-1-sashal@kernel.org>
References: <20190715133550.1772-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

[ Upstream commit 389b72e58259336c2d56d58b660b79cf4b9e0dcb ]

As already noted a comment in ath_tx_complete_aggr(), the hardware will
occasionally send a TX status with the wrong tid number. If we trust the
value, airtime usage will be reported to the wrong AC, which can cause the
deficit on that AC to become very low, blocking subsequent attempts to
transmit.

To fix this, account airtime usage to the TID number from the original skb,
instead of the one in the hardware TX status report.

Reported-by: Miguel Catalan Cid <miguel.catalan@i2cat.net>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index b17e1ca40995..3be0aeedb9b5 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -668,7 +668,8 @@ static bool bf_is_ampdu_not_probing(struct ath_buf *bf)
 static void ath_tx_count_airtime(struct ath_softc *sc,
 				 struct ieee80211_sta *sta,
 				 struct ath_buf *bf,
-				 struct ath_tx_status *ts)
+				 struct ath_tx_status *ts,
+				 u8 tid)
 {
 	u32 airtime = 0;
 	int i;
@@ -679,7 +680,7 @@ static void ath_tx_count_airtime(struct ath_softc *sc,
 		airtime += rate_dur * bf->rates[i].count;
 	}
 
-	ieee80211_sta_register_airtime(sta, ts->tid, airtime, 0);
+	ieee80211_sta_register_airtime(sta, tid, airtime, 0);
 }
 
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
@@ -709,7 +710,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 	if (sta) {
 		struct ath_node *an = (struct ath_node *)sta->drv_priv;
 		tid = ath_get_skb_tid(sc, an, bf->bf_mpdu);
-		ath_tx_count_airtime(sc, sta, bf, ts);
+		ath_tx_count_airtime(sc, sta, bf, ts, tid->tidno);
 		if (ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY))
 			tid->clear_ps_filter = true;
 	}
-- 
2.20.1

