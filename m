Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCAE404F5B
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350975AbhIIMSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352741AbhIIMPI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:15:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 33DC561A3A;
        Thu,  9 Sep 2021 11:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188166;
        bh=DGJlaWkXczT7hs0YZrX1UHK2Uy0SYQKrZyStzYEnIvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJdNst1JyjYFESXbHxhUecutKlbFYkxP9X3z5dLdcuNIqg7gb+AKFUeSkW0EJpSOi
         TGmjFGR0ymKxGfPEia2EjE9o4mrOkAaJnpS+NMA+cNWgoaZ9fnMHNS4mHHGhrkdx7Y
         +WSIY9/pQyP5d/U51QtkBi0ly39Jaddo46no6dsEwxfPWTgmJ+mpc263FolTUwpE+m
         O7LqTNepBWP+ELQXaigzsFC6PwrpguPXRGUiebmGv7xQA5p+gUyMZkOgpLqRM6L/aT
         /UyoomhYYZJl4FXyq3Jt9PogchMIVBoE6H5unD6sksH0fDJZUeiUaBPofyRN1PlVtn
         WblWxWl60wZfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 131/219] mac80211: Fix monitor MTU limit so that A-MSDUs get through
Date:   Thu,  9 Sep 2021 07:45:07 -0400
Message-Id: <20210909114635.143983-131-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
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
index 137fa4c50e07..8df7ab34911c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1985,9 +1985,16 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
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
 
 		ret = cfg80211_register_netdevice(ndev);
 		if (ret) {
-- 
2.30.2

