Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF78751B78E
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 07:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243892AbiEEFsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 01:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243704AbiEEFru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 01:47:50 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2114.outbound.protection.outlook.com [40.107.101.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C8C344C0
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 22:44:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYR0ovAJSfkJ6WHr2ue6it1InBVucGFYGhHqSbApQkcyKabiEMAVBVW9euQatrT5V/swvWmCsi/X8wLAxkwK/D+G4G/9HVoo32YIG7KQaCFVYctg8AE2hcTOj7JBIZC0gFK4iwVyHqK2/g/QKq01QMoK+vTc2E0hs7Qo/kcnkv4FZI8XA+02ndbkQ9aVdc6sJrmmzIqXjAKCGiLw2GH+8vjHwny23s4ogFzD3w+uF3rJDZp2EP2FEt2v8D/GPiPubd8DpGC5TiK/cM9mx0tIBpluT3ypo+UH8QCehjmCsdoD6xhZE+Rbsv88jmGOioSp6CthCBHdzcBjIRykB/04jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esvyNvTQ7JgPYflmCkrAwK5ZrM8BYJtSkFgDUNWbVHo=;
 b=inp930aLRXyaAIqTUIfYlv8UdB+snXK0eCKPkc6CjhClNAvfY+pO7zC4EZQcfaNTHtIXCVvUWLrdOV0A4Ne5WFdxZmzHhtcc2gpoltM1jACFjzbz4RV897IWImtYKyCcRSRvJQH4dlAWPfGh35rbx8RO8E2vGasGUb7jCGxDrw71eD6vH31IF08YqS2dQkGE5NKD4C5Uo9mlKadRsykMoANyUk+i+WWBH9R7GZJ0K/U3s7TQq9uiet17Wy42Wy4SDPhujJA2FqpQwP2aU+vnVYJocUCG92tBfmgk0RySjAjX0vL/DfFCW+VwIhyHKShN8U/lf2Y7PZzbfgf4N+yfiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=esvyNvTQ7JgPYflmCkrAwK5ZrM8BYJtSkFgDUNWbVHo=;
 b=F/092Oe9f7QHleDE/slprnSxlTX6gb5jqvN3gFAtJtl2GzTZza1OaHrWi8xvmBcwxL0Q3gv8oywWxZeNDCDHwH1rdkCfCEKE+9DZNM3spuecMesr5irirtDibqFrOe4P1ENBrw0rogEJK6Hs+mGRumwcu7QxO23mnsQkIFhZOaM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN8PR13MB2609.namprd13.prod.outlook.com (2603:10b6:408:82::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.14; Thu, 5 May
 2022 05:44:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::8808:1c60:e9cb:1f94%3]) with mapi id 15.20.5227.006; Thu, 5 May 2022
 05:44:10 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: [PATCH net-next 5/9] nfp: flower: update nfp_tun_neigh structs
Date:   Thu,  5 May 2022 14:43:44 +0900
Message-Id: <20220505054348.269511-6-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220505054348.269511-1-simon.horman@corigine.com>
References: <20220505054348.269511-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0082.jpnprd01.prod.outlook.com
 (2603:1096:404:2c::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36642cf9-00f4-44eb-880a-08da2e5a46fb
X-MS-TrafficTypeDiagnostic: BN8PR13MB2609:EE_
X-Microsoft-Antispam-PRVS: <BN8PR13MB26097AC7453A9A0BC52A08FFE8C29@BN8PR13MB2609.namprd13.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HNO7fcq8fP6EzlkE15lRMAE+95VqFwS9IDnLmmyhqtCVQkjWbEJnp5XaLjC9q++9bmPHeIcpA5mY9cu4fsQFArTSrdcihO6/p77eUBUYzrzB+xGfMoBSMj+ItUbMrbxruRxsgf0vgkBaWAlm3FzFtEcRDRsLJg0k39jvU6UQPkLQFmgSTxKk2pX4nl1K5iCKuDN8Sjp9q/M9e/GQogbC+76KWbUjEmx1goYJl4kVEStzBulvv54ktROVr8Ym3vNYpnLlHRiNCaCoJ614V86FLpgALCa3kPYxG2Shccy+YjHONkE66VY/2SlQT0j0eKEgFLpAnXwQ2n/ZOxtqL2Q1NvQQkzeKvS++PNY0Bx84rVDGUE87LjzN68UJzp7osbcGNaPkjndB6SZVRlftm7JPE/1JI0fPmFsvE2jcV76br/FRSEKBimQzIcsLxFPPdvgtZHAYDNY7HFz3YRs+d5jGzVhSZdP4HUPf4A9RGcmCMoaFhj3yP9CuRzN0J5cVvPRj7YI1iSDFZe6XAeYcd+DX5prgvdj5giD9Erk/q99A3p3mTsogvISDRKeggd1h1mWYlYdCkzdHcpbjBmNuSrMHZ6+gv9Fjv6mV2W1GRfruwPkUD/vWFi3/E6dX5rjcJamMWJARa0szMaSAX2PS1iTAH8AWhSZkY4QFDejgB+KB73M74L154h2XDZ3gv8E1RP8NMN8ySm7f0Gx9VowaSxIAZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(366004)(376002)(346002)(136003)(39830400003)(6666004)(6486002)(38100700002)(38350700002)(44832011)(5660300002)(316002)(508600001)(15650500001)(2906002)(36756003)(86362001)(186003)(52116002)(2616005)(6506007)(6512007)(26005)(83380400001)(8936002)(66476007)(66556008)(66946007)(8676002)(4326008)(1076003)(107886003)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3E7Zo5QszJHv/lar9Mr4lynd3I8+EcoiYle7AC8tzeGjAi54R62CyCwjTSSs?=
 =?us-ascii?Q?UrRINKaTwcVmVV1cN8/PwX3oDiklnPgfAZVJlSJQUeK6YEzY1C/uhvQF76Mn?=
 =?us-ascii?Q?oIQY0lMQy5YIAZvmOYgJj4AOwNIjoz6xJ9uo+Wu7g1n0cGyht1piUH57Jqbr?=
 =?us-ascii?Q?WHLOlDkGuXHl38CyqOD7cd6LPeGLWHlsD5O/vBdERpJxYeozv1QS1joSzXPG?=
 =?us-ascii?Q?S5TJS5tFF3hNrpYxcUgk1VO3ofoFoYTgd5YODz81E8ygzpcvBAYzO2BdxbOe?=
 =?us-ascii?Q?V9w5JOs8UkCpLNOy911j/SaT/MXi0kU5Tsmc74ih/G/U1i2b0wVYOIp+feIG?=
 =?us-ascii?Q?D6j7fy+m0AwQ02wWQ42FcUKHMyu+rgPZ445ZOUakzc4M5aboq+b6KumkhWbR?=
 =?us-ascii?Q?Jq5yDWHvAZA4L7FXJbfNEnU2i/O+RhETJoLUAsGjw0O/obQ9B70a67F6/m6y?=
 =?us-ascii?Q?ONU6lBBeTvdhAQ52HmpzHShBSuFuFfwitaWdJW1D7tn0CS78wtNxK6Q4m4Lt?=
 =?us-ascii?Q?zJ8Zbt3Bzad00hxejwHFbE54eiiwXkFCXmJeIlLKj+RxC1T8MNWwrlf1W3yL?=
 =?us-ascii?Q?8fVAuJ94tNpWPQWSKuSP1WNcmF9jPxNSYoEGtM93PtYryJbkpVx4Nd8+FkTT?=
 =?us-ascii?Q?cf51PSx2Q78ZDI+i3HBtApzxkUFImTXMwQLpf8CPCnfe/Ashpk0K2jD5paTY?=
 =?us-ascii?Q?2mXdxtb408bTz/yR3n6INUzk5DVXp3XwRU0zuUoZ7XgyFsSGdAHFENh+jyYt?=
 =?us-ascii?Q?MksVBBR/rAkQQXHd4U4HdxcfnfQWXv4hFAthIb4BMY/yTUUkupJuQgyzfMqY?=
 =?us-ascii?Q?Upn440o0BTOmHJwtnH1uqbp44JB5Lk7P3jxzY8+N3GN13rNr9YcJzapfCLrJ?=
 =?us-ascii?Q?XVXv8zwYud+lBxdmFQ1yr0OUb565mOiSgZ/LRVeQJirl8lyibeXKTeDI8XWL?=
 =?us-ascii?Q?JQjuAUfiabwD6hI91tRTRgW8iyuAHj7HpiPyQZtfweEkB8kOyLzdSlO8wvFH?=
 =?us-ascii?Q?ykGVedcePDcWq+8hnGdzLpmUcy6vqZd/Yvs5ysYAV3bR89HVqb9IzmZ0RooI?=
 =?us-ascii?Q?KrF2pGnUQNAjMLB0odM8cD4u80w25OpzFCtz7ceUZknBUSgj0dbe8Rqz8si3?=
 =?us-ascii?Q?ATy1T9ebSfz8NmRnnhlWv6Ydo8Z50tgWqokxc/Prvgst7YEEo7tWj9lJPQU4?=
 =?us-ascii?Q?MqlHWK6DBpfuE0f5NC3YJry9n7v1+jpyQv20h+fIC5cvHwUAzu6TTJvFGhb5?=
 =?us-ascii?Q?jHiqCjTXVAWYpRyFzPLVE34xtGhFI0N5shnWeTUuxOSMdMFaPVC4uMKp1Z3d?=
 =?us-ascii?Q?f/gXwKniI5susFu4rUJ50PvVpJIF7v85C7W1jQIb3Unfop0dg4UJyr9oD1L+?=
 =?us-ascii?Q?ftQdB/T0fOtllUMDXeA7AcXQSA39FY4KgqjovgMNLcfdYHd/yhJLbNmofRsV?=
 =?us-ascii?Q?/p78pQMNNWUFN0820EaL01tihACBwNzIrdlcEWzfCXfDwrWiAjPzdayLvZiM?=
 =?us-ascii?Q?aBVGnB0IZe/tcPcwIgJQWzx5QlUNvJJzi4nrKkoA7q7fj5GLqwEpmNHVxDT7?=
 =?us-ascii?Q?BgYH4SHpVQ7IvZ8qZtdiUs6jjz33wGpSsziDCYTx2sos45APRGeBCxAZDKt4?=
 =?us-ascii?Q?Vf1j1dj+HivmcyuUaaQoERFiorkF8fOeOLd+sn1APVVxn+Mo66FocgQjtBo4?=
 =?us-ascii?Q?5JkbdivrrLKRTdMah0D8H40Lne/Ep9ElOLnpQNC4wUeA0++FoCxmNMkjh3FP?=
 =?us-ascii?Q?yj4rAzfA2t2NruY+qx/Hi0cHiThDxOA=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36642cf9-00f4-44eb-880a-08da2e5a46fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 05:44:10.2150
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ch/28AuJb3p/KwKLHXO3bqhGhyvoTsqtioZ5pqE5nG9zV7p2MQCoO/syFw48TQedfpvIapNkEyOULPHH76Z/mcSt1f1M2yoCWuPfiexW3U8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR13MB2609
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Louis Peens <louis.peens@corigine.com>

Prepare for more rework in following patches by updating
the existing nfp_neigh_structs. The update allows for
the same headers to be used for both old and new firmware,
with a slight length adjustment when sending the control message
to the firmware.

Signed-off-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 .../net/ethernet/netronome/nfp/flower/main.h  | 50 +++++++++++--------
 .../netronome/nfp/flower/tunnel_conf.c        | 30 ++++++-----
 2 files changed, 47 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/main.h b/drivers/net/ethernet/netronome/nfp/flower/main.h
index 454fdb6ea4a5..2c011d60c212 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/main.h
+++ b/drivers/net/ethernet/netronome/nfp/flower/main.h
@@ -111,47 +111,55 @@ struct nfp_fl_tunnel_offloads {
 };
 
 /**
- * struct nfp_tun_neigh - neighbour/route entry on the NFP
- * @dst_ipv4:	Destination IPv4 address
- * @src_ipv4:	Source IPv4 address
+ * struct nfp_tun_neigh - basic neighbour data
  * @dst_addr:	Destination MAC address
  * @src_addr:	Source MAC address
  * @port_id:	NFP port to output packet on - associated with source IPv4
- * @vlan_tpid:	VLAN_TPID match field
- * @vlan_tci:	VLAN_TCI match field
- * @host_ctx:	Host context ID to be saved here
  */
 struct nfp_tun_neigh {
-	__be32 dst_ipv4;
-	__be32 src_ipv4;
 	u8 dst_addr[ETH_ALEN];
 	u8 src_addr[ETH_ALEN];
 	__be32 port_id;
+};
+
+/**
+ * struct nfp_tun_neigh_ext - extended neighbour data
+ * @vlan_tpid:	VLAN_TPID match field
+ * @vlan_tci:	VLAN_TCI match field
+ * @host_ctx:	Host context ID to be saved here
+ */
+struct nfp_tun_neigh_ext {
 	__be16 vlan_tpid;
 	__be16 vlan_tci;
 	__be32 host_ctx;
 };
 
 /**
- * struct nfp_tun_neigh_v6 - neighbour/route entry on the NFP
+ * struct nfp_tun_neigh_v4 - neighbour/route entry on the NFP for IPv4
+ * @dst_ipv4:	Destination IPv4 address
+ * @src_ipv4:	Source IPv4 address
+ * @common:	Neighbour/route common info
+ * @ext:	Neighbour/route extended info
+ */
+struct nfp_tun_neigh_v4 {
+	__be32 dst_ipv4;
+	__be32 src_ipv4;
+	struct nfp_tun_neigh common;
+	struct nfp_tun_neigh_ext ext;
+};
+
+/**
+ * struct nfp_tun_neigh_v6 - neighbour/route entry on the NFP for IPv6
  * @dst_ipv6:	Destination IPv6 address
  * @src_ipv6:	Source IPv6 address
- * @dst_addr:	Destination MAC address
- * @src_addr:	Source MAC address
- * @port_id:	NFP port to output packet on - associated with source IPv6
- * @vlan_tpid:	VLAN_TPID match field
- * @vlan_tci:	VLAN_TCI match field
- * @host_ctx:	Host context ID to be saved here
+ * @common:	Neighbour/route common info
+ * @ext:	Neighbour/route extended info
  */
 struct nfp_tun_neigh_v6 {
 	struct in6_addr dst_ipv6;
 	struct in6_addr src_ipv6;
-	u8 dst_addr[ETH_ALEN];
-	u8 src_addr[ETH_ALEN];
-	__be32 port_id;
-	__be16 vlan_tpid;
-	__be16 vlan_tci;
-	__be32 host_ctx;
+	struct nfp_tun_neigh common;
+	struct nfp_tun_neigh_ext ext;
 };
 
 /**
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 0cb016afbab3..174888272a30 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -281,9 +281,15 @@ static int
 nfp_flower_xmit_tun_conf(struct nfp_app *app, u8 mtype, u16 plen, void *pdata,
 			 gfp_t flag)
 {
+	struct nfp_flower_priv *priv = app->priv;
 	struct sk_buff *skb;
 	unsigned char *msg;
 
+	if (!(priv->flower_ext_feats & NFP_FL_FEATS_DECAP_V2) &&
+	    (mtype == NFP_FLOWER_CMSG_TYPE_TUN_NEIGH ||
+	     mtype == NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6))
+		plen -= sizeof(struct nfp_tun_neigh_ext);
+
 	skb = nfp_flower_cmsg_alloc(app, plen, mtype, flag);
 	if (!skb)
 		return -ENOMEM;
@@ -416,14 +422,14 @@ static void
 nfp_tun_write_neigh_v4(struct net_device *netdev, struct nfp_app *app,
 		       struct flowi4 *flow, struct neighbour *neigh, gfp_t flag)
 {
-	struct nfp_tun_neigh payload;
+	struct nfp_tun_neigh_v4 payload;
 	u32 port_id;
 
 	port_id = nfp_flower_get_port_id_from_netdev(app, netdev);
 	if (!port_id)
 		return;
 
-	memset(&payload, 0, sizeof(struct nfp_tun_neigh));
+	memset(&payload, 0, sizeof(struct nfp_tun_neigh_v4));
 	payload.dst_ipv4 = flow->daddr;
 
 	/* If entry has expired send dst IP with all other fields 0. */
@@ -436,15 +442,15 @@ nfp_tun_write_neigh_v4(struct net_device *netdev, struct nfp_app *app,
 
 	/* Have a valid neighbour so populate rest of entry. */
 	payload.src_ipv4 = flow->saddr;
-	ether_addr_copy(payload.src_addr, netdev->dev_addr);
-	neigh_ha_snapshot(payload.dst_addr, neigh, netdev);
-	payload.port_id = cpu_to_be32(port_id);
+	ether_addr_copy(payload.common.src_addr, netdev->dev_addr);
+	neigh_ha_snapshot(payload.common.dst_addr, neigh, netdev);
+	payload.common.port_id = cpu_to_be32(port_id);
 	/* Add destination of new route to NFP cache. */
 	nfp_tun_add_route_to_cache_v4(app, &payload.dst_ipv4);
 
 send_msg:
 	nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH,
-				 sizeof(struct nfp_tun_neigh),
+				 sizeof(struct nfp_tun_neigh_v4),
 				 (unsigned char *)&payload, flag);
 }
 
@@ -472,9 +478,9 @@ nfp_tun_write_neigh_v6(struct net_device *netdev, struct nfp_app *app,
 
 	/* Have a valid neighbour so populate rest of entry. */
 	payload.src_ipv6 = flow->saddr;
-	ether_addr_copy(payload.src_addr, netdev->dev_addr);
-	neigh_ha_snapshot(payload.dst_addr, neigh, netdev);
-	payload.port_id = cpu_to_be32(port_id);
+	ether_addr_copy(payload.common.src_addr, netdev->dev_addr);
+	neigh_ha_snapshot(payload.common.dst_addr, neigh, netdev);
+	payload.common.port_id = cpu_to_be32(port_id);
 	/* Add destination of new route to NFP cache. */
 	nfp_tun_add_route_to_cache_v6(app, &payload.dst_ipv6);
 
@@ -1372,7 +1378,7 @@ void nfp_tunnel_config_stop(struct nfp_app *app)
 	struct nfp_flower_priv *priv = app->priv;
 	struct nfp_ipv4_addr_entry *ip_entry;
 	struct nfp_tun_neigh_v6 ipv6_route;
-	struct nfp_tun_neigh ipv4_route;
+	struct nfp_tun_neigh_v4 ipv4_route;
 	struct list_head *ptr, *storage;
 
 	unregister_netevent_notifier(&priv->tun.neigh_nb);
@@ -1398,7 +1404,7 @@ void nfp_tunnel_config_stop(struct nfp_app *app)
 		kfree(route_entry);
 
 		nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH,
-					 sizeof(struct nfp_tun_neigh),
+					 sizeof(struct nfp_tun_neigh_v4),
 					 (unsigned char *)&ipv4_route,
 					 GFP_KERNEL);
 	}
@@ -1412,7 +1418,7 @@ void nfp_tunnel_config_stop(struct nfp_app *app)
 		kfree(route_entry);
 
 		nfp_flower_xmit_tun_conf(app, NFP_FLOWER_CMSG_TYPE_TUN_NEIGH_V6,
-					 sizeof(struct nfp_tun_neigh),
+					 sizeof(struct nfp_tun_neigh_v6),
 					 (unsigned char *)&ipv6_route,
 					 GFP_KERNEL);
 	}
-- 
2.30.2

