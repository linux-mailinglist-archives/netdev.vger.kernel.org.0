Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF29632473
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 14:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbiKUN4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 08:56:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbiKUN4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 08:56:35 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2057.outbound.protection.outlook.com [40.107.21.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBDA0C4950
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 05:56:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKK9XL33ze/CJZW+qO3Et7PljCWLvQsfuxwBdnln278ILaubiocUGHF5brQlZl9H/2Qkzi+GkefJfjWIllxyMriTY2mFLOStCZTwElrxB05+Kyg2n75DdOl5OyhcoAwnWqlNalYv7OtF+VA+eRha3d5KE3DzM1/5eKEm7bNPTBreXvcdvUvz7FkF3M5Ovcu+xMZDLYPMWLicA2Jr6mVT9qzLbQh+UXL4NoAVVfe3tDrjdJAaAOSI2oFZjPV48u+RpHaP5JCIAEasUxmP1XH4vUe0nypI7nuSz+t9PUI2ZUSnjFCQNFCwBL538l0tks9jQ6D1XSiHJzDchuWdqmnoEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EYbHJxhRYDDsQ+jKpmxrpLMVhh0c9sjxOtnJvTZNx4c=;
 b=TzGlcVpHnTW9uO1t+XbDDH41+mMKdEhTNJnM6LTWL5hFlzWz3A7cQCE5taeIGywbdSsvXMKiehBEqXnuOmlcopSzhnSsqwdfvcVlJIw/20BD6GjZG4tJOqGa/P7XILPLjahmt8VZQEDFJ5vShG7HrWOdHaMEexqyp0/ODDUupRheB3Z/2nj90ot8lzQy8QkVjBXLlCCW4QcPMadOPpiwCyRSziIGQXmPTq8FfBnNl3/1l4WXE8A3m5UtuUV6FKABdlTwDEZztSwOqAb8mxcIYmc0GuHBIln7rsKJp7ixEWIcsJ7Vrvq8GsHyf1sPcEAdTfMrBnXKSWE2agKGWm5zng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EYbHJxhRYDDsQ+jKpmxrpLMVhh0c9sjxOtnJvTZNx4c=;
 b=MTdUJ13d7f1rbPSWi7PqduFc6LKlnpiU3MGAsreq4EgmnU1E5wUJJ31/eUZOyon2w1IaxXy/8qYS9Fq59kIMMtqMTk+90QaBEHBD7vjdKNsMUNVlAyyj48/GKJXfL9Kzi0FA0yhtBgQPPPtUryWY5S5xGbL+uJ+qiuui2Zg/1Vw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB8134.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.11; Mon, 21 Nov
 2022 13:56:20 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 13:56:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 12/17] net: dsa: move notifier definitions to switch.h
Date:   Mon, 21 Nov 2022 15:55:50 +0200
Message-Id: <20221121135555.1227271-13-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0015.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB8134:EE_
X-MS-Office365-Filtering-Correlation-Id: 723ee4b6-92e0-440f-87d0-08dacbc82b45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 62POePX9P78pNYwmJKz6X/Wb3QsFp2NWVGfyCuFRXge4Fs0rbFAKzOTYXevaDJITgWiSy8YS8H1uVl4fhZhL6vf3/iqqkXjFURvuMrP/zEwmL2iVSGdWFtoCrRAEAfd98ZGqEjHrpZTwoHe9BME/aRezsqgbAMIRlVHuOLZatu6gmpCYudUG0S0OZ9m3Dbr25U2Oy0NMzRwCrs9DPVXai4AkI1JYvKFz5NMHpelG28Cql8fFxfabEpBcu/9+DOpbjWAI2sNJ6+ujeBGxmSBPP7k78gWmiVq+B8M6IRyvgP9EEdtkUV5IipPvIDiiY58PqVEvbB0g26/DyvbLzs/LOFXMXfzTJBwi9GUDNuw9TUWZRixLYdsp3TJhswdKBx8vT1IW8eXqKuBSUc5uTVU7CcmNgghTla5OpNEoM0N29/dojKcSbe0tVYcN3uF4cEvt+T0R3y9XOA0JcHRlvhlKGLTfZ6CShlrDQ19ZqXUizO/pKw7Q1PId8qLVgFcB2EYumFbZiCQrUZ+o3kw1+tjEJJvgPTirfw927fkWVmEdMzFD/1B9qOTRWJW1R6BuikUH1INrXPY6KO1UoQYmPP4VHWl2PWchH2hNi2z97jqP5IYBwwqq3VB1qaReUpyZs3SNnt5uTTX+E8fabAbNDULDTXFkcXC2/Vw+Vji4T5FQt1DOxdqUKaDswR656K+GaP/v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(36756003)(478600001)(5660300002)(44832011)(6512007)(66946007)(54906003)(66476007)(26005)(6916009)(4326008)(8676002)(316002)(2616005)(6506007)(52116002)(66556008)(41300700001)(1076003)(186003)(8936002)(38350700002)(38100700002)(83380400001)(2906002)(86362001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eSqT6XDQsw1lD0sA8+FZoyz9LSxGeO0PO1LDHz3H1Kgww+SpHs+4TUt/WOT6?=
 =?us-ascii?Q?UBunYFKRMef+VNzvLD02P0kc4M+Q2o5w2hfvj0cZhYe1usCdNE7yShE4rAZe?=
 =?us-ascii?Q?3e43FqFSdb1AnGQDiiZnpZpvHIdptJ3hGAGXobmgvzTTI4c5gNFSHjYu+OME?=
 =?us-ascii?Q?eM2E1+wqmhboAGuDghQhZCRPnGi2xSChcKUqrHusUPCegvOfACS+jnLoeFOJ?=
 =?us-ascii?Q?exelrgxRfrH+1mPyx/fPQ8uV62/SnV85fY4/DLpSPRiRxM7gyJaQEASBrymz?=
 =?us-ascii?Q?3B1iP/ZgpiPAgjIHvbQW1Yc3Nlmsau42Mj8ltcwBZAa8FqmP2UoQUhfy02Tc?=
 =?us-ascii?Q?KY42vNUCQqD97ytGxzqFLkY2/tajdAHt4GUMV3wIgG4y/o7KJc2I9MtaE0lY?=
 =?us-ascii?Q?ZpxnmpfqcjjlylaDGJb8OL4FproTFJ87iIDL0vibeIgf+UwRXDPEBJDvVrSM?=
 =?us-ascii?Q?uzxJaT4rlMjqYyRk2EXdGBJcSbHcWHmJAYgP3uvq98Vi0QqW/hFUD1XUion4?=
 =?us-ascii?Q?IG1GHth2VLwdckVPiEkm7Ni+p8doDu9k3kYvuw2QCZEhSQCENAhw0oboVD8z?=
 =?us-ascii?Q?++wdIu2d5+5+Mq4eR35tB6bT32CtzTFe9fKPcE4J+WaQWoKmr/sHAohemsDy?=
 =?us-ascii?Q?cq7g7vfJ2zliCS5cX6n/4NCr7VvA6cPYwOcfRyuks6NBjYM7RukPLTutZzGQ?=
 =?us-ascii?Q?vNwn8eBFVP7zC0EQ0/f8m/w6tCC1KbkdLxHGNn2InVn0JgF0UGofj3Gs/EPc?=
 =?us-ascii?Q?usCHYQIpH4x7S5wXnBbpZgovy7BHZTS9h7jXtRSvQmMTu0H3P7y9CBOj93ZR?=
 =?us-ascii?Q?TEZS6Piwp0Dasz+lWW0XoHCFXN30KZ+78XppU+krQ/SAr/sXSVU8rnVCcSGU?=
 =?us-ascii?Q?xotIE/T1+dGo+0fThd8HZJpsh78PxIkqB6cAthqmdCxUOxf2nWdoFzW2PTPW?=
 =?us-ascii?Q?SefpnPE/HRudQqDDiOSa63n4hp+joty3CbNe6vQi8Wb6AsJakdzW48SXP6xa?=
 =?us-ascii?Q?Y3yYE6QkRqi69Rp47+KdQp0RNbOaFk4Gkqsjncv8OvG57nfszoEy82SeZLHd?=
 =?us-ascii?Q?Sxje7ecHttmv9PXyWjBMtP2oe25ERFDJLQFiSCaooP7VGO/of2mJlohgXOpb?=
 =?us-ascii?Q?DNHSoq3Wz21QR40Sm8y+5r2/cdyrcrkCAoULy/v4BkofroITllDAnn3YSVkW?=
 =?us-ascii?Q?K55xeTkn/bn54lIPlOoffxwEwC+orvpYRWc1DEcGcRTPpKDWds/2o91iHw7z?=
 =?us-ascii?Q?TRLxT5Uc6U04dMUYlIyu2sUnznAM48urvPbUKg6ejgdrKrcdvRgZk5wNASbC?=
 =?us-ascii?Q?0tsYg8JoLX8Zas+rDvI0+ZT0GfNA+lN3Rk88P3LbNXPAuhZWylNaj1X2e3em?=
 =?us-ascii?Q?4OdMdw4lzRTFwQQwWB6cm6kFsGgY8i1AWoZ4TjnNEGJIAu9RDRwUhLvblkOg?=
 =?us-ascii?Q?k0QQ8XwmFFEb8eLsdkcmmQ7JhvA4wYSRTPaMRuMnBNMzob/G0qQLFa47JGjr?=
 =?us-ascii?Q?uuxewp8pcw3ATy3oPHANvrRRmWeMsEERbm4FbYv/83kuXw52VOxOj3VCZCvj?=
 =?us-ascii?Q?7CoK/DRXG0k6Bs6kzs+Ve4seZLPfus9DMdgfz8FHBE3YTQ6HKdGrzkV1ZKls?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 723ee4b6-92e0-440f-87d0-08dacbc82b45
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 13:56:20.7939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l6HFZGvQNe2aTYZud3/jesRK7r2I96hbFTM3pDH7auB/qHU+ITqfG6tjcr82YoWp9SkGCBQEMSg4xAKusv/5Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8134
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reduce bloat in dsa_priv.h by moving the cross-chip notifier data
structures to switch.h.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 104 +-----------------------------------------
 net/dsa/switch.h   | 109 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 108 insertions(+), 105 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 8cf8608344f5..e5d421cdaa8f 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -13,109 +13,7 @@
 
 #define DSA_MAX_NUM_OFFLOADING_BRIDGES		BITS_PER_LONG
 
-enum {
-	DSA_NOTIFIER_AGEING_TIME,
-	DSA_NOTIFIER_BRIDGE_JOIN,
-	DSA_NOTIFIER_BRIDGE_LEAVE,
-	DSA_NOTIFIER_FDB_ADD,
-	DSA_NOTIFIER_FDB_DEL,
-	DSA_NOTIFIER_HOST_FDB_ADD,
-	DSA_NOTIFIER_HOST_FDB_DEL,
-	DSA_NOTIFIER_LAG_FDB_ADD,
-	DSA_NOTIFIER_LAG_FDB_DEL,
-	DSA_NOTIFIER_LAG_CHANGE,
-	DSA_NOTIFIER_LAG_JOIN,
-	DSA_NOTIFIER_LAG_LEAVE,
-	DSA_NOTIFIER_MDB_ADD,
-	DSA_NOTIFIER_MDB_DEL,
-	DSA_NOTIFIER_HOST_MDB_ADD,
-	DSA_NOTIFIER_HOST_MDB_DEL,
-	DSA_NOTIFIER_VLAN_ADD,
-	DSA_NOTIFIER_VLAN_DEL,
-	DSA_NOTIFIER_HOST_VLAN_ADD,
-	DSA_NOTIFIER_HOST_VLAN_DEL,
-	DSA_NOTIFIER_MTU,
-	DSA_NOTIFIER_TAG_PROTO,
-	DSA_NOTIFIER_TAG_PROTO_CONNECT,
-	DSA_NOTIFIER_TAG_PROTO_DISCONNECT,
-	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
-	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
-	DSA_NOTIFIER_MASTER_STATE_CHANGE,
-};
-
-/* DSA_NOTIFIER_AGEING_TIME */
-struct dsa_notifier_ageing_time_info {
-	unsigned int ageing_time;
-};
-
-/* DSA_NOTIFIER_BRIDGE_* */
-struct dsa_notifier_bridge_info {
-	const struct dsa_port *dp;
-	struct dsa_bridge bridge;
-	bool tx_fwd_offload;
-	struct netlink_ext_ack *extack;
-};
-
-/* DSA_NOTIFIER_FDB_* */
-struct dsa_notifier_fdb_info {
-	const struct dsa_port *dp;
-	const unsigned char *addr;
-	u16 vid;
-	struct dsa_db db;
-};
-
-/* DSA_NOTIFIER_LAG_FDB_* */
-struct dsa_notifier_lag_fdb_info {
-	struct dsa_lag *lag;
-	const unsigned char *addr;
-	u16 vid;
-	struct dsa_db db;
-};
-
-/* DSA_NOTIFIER_MDB_* */
-struct dsa_notifier_mdb_info {
-	const struct dsa_port *dp;
-	const struct switchdev_obj_port_mdb *mdb;
-	struct dsa_db db;
-};
-
-/* DSA_NOTIFIER_LAG_* */
-struct dsa_notifier_lag_info {
-	const struct dsa_port *dp;
-	struct dsa_lag lag;
-	struct netdev_lag_upper_info *info;
-	struct netlink_ext_ack *extack;
-};
-
-/* DSA_NOTIFIER_VLAN_* */
-struct dsa_notifier_vlan_info {
-	const struct dsa_port *dp;
-	const struct switchdev_obj_port_vlan *vlan;
-	struct netlink_ext_ack *extack;
-};
-
-/* DSA_NOTIFIER_MTU */
-struct dsa_notifier_mtu_info {
-	const struct dsa_port *dp;
-	int mtu;
-};
-
-/* DSA_NOTIFIER_TAG_PROTO_* */
-struct dsa_notifier_tag_proto_info {
-	const struct dsa_device_ops *tag_ops;
-};
-
-/* DSA_NOTIFIER_TAG_8021Q_VLAN_* */
-struct dsa_notifier_tag_8021q_vlan_info {
-	const struct dsa_port *dp;
-	u16 vid;
-};
-
-/* DSA_NOTIFIER_MASTER_STATE_CHANGE */
-struct dsa_notifier_master_state_info {
-	const struct net_device *master;
-	bool operational;
-};
+struct dsa_notifier_tag_8021q_vlan_info;
 
 struct dsa_switchdev_event_work {
 	struct net_device *dev;
diff --git a/net/dsa/switch.h b/net/dsa/switch.h
index b2fd496bc56f..15e67b95eb6e 100644
--- a/net/dsa/switch.h
+++ b/net/dsa/switch.h
@@ -3,8 +3,113 @@
 #ifndef __DSA_SWITCH_H
 #define __DSA_SWITCH_H
 
-struct dsa_switch_tree;
-struct dsa_switch;
+#include <net/dsa.h>
+
+struct netlink_ext_ack;
+
+enum {
+	DSA_NOTIFIER_AGEING_TIME,
+	DSA_NOTIFIER_BRIDGE_JOIN,
+	DSA_NOTIFIER_BRIDGE_LEAVE,
+	DSA_NOTIFIER_FDB_ADD,
+	DSA_NOTIFIER_FDB_DEL,
+	DSA_NOTIFIER_HOST_FDB_ADD,
+	DSA_NOTIFIER_HOST_FDB_DEL,
+	DSA_NOTIFIER_LAG_FDB_ADD,
+	DSA_NOTIFIER_LAG_FDB_DEL,
+	DSA_NOTIFIER_LAG_CHANGE,
+	DSA_NOTIFIER_LAG_JOIN,
+	DSA_NOTIFIER_LAG_LEAVE,
+	DSA_NOTIFIER_MDB_ADD,
+	DSA_NOTIFIER_MDB_DEL,
+	DSA_NOTIFIER_HOST_MDB_ADD,
+	DSA_NOTIFIER_HOST_MDB_DEL,
+	DSA_NOTIFIER_VLAN_ADD,
+	DSA_NOTIFIER_VLAN_DEL,
+	DSA_NOTIFIER_HOST_VLAN_ADD,
+	DSA_NOTIFIER_HOST_VLAN_DEL,
+	DSA_NOTIFIER_MTU,
+	DSA_NOTIFIER_TAG_PROTO,
+	DSA_NOTIFIER_TAG_PROTO_CONNECT,
+	DSA_NOTIFIER_TAG_PROTO_DISCONNECT,
+	DSA_NOTIFIER_TAG_8021Q_VLAN_ADD,
+	DSA_NOTIFIER_TAG_8021Q_VLAN_DEL,
+	DSA_NOTIFIER_MASTER_STATE_CHANGE,
+};
+
+/* DSA_NOTIFIER_AGEING_TIME */
+struct dsa_notifier_ageing_time_info {
+	unsigned int ageing_time;
+};
+
+/* DSA_NOTIFIER_BRIDGE_* */
+struct dsa_notifier_bridge_info {
+	const struct dsa_port *dp;
+	struct dsa_bridge bridge;
+	bool tx_fwd_offload;
+	struct netlink_ext_ack *extack;
+};
+
+/* DSA_NOTIFIER_FDB_* */
+struct dsa_notifier_fdb_info {
+	const struct dsa_port *dp;
+	const unsigned char *addr;
+	u16 vid;
+	struct dsa_db db;
+};
+
+/* DSA_NOTIFIER_LAG_FDB_* */
+struct dsa_notifier_lag_fdb_info {
+	struct dsa_lag *lag;
+	const unsigned char *addr;
+	u16 vid;
+	struct dsa_db db;
+};
+
+/* DSA_NOTIFIER_MDB_* */
+struct dsa_notifier_mdb_info {
+	const struct dsa_port *dp;
+	const struct switchdev_obj_port_mdb *mdb;
+	struct dsa_db db;
+};
+
+/* DSA_NOTIFIER_LAG_* */
+struct dsa_notifier_lag_info {
+	const struct dsa_port *dp;
+	struct dsa_lag lag;
+	struct netdev_lag_upper_info *info;
+	struct netlink_ext_ack *extack;
+};
+
+/* DSA_NOTIFIER_VLAN_* */
+struct dsa_notifier_vlan_info {
+	const struct dsa_port *dp;
+	const struct switchdev_obj_port_vlan *vlan;
+	struct netlink_ext_ack *extack;
+};
+
+/* DSA_NOTIFIER_MTU */
+struct dsa_notifier_mtu_info {
+	const struct dsa_port *dp;
+	int mtu;
+};
+
+/* DSA_NOTIFIER_TAG_PROTO_* */
+struct dsa_notifier_tag_proto_info {
+	const struct dsa_device_ops *tag_ops;
+};
+
+/* DSA_NOTIFIER_TAG_8021Q_VLAN_* */
+struct dsa_notifier_tag_8021q_vlan_info {
+	const struct dsa_port *dp;
+	u16 vid;
+};
+
+/* DSA_NOTIFIER_MASTER_STATE_CHANGE */
+struct dsa_notifier_master_state_info {
+	const struct net_device *master;
+	bool operational;
+};
 
 int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
 int dsa_broadcast(unsigned long e, void *v);
-- 
2.34.1

