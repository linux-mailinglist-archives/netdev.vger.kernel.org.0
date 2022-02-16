Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B0D4B8E7C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236642AbiBPQsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:48:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236618AbiBPQs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:48:27 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D0D280EFD;
        Wed, 16 Feb 2022 08:48:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0OGrj7ZOaFruPZrdjuQtikxn9eI3IaJryBs4HLV0NVQ3B7W82BVy2xizIaaDj7Yq6pY8jjZ0KV7FkRNQjq8Ba3MV56cR3Gzc3efTQ+V2hZXUtu2+vtDgHmnU85PTYMsCN0yzGNVglbkUcI+Nfqf0HXJJWUOHHVR7VguDoxI9UbnP32BMKEUlzUxhrw+oa08Q+WukbAloMcN6yY+YkOLnnOJAZ2bw/k5G0ttBxkj1qfr9XxTFGGjPu9ZD52lCSLWVI0A0/uIVRPX1pO7yqxvgoMfO0Ts7rrMPw06nQSLfniyN8XizOi3u2zjXdsHnTQtpVuiFQrZzkPBHVUN3sEDrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ns6bcDZIr9IavkjqofzyHNouaIV2fyNuGoHSukZvYsQ=;
 b=BwvUku+56KTt9s8X675otqSj4yniifRRreQoUpLjWOXUadC7ON0AwLNSRUcM+wrnrHGdOBS2dVh94krLh2OX2Mdh43hutqi0QaixwZa2XqP3N3bZFS2aRIuSM1d5gYp/D1NISCUSyOfTQWZplwPNcDhiO4Ln6lG08m9VSA47vNYC+VO2FDsnrdkpr4as3U39wo7m+VRf4PpxJxKUDazXK+vUC9HnWatH2gleWW+mZeZm6bAiHFdjXAMUVhYy3LZlo13Lr0oSNAP68rO/yF/uZHd3K4w5K8Qrd1MVuOfQLzX+v14kodOzO/9aEvg0W8NfRgNhzOUmEJSwezp7HQieeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ns6bcDZIr9IavkjqofzyHNouaIV2fyNuGoHSukZvYsQ=;
 b=g1qqi1UsHKBABc3zmrEC1oNSJlgVArglSa10AteNwpAXDcsysjknczbB0N1mcHGEelDuMm7BHgVOEG3jhunGH0Pz57BEtxVFKex2OChw6nCZftKwIksFcD28cg26QIWty+WkBP4yht/T2k7vlrLR/96fJWyeJoZHC+6QN1QDs1A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4091.eurprd04.prod.outlook.com (2603:10a6:5:1e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 16:48:12 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 16:48:12 +0000
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
Subject: [PATCH net-next 4/5] net: ti: am65-cpsw-nuss: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
Date:   Wed, 16 Feb 2022 18:47:51 +0200
Message-Id: <20220216164752.2794456-5-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3caf21eb-f347-4f9a-622a-08d9f16c1ee4
X-MS-TrafficTypeDiagnostic: DB7PR04MB4091:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB40913ACCFD2BC231674E5D49E0359@DB7PR04MB4091.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XY0E1jdhi9RVbCyQkL8kagEC6CKpTPd2oIHDEkmP5DyGcaTEAuc8mH90TVjgVSdi9J12ldNokAwj9DGFD0hqu14HibqVxnSHLTo9oLA5pw2kF/APgX8raVEl/v1uW9FgkxY3K3LJiXjRsikPf+g8uWgGL//Ehc4ePu3x8HJflqcjbGkw02mO5a/Hl2yE/b2GfzFdpxZ2jGUAYFJmJiPuqz7+XCykUtm6B04F+GSF88CC0eGonLWfMYohJKsRFijyYF+6re0NiaAMzFWKlZqveSlu7B5Ue57/BPeaMauGeazwcrd0bcmgFJrOuKPkOd01Ful5SCUTrrfr/zGInugafZfvjAiRpfXLqsFeTZFigAYbN48+WN7qdWWfkyQBNqWux9rIaIwxJHCC7EeL175eI1+Ep65K+ZyjCX5+Z/w6TueUlJiGeQ1z9WhoPY61Jf/Yno4DdAR1mPI9P8O2DVCh1Nq4rqnC8AfuaQchUZcd1gBFlMeSy5vDj417dFzOnXUbCvAf98DTPoPRJH0YIWFrTelZ7ll0LxwlGXxT6cgsHRDVvtQmcs9yDZ8WwvKE2EOkHfoagyq/M8VRSgjIbYYwg6A7XjD70ipPHQrldTcR75vAC9WCbwyPqf7dsbLqFB07w2M+KXX+pXBQURXdtrpNRhkBx1HztQC//l+xRAM4z7X4T7Gr5WLdC0TjmkRVSjklJqiGivDqsaxiNpbhjlEXfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(44832011)(6916009)(5660300002)(8676002)(52116002)(186003)(7416002)(36756003)(26005)(66476007)(6512007)(1076003)(86362001)(2616005)(8936002)(38350700002)(6666004)(83380400001)(316002)(38100700002)(2906002)(6486002)(66946007)(66556008)(508600001)(6506007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JDtEwQtM5l1ANbwE5zKxOGKtSQMDn9Km216O4DQq8+a94pOgjwPaO9JznMEA?=
 =?us-ascii?Q?nsFcv0eK1TTY5XGWW/7R8VxA9xFPON1BuTygpPGHC9xechuiTYYKuenpzRsv?=
 =?us-ascii?Q?RJ4p896YMa7u12zSrZ48KAnl0GUDIFVwAldPjZbS6Q2Ksvc7JNcAT2bMvh25?=
 =?us-ascii?Q?VGZ6wsfrf3IAO0tjSYmuur9cSK+14MMx/QpNC2+gu+sEaX2zI91wpOYybwYt?=
 =?us-ascii?Q?p3xiRcpitjQdluVJGIlZ9KEZMhcVP3wTRu2+X3jpUsWfosCr3lzNOzhoyUCq?=
 =?us-ascii?Q?ItrRyAg4tT7FTj/E5/RAIpwgdkEsKwkuaxY7A1Ocb3liXfjeFefmoo4Ns4pZ?=
 =?us-ascii?Q?1zNXTyNgS6aqK4nHtTZy6OylOtDPoHGV042VKK9kexLzN416m4+9Q8KO8Awa?=
 =?us-ascii?Q?q5u4/lxx9FhZe5EEUldpg7GDyU1o+OdmTkvL6JGyXzCkrX8P1nnDEi4k0Tfx?=
 =?us-ascii?Q?MuAABDWxNZKwuSHN3FlXYzd8nutQqpanaP+kalQmArCwlwEh2NACQDLTFFa2?=
 =?us-ascii?Q?JzFLw9II/WwcojJ0JFJfcWmT65fbm3+sbZaMFx8cVpt/al0356Dw2EQmafR5?=
 =?us-ascii?Q?JaIauJxtOtNGjDkyFkybxAoaxfRQtgTGcMzCUXDCTmitQRJTLa+2Uah9Yawr?=
 =?us-ascii?Q?crW0KpTJ639JY3dl1ZYsLkLaG5R8uqgeSNu8h/IoOyn9KNUQNDHzLtjX6RQm?=
 =?us-ascii?Q?RVdO/vL9fHFl6Fp9Qj1id7gsE/qY+9AVpRWRWMD3CFLHZDQgnJd4F/HDGA65?=
 =?us-ascii?Q?cvrm5LndM/mA6mpThsI4BFYqS1mGZTxShyoSvQfVZvtV3T4nwiWj3YElWqDX?=
 =?us-ascii?Q?qwxg9DyRXfuUt0E9TjwzLLN5MAGYJZhIzBrXpc5u5xplOiggxF5ZanKSJc6P?=
 =?us-ascii?Q?GLIIoZc4fLLySQKPIbFMRS9sm+sbeH6WXB0/RmnR2QeCAiXIHw6YwhbnxADy?=
 =?us-ascii?Q?Ekdk3aDaetK2al/ZVHZ2BN5vMfSoscnr2jmGjcFNnRo2oOWkm+7Pder91JjK?=
 =?us-ascii?Q?pAJXWteVlzZoTKx1xVpet6yjjIHUb/99/xia8Dl3+rmQK7bWvZOyjPWkfD/h?=
 =?us-ascii?Q?App3GIDrDLR65Zzx8LX/uiPvI0SV9E0u9Z5eqmRq8jzwJb8U+Kv/AuCoih44?=
 =?us-ascii?Q?Py6xehDYJLW4zj8vn38exGnPzlFfRCX0e0aq8S4nTYat+D5fsNy1efoBxDsZ?=
 =?us-ascii?Q?PV9IVQ9Hwck2xWWV/3mlBF8LF27xxxtBbtfeU7YdFy1Il05MEY+LcvsDyP8Q?=
 =?us-ascii?Q?He3AV7AgXksfCgTLSLzjF2J2xkBCQUvLwm5a10p4IEc5pjGUXBkLtRl+hTd1?=
 =?us-ascii?Q?BslCx8ZjdCNl7dpsXPfjwyWCxEf6nfNDDQtE0BjCf0KkVCWeDUPRa+54ker6?=
 =?us-ascii?Q?HbBP9XsoFo+rIv5M5EpN6k5y01i9QgPJjncphY/Ux9aCNN+Uey6PeLov1D8+?=
 =?us-ascii?Q?qUjJqC/EEcdacjxI/FdyKFS+fcB42CragohSiWnOVWT72C0sPIhAnjsOfj71?=
 =?us-ascii?Q?FN0/r8HYdZ1gjOSltvfNV5jgFYs/fcqGeeltVK2S7LlRvgunNSCISGeHISC5?=
 =?us-ascii?Q?G7ia74dvSYGGapaNM/vYLLVHgn4FwmXjU4GHicFnVtHvPP8dS71vQcHyfiqH?=
 =?us-ascii?Q?Lb9lKXhPniKd6UQ2XUKGJX8=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3caf21eb-f347-4f9a-622a-08d9f16c1ee4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 16:48:12.9027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4y++ulviH55uPMPhmqj8NhDwhiGsPgwoxAEH2KOhuHSlqO6OCS0K1a5nEeNYWrzLpC3NrlMQr4s3EtAI5qJZ9w==
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
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
index 599708a3e81d..d4c56da98a6a 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-switchdev.c
@@ -237,15 +237,11 @@ static int am65_cpsw_port_vlans_add(struct am65_cpsw_port *port,
 {
 	bool untag = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct net_device *orig_dev = vlan->obj.orig_dev;
-	bool cpu_port = netif_is_bridge_master(orig_dev);
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 
 	netdev_dbg(port->ndev, "VID add: %s: vid:%u flags:%X\n",
 		   port->ndev->name, vlan->vid, vlan->flags);
 
-	if (cpu_port && !(vlan->flags & BRIDGE_VLAN_INFO_BRENTRY))
-		return 0;
-
 	return am65_cpsw_port_vlan_add(port, untag, pvid, vlan->vid, orig_dev);
 }
 
-- 
2.25.1

