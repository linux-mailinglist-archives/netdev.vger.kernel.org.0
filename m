Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4101062AF
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729694AbfKVGCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:02:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:40892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbfKVGCU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B60F12068E;
        Fri, 22 Nov 2019 06:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402539;
        bh=oyecKgL4JJJNfN/xarrb88sIaFNFCW/ML4rY/gU8oKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zt2We2FyrrIfq9YYlqxVSElLFktd/udawJCrflpXkp8jPQvSqrLC2MuFgkoZRZQZT
         P0JcWd43iycFkZ0cIxKctQMYYpi8nUX7DJTQN6KM1lVyczgU3cEEuyGopgQxu1kmmL
         fYIJLPcEnXBuhTX9IYDbbO1R34sg0Cud/1/rhbYQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kyle Roeschley <kyle.roeschley@ni.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 46/91] ath6kl: Fix off by one error in scan completion
Date:   Fri, 22 Nov 2019 01:00:44 -0500
Message-Id: <20191122060129.4239-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kyle Roeschley <kyle.roeschley@ni.com>

[ Upstream commit 5803c12816c43bd09e5f4247dd9313c2d9a2c41b ]

When ath6kl was reworked to share code between regular and scheduled scans
in commit 3b8ffc6a22ba ("ath6kl: Configure probed SSID list consistently"),
probed SSID entry changed from 1-index to 0-indexed. However,
ath6kl_cfg80211_scan_complete_event() was missed in that change. Fix its
indexing so that we correctly clear out the probed SSID list.

Signed-off-by: Kyle Roeschley <kyle.roeschley@ni.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 0cce5a2bca161..650d2f6446a6c 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1088,7 +1088,7 @@ void ath6kl_cfg80211_scan_complete_event(struct ath6kl_vif *vif, bool aborted)
 	if (vif->scan_req->n_ssids && vif->scan_req->ssids[0].ssid_len) {
 		for (i = 0; i < vif->scan_req->n_ssids; i++) {
 			ath6kl_wmi_probedssid_cmd(ar->wmi, vif->fw_vif_idx,
-						  i + 1, DISABLE_SSID_FLAG,
+						  i, DISABLE_SSID_FLAG,
 						  0, NULL);
 		}
 	}
-- 
2.20.1

