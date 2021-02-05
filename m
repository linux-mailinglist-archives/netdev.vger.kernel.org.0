Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09233115C7
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 23:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBEWlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 17:41:45 -0500
Received: from mail-eopbgr50040.outbound.protection.outlook.com ([40.107.5.40]:14756
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229756AbhBENH6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 08:07:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJivCSoDgg9MwWy2MaoocjIUzfuHtgbQdsOWIUa1NXLi+piVMezHkipLJYLC6MFTKndg2WfQvJ8JjMQy0aj6yRKTky9QfFmghEXtTooGHnKNmQpUv/bbgosno0XYEktEOX6qR8aEMN5+oqV09tFnslA+6yFVatx7vFu6Qqhl2bYpr26nx9CUjiU4qDwxF/VCO869C37lmKMboDNju6vdKjxRVaclEXC7G/s9OPuWm5HnzRXeoDUBflRj12JwAgTqmMlB+WdT3YG3YY4PRpm94RADoE61bGxXIZ9Lr8lzeFA6O27opdbiNbfhQ3ruR8s3p4Cqvv8JKXGOA2Yz6eAQSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNbqQ0SyjV1HMiL7P/ktuVpv7oBHJaR8LoGaRVhhS6I=;
 b=F6JYWdI8iGKRUru6kZEqU738wQSRdLExkkdPxt8Md4pnc+nb9fuswnxethrrUtLQKZOmxloYkyJhDFfSlHbOX5Gmp/FziCewIcdEe5EJwJbM0pMX42pohGkJokKl97Cx/VSoZCW0OglSCkLKZppVIZxmT8zkNAgS5HwSR7hDzeJAQUZEkAfQuSYkI8U+ucPkZglrztPethkZceHF6D4ekwCn/LKkvkIqi967KjQax9t3r0ULegb/cOzCLx4fjUtVwj/v0uRuNqjleS5dBJYlpFnilaKYPsCNymGsOzvuZaylGSPXP3u+Y9rBIOdsV/VRD1jga93s/vI8OYgrtPnivw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNbqQ0SyjV1HMiL7P/ktuVpv7oBHJaR8LoGaRVhhS6I=;
 b=ZuMz6G9FaUqh1+47sWG+vDRzLLh3Htehu8jQIYbIj8omUx8cl7dtoYeHOPomJXBMIweIN+yCVjIKHupUkHWkgLGjmxP7VimKhW8Hyou9v8MIJArBr0ck9OCL1M+jdZ6S2kxZQUFTt84St2ABXlR2okqP/olwx2MX4jxUnWjnlog=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 13:03:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3df3:2eba:51bb:58d7%7]) with mapi id 15.20.3825.020; Fri, 5 Feb 2021
 13:03:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v3 net-next 12/12] net: dsa: felix: propagate the LAG offload ops towards the ocelot lib
Date:   Fri,  5 Feb 2021 15:02:40 +0200
Message-Id: <20210205130240.4072854-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
References: <20210205130240.4072854-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.227.87]
X-ClientProxiedBy: VI1PR0502CA0004.eurprd05.prod.outlook.com
 (2603:10a6:803:1::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.227.87) by VI1PR0502CA0004.eurprd05.prod.outlook.com (2603:10a6:803:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 13:03:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f99ba21-a240-43f9-a9a0-08d8c9d66189
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28630221C9100C7D83ABDE85E0B29@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: maONwAOqY2g1kdGZ0XsyS9HjglZ8JiVoSDBS19qVbD3FBl71W5eJ/bWf6sbiXXGZGrDxRil6fGEF+MecCW3JK3bchSVG5H945/3Ycxj/hsnAx2xckR4EXbegAZKlR1p8+pNzsgZ9EYd+xEdvm7OzSVSF9FmDZ3lu5Z/Mx4kPDKg5EPBZIO65ySs7OLRHyCxeQHnNC6BAO7LTQ/5xsm4mgF85Do4Kn/xd639PifeShULd4E4l1CWNHOLKstIRMOb4tdjPYOI3d7v6G7cL2LG8sCi50993lwmDYgFNNMnHhw2PXDltQpKkqbeOrBpDAOJ9JD2OlvITN3S1364yL1nTjjALW4+QUPVPla8kJNvwm1L4/D1ZaxIwrMgqZd2Y3eBj+tOT34sLCLI3gYYP9CtEWHAkwgL6BDdCmBh0xsJfFziw0P5aDOv3pdFmQN77gZAF1vHhJaOEqnOkkDK7Z2kenFi42jWk55T/0WhEaBbUv6j6o2HJPlttSdZP6YMA2s+AJPEZQlYFw/YYAnGY5cpCGWaYk5KQJRbUu2frfIUryi8/EN/q8/LUiJtiqzUsNK0MG5ne7/8i6HvRu0bOgpC/nA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(346002)(39850400004)(376002)(66946007)(316002)(26005)(86362001)(6486002)(83380400001)(186003)(16526019)(6506007)(69590400011)(2906002)(5660300002)(44832011)(478600001)(8936002)(6512007)(4326008)(52116002)(54906003)(2616005)(110136005)(956004)(6666004)(8676002)(66476007)(1076003)(66556008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dYKKsCLTTart7WlvoDIW1p8GQ0WsBzi3SxVNZi66baCN9L/CEk0DiU15agui?=
 =?us-ascii?Q?61bpYRIuKkb+DdUS486IBNJe4irmtYILHsQzqxmxUF4xSllFR18kVDzD+8jq?=
 =?us-ascii?Q?7lc0HOPB9F/MXl0coa7rVJ3Hw4qjWIMJ5MNtqeyLteqlQ5BG6GHRssGWEl35?=
 =?us-ascii?Q?nRd8C7IVxoG4NExJjbyvN8uCI3zfgNIa8xwAMAlQW7AaImYRMOsLFGc9wKHQ?=
 =?us-ascii?Q?oMiIb7o10NUhF+Oq0+ica5ACA6lu8sC6icVV1R+PzU2WdkvBo+0cKMtkP5Rw?=
 =?us-ascii?Q?ZRMiBCcWMS0IMUW30eda3RmBWkbrci9iuS0whuEAd2rJDxEJbgeJsOafFX0M?=
 =?us-ascii?Q?TQcDiYw6bXhFhPia+A0jrewaVROzFHaUeEmua4Zs9iHo8pEEEkpyl42iJ+n7?=
 =?us-ascii?Q?eNMLlTLI/ViCzOuJb8iTXp8YoI22jn9zqeuIrWBnToGBn29Fg8EpWC+ovjPx?=
 =?us-ascii?Q?wGcEyiJhnMyf700/PbB+XDG4fkf1hm977yDibIlOSuiDFfqG6N1d99npgrVq?=
 =?us-ascii?Q?ZCwsqZjx2T3pVZOeSWmiA16HIdtBVkrLQSdwrfYzqc0wrV7mvz5/wx2lGMB8?=
 =?us-ascii?Q?yf3pNzGFi0fuBschSu+NX7nfbl2oQQNTLL4T17ZvxE1ZA5aDC5vL2eQV6RGM?=
 =?us-ascii?Q?F19A3uxj2j38RbicFaTA+vYF8F46jnMehnuJF+D4hwhhHXIO/0h7iK2xHPb1?=
 =?us-ascii?Q?w4u/Z+aC0eHcburASZpAlWmFakk+y6IaFezymrhtBmXLVOMwTLZLj2Y+JBXP?=
 =?us-ascii?Q?bqZTu3Ju/08x3vRyfYoW3yLcN91GC26Sm4jdy6RZvHYFbvka5DsySZt2jCk6?=
 =?us-ascii?Q?MSO5Dq+ibdxnOVjNmNcBfltrMAx8H/tS2SjgE2jBp+x8cGn+U+6+xx9LCrrg?=
 =?us-ascii?Q?W/69zE+xtFNQWt3BREH9IbokrxFTF+aDj9zVSJnGWr5xCENBru1LW89tD5zW?=
 =?us-ascii?Q?1hxzNGpJpMrvbRmJKxny0Y6lEFJ7ix/LV4COGPqtmZ3L/04Sa2rXBVqkUWXc?=
 =?us-ascii?Q?cjQ9K7pGqOgBfCUUp2N1KwS8+ww3TNp9Q1kO5YtBKLejrw18lmplKzZ0gWcR?=
 =?us-ascii?Q?Pn0EqH4aSISwl2v+RN0FJEBR2zmWN43O6JBti6staM3UpF8yRfsD9bREmDL6?=
 =?us-ascii?Q?2PUewWaEPShRihBWckuIWGseyNaYTI6oymn39GDMhyEUjn3g2hWf++CkKBNw?=
 =?us-ascii?Q?lmrBA3FyvLBP37oMNxfkJxwYBntIeokJpybmZ1AVSQd5P4eTXdQv+fG0SZHE?=
 =?us-ascii?Q?f54tlB/TrcKBTVBjpwmi897QK/iX/lmgdsj7FSWt7XyqP1nJBXlm7akjpjgy?=
 =?us-ascii?Q?5gL7ewGptuVu1PwAnW3jK6oM?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f99ba21-a240-43f9-a9a0-08d8c9d66189
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 13:03:07.1640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xo4j+7nNDYwItOhf3KffOQioB3y1SUTSu6bw6nOMGPXNLqD5j3W7WM0ubVI0Nskjj29YNHrkGCoGn/dJ3lBE2Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot switch has been supporting LAG offload since its initial
commit, however felix could not make use of that, due to lack of a LAG
abstraction in DSA. Now that we have that, let's forward DSA's calls
towards the ocelot library, who will deal with setting up the bonding.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
lag_leave and lag_change now return void.

Changes in v2:
s/lag_dev/bond/g

 drivers/net/dsa/ocelot/felix.c     | 32 ++++++++++++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.h |  6 ------
 include/soc/mscc/ocelot.h          |  6 ++++++
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index c3200dfcb83b..a9840e80bd1f 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -569,6 +569,35 @@ static void felix_bridge_leave(struct dsa_switch *ds, int port,
 	ocelot_port_bridge_leave(ocelot, port, br);
 }
 
+static int felix_lag_join(struct dsa_switch *ds, int port,
+			  struct net_device *bond,
+			  struct netdev_lag_upper_info *info)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	return ocelot_port_lag_join(ocelot, port, bond, info);
+}
+
+static int felix_lag_leave(struct dsa_switch *ds, int port,
+			   struct net_device *bond)
+{
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_lag_leave(ocelot, port, bond);
+
+	return 0;
+}
+
+static int felix_lag_change(struct dsa_switch *ds, int port)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+	struct ocelot *ocelot = ds->priv;
+
+	ocelot_port_lag_change(ocelot, port, dp->lag_tx_enabled);
+
+	return 0;
+}
+
 static int felix_vlan_prepare(struct dsa_switch *ds, int port,
 			      const struct switchdev_obj_port_vlan *vlan)
 {
@@ -1341,6 +1370,9 @@ const struct dsa_switch_ops felix_switch_ops = {
 	.port_mdb_del			= felix_mdb_del,
 	.port_bridge_join		= felix_bridge_join,
 	.port_bridge_leave		= felix_bridge_leave,
+	.port_lag_join			= felix_lag_join,
+	.port_lag_leave			= felix_lag_leave,
+	.port_lag_change		= felix_lag_change,
 	.port_stp_state_set		= felix_bridge_stp_state_set,
 	.port_vlan_filtering		= felix_vlan_filtering,
 	.port_vlan_add			= felix_vlan_add,
diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index b18f6644726a..c485795c606b 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -109,12 +109,6 @@ int ocelot_mact_learn(struct ocelot *ocelot, int port,
 		      unsigned int vid, enum macaccess_entry_type type);
 int ocelot_mact_forget(struct ocelot *ocelot,
 		       const unsigned char mac[ETH_ALEN], unsigned int vid);
-int ocelot_port_lag_join(struct ocelot *ocelot, int port,
-			 struct net_device *bond,
-			 struct netdev_lag_upper_info *info);
-void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
-			   struct net_device *bond);
-void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
 struct net_device *ocelot_port_to_netdev(struct ocelot *ocelot, int port);
 int ocelot_netdev_to_port(struct net_device *dev);
 
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 6e806872cd24..d0d48e9620fb 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -798,6 +798,12 @@ int ocelot_port_mdb_add(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
 int ocelot_port_mdb_del(struct ocelot *ocelot, int port,
 			const struct switchdev_obj_port_mdb *mdb);
+int ocelot_port_lag_join(struct ocelot *ocelot, int port,
+			 struct net_device *bond,
+			 struct netdev_lag_upper_info *info);
+void ocelot_port_lag_leave(struct ocelot *ocelot, int port,
+			   struct net_device *bond);
+void ocelot_port_lag_change(struct ocelot *ocelot, int port, bool lag_tx_active);
 
 int ocelot_devlink_sb_register(struct ocelot *ocelot);
 void ocelot_devlink_sb_unregister(struct ocelot *ocelot);
-- 
2.25.1

