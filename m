Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B640FE5CCA
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfJZNSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbfJZNSI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6546222C1;
        Sat, 26 Oct 2019 13:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095887;
        bh=WwaPMs6a0XVnuyot8vmAQRgX38Uz3dfCVG1j8TJ1ExI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A5QrFRJ8zZrBnG49srjq5nUguepx4f34IL2vJycn1TsnEFUqtYfV7eJTU8ey6uoA4
         +q9+KoT3GV4Z3RM5ixSmcvXoz4eb9vUdLr3MkqM3xyerFYNS8TfwxAdE+ZlILoP9dF
         qiw4TsFTO21Z7Y6yTRG4bc0To57gzyuztFbUTThA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 71/99] net: aquantia: correctly handle macvlan and multicast coexistence
Date:   Sat, 26 Oct 2019 09:15:32 -0400
Message-Id: <20191026131600.2507-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit 9f051db566da1e8110659ab4ab188af1c2510bb4 ]

macvlan and multicast handling is now mixed up.
The explicit issue is that macvlan interface gets broken (no traffic)
after clearing MULTICAST flag on the real interface.

We now do separate logic and consider both ALLMULTI and MULTICAST
flags on the device.

Fixes: 11ba961c9161 ("net: aquantia: Fix IFF_ALLMULTI flag functionality")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/aquantia/atlantic/aq_main.c  |  4 +--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 32 +++++++++----------
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  7 ++--
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index b4a0fb281e69e..bb65dd39f8474 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -194,9 +194,7 @@ static void aq_ndev_set_multicast_settings(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 
-	aq_nic_set_packet_filter(aq_nic, ndev->flags);
-
-	aq_nic_set_multicast_list(aq_nic, ndev);
+	(void)aq_nic_set_multicast_list(aq_nic, ndev);
 }
 
 static int aq_ndo_vlan_rx_add_vid(struct net_device *ndev, __be16 proto,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 8f66e78178118..2a18439b36fbe 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -631,9 +631,12 @@ int aq_nic_set_packet_filter(struct aq_nic_s *self, unsigned int flags)
 
 int aq_nic_set_multicast_list(struct aq_nic_s *self, struct net_device *ndev)
 {
-	unsigned int packet_filter = self->packet_filter;
+	const struct aq_hw_ops *hw_ops = self->aq_hw_ops;
+	struct aq_nic_cfg_s *cfg = &self->aq_nic_cfg;
+	unsigned int packet_filter = ndev->flags;
 	struct netdev_hw_addr *ha = NULL;
 	unsigned int i = 0U;
+	int err = 0;
 
 	self->mc_list.count = 0;
 	if (netdev_uc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
@@ -641,29 +644,26 @@ int aq_nic_set_multicast_list(struct aq_nic_s *self, struct net_device *ndev)
 	} else {
 		netdev_for_each_uc_addr(ha, ndev) {
 			ether_addr_copy(self->mc_list.ar[i++], ha->addr);
-
-			if (i >= AQ_HW_MULTICAST_ADDRESS_MAX)
-				break;
 		}
 	}
 
-	if (i + netdev_mc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
-		packet_filter |= IFF_ALLMULTI;
-	} else {
-		netdev_for_each_mc_addr(ha, ndev) {
-			ether_addr_copy(self->mc_list.ar[i++], ha->addr);
-
-			if (i >= AQ_HW_MULTICAST_ADDRESS_MAX)
-				break;
+	cfg->is_mc_list_enabled = !!(packet_filter & IFF_MULTICAST);
+	if (cfg->is_mc_list_enabled) {
+		if (i + netdev_mc_count(ndev) > AQ_HW_MULTICAST_ADDRESS_MAX) {
+			packet_filter |= IFF_ALLMULTI;
+		} else {
+			netdev_for_each_mc_addr(ha, ndev) {
+				ether_addr_copy(self->mc_list.ar[i++],
+						ha->addr);
+			}
 		}
 	}
 
 	if (i > 0 && i <= AQ_HW_MULTICAST_ADDRESS_MAX) {
-		packet_filter |= IFF_MULTICAST;
 		self->mc_list.count = i;
-		self->aq_hw_ops->hw_multicast_list_set(self->aq_hw,
-						       self->mc_list.ar,
-						       self->mc_list.count);
+		err = hw_ops->hw_multicast_list_set(self->aq_hw,
+						    self->mc_list.ar,
+						    self->mc_list.count);
 	}
 	return aq_nic_set_packet_filter(self, packet_filter);
 }
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 30f7fc4c97ff4..e6b5ab9b5bae7 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -818,14 +818,15 @@ static int hw_atl_b0_hw_packet_filter_set(struct aq_hw_s *self,
 				     cfg->is_vlan_force_promisc);
 
 	hw_atl_rpfl2multicast_flr_en_set(self,
-					 IS_FILTER_ENABLED(IFF_ALLMULTI), 0);
+					 IS_FILTER_ENABLED(IFF_ALLMULTI) &&
+					 IS_FILTER_ENABLED(IFF_MULTICAST), 0);
 
 	hw_atl_rpfl2_accept_all_mc_packets_set(self,
-					       IS_FILTER_ENABLED(IFF_ALLMULTI));
+					      IS_FILTER_ENABLED(IFF_ALLMULTI) &&
+					      IS_FILTER_ENABLED(IFF_MULTICAST));
 
 	hw_atl_rpfl2broadcast_en_set(self, IS_FILTER_ENABLED(IFF_BROADCAST));
 
-	cfg->is_mc_list_enabled = IS_FILTER_ENABLED(IFF_MULTICAST);
 
 	for (i = HW_ATL_B0_MAC_MIN; i < HW_ATL_B0_MAC_MAX; ++i)
 		hw_atl_rpfl2_uc_flr_en_set(self,
-- 
2.20.1

