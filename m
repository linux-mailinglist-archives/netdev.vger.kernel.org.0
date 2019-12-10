Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 939C8119402
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbfLJVMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:12:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729003AbfLJVMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:33 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1255B2077B;
        Tue, 10 Dec 2019 21:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012352;
        bh=MI13WdruNkQxoyQuvMsnulcUQpenwMohsKZ7fBvKQJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQoTKO08ouX7/FvlXYcat5m/fh4liNgUne3T3G82NanT98mzt0CEx+aY8Lorb00r3
         kJU3FReOXws43LU4H2ANx3Pvm0VPmYsqWkAHg8Aj4SGB7pp14llWO8ZvVJkuL1K50V
         TXIM0GJ4yeQzMMzz1k9esW9syerY7lbtExNVQg0o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 282/350] qtnfmac: fix invalid channel information output
Date:   Tue, 10 Dec 2019 16:06:27 -0500
Message-Id: <20191210210735.9077-243-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[ Upstream commit 24227a9e956a7c9913a7e6e7199a9ae3f540fe88 ]

Do not attempt to print frequency for an invalid channel
provided by firmware. That channel may simply not exist.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/quantenna/qtnfmac/event.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/event.c b/drivers/net/wireless/quantenna/qtnfmac/event.c
index b57c8c18a8d01..7846383c88283 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/event.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/event.c
@@ -171,8 +171,9 @@ qtnf_event_handle_bss_join(struct qtnf_vif *vif,
 		return -EPROTO;
 	}
 
-	pr_debug("VIF%u.%u: BSSID:%pM status:%u\n",
-		 vif->mac->macid, vif->vifid, join_info->bssid, status);
+	pr_debug("VIF%u.%u: BSSID:%pM chan:%u status:%u\n",
+		 vif->mac->macid, vif->vifid, join_info->bssid,
+		 le16_to_cpu(join_info->chan.chan.center_freq), status);
 
 	if (status != WLAN_STATUS_SUCCESS)
 		goto done;
@@ -181,7 +182,7 @@ qtnf_event_handle_bss_join(struct qtnf_vif *vif,
 	if (!cfg80211_chandef_valid(&chandef)) {
 		pr_warn("MAC%u.%u: bad channel freq=%u cf1=%u cf2=%u bw=%u\n",
 			vif->mac->macid, vif->vifid,
-			chandef.chan->center_freq,
+			chandef.chan ? chandef.chan->center_freq : 0,
 			chandef.center_freq1,
 			chandef.center_freq2,
 			chandef.width);
-- 
2.20.1

