Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0DE3095E8
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 15:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbhA3OYA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 09:24:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231916AbhA3OU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 09:20:56 -0500
X-Greylist: delayed 1193 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 30 Jan 2021 06:20:16 PST
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A96C0613D6
        for <netdev@vger.kernel.org>; Sat, 30 Jan 2021 06:20:16 -0800 (PST)
Received: from p548daeed.dip0.t-ipconnect.de ([84.141.174.237] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1l5qnS-0001w1-AZ; Sat, 30 Jan 2021 15:00:18 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next 1/2] net: dsa: hellcreek: Report VLAN table occupancy
Date:   Sat, 30 Jan 2021 14:59:33 +0100
Message-Id: <20210130135934.22870-2-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210130135934.22870-1-kurt@kmk-computers.de>
References: <20210130135934.22870-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1612016416;6ebbfdd3;
X-HE-SMSGID: 1l5qnS-0001w1-AZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VLAN membership configuration is cached in software already. So, it can be
reported via devlink. Add support for it:

|root@tsn:~# devlink resource show platform/ff240000.switch
|platform/ff240000.switch:
|  name VLAN size 4096 occ 4 unit entry dpipe_tables none

Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 59 ++++++++++++++++++++++++++
 drivers/net/dsa/hirschmann/hellcreek.h |  5 +++
 2 files changed, 64 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 4cc51fb37e67..0ba0f6e81305 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1000,6 +1000,51 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 	return ret;
 }
 
+static u64 hellcreek_devlink_vlan_table_get(void *priv)
+{
+	struct hellcreek *hellcreek = priv;
+	u64 count = 0;
+	int i;
+
+	mutex_lock(&hellcreek->reg_lock);
+	for (i = 0; i < VLAN_N_VID; ++i)
+		if (hellcreek->vidmbrcfg[i])
+			count++;
+	mutex_unlock(&hellcreek->reg_lock);
+
+	return count;
+}
+
+static int hellcreek_setup_devlink_resources(struct dsa_switch *ds)
+{
+	struct devlink_resource_size_params size_params;
+	struct hellcreek *hellcreek = ds->priv;
+	int err;
+
+	devlink_resource_size_params_init(&size_params, VLAN_N_VID,
+					  VLAN_N_VID,
+					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
+
+	err = dsa_devlink_resource_register(ds, "VLAN", VLAN_N_VID,
+					    HELLCREEK_DEVLINK_PARAM_ID_VLAN_TABLE,
+					    DEVLINK_RESOURCE_ID_PARENT_TOP,
+					    &size_params);
+	if (err)
+		goto out;
+
+	dsa_devlink_resource_occ_get_register(ds,
+					      HELLCREEK_DEVLINK_PARAM_ID_VLAN_TABLE,
+					      hellcreek_devlink_vlan_table_get,
+					      hellcreek);
+
+	return 0;
+
+out:
+	dsa_devlink_resources_unregister(ds);
+
+	return err;
+}
+
 static int hellcreek_setup(struct dsa_switch *ds)
 {
 	struct hellcreek *hellcreek = ds->priv;
@@ -1053,9 +1098,22 @@ static int hellcreek_setup(struct dsa_switch *ds)
 		return ret;
 	}
 
+	/* Register devlink resources with DSA */
+	ret = hellcreek_setup_devlink_resources(ds);
+	if (ret) {
+		dev_err(hellcreek->dev,
+			"Failed to setup devlink resources!\n");
+		return ret;
+	}
+
 	return 0;
 }
 
+static void hellcreek_teardown(struct dsa_switch *ds)
+{
+	dsa_devlink_resources_unregister(ds);
+}
+
 static void hellcreek_phylink_validate(struct dsa_switch *ds, int port,
 				       unsigned long *supported,
 				       struct phylink_link_state *state)
@@ -1447,6 +1505,7 @@ static const struct dsa_switch_ops hellcreek_ds_ops = {
 	.port_vlan_del	     = hellcreek_vlan_del,
 	.port_vlan_filtering = hellcreek_vlan_filtering,
 	.setup		     = hellcreek_setup,
+	.teardown	     = hellcreek_teardown,
 };
 
 static int hellcreek_probe(struct platform_device *pdev)
diff --git a/drivers/net/dsa/hirschmann/hellcreek.h b/drivers/net/dsa/hirschmann/hellcreek.h
index 854639f87247..11539916a6be 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.h
+++ b/drivers/net/dsa/hirschmann/hellcreek.h
@@ -298,4 +298,9 @@ struct hellcreek {
 #define dw_to_hellcreek_port(dw)				\
 	container_of(dw, struct hellcreek_port, schedule_work)
 
+/* Devlink resources */
+enum hellcreek_devlink_resource_id {
+	HELLCREEK_DEVLINK_PARAM_ID_VLAN_TABLE,
+};
+
 #endif /* _HELLCREEK_H_ */
-- 
2.26.2

