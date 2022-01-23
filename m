Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE7E497069
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 07:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbiAWGyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 01:54:00 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:58724 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiAWGx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 01:53:58 -0500
Received: from pop-os.home ([90.126.236.122])
        by smtp.orange.fr with ESMTPA
        id BWl8nGtI5HZHJBWl9nOzEa; Sun, 23 Jan 2022 07:53:56 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Sun, 23 Jan 2022 07:53:56 +0100
X-ME-IP: 90.126.236.122
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        netdev@vger.kernel.org
Subject: [PATCH] net: atlantic: Use the bitmap API instead of hand-writing it
Date:   Sun, 23 Jan 2022 07:53:46 +0100
Message-Id: <27b498801eb6d9d9876b35165c57b7f8606f4da8.1642920729.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify code by using bitmap_weight() and bitmap_zero() instead of
hand-writing these functions.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/ethernet/aquantia/atlantic/aq_filters.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
index 1bc4d33a0ce5..30a573db02bb 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -826,7 +826,6 @@ int aq_filters_vlans_update(struct aq_nic_s *aq_nic)
 	struct aq_hw_s *aq_hw = aq_nic->aq_hw;
 	int hweight = 0;
 	int err = 0;
-	int i;
 
 	if (unlikely(!aq_hw_ops->hw_filter_vlan_set))
 		return -EOPNOTSUPP;
@@ -837,8 +836,7 @@ int aq_filters_vlans_update(struct aq_nic_s *aq_nic)
 			 aq_nic->aq_hw_rx_fltrs.fl2.aq_vlans);
 
 	if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		for (i = 0; i < BITS_TO_LONGS(VLAN_N_VID); i++)
-			hweight += hweight_long(aq_nic->active_vlans[i]);
+		hweight = bitmap_weight(aq_nic->active_vlans, VLAN_N_VID);
 
 		err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw, false);
 		if (err)
@@ -871,7 +869,7 @@ int aq_filters_vlan_offload_off(struct aq_nic_s *aq_nic)
 	struct aq_hw_s *aq_hw = aq_nic->aq_hw;
 	int err = 0;
 
-	memset(aq_nic->active_vlans, 0, sizeof(aq_nic->active_vlans));
+	bitmap_zero(aq_nic->active_vlans, VLAN_N_VID);
 	aq_fvlan_rebuild(aq_nic, aq_nic->active_vlans,
 			 aq_nic->aq_hw_rx_fltrs.fl2.aq_vlans);
 
-- 
2.32.0

