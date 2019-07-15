Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC256960A
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389267AbfGOOOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:14:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731356AbfGOONw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:13:52 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8449206B8;
        Mon, 15 Jul 2019 14:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200031;
        bh=oiFz2NTIZMbWcBgnnWQwMU4e1+RSkgJOnzytLtRJPzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFu21eClbnjr2A/mWVk2SRxGxEkb1n1ciDJ73hH+/3RGmdOQZE2jXN1bwlyUj9NqG
         NzbCnKCcjXIWHmD8gQVUjph6INezPhbptreXkPOd+upcJhcLZcf+78m4qyq2NQQEy4
         gVoZZJ3q/BQZJpMx3D8W5ed26+vVUQzR85a13jfM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zefir Kurtisi <zefir.kurtisi@neratec.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 164/219] ath9k: correctly handle short radar pulses
Date:   Mon, 15 Jul 2019 10:02:45 -0400
Message-Id: <20190715140341.6443-164-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zefir Kurtisi <zefir.kurtisi@neratec.com>

[ Upstream commit df5c4150501ee7e86383be88f6490d970adcf157 ]

In commit 3c0efb745a17 ("ath9k: discard undersized packets")
the lower bound of RX packets was set to 10 (min ACK size) to
filter those that would otherwise be treated as invalid at
mac80211.

Alas, short radar pulses are reported as PHY_ERROR frames
with length set to 3. Therefore their detection stopped
working after that commit.

NOTE: ath9k drivers built thereafter will not pass DFS
certification.

This extends the criteria for short packets to explicitly
handle PHY_ERROR frames.

Fixes: 3c0efb745a17 ("ath9k: discard undersized packets")
Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/recv.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 4e97f7f3b2a3..06e660858766 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -815,6 +815,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_hdr *hdr;
 	bool discard_current = sc->rx.discard_next;
+	bool is_phyerr;
 
 	/*
 	 * Discard corrupt descriptors which are marked in
@@ -827,8 +828,11 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 
 	/*
 	 * Discard zero-length packets and packets smaller than an ACK
+	 * which are not PHY_ERROR (short radar pulses have a length of 3)
 	 */
-	if (rx_stats->rs_datalen < 10) {
+	is_phyerr = rx_stats->rs_status & ATH9K_RXERR_PHY;
+	if (!rx_stats->rs_datalen ||
+	    (rx_stats->rs_datalen < 10 && !is_phyerr)) {
 		RX_STAT_INC(sc, rx_len_err);
 		goto corrupt;
 	}
-- 
2.20.1

