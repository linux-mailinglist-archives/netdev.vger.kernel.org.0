Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE0A2106630
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728668AbfKVG30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 01:29:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727418AbfKVFt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9A90207FC;
        Fri, 22 Nov 2019 05:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401798;
        bh=1mDTrOw4fA067XJ1Z8S423pPoOETpotNdsL5AjXaYng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VT6nR9MqlL0r2ihTRBB5NM5K09TCPMdKm650PrRP8AQCzWBNo96F2Ya3ja/TXlKKc
         98mJkQdGD36tIG/olrb5Vu1iITkIN0j7Pv6ddOKlk3bfbhD1D/OODwoXh0BT01G2wC
         rsfDgKLDWyYgUvYoRwMTbl9skKMqyVDIUg2q2KEU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 045/219] mwifiex: debugfs: correct histogram spacing, formatting
Date:   Fri, 22 Nov 2019 00:46:17 -0500
Message-Id: <20191122054911.1750-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brian Norris <briannorris@chromium.org>

[ Upstream commit 4cb777c64e030778c569f605398d7604d8aabc0f ]

Currently, snippets of this file look like:

rx rates (in Mbps): 0=1M   1=2M2=5.5M  3=11M   4=6M   5=9M  6=12M
7=18M  8=24M  9=36M  10=48M  11=54M12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)
44-53=MCS0-9(VHT:BW20)54-63=MCS0-9(VHT:BW40)64-73=MCS0-9(VHT:BW80)
...
noise_flr[--96dBm] = 22
noise_flr[--95dBm] = 149
noise_flr[--94dBm] = 9
noise_flr[--93dBm] = 2

We're missing some spaces, and we're adding a minus sign ('-') on values
that are already negative signed integers.

Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/debugfs.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/debugfs.c b/drivers/net/wireless/marvell/mwifiex/debugfs.c
index cce70252fd96b..cbe4493b32664 100644
--- a/drivers/net/wireless/marvell/mwifiex/debugfs.c
+++ b/drivers/net/wireless/marvell/mwifiex/debugfs.c
@@ -273,15 +273,13 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 		     "total samples = %d\n",
 		     atomic_read(&phist_data->num_samples));
 
-	p += sprintf(p, "rx rates (in Mbps): 0=1M   1=2M");
-	p += sprintf(p, "2=5.5M  3=11M   4=6M   5=9M  6=12M\n");
-	p += sprintf(p, "7=18M  8=24M  9=36M  10=48M  11=54M");
-	p += sprintf(p, "12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)\n");
+	p += sprintf(p,
+		     "rx rates (in Mbps): 0=1M   1=2M 2=5.5M  3=11M   4=6M   5=9M  6=12M\n"
+		     "7=18M  8=24M  9=36M  10=48M  11=54M 12-27=MCS0-15(BW20) 28-43=MCS0-15(BW40)\n");
 
 	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info)) {
-		p += sprintf(p, "44-53=MCS0-9(VHT:BW20)");
-		p += sprintf(p, "54-63=MCS0-9(VHT:BW40)");
-		p += sprintf(p, "64-73=MCS0-9(VHT:BW80)\n\n");
+		p += sprintf(p,
+			     "44-53=MCS0-9(VHT:BW20) 54-63=MCS0-9(VHT:BW40) 64-73=MCS0-9(VHT:BW80)\n\n");
 	} else {
 		p += sprintf(p, "\n");
 	}
@@ -310,7 +308,7 @@ mwifiex_histogram_read(struct file *file, char __user *ubuf,
 	for (i = 0; i < MWIFIEX_MAX_NOISE_FLR; i++) {
 		value = atomic_read(&phist_data->noise_flr[i]);
 		if (value)
-			p += sprintf(p, "noise_flr[-%02ddBm] = %d\n",
+			p += sprintf(p, "noise_flr[%02ddBm] = %d\n",
 				(int)(i-128), value);
 	}
 	for (i = 0; i < MWIFIEX_MAX_SIG_STRENGTH; i++) {
-- 
2.20.1

