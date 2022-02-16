Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495024B8E74
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:48:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236613AbiBPQs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:48:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236598AbiBPQsY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:48:24 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21222804C1;
        Wed, 16 Feb 2022 08:48:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekIyrTVlKcmf06QokmZW311jzc5O8MXmUsupZ5utH1hiIsnCMdqkRmoJIY/DJA4Zw0wcXSk1HKRcCOrhKsSRO4PZprL6MQjkH8BLKWdme9LJn2pVCyHci+pA5NH9gV6J3YWUNE8wUhNvQL3YWy39bfbEorY4uulrZFcRtCktXFK+K1muhRN8eoLn/gyVaNINYUrjDII1Bq2C0UFjEIisKunprvP5b7KXx5XC3EeNyGRdCpDWUpDi+31oZ9Aa2a8VVa2ld/dboszxC0V4+K+6f7oikW9My1SOHbJv0i2Y4+rMOizwi45xhDDcYXnMNV1zQ05TiwNl09Jk2UAX6qyc3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFKE769psFV51b2noPHabpFVlRF4vyKlifQCkErRcfQ=;
 b=PnCulho7Z51nLlYg7i/a0ssxrWzeB3yhWVOjYe+RIyCuFvgodbQ/wOC7X5uHfLk13XKhxhodvPnn5fx6UVI6UMqfzlushuostIQ2OjU235QXBzV29/VhSTHCmEDOQESl6Drv9rHLN++o2mFE6VpFTNEBPP7rrui/Rz2i5vbb0zevm/JqgIEJqxP6yhYvzNmxqWVK6RvP9oPWZ9c2rx7bMg96XD7qWTPTHGaduIiMQZSuvfxQYo76RHEYIKWBY1ma4AW1xX7UEh9D4ATK/TpIy7b9KLnOK7jwgiGdpXb6BFeGNmzxIBNec3sJMyIppAZVal59Dt5v5/GHlOMMlSRK8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFKE769psFV51b2noPHabpFVlRF4vyKlifQCkErRcfQ=;
 b=cCqjIN43zwfWx1cvBbug4iyCpmsWKsk+zMxCQxr/Q4MITOkKgIiOX+CkOWM0mNfHbNaODLI05YyYqPDd+Wht5zvwV5a+1A3qIJa6LlCZ7nR3fk7kwVcfvK2dLRtw0Kf7B+MZD6Q3fHWWTpQZJvBw9DaNrBC9zklpR9R5TuVIFYI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4091.eurprd04.prod.outlook.com (2603:10a6:5:1e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 16:48:09 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 16:48:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH net-next 1/5] mlxsw: spectrum: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
Date:   Wed, 16 Feb 2022 18:47:48 +0200
Message-Id: <20220216164752.2794456-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
References: <20220216164752.2794456-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0302CA0009.eurprd03.prod.outlook.com
 (2603:10a6:205:2::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33a27278-8aa1-4091-feca-08d9f16c1c8d
X-MS-TrafficTypeDiagnostic: DB7PR04MB4091:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB40910E6206F95B3E8D0B6C69E0359@DB7PR04MB4091.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DT3RnbGVy2S7BVUw98wYkBayFDcFov51jsHw3oFSxZXJDHw7914c1qtsT6SBbQcAL2eHHCYTgc0Zq/RPHOeQvh+S2eE8FErOMhHXq1Ab07josIodVG2INTTaTo6wqI2mLNhqisW0xxC730QFr2soOSMu1LzNvGPdlqP/J+bPW/eHX07RX95eRy7UXUsQ0TN8tM2XizYSAY6n6O4MkPZ9L8Cc/RgwFZqXZ4mAT8ZJThHqMmNoQv4Ss0YguNt1TLiPditS1fVJVV9bLu+FDPNZG7piM9ZFYHzjG0Qo2Uisvwx5YHq8lPJR0Vi2D+PrSd4hcgxW+mHD3YE5BVCUG0eS9LeurcIoeg/OJvMFsYt8KSQ3V8nn6K0Y8ffAM4ZF0N+qOzBlD2DanRJzDDkghNqd83wv7aqgorjpI0tDmcpne5Fo5oDyELJTcNn1ILZNiXO8sDbRI5b9Je/eBon1m33H801Relv0B/AsmZZkOt4hT5TzaYAiTiPVr7WzGHxiYKYUCMOfaPgv6BWcUgIEGOCcoXxIfFBU8yR1O5Fn0tG1Sh/Z5PxB5kiZlwTm+rRT8dgyQWkwCF5HpIKdCtVWQJwiy8INLkg1Fx4OSMO84mjihuzKQBUzSl82KGt8yS3MRf1nJy9a1HNvixCoTUbaxQyZ3pEjXfQKrjE9OYuQjzLA8HIWfrdCInsZDvl2+wwHykKiMU9fVV3pvYIUoYuIzNmXig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(44832011)(6916009)(5660300002)(8676002)(52116002)(186003)(7416002)(36756003)(26005)(66476007)(6512007)(1076003)(86362001)(2616005)(8936002)(38350700002)(6666004)(83380400001)(316002)(38100700002)(2906002)(6486002)(66946007)(66556008)(508600001)(6506007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FQC8XdVYIg4drrxoGzy0gHZQktdUeevUQPccw3S0VnfLL4S5+yKQirCFFFUI?=
 =?us-ascii?Q?lIqu7icg07ULNdEuxncWS95iKr4599w2RKb5M4nLbEDolpgHGHwhesLEF7j4?=
 =?us-ascii?Q?re1uIquesdqVyY/bAj2QkwJ1oVSSylB4Hzll6WJgpUbk/VTt3JbhC+pEX+uU?=
 =?us-ascii?Q?5a/UoynZLea83achQdIzpldxrK7xv646WXPl+NbWL7/TTWH38BN+duAPaHYu?=
 =?us-ascii?Q?1oRko2t0wugHfzjbyVMiUxppDzqQoxuaSoFt9TbyQ6BiEu84tahfGlPrNeGN?=
 =?us-ascii?Q?Oex7IuoqmB1ns5Sbkk9JJgrv4VslFcHlKN2dFALN2WcYTmJIOxEo5pY1uzEm?=
 =?us-ascii?Q?gbKEsEDkLuIe4LPV7p2glMutOTY2Rt1ALKsIIQOvqCi0bISIoxnxEtvyJ+up?=
 =?us-ascii?Q?tIVTYVtefcJ6xf16Nyu/7aMuPiXgDzWuOLYBWl1XZi+l6zKGCAQkKsASnSCj?=
 =?us-ascii?Q?uXJukO3GH1hDoyRypTmlKTacK6qBh7Wg+mZ/vWNKdNqK0QOn35KOpDFWIAg3?=
 =?us-ascii?Q?haUfHeiHitxuVsftCgIpGaOEg7QbUhRfnfGg4t0Ge1OvGSlfesulGDm7SIKx?=
 =?us-ascii?Q?5XmdDBDwFcUwKuvB6kTTF1IR8z2B7WbffegfHsE1z6v6khkc941bmRbir2dB?=
 =?us-ascii?Q?ERfxx5hzAiEd13O5N9Cn/MBw7KeHtemv3bwY4eYIXuW/BIRYGszKgq9jqTqQ?=
 =?us-ascii?Q?/2JsJMMfcKo6+3PAmUI2tCa19MLsBxPmhtafSOL25eO4PuG/ANIxOK0+OUC+?=
 =?us-ascii?Q?JWnFxxwYmc4DIWtWsxXM+JPf+vWX3umXLnzqGXNb569AyP8MP0DKWuMPHUyG?=
 =?us-ascii?Q?jSHGPwGzOXvzSJDglphC7PphqhBQQqYYKZkBs8nnrkYixQpd0cLzxs8vYAtj?=
 =?us-ascii?Q?11cmqeOyz9tKHEiHJOGPs1bZVV9/TcjdIgRbGkeIm55xZh+2bR+J22psC2Vp?=
 =?us-ascii?Q?lsH7/W1w9axWGqnPuA+DEJuEWEfVm1JOWgOABjrGgQIgrStSNrjRDIgdoDeF?=
 =?us-ascii?Q?kUC1pkkbXMcxe9PMXwQaErEBgf1vI647qH4kyBgVElx9SHJZ88Z/OcrHdhz+?=
 =?us-ascii?Q?e1wq5UKVXWoHnb7alcVLc7glNK2W0Z2YKqSYJmcOfqeuBfRLuBvudvMwKsv6?=
 =?us-ascii?Q?06noA0AJkNLaTsGd4LaRU8uy6GcZnL6F0K6bVi/Mtyc2NBInCAWzTgOSQiGp?=
 =?us-ascii?Q?Isgr1oTSvJkln83J9XPZnXEgbRAPVQB3C85XUzUYg50KdYIpciaLlrSdo6GJ?=
 =?us-ascii?Q?NmrWlJ12w89yuIMne2MjxDciIBiup2E8FbUE639n+FjNmZYQxYDAE/RaeQen?=
 =?us-ascii?Q?nnesgn6gc/OXGKeNz6PAgPJ84HlM4p7ZQKDPX7plkgTASlLTS8nQrkxZs/A7?=
 =?us-ascii?Q?uiqLMHlJMC4KfOdNyNnwMEfrMD0xdxq09pjOp/7k90CSd0kQf6OV1UMMx8yP?=
 =?us-ascii?Q?OldY5EchLXaMFqr/aw6cwLKwEHQ6Wdk1RSbAeJYYLinKu8lp3lrExSRA4483?=
 =?us-ascii?Q?aPHTAosFxms4TW0sMplERl7j8XoY87wOxN6VPVUlcg7lV+SbpPNtFlxHKos1?=
 =?us-ascii?Q?IFzpxXvQs00Y7ZHlTLQz7G8pZgeXtBVlhDlTnyB1IikVKzJdDxfh5CMC5rOH?=
 =?us-ascii?Q?6hc5PtmPizisJkDKr7JuBc4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33a27278-8aa1-4091-feca-08d9f16c1c8d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 16:48:08.9340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6f4mbG5ATCNZDseneSW+fnujMiHDtOvw0xBZGERBuAHAVGyF6Dv7CXrsh5e19z7QHttI1piTCIX15JsEMdLlgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4091
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit 3116ad0696dd ("net: bridge: vlan: don't notify to switchdev
master VLANs without BRENTRY flag"), the bridge no longer emits
switchdev notifiers for VLANs that don't have the
BRIDGE_VLAN_INFO_BRENTRY flag, so these checks are dead code.
Remove them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c      | 4 +---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index f9671cc53002..5459490c7790 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -269,9 +269,7 @@ mlxsw_sp_span_entry_bridge_8021q(const struct net_device *br_dev,
 
 	if (!vid && WARN_ON(br_vlan_get_pvid(br_dev, &vid)))
 		return NULL;
-	if (!vid ||
-	    br_vlan_get_info(br_dev, vid, &vinfo) ||
-	    !(vinfo.flags & BRIDGE_VLAN_INFO_BRENTRY))
+	if (!vid || br_vlan_get_info(br_dev, vid, &vinfo))
 		return NULL;
 
 	edev = br_fdb_find_port(br_dev, dmac, vid);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index bffdb41fc4ed..3bf12092a8a2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -1234,8 +1234,7 @@ static int mlxsw_sp_port_vlans_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (netif_is_bridge_master(orig_dev)) {
 		int err = 0;
 
-		if ((vlan->flags & BRIDGE_VLAN_INFO_BRENTRY) &&
-		    br_vlan_enabled(orig_dev))
+		if (br_vlan_enabled(orig_dev))
 			err = mlxsw_sp_br_ban_rif_pvid_change(mlxsw_sp,
 							      orig_dev, vlan);
 		if (!err)
-- 
2.25.1

