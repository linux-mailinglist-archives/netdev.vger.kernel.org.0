Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAE2FF201
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731958AbfKPQQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:16:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:53676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729597AbfKPPrD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:03 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62F8D2133F;
        Sat, 16 Nov 2019 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919222;
        bh=kZ8zWA2dW+43AmUKUBWUQPRKVQv73HqDZw+2W139/QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b4ggr0lHaemtpOzYvpM3QVjjjyV1n/ND5yHRmN/6bcVbn4sen8rcAKOEebXCc+ju7
         Yd47gmL43zIPUfUYaLjlsP1w32tWFXDYbIx3pENgVodIhVoDQDYjoNJNR1rcx6WJv1
         xwPlw1r4b3pMnbLru0uRHfASeZGvmHDSZhx8wGCI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sriram R <srirrama@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 226/237] cfg80211: Prevent regulatory restore during STA disconnect in concurrent interfaces
Date:   Sat, 16 Nov 2019 10:41:01 -0500
Message-Id: <20191116154113.7417-226-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriram R <srirrama@codeaurora.org>

[ Upstream commit 113f3aaa81bd56aba02659786ed65cbd9cb9a6fc ]

Currently when an AP and STA interfaces are active in the same or different
radios, regulatory settings are restored whenever the STA disconnects. This
restores all channel information including dfs states in all radios.
For example, if an AP interface is active in one radio and STA in another,
when radar is detected on the AP interface, the dfs state of the channel
will be changed to UNAVAILABLE. But when the STA interface disconnects,
this issues a regulatory disconnect hint which restores all regulatory
settings in all the radios attached and thereby losing the stored dfs
state on the other radio where the channel was marked as unavailable
earlier. Hence prevent such regulatory restore whenever another active
beaconing interface is present in the same or other radios.

Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index d536b07582f8c..c7047c7b4e80f 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -642,11 +642,15 @@ static bool cfg80211_is_all_idle(void)
 	 * All devices must be idle as otherwise if you are actively
 	 * scanning some new beacon hints could be learned and would
 	 * count as new regulatory hints.
+	 * Also if there is any other active beaconing interface we
+	 * need not issue a disconnect hint and reset any info such
+	 * as chan dfs state, etc.
 	 */
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 			wdev_lock(wdev);
-			if (wdev->conn || wdev->current_bss)
+			if (wdev->conn || wdev->current_bss ||
+			    cfg80211_beaconing_iface_active(wdev))
 				is_all_idle = false;
 			wdev_unlock(wdev);
 		}
-- 
2.20.1

