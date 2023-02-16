Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A25D698E1C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 08:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjBPHx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 02:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjBPHxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 02:53:50 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B21547414;
        Wed, 15 Feb 2023 23:53:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5wr/Q4TTfm2wX3P5tN/zyQyVrPUIEJujL3DeT1fiXqhOsAAq5rewM6CGeG64xCSBdiZyuv44R8smLy/mlf5YgrxztUr27lreUphmi8lMhRTd2y2DYvehIJgMe27GY4ZkhZZN0SKJS4usmwKAl/WM+UIYaOXv4ZGYl+PeBGn8CboJrjf3Ens7fh6c0h1OBbZhMsE03yrFRCKTIlPI2dAi6bUMMiY/WHmAJ8SCOvX+kXujbr5f6Pl1A0pd5BrJgWUclEogMb7AQSdEEjQF9/ZxDDPqVL/5rEPV1SaEW6vheyw+OgRvQ8Y+yrd/kw/iFmMdEIlUi8tdCjppzkiwrPXvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+zPz2R6STGR9Ittj76VJRsan2pXWYyyAcVCzNjCYW7U=;
 b=hIXj21IUkb+KF0El33cfU532DJdrwpWzQApKf2vAw5eQB43cSe9aGyXgd5muoGMsmNX+pChcEFtAGEdZCXCbN2JNu75sIhAMXIEZNQB9AQlpiKNQJKV33b3C/4ji0sy4amE87q0cwW7F4AOOgTaa3FkTu4bY7c9Qi4b3HRcdTshvprvx22T9LtIFizTyuJJl0EjJpfehGkTo3NgQ1eZDC9dWR3H7XQV9c23ApY8jfyI5P6FTTSoQ0cQ/2l5SB4dmA6GEMvquFBw2XBvZfSVd2DAHrhzYgPn7U5Xk+v0W1+UGrcKoM9TdG+I6B117mdcLGirPU96G8OC7YJd2gWXgnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+zPz2R6STGR9Ittj76VJRsan2pXWYyyAcVCzNjCYW7U=;
 b=u5Vgpp/PtTDdpiwg7OSexLsi3+iwwgHl2CwhixzvuhH6j3j2rfvqjqhvVfvKmQE5uLPR9cQ5GxafKPJABNjr3ue40OyJsh8vUTY0nQCpU9XGP+UhyM0UfBKjad1QV1o/KfcoXffs34c7Eb9S6QJqe5YlbRCai+YDH4QGlBU9NpU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by IA1PR10MB5993.namprd10.prod.outlook.com
 (2603:10b6:208:3ef::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Thu, 16 Feb
 2023 07:53:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::1897:6663:87ba:c8fa%4]) with mapi id 15.20.6111.010; Thu, 16 Feb 2023
 07:53:42 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-phy@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee@kernel.org>
Subject: [RFC v1 net-next 6/7] net: dsa: felix: allow external parsing of port nodes
Date:   Wed, 15 Feb 2023 23:53:20 -0800
Message-Id: <20230216075321.2898003-7-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216075321.2898003-1-colin.foster@in-advantage.com>
References: <20230216075321.2898003-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:a03:254::24) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|IA1PR10MB5993:EE_
X-MS-Office365-Filtering-Correlation-Id: e9d3e729-f43f-42f9-fd95-08db0ff2ec76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ezWBJZXEmdjV4qipJEIStbgspmznb2ZfQ/TlWrt8tdmG9GPo4AdWYr4FpFV0LmVrinhWEOl/Ep23uV4/Wh0CaPZQcE65MBD/hMbCkBloDb0P6AybNeSI2tSvHCI+DYmfapsq3XYPiXY5TzWjseIJKItQ16ZujaxkR38UaYOO3ICtHYir54yYjGq91WSl+6cPbMrTHO3eSQzH0ff+trYQ7oQPQRKJEKFhLaWEseRRgB8WoZhEwP97zbBcZe+Iu41FZN+FSaItlKAmItFnC6xJ15NvpelZ5mE8bZw5M84NHzuxjx93H6MVcslwmcA8zMTmu1w/88yexGS0GT/P95a1hnr0ZAPlaPI7jjq9qXqk7XCBFDn3QNTkg02bOEp7J55ECZCCxgptU3HdvK7YOWznYvfh50yaHCZsq+syJmUoz4//8ggHhVCzxuiGHUnExf7k+AX0N5owxWE9XWc4LOqnK5/U4gVmnOL6R/oNSb+/S6SH5AHlggY5+n9KK3yYxx9zuOy25DzQJ6ohU4ndBCYhFBMxOtMb7M2d90cTOtxxBP6aPnvjK/H/dwj4cLatwMBq+LSSliMtpP7O2ZUgWKpDMaeHtFtRw/18HxWF2q2w5zSNLJuYwDqHpCYxYGro6WozzNog4l1ANttLHtRe6lV2pmtumuyitzbWhX1uPqPQCNhEmcNZjK+4MqYxPnU9qOwwI08zQvmAEbJRAjgQKBqJvQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39830400003)(396003)(366004)(346002)(376002)(451199018)(83380400001)(5660300002)(38350700002)(41300700001)(2906002)(8936002)(38100700002)(2616005)(6506007)(26005)(6512007)(186003)(6666004)(478600001)(52116002)(6486002)(44832011)(1076003)(86362001)(316002)(66476007)(66946007)(54906003)(4326008)(8676002)(66556008)(7416002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CEYKP6sF7oUbIi9I0v4F13x3eDydIpRuXqhZctWO+JW5SGyWhEadJB+gAYMe?=
 =?us-ascii?Q?SZDzU+fO06sf51a3T65W54SP409vj/tqBol2Ol0XLzTP8AcKG/Pwm0ffDhJ3?=
 =?us-ascii?Q?oxtekRuWFytco5GNwOxVVGO+LNqw8BRR+pZwiZHj2FIKZe3lcxDxaERpKePl?=
 =?us-ascii?Q?liGIUvSzPqZv6lzYjTPfK5DuwDG1k2gcYNQDbVdhm6G5BNkyJuPMroVeRLRe?=
 =?us-ascii?Q?6yrHnrV0IkGOhhrUTqtweACTfbCk5IIDkvghS7nF2sR4cu6J7NXTXqssftkv?=
 =?us-ascii?Q?DKM3BoVdV3XtdU8LiZDhr56XVMEc2WTNpuCWZ3YJxhkA/Gd4xsOCKdZ0VFKl?=
 =?us-ascii?Q?0ClUfP0fnFtbvz2Vu0TyE+NLJqH0gatlaJoSKelzZ8ZKrknNuFO3P1lh2uPq?=
 =?us-ascii?Q?dn5JS6Ak+9ezLm+2lxD9tqVcThR9IT0rlBCPe106G5QqJ1ZMbyZAgemoufdR?=
 =?us-ascii?Q?CBFRsat98rjpRBpJcmiIZTOe97VEU3/mq65DVUuoWQAiwWDbDYsxjkr09RIZ?=
 =?us-ascii?Q?d02YkdoSGBXhkCpJ5/q7CB6WrwjiFpIdBX/2yYXfy03sO/FifDt4p0sv/2IA?=
 =?us-ascii?Q?GijEOP0sWX7J1bXygawzwZ4uIYm/8lrTvjF9CddK1JnHX8F1+JRYqx1voW7d?=
 =?us-ascii?Q?IQ6LyOa1+72cGcdQnhV7l+ZlPwncSKY5iGvMSf7c9tcizyiGq7jAEJfh+J0C?=
 =?us-ascii?Q?M5LKuX9TSn2BhWNCzG/XY7RhCCQ9GhJglBxvzFagfZx1+/+L5+smoIFqgasC?=
 =?us-ascii?Q?+oxmapmFI/nE27ZIgpgaX1rZ10kv5K+cd+YRUH65IdE6JlHL8PPVe7KwCBST?=
 =?us-ascii?Q?/JPK74hyFcpgN+sdYhaCxl22iU49uo4Obm9FSIdVlkZ9pWYUeNZShLTs7RQb?=
 =?us-ascii?Q?sZ9lhaANs1IdbmRu+PBwioO0GDYVmwFFkPyBVgwmOHuS/SE2/l5MkSyMINec?=
 =?us-ascii?Q?plCe0OFd2xh1hIBlS+51+cuoj21XTcyzxjsWeVv6N7htRFnMuke/t6OCrZiQ?=
 =?us-ascii?Q?3AagaL+OLtz/+S6Fzj6gYjfxcozQ3loDKSpukX6CMxN+6YvafZAVjgmx4ahg?=
 =?us-ascii?Q?fWUY0ypXXcm+V/7/56EaTLrZadxzs+4A3wLUHE0OPmqTcSS0j3ELHacPA1Da?=
 =?us-ascii?Q?HWLeFF5W7d8cWwkwHEBiEJKmJ9UEX0XaG+S/ksbtSCyzeOkqLp5pJNR8qL1D?=
 =?us-ascii?Q?FNtFQBX/vhpkxaqpQr0BqAwWaROcOFvSgW7QUpOsiab/PDPIkzbd43tRBmH3?=
 =?us-ascii?Q?VThmr2RaAPdQdp0VxFfdZU+aIYd2BM/aizkhgmUqjJKtaiLmZBJ7HLQNu0Xh?=
 =?us-ascii?Q?arz7DnjFIn8mnxbEKPlTLZ+whRJU2eJFQB3iIcuVsPa6ClPEDqj3gpJ3Xc4P?=
 =?us-ascii?Q?85a7HJ56z8AZMbsBMCh4aVo85Dp7KGbGAHkzJCDi664AlEKYe5JCWrd+ogx2?=
 =?us-ascii?Q?zViTRlnv5fSozRJPEdCAuoM5791VXPOk3S5yUFnKRM6MG3K02dW3IPVnDLNj?=
 =?us-ascii?Q?G8UGul0ADiOBa+DGeI71n2me4a2xdcS5Ud3+/YseMTlSstQ/Omj/kirg8fxy?=
 =?us-ascii?Q?ZP2i25aMTZhf22fz48II28dq0bEAWB9nPO5lyynQDPH6T/+Xrg55wZDjHlZI?=
 =?us-ascii?Q?JYZZeRYpmH2pwQ9xHapHCUk=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d3e729-f43f-42f9-fd95-08db0ff2ec76
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 07:53:42.9124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: osFW4LmzbsZYVzEWTyIlnu85w9T1vu7UaZw9s5AKDHNpScboBoxrL8Z5tzZwoPt8VZnhkOO86OflcWcQx8mLdXpDeioJ2W0WeM6Xol3ueok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5993
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the felix driver parses the device tree, it does so in such a way that
every node is parsed in a loop. This is done in the felix_init_structs()
function. After this is done, a separate loop will invoke
ocelot_init_port() on each port.

This causes problems if a user of the felix driver needs to retain some
information from the device tree during port initialization. A driver
might, for example, need to create call phylink_create() during
ocelot_init_port(), which requires a reference to the fwnode_handle.

Add a hook from felix into the sub-drivers, where they can optionally grab
references to the device_node when needed.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/net/dsa/ocelot/felix.c | 54 +++++++++++++++++++++++++---------
 drivers/net/dsa/ocelot/felix.h |  5 ++++
 2 files changed, 45 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 21dcb9cadc12..b6e3a88addb8 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1245,7 +1245,8 @@ static int felix_parse_ports_node(struct felix *felix,
 				  struct device_node *ports_node,
 				  phy_interface_t *port_phy_modes)
 {
-	struct device *dev = felix->ocelot.dev;
+	struct ocelot *ocelot = &felix->ocelot;
+	struct device *dev = ocelot->dev;
 	struct device_node *child;
 
 	for_each_available_child_of_node(ports_node, child) {
@@ -1285,6 +1286,19 @@ static int felix_parse_ports_node(struct felix *felix,
 		}
 
 		port_phy_modes[port] = phy_mode;
+
+		if (dsa_is_cpu_port(felix->ds, port) ||
+		    !felix->info->parse_port_node)
+			continue;
+
+		err = felix->info->parse_port_node(ocelot, child, phy_mode,
+						   port);
+		if (err < 0) {
+			dev_err(dev, "Unable to create etherdev for port %d\n",
+				port);
+			of_node_put(child);
+			return err;
+		}
 	}
 
 	return 0;
@@ -1396,8 +1410,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 
 	err = felix_parse_dt(felix, port_phy_modes);
 	if (err) {
-		kfree(port_phy_modes);
-		return err;
+		goto free_port_modes;
 	}
 
 	for (i = 0; i < TARGET_MAX; i++) {
@@ -1406,8 +1419,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 			dev_err(ocelot->dev,
 				"Failed to map device memory space: %pe\n",
 				target);
-			kfree(port_phy_modes);
-			return PTR_ERR(target);
+			err = PTR_ERR(target);
+			goto free_port_modes;
 		}
 
 		ocelot->targets[i] = target;
@@ -1416,8 +1429,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	err = ocelot_regfields_init(ocelot, felix->info->regfields);
 	if (err) {
 		dev_err(ocelot->dev, "failed to init reg fields map\n");
-		kfree(port_phy_modes);
-		return err;
+		goto free_port_modes;
 	}
 
 	for (port = 0; port < num_phys_ports; port++) {
@@ -1429,8 +1441,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		if (!ocelot_port) {
 			dev_err(ocelot->dev,
 				"failed to allocate port memory\n");
-			kfree(port_phy_modes);
-			return -ENOMEM;
+			err = -ENOMEM;
+			goto free_port_modes;
 		}
 
 		target = felix_request_port_regmap(felix, port);
@@ -1438,8 +1450,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d: %pe\n",
 				port, target);
-			kfree(port_phy_modes);
-			return PTR_ERR(target);
+			err = PTR_ERR(target);
+			goto free_port_modes;
 		}
 
 		ocelot_port->phy_mode = port_phy_modes[port];
@@ -1449,15 +1461,21 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		ocelot->ports[port] = ocelot_port;
 	}
 
-	kfree(port_phy_modes);
-
 	if (felix->info->mdio_bus_alloc) {
 		err = felix->info->mdio_bus_alloc(ocelot);
 		if (err < 0)
-			return err;
+			goto free_port_modes;
 	}
 
+	kfree(port_phy_modes);
+
 	return 0;
+
+free_port_modes:
+	if (felix->info->phylink_of_cleanup)
+		felix->info->phylink_of_cleanup(ocelot);
+	kfree(port_phy_modes);
+	return err;
 }
 
 static void ocelot_port_purge_txtstamp_skb(struct ocelot *ocelot, int port,
@@ -1574,12 +1592,18 @@ static int felix_setup(struct dsa_switch *ds)
 	dsa_switch_for_each_available_port(dp, ds) {
 		ocelot_init_port(ocelot, dp->index);
 
+		if (felix->info->phylink_create)
+			felix->info->phylink_create(ocelot, dp->index);
+
 		/* Set the default QoS Classification based on PCP and DEI
 		 * bits of vlan tag.
 		 */
 		felix_port_qos_map_init(ocelot, dp->index);
 	}
 
+	if (felix->info->phylink_of_cleanup)
+		felix->info->phylink_of_cleanup(ocelot);
+
 	err = ocelot_devlink_sb_register(ocelot);
 	if (err)
 		goto out_deinit_ports;
@@ -1604,6 +1628,8 @@ static int felix_setup(struct dsa_switch *ds)
 	ocelot_deinit(ocelot);
 
 out_mdiobus_free:
+	if (felix->info->phylink_of_cleanup)
+		felix->info->phylink_of_cleanup(ocelot);
 	if (felix->info->mdio_bus_free)
 		felix->info->mdio_bus_free(ocelot);
 
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index d5d0b30c0b75..ffb60bcf1817 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -58,6 +58,11 @@ struct felix_info {
 	void	(*tas_guard_bands_update)(struct ocelot *ocelot, int port);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	int	(*parse_port_node)(struct ocelot *ocelot,
+				   struct device_node *ports_node,
+				   phy_interface_t phy_mode, int port);
+	int	(*phylink_create)(struct ocelot *ocelot, int port);
+	void	(*phylink_of_cleanup)(struct ocelot *ocelot);
 };
 
 /* Methods for initializing the hardware resources specific to a tagging
-- 
2.25.1

