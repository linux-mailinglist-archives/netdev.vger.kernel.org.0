Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA616339D62
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 10:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232974AbhCMJkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 04:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbhCMJkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 04:40:02 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04437C061761
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 01:40:01 -0800 (PST)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lL0kY-0002vy-C7; Sat, 13 Mar 2021 10:39:58 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next v2 4/4] net: dsa: hellcreek: Add devlink FDB region
Date:   Sat, 13 Mar 2021 10:39:39 +0100
Message-Id: <20210313093939.15179-5-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313093939.15179-1-kurt@kmk-computers.de>
References: <20210313093939.15179-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1615628402;59b7f840;
X-HE-SMSGID: 1lL0kY-0002vy-C7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to dump the FDB table via devlink. This is a useful debugging feature.

Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 62 ++++++++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h |  1 +
 2 files changed, 63 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 38ff0f12e8a4..02d8bcb37f31 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1111,18 +1111,62 @@ static int hellcreek_devlink_region_vlan_snapshot(struct devlink *dl,
 	return 0;
 }
 
+static int hellcreek_devlink_region_fdb_snapshot(struct devlink *dl,
+						 const struct devlink_region_ops *ops,
+						 struct netlink_ext_ack *extack,
+						 u8 **data)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+	struct hellcreek_fdb_entry *table, *entry;
+	struct hellcreek *hellcreek = ds->priv;
+	size_t i;
+
+	table = kcalloc(hellcreek->fdb_entries, sizeof(*entry), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	entry = table;
+
+	mutex_lock(&hellcreek->reg_lock);
+
+	/* Start table read */
+	hellcreek_read(hellcreek, HR_FDBMAX);
+	hellcreek_write(hellcreek, 0x00, HR_FDBMAX);
+
+	for (i = 0; i < hellcreek->fdb_entries; ++i, ++entry) {
+		/* Read current entry */
+		hellcreek_populate_fdb_entry(hellcreek, entry, i);
+
+		/* Advance read pointer */
+		hellcreek_write(hellcreek, 0x00, HR_FDBRDH);
+	}
+
+	mutex_unlock(&hellcreek->reg_lock);
+
+	*data = (u8 *)table;
+
+	return 0;
+}
+
 static struct devlink_region_ops hellcreek_region_vlan_ops = {
 	.name	    = "vlan",
 	.snapshot   = hellcreek_devlink_region_vlan_snapshot,
 	.destructor = kfree,
 };
 
+static struct devlink_region_ops hellcreek_region_fdb_ops = {
+	.name	    = "fdb",
+	.snapshot   = hellcreek_devlink_region_fdb_snapshot,
+	.destructor = kfree,
+};
+
 static int hellcreek_setup_devlink_regions(struct dsa_switch *ds)
 {
 	struct hellcreek *hellcreek = ds->priv;
 	struct devlink_region_ops *ops;
 	struct devlink_region *region;
 	u64 size;
+	int ret;
 
 	/* VLAN table */
 	size = VLAN_N_VID * sizeof(struct hellcreek_devlink_vlan_entry);
@@ -1134,13 +1178,31 @@ static int hellcreek_setup_devlink_regions(struct dsa_switch *ds)
 
 	hellcreek->vlan_region = region;
 
+	/* FDB table */
+	size = hellcreek->fdb_entries * sizeof(struct hellcreek_fdb_entry);
+	ops  = &hellcreek_region_fdb_ops;
+
+	region = dsa_devlink_region_create(ds, ops, 1, size);
+	if (IS_ERR(region)) {
+		ret = PTR_ERR(region);
+		goto err_fdb;
+	}
+
+	hellcreek->fdb_region = region;
+
 	return 0;
+
+err_fdb:
+	dsa_devlink_region_destroy(hellcreek->vlan_region);
+
+	return ret;
 }
 
 static void hellcreek_teardown_devlink_regions(struct dsa_switch *ds)
 {
 	struct hellcreek *hellcreek = ds->priv;
 
+	dsa_devlink_region_destroy(hellcreek->fdb_region);
 	dsa_devlink_region_destroy(hellcreek->vlan_region);
 }
 
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index 42339f9359d9..9e303b8ab13c 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -279,6 +279,7 @@ struct hellcreek {
 	struct mutex vlan_lock;	/* VLAN bitmaps lock */
 	struct mutex ptp_lock;	/* PTP IP register lock */
 	struct devlink_region *vlan_region;
+	struct devlink_region *fdb_region;
 	void __iomem *base;
 	void __iomem *ptp_base;
 	u16 swcfg;		/* swcfg shadow */
-- 
2.30.2

