Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB81026C93
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733206AbfEVTfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:35:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387411AbfEVTaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:30:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5944320675;
        Wed, 22 May 2019 19:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553455;
        bh=dy+5KZ5Z6sM0uLoTtO033MuHDREOBbOfD0kSQTitNdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LupdFhiImBzeJM6/X96F+Kmfy3NjFui3zx531C3LC4zp7XS78N8H71Qwln7igTrHt
         +/nEpeGl6k6mzJ8uKY4dJbxtH1Mvsw+bEjw43kcJ7Piy6UawlhXIbFU6v8rKr4BCJR
         gBhEUPI484wMtVraUE5IXEyxAwVLC+r/KLE7YMGQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kangjie Lu <kjlu@umn.edu>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 024/114] net: cw1200: fix a NULL pointer dereference
Date:   Wed, 22 May 2019 15:28:47 -0400
Message-Id: <20190522193017.26567-24-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522193017.26567-1-sashal@kernel.org>
References: <20190522193017.26567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kangjie Lu <kjlu@umn.edu>

[ Upstream commit 0ed2a005347400500a39ea7c7318f1fea57fb3ca ]

In case create_singlethread_workqueue fails, the fix free the
hardware and returns NULL to avoid NULL pointer dereference.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/st/cw1200/main.c b/drivers/net/wireless/st/cw1200/main.c
index dc478cedbde0d..84624c812a15f 100644
--- a/drivers/net/wireless/st/cw1200/main.c
+++ b/drivers/net/wireless/st/cw1200/main.c
@@ -345,6 +345,11 @@ static struct ieee80211_hw *cw1200_init_common(const u8 *macaddr,
 	mutex_init(&priv->wsm_cmd_mux);
 	mutex_init(&priv->conf_mutex);
 	priv->workqueue = create_singlethread_workqueue("cw1200_wq");
+	if (!priv->workqueue) {
+		ieee80211_free_hw(hw);
+		return NULL;
+	}
+
 	sema_init(&priv->scan.lock, 1);
 	INIT_WORK(&priv->scan.work, cw1200_scan_work);
 	INIT_DELAYED_WORK(&priv->scan.probe_work, cw1200_probe_work);
-- 
2.20.1

