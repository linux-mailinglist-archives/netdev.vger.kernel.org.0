Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C5C435200
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230527AbhJTRwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:52:42 -0400
Received: from mail-eopbgr30084.outbound.protection.outlook.com ([40.107.3.84]:28293
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231134AbhJTRwk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 13:52:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/ypU8uoF2SYC+wIYB4VOKcAjTZu+Kl+bPT/pndlAfoNikdR/MfhIM9OIzmKR2uuiwz50RxBex4BQInitXvyB50Z1+SQNRM45gSx4W3R2HXKVJLaNGJSNsip3ob+vBW3kgHL2dZItkSb64NMkdVyBkU0ZBUsNc9LEJQecQtVJkcjic90zuSzdwiYCaaw4sbQ2Et3DftfPyOKiOjhJZncAvDXo+JNB4LDdtJVBxPrE4Hha2KB2/zrF6nkPdtZ2wWt3SATatwwG67+w8vTuMX4Hjo8sT7OWuQMk39agXL2yWkm7AXmNmYp7eo3pxc6/w/nnNgbqLxGshlC4e9S154rLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8T+yq7Un08h0MMx1gbh5oZh96ocl307ar9HJWjMXDo=;
 b=jzJlea++gUWR8f97jn5lkBwG5yOAdPuH7WrU0g9it1C4sX6m5Q2L21jVjKJp9Pe6qi77vQicFlhRRKYlxz2E0KrW6A4e7VrN9y8dHjCubXND6H/qvWUWXPtRPvMTfAbzxcFhXXzYZS1HuJtBUtmiEWaDrnryDXUQOssGbyQBNjAF+9FdhatGnuClsmLfFmYGIFy0iztUWnNjh5IyvaOpmqPyBHSl1Xxtnd9FjXRLLYmxqwGSydUBodJmkvb3WV/IicZJw/xauCWs75ilMddIDk/c4G2Gftv74Tha94jZUdWxB3VpZd7JHLBkmkAA/89gK5iVpJsf9NoocFVUcXZT/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s8T+yq7Un08h0MMx1gbh5oZh96ocl307ar9HJWjMXDo=;
 b=hxz5jXXK8YpvkTubK6B2FnwlV7O73YB8uhQyNCh9kjLxh8Sxv6nh3Q2KcLci3PWvXasXnKLPUxZX23ySI4hYbMWvD3CHWKtIR7iSvbb45b1O4Tjw+GA+JaVsFHgElrIkhIhj6xZuL/TUwIY/6BQFpgJyE+2XLu10CeYgWgeKr5k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.22; Wed, 20 Oct
 2021 17:50:19 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Wed, 20 Oct 2021
 17:50:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH RESEND v3 net-next 7/7] net: dsa: tag_8021q: make dsa_8021q_{rx,tx}_vid take dp as argument
Date:   Wed, 20 Oct 2021 20:49:55 +0300
Message-Id: <20211020174955.1102089-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
References: <20211020174955.1102089-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0034.eurprd03.prod.outlook.com
 (2603:10a6:208:14::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR03CA0034.eurprd03.prod.outlook.com (2603:10a6:208:14::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 17:50:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30cd18c9-ae14-47a2-b759-08d993f214be
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-Microsoft-Antispam-PRVS: <VI1PR04MB55017B73DCEAFD4D9F694181E0BE9@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XNWIXBx8BGWcjTjO8I3PYTIKriFrr53iBts86XRJ+f7OFztkKSJ8Uetnr/0UYTBMGinjvV9yuMMcbbclp5625EpBW+WAgWOT/IyOf4HOtFJhfK1TcCaygki8HxJ57dBR39mv2oudBf+83n/UB4OYjnzeWqAULsqWgv2DdpnpgU/eSOy+EI5UV0XcCjHiNOnz/eCXJE9YHF/TfnKp51rFVjE52GbfZi/0PYRY+Ot1ki/xTpLYCMPFbnUavV1c8iIAccXl99hCvBMb68iAOs2t2WIF+dkUDUGxywhD5vR8uTv8t7+QZ9RIdBGiduSGkwSpmRH+7+oh/st9nl0YdJU6qWeWQ5MQV5XBHx8OiXNAllNeONFPhl3SeAk5mgKSeUvdRlMd24LnzG0OXZQ1L8CNmUZT/Ql5ZGRXm4sDvVQfnufPNyCKEapSUwvJt7vpH4OLN8mJqFinvjbQHVFEw8Rvsvi7h6MQCW1DSmt5Eq3uw1vcg74MpNm8TEpxN8wJkgnUJjzT/DOh1dxP97DwqPL18pymYbEZJrzlGbnmHvJZBh9YlJTarLxy7zx4kRG0C+khsESqnn73YIKVX+mX4v127SN0HehgVzkssbbND33QuxAQDq8hrIDlRQAIOa3jZ36JYvjJp7WY0rc+K0R50GspCUihlpm+CSRx6dI6ljMBfo//cU8GQL+cfpl1AosXsCH4HZFS2fAzyinuxgV6uDmnsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(6506007)(86362001)(38350700002)(956004)(1076003)(38100700002)(110136005)(186003)(2906002)(6666004)(316002)(54906003)(6512007)(2616005)(6486002)(26005)(4326008)(66476007)(8676002)(66556008)(44832011)(508600001)(66946007)(52116002)(8936002)(83380400001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ITJZBJLlh7PO9Akz5M6rjdNhYUcHjeGjtBXh6k9NOH8bP0PAW15L2ZaikQqb?=
 =?us-ascii?Q?i1hFY27TmPqOoOGNCxFa30hpUehDI7J+zrERFtqp9duicF3coK9Warqfoj1p?=
 =?us-ascii?Q?Nnh0Lu4NQyksHJSHfdkKLbkxX5lZXaMUCTJt33nlhx2eiKxK1rIWZwz6q0uK?=
 =?us-ascii?Q?fPTgPujSJVqRyCauOQaS9DKZ0f/9Mkk/KBg3OvJCuYNVaD+LN969rGJjy7aU?=
 =?us-ascii?Q?IDDo5WkYSiVulQmPrldFAzqdnISSbheMsdSSE9EKc8zrDIS/y5Gck++K4Oeb?=
 =?us-ascii?Q?XXJc5rM3TnX5Ek5wL2Weph5jdzRB5Rqqsc/ninwAV9ateNXnxBWx7pJtGyxN?=
 =?us-ascii?Q?pfisKMgbqJ7HyXunY+UYNYcKhYY7ehmKqtm6Z509rcG8HEQTYp8BrTVJJF+4?=
 =?us-ascii?Q?PHkxyo2juTuCBBDE6aUR45VRU1nxaH/p74eFpayUIBH3riLsor21Y8ulIz0g?=
 =?us-ascii?Q?+1/iJZXsZsuwIuNMVBMfyonKWPn38LSUo7m1353nw0Wd9YrFs46J9aB4ZeS1?=
 =?us-ascii?Q?CkCBjdn3uKnd/7xvdoUidFwSExZPXcgn3Q3bKjfqNo/M3RBDQ4N0VLVay8Ba?=
 =?us-ascii?Q?pIaesmo4/fIRkA/aNhCsN9NBhg28v4a9aiGfEyrmW1U5lSUqa4dn3Bs/NvcD?=
 =?us-ascii?Q?jVj5xUkeel5oDBX4TUBmJxOf3dpbep4wibJsSVhw2y/GB2YnbBsNb8IDpmCo?=
 =?us-ascii?Q?fBpJTFApo/ljEuhLw8L8em0La9WHa6dzO/OJpWsjwQDqjmXVR5Yn12Q+m7vu?=
 =?us-ascii?Q?hRBKvF1T5BkqqPzrhGwbLOWM13URDCIVlUC2DD+ObNBWPHaionePa0M3EpzC?=
 =?us-ascii?Q?dJM3D/Q0hpVZzoA1pvd2TEBkHv8BLePn8++lekdM+NdJLRl7kT0m5UDbFlE5?=
 =?us-ascii?Q?s/aAANEYiOdW/PVoXXAnZ90X3OYqosLbACJ3GrSsRKFizsMr8saXd70x4Gwp?=
 =?us-ascii?Q?HQ0pH5NKYTBNW5polfVncFwFJ4zHiilAV3Cs6wTx/JmqFX+BVonS3ynE3M5V?=
 =?us-ascii?Q?D7RehTgmbeORZOniTVYG3T+qGC85j2WX3H3ECS0Z+CYaNkhr7b9SKDX6W9A+?=
 =?us-ascii?Q?MMWRNTecyeHuJAfir6TbgxMcSXY83LYJKLhhPzAKzxw+LKtzOb2epsqCnwnn?=
 =?us-ascii?Q?664a3q/AEnfJZPRBDGNuBfEwsUlkTS244zp8cNqLEXnt+w+la8XSxc9Z4JZS?=
 =?us-ascii?Q?S4JnWePlOBJfFFN3JG41DbDULXlkydSkjpCcresQIY5bE6UctcAx5eKHTl+d?=
 =?us-ascii?Q?TCtGF6wx/Dqkh+UoD57EwwRX5F6r/duBpvxjujNtqQYlL/2BHxpL+xPs7q3h?=
 =?us-ascii?Q?h6+ANqoiHbwtGdQojzXG4L2S?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30cd18c9-ae14-47a2-b759-08d993f214be
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 17:50:19.0456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9/3Poi3d1qvmJl0cnjN/2RpvJcs3/sQFYX6QmCV71qSv5ntiCb55OB7TN4Mw/nbuBm8lC2incK0KRlFReOW25g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass a single argument to dsa_8021q_rx_vid and dsa_8021q_tx_vid that
contains the necessary information from the two arguments that are
currently provided: the switch and the port number.

Also rename those functions so that they have a dsa_port_* prefix, since
they operate on a struct dsa_port *.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c |  3 ++-
 include/linux/dsa/8021q.h            |  5 +++--
 net/dsa/tag_8021q.c                  | 32 ++++++++++++++--------------
 net/dsa/tag_ocelot_8021q.c           |  2 +-
 net/dsa/tag_sja1105.c                |  4 ++--
 5 files changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index d55572994e1f..f5dca6a9b0f9 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -394,7 +394,8 @@ static int sja1105_init_virtual_links(struct sja1105_private *priv,
 				vl_lookup[k].vlanid = rule->key.vl.vid;
 				vl_lookup[k].vlanprior = rule->key.vl.pcp;
 			} else {
-				u16 vid = dsa_8021q_rx_vid(priv->ds, port);
+				struct dsa_port *dp = dsa_to_port(priv->ds, port);
+				u16 vid = dsa_tag_8021q_rx_vid(dp);
 
 				vl_lookup[k].vlanid = vid;
 				vl_lookup[k].vlanprior = 0;
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index c7fa4a3498fe..254b165f2b44 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 
 struct dsa_switch;
+struct dsa_port;
 struct sk_buff;
 struct net_device;
 
@@ -45,9 +46,9 @@ void dsa_tag_8021q_bridge_tx_fwd_unoffload(struct dsa_switch *ds, int port,
 
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num);
 
-u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port);
+u16 dsa_tag_8021q_tx_vid(const struct dsa_port *dp);
 
-u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port);
+u16 dsa_tag_8021q_rx_vid(const struct dsa_port *dp);
 
 int dsa_8021q_rx_switch_id(u16 vid);
 
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 8f4e0af2f74f..72cac2c0af7b 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -77,22 +77,22 @@ EXPORT_SYMBOL_GPL(dsa_8021q_bridge_tx_fwd_offload_vid);
 /* Returns the VID to be inserted into the frame from xmit for switch steering
  * instructions on egress. Encodes switch ID and port ID.
  */
-u16 dsa_8021q_tx_vid(struct dsa_switch *ds, int port)
+u16 dsa_tag_8021q_tx_vid(const struct dsa_port *dp)
 {
-	return DSA_8021Q_DIR_TX | DSA_8021Q_SWITCH_ID(ds->index) |
-	       DSA_8021Q_PORT(port);
+	return DSA_8021Q_DIR_TX | DSA_8021Q_SWITCH_ID(dp->ds->index) |
+	       DSA_8021Q_PORT(dp->index);
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_tx_vid);
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_tx_vid);
 
 /* Returns the VID that will be installed as pvid for this switch port, sent as
  * tagged egress towards the CPU port and decoded by the rcv function.
  */
-u16 dsa_8021q_rx_vid(struct dsa_switch *ds, int port)
+u16 dsa_tag_8021q_rx_vid(const struct dsa_port *dp)
 {
-	return DSA_8021Q_DIR_RX | DSA_8021Q_SWITCH_ID(ds->index) |
-	       DSA_8021Q_PORT(port);
+	return DSA_8021Q_DIR_RX | DSA_8021Q_SWITCH_ID(dp->ds->index) |
+	       DSA_8021Q_PORT(dp->index);
 }
-EXPORT_SYMBOL_GPL(dsa_8021q_rx_vid);
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_rx_vid);
 
 /* Returns the decoded switch ID from the RX VID. */
 int dsa_8021q_rx_switch_id(u16 vid)
@@ -354,10 +354,10 @@ int dsa_tag_8021q_bridge_join(struct dsa_switch *ds,
 
 	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
 	targeted_dp = dsa_to_port(targeted_ds, info->port);
-	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
+	targeted_rx_vid = dsa_tag_8021q_rx_vid(targeted_dp);
 
 	dsa_switch_for_each_port(dp, ds) {
-		u16 rx_vid = dsa_8021q_rx_vid(ds, dp->index);
+		u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
 
 		if (!dsa_port_tag_8021q_bridge_match(dp, info))
 			continue;
@@ -389,10 +389,10 @@ int dsa_tag_8021q_bridge_leave(struct dsa_switch *ds,
 
 	targeted_ds = dsa_switch_find(info->tree_index, info->sw_index);
 	targeted_dp = dsa_to_port(targeted_ds, info->port);
-	targeted_rx_vid = dsa_8021q_rx_vid(targeted_ds, info->port);
+	targeted_rx_vid = dsa_tag_8021q_rx_vid(targeted_dp);
 
 	dsa_switch_for_each_port(dp, ds) {
-		u16 rx_vid = dsa_8021q_rx_vid(ds, dp->index);
+		u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
 
 		if (!dsa_port_tag_8021q_bridge_match(dp, info))
 			continue;
@@ -433,8 +433,8 @@ static int dsa_tag_8021q_port_setup(struct dsa_switch *ds, int port)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_port *dp = dsa_to_port(ds, port);
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
-	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
+	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
 	struct net_device *master;
 	int err;
 
@@ -478,8 +478,8 @@ static void dsa_tag_8021q_port_teardown(struct dsa_switch *ds, int port)
 {
 	struct dsa_8021q_context *ctx = ds->tag_8021q_ctx;
 	struct dsa_port *dp = dsa_to_port(ds, port);
-	u16 rx_vid = dsa_8021q_rx_vid(ds, port);
-	u16 tx_vid = dsa_8021q_tx_vid(ds, port);
+	u16 rx_vid = dsa_tag_8021q_rx_vid(dp);
+	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
 	struct net_device *master;
 
 	/* The CPU port is implicitly configured by
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 3412051981d7..a1919ea5e828 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -39,9 +39,9 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
 	struct ethhdr *hdr = eth_hdr(skb);
 
 	if (ocelot_ptp_rew_op(skb) || is_link_local_ether_addr(hdr->h_dest))
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 8b2d458f72b3..262c8833a910 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -235,9 +235,9 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 				    struct net_device *netdev)
 {
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
 
 	if (skb->offload_fwd_mark)
 		return sja1105_imprecise_xmit(skb, netdev);
@@ -263,9 +263,9 @@ static struct sk_buff *sja1110_xmit(struct sk_buff *skb,
 {
 	struct sk_buff *clone = SJA1105_SKB_CB(skb)->clone;
 	struct dsa_port *dp = dsa_slave_to_port(netdev);
-	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tx_vid = dsa_tag_8021q_tx_vid(dp);
 	__be32 *tx_trailer;
 	__be16 *tx_header;
 	int trailer_pos;
-- 
2.25.1

