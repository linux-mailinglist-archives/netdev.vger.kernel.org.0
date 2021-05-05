Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12D03373FE1
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbhEEQca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234119AbhEEQcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AD9061176;
        Wed,  5 May 2021 16:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232287;
        bh=GC0JSQP6TWY1b0lfwONIKL+869Qk61wRxyZRS4vVIz8=;
        h=From:To:Cc:Subject:Date:From;
        b=b0Sw1VTBifF255lbkOLmJaO5Tt+/31rE0B7vguzYdVrcW3p1Gt5Wf8gFNSXLR1Aza
         FuhxhWAAWKmc5BbDth5eWD9yQQaEvi/wJbHzytWljJG80A/gtZVXY6JMsNA0J88Cop
         5D7TcQg7TjVDS6auIt5uESbJE7ubUa1vDVNRktKqwwkmSDFMweg2+r/3qfmn+LGOUq
         mJD6PxT/4Zp3y9eIMlpALYLDaX8L3QfpY8SsmQld2mlMeMkBSswnDrPXlLjWvd6xG/
         1Gr8w9HitkGy458yAeDQyOrLS0z+6NFaILVSYyMDaz7smVmShOgIswIqZz64bn+why
         toCXgwTisQUHg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 001/116] ath11k: fix thermal temperature read
Date:   Wed,  5 May 2021 12:29:29 -0400
Message-Id: <20210505163125.3460440-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>

[ Upstream commit e3de5bb7ac1a4cb262f8768924fd3ef6182b10bb ]

Fix dangling pointer in thermal temperature event which causes
incorrect temperature read.

Tested-on: IPQ8074 AHB WLAN.HK.2.4.0.1-00041-QCAHKSWPL_SILICONZ-1

Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210218182708.8844-1-pradeepc@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 53 +++++++++++----------------
 1 file changed, 21 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index cccfd3bd4d27..ca5cda890d58 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5417,31 +5417,6 @@ int ath11k_wmi_pull_fw_stats(struct ath11k_base *ab, struct sk_buff *skb,
 	return 0;
 }
 
-static int
-ath11k_pull_pdev_temp_ev(struct ath11k_base *ab, u8 *evt_buf,
-			 u32 len, const struct wmi_pdev_temperature_event *ev)
-{
-	const void **tb;
-	int ret;
-
-	tb = ath11k_wmi_tlv_parse_alloc(ab, evt_buf, len, GFP_ATOMIC);
-	if (IS_ERR(tb)) {
-		ret = PTR_ERR(tb);
-		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
-		return ret;
-	}
-
-	ev = tb[WMI_TAG_PDEV_TEMPERATURE_EVENT];
-	if (!ev) {
-		ath11k_warn(ab, "failed to fetch pdev temp ev");
-		kfree(tb);
-		return -EPROTO;
-	}
-
-	kfree(tb);
-	return 0;
-}
-
 size_t ath11k_wmi_fw_stats_num_vdevs(struct list_head *head)
 {
 	struct ath11k_fw_stats_vdev *i;
@@ -6849,23 +6824,37 @@ ath11k_wmi_pdev_temperature_event(struct ath11k_base *ab,
 				  struct sk_buff *skb)
 {
 	struct ath11k *ar;
-	struct wmi_pdev_temperature_event ev = {0};
+	const void **tb;
+	const struct wmi_pdev_temperature_event *ev;
+	int ret;
+
+	tb = ath11k_wmi_tlv_parse_alloc(ab, skb->data, skb->len, GFP_ATOMIC);
+	if (IS_ERR(tb)) {
+		ret = PTR_ERR(tb);
+		ath11k_warn(ab, "failed to parse tlv: %d\n", ret);
+		return;
+	}
 
-	if (ath11k_pull_pdev_temp_ev(ab, skb->data, skb->len, &ev) != 0) {
-		ath11k_warn(ab, "failed to extract pdev temperature event");
+	ev = tb[WMI_TAG_PDEV_TEMPERATURE_EVENT];
+	if (!ev) {
+		ath11k_warn(ab, "failed to fetch pdev temp ev");
+		kfree(tb);
 		return;
 	}
 
 	ath11k_dbg(ab, ATH11K_DBG_WMI,
-		   "pdev temperature ev temp %d pdev_id %d\n", ev.temp, ev.pdev_id);
+		   "pdev temperature ev temp %d pdev_id %d\n", ev->temp, ev->pdev_id);
 
-	ar = ath11k_mac_get_ar_by_pdev_id(ab, ev.pdev_id);
+	ar = ath11k_mac_get_ar_by_pdev_id(ab, ev->pdev_id);
 	if (!ar) {
-		ath11k_warn(ab, "invalid pdev id in pdev temperature ev %d", ev.pdev_id);
+		ath11k_warn(ab, "invalid pdev id in pdev temperature ev %d", ev->pdev_id);
+		kfree(tb);
 		return;
 	}
 
-	ath11k_thermal_event_temperature(ar, ev.temp);
+	ath11k_thermal_event_temperature(ar, ev->temp);
+
+	kfree(tb);
 }
 
 static void ath11k_fils_discovery_event(struct ath11k_base *ab,
-- 
2.30.2

