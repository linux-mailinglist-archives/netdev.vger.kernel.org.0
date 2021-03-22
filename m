Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41EF344F1A
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhCVSv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 14:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbhCVSv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 14:51:27 -0400
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4378DC061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 11:51:27 -0700 (PDT)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lOPe7-0001pZ-Fy; Mon, 22 Mar 2021 19:51:23 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next v2] net: dsa: hellcreek: Report switch name and ID
Date:   Mon, 22 Mar 2021 19:51:13 +0100
Message-Id: <20210322185113.18095-1-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1616439087;336673db;
X-HE-SMSGID: 1lOPe7-0001pZ-Fy
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the driver name, ASIC ID and the switch name via devlink. This is a
useful information for user space tooling.

Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
Changes since v1:

 * Include just the model name in ASIC ID

drivers/net/dsa/hirschmann/hellcreek.c         | 18 ++++++++++++++++++
 .../linux/platform_data/hirschmann-hellcreek.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 64a73dd045c0..918be7eb626f 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1082,6 +1082,22 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 	return ret;
 }
 
+static int hellcreek_devlink_info_get(struct dsa_switch *ds,
+				      struct devlink_info_req *req,
+				      struct netlink_ext_ack *extack)
+{
+	struct hellcreek *hellcreek = ds->priv;
+	int ret;
+
+	ret = devlink_info_driver_name_put(req, "hellcreek");
+	if (ret)
+		return ret;
+
+	return devlink_info_version_fixed_put(req,
+					      DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
+					      hellcreek->pdata->name);
+}
+
 static u64 hellcreek_devlink_vlan_table_get(void *priv)
 {
 	struct hellcreek *hellcreek = priv;
@@ -1732,6 +1748,7 @@ static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
 }
 
 static const struct dsa_switch_ops hellcreek_ds_ops = {
+	.devlink_info_get      = hellcreek_devlink_info_get,
 	.get_ethtool_stats     = hellcreek_get_ethtool_stats,
 	.get_sset_count	       = hellcreek_get_sset_count,
 	.get_strings	       = hellcreek_get_strings,
@@ -1909,6 +1926,7 @@ static int hellcreek_remove(struct platform_device *pdev)
 }
 
 static const struct hellcreek_platform_data de1soc_r1_pdata = {
+	.name		 = "r4c30",
 	.num_ports	 = 4,
 	.is_100_mbits	 = 1,
 	.qbv_support	 = 1,
diff --git a/include/linux/platform_data/hirschmann-hellcreek.h b/include/linux/platform_data/hirschmann-hellcreek.h
index 388846766bb2..6a000df5541f 100644
--- a/include/linux/platform_data/hirschmann-hellcreek.h
+++ b/include/linux/platform_data/hirschmann-hellcreek.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 
 struct hellcreek_platform_data {
+	const char *name;	/* Switch name */
 	int num_ports;		/* Amount of switch ports */
 	int is_100_mbits;	/* Is it configured to 100 or 1000 mbit/s */
 	int qbv_support;	/* Qbv support on front TSN ports */
-- 
2.31.0

