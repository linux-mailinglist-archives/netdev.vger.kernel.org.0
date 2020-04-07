Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7121B1A0336
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728187AbgDGAHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:07:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727247AbgDGABk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9749620A8B;
        Tue,  7 Apr 2020 00:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217699;
        bh=Zg0lXdbFYkI82DZL3HsOsGw1RamNs7bH/YilUYo10QM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEMdc21AW5Rx2x7z/2rKxDrLnaXgeokOB000LhORVYR9BY/M1233pEw/vUFlr90zo
         2KuHE+NJroVn5szAWNWOp3AJQ7uFSyrQeCXIosGQgWeRHubrHjHWnGOTXCFEHt2Bfw
         wVeQw6CQCl5by7aC4R7QK4l6D8DYMUSYRtuZesHU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 32/35] cfg80211: Do not warn on same channel at the end of CSA
Date:   Mon,  6 Apr 2020 20:00:54 -0400
Message-Id: <20200407000058.16423-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 05dcb8bb258575a8dd3499d0d78bd2db633c2b23 ]

When cfg80211_update_assoc_bss_entry() is called, there is a
verification that the BSS channel actually changed. As some APs use
CSA also for bandwidth changes, this would result with a kernel
warning.

Fix this by removing the WARN_ON().

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200326150855.96316ada0e8d.I6710376b1b4257e5f4712fc7ab16e2b638d512aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index aef240fdf8df6..328402ab64a3f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2022,7 +2022,11 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 
 	spin_lock_bh(&rdev->bss_lock);
 
-	if (WARN_ON(cbss->pub.channel == chan))
+	/*
+	 * Some APs use CSA also for bandwidth changes, i.e., without actually
+	 * changing the control channel, so no need to update in such a case.
+	 */
+	if (cbss->pub.channel == chan)
 		goto done;
 
 	/* use transmitting bss */
-- 
2.20.1

