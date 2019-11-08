Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67B51F492C
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391560AbfKHMBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:01:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390487AbfKHLne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD6AC222C6;
        Fri,  8 Nov 2019 11:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213413;
        bh=RKRTRBPAlk+f+aw3C7A6A3UDnlrwH0Cc8yXEXBYKvkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dY4e2MvzVDfqELynxtCPL+gzwTzL1T2uDze9r8OVm5+lp4iI5CdAjXjh9UVAp+Ntd
         8zSDTtco+VzaArxVWGi+D8+26QdA/islZW7aDlN6a33qi2nlfLmRaK6PER2MECrQfG
         IHIeCBv7u7umE6FqsHjmUspXuXR9fMaHFjzgnjgM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Eckelmann <sven.eckelmann@openmesh.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 016/103] ath10k: limit available channels via DT ieee80211-freq-limit
Date:   Fri,  8 Nov 2019 06:41:41 -0500
Message-Id: <20191108114310.14363-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Eckelmann <sven.eckelmann@openmesh.com>

[ Upstream commit 34d5629d2ca89d847b7040762b87964c696c14da ]

Tri-band devices (1x 2.4GHz + 2x 5GHz) often incorporate special filters in
the RX and TX path. These filtered channel can in theory still be used by
the hardware but the signal strength is reduced so much that it makes no
sense.

There is already a DT property to limit the available channels but ath10k
has to manually call this functionality to limit the currrently set wiphy
channels further.

Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 58a3c42c4aedb..8c4bb56c262f6 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -17,6 +17,7 @@
 
 #include "mac.h"
 
+#include <net/cfg80211.h>
 #include <net/mac80211.h>
 #include <linux/etherdevice.h>
 #include <linux/acpi.h>
@@ -8174,6 +8175,7 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->bands[NL80211_BAND_5GHZ] = band;
 	}
 
+	wiphy_read_of_freq_limits(ar->hw->wiphy);
 	ath10k_mac_setup_ht_vht_cap(ar);
 
 	ar->hw->wiphy->interface_modes =
-- 
2.20.1

