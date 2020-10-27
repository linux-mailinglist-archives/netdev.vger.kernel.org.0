Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A66D3299E54
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 01:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439564AbgJ0AOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 20:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411765AbgJ0ALd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 20:11:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DA3621707;
        Tue, 27 Oct 2020 00:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603757493;
        bh=wHsImZGjp0npO5/iLpAlz/CmDuBqLZQcm/h/wGv8+p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uhFFeur4dYjR2fAvkotcPxgQpYEM/tk206X5ZNTqbK9G64ONKedJFGTY5PYD41SxA
         WqR+3hSLJwIhmnWm2B1rWeXDKWPZ1WaQHsyv7qXsu0JsktBe26bE6SeoZ0bfqI1w70
         O2BQWI9EFobm5vCeghKL3zBpkQP7V5MgrWeOTFSg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sathishkumar Muruganandam <murugana@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/25] ath10k: fix VHT NSS calculation when STBC is enabled
Date:   Mon, 26 Oct 2020 20:11:05 -0400
Message-Id: <20201027001123.1027642-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201027001123.1027642-1-sashal@kernel.org>
References: <20201027001123.1027642-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sathishkumar Muruganandam <murugana@codeaurora.org>

[ Upstream commit 99f41b8e43b8b4b31262adb8ac3e69088fff1289 ]

When STBC is enabled, NSTS_SU value need to be accounted for VHT NSS
calculation for SU case.

Without this fix, 1SS + STBC enabled case was reported wrongly as 2SS
in radiotap header on monitor mode capture.

Tested-on: QCA9984 10.4-3.10-00047

Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1597392971-3897-1-git-send-email-murugana@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index a65b5d7f59f44..47ac9aa986dcd 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -657,6 +657,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 	u8 preamble = 0;
 	u8 group_id;
 	u32 info1, info2, info3;
+	u32 stbc, nsts_su;
 
 	info1 = __le32_to_cpu(rxd->ppdu_start.info1);
 	info2 = __le32_to_cpu(rxd->ppdu_start.info2);
@@ -700,11 +701,16 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 		   TODO check this */
 		bw = info2 & 3;
 		sgi = info3 & 1;
+		stbc = (info2 >> 3) & 1;
 		group_id = (info2 >> 4) & 0x3F;
 
 		if (GROUP_ID_IS_SU_MIMO(group_id)) {
 			mcs = (info3 >> 4) & 0x0F;
-			nss = ((info2 >> 10) & 0x07) + 1;
+			nsts_su = ((info2 >> 10) & 0x07);
+			if (stbc)
+				nss = (nsts_su >> 2) + 1;
+			else
+				nss = (nsts_su + 1);
 		} else {
 			/* Hardware doesn't decode VHT-SIG-B into Rx descriptor
 			 * so it's impossible to decode MCS. Also since
-- 
2.25.1

