Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D59E342C23
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 12:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbhCTL2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 07:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhCTL2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 07:28:01 -0400
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE38C0613E7
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 04:28:01 -0700 (PDT)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lNZlt-0000NL-Nu; Sat, 20 Mar 2021 12:27:57 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next] net: dsa: hellcreek: Report switch name and ID
Date:   Sat, 20 Mar 2021 12:27:15 +0100
Message-Id: <20210320112715.8667-1-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1616239681;f6241b06;
X-HE-SMSGID: 1lNZlt-0000NL-Nu
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report the driver name, ASIC ID and the switch name via devlink. This is a
useful information for user space tooling.

Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c         | 18 ++++++++++++++++++
 .../linux/platform_data/hirschmann-hellcreek.h |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 6cba02307bda..dd4d22a607d6 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1086,6 +1086,22 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
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
@@ -1796,6 +1812,7 @@ static int hellcreek_port_setup_tc(struct dsa_switch *ds, int port,
 }
 
 static const struct dsa_switch_ops hellcreek_ds_ops = {
+	.devlink_info_get      = hellcreek_devlink_info_get,
 	.get_ethtool_stats     = hellcreek_get_ethtool_stats,
 	.get_sset_count	       = hellcreek_get_sset_count,
 	.get_strings	       = hellcreek_get_strings,
@@ -1973,6 +1990,7 @@ static int hellcreek_remove(struct platform_device *pdev)
 }
 
 static const struct hellcreek_platform_data de1soc_r1_pdata = {
+	.name		 = "Hellcreek r4c30",
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

