Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41CAB339D65
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 10:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhCMJko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 04:40:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbhCMJkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 04:40:02 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13E4C061574
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 01:40:01 -0800 (PST)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lL0kX-0002vy-8h; Sat, 13 Mar 2021 10:39:57 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next v2 1/4] net: dsa: hellcreek: Add devlink VLAN region
Date:   Sat, 13 Mar 2021 10:39:36 +0100
Message-Id: <20210313093939.15179-2-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313093939.15179-1-kurt@kmk-computers.de>
References: <20210313093939.15179-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1615628402;59b7f840;
X-HE-SMSGID: 1lL0kX-0002vy-8h
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow to dump the VLAN table via devlink. This especially useful, because the
driver internally leverages VLANs for the port separation. These are not visible
via the bridge utility.

Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 74 ++++++++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h |  6 +++
 2 files changed, 80 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 463137c39db2..4a14760e2680 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1082,6 +1082,67 @@ static int hellcreek_setup_devlink_resources(struct dsa_switch *ds)
 	return err;
 }
 
+static int hellcreek_devlink_region_vlan_snapshot(struct devlink *dl,
+						  const struct devlink_region_ops *ops,
+						  struct netlink_ext_ack *extack,
+						  u8 **data)
+{
+	struct hellcreek_devlink_vlan_entry *table, *entry;
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
+	struct hellcreek *hellcreek = ds->priv;
+	int i;
+
+	table = kcalloc(VLAN_N_VID, sizeof(*entry), GFP_KERNEL);
+	if (!table)
+		return -ENOMEM;
+
+	entry = table;
+
+	mutex_lock(&hellcreek->reg_lock);
+	for (i = 0; i < VLAN_N_VID; ++i, ++entry) {
+		entry->member = hellcreek->vidmbrcfg[i];
+		entry->vid    = i;
+	}
+	mutex_unlock(&hellcreek->reg_lock);
+
+	*data = (u8 *)table;
+
+	return 0;
+}
+
+static struct devlink_region_ops hellcreek_region_vlan_ops = {
+	.name	    = "vlan",
+	.snapshot   = hellcreek_devlink_region_vlan_snapshot,
+	.destructor = kfree,
+};
+
+static int hellcreek_setup_devlink_regions(struct dsa_switch *ds)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	struct devlink_region_ops *ops;
+	struct devlink_region *region;
+	u64 size;
+
+	/* VLAN table */
+	size = VLAN_N_VID * sizeof(struct hellcreek_devlink_vlan_entry);
+	ops  = &hellcreek_region_vlan_ops;
+
+	region = dsa_devlink_region_create(ds, ops, 1, size);
+	if (IS_ERR(region))
+		return PTR_ERR(region);
+
+	hellcreek->vlan_region = region;
+
+	return 0;
+}
+
+static void hellcreek_teardown_devlink_regions(struct dsa_switch *ds)
+{
+	struct hellcreek *hellcreek = ds->priv;
+
+	dsa_devlink_region_destroy(hellcreek->vlan_region);
+}
+
 static int hellcreek_setup(struct dsa_switch *ds)
 {
 	struct hellcreek *hellcreek = ds->priv;
@@ -1143,11 +1204,24 @@ static int hellcreek_setup(struct dsa_switch *ds)
 		return ret;
 	}
 
+	ret = hellcreek_setup_devlink_regions(ds);
+	if (ret) {
+		dev_err(hellcreek->dev,
+			"Failed to setup devlink regions!\n");
+		goto err_regions;
+	}
+
 	return 0;
+
+err_regions:
+	dsa_devlink_resources_unregister(ds);
+
+	return ret;
 }
 
 static void hellcreek_teardown(struct dsa_switch *ds)
 {
+	hellcreek_teardown_devlink_regions(ds);
 	dsa_devlink_resources_unregister(ds);
 }
 
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index 305e76dab34d..42339f9359d9 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -278,6 +278,7 @@ struct hellcreek {
 	struct mutex reg_lock;	/* Switch IP register lock */
 	struct mutex vlan_lock;	/* VLAN bitmaps lock */
 	struct mutex ptp_lock;	/* PTP IP register lock */
+	struct devlink_region *vlan_region;
 	void __iomem *base;
 	void __iomem *ptp_base;
 	u16 swcfg;		/* swcfg shadow */
@@ -304,4 +305,9 @@ enum hellcreek_devlink_resource_id {
 	HELLCREEK_DEVLINK_PARAM_ID_FDB_TABLE,
 };
 
+struct hellcreek_devlink_vlan_entry {
+	u16 vid;
+	u16 member;
+};
+
 #endif /* _HELLCREEK_H_ */
-- 
2.30.2

