Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB0344A136
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241612AbhKIBID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:08:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237809AbhKIBGM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:06:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 345CE61A0B;
        Tue,  9 Nov 2021 01:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419765;
        bh=j4DogJZl2Vu+zsxMLerayzNIup6aEJcDiqFmY097EUs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqMjEawZcvI1vnGIl6dlyczpyTTP+eRZqSyjCb+qIUtOyCa6BzOa86vcwyrb8T/k3
         VBhi3mPOhH6i5qT7Fn8kdbrpzYhtVYS14UV7HOPeAbRtTSmNSrKVv7POpjXrgcaSuz
         5bXLvb3VAicdJuUeQnbsw/apg8JpBZ1HfwM/6+wsWmoPDN9l7YyXO+4V6dnxUieYb6
         1HDLkXp9Cg85w9VbKI69AzeT99DlT96AI/2QZ6tF7BjXungic1gWGOinPaV1PoZ0yP
         H37cUOeFQC3kLwlHxRha4ywWXAIO4cdXgtpmZ7jkqKkPW+CEIxKOyqTAJUiHVfnwHX
         fSrqT/vOs/mtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sriram R <srirrama@codeaurora.org>,
        Jouni Malinen <jouni@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 030/138] ath11k: Avoid reg rules update during firmware recovery
Date:   Mon,  8 Nov 2021 12:44:56 -0500
Message-Id: <20211108174644.1187889-30-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sriram R <srirrama@codeaurora.org>

[ Upstream commit 69a0fcf8a9f2273040d03e5ee77c9689c09e9d3a ]

During firmware recovery, the default reg rules which are
received via WMI_REG_CHAN_LIST_CC_EVENT can overwrite
the currently configured user regd.

See below snap for example,

root@OpenWrt:/# iw reg get | grep country
country FR: DFS-ETSI
country FR: DFS-ETSI
country FR: DFS-ETSI
country FR: DFS-ETSI

root@OpenWrt:/# echo assert > /sys/kernel/debug/ath11k/ipq8074\ hw2.0/simulate_f
w_crash
<snip>
[ 5290.471696] ath11k c000000.wifi1: pdev 1 successfully recovered

root@OpenWrt:/# iw reg get | grep country
country FR: DFS-ETSI
country US: DFS-FCC
country US: DFS-FCC
country US: DFS-FCC

In the above, the user configured country 'FR' is overwritten
when the rules of default country 'US' are received and updated during
recovery. Hence avoid processing of these rules in general
during firmware recovery as they have been already applied during
driver registration or after last set user country is configured.

This scenario applies for both AP and STA devices basically because
cfg80211 is not aware of the recovery and only the driver recovers, but
changing or resetting of the reg domain during recovery is not needed so
as to continue with the configured regdomain currently in use.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01460-QCAHKSWPL_SILICONZ-1

Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210721212029.142388-3-jouni@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 27c060dd3fb47..fa27115483c6c 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -5793,6 +5793,17 @@ static int ath11k_reg_chan_list_event(struct ath11k_base *ab, struct sk_buff *sk
 
 	pdev_idx = reg_info->phy_id;
 
+	/* Avoid default reg rule updates sent during FW recovery if
+	 * it is already available
+	 */
+	spin_lock(&ab->base_lock);
+	if (test_bit(ATH11K_FLAG_RECOVERY, &ab->dev_flags) &&
+	    ab->default_regd[pdev_idx]) {
+		spin_unlock(&ab->base_lock);
+		goto mem_free;
+	}
+	spin_unlock(&ab->base_lock);
+
 	if (pdev_idx >= ab->num_radios) {
 		/* Process the event for phy0 only if single_pdev_only
 		 * is true. If pdev_idx is valid but not 0, discard the
-- 
2.33.0

