Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7320D3096CE
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 17:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhA3QgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 11:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbhA3OVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 09:21:38 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5FFC061786
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 06:20:26 -0800 (PST)
Received: from p548daeed.dip0.t-ipconnect.de ([84.141.174.237] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1l5qnT-0001w1-B1; Sat, 30 Jan 2021 15:00:19 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next 2/2] net: dsa: hellcreek: Report FDB table occupancy
Date:   Sat, 30 Jan 2021 14:59:34 +0100
Message-Id: <20210130135934.22870-3-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210130135934.22870-1-kurt@kmk-computers.de>
References: <20210130135934.22870-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1612016426;36b6e8c3;
X-HE-SMSGID: 1l5qnT-0001w1-B1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the FDB table size and occupancy via devlink. The actual size depends on
the used Hellcreek version:

|root@tsn:~# devlink resource show platform/ff240000.switch
|platform/ff240000.switch:
|  name VLAN size 4096 occ 2 unit entry dpipe_tables none
|  name FDB size 256 occ 6 unit entry dpipe_tables none

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 46 ++++++++++++++++++++++----
 drivers/net/dsa/hirschmann/hellcreek.h |  1 +
 2 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 0ba0f6e81305..f984ca75a71f 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -221,12 +221,11 @@ static void hellcreek_feature_detect(struct hellcreek *hellcreek)
 
 	features = hellcreek_read(hellcreek, HR_FEABITS0);
 
-	/* Currently we only detect the size of the FDB table */
+	/* Only detect the size of the FDB table. The size and current
+	 * utilization can be queried via devlink.
+	 */
 	hellcreek->fdb_entries = ((features & HR_FEABITS0_FDBBINS_MASK) >>
 			       HR_FEABITS0_FDBBINS_SHIFT) * 32;
-
-	dev_info(hellcreek->dev, "Feature detect: FDB entries=%zu\n",
-		 hellcreek->fdb_entries);
 }
 
 static enum dsa_tag_protocol hellcreek_get_tag_protocol(struct dsa_switch *ds,
@@ -1015,20 +1014,48 @@ static u64 hellcreek_devlink_vlan_table_get(void *priv)
 	return count;
 }
 
+static u64 hellcreek_devlink_fdb_table_get(void *priv)
+{
+	struct hellcreek *hellcreek = priv;
+	u64 count = 0;
+
+	/* Reading this register has side effects. Synchronize against the other
+	 * FDB operations.
+	 */
+	mutex_lock(&hellcreek->reg_lock);
+	count = hellcreek_read(hellcreek, HR_FDBMAX);
+	mutex_unlock(&hellcreek->reg_lock);
+
+	return count;
+}
+
 static int hellcreek_setup_devlink_resources(struct dsa_switch *ds)
 {
-	struct devlink_resource_size_params size_params;
+	struct devlink_resource_size_params size_vlan_params;
+	struct devlink_resource_size_params size_fdb_params;
 	struct hellcreek *hellcreek = ds->priv;
 	int err;
 
-	devlink_resource_size_params_init(&size_params, VLAN_N_VID,
+	devlink_resource_size_params_init(&size_vlan_params, VLAN_N_VID,
 					  VLAN_N_VID,
 					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
 
+	devlink_resource_size_params_init(&size_fdb_params,
+					  hellcreek->fdb_entries,
+					  hellcreek->fdb_entries,
+					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
+
 	err = dsa_devlink_resource_register(ds, "VLAN", VLAN_N_VID,
 					    HELLCREEK_DEVLINK_PARAM_ID_VLAN_TABLE,
 					    DEVLINK_RESOURCE_ID_PARENT_TOP,
-					    &size_params);
+					    &size_vlan_params);
+	if (err)
+		goto out;
+
+	err = dsa_devlink_resource_register(ds, "FDB", hellcreek->fdb_entries,
+					    HELLCREEK_DEVLINK_PARAM_ID_FDB_TABLE,
+					    DEVLINK_RESOURCE_ID_PARENT_TOP,
+					    &size_fdb_params);
 	if (err)
 		goto out;
 
@@ -1037,6 +1064,11 @@ static int hellcreek_setup_devlink_resources(struct dsa_switch *ds)
 					      hellcreek_devlink_vlan_table_get,
 					      hellcreek);
 
+	dsa_devlink_resource_occ_get_register(ds,
+					      HELLCREEK_DEVLINK_PARAM_ID_FDB_TABLE,
+					      hellcreek_devlink_fdb_table_get,
+					      hellcreek);
+
 	return 0;
 
 out:
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index 11539916a6be..305e76dab34d 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -301,6 +301,7 @@ struct hellcreek {
 /* Devlink resources */
 enum hellcreek_devlink_resource_id {
 	HELLCREEK_DEVLINK_PARAM_ID_VLAN_TABLE,
+	HELLCREEK_DEVLINK_PARAM_ID_FDB_TABLE,
 };
 
 #endif /* _HELLCREEK_H_ */
-- 
2.26.2

