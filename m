Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86E80404C04
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 13:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242328AbhIILz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 07:55:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242573AbhIILwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 07:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0115A61100;
        Thu,  9 Sep 2021 11:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187861;
        bh=xHfzP72TZyDPRk8pGAwmlKS+B0g1x+9BYa0SUdCdils=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sVwcZKh+hzP2J+67+aMTvK9u02C7XhI3iKnQaL2Af8Tfxt2yxGMFhEKOThIN8NTFb
         QvnpANeHudBkBjpB31xZ3/8jD0rejWMxEnxNcyUGeoEyoU9nxhMDJqaGYj/w9KM5Hv
         4KWiBSIkD0GhZjrO71PU1Ws0E1WdV8+pkHOIvhJjLg6/GLlcXK93FajVDnhB/zM1cD
         ntzAiUvEBZMnxeFCkqwWSLdXbmWe1u+20JhUyoxmwb5uqsuDkvrWaFJkkr4y/SnD+0
         7z+MPWgac0VpzN3haHFGt3miWsdpa7VYmgXx2fnGucq380JlRyG2NwzB3W5ISDHJEY
         bofMoDpoGi7hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 149/252] mac80211: Fix monitor MTU limit so that A-MSDUs get through
Date:   Thu,  9 Sep 2021 07:39:23 -0400
Message-Id: <20210909114106.141462-149-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index 1e5e9fc45523..cd96cd337aa8 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2001,9 +2001,16 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
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

