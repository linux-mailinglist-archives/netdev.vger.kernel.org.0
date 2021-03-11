Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1610C337C68
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhCKSWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhCKSWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 13:22:04 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD4CC061762
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 10:22:03 -0800 (PST)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lKPVb-0008Vo-Kr; Thu, 11 Mar 2021 18:54:03 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next 1/6] net: dsa: hellcreek: Report RAM usage
Date:   Thu, 11 Mar 2021 18:53:39 +0100
Message-Id: <20210311175344.3084-2-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210311175344.3084-1-kurt@kmk-computers.de>
References: <20210311175344.3084-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1615486923;d5c4f916;
X-HE-SMSGID: 1lKPVb-0008Vo-Kr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the RAM usage via devlink. This is a useful debug feature. The actual
size depends on the used Hellcreek version:

|root@tsn:~# devlink resource show platform/ff240000.switch
|platform/ff240000.switch:
|  name VLAN size 4096 occ 3 unit entry dpipe_tables none
|  name FDB size 256 occ 6 unit entry dpipe_tables none
|  name RAM size 320 occ 14 unit entry dpipe_tables none

Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 38 ++++++++++++++++++++++++--
 drivers/net/dsa/hirschmann/hellcreek.h |  2 ++
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 463137c39db2..c7a439336336 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -221,11 +221,13 @@ static void hellcreek_feature_detect(struct hellcreek *hellcreek)
 
 	features = hellcreek_read(hellcreek, HR_FEABITS0);
 
-	/* Only detect the size of the FDB table. The size and current
-	 * utilization can be queried via devlink.
+	/* Detect the FDB table size and the maximum RAM page count. The size
+	 * and current utilization can be queried via devlink.
 	 */
 	hellcreek->fdb_entries = ((features & HR_FEABITS0_FDBBINS_MASK) >>
-			       HR_FEABITS0_FDBBINS_SHIFT) * 32;
+				  HR_FEABITS0_FDBBINS_SHIFT) * 32;
+	hellcreek->page_count  = ((features & HR_FEABITS0_PCNT_MASK) >>
+				  HR_FEABITS0_PCNT_SHIFT) * 32;
 }
 
 static enum dsa_tag_protocol hellcreek_get_tag_protocol(struct dsa_switch *ds,
@@ -1034,10 +1036,23 @@ static u64 hellcreek_devlink_fdb_table_get(void *priv)
 	return count;
 }
 
+static u64 hellcreek_devlink_ram_usage_get(void *priv)
+{
+	struct hellcreek *hellcreek = priv;
+	u64 usage = 0;
+
+	/* Indicates how many free ram pages are available. */
+	usage = hellcreek_read(hellcreek, HR_PFREE);
+	usage = hellcreek->page_count - usage;
+
+	return usage;
+}
+
 static int hellcreek_setup_devlink_resources(struct dsa_switch *ds)
 {
 	struct devlink_resource_size_params size_vlan_params;
 	struct devlink_resource_size_params size_fdb_params;
+	struct devlink_resource_size_params size_ram_params;
 	struct hellcreek *hellcreek = ds->priv;
 	int err;
 
@@ -1050,6 +1065,11 @@ static int hellcreek_setup_devlink_resources(struct dsa_switch *ds)
 					  hellcreek->fdb_entries,
 					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
 
+	devlink_resource_size_params_init(&size_ram_params,
+					  hellcreek->page_count,
+					  hellcreek->page_count,
+					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
+
 	err = dsa_devlink_resource_register(ds, "VLAN", VLAN_N_VID,
 					    HELLCREEK_DEVLINK_PARAM_ID_VLAN_TABLE,
 					    DEVLINK_RESOURCE_ID_PARENT_TOP,
@@ -1064,6 +1084,13 @@ static int hellcreek_setup_devlink_resources(struct dsa_switch *ds)
 	if (err)
 		goto out;
 
+	err = dsa_devlink_resource_register(ds, "RAM", hellcreek->page_count,
+					    HELLCREEK_DEVLINK_PARAM_ID_RAM_USAGE,
+					    DEVLINK_RESOURCE_ID_PARENT_TOP,
+					    &size_ram_params);
+	if (err)
+		goto out;
+
 	dsa_devlink_resource_occ_get_register(ds,
 					      HELLCREEK_DEVLINK_PARAM_ID_VLAN_TABLE,
 					      hellcreek_devlink_vlan_table_get,
@@ -1074,6 +1101,11 @@ static int hellcreek_setup_devlink_resources(struct dsa_switch *ds)
 					      hellcreek_devlink_fdb_table_get,
 					      hellcreek);
 
+	dsa_devlink_resource_occ_get_register(ds,
+					      HELLCREEK_DEVLINK_PARAM_ID_RAM_USAGE,
+					      hellcreek_devlink_ram_usage_get,
+					      hellcreek);
+
 	return 0;
 
 out:
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index 305e76dab34d..9c08aeabbc24 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -286,6 +286,7 @@ struct hellcreek {
 	u64 last_ts;		/* Used for overflow detection */
 	u16 status_out;		/* ptp.status_out shadow */
 	size_t fdb_entries;
+	size_t page_count;
 };
 
 /* A Qbv schedule can only started up to 8 seconds in the future. If the delta
@@ -302,6 +303,7 @@ struct hellcreek {
 enum hellcreek_devlink_resource_id {
 	HELLCREEK_DEVLINK_PARAM_ID_VLAN_TABLE,
 	HELLCREEK_DEVLINK_PARAM_ID_FDB_TABLE,
+	HELLCREEK_DEVLINK_PARAM_ID_RAM_USAGE,
 };
 
 #endif /* _HELLCREEK_H_ */
-- 
2.30.2

