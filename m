Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC944B8E7B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 17:48:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236650AbiBPQsh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 11:48:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236631AbiBPQs2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 11:48:28 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4781F2819A2;
        Wed, 16 Feb 2022 08:48:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYMkMCJW0Ov2946nJ6vmk30OA1n9KtlkbVs2LMHOmT3709rdBT8aMgk07YeuN6s6aMlOVsCK4UBtN/BTAPSQ55sBJtxDQXrrd/zBcqoxD9LtWOvYcFlyoP7xpyvgY8VAb2HsvXpAhJ5lnKHCMoUNIKjhsEUctRRBkc8c8MB/8Rfos/glFhOIbGtjUDw6uPlYG5utyM78BLmJpzEsL913yJ7n0zKIIYKC9iAasg90287F6vRaxgCsFlCfgEQQDNb9IiYjwAlsJBotz08T+HJBb73Rxfdxpu0Obzr5z34kbyZ4WRra1WLu7LFVRtqIaz2g1XMfMYhRykgJtHRioXPB1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a28wi/5xh2Zt5W6xwbI/RdUMu6XiQwt9JfhXmzFxOO4=;
 b=lCTTaHCzVJcQ0AokPmx3p28Dd/0Ah7z/MSpTudA7m7YdGkw7c7nWx52Y/4NDB4swlNPYban/HG2O1pjB+vnq7E+fSkCMBmLKkzOl1oCylY/VZjkU3x1v9Nw1RZGWBy5rct6SVziCMXzAgw9NT7/UYxHCc2Lsos6q/E68uYlAd02I4FsvBVV2ZxLRlOYum0vdbXWgH00NlaPw0U29ht0FLB1OPmaS+TAXp1xYR5K5IYE//Iq+6Y2RLk3438fg7n0apIK7eh8756/LXxixTpe+fOItDfCV5Uzs6nTKHeKb5uVEhwkLIP5mT9I4wv4EUfDtyoj0rhtS79pZg1wR/Nntow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a28wi/5xh2Zt5W6xwbI/RdUMu6XiQwt9JfhXmzFxOO4=;
 b=iQwTBuYfRY7DgeUlRfNQgfRQz/jYgyOWcq7+C9oskhxEMSzy6FklQQZiiK/f59/0S8ar1YR/Gk5IiClrqhA3r1NBDXpjHUhRhkBBKVQ1dTF+Sj0dbWfL0Zdc5CimN0fRBEec1y982ZvNhZ7kZ78THpyGjqbuG7DUL7/imz2yd4I=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB4091.eurprd04.prod.outlook.com (2603:10a6:5:1e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Wed, 16 Feb
 2022 16:48:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 16 Feb 2022
 16:48:14 +0000
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
Subject: [PATCH net-next 5/5] net: ti: cpsw: remove guards against !BRIDGE_VLAN_INFO_BRENTRY
Date:   Wed, 16 Feb 2022 18:47:52 +0200
Message-Id: <20220216164752.2794456-6-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: ea36323a-c241-42c0-065b-08d9f16c1faf
X-MS-TrafficTypeDiagnostic: DB7PR04MB4091:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB4091961403C214F09D304E76E0359@DB7PR04MB4091.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qjE6LJhDKqVw6P+FzFWECufTnXidcuRVa5pL3sErEjOVeemVy2ucfQxpvD/AAL9AuNsim6Be9bhS0vMDSUSj+WAmbUOYz59WQrcuEukLpEfCd4aVF/lDxGVoNU2TbXVkZKfeLgQIvtikg8R4ysaGtouwoIZc/8SLCGqnH3BHKZm45xJAslwCdIBbAD6mHEpTKND/d0wiZA3+A4RMT8KMhQtMbnPSID4D5kIpXeDQAFhPe/z4a0Q+R9RrzpoCQSxnRG0CWZm/AUHR7J9whqxi+24RnmfFA9DUxwVr5kM+2qlomXqCx+EoxYBkBVxgylXRjnTys075y5nJD/bYlxMYuVYMeGwGDGOVGIado6AkO1Ey9UxRXFY4LR6MN3J5zyXdFWtgF383yjW6u/U+opmszwCxKA1rmC1P6DHEa6UUA7MFw+kdMXjcuhxtPw78zsVsclHwOZLxePZXyCgS/gNBWg0hEZpF2op9FBSUOKNznc0E/qFskWjGSVBFepvri7bLA7FRZvVXjxSWl4KnmBxxy++clSkGzFxkEqPjuj4FEZssLGbkq/u5q6H9JX0mWQSXUvomTELVPZ3sXIOkMNijn0UiPqOLg11dXwQiX+e0qxxty9smtzUGOG3CFkCKiPJrX8nINXZ2s20dO4rlUSx3XsQxjdSW6s5Y9Rf5e1mI7TmQ5m2xn07cSefPDvh+pluglmAW0zXRpTrQtdgNMtACow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(44832011)(6916009)(5660300002)(8676002)(52116002)(186003)(7416002)(36756003)(26005)(66476007)(6512007)(1076003)(86362001)(2616005)(8936002)(38350700002)(6666004)(83380400001)(316002)(38100700002)(2906002)(6486002)(66946007)(66556008)(508600001)(6506007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PsDT4RTqOUjiWBxD1qjpgkua2BStFtGsYvsape1Bo7qhoL5QqJJy3W4FR5JM?=
 =?us-ascii?Q?Nm6jpEzlLYZd+hrLUYCdoOtj615UeNIT9rcdlV5Qpie2M69uEfYkIsEjUSMF?=
 =?us-ascii?Q?KOmhX79AyZF5A9VFmwnDNFT9W5vkPfYolFWyeKZqPSP0iX114UAiHQa/9YtO?=
 =?us-ascii?Q?1KkApeovQ+HTxenXP1KDODX+U2axg6fAuVx/l6WEuKbIfNj0sVHMVAQh9yRC?=
 =?us-ascii?Q?unaLbO77VPAUZxJwuyOuxcJ2ZZdRa/FsWEAVVBgKRxpVRVNB9haAn95FzKOR?=
 =?us-ascii?Q?HNsq46n6ZVpQ17lYBnmgX1BwTI4mPcXBLmFbENPzI4/6BznL6bi3fQr++zgD?=
 =?us-ascii?Q?VUV2Xp6QkDdpFXZmbYT+wPYmYG1PaEbMoKo8omZKrl72X1qjWIKyNFx4rrlB?=
 =?us-ascii?Q?fGqDZDqmGtMzh/XQWCz33rg9739iv3QiOQiMddzJ+7t9VbL2RXgxCLL5T6Qc?=
 =?us-ascii?Q?6lQlFUCzLY/G5waXgEnOHY46jTyuWJ7T06fxoMvFXXIYNKYhoh8yDqZ2LFHr?=
 =?us-ascii?Q?PNGia9ekgk/qbwfFolLCMoZ7nlwX0Wo9Kq6CzLD23bsih1Fqd2/uXzBvY0lF?=
 =?us-ascii?Q?sT15rATQZW+XmS3cY1XWytCQR/0LxTalDhaLyoK3cFX6ZW+1MzDqOI3mb+N/?=
 =?us-ascii?Q?QyJTbvqytqhd5N1QKzhrW0AmBhKwUccFdgpKJsi2gxQ7BrolkpUHggGIA9Fb?=
 =?us-ascii?Q?SQz9NcbqUiHGl4vHfNwgk20mV2st4ejp0c6LXjEx70L30owNNfY1551MAkwP?=
 =?us-ascii?Q?sccL8ejtihKGNl1MlC2xSXzE1uw/+07oSG2RTv4ROvqE3lR4XeoArdG/w1Rw?=
 =?us-ascii?Q?kmiJD8RoBGvej+1X6njzWPb3Z64iQYFyPM+e4ikLN0yaVMmnntz6JmwrrpGX?=
 =?us-ascii?Q?nI5puBiQGfW08p4Hvcnr84HE6jCSVtloP+zsd9g0/vY3/GF1KRbWEnvNo+op?=
 =?us-ascii?Q?j4V2RWpDgtx3jGrqynQCuX6YnglbY73Rv0NvKVzI9Ta7HsNMkBvA71zqeDI4?=
 =?us-ascii?Q?GHm27Z43MVDtr/R5/IJTnAhv+VNngkWHzHuE0w8RrLuUk6oj7wrcFQE5W8/f?=
 =?us-ascii?Q?m6z775k8dQKqjZNJ7OHtcTHbBDH1QnshFqGVhluhiD9v0gcGDD8KKa3x+OkK?=
 =?us-ascii?Q?5BqA/6fIynimSrMr0bPTbBzPn8GSyI+0kPug/HCDGtRID76wZ+resaEAjwXU?=
 =?us-ascii?Q?MIKUeBXYfOuosBtxqaaXuuJGzmK20dt9rLrAwBRBwIUYlYlMoBDIVyluy4IW?=
 =?us-ascii?Q?m4sycb6tAIlQ9wMCdRhoHiP33nTzP4+84QoycQsebyDrY5qb2PzEtYHTm0Tm?=
 =?us-ascii?Q?JhlKGgwoEh9hCPDbUTU42H6xaEVB03R4ur66k8s9gN7WhHbFxQ3lxIR9AZMx?=
 =?us-ascii?Q?xathcOLuFmtYAx9s8CLF8caaRBuKMkc6NEvERqNceAkCCpg0NOPBxAxw3JCk?=
 =?us-ascii?Q?rT0sUjOySNKUCBXFLQ6S3Ae6QBSrahGRrZ0lXDLWtw6YtE/7IXjSDZpxRH5G?=
 =?us-ascii?Q?t8Rw9D2dbFxb1f07GTtd5gkUv7sMMroMSmyi97C1dfSW/GiWPNYbrqMa0yKe?=
 =?us-ascii?Q?EpkeWbZdg/5vDgEq82ACd8QoOXh/OPmvBS5HKn1N8JiRrAzL57BLLUoj0Xwy?=
 =?us-ascii?Q?TA9mQp3eYDd0fvaER5owo7g=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea36323a-c241-42c0-065b-08d9f16c1faf
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 16:48:14.1993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fkX5i/i7pjpZW9tslbqW2v8Y0sGFJggpNa6ZqJDsEAJjDWEiIV2qL8ehOqw0asroix9aoRvelbxB8GXOEmvDBA==
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
 drivers/net/ethernet/ti/cpsw_switchdev.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_switchdev.c b/drivers/net/ethernet/ti/cpsw_switchdev.c
index a7d97d429e06..ce85f7610273 100644
--- a/drivers/net/ethernet/ti/cpsw_switchdev.c
+++ b/drivers/net/ethernet/ti/cpsw_switchdev.c
@@ -252,15 +252,11 @@ static int cpsw_port_vlans_add(struct cpsw_priv *priv,
 {
 	bool untag = vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED;
 	struct net_device *orig_dev = vlan->obj.orig_dev;
-	bool cpu_port = netif_is_bridge_master(orig_dev);
 	bool pvid = vlan->flags & BRIDGE_VLAN_INFO_PVID;
 
 	dev_dbg(priv->dev, "VID add: %s: vid:%u flags:%X\n",
 		priv->ndev->name, vlan->vid, vlan->flags);
 
-	if (cpu_port && !(vlan->flags & BRIDGE_VLAN_INFO_BRENTRY))
-		return 0;
-
 	return cpsw_port_vlan_add(priv, untag, pvid, vlan->vid, orig_dev);
 }
 
-- 
2.25.1

