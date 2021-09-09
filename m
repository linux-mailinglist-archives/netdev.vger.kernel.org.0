Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8E74051DE
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354447AbhIIMjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:39:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353606AbhIIMep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:34:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50C3C61B64;
        Thu,  9 Sep 2021 11:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188417;
        bh=5Tmo5EoUoUNPILBlPgR5l9L/1NDvicyyvoVo8uwBhKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9wAKuOAccQ/wN+rxQuiY2ZsC7xME/EaWkcAnXPWVGB/l3XAxyaXZJ3U6P/ydBdW7
         qgqSt2aqSAtemOM+c7fLL54KM3kPVlJ+iZaSywBFAKWX/rtew+GJonuKfLqvuA2803
         PNh7mFtxwTFUGmjx0ifslSaZXo06GuUi0zAr0KGcC6PQ/dqjv1DMLlFaQyf3IVqbwF
         dZk+0zFxhap2HkvQqIda7vgvsd0EgPRD0VBMLgPFAkpgnHdSkiDsxs2aIMYTBQwfSC
         URA7oVIM6va/hUr0oFEhRzNINgD+A9b73luSgI9qHx/IMrof1aZqw0pNJGcGeJeVdR
         qdnuQi9KzTu5g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 107/176] mac80211: Fix monitor MTU limit so that A-MSDUs get through
Date:   Thu,  9 Sep 2021 07:50:09 -0400
Message-Id: <20210909115118.146181-107-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 30589b4c09da..3a15ef8dd322 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2000,9 +2000,16 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
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

