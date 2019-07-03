Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEB15DC26
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfGCCQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727860AbfGCCQN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 768332187F;
        Wed,  3 Jul 2019 02:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120172;
        bh=lX4Mr5SESkWVekixij8Gaj+QffjIR57OTaibDAW5Bl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zdzr3mEY6Wf6kXwMF5g5blUxFhdwBo4H5Hbele9WJgRIthHqX1kKAORzsYUAxRBii
         53K0tZw+cTaX9/1bGxX0LQANYKEKhvsJG7FXfpSDAEcBUFO9EeC/ACJD+/0vT2FO5Y
         WEyO45WvJjNhrjT4NqQll/1n1hKepU9F0jDFePSI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>,
        Igor Russkikh <igor.russkikh@aquantia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 34/39] net: aquantia: fix vlans not working over bridged network
Date:   Tue,  2 Jul 2019 22:15:09 -0400
Message-Id: <20190703021514.17727-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021514.17727-1-sashal@kernel.org>
References: <20190703021514.17727-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>

[ Upstream commit 48dd73d08d4dda47ee31cc8611fb16840fc16803 ]

In configuration of vlan over bridge over aquantia device
it was found that vlan tagged traffic is dropped on chip.

The reason is that bridge device enables promisc mode,
but in atlantic chip vlan filters will still apply.
So we have to corellate promisc settings with vlan configuration.

The solution is to track in a separate state variable the
need of vlan forced promisc. And also consider generic
promisc configuration when doing vlan filter config.

Fixes: 7975d2aff5af ("net: aquantia: add support of rx-vlan-filter offload")
Signed-off-by: Dmitry Bogdanov <dmitry.bogdanov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/aquantia/atlantic/aq_filters.c   | 10 ++++++++--
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |  1 +
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |  1 +
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 19 +++++++++++++------
 4 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
index 18bc035da850..1fff462a4175 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_filters.c
@@ -843,9 +843,14 @@ int aq_filters_vlans_update(struct aq_nic_s *aq_nic)
 		return err;
 
 	if (aq_nic->ndev->features & NETIF_F_HW_VLAN_CTAG_FILTER) {
-		if (hweight < AQ_VLAN_MAX_FILTERS)
-			err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw, true);
+		if (hweight < AQ_VLAN_MAX_FILTERS && hweight > 0) {
+			err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw,
+				!(aq_nic->packet_filter & IFF_PROMISC));
+			aq_nic->aq_nic_cfg.is_vlan_force_promisc = false;
+		} else {
 		/* otherwise left in promiscue mode */
+			aq_nic->aq_nic_cfg.is_vlan_force_promisc = true;
+		}
 	}
 
 	return err;
@@ -866,6 +871,7 @@ int aq_filters_vlan_offload_off(struct aq_nic_s *aq_nic)
 	if (unlikely(!aq_hw_ops->hw_filter_vlan_ctrl))
 		return -EOPNOTSUPP;
 
+	aq_nic->aq_nic_cfg.is_vlan_force_promisc = true;
 	err = aq_hw_ops->hw_filter_vlan_ctrl(aq_hw, false);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index ff83667410bd..550abfe6973d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -117,6 +117,7 @@ void aq_nic_cfg_start(struct aq_nic_s *self)
 
 	cfg->link_speed_msk &= cfg->aq_hw_caps->link_speed_msk;
 	cfg->features = cfg->aq_hw_caps->hw_features;
+	cfg->is_vlan_force_promisc = true;
 }
 
 static int aq_nic_update_link_status(struct aq_nic_s *self)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 8e34c1e49bf2..65e681be9b5d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -36,6 +36,7 @@ struct aq_nic_cfg_s {
 	u32 flow_control;
 	u32 link_speed_msk;
 	u32 wol;
+	bool is_vlan_force_promisc;
 	u16 is_mc_list_enabled;
 	u16 mc_list_count;
 	bool is_autoneg;
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index ec302fdfec63..a4cc04741115 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -771,8 +771,15 @@ static int hw_atl_b0_hw_packet_filter_set(struct aq_hw_s *self,
 					  unsigned int packet_filter)
 {
 	unsigned int i = 0U;
+	struct aq_nic_cfg_s *cfg = self->aq_nic_cfg;
+
+	hw_atl_rpfl2promiscuous_mode_en_set(self,
+					    IS_FILTER_ENABLED(IFF_PROMISC));
+
+	hw_atl_rpf_vlan_prom_mode_en_set(self,
+				     IS_FILTER_ENABLED(IFF_PROMISC) ||
+				     cfg->is_vlan_force_promisc);
 
-	hw_atl_rpfl2promiscuous_mode_en_set(self, IS_FILTER_ENABLED(IFF_PROMISC));
 	hw_atl_rpfl2multicast_flr_en_set(self,
 					 IS_FILTER_ENABLED(IFF_ALLMULTI), 0);
 
@@ -781,13 +788,13 @@ static int hw_atl_b0_hw_packet_filter_set(struct aq_hw_s *self,
 
 	hw_atl_rpfl2broadcast_en_set(self, IS_FILTER_ENABLED(IFF_BROADCAST));
 
-	self->aq_nic_cfg->is_mc_list_enabled = IS_FILTER_ENABLED(IFF_MULTICAST);
+	cfg->is_mc_list_enabled = IS_FILTER_ENABLED(IFF_MULTICAST);
 
 	for (i = HW_ATL_B0_MAC_MIN; i < HW_ATL_B0_MAC_MAX; ++i)
 		hw_atl_rpfl2_uc_flr_en_set(self,
-					   (self->aq_nic_cfg->is_mc_list_enabled &&
-				    (i <= self->aq_nic_cfg->mc_list_count)) ?
-				    1U : 0U, i);
+					   (cfg->is_mc_list_enabled &&
+					    (i <= cfg->mc_list_count)) ?
+					   1U : 0U, i);
 
 	return aq_hw_err_from_flags(self);
 }
@@ -1079,7 +1086,7 @@ static int hw_atl_b0_hw_vlan_set(struct aq_hw_s *self,
 static int hw_atl_b0_hw_vlan_ctrl(struct aq_hw_s *self, bool enable)
 {
 	/* set promisc in case of disabing the vland filter */
-	hw_atl_rpf_vlan_prom_mode_en_set(self, !!!enable);
+	hw_atl_rpf_vlan_prom_mode_en_set(self, !enable);
 
 	return aq_hw_err_from_flags(self);
 }
-- 
2.20.1

