Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578D36E5F8D
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjDRLP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjDRLPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:15:25 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C897131;
        Tue, 18 Apr 2023 04:15:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDZbPMVD82F12xzVzqa8I80rv+MDfV5tsXEBsK3y6ETP/EWYpAvb9tcqFas6TIX1IiKhXOQL3CvDT7zv0eTyOvobzIj2REcOlLlDaGl9FNImbe7riCiZ7UooLWcUbptULWJc3OMtsXYjnjn/JZ2nfszSblEFmUkexqocYleDBD1SxOwpCQKNvP9Dcgigr14jLbRjKOJ3dXTyRDqUWdaU8RdzzoukxclqorlBVy+wNlGhwmTweUYRERb136be6Of5r6RCGjiv3ZieZhXnI30IssJam8Tw0kxp3Se1+PyyoK1dje52ql85r0qtQA50meM3DulOYf0B7s0KPuLBEIeVvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zT70HQvHEGA9i75ZWy4R/BZdgkENulL3EBYoUIpUZ2I=;
 b=XEMmXrPhlnzPxHqu5V10aHthfPNcS7kjURmHnplhnLiOrF1odJyXMK/6Kd94HfeXiGubuNdSwwRc6vMacdKiDqMEClTMfPUsD2pO4qB7XhP1iFW3ayuiBN0AgQZAs9Eagtws3ov5oJteE0tUEbFn8IfrnL1BbI2/K9ZLI7QR4KTQ14J58T6007oyhGzK3zm/QH8gTplCUzKe5U0MwY55j6ikxJIDw6hHkOa6yIEIb6dZdV24A50UX7p0SV4dNbQbsQdfbyQD0+GUrw31yQNPjF7ylNm7dOlBUnoaPF7LukmXqI1t2m9pEItOL50GuzCG6vciqi6jwdTJZkmnE/+PkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zT70HQvHEGA9i75ZWy4R/BZdgkENulL3EBYoUIpUZ2I=;
 b=nkadiEDDHJiMinm5wn6K6K2ms+wjaVyd2Qvc7fAMubG02yYjVXt/rosYdgJ1wNJDIdIV0TXsYZnlR7HF1CINhZf6QKg5+F0DgCIahF4pFHor8y9ZpYqvg0lDT33/H4PuHPqs/Ba9slKYjy/wAn/ntztyZ+bBALemqy7Mo3kzA1U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by AS8PR04MB8659.eurprd04.prod.outlook.com (2603:10a6:20b:42a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 11:15:20 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::55b1:d2dd:4327:912b%5]) with mapi id 15.20.6298.028; Tue, 18 Apr 2023
 11:15:20 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Petr Machata <petrm@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Aaron Conole <aconole@redhat.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 4/9] net: enetc: include MAC Merge / FP registers in register dump
Date:   Tue, 18 Apr 2023 14:14:54 +0300
Message-Id: <20230418111459.811553-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418111459.811553-1-vladimir.oltean@nxp.com>
References: <20230418111459.811553-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0152.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:98::19) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|AS8PR04MB8659:EE_
X-MS-Office365-Filtering-Correlation-Id: cb5c1b4b-edbe-4ec7-5469-08db3ffe32a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iR17Ikgoq6rfgEzSW78tCP6+37VdNNH3V2hzV7IY/dMpe19ZEsApoYTWZDZ50vZThYXJAg3ND8ElEDs+cENOsE6NBlRYTzFiyce9vea1L+d9w/aq3tEEyxe12UorglqxNNgX2yc4YhSDy1yGkxii7d50rTQa6iem+afIYV01QN8Eh/7zRt2x8R2WdXA25x/Elc3xR+Ihly/7EGLtzuHRWte5zii9pj27LqgzljDV/MJAtddy0F7l8wAQFU4j8KCXLlfK6XolrSUrW2BN48PNcKntJdDXRP6aS6+OLdSWzQ+MlIIoipm1ZFDe6hw8pe3P9XnQncausEcheo7SG5E4CX2zHyqLenv8qD1Hv/YvMZowIReXrfHwYKO8l0Rk4HK5EJYyh4DHV4MAWFpC36dxNYpeH48yHKkBxpuNAZtPi4oj3y9wYfrKEUIBmzQblkFtkV4pwNDXouw3JoM6frsqLm5VGS/q0A2Jj/eZvDo+yRXPQqfDB+AMtHLb/L3KlqQ40Yq/hcIYNw/QuG4Yp5xRp4OLfvGpAe2urfOPHg53M19Ehf/3sPYqQ704meKS99egd7kfdYYuLJ9jBcjx8yFIpzkaxmGQFUMwUkOXqY8MM99y/UsTVBXY2L7epiH38rxd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199021)(6666004)(6486002)(478600001)(86362001)(2616005)(36756003)(26005)(6512007)(1076003)(6506007)(186003)(38100700002)(38350700002)(52116002)(66556008)(66946007)(66476007)(316002)(2906002)(4326008)(6916009)(8936002)(5660300002)(8676002)(7416002)(44832011)(41300700001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+Vw+4De4qcxxduc8gJ7USblIhRZ8OXs2dCDRqG7kmO3aqps/PelCi9vSYN9E?=
 =?us-ascii?Q?XOIovjdB3TgSVL2EQsFjKuMVz1LTK4e7/jueCAh9/SbBM38tOiNGDYr60mOi?=
 =?us-ascii?Q?5v3qdP5WuE1rwhRfqpL4LtiZ0rOJaOszJugcGDPwIHHRJjsJ0RV/UPaXqugs?=
 =?us-ascii?Q?xIcBcUCrhK0YB8ej0HMYw5tpNgLB20MdlrOtjBGjGBKv1XW/FFtV1NXv5g40?=
 =?us-ascii?Q?x5JayiBpauwtBDvCF8K4gKB9x/PAwrDIpY0OFcu8K4ZwREJo4i7OI0cjof+P?=
 =?us-ascii?Q?Gs00vlGh8m/Dn5IIFepytQdvIaUbIBs7D7Ll+k8YdL1xf90OPzLT6G7JQKcG?=
 =?us-ascii?Q?O81jg7QINQsWSfqIbvWELdov/cikh4gLfG3HenX3K3rnC9svku/YPrv4mn5g?=
 =?us-ascii?Q?vH+pv9erVnUDWotGflQ4SLKDlofOVaRO0WMNZVOOBoyl5TFt1g08o103DqPW?=
 =?us-ascii?Q?DXHJ4E7yhNEvHrd8ELB9h8urrPgvNtZPP/lcmDs0Aw464pkHJ0Ch0sPs+Fsl?=
 =?us-ascii?Q?GQ7OHmu2EdiAVhXfwdkpNTnoze2E0S2YItObILFXsh4Er9LAI6c2QozhNN33?=
 =?us-ascii?Q?N6uWrRCDApIlUm/sv9V2+Ln/yW8H99fl4f9gVQhqygCSLFFoK24MXJt4swO1?=
 =?us-ascii?Q?4KDUNhwEAj4axoHPuXk5grjUnyn2GVz3j144CLENnahDu9dwqRPDaC0YMD0C?=
 =?us-ascii?Q?lORhOEji6zOoy0OKaWLfwlNn5OzG98eYpEmKFAv+glhRZvze584ZiSAu8qe6?=
 =?us-ascii?Q?H57oFXH7XqIOvlFTTQKeuI0EAtIu9qL67TkKky5uXBAjX3A6fa/kK7vKC+hM?=
 =?us-ascii?Q?uFBIh1N8Vl2km0VL/dVnFBQ45zb0wDSgU7wePUWAlikPoP/enoCPqPSLQeJ6?=
 =?us-ascii?Q?qpHhevPae94sWDGXbcdzNIIgqDqhP9wBhfSx/rVfJ5ABWPPFYQWL/lzG6vdt?=
 =?us-ascii?Q?/FrVDfAMYdo780bdlCF1PKaVC5+BNQuoTdAQA4dKCdBXjLwPoH3jR3h6/A1N?=
 =?us-ascii?Q?umhY+U0gshKbiHzV1ryFZBr4sbYhm59agRZC2Vz3rLzL5bWP2VzV3ZbapUPk?=
 =?us-ascii?Q?Jfq91T5RNMbbzIjaVZcGwl63iEkLoMKXN2a26gxxeNvPRoymRIPCdL76macx?=
 =?us-ascii?Q?f/uNTEArDN2JC+m0rxN92cyo66qoTWuL7V/yHl9d3Qsj5eFk8C/LsYgS4X46?=
 =?us-ascii?Q?gzDWB+ipQNuL+2MjtwcVQv01/U9gHjLlW3+VjA0JFnhTacSM+3a6pwyjTxcR?=
 =?us-ascii?Q?TIkUz9gAtDQs8juyVZnnkTk4E96ZeqBgrrKmi8O9HQ3iBmC5U8YFNVnuLwPp?=
 =?us-ascii?Q?OwdQpNgUHgiTgyLk7wjJ2uDNInqOWOM4/iaJw5Z0Ws9bPJXwBlv93ew80Yg2?=
 =?us-ascii?Q?dFig+LjpaL0+iGM6ukfIzhFjczRre0OSphNQXCMlqeZWvV9Utulwu/Laqt6d?=
 =?us-ascii?Q?CL3u7UTOJTN7/vPEcZs4F+IydSBQ88tsaPRVWxXsE51Lp/yBLU1sXWol7OLO?=
 =?us-ascii?Q?BI/R0HLPc5raFOMOK76qjoTDNYdwjd/S0ruXFuC9asWYovbOmDXK7DBQroxv?=
 =?us-ascii?Q?lTou58ojv6tfaKCBI87vpxzN95E08ieR6/Y9NYfV/HQ+QQ5g0JHNxNmx26qU?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb5c1b4b-edbe-4ec7-5469-08db3ffe32a9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 11:15:20.8751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eVeGsBjt1W4QSsIQ3+FKpe/zeJu3nDF47b+gk0r46UdiU8Y3vFI/jEkHE4DUK94ijy+WSmGgBkD/dilz4/i1JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8659
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These have been useful in debugging various problems related to frame
preemption, so make them available through ethtool --register-dump for
later too.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 .../ethernet/freescale/enetc/enetc_ethtool.c    | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 838a92131963..e993ed04ab57 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -32,6 +32,12 @@ static const u32 enetc_port_regs[] = {
 	ENETC_PM0_CMD_CFG, ENETC_PM0_MAXFRM, ENETC_PM0_IF_MODE
 };
 
+static const u32 enetc_port_mm_regs[] = {
+	ENETC_MMCSR, ENETC_PFPMR, ENETC_PTCFPR(0), ENETC_PTCFPR(1),
+	ENETC_PTCFPR(2), ENETC_PTCFPR(3), ENETC_PTCFPR(4), ENETC_PTCFPR(5),
+	ENETC_PTCFPR(6), ENETC_PTCFPR(7),
+};
+
 static int enetc_get_reglen(struct net_device *ndev)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
@@ -45,6 +51,9 @@ static int enetc_get_reglen(struct net_device *ndev)
 	if (hw->port)
 		len += ARRAY_SIZE(enetc_port_regs);
 
+	if (hw->port && !!(priv->si->hw_features & ENETC_SI_F_QBU))
+		len += ARRAY_SIZE(enetc_port_mm_regs);
+
 	len *= sizeof(u32) * 2; /* store 2 entries per reg: addr and value */
 
 	return len;
@@ -90,6 +99,14 @@ static void enetc_get_regs(struct net_device *ndev, struct ethtool_regs *regs,
 		*buf++ = addr;
 		*buf++ = enetc_rd(hw, addr);
 	}
+
+	if (priv->si->hw_features & ENETC_SI_F_QBU) {
+		for (i = 0; i < ARRAY_SIZE(enetc_port_mm_regs); i++) {
+			addr = ENETC_PORT_BASE + enetc_port_mm_regs[i];
+			*buf++ = addr;
+			*buf++ = enetc_rd(hw, addr);
+		}
+	}
 }
 
 static const struct {
-- 
2.34.1

