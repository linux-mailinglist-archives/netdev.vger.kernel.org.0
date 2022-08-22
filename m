Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB5459C5B0
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 20:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236164AbiHVSEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 14:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236866AbiHVSE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 14:04:26 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80108.outbound.protection.outlook.com [40.107.8.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BEC402F1;
        Mon, 22 Aug 2022 11:04:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GnPkARl3Ocg+grTw6Ku+59P+bredMnHPRoGItUZBsFw9I7bTY40Piqgi+a7OYuVyhzwCNw+Iq1Y+Db2RVPgagdwnfc9bwNdQuRLSN0sGbeMh/8+NobwlYfEp58pncfNDr+sdVYkuYX6vQ2MvL1rRjD1BeukgHNGiGB/ITa8WMIcLQ23QpDSs/gabqG7KUFFOe4GK8OVGZUjJQ1D31DiQS875PVIzO0JVOS/RM/GVMX1djQypnfovCQFhKjGG4xQBOznc/KFiVpS1v9nv6xMvSN1E/c+8O2oxjhv056v9xiBw1z88tPtpiVybUX6TsdgLP2cPkYFZ2XLELTd9HkqBDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfWOUak7AcjFG8+M20NQT8Ro4cYWpnPlHkRE+bfVrXI=;
 b=IhFJef7EY3pegs818Qxuf+ws0ObsI1ploO6HxnOksdNX7MfRPcuXJ7FSbtWzhhEHXc/qo6Yh5zN9+DT/7dMkMHxRcBq43TFoKbG596fc/Err1MDb+4KyHzQFpZvUnMTVTKv24xcd6Uh6KvEDatonkEo/n+jBbFASW+BNgfaMdZrtv5e5J08NDA6Bvt2NdgTduDdLGSwzhOAJBPJtsQVE70KBI1b+O+sQH1U1TNyjZl9WORsku28JeFxzUdg/0Ap8YfcBO4mXr+rrYzlOzI/+yRo6r3hsJEqzbbFN4V7qOfzN2mAWQ+MrRTUvpLUPJR6OZyAzvMPLTJYhmAGxUPEIWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfWOUak7AcjFG8+M20NQT8Ro4cYWpnPlHkRE+bfVrXI=;
 b=dqoJwk4fkHF5fYYCs4mEXXWC9oaOjutfAb4zmoqTwwwn4ltEbq8HnGU5Tvei6EkeATv8/+ehzdl2ODJwx6mVIZ6Mfn68M+Ik/U31F7XzuGrGXPzxhQ6KARw+AAi9csA6xyaLMpLE2YI744FteMJvWrSKYfgYNLg+/fCSAUOE5RU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM (2603:10a6:150:5b::20)
 by VI1P190MB0735.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:129::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.19; Mon, 22 Aug
 2022 18:04:15 +0000
Received: from GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::14f8:4a36:e7b2:3c82]) by GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 ([fe80::14f8:4a36:e7b2:3c82%6]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 18:04:15 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [PATCH V2 net-next] net: marvell: prestera: implement br_port_locked flag offloading
Date:   Mon, 22 Aug 2022 21:03:15 +0300
Message-Id: <20220822180315.3927-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0104.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::15) To GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:150:5b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72c67f74-196f-4f67-c015-08da8468b98c
X-MS-TrafficTypeDiagnostic: VI1P190MB0735:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UTK/lW7IAXPbowD+TgsWuv9H4pgEuqAMZwXWxq5KaRUjCGT4IHhdtbEh94szA2pO1M+Ab703j2UjHzQSBx/5facOidR2yYsqVG8VVfLSsFRIKxBcdShhhEhvkX5ATxHJFC+UsR3ASO3hfAGvcPtOFhOA+RGty6N85NJleBPUyHCV41cugGojgWJLkOT//QsHS+rF0aD6l5UFp2fHMyNT7Q6njWNW4mZ5DfT2H0uneCNPwIuorWjJqeJcyQ8NVa7KaizHdoMSFSJGMnM5NYOf1OM6cximFYUPvQLVAj3VjIknn6ABgzqkK/RXExXskMf8iMDVbYniioYQIrSDtT0eaREyuNbCnkCrR9n4VQMY63qGZpJqqpxg1m953ta+GN1ilHu9FcHCWKFPaUhNzIsD1GKQR+WggYv+FZHDimWmUknKAC/bbutom21aTPOmCOpNAX5cUCZw1NOyDHzuym4CqM+dTpLxaIs6aPyprhoqiPv6toEfb+WX6UFUEn777ocCMJS5xue7FzB8Obk/gvLFeRXfCO/v5g2eZ06XcGcgP2B4mERJcRj1ke0BeC9M1B3ZNL59aJztrT4uZWt3swaXCblhSszbbpJscnzkm25omVmkly5C5dXtbuirRLgqI1q4ywTAJoX+5XiaFlPKbJxMTo76KaUS8CX1Erg6p71VA1D66bY3FBolpFNO3I77eDQUZnouBOpbtSoHS5r5j1z8kRIk5pEN7V8Qt+X6rcLxkzXz1Y5f6ahNOjd3gSuULDHaylnYo0qFR1ni4aPfBV7P3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1P190MB2019.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(34036004)(366004)(39830400003)(26005)(186003)(6506007)(6512007)(8936002)(1076003)(2616005)(44832011)(107886003)(86362001)(41300700001)(52116002)(5660300002)(41320700001)(36756003)(83380400001)(38350700002)(316002)(508600001)(66556008)(66476007)(66946007)(110136005)(4326008)(6486002)(8676002)(38100700002)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7v4hhSqe1VqgeppUF4L/qya5PzoJ6etmgNu0TqVjDBeUuYfggNpdHFaXEzsH?=
 =?us-ascii?Q?mZXa/N9s10O7MdrGZkodWdCAKqxvf+3dy4ZPwxmBnu5QM81JjcpUfby+YRml?=
 =?us-ascii?Q?sKLk6A9xvzRB1T2RDAo05PA02I+I9l8AWex83mWRLJs2IIpgpYhWWXNiyywj?=
 =?us-ascii?Q?cB9NHQDaCb5CR0CQ2q9QQVVOgcteQ7nXTTqX+u1NM9QqA9bA5jtkazwSMO86?=
 =?us-ascii?Q?0bM4XEL0n/trnldXhjOeo/S3NekEfa9iEq2s6eFX7zbU8dzAuHKG3/mp6T8F?=
 =?us-ascii?Q?qVM8OvIVlQz750Vk4t/zcD3WbY++FxCeAn6795SrYawZaZyxlXiK4fbl523O?=
 =?us-ascii?Q?BkyFCQ9OoXMH6XTEiyc6H7bqn1xQHicSIxjzE5n6xxYpyYc7Gzh7PGwO3LO/?=
 =?us-ascii?Q?+ZQKtHnXuNe6NQYduH3gd685PAk+MROGvNWf/W0U4tMnYM0og78VRYdYeMpm?=
 =?us-ascii?Q?ske/o0RusjTQmGOxyWBe687cFrl/rngP7G9aolAknZ+wLQ92Krq1c3PDQHv3?=
 =?us-ascii?Q?b7NCyWgDXFMvrBztp3y2BWsuxfmT0NJXZzHKp/NfLXTlDU42AY6ZibuaJJZE?=
 =?us-ascii?Q?XKmQj4O/wRvwO0PsgMbx1OyPtoOZoADnYsF37JvVlNfnQ9CNOGDBOMnMEvqc?=
 =?us-ascii?Q?Ua/NDtbue+ex4GZt0YpXubIv/cMtiLtBWgcG4B7yf46jLNPvXd5HLYdmJf8v?=
 =?us-ascii?Q?Kd65W9PAJcYPKJEz65SqJJs4Kl/h/prVMI32otNokc2/qe+20Aw9sVXoYTdl?=
 =?us-ascii?Q?zNqRqlmVKIBaH5/gYpzzDrIb/1jarqO52lgUXtvF4f/dBT+Vcm8QcWHV1uMA?=
 =?us-ascii?Q?Io1ECb5Ky7uumjuTnGhvWrdqSpmj4emtCBkbmLTpSAFtAMEoPF09rbaf6IgS?=
 =?us-ascii?Q?U8STrJWqOit29Vvl96LfE1MBTOEyzEAdiM15hj5psjzi2vFYdAkwlqx9deYI?=
 =?us-ascii?Q?PRPQMQCdj64tyfn52saxE1YRcPZYBMcieMMEqAoNCXy1nXu2WkrHjefSnXet?=
 =?us-ascii?Q?cr8PkG/ac5ojXRsfgh1dKaGzqRerqicgllxSlJeYC4PdZshjz5R6vrPEMZiw?=
 =?us-ascii?Q?Mv4NOmnbzlhgJx0ptwNyhirqKnPOYGiZrrMSatzcai740hmgWIEjZ4FyE2FI?=
 =?us-ascii?Q?nYovJl+45+g4RMKdG85cIY0xZ033oJdGNLyD0K6aKqkHG3NL41LA8q3qtdDu?=
 =?us-ascii?Q?reEVS+Zp8fmP6mhsQXq28hHgVXok/uQ4NA/dmoPw0PztgjUJHguah4dIs8op?=
 =?us-ascii?Q?aZZKGjx+8tVB99akJX3HUePeVo3OQrqUNXChFWLGUfCQWipWJhIlyFzhAbTi?=
 =?us-ascii?Q?JTOf9ctN7yHXiccNtwy7CAFYeBXzZ1oXXboeL+c5erB1V1BfHg4g2NKhI5pD?=
 =?us-ascii?Q?ciwxI7Ot0L3/wqsyId10sT//20x1rlFBt2zzbitQzcoRWsvNUkCiVfHjowrZ?=
 =?us-ascii?Q?Kmv1t8i+Ur6IGAfR9s49x03pVpjGkWcrw9c4gm6suav/3iLRWq/jxnoK0pHn?=
 =?us-ascii?Q?bR9OaP/j72dt4+KTC8F8AjzDpTSBDXQ4VpvCoFAUAsOdFskJ+pvKU377BwsC?=
 =?us-ascii?Q?QfCbGxLskyutDwsLn4L2FPQzC+V4JEjWZakC2pn7b3KGqCaHdAYGvp+JMV6I?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 72c67f74-196f-4f67-c015-08da8468b98c
X-MS-Exchange-CrossTenant-AuthSource: GV1P190MB2019.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2022 18:04:15.2059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XMbkAJzkGkJymdkSqFgK8F6ZfwCs4X7i2+wWo+XwacDb9+LNvSIhpMtMSz8sNolsQXDP1EcJ9xVeYzTaRWJvGnzHO6ajArLe8EbWlvMWK4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0735
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both <port> br_port_locked and <lag> interfaces's flag
offloading is supported. No new ABI is being added,
rather existing (port_param_set) API call gets extended.

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

V2:
  add missing receipents (linux-kernel, netdev)
---
 .../net/ethernet/marvell/prestera/prestera.h   |  2 ++
 .../ethernet/marvell/prestera/prestera_hw.c    | 18 ++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h    |  2 ++
 .../ethernet/marvell/prestera/prestera_main.c  |  5 +++++
 .../marvell/prestera/prestera_switchdev.c      |  8 +++++++-
 5 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera.h b/drivers/net/ethernet/marvell/prestera/prestera.h
index 2f84d0fb4094..e5a4381a88b3 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera.h
@@ -367,6 +367,8 @@ int prestera_port_learning_set(struct prestera_port *port, bool learn_enable);
 int prestera_port_uc_flood_set(struct prestera_port *port, bool flood);
 int prestera_port_mc_flood_set(struct prestera_port *port, bool flood);
 
+int prestera_port_br_locked_set(struct prestera_port *port, bool br_locked);
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid);
 
 bool prestera_netdev_check(const struct net_device *dev);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.c b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
index 962d7e0c0cb5..554115965857 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c
@@ -101,6 +101,7 @@ enum {
 	PRESTERA_CMD_PORT_ATTR_LEARNING = 7,
 	PRESTERA_CMD_PORT_ATTR_FLOOD = 8,
 	PRESTERA_CMD_PORT_ATTR_CAPABILITY = 9,
+	PRESTERA_CMD_PORT_ATTR_LOCKED = 10,
 	PRESTERA_CMD_PORT_ATTR_PHY_MODE = 12,
 	PRESTERA_CMD_PORT_ATTR_TYPE = 13,
 	PRESTERA_CMD_PORT_ATTR_STATS = 17,
@@ -285,6 +286,7 @@ union prestera_msg_port_param {
 	u8 duplex;
 	u8 fec;
 	u8 fc;
+	u8 br_locked;
 	union {
 		struct {
 			u8 admin;
@@ -1639,6 +1641,22 @@ int prestera_hw_port_mc_flood_set(const struct prestera_port *port, bool flood)
 			    &req.cmd, sizeof(req));
 }
 
+int prestera_hw_port_br_locked_set(const struct prestera_port *port,
+				   bool br_locked)
+{
+	struct prestera_msg_port_attr_req req = {
+		.attr = __cpu_to_le32(PRESTERA_CMD_PORT_ATTR_LOCKED),
+		.port = __cpu_to_le32(port->hw_id),
+		.dev = __cpu_to_le32(port->dev_id),
+		.param = {
+			.br_locked = br_locked,
+		}
+	};
+
+	return prestera_cmd(port->sw, PRESTERA_CMD_TYPE_PORT_ATTR_SET,
+			    &req.cmd, sizeof(req));
+}
+
 int prestera_hw_vlan_create(struct prestera_switch *sw, u16 vid)
 {
 	struct prestera_msg_vlan_req req = {
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_hw.h b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
index 56e043146dd2..4aca43e72a05 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_hw.h
+++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.h
@@ -183,6 +183,8 @@ int prestera_hw_port_speed_get(const struct prestera_port *port, u32 *speed);
 int prestera_hw_port_learning_set(struct prestera_port *port, bool enable);
 int prestera_hw_port_uc_flood_set(const struct prestera_port *port, bool flood);
 int prestera_hw_port_mc_flood_set(const struct prestera_port *port, bool flood);
+int prestera_hw_port_br_locked_set(const struct prestera_port *port,
+				   bool br_locked);
 int prestera_hw_port_accept_frm_type(struct prestera_port *port,
 				     enum prestera_accept_frm_type type);
 /* Vlan API */
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index ede3e53b9790..319e63ad5690 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -51,6 +51,11 @@ int prestera_port_mc_flood_set(struct prestera_port *port, bool flood)
 	return prestera_hw_port_mc_flood_set(port, flood);
 }
 
+int prestera_port_br_locked_set(struct prestera_port *port, bool br_locked)
+{
+	return prestera_hw_port_br_locked_set(port, br_locked);
+}
+
 int prestera_port_pvid_set(struct prestera_port *port, u16 vid)
 {
 	enum prestera_accept_frm_type frm_type;
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 71cde97d85c8..e548cd32582e 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -143,6 +143,7 @@ prestera_br_port_flags_reset(struct prestera_bridge_port *br_port,
 	prestera_port_uc_flood_set(port, false);
 	prestera_port_mc_flood_set(port, false);
 	prestera_port_learning_set(port, false);
+	prestera_port_br_locked_set(port, false);
 }
 
 static int prestera_br_port_flags_set(struct prestera_bridge_port *br_port,
@@ -162,6 +163,11 @@ static int prestera_br_port_flags_set(struct prestera_bridge_port *br_port,
 	if (err)
 		goto err_out;
 
+	err = prestera_port_br_locked_set(port,
+					  br_port->flags & BR_PORT_LOCKED);
+	if (err)
+		goto err_out;
+
 	return 0;
 
 err_out:
@@ -1163,7 +1169,7 @@ static int prestera_port_obj_attr_set(struct net_device *dev, const void *ctx,
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_PRE_BRIDGE_FLAGS:
 		if (attr->u.brport_flags.mask &
-		    ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD))
+		    ~(BR_LEARNING | BR_FLOOD | BR_MCAST_FLOOD | BR_PORT_LOCKED))
 			err = -EINVAL;
 		break;
 	case SWITCHDEV_ATTR_ID_PORT_BRIDGE_FLAGS:
-- 
2.17.1

