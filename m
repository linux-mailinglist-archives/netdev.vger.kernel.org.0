Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6FE01A59DE
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730955AbgDKXja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728687AbgDKXHi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 19:07:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CC5F217D8;
        Sat, 11 Apr 2020 23:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646458;
        bh=gd10e2c/wzZb0TFnZI+DI1l+5W6eeDsygfka7Ju+dhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hu3seVpba3gUR6z+KzXDcd4VTEak3KH6BhcbunEU/iYoufppxVR9i+gtvL7J/o/If
         wTqQpch3exefrM0eVgrhJf1Rx1bQAg3nbRIJ3AjJlVY0AIrEGcvCfXESA4yBJRIRFm
         Fq0Kk1Tzuc/aT0qte5Gw5wHw1vEp18MOnIgvZo+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yibo Zhao <yiboz@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 027/121] ath10k: fix not registering airtime of 11a station with WMM disable
Date:   Sat, 11 Apr 2020 19:05:32 -0400
Message-Id: <20200411230706.23855-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yibo Zhao <yiboz@codeaurora.org>

[ Upstream commit f9680c75d187f2d5b9288c02f7a432041d4447b4 ]

The tid of 11a station with WMM disable reported by FW is 0x10 in
tx completion. The tid 16 is mapped to a NULL txq since buffer
MMPDU capbility is not supported. Then 11a station's airtime will
not be registered due to NULL txq check. As a results, airtime of
11a station keeps unchanged in debugfs system.

Mask the tid along with IEEE80211_QOS_CTL_TID_MASK to make it in
the valid range.

Hardwares tested : QCA9984
Firmwares tested : 10.4-3.10-00047

Signed-off-by: Yibo Zhao <yiboz@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index d95b63f133abf..c249fbc8d2dd8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2732,7 +2732,8 @@ static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
 			continue;
 		}
 
-		tid = FIELD_GET(HTT_TX_PPDU_DUR_INFO0_TID_MASK, info0);
+		tid = FIELD_GET(HTT_TX_PPDU_DUR_INFO0_TID_MASK, info0) &
+						IEEE80211_QOS_CTL_TID_MASK;
 		tx_duration = __le32_to_cpu(ppdu_dur->tx_duration);
 
 		ieee80211_sta_register_airtime(peer->sta, tid, tx_duration, 0);
-- 
2.20.1

