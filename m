Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2843C4057E2
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353639AbhIINmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 09:42:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351834AbhIIMrd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:47:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 817D363220;
        Thu,  9 Sep 2021 11:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188589;
        bh=Jqb7XaWOx11p37FMvH/ReA+WJNCzFGBf3lqGQwH79gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=movnjE+IYV+9GnWIiFM5ZIMa66cHmb9QnNzBrSNvar5/oYJUFS+tdsjoalWd8/810
         LnIY4LlEGe1fjJHUc18mSUH6iCNUBhw7V2oMGMBHxFj+NQFBALxt9SwvNjGG5faY6C
         3wBfSDt3t+fu05F3tnG4czWNRRIQsuYKrbIP8GXTyv0VfgAdpVkT6XOAWeGDSZziXA
         Eku1KLX0ubgpOd1m2723DiFkCAlS8TdZ6667Vr8M/YVTfJ+ARlPsFvnFBe+d93Fbvd
         QEPKCSGFEr0RSnKH2yLRUdhM96aAIU2S/v4aCXiteAz9FIkqPWiZacnHYX7x0bSl+X
         W9/i+WPKjWUrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 064/109] mac80211: Fix monitor MTU limit so that A-MSDUs get through
Date:   Thu,  9 Sep 2021 07:54:21 -0400
Message-Id: <20210909115507.147917-64-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit 79f5962baea74ce1cd4e5949598944bff854b166 ]

The maximum MTU was set to 2304, which is the maximum MSDU size. While
this is valid for normal WLAN interfaces, it is too low for monitor
interfaces. A monitor interface may receive and inject MPDU frames, and
the maximum MPDU frame size is larger than 2304. The MPDU may also
contain an A-MSDU frame, in which case the size may be much larger than
the MTU limit. Since the maximum size of an A-MSDU depends on the PHY
mode of the transmitting STA, it is not possible to set an exact MTU
limit for a monitor interface. Now the maximum MTU for a monitor
interface is unrestricted.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Link: https://lore.kernel.org/r/20210628123246.2070558-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 6f576306a4d7..ddc001ad9055 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1875,9 +1875,16 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
 
-		/* MTU range: 256 - 2304 */
+		/* MTU range is normally 256 - 2304, where the upper limit is
+		 * the maximum MSDU size. Monitor interfaces send and receive
+		 * MPDU and A-MSDU frames which may be much larger so we do
+		 * not impose an upper limit in that case.
+		 */
 		ndev->min_mtu = 256;
-		ndev->max_mtu = local->hw.max_mtu;
+		if (type == NL80211_IFTYPE_MONITOR)
+			ndev->max_mtu = 0;
+		else
+			ndev->max_mtu = local->hw.max_mtu;
 
 		ret = register_netdevice(ndev);
 		if (ret) {
-- 
2.30.2

