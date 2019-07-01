Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC6026F2B
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 21:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731571AbfEVTZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 15:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731537AbfEVTZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 15:25:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 435F021473;
        Wed, 22 May 2019 19:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558553125;
        bh=Na5zua+BMhBNFZNBRjS6szXtRLjVmifaB5T4ebTYgO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJGFPPklFjI7gHolpv2vmnVae7GJeLZHqcmh9uBCgpjUqiZRKqc4cLiCbtxHGXU9L
         j1eOWwWtgJ+PcBI7twHdXzRJKPutYEjoPnnfK3DCqwbMxXT8i3syWS6gLiSmNCRthQ
         GLiF9IJbaVEYIIQt4WPDb99Ltpu3ksz5BEiGKXwk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.0 059/317] net: ethernet: ti: cpsw: fix allmulti cfg in dual_mac mode
Date:   Wed, 22 May 2019 15:19:20 -0400
Message-Id: <20190522192338.23715-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192338.23715-1-sashal@kernel.org>
References: <20190522192338.23715-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 06095f34f8a0a2c4c83a19514c272699edd5f80b ]

Now CPSW ALE will set/clean Host port bit in Unregistered Multicast Flood
Mask (UNREG_MCAST_FLOOD_MASK) for every VLAN without checking if this port
belongs to VLAN or not when ALLMULTI mode flag is set for nedev. This is
working in non dual_mac mode, but in dual_mac - it causes
enabling/disabling ALLMULTI flag for both ports.

Hence fix it by adding additional parameter to cpsw_ale_set_allmulti() to
specify ALE port number for which ALLMULTI has to be enabled and check if
port belongs to VLAN before modifying UNREG_MCAST_FLOOD_MASK.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/cpsw.c     | 12 +++++++++---
 drivers/net/ethernet/ti/cpsw_ale.c | 19 ++++++++++---------
 drivers/net/ethernet/ti/cpsw_ale.h |  3 +--
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index a591583d120e1..dd12b73a88530 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -800,12 +800,17 @@ static int cpsw_purge_all_mc(struct net_device *ndev, const u8 *addr, int num)
 
 static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
 {
-	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	struct cpsw_common *cpsw = priv->cpsw;
+	int slave_port = -1;
+
+	if (cpsw->data.dual_emac)
+		slave_port = priv->emac_port + 1;
 
 	if (ndev->flags & IFF_PROMISC) {
 		/* Enable promiscuous mode */
 		cpsw_set_promiscious(ndev, true);
-		cpsw_ale_set_allmulti(cpsw->ale, IFF_ALLMULTI);
+		cpsw_ale_set_allmulti(cpsw->ale, IFF_ALLMULTI, slave_port);
 		return;
 	} else {
 		/* Disable promiscuous mode */
@@ -813,7 +818,8 @@ static void cpsw_ndo_set_rx_mode(struct net_device *ndev)
 	}
 
 	/* Restore allmulti on vlans if necessary */
-	cpsw_ale_set_allmulti(cpsw->ale, ndev->flags & IFF_ALLMULTI);
+	cpsw_ale_set_allmulti(cpsw->ale,
+			      ndev->flags & IFF_ALLMULTI, slave_port);
 
 	/* add/remove mcast address either for real netdev or for vlan */
 	__hw_addr_ref_sync_dev(&ndev->mc, ndev, cpsw_add_mc_addr,
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 798c989d5d934..b3d9591b4824a 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -482,24 +482,25 @@ int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 }
 EXPORT_SYMBOL_GPL(cpsw_ale_del_vlan);
 
-void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti)
+void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti, int port)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS];
-	int type, idx;
 	int unreg_mcast = 0;
-
-	/* Only bother doing the work if the setting is actually changing */
-	if (ale->allmulti == allmulti)
-		return;
-
-	/* Remember the new setting to check against next time */
-	ale->allmulti = allmulti;
+	int type, idx;
 
 	for (idx = 0; idx < ale->params.ale_entries; idx++) {
+		int vlan_members;
+
 		cpsw_ale_read(ale, idx, ale_entry);
 		type = cpsw_ale_get_entry_type(ale_entry);
 		if (type != ALE_TYPE_VLAN)
 			continue;
+		vlan_members =
+			cpsw_ale_get_vlan_member_list(ale_entry,
+						      ale->vlan_field_bits);
+
+		if (port != -1 && !(vlan_members & BIT(port)))
+			continue;
 
 		unreg_mcast =
 			cpsw_ale_get_vlan_unreg_mcast(ale_entry,
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index cd07a3e96d576..1fe196d8a5e42 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -37,7 +37,6 @@ struct cpsw_ale {
 	struct cpsw_ale_params	params;
 	struct timer_list	timer;
 	unsigned long		ageout;
-	int			allmulti;
 	u32			version;
 	/* These bits are different on NetCP NU Switch ALE */
 	u32			port_mask_bits;
@@ -116,7 +115,7 @@ int cpsw_ale_del_mcast(struct cpsw_ale *ale, const u8 *addr, int port_mask,
 int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port, int untag,
 			int reg_mcast, int unreg_mcast);
 int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port);
-void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti);
+void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti, int port);
 
 int cpsw_ale_control_get(struct cpsw_ale *ale, int port, int control);
 int cpsw_ale_control_set(struct cpsw_ale *ale, int port,
-- 
2.20.1

