Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEDC1D3CAD
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbgENTJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:09:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:51500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728469AbgENSww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:52:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66FB1207C3;
        Thu, 14 May 2020 18:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482371;
        bh=0MrHvY0ae7Y33Xk5nmDJ/oINsCWIQXnx0aX1FFVz2FY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hr4dLLkknZJIDfFRR1EldDB/8rLtRdA1gdJwlOpoYHOWZ+d2Y31sP7s9euJSpp2Lb
         +0kM3/ZCzkZ9GjVC63/BaW1vTp2U6PLb8n1IUgIIoo8q6ft9lcwY8vD3z4EpNwjEht
         Iu9Gi0ojiVi/BM9s0+uhh89r3+Px8dkua0ONkoR4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 49/62] net: dsa: ocelot: the MAC table on Felix is twice as large
Date:   Thu, 14 May 2020 14:51:34 -0400
Message-Id: <20200514185147.19716-49-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185147.19716-1-sashal@kernel.org>
References: <20200514185147.19716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 21ce7f3e16fbf89faaf149cfe0f730edfc553914 ]

When running 'bridge fdb dump' on Felix, sometimes learnt and static MAC
addresses would appear, sometimes they wouldn't.

Turns out, the MAC table has 4096 entries on VSC7514 (Ocelot) and 8192
entries on VSC9959 (Felix), so the existing code from the Ocelot common
library only dumped half of Felix's MAC table. They are both organized
as a 4-way set-associative TCAM, so we just need a single variable
indicating the correct number of rows.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/ocelot/felix.c          | 1 +
 drivers/net/dsa/ocelot/felix.h          | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c  | 1 +
 drivers/net/ethernet/mscc/ocelot.c      | 6 ++----
 drivers/net/ethernet/mscc/ocelot_regs.c | 1 +
 include/soc/mscc/ocelot.h               | 1 +
 6 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 9e895ab586d5a..a7780c06fa65b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -397,6 +397,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_stats	= felix->info->num_stats;
 	ocelot->shared_queue_sz	= felix->info->shared_queue_sz;
+	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->ops		= felix->info->ops;
 
 	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 3a7580015b621..8771d40324f10 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -15,6 +15,7 @@ struct felix_info {
 	const u32 *const		*map;
 	const struct ocelot_ops		*ops;
 	int				shared_queue_sz;
+	int				num_mact_rows;
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
 	int				num_ports;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2c812b481778c..edc1a67c002b6 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1090,6 +1090,7 @@ struct felix_info felix_info_vsc9959 = {
 	.stats_layout		= vsc9959_stats_layout,
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
 	.shared_queue_sz	= 128 * 1024,
+	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.switch_pci_bar		= 4,
 	.imdio_pci_bar		= 0,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index b14286dc49fb5..33ef8690eafe9 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1016,10 +1016,8 @@ int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 {
 	int i, j;
 
-	/* Loop through all the mac tables entries. There are 1024 rows of 4
-	 * entries.
-	 */
-	for (i = 0; i < 1024; i++) {
+	/* Loop through all the mac tables entries. */
+	for (i = 0; i < ocelot->num_mact_rows; i++) {
 		for (j = 0; j < 4; j++) {
 			struct ocelot_mact_entry entry;
 			bool is_static;
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index b88b5899b2273..7d4fd1b6addaf 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -431,6 +431,7 @@ int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	ocelot->stats_layout = ocelot_stats_layout;
 	ocelot->num_stats = ARRAY_SIZE(ocelot_stats_layout);
 	ocelot->shared_queue_sz = 224 * 1024;
+	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
 	ret = ocelot_regfields_init(ocelot, ocelot_regfields);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index f8e1955c86f14..7b5382e10bd29 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -437,6 +437,7 @@ struct ocelot {
 	unsigned int			num_stats;
 
 	int				shared_queue_sz;
+	int				num_mact_rows;
 
 	struct net_device		*hw_bridge_dev;
 	u16				bridge_mask;
-- 
2.20.1

