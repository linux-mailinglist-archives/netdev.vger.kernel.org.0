Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A075987DF
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344371AbiHRPux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344300AbiHRPuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:50:16 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50081.outbound.protection.outlook.com [40.107.5.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8146A73919
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 08:49:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dGC28fM08tUAHwP+UriratrqM9Nxg14j7iyxNFrqbnycFg2w2LD2+u/fRY9LznHiMb0YhPMyxOr0NDLMVWZNfEyvqZ7bwG/5CSDAI0QdtEj4UDuaNtprdGUE+SBzd9B2XUJZg4prUj/Ll1g0j2AFIj4rTXr9X3aVZf50ejNkjzI2lK4uXEdg8Yqdgcg49Cw3aDJOV8tNOhIi+YYYzLtt20qeyXPEMu1bZaes+YRRBSZCJaoC3/Les4Q7jefUC8QIvmCQ6sSdNaT0oYCi9OYaq615ZMJjyxNlqtLEwYtBQIsMqeT5e70GRJxq5Dt3IbSkl3x6JAfdYYgQQGtkhDUnGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+bneBZ7DYtOsUPmX/8nT9nyQZxD7bf3llLiFm9ASl0=;
 b=NFQGrDte3POXpQwKf/0DUHVBsIyahZ88hYnDuBsyx06kSVk/hFOoUowTrY4lgZPZ9ZDGCXqGne/coReSx946s92thNT9B2/JK9SSoo2oNOQ8Mcc2eYHv2i1nvBhqLr9DSyA4pxExw755YyFBYJYOQywF4zn0GhruccJTP7xrFV3dQxBL1XUADthOTEWTy3E+Mj85lg0IxvwmTmtEbNRuGj6rCJgkGXUH8FFLSRbJe6/liUijl60mdgBb8YJ0tiVGNhdMysK/yiUL+xdQtAx5Sppi5kgEyRPC3Ls3ECqlpnPJTB/W2S5JKEA0e0/cglE1HQRt9jSi+0KgS+/ux1LNBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+bneBZ7DYtOsUPmX/8nT9nyQZxD7bf3llLiFm9ASl0=;
 b=FesOrJ+jgVN7ImZthFVF8rKzKqOA+B54Kk3gS9BLXhpR2XpK20pDuEIImxh6QZGTCRUQ8XGkPMhRoJoGKeP24QLjrMldzkiFmdjpL1g+W2ACEnkRSFjyl/wb461NAXwOKxDpaCgSwxBlgG8/K17UDFdB07LrbCs5fkUN++gZ+YQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6349.eurprd04.prod.outlook.com (2603:10a6:803:126::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Thu, 18 Aug
 2022 15:49:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5525.011; Thu, 18 Aug 2022
 15:49:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [RFC PATCH net-next 10/10] net: dsa: make _del variants of functions return void
Date:   Thu, 18 Aug 2022 18:49:11 +0300
Message-Id: <20220818154911.2973417-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
References: <20220818154911.2973417-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR05CA0074.eurprd05.prod.outlook.com
 (2603:10a6:208:136::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e15b72e2-2afe-4d91-4192-08da81314338
X-MS-TrafficTypeDiagnostic: VE1PR04MB6349:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56Zw8wEycD6c0p04dvRm5IwtnftUx8eO+S+36yfLCmGTKJJc2BmYQDHtTDJ5xY/yUl1PNGTZdLU12hfSH3V8CaOgAwe8c7TQqfNaMz30OD+m+lRb7RyWMP4yq+fRl8w3aeaoVdqdD6xP9mqr5NtwmW1Y+UjVwjLIlqsk5GZ0jav/ADso9GvnAeyf1NyGwDaAaugxJymdEmabPeBrX9q+Y7+F3oaQNOjshDKg2gUf/XZkvH0+1CLN+jnJfhzcDDFdZJWj67U/aaNk57RHY9xpms7JxaBReNMuEWMaLyzjsgdL+JaYW2y4QXkQBJSDxrkQGGkZZ8l6FOcCVRX9fqPf95txlsQg/4fRPlwAoZhnTUqQfkO59JvqBEYEFWR/h/18KVA+0JLSkIpL1cyT1YlxqmSRzRNFqwr0GdARgWxTbeXSrxZ0IqgLNKXwvfTaRQ2qkMCkh0Ml5DhjXApGFnan4XMcx9vGp07p0HvrtlsvRgM4uAAjy5Z2YVqirpK7RsOmbH9KsNo/eQHKuj8Tpp/f6zq0yPxvJqR/b2mDvqPZZHqSfox5I5kXgZqrEkSLHLdnUZU6BpwPlEc2FxeG3caGIRrjSbVHjcJdwtWW3iIrfsl36iWWpaZfWGVWXrknrmpDOTXZrC51ELVn6oLO5sxuXyrbfXkI89XnBH4FL5b0bQZ9lkDYnfvbt0nr/ZzH8WPtgivdCIckeJVaZVt2qvb+ybrQr3aW6zoBOBRYIy+3QvdP/fFbhFCeqZqm/THySvVcQVEUo5eZESFvtR4k9gHguw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(52116002)(6486002)(478600001)(41300700001)(6666004)(26005)(6512007)(2906002)(66476007)(66556008)(6506007)(36756003)(86362001)(6916009)(316002)(54906003)(8676002)(66946007)(1076003)(2616005)(186003)(30864003)(5660300002)(44832011)(7416002)(8936002)(4326008)(38350700002)(38100700002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I0ey/ePSgYxy2RG/OwStAHtv/FrWiWUkCGa8FO6Uh+WkMbiZn3yHlzAfUlYs?=
 =?us-ascii?Q?q4myoXIi6fqeDXZBkpVdEXS0LaT9GbNV6mMUxAQM8PeKMbOD9LfKson2dTfq?=
 =?us-ascii?Q?rWHqWK2QPqbt548TjIzbMDODP196TsqTgg4hDqwUmrGzCwZIiYKDlCHD8O0l?=
 =?us-ascii?Q?I3CC9GYqYhcflz9c7VpjjOqScdGDNzXCtWrnSZjEFc1Ve6/Da1htmJIMcp63?=
 =?us-ascii?Q?d3do8URPo/EYmeMiAFWtkiixu0bbnrt4xalkCruBwieSiLrc/bb+Ozt8DVXZ?=
 =?us-ascii?Q?5xyvw4XBtD5L1IrJBVaB2FnevNhxxBVGYuVkt/yWiedv8le+X/2J0+S1Kyqw?=
 =?us-ascii?Q?q6F430uBOsNbykI+G5mfT/6WGfUZ3RGSlS+FRxtHe6mACOrgAdNPcwf1FsuD?=
 =?us-ascii?Q?Tw3xPXtaCNEEpDL9QU4wpDv4d/Bsp+xw3m9BgY3jBYvjFD2sdtHyBCh1OkUH?=
 =?us-ascii?Q?vun3t09i3Av0IhvKypbxZylELqZLdeInWJGfrFzVZP5jmrW9KNPZUrQoPiXY?=
 =?us-ascii?Q?Z9ZR21xBISS554V9JdEo++KIY1g7muDn9MGNNmQmBMQ2SMJDK5s0SsqlwiPW?=
 =?us-ascii?Q?lUa+FFY4G6NHPRtfceErUEwbifsixXrOpstil0O+QHPcRKyLLo9m449obr4T?=
 =?us-ascii?Q?mfDtJio276zluen8wmC+vsMnd3lKw8bJNGbnJ1ileSPBVAT9jL6LaoJ6N3m8?=
 =?us-ascii?Q?o8/ESYyT7XYQ1CgN1u6S+7wr6vLFvWiyc0+k+OwcJ46leVr1ToCDpqntKTxe?=
 =?us-ascii?Q?eWFW8cXJY5L4/EMAXlJ0/LijQv5AHtbeOcfKKLUCGrAHWV7xRsmbJWa6ESki?=
 =?us-ascii?Q?AX900IYWSnQxUnAVwK3WELKH3ZPiBt2mGxMVW+ghjKmZU3tT2of2OMZiTLT4?=
 =?us-ascii?Q?YPoTk73/jm4Sd93hHkBAiOK8JpitCr5uyKqS3wRzAJh4IX8O5RbRPa+cf2ED?=
 =?us-ascii?Q?XojcwPUTYYeJHnnmTK5Pttq7Uh33F0uPQW5nKkoiFEpMhiWC5/18mDQg+1dY?=
 =?us-ascii?Q?1E1d/9c3P4q6uA6SJj385nqceIED86wyo4OuwshZdC+BmLxHuijtDBFvPLKr?=
 =?us-ascii?Q?KydRfOdSRgyjIuLxZuEBUtkvT7QVmwj//k08k5WELBTrVViLyppXgcXt4JE0?=
 =?us-ascii?Q?dDXuOqn5u9lB8A3BOys1/XmvInwXFdb7i9rwGctomyiyaUP8tVcaDp+pCimZ?=
 =?us-ascii?Q?Owaqc9oNFkzFf50/g9l+Z+THlJ2cxh55vQ9+siZpjZRAWOGP132BUmEqHzE6?=
 =?us-ascii?Q?Ob+0MW+zhVGRUziutLlwc9/aFA2eiGosB1lyIdVVFFNDMQiDgcppuOqo/Xd+?=
 =?us-ascii?Q?K9NBgxQbVmnFumHIlMpQI9AqR0rUztMcOxloEWO3uOHFXKb6gwOuYY1UoFqt?=
 =?us-ascii?Q?9C86bSyIamypal0z3xF3Kkfc+cVqij5BSMhYaZ5uqxTZWorrGY6j6ghIFzWg?=
 =?us-ascii?Q?xlnNkdNTD3Cx0EQj017NU7jKzV4a2XPtMgs0nJhnCZ3gckD5ObLUBFa8QXt0?=
 =?us-ascii?Q?QRi/B7d7VtvmWBEXN0uLNfaPPHTfdAbsYMXmYFSRFI4ad3zlYyGJkFNA2NnF?=
 =?us-ascii?Q?EPzKiU8ob+Eo717A8PF1XfO2TTBtTT+NLhR/cwbuu9BJHcFs6CLLb0GQ2thP?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e15b72e2-2afe-4d91-4192-08da81314338
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 15:49:40.9049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qD4PY+TOcitCXW2gPbTLSuygKf+TeARLf+OABRbD7uaqalmpLWCztGCP9ywHOdLeaVF9q3Ahd5IqY9MXkQTizQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we suppress return codes from the cross-chip notifier layer
where we don't have anything sane to do, we can propagate the prototype
chain to void one layer higher, which is to the netdev notifiers and
switchdev notifiers.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  44 ++++++++++----------
 net/dsa/port.c     | 101 +++++++++++++++++----------------------------
 net/dsa/slave.c    |  74 ++++++++++++---------------------
 3 files changed, 86 insertions(+), 133 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 263a07152b07..75aa1bcc432b 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -235,33 +235,33 @@ void dsa_port_mtu_change(struct dsa_port *dp, int new_mtu);
 int dsa_port_mtu_change_robust(struct dsa_port *dp, int new_mtu, int old_mtu);
 int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 		     u16 vid);
-int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid);
+void dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid);
 int dsa_port_standalone_host_fdb_add(struct dsa_port *dp,
 				     const unsigned char *addr, u16 vid);
-int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
-				     const unsigned char *addr, u16 vid);
+void dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
+				      const unsigned char *addr, u16 vid);
 int dsa_port_bridge_host_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 				 u16 vid);
-int dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-				 u16 vid);
+void dsa_port_bridge_host_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+				  u16 vid);
 int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 			 u16 vid);
-int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			 u16 vid);
+void dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			  u16 vid);
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data);
 int dsa_port_mdb_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_mdb_del(const struct dsa_port *dp,
-		     const struct switchdev_obj_port_mdb *mdb);
+void dsa_port_mdb_del(const struct dsa_port *dp,
+		      const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_standalone_host_mdb_add(const struct dsa_port *dp,
 				     const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
-				     const struct switchdev_obj_port_mdb *mdb);
+void dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
+				      const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
 				 const struct switchdev_obj_port_mdb *mdb);
-int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
-				 const struct switchdev_obj_port_mdb *mdb);
+void dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
+				  const struct switchdev_obj_port_mdb *mdb);
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp,
 			      struct switchdev_brport_flags flags,
 			      struct netlink_ext_ack *extack);
@@ -271,21 +271,21 @@ int dsa_port_bridge_flags(struct dsa_port *dp,
 int dsa_port_vlan_add(struct dsa_port *dp,
 		      const struct switchdev_obj_port_vlan *vlan,
 		      struct netlink_ext_ack *extack);
-int dsa_port_vlan_del(struct dsa_port *dp,
-		      const struct switchdev_obj_port_vlan *vlan);
+void dsa_port_vlan_del(struct dsa_port *dp,
+		       const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_host_vlan_add(struct dsa_port *dp,
 			   const struct switchdev_obj_port_vlan *vlan,
 			   struct netlink_ext_ack *extack);
-int dsa_port_host_vlan_del(struct dsa_port *dp,
-			   const struct switchdev_obj_port_vlan *vlan);
+void dsa_port_host_vlan_del(struct dsa_port *dp,
+			    const struct switchdev_obj_port_vlan *vlan);
 int dsa_port_mrp_add(const struct dsa_port *dp,
 		     const struct switchdev_obj_mrp *mrp);
-int dsa_port_mrp_del(const struct dsa_port *dp,
-		     const struct switchdev_obj_mrp *mrp);
+void dsa_port_mrp_del(const struct dsa_port *dp,
+		      const struct switchdev_obj_mrp *mrp);
 int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
 			       const struct switchdev_obj_ring_role_mrp *mrp);
-int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
-			       const struct switchdev_obj_ring_role_mrp *mrp);
+void dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
+				const struct switchdev_obj_ring_role_mrp *mrp);
 int dsa_port_phylink_create(struct dsa_port *dp);
 int dsa_port_link_register_of(struct dsa_port *dp);
 void dsa_port_link_unregister_of(struct dsa_port *dp);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 1452f818263a..8ad9261a074e 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1003,8 +1003,8 @@ int dsa_port_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 				      DSA_NOTIFIER_FDB_DEL, &info);
 }
 
-int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-		     u16 vid)
+void dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+		      u16 vid)
 {
 	struct dsa_notifier_fdb_info info = {
 		.dp = dp,
@@ -1020,8 +1020,6 @@ int dsa_port_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		info.db.bridge.num = 0;
 
 	dsa_port_notify(dp, DSA_NOTIFIER_FDB_DEL, &info);
-
-	return 0;
 }
 
 static int dsa_port_host_fdb_add(struct dsa_port *dp,
@@ -1076,9 +1074,9 @@ int dsa_port_bridge_host_fdb_add(struct dsa_port *dp,
 	return dsa_port_host_fdb_add(dp, addr, vid, db);
 }
 
-static int dsa_port_host_fdb_del(struct dsa_port *dp,
-				 const unsigned char *addr, u16 vid,
-				 struct dsa_db db)
+static void dsa_port_host_fdb_del(struct dsa_port *dp,
+				  const unsigned char *addr, u16 vid,
+				  struct dsa_db db)
 {
 	struct dsa_notifier_fdb_info info = {
 		.dp = dp,
@@ -1091,38 +1089,32 @@ static int dsa_port_host_fdb_del(struct dsa_port *dp,
 		info.db.bridge.num = 0;
 
 	dsa_port_notify(dp, DSA_NOTIFIER_HOST_FDB_DEL, &info);
-
-	return 0;
 }
 
-int dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
-				     const unsigned char *addr, u16 vid)
+void dsa_port_standalone_host_fdb_del(struct dsa_port *dp,
+				      const unsigned char *addr, u16 vid)
 {
 	struct dsa_db db = {
 		.type = DSA_DB_PORT,
 		.dp = dp,
 	};
 
-	return dsa_port_host_fdb_del(dp, addr, vid, db);
+	dsa_port_host_fdb_del(dp, addr, vid, db);
 }
 
-int dsa_port_bridge_host_fdb_del(struct dsa_port *dp,
-				 const unsigned char *addr, u16 vid)
+void dsa_port_bridge_host_fdb_del(struct dsa_port *dp,
+				  const unsigned char *addr, u16 vid)
 {
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	struct dsa_db db = {
 		.type = DSA_DB_BRIDGE,
 		.bridge = *dp->bridge,
 	};
-	int err;
 
-	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT) {
-		err = dev_uc_del(cpu_dp->master, addr);
-		if (err)
-			return err;
-	}
+	if (cpu_dp->master->priv_flags & IFF_UNICAST_FLT)
+		dev_uc_del(cpu_dp->master, addr);
 
-	return dsa_port_host_fdb_del(dp, addr, vid, db);
+	dsa_port_host_fdb_del(dp, addr, vid, db);
 }
 
 int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
@@ -1145,8 +1137,8 @@ int dsa_port_lag_fdb_add(struct dsa_port *dp, const unsigned char *addr,
 				      DSA_NOTIFIER_LAG_FDB_DEL, &info);
 }
 
-int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
-			 u16 vid)
+void dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
+			  u16 vid)
 {
 	struct dsa_notifier_lag_fdb_info info = {
 		.lag = dp->lag,
@@ -1162,8 +1154,6 @@ int dsa_port_lag_fdb_del(struct dsa_port *dp, const unsigned char *addr,
 		info.db.bridge.num = 0;
 
 	dsa_port_notify(dp, DSA_NOTIFIER_LAG_FDB_DEL, &info);
-
-	return 0;
 }
 
 int dsa_port_fdb_dump(struct dsa_port *dp, dsa_fdb_dump_cb_t *cb, void *data)
@@ -1196,8 +1186,8 @@ int dsa_port_mdb_add(const struct dsa_port *dp,
 				      DSA_NOTIFIER_MDB_DEL, &info);
 }
 
-int dsa_port_mdb_del(const struct dsa_port *dp,
-		     const struct switchdev_obj_port_mdb *mdb)
+void dsa_port_mdb_del(const struct dsa_port *dp,
+		      const struct switchdev_obj_port_mdb *mdb)
 {
 	struct dsa_notifier_mdb_info info = {
 		.dp = dp,
@@ -1212,8 +1202,6 @@ int dsa_port_mdb_del(const struct dsa_port *dp,
 		info.db.bridge.num = 0;
 
 	dsa_port_notify(dp, DSA_NOTIFIER_MDB_DEL, &info);
-
-	return 0;
 }
 
 static int dsa_port_host_mdb_add(const struct dsa_port *dp,
@@ -1261,9 +1249,9 @@ int dsa_port_bridge_host_mdb_add(const struct dsa_port *dp,
 	return dsa_port_host_mdb_add(dp, mdb, db);
 }
 
-static int dsa_port_host_mdb_del(const struct dsa_port *dp,
-				 const struct switchdev_obj_port_mdb *mdb,
-				 struct dsa_db db)
+static void dsa_port_host_mdb_del(const struct dsa_port *dp,
+				  const struct switchdev_obj_port_mdb *mdb,
+				  struct dsa_db db)
 {
 	struct dsa_notifier_mdb_info info = {
 		.dp = dp,
@@ -1275,36 +1263,31 @@ static int dsa_port_host_mdb_del(const struct dsa_port *dp,
 		info.db.bridge.num = 0;
 
 	dsa_port_notify(dp, DSA_NOTIFIER_HOST_MDB_DEL, &info);
-
-	return 0;
 }
 
-int dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
-				     const struct switchdev_obj_port_mdb *mdb)
+void dsa_port_standalone_host_mdb_del(const struct dsa_port *dp,
+				      const struct switchdev_obj_port_mdb *mdb)
 {
 	struct dsa_db db = {
 		.type = DSA_DB_PORT,
 		.dp = dp,
 	};
 
-	return dsa_port_host_mdb_del(dp, mdb, db);
+	dsa_port_host_mdb_del(dp, mdb, db);
 }
 
-int dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
-				 const struct switchdev_obj_port_mdb *mdb)
+void dsa_port_bridge_host_mdb_del(const struct dsa_port *dp,
+				  const struct switchdev_obj_port_mdb *mdb)
 {
 	struct dsa_port *cpu_dp = dp->cpu_dp;
 	struct dsa_db db = {
 		.type = DSA_DB_BRIDGE,
 		.bridge = *dp->bridge,
 	};
-	int err;
 
-	err = dev_mc_del(cpu_dp->master, mdb->addr);
-	if (err)
-		return err;
+	dev_mc_del(cpu_dp->master, mdb->addr);
 
-	return dsa_port_host_mdb_del(dp, mdb, db);
+	dsa_port_host_mdb_del(dp, mdb, db);
 }
 
 int dsa_port_vlan_add(struct dsa_port *dp,
@@ -1321,8 +1304,8 @@ int dsa_port_vlan_add(struct dsa_port *dp,
 				      DSA_NOTIFIER_VLAN_DEL, &info);
 }
 
-int dsa_port_vlan_del(struct dsa_port *dp,
-		      const struct switchdev_obj_port_vlan *vlan)
+void dsa_port_vlan_del(struct dsa_port *dp,
+		       const struct switchdev_obj_port_vlan *vlan)
 {
 	struct dsa_notifier_vlan_info info = {
 		.dp = dp,
@@ -1330,8 +1313,6 @@ int dsa_port_vlan_del(struct dsa_port *dp,
 	};
 
 	dsa_port_notify(dp, DSA_NOTIFIER_VLAN_DEL, &info);
-
-	return 0;
 }
 
 int dsa_port_host_vlan_add(struct dsa_port *dp,
@@ -1356,8 +1337,8 @@ int dsa_port_host_vlan_add(struct dsa_port *dp,
 	return err;
 }
 
-int dsa_port_host_vlan_del(struct dsa_port *dp,
-			   const struct switchdev_obj_port_vlan *vlan)
+void dsa_port_host_vlan_del(struct dsa_port *dp,
+			    const struct switchdev_obj_port_vlan *vlan)
 {
 	struct dsa_notifier_vlan_info info = {
 		.dp = dp,
@@ -1368,8 +1349,6 @@ int dsa_port_host_vlan_del(struct dsa_port *dp,
 	dsa_port_notify(dp, DSA_NOTIFIER_HOST_VLAN_DEL, &info);
 
 	vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), vlan->vid);
-
-	return 0;
 }
 
 int dsa_port_mrp_add(const struct dsa_port *dp,
@@ -1383,15 +1362,13 @@ int dsa_port_mrp_add(const struct dsa_port *dp,
 	return ds->ops->port_mrp_add(ds, dp->index, mrp);
 }
 
-int dsa_port_mrp_del(const struct dsa_port *dp,
-		     const struct switchdev_obj_mrp *mrp)
+void dsa_port_mrp_del(const struct dsa_port *dp,
+		      const struct switchdev_obj_mrp *mrp)
 {
 	struct dsa_switch *ds = dp->ds;
 
-	if (!ds->ops->port_mrp_del)
-		return -EOPNOTSUPP;
-
-	return ds->ops->port_mrp_del(ds, dp->index, mrp);
+	if (ds->ops->port_mrp_del)
+		ds->ops->port_mrp_del(ds, dp->index, mrp);
 }
 
 int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
@@ -1405,15 +1382,13 @@ int dsa_port_mrp_add_ring_role(const struct dsa_port *dp,
 	return ds->ops->port_mrp_add_ring_role(ds, dp->index, mrp);
 }
 
-int dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
-			       const struct switchdev_obj_ring_role_mrp *mrp)
+void dsa_port_mrp_del_ring_role(const struct dsa_port *dp,
+				const struct switchdev_obj_ring_role_mrp *mrp)
 {
 	struct dsa_switch *ds = dp->ds;
 
 	if (!ds->ops->port_mrp_del_ring_role)
-		return -EOPNOTSUPP;
-
-	return ds->ops->port_mrp_del_ring_role(ds, dp->index, mrp);
+		ds->ops->port_mrp_del_ring_role(ds, dp->index, mrp);
 }
 
 void dsa_port_set_tag_protocol(struct dsa_port *cpu_dp,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 02cc1774888a..776c58a1795b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -48,14 +48,9 @@ static void dsa_slave_standalone_event_work(struct work_struct *work)
 		break;
 
 	case DSA_UC_DEL:
-		err = dsa_port_standalone_host_fdb_del(dp, addr, vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to delete %pM vid %d from fdb: %d\n",
-				dp->index, addr, vid, err);
-		}
-
+		dsa_port_standalone_host_fdb_del(dp, addr, vid);
 		break;
+
 	case DSA_MC_ADD:
 		ether_addr_copy(mdb.addr, addr);
 		mdb.vid = vid;
@@ -72,13 +67,7 @@ static void dsa_slave_standalone_event_work(struct work_struct *work)
 		ether_addr_copy(mdb.addr, addr);
 		mdb.vid = vid;
 
-		err = dsa_port_standalone_host_mdb_del(dp, &mdb);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to delete %pM vid %d from mdb: %d\n",
-				dp->index, addr, vid, err);
-		}
-
+		dsa_port_standalone_host_mdb_del(dp, &mdb);
 		break;
 	}
 
@@ -636,43 +625,42 @@ static int dsa_slave_port_obj_add(struct net_device *dev, const void *ctx,
 	return err;
 }
 
-static int dsa_slave_vlan_del(struct net_device *dev,
-			      const struct switchdev_obj *obj)
+static void dsa_slave_vlan_del(struct net_device *dev,
+			       const struct switchdev_obj *obj)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan *vlan;
 
 	if (dsa_port_skip_vlan_configuration(dp))
-		return 0;
+		return;
 
 	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
-	return dsa_port_vlan_del(dp, vlan);
+	dsa_port_vlan_del(dp, vlan);
 }
 
-static int dsa_slave_host_vlan_del(struct net_device *dev,
-				   const struct switchdev_obj *obj)
+static void dsa_slave_host_vlan_del(struct net_device *dev,
+				    const struct switchdev_obj *obj)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	struct switchdev_obj_port_vlan *vlan;
 
 	/* Do nothing if this is a software bridge */
 	if (!dp->bridge)
-		return -EOPNOTSUPP;
+		return;
 
 	if (dsa_port_skip_vlan_configuration(dp))
-		return 0;
+		return;
 
 	vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
 
-	return dsa_port_host_vlan_del(dp, vlan);
+	dsa_port_host_vlan_del(dp, vlan);
 }
 
 static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 				  const struct switchdev_obj *obj)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	int err;
 
 	if (ctx && ctx != dp)
 		return 0;
@@ -682,39 +670,37 @@ static int dsa_slave_port_obj_del(struct net_device *dev, const void *ctx,
 		if (!dsa_port_offloads_bridge_port(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
-		err = dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
+		dsa_port_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_HOST_MDB:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
-		err = dsa_port_bridge_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
+		dsa_port_bridge_host_mdb_del(dp, SWITCHDEV_OBJ_PORT_MDB(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_PORT_VLAN:
 		if (dsa_port_offloads_bridge_port(dp, obj->orig_dev))
-			err = dsa_slave_vlan_del(dev, obj);
+			dsa_slave_vlan_del(dev, obj);
 		else
-			err = dsa_slave_host_vlan_del(dev, obj);
+			dsa_slave_host_vlan_del(dev, obj);
 		break;
 	case SWITCHDEV_OBJ_ID_MRP:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
-		err = dsa_port_mrp_del(dp, SWITCHDEV_OBJ_MRP(obj));
+		dsa_port_mrp_del(dp, SWITCHDEV_OBJ_MRP(obj));
 		break;
 	case SWITCHDEV_OBJ_ID_RING_ROLE_MRP:
 		if (!dsa_port_offloads_bridge_dev(dp, obj->orig_dev))
 			return -EOPNOTSUPP;
 
-		err = dsa_port_mrp_del_ring_role(dp,
-						 SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
+		dsa_port_mrp_del_ring_role(dp, SWITCHDEV_OBJ_RING_ROLE_MRP(obj));
 		break;
 	default:
-		err = -EOPNOTSUPP;
-		break;
+		return -EOPNOTSUPP;
 	}
 
-	return err;
+	return 0;
 }
 
 static inline netdev_tx_t dsa_slave_netpoll_send_skb(struct net_device *dev,
@@ -1611,13 +1597,11 @@ static int dsa_slave_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 		/* This API only allows programming tagged, non-PVID VIDs */
 		.flags = 0,
 	};
-	int err;
 
-	err = dsa_port_vlan_del(dp, &vlan);
-	if (err)
-		return err;
+	dsa_port_vlan_del(dp, &vlan);
+	dsa_port_host_vlan_del(dp, &vlan);
 
-	return dsa_port_host_vlan_del(dp, &vlan);
+	return 0;
 }
 
 static int dsa_slave_restore_vlan(struct net_device *vdev, int vid, void *arg)
@@ -2837,17 +2821,11 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		if (switchdev_work->host_addr)
-			err = dsa_port_bridge_host_fdb_del(dp, addr, vid);
+			dsa_port_bridge_host_fdb_del(dp, addr, vid);
 		else if (dp->lag)
-			err = dsa_port_lag_fdb_del(dp, addr, vid);
+			dsa_port_lag_fdb_del(dp, addr, vid);
 		else
-			err = dsa_port_fdb_del(dp, addr, vid);
-		if (err) {
-			dev_err(ds->dev,
-				"port %d failed to delete %pM vid %d from fdb: %d\n",
-				dp->index, addr, vid, err);
-		}
-
+			dsa_port_fdb_del(dp, addr, vid);
 		break;
 	}
 
-- 
2.34.1

